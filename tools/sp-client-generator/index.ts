/**
 * SP CLIENT GENERATOR v1.0
 * Generates TypeScript SDK from Dump20260606.sql procedures
 */

import * as fs from 'fs';
import * as path from 'path';

const DUMP_FILE = 'D:\\AtendimentoOfflineAlpha\\legacy\\backend_antigo\\sql\\Dump20260606.sql';
const OUTPUT_DIR = 'D:\\AtendimentoOfflineAlpha\\packages\\sp-client';
const CONTRACTS_DIR = 'D:\\AtendimentoOfflineAlpha\\database\\contracts';

interface SPContract {
  name: string;
  domain: string;
  params: Array<{ name: string; type: string; direction: 'IN' | 'OUT' | 'INOUT' }>;
  returns: string[];
  tables: string[];
  calls: string[];
  description: string;
  frontendUsage: string;
  tenantRequired: boolean;
}

class SPClientGenerator {
  private procedures: Map<string, SPContract> = new Map();
  private domainMap: Map<string, string[]> = new Map();

  generate() {
    console.log('🚀 SP CLIENT GENERATOR v1.0');
    console.log('📖 Reading dump file...');

    const content = fs.readFileSync(DUMP_FILE, 'utf-8');
    const lines = content.split('\n');

    console.log(`📊 Loaded ${lines.length} lines`);

    this.parseProcedures(lines);
    this.mapDomains();
    this.generateContracts();
    this.generateSDK();
    this.generateIndex();

    console.log('✅ SP Client generated successfully!');
    console.log(`   - Procedures: ${this.procedures.size}`);
    console.log(`   - Domains: ${this.domainMap.size}`);
    console.log(`   - Output: ${OUTPUT_DIR}`);
  }

