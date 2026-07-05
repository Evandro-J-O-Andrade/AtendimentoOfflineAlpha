/**
 * KILO ENGINE v8 - Legacy Database Analyzer
 * Analyzes Dump20260606.sql and generates:
 *   - Domain mapping (tables + procedures)
 *   - Relationship graph
 *   - Bounded contexts
 *   - Frontend-ready summary
 */

import * as fs from 'fs';
import * as path from 'path';

const DUMP_FILE = 'D:\\AtendimentoOfflineAlpha\\legacy\\backend_antigo\\sql\\Dump20260606.sql';
const OUTPUT_DIR = 'D:\\AtendimentoOfflineAlpha\\docs\\database\\kilo\\engine';

interface TableInfo {
  name: string;
  domain: string;
  columns: string[];
  primaryKey: string;
  foreignKeys: Array<{ column: string; references: string }>;
}

interface ProcedureInfo {
  name: string;
  type: 'SELECT' | 'INSERT' | 'UPDATE' | 'DELETE' | 'MIXED';
  tables: string[];
  calls: string[];
  hasOutput: boolean;
  description: string;
}

interface DomainMap {
  [domain: string]: {
    tables: string[];
    procedures: string[];
    description: string;
  };
}

class KiloEngine {
  private tables: Map<string, TableInfo> = new Map();
  private procedures: Map<string, ProcedureInfo> = new Map();
  private domainMap: DomainMap = {};

  analyze() {
    console.log('🚀 KILO ENGINE v8 - Starting analysis...');
    
    if (!fs.existsSync(DUMP_FILE)) {
      console.error(`❌ Dump file not found: ${DUMP_FILE}`);
      process.exit(1);
    }

    const content = fs.readFileSync(DUMP_FILE, 'utf-8');
    const lines = content.split('\n');

    console.log(`📊 Dump loaded: ${lines.length} lines`);

    this.parseTables(lines);
    this.parseProcedures(lines);
    this.mapDomains();
    this.detectRelationships();
    this.generateOutput();

    console.log('✅ Analysis complete!');
    console.log(`   - Tables: ${this.tables.size}`);
    console.log(`   - Procedures: ${this.procedures.size}`);
    console.log(`   - Domains: ${Object.keys(this.domainMap).length}`);
  }