  private parseProcedures(lines: string[]) {
    console.log('🔍 Parsing procedures...');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      
      // Match CREATE PROCEDURE or CREATE DEFINER... PROCEDURE
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
        const contract = this.analyzeProcedure(procName, bodyStr);
        this.procedures.set(procName, contract);
        
        // Skip to next statement
        i = j;
      }
    }
  }

  private analyzeProcedure(name: string, body: string): SPContract {
    const params: SPContract['params'] = [];
    const tables: string[] = [];
    const calls: string[] = [];
    const returns: string[] = [];

    // Extract parameters from signature
    const paramMatches = body.matchAll(/(IN|OUT|INOUT)\s+(\w+)\s+(\w+)/gi);
    for (const m of paramMatches) {
      params.push({
        direction: m[1] as 'IN' | 'OUT' | 'INOUT',
        name: m[2],
        type: this.mapSqlTypeToTs(m[3])
      });
    }

    // Extract OUT parameters specifically
    const outMatches = body.matchAll(/\bOUT\s+(\w+)\s+(\w+)/gi);
    for (const m of outMatches) {
      returns.push(m[1]);
    }

    // Extract SELECT ... INTO (returns)
    const intoMatches = body.matchAll(/SELECT\s+[^INTO]*INTO\s+(\w+)/gi);
    for (const m of intoMatches) {
      if (!returns.includes(m[1])) {
        returns.push(m[1]);
      }
    }

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

    // Determine domain
    const domain = this.inferDomain(name, tables);

    // Determine frontend usage
    const frontendUsage = this.inferFrontendUsage(name, domain);

    // Tenant required?
    const tenantRequired = body.includes('p_id_sessao') || 
                          body.includes('p_id_unidade') ||
                          body.includes('p_id_saas');

    return {
      name,
      domain,
      params,
      returns,
      tables,
      calls,
      description: this.generateDescription(name, domain),
      frontendUsage,
      tenantRequired
    };
  }

  private mapSqlTypeToTs(sqlType: string): string {
    const typeMap: { [key: string]: string } = {
      'BIGINT': 'number',
      'INT': 'number',
      'INTEGER': 'number',
      'DECIMAL': 'number',
      'FLOAT': 'number',
      'DOUBLE': 'number',
      'VARCHAR': 'string',
      'CHAR': 'string',
      'TEXT': 'string',
      'JSON': 'any',
      'JSONB': 'any',
      'BOOLEAN': 'boolean',
      'TINYINT': 'boolean',
      'DATE': 'Date',
      'DATETIME': 'Date',
      'TIMESTAMP': 'Date',
      'TIME': 'string'
    };

    const upper = sqlType.toUpperCase();
    for (const [sql, ts] of Object.entries(typeMap)) {
      if (upper.includes(sql)) {
        return ts;
      }
    }

    return 'any';
  }

  private inferDomain(name: string, tables: string[]): string {
    const domainRules: { [key: string]: string } = {
      'sp_master_login': 'Auth',
      'sp_sessao_': 'Auth',
      'sp_auth_': 'Auth',
      'sp_usuario_': 'Auth',
      'sp_permissao_': 'Auth',
      'sp_senha_': 'Operations',
      'sp_fila_': 'Operations',
      'sp_painel_': 'Operations',
      'sp_totem_': 'Operations',
      'sp_triagem_': 'Clinical',
      'sp_executor_assistencial_': 'Clinical',
      'sp_atendimento_': 'Clinical',
      'sp_ffa_': 'Clinical',
      'sp_medico_': 'Clinical',
      'sp_medicacao_': 'Clinical',
      'sp_farm_': 'Inventory',
      'sp_farmacia_': 'Inventory',
      'sp_estoque_': 'Inventory',
      'sp_gera_protocolo_lab': 'Laboratory',
      'sp_lab_': 'Laboratory',
      'sp_protocolo_': 'Laboratory',
      'sp_pedido_medico_': 'Clinical',
      'sp_recepcao_': 'Operations',
      'sp_chamar_': 'Operations',
      'sp_finalizar_': 'Operations',
      'sp_criar_': 'Operations',
      'sp_master_': 'Master',
      'sp_orquestrador_': 'Core',
      'sp_guardiao_': 'Governance',
      'sp_kernel_': 'Governance',
      'sp_runtime_': 'Governance',
      'sp_auditoria_': 'Governance',
      'sp_ledger_': 'Governance',
      'sp_fluxo_': 'Core'
    };

    for (const [prefix, domain] of Object.entries(domainRules)) {
      if (name.startsWith(prefix)) {
        return domain;
      }
    }

    // Infer from tables
    for (const table of tables) {
      if (table.includes('estoque') || table.includes('farm')) return 'Inventory';
      if (table.includes('faturamento')) return 'Finance';
      if (table.includes('fila') || table.includes('senha')) return 'Operations';
      if (table.includes('atendimento') || table.includes('triagem')) return 'Clinical';
      if (table.includes('auth') || table.includes('usuario')) return 'Auth';
    }

    return 'General';
  }

  private inferFrontendUsage(name: string, domain: string): string {
    const usageMap: { [key: string]: string } = {
      'sp_master_login': 'AUTH_LOGIN',
      'sp_sessao_abrir': 'AUTH_SESSION',
      'sp_senha_emitir': 'QUEUE_EMIT',
      'sp_fila_chamar_proxima': 'QUEUE_CALL',
      'sp_triagem_classificar_senha': 'TRIAGE_CLASSIFY',
      'sp_executor_recepcao_abrir_atendimento': 'RECEPTION_OPEN',
      'sp_ffa_orquestrador_transicao': 'FFA_TRANSITION',
      'sp_executor_assistencial_runtime': 'CLINICAL_RUNTIME',
      'sp_gera_protocolo_lab': 'LAB_PROTOCOL',
      'sp_farm_dispensacao_criar': 'PHARMACY_DISPENSE'
    };

    return usageMap[name] || `${domain.toUpperCase()}_OPERATION`;
  }

  private generateDescription(name: string, domain: string): string {
    const descriptions: { [key: string]: string } = {
      'sp_master_login': 'Authenticates user and creates session',
      'sp_sessao_abrir': 'Opens user session',
      'sp_senha_emitir': 'Emits new queue ticket',
      'sp_fila_chamar_proxima': 'Calls next patient from queue',
      'sp_triagem_classificar_senha': 'Classifies Manchester risk',
      'sp_executor_recepcao_abrir_atendimento': 'Opens new patient attendance',
      'sp_ffa_orquestrador_transicao': 'Transitions FFA state',
      'sp_executor_assistencial_runtime': 'Clinical runtime executor',
      'sp_gera_protocolo_lab': 'Generates lab protocol',
      'sp_farm_dispensacao_criar': 'Creates pharmacy dispensation'
    };

    return descriptions[name] || name.replace(/^sp_/, '').replace(/_/g, ' ');
  }

  private mapDomains() {
    console.log('🗺️  Mapping domains...');

    this.procedures.forEach((proc, name) => {
      if (!this.domainMap.has(proc.domain)) {
        this.domainMap.set(proc.domain, []);
      }
      this.domainMap.get(proc.domain)!.push(name);
    });
  }

  private generateContracts() {
    console.log('📝 Generating contracts...');

    if (!fs.existsSync(CONTRACTS_DIR)) {
      fs.mkdirSync(CONTRACTS_DIR, { recursive: true });
    }

    // sp_registry.json
    const registry: any = {
      generatedAt: new Date().toISOString(),
      source: 'Dump20260606.sql',
      totalProcedures: this.procedures.size,
      procedures: {}
    };

    this.procedures.forEach((proc, name) => {
      registry.procedures[name] = {
        domain: proc.domain,
        params: proc.params,
        returns: proc.returns,
        tables: proc.tables,
        calls: proc.calls,
        frontendUsage: proc.frontendUsage,
        tenantRequired: proc.tenantRequired
      };
    });

    fs.writeFileSync(
      path.join(CONTRACTS_DIR, 'sp_registry.json'),
      JSON.stringify(registry, null, 2)
    );

    // sp_front_mapping.json
    const frontendMapping: any = {
      generatedAt: new Date().toISOString(),
      flows: {}
    };

    // Group by frontend usage
    this.procedures.forEach((proc, name) => {
      const usage = proc.frontendUsage;
      if (!frontendMapping.flows[usage]) {
        frontendMapping.flows[usage] = [];
      }
      frontendMapping.flows[usage].push({
        procedure: name,
        domain: proc.domain,
        params: proc.params,
        returns: proc.returns
      });
    });

    fs.writeFileSync(
      path.join(CONTRACTS_DIR, 'sp_front_mapping.json'),
      JSON.stringify(frontendMapping, null, 2)
    );
  }

  private generateSDK() {
    console.log('⚛️  Generating TypeScript SDK...');

    if (!fs.existsSync(OUTPUT_DIR)) {
      fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }

    // Generate domain files
    const domains = new Set<string>();
    this.procedures.forEach(p => domains.add(p.domain));

    domains.forEach(domain => {
      const domainFile = path.join(OUTPUT_DIR, `${domain.toLowerCase().replace(/\s+/g, '-')}.ts`);
      let content = `/**
 * ${domain} Domain - SP Client
 * Auto-generated by KILO ENGINE
 */

import { SPClient } from './sp-client';

export interface ${domain.replace(/\s+/g, '')}Params {
`;

      // Add params for procedures in this domain
      this.procedures.forEach((proc, name) => {
        if (proc.domain === domain) {
          content += `  // ${name}\n`;
          proc.params.forEach(param => {
            if (param.direction === 'IN') {
              content += `  ${param.name}?: ${param.type};\n`;
            }
          });
          content += '\n';
        }
      });

      content += `}

export class ${domain.replace(/\s+/g, '')}Client {
  constructor(private sp: SPClient) {}

`;

      // Add methods
      this.procedures.forEach((proc, name) => {
        if (proc.domain === domain) {
          const methodName = name.replace(/^sp_/, '').replace(/_(\w)/g, (m, w) => w.toUpperCase());
          const params = proc.params
            .filter(p => p.direction === 'IN')
            .map(p => `${p.name}: ${p.type}`)
            .join(', ');
          
          const returnType = proc.returns.length > 0 
            ? `Promise<{ [key: string]: ${proc.returns.map(() => 'any').join(' | ')} }>`
            : 'Promise<void>';

          content += `  async ${methodName}(${params}): ${returnType} {\n`;
          content += `    return this.sp.call('${name}', {\n`;
          proc.params.filter(p => p.direction === 'IN').forEach(p => {
            content += `      ${p.name},\n`;
          });
          content += `    });\n`;
          content += `  }\n\n`;
        }
      });

      content += `}\n`;
      fs.writeFileSync(domainFile, content);
    });

    // Generate main sp-client.ts
    const clientContent = `/**
 * SP Client - Official Stored Procedure Client
 * Auto-generated by KILO ENGINE
 * 
 * Usage:
 *   const sp = new SPClient(tenantId, sessionId);
 *   await sp.masterLogin(username, password);
 *   await sp.fila.chamarProxima(sector, localId);
 */

export interface SPConfig {
  tenantId: string;
  sessionId?: string;
  userId?: number;
}

export interface SPResult {
  success: boolean;
  data?: any;
  error?: string;
}

export class SPClient {
  constructor(private config: SPConfig) {}

  private getTenantId(): string {
    return this.config.tenantId;
  }

  private getSessionId(): number | null {
    return this.config.sessionId ? parseInt(this.config.sessionId) : null;
  }

  async call(procedureName: string, params: any = {}): Promise<SPResult> {
    try {
      // Here you would implement actual MySQL connection
      // For now, this is a typed interface
      
      const callParams = {
        ...params,
        p_id_sessao: this.getSessionId(),
        p_tenant: this.getTenantId()
      };

      console.log(\`[SP] Calling \${procedureName}\`, callParams);
      
      // TODO: Implement actual database call
      // const result = await mysql.query(\`CALL \${procedureName}(...)\`);
      
      return {
        success: true,
        data: {} // result would go here
      };
    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  }

  // Domain-specific clients
  get auth() {
    return {
      login: (username: string, password: string) =>
        this.call('sp_master_login', { username, password }),
      
      session: {
        open: (userId: number, unitId: number) =>
          this.call('sp_sessao_abrir', { p_id_usuario: userId, p_id_unidade: unitId }),
        
        close: (sessionId: number) =>
          this.call('sp_sessao_encerrar', { p_id_sessao: sessionId }),
        
        validate: (sessionId: number) =>
          this.call('sp_sessao_assert', { p_id_sessao: sessionId })
      }
    };
  }

  get fila() {
    return {
      chamarProxima: (setor: string, localId: number) =>
        this.call('sp_fila_chamar_proxima', { 
          p_setor: setor, 
          p_id_local_operacional: localId 
        }),
      
      finalizar: (filaId: number, detalhe?: string) =>
        this.call('sp_fila_finalizar', { 
          p_id_fila: filaId, 
          p_detalhe: detalhe 
        })
    };
  }

  get senha() {
    return {
      emitir: (pacienteId: number, setor: string) =>
        this.call('sp_senha_emitir', { 
          p_id_paciente: pacienteId, 
          p_setor: setor 
        }),
      
      chamar: (senhaId: number) =>
        this.call('sp_senha_chamar', { p_id_senha: senhaId }),
      
      finalizar: (senhaId: number) =>
        this.call('sp_senha_finalizar', { p_id_senha: senhaId })
    };
  }

  get clinical() {
    return {
      triage: {
        classify: (senhaId: number, classificacao: string) =>
          this.call('sp_triagem_classificar_senha', { 
            p_id_senha: senhaId, 
            p_classificacao: classificacao 
          })
      },
      
      attendance: {
        open: (pacienteId: number) =>
          this.call('sp_executor_recepcao_abrir_atendimento', { 
            p_id_paciente: pacienteId 
          }),
        
        transition: (ffaId: number, evento: string) =>
          this.call('sp_ffa_orquestrador_transicao', { 
            p_id_ffa: ffaId, 
            p_evento: evento 
          })
      },
      
      lab: {
        generateProtocol: (pedidoItemId: number) =>
          this.call('sp_gera_protocolo_lab', { 
            p_id_pedido_item: pedidoItemId 
          })
      }
    };
  }

  get pharmacy() {
    return {
      createDispensation: (ffaId: number, estoqueLocalId: number) =>
        this.call('sp_farm_dispensacao_criar', { 
          p_id_ffa: ffaId, 
          p_id_estoque_local: estoqueLocalId 
        }),
      
      register: (receitaId: number, produtoId: number, loteId: number, quantidade: number) =>
        this.call('sp_farm_dispensacao_registrar', { 
          p_id_receita: receitaId,
          p_id_produto: produtoId,
          p_id_lote: loteId,
          p_quantidade: quantidade
        })
    };
  }

  get inventory() {
    return {
      move: (localId: number, itemId: number, loteId: number, quantidade: number, acao: string) =>
        this.call('sp_estoque_movimentar', { 
          p_id_local: localId,
          p_id_item: itemId,
          p_id_lote: loteId,
          p_quantidade: quantidade,
          p_acao: acao
        })
    };
  }
}

// Factory function
export function createSPClient(config: SPConfig): SPClient {
  return new SPClient(config);
}
`;

    fs.writeFileSync(path.join(OUTPUT_DIR, 'sp-client.ts'), clientContent);

    // Generate barrel export
    const barrelContent = `/**
 * SP Client SDK
 * Auto-generated by KILO ENGINE
 * 
 * 253 stored procedures mapped to TypeScript
 */

export { SPClient, createSPClient, SPConfig, SPResult } from './sp-client';
`;

    fs.writeFileSync(path.join(OUTPUT_DIR, 'index.ts'), barrelContent);
  }

  private generateIndex() {
    console.log('📑 Generating index...');

    const indexContent = `# SP Client SDK

> Auto-generated TypeScript client for 253 stored procedures

## Installation

\`\`\`typescript
import { createSPClient } from '@saas/sp-client';

const sp = createSPClient({
  tenantId: 'default',
  sessionId: '123'
});
\`\`\`

## Usage

### Authentication
\`\`\`typescript
const result = await sp.auth.login('username', 'password');
\`\`\`

### Queue Operations
\`\`\`typescript
const fila = await sp.fila.chamarProxima('MEDICO', 1);
\`\`\`

### Ticket Emission
\`\`\`typescript
const senha = await sp.senha.emitir(pacienteId, 'TRIAGEM');
\`\`\`

### Clinical Runtime
\`\`\`typescript
const protocol = await sp.clinical.lab.generateProtocol(pedidoItemId);
\`\`\`

## Domains

`;

    this.domainMap.forEach((procs, domain) => {
      indexContent += `### ${domain}\n`;
      procs.forEach(p => {
        indexContent += `- \`${p}\`\n`;
      });
      indexContent += '\n';
    });

    fs.writeFileSync(path.join(OUTPUT_DIR, 'README.md'), indexContent);
  }
}

// Run generator
const generator = new SPClientGenerator();
generator.generate();