  private parseTables(lines: string[]) {
    console.log('📦 Parsing tables...');
    
    let currentTable: TableInfo | null = null;
    let inCreate = false;

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();

      // CREATE TABLE
      const createMatch = line.match(/^CREATE\s+TABLE\s+`?(\w+)`?\s*\(/i);
      if (createMatch) {
        inCreate = true;
        currentTable = {
          name: createMatch[1],
          domain: this.inferDomain(createMatch[1]),
          columns: [],
          primaryKey: '',
          foreignKeys: []
        };
        continue;
      }

      // End of table definition
      if (inCreate && line.match(/^\)/)) {
        if (currentTable) {
          this.tables.set(currentTable.name, currentTable);
        }
        inCreate = false;
        currentTable = null;
        continue;
      }

      // Parse columns
      if (inCreate && currentTable) {
        // Primary key
        const pkMatch = line.match(/PRIMARY\s+KEY\s*\(`?(\w+)`?\)/i);
        if (pkMatch) {
          currentTable.primaryKey = pkMatch[1];
        }

        // Column
        const colMatch = line.match(/^`?(\w+)`?\s+\w+/);
        if (colMatch && !line.match(/^(KEY|CONSTRAINT|INDEX|UNIQUE|PRIMARY|FOREIGN)/i)) {
          currentTable.columns.push(colMatch[1]);
        }

        // Foreign key
        const fkMatch = line.match(/FOREIGN\s+KEY\s*\(`?(\w+)`?\)\s+REFERENCES\s+`?(\w+)`?/i);
        if (fkMatch) {
          currentTable.foreignKeys.push({
            column: fkMatch[1],
            references: fkMatch[2]
          });
        }
      }
    }
  }

  private parseProcedures(lines: string[]) {
    console.log('⚙️  Parsing procedures...');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      
      // CREATE PROCEDURE or CREATE DEFINER... PROCEDURE
      const procMatch = line.match(
        /^CREATE\s+(?:DEFINER=`[^`]+`@`[^`]+`\s+)?PROCEDURE\s+`?(\w+)`?\s*\(/i
      );
      
      if (procMatch) {
        const procName = procMatch[1];
        const body: string[] = [];
        let braceCount = 0;
        let j = i;

        // Extract body until END
        while (j < lines.length) {
          body.push(lines[j]);
          braceCount += (lines[j].match(/\(/g) || []).length;
          braceCount -= (lines[j].match(/\)/g) || []).length;
          
          if (braceCount <= 0 && lines[j].includes('END')) {
            break;
          }
          j++;
        }

        const bodyStr = body.join('\n');
        const procInfo = this.analyzeProcedureBody(procName, bodyStr);
        this.procedures.set(procName, procInfo);
        
        // Skip to next statement
        i = j;
      }
    }
  }

  private analyzeProcedureBody(name: string, body: string): ProcedureInfo {
    const tables: string[] = [];
    const calls: string[] = [];

    // Extract table references
    const fromMatches = body.matchAll(/FROM\s+`?(\w+)`?/gi);
    for (const m of fromMatches) {
      if (!tables.includes(m[1])) tables.push(m[1]);
    }

    const joinMatches = body.matchAll(/JOIN\s+`?(\w+)`?/gi);
    for (const m of joinMatches) {
      if (!tables.includes(m[1])) tables.push(m[1]);
    }

    const insertMatches = body.matchAll(/INSERT\s+INTO\s+`?(\w+)`?/gi);
    for (const m of insertMatches) {
      if (!tables.includes(m[1])) tables.push(m[1]);
    }

    const updateMatches = body.matchAll(/UPDATE\s+`?(\w+)`?/gi);
    for (const m of updateMatches) {
      if (!tables.includes(m[1])) tables.push(m[1]);
    }

    // Extract CALL references
    const callMatches = body.matchAll(/CALL\s+`?(\w+)`?/gi);
    for (const m of callMatches) {
      if (!calls.includes(m[1])) calls.push(m[1]);
    }

    // Determine type
    const hasSelect = body.match(/\bSELECT\b/i);
    const hasInsert = body.match(/\bINSERT\s+INTO\b/i);
    const hasUpdate = body.match(/\bUPDATE\b/i);
    const hasDelete = body.match(/\bDELETE\s+FROM\b/i);

    let type: ProcedureInfo['type'] = 'MIXED';
    if (hasSelect && !hasInsert && !hasUpdate && !hasDelete) type = 'SELECT';
    else if (hasInsert && !hasUpdate && !hasDelete) type = 'INSERT';
    else if (hasUpdate && !hasInsert && !hasDelete) type = 'UPDATE';
    else if (hasDelete) type = 'DELETE';

    const hasOutput = body.match(/\bOUT\s+\w+/i) !== null;

    // Auto-describe
    const description = this.describeProcedure(name, tables, calls);

    return { name, type, tables, calls, hasOutput, description };
  }

  private describeProcedure(name: string, tables: string[], calls: string[]): string {
    const descriptions: { [key: string]: string } = {
      'sp_chamar_senha': 'Chama próxima senha na fila',
      'sp_senha_emitir': 'Emite nova senha para paciente',
      'sp_senha_finalizar': 'Finaliza atendimento de senha',
      'sp_master_login': 'Autentica usuário e cria sessão',
      'sp_executor_manchester_runtime': 'Calcula risco dinâmico Manchester',
      'sp_fila_chamar_proxima': 'Chama próximo paciente da fila',
      'sp_fila_finalizar': 'Finaliza procedimento na fila',
      'sp_triagem_classificar_senha': 'Classifica risco na triagem',
      'sp_executor_recepcao_abrir_atendimento': 'Abre novo atendimento na recepção',
      'sp_ffa_orquestrador_transicao': 'Transiciona estado da FFA',
      'sp_ffa_gpat_gerar': 'Gera código GPAT',
      'sp_gera_protocolo_lab': 'Gera protocolo de laboratório',
      'sp_farm_dispensacao_criar': 'Cria dispensação de farmácia',
      'sp_farm_dispensacao_registrar': 'Registra baixa de estoque farmacêutico'
    };

    return descriptions[name] || `Operação: ${name.replace('sp_', '').replace(/_/g, ' ')}`;
  }

  private inferDomain(tableName: string): string {
    const domainMap: { [prefix: string]: string } = {
      'usuario_': 'Identity & Auth',
      'usuario': 'Identity & Auth',
      'auth_': 'Identity & Auth',
      'sessao_': 'Identity & Auth',
      'perfil': 'Identity & Auth',
      'permissao': 'Identity & Auth',
      'login_': 'Identity & Auth',
      'token': 'Identity & Auth',
      
      'paciente': 'Patient Core',
      'pessoa': 'Patient Core',
      'prontuario': 'Patient Core',
      
      'atendimento': 'Clinical Flow',
      'triagem': 'Clinical Flow',
      'evolucao': 'Clinical Flow',
      'prescricao': 'Clinical Flow',
      'anamnese': 'Clinical Flow',
      'diagnostico': 'Clinical Flow',
      'medicacao': 'Clinical Flow',
      'internacao': 'Clinical Flow',
      
      'fila_': 'Operations',
      'senha': 'Operations',
      'painel': 'Operations',
      'totem': 'Operations',
      'local_': 'Operations',
      'setor': 'Operations',
      
      'faturamento': 'Finance',
      'caixa': 'Finance',
      'venda': 'Finance',
      'pdv_': 'Finance',
      
      'estoque_': 'Inventory',
      'farm_': 'Inventory',
      'farmacia_': 'Inventory',
      'produto': 'Inventory',
      'lote': 'Inventory',
      
      'auditoria_': 'Governance',
      'log_': 'Governance',
      'audit_': 'Governance',
      'runtime_': 'Governance',
      'kernel_': 'Governance',
      'erro_': 'Governance',
      'schema_patch': 'Governance'
    };

    for (const [prefix, domain] of Object.entries(domainMap)) {
      if (tableName.startsWith(prefix)) {
        return domain;
      }
    }

    return 'General';
  }

  private mapDomains() {
    console.log('🗺️  Mapping domains...');

    // Initialize domains
    const domains = [
      'Identity & Auth',
      'Patient Core',
      'Clinical Flow',
      'Operations',
      'Finance',
      'Inventory',
      'Governance',
      'General'
    ];

    domains.forEach(d => {
      this.domainMap[d] = { tables: [], procedures: [], description: '' };
    });

    // Map tables to domains
    this.tables.forEach((table, name) => {
      const domain = table.domain;
      this.domainMap[domain].tables.push(name);
    });

    // Map procedures to domains (based on tables they touch)
    this.procedures.forEach((proc, name) => {
      const procDomains = new Set<string>();
      
      proc.tables.forEach(tableName => {
        const table = this.tables.get(tableName);
        if (table) {
          procDomains.add(table.domain);
        }
      });

      // If procedure touches multiple domains, assign to primary
      const primaryDomain = Array.from(procDomains)[0] || 'General';
      this.domainMap[primaryDomain].procedures.push(name);
    });
  }

  private detectRelationships() {
    console.log('🔗 Detecting relationships...');

    const relationships: Array<{ from: string; to: string; type: string }> = [];

    this.tables.forEach((table, tableName) => {
      table.foreignKeys.forEach(fk => {
        relationships.push({
          from: tableName,
          to: fk.references,
          type: 'foreign_key',
          column: fk.column
        });
      });
    });

    // Store relationships
    this.domainMap['__relationships__'] = {
      tables: relationships.map(r => `${r.from} → ${r.to}`),
      procedures: [],
      description: 'Table relationships detected'
    };
  }

  private generateOutput() {
    console.log('📤 Generating output...');

    if (!fs.existsSync(OUTPUT_DIR)) {
      fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }

    // 1. Domain map
    const domainMapContent = this.generateDomainMap();
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'kilo-domain-map.json'),
      JSON.stringify(domainMapContent, null, 2)
    );

    // 2. Tables by domain
    const tablesByDomain = this.generateTablesByDomain();
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'kilo-tables-by-domain.json'),
      JSON.stringify(tablesByDomain, null, 2)
    );

    // 3. Procedures catalog
    const proceduresCatalog = this.generateProceduresCatalog();
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'kilo-procedures-catalog.json'),
      JSON.stringify(proceduresCatalog, null, 2)
    );

    // 4. Frontend summary (human-readable)
    const frontendSummary = this.generateFrontendSummary();
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'kilo-frontend-summary.md'),
      frontendSummary
    );

    // 5. Relationship graph (simple text)
    const relationshipGraph = this.generateRelationshipGraph();
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'kilo-relationships.txt'),
      relationshipGraph
    );
  }

  private generateDomainMap(): any {
    const map: any = {};
    
    Object.entries(this.domainMap).forEach(([domain, data]) => {
      if (domain.startsWith('__')) return;
      
      map[domain] = {
        tables: data.tables,
        procedures: data.procedures,
        tableCount: data.tables.length,
        procedureCount: data.procedures.length
      };
    });

    return {
      generatedAt: new Date().toISOString(),
      source: 'Dump20260606.sql',
      totalTables: this.tables.size,
      totalProcedures: this.procedures.size,
      domains: map
    };
  }

  private generateTablesByDomain(): any {
    const result: any = {};

    this.tables.forEach((table, name) => {
      if (!result[table.domain]) {
        result[table.domain] = [];
      }
      result[table.domain].push({
        name,
        columns: table.columns.length,
        primaryKey: table.primaryKey,
        foreignKeys: table.foreignKeys.map(fk => ({
          column: fk.column,
          references: fk.references
        }))
      });
    });

    return result;
  }

  private generateProceduresCatalog(): any {
    const catalog: any = {};

    this.procedures.forEach((proc, name) => {
      catalog[name] = {
        type: proc.type,
        tables: proc.tables,
        calls: proc.calls,
        hasOutput: proc.hasOutput,
        description: proc.description,
        frontendReady: proc.hasOutput || proc.type === 'SELECT'
      };
    });

    return catalog;
  }

  private generateFrontendSummary(): string {
    let md = `# KILO ENGINE - Frontend Summary\n\n`;
    md += `> Generated: ${new Date().toISOString()}\n`;
    md += `> Source: Dump20260606.sql (478 tables)\n\n`;

    md += `## 📊 Overview\n\n`;
    md += `- **Total Tables**: ${this.tables.size}\n`;
    md += `- **Total Procedures**: ${this.procedures.size}\n`;
    md += `- **Domains**: ${Object.keys(this.domainMap).filter(k => !k.startsWith('__')).length}\n\n`;

    md += `## 🎯 Frontend-Ready Procedures\n\n`;
    md += `Procedures that RETURN data to frontend:\n\n`;

    this.procedures.forEach((proc, name) => {
      if (proc.hasOutput || proc.type === 'SELECT') {
        md += `### ${name}\n`;
        md += `- **Type**: ${proc.type}\n`;
        md += `- **Tables**: ${proc.tables.join(', ')}\n`;
        md += `- **Calls**: ${proc.calls.join(', ')}\n`;
        md += `- **Output**: ${proc.hasOutput ? 'Yes (OUT params)' : 'Yes (SELECT)'}\n`;
        md += `- **Use case**: ${proc.description}\n\n`;
      }
    });

    md += `## 🔑 Key Procedures for MVP\n\n`;
    md += `These are the CRITICAL procedures for the MVP:\n\n`;

    const criticalProcs = [
      'sp_master_login',
      'sp_sessao_abrir',
      'sp_auth_contexto_get',
      'sp_senha_emitir',
      'sp_fila_chamar_proxima',
      'sp_triagem_classificar_senha',
      'sp_executor_recepcao_abrir_atendimento',
      'sp_ffa_orquestrador_transicao',
      'sp_executor_assistencial_runtime',
      'sp_gera_protocolo_lab'
    ];

    criticalProcs.forEach(procName => {
      const proc = this.procedures.get(procName);
      if (proc) {
        md += `- ❗ **${procName}**: ${proc.description}\n`;
        md += `  - Tables: ${proc.tables.join(', ')}\n`;
        md += `  - Calls: ${proc.calls.length > 0 ? proc.calls.join(', ') : 'None'}\n\n`;
      }
    });

    md += `## 📁 Domain Structure\n\n`;
    Object.entries(this.domainMap).forEach(([domain, data]) => {
      if (domain.startsWith('__')) return;
      md += `### ${domain}\n`;
      md += `- Tables: ${data.tables.length}\n`;
      md += `- Procedures: ${data.procedures.length}\n`;
      md += `- Key tables: ${data.tables.slice(0, 5).join(', ')}${data.tables.length > 5 ? '...' : ''}\n\n`;
    });

    return md;
  }

  private generateRelationshipGraph(): string {
    let graph = `# KILO ENGINE - Relationship Graph\n\n`;
    
    this.tables.forEach((table, tableName) => {
      if (table.foreignKeys.length > 0) {
        graph += `${tableName}:\n`;
        table.foreignKeys.forEach(fk => {
          graph += `  └─ ${fk.column} → ${fk.references}\n`;
        });
        graph += `\n`;
      }
    });

    return graph;
  }
}

// Run engine
const engine = new KiloEngine();
engine.analyze();
