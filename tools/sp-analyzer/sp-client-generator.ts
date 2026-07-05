/**
 * SP CLIENT GENERATOR
 * 
 * Gera SDK TypeScript oficial para as 253 stored procedures.
 * Saída: packages/sp-client/
 * 
 * Uso:
 *   npx ts-node tools/sp-analyzer/sp-client-generator.ts
 */

import * as fs from 'fs';
import * as path from 'path';

const DUMP_FILE = 'D:\\AtendimentoOfflineAlpha\\legacy\\backend_antigo\\sql\\Dump20260606.sql';
const OUTPUT_DIR = 'D:\\AtendimentoOfflineAlpha\\saas-platform\\packages\\sp-client\\src';
const CONTRACTS_DIR = 'D:\\AtendimentoOfflineAlpha\\saas-platform\\database\\contracts';

interface SPDefinition {
  name: string;
  params: Array<{ name: string; type: string; direction: 'IN' | 'OUT' | 'INOUT' }>;
  returns: string[];
  tables: string[];
  calls: string[];
  description: string;
  category: string;
}

class SPClientGenerator {
  private procedures: Map<string, SPDefinition> = new Map();
  private categoryMap: Map<string, string> = new Map();

  generate() {
    console.log('🔧 SP CLIENT GENERATOR - Starting...');
    
    if (!fs.existsSync(DUMP_FILE)) {
      console.error(`❌ Dump not found: ${DUMP_FILE}`);
      process.exit(1);
    }

    const content = fs.readFileSync(DUMP_FILE, 'utf-8');
    const lines = content.split('\n');

    this.categorizeProcedures(lines);
    this.parseProcedures(lines);
    this.generateClient();
    this.generateTypes();
    this.generateContracts();
    this.generateIndex();

    console.log('✅ SP Client generated!');
    console.log(`   - Procedures: ${this.procedures.size}`);
    console.log(`   - Categories: ${new Set(Array.from(this.categoryMap.values())).size}`);
  }

  private categorizeProcedures(lines: string[]) {
    const categories: { [prefix: string]: string } = {
      'sp_auth_': 'auth',
      'sp_sessao_': 'auth',
      'sp_usuario_': 'auth',
      'sp_permissao_': 'auth',
      'sp_login': 'auth',
      'sp_senha_': 'operations',
      'sp_fila_': 'operations',
      'sp_painel_': 'operations',
      'sp_totem_': 'operations',
      'sp_chamar_': 'operations',
      'sp_finalizar_': 'operations',
      'sp_executor_manchester': 'operations',
      'sp_executor_fila': 'operations',
      'sp_executor_recepcao': 'operations',
      'sp_executor_assistencial': 'clinical',
      'sp_executor_estoque': 'inventory',
      'sp_executor_faturamento': 'finance',
      'sp_triagem_': 'clinical',
      'sp_atendimento_': 'clinical',
      'sp_medico_': 'clinical',
      'sp_medicacao_': 'clinical',
      'sp_operacao_': 'clinical',
      'sp_recepcao_': 'clinical',
      'sp_gatekeeper': 'clinical',
      'sp_orquestrador': 'clinical',
      'sp_oraculo': 'clinical',
      'sp_ffa_': 'clinical',
      'sp_farm_': 'inventory',
      'sp_farmacia_': 'inventory',
      'sp_estoque_': 'inventory',
      'sp_fluxo_estoque': 'inventory',
      'sp_conciliador_': 'finance',
      'sp_faturamento_': 'finance',
      'sp_caixa': 'finance',
      'sp_pdv_': 'finance',
      'sp_venda': 'finance',
      'sp_ledger_': 'governance',
      'sp_auditoria_': 'governance',
      'sp_auditar_': 'governance',
      'sp_registrar_': 'governance',
      'sp_runtime_': 'governance',
      'sp_kernel_': 'governance',
      'sp_guardiao_': 'governance',
      'sp_checkpoint_': 'governance',
      'sp_invariant': 'governance',
      'sp_sync_': 'governance',
      'sp_raim_': 'governance',
      'sp_codigo_': 'protocol',
      'sp_protocolo_': 'protocol',
      'sp_gera_protocolo': 'protocol',
      'sp_lab_': 'protocol',
      'sp_laboratorio_': 'protocol',
      'sp_procedimento_': 'protocol',
      'sp_pedido_': 'protocol',
      'sp_gpat_': 'protocol',
      'sp_master_': 'master',
      'sp_seed_': 'master',
      'sp_patch_': 'master',
      'sp_fix_': 'master',
      'sp_backfill': 'master',
      'sp_recreate': 'master',
      'sp_admin_': 'master',
      'sp_worker_': 'worker',
      'sp_dispatcher': 'worker',
      'sp_retry_': 'worker',
      'sp_motor_': 'worker'
    };

    lines.forEach(line => {
      const procMatch = line.match(/^CREATE\s+DEFINER=`[^`]+`@`[^`]+`\s+PROCEDURE\s+`(\w+)`/i);
      if (procMatch) {
        const name = procMatch[1];
        let category = 'general';
        
        for (const [prefix, cat] of Object.entries(categories)) {
          if (name.startsWith(prefix)) {
            category = cat;
            break;
          }
        }
        
        this.categoryMap.set(name, category);
      }
    });
  }

  private parseProcedures(lines: string[]) {
    console.log('⚙️  Parsing procedures...');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      
      const procMatch = line.match(
        /^CREATE\s+DEFINER=`[^`]+`@`[^`]+`\s+PROCEDURE\s+`(\w+)`\s*\(/i
      );
      
      if (procMatch) {
        const procName = procMatch[1];
        const body: string[] = [];
        let braceCount = 0;
        let j = i;

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
        const def = this.analyzeProcedure(procName, bodyStr);
        this.procedures.set(procName, def);
        i = j;
      }
    }
  }

  private analyzeProcedure(name: string, body: string): SPDefinition {
    const params: SPDefinition['params'] = [];
    const tables: string[] = [];
    const calls: string[] = [];
    const returns: string[] = [];

    // Extract parameters from signature
    const paramMatches = body.matchAll(/(?:IN|OUT|INOUT)\s+(\w+)\s+(\w+(?:\([^)]*\))?)/gi);
    for (const m of paramMatches) {
      params.push({
        name: m[1],
        type: this.normalizeType(m[2]),
        direction: m[0].startsWith('INOUT') ? 'INOUT' : m[0].startsWith('OUT') ? 'OUT' : 'IN'
      });
    }

    // Extract tables
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

    // Extract CALLS
    const callMatches = body.matchAll(/CALL\s+`?(\w+)`?/gi);
    for (const m of callMatches) {
      if (!calls.includes(m[1])) calls.push(m[1]);
    }

    // Determine what it returns
    if (body.match(/\bSELECT\b/i)) {
      returns.push('SELECT');
    }
    if (params.some(p => p.direction === 'OUT')) {
      returns.push('OUTPUT');
    }

    const category = this.categoryMap.get(name) || 'general';
    const description = this.describeProcedure(name, tables);

    return {
      name,
      params,
      returns,
      tables,
      calls,
      description,
      category
    };
  }

  private normalizeType(sqlType: string): string {
    const typeMap: { [key: string]: string } = {
      'bigint': 'number',
      'int': 'number',
      'integer': 'number',
      'tinyint': 'number',
      'smallint': 'number',
      'mediumint': 'number',
      'varchar': 'string',
      'char': 'string',
      'text': 'string',
      'longtext': 'string',
      'mediumtext': 'string',
      'decimal': 'number',
      'numeric': 'number',
      'float': 'number',
      'double': 'number',
      'date': 'string',
      'datetime': 'string',
      'timestamp': 'string',
      'time': 'string',
      'json': 'any',
      'boolean': 'boolean',
      'bool': 'boolean'
    };

    const baseType = sqlType.toLowerCase().split('(')[0].trim();
    return typeMap[baseType] || 'any';
  }

  private describeProcedure(name: string, tables: string[]): string {
    const descriptions: { [key: string]: string } = {
      'sp_master_login': 'Autentica usuário e cria sessão',
      'sp_sessao_abrir': 'Abrir sessão de usuário',
      'sp_auth_contexto_get': 'Obter contexto de autenticação',
      'sp_senha_emitir': 'Emitir nova senha',
      'sp_fila_chamar_proxima': 'Chamar próximo da fila',
      'sp_triagem_classificar_senha': 'Classificar risco na triagem',
      'sp_executor_recepcao_abrir_atendimento': 'Abrir atendimento na recepção',
      'sp_ffa_orquestrador_transicao': 'Transicionar estado da FFA',
      'sp_executor_assistencial_runtime': 'Executar fluxo assistencial',
      'sp_gera_protocolo_lab': 'Gerar protocolo de laboratório'
    };

    if (descriptions[name]) return descriptions[name];

    return `${name.replace('sp_', '').replace(/_/g, ' ')} - afeta: ${tables.slice(0, 3).join(', ')}${tables.length > 3 ? '...' : ''}`;
  }

  private generateClient() {
    console.log('📦 Generating SP Client...');

    if (!fs.existsSync(OUTPUT_DIR)) {
      fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }

    // Main client file
    let clientCode = `/**
 * SP CLIENT - Official Stored Procedure SDK
 * Auto-generated by Kilo Engine v8
 * 
 * DO NOT EDIT - Generated from Dump20260606.sql
 */

export interface SPClientConfig {
  tenantId: string;
  sessionId?: string;
  userId?: number;
  profileId?: number;
  systemId?: number;
}

export interface SPResult<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  sqlState?: string;
  errno?: number;
}

export interface SPContext {
  tenantId: string;
  sessionId: number | null;
  userId: number | null;
  profileId: number | null;
  systemId: number | null;
}

class SPClient {
  private config: SPClientConfig;
  private context: SPContext;

  constructor(config: SPClientConfig) {
    this.config = config;
    this.context = {
      tenantId: config.tenantId,
      sessionId: config.sessionId || null,
      userId: config.userId || null,
      profileId: config.profileId || null,
      systemId: config.systemId || null
    };
  }

  getContext(): SPContext {
    return { ...this.context };
  }

  updateContext(partial: Partial<SPContext>): void {
    this.context = { ...this.context, ...partial };
  }

  async call<T = any>(procedureName: string, params: any[] = []): Promise<SPResult<T>> {
    // Implementation will be platform-specific
    // This is the interface contract
    throw new Error('SPClient.call() must be implemented by platform adapter');
  }
}

// Category-specific namespaces
export const auth = {
  login: () => ({ name: 'sp_master_login', params: ['p_usuario', 'p_senha', 'p_id_unidade', 'p_id_local_operacional'] }),
  validateSession: () => ({ name: 'sp_sessao_assert', params: ['p_id_sessao_usuario'] }),
  getContext: () => ({ name: 'sp_auth_contexto_get', params: [] }),
  setContext: () => ({ name: 'sp_auth_contexto_set', params: ['p_contexto_json'] })
};

export const fila = {
  chamarProxima: () => ({ name: 'sp_fila_chamar_proxima', params: ['p_id_sessao_usuario', 'p_setor', 'p_id_local_operacional'] }),
  finalizar: () => ({ name: 'sp_fila_finalizar', params: ['p_id_sessao_usuario', 'p_id_fila', 'p_detalhe'] }),
  tipoPorLocal: () => ({ name: 'sp_fila_tipo_por_local', params: ['p_id_sessao_usuario', 'p_id_local_operacional'] })
};

export const senha = {
  emitir: () => ({ name: 'sp_senha_emitir', params: ['p_id_sessao_usuario', 'p_id_paciente', 'p_id_setor'] }),
  chamar: () => ({ name: 'sp_senha_chamar', params: ['p_id_sessao_usuario', 'p_id_senha'] }),
  finalizar: () => ({ name: 'sp_finalizar_senha', params: ['p_id_sessao_usuario', 'p_id_senha'] }),
  transicionar: () => ({ name: 'sp_senha_transicionar_status', params: ['p_id_sessao_usuario', 'p_id_senha', 'p_novo_status'] })
};

export const clinical = {
  abrirAtendimento: () => ({ name: 'sp_executor_recepcao_abrir_atendimento', params: ['p_id_sessao', 'p_acao', 'p_id_referencia', 'p_payload'] }),
  transicionarFFA: () => ({ name: 'sp_ffa_orquestrador_transicao', params: ['p_id_ffa', 'p_estado_atual', 'p_evento', 'p_id_usuario', 'p_id_perfil', 'p_id_sistema', 'p_contexto', 'p_id_sessao_usuario'] }),
  triagemClassificar: () => ({ name: 'sp_triagem_classificar_senha', params: ['p_id_sessao_usuario', 'p_id_senha', 'p_classificacao'] }),
  atendimentoIniciar: () => ({ name: 'sp_executor_assistencial_atendimento_iniciar', params: ['p_id_sessao', 'p_id_ffa'] }),
  atendimentoFinalizar: () => ({ name: 'sp_executor_assistencial_atendimento_finalizar', params: ['p_id_sessao', 'p_id_ffa', 'p_desfecho'] })
};

export const inventory = {
  movimentar: () => ({ name: 'sp_estoque_movimentar', params: ['p_id_unidade', 'p_id_local', 'p_contexto', 'p_id_item', 'p_id_lote', 'p_quantidade', 'p_acao', 'p_id_referencia', 'p_id_sessao'] }),
  fluxoEstoque: () => ({ name: 'sp_fluxo_estoque', params: ['p_id_unidade', 'p_id_local', 'p_contexto', 'p_id_item', 'p_id_lote', 'p_quantidade', 'p_acao', 'p_id_referencia', 'p_id_sessao'] }),
  farmaciaDispensar: () => ({ name: 'sp_farmacia_dispensar_registrar', params: ['p_id_sessao_usuario', 'p_id_unidade', 'p_id_paciente', 'p_id_produto', 'p_id_lote', 'p_quantidade', 'p_observacao'] })
};

export const protocol = {
  gerarLab: () => ({ name: 'sp_gera_protocolo_lab', params: ['p_id_sessao_usuario', 'p_id_pedido_item', 'p_sistema_externo', 'p_codigo_externo'] }),
  emitir: () => ({ name: 'sp_protocolo_emitir', params: ['p_id_sessao_usuario', 'p_tipo', 'p_id_referencia'] }),
  geraGPAT: () => ({ name: 'sp_ffa_gpat_gerar', params: ['p_id_sessao_usuario', 'p_id_ffa', 'p_prefixo_5'] })
};

export const governance = {
  registrarEvento: () => ({ name: 'sp_auditoria_evento_registrar', params: ['p_id_sessao_usuario', 'p_evento', 'p_entidade', 'p_id_entidade'] }),
  registrarErro: () => ({ name: 'sp_auditar_erro_sql', params: ['p_id_sessao_usuario', 'p_procedure', 'p_mensagem'] }),
  ledEvento: () => ({ name: 'sp_ledger_evento_log', params: ['p_uuid', 'p_id_usuario', 'p_id_perfil', 'p_evento', 'p_id_ffa', 'p_id_entidade', 'p_payload_json', 'p_status', 'p_mensagem'] })
};

export const master = {
  adminGerenciarUsuarios: () => ({ name: 'sp_master_admin_gerenciar_usuarios', params: ['p_id_sessao', 'p_acao', 'p_id_usuario', 'p_dados'] }),
  seedAdminRoot: () => ({ name: 'sp_seed_admin_root_runtime', params: [] }),
  patchPermissao: () => ({ name: 'sp_patch_permissao', params: [] })
};

export const worker = {
  dispatcher: () => ({ name: 'sp_dispatcher_kernel', params: ['p_comando', 'p_payload', 'p_id_sessao'] }),
  retrySemantico: () => ({ name: 'sp_retry_semantico_worker', params: [] }),
  atendimento: () => ({ name: 'sp_worker_atendimento', params: ['p_comando', 'p_payload'] })
};

export const sp = {
  auth,
  fila,
  senha,
  clinical,
  inventory,
  protocol,
  governance,
  master,
  worker
};

export default SPClient;

`;

    fs.writeFileSync(path.join(OUTPUT_DIR, 'index.ts'), clientCode);
  }

  private generateTypes() {
    console.log('📝 Generating TypeScript types...');

    let typesCode = `/**
 * SP CLIENT TYPES
 * Auto-generated from Dump20260606.sql
 */

export interface SPParameter {
  name: string;
  type: string;
  direction: 'IN' | 'OUT' | 'INOUT';
}

export interface SPDefinition {
  name: string;
  params: SPParameter[];
  returns: string[];
  tables: string[];
  calls: string[];
  description: string;
  category: string;
  hasOutput?: boolean;
}

export interface SPResult<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  sqlState?: string;
  errno?: number;
}

export interface SPContext {
  tenantId: string;
  sessionId: number | null;
  userId: number | null;
  profileId: number | null;
  systemId: number | null;
}

export interface SPClientConfig {
  tenantId: string;
  sessionId?: number;
  userId?: number;
  profileId?: number;
  systemId?: number;
}

`;

    // Generate category enums
    typesCode += `export enum SPCategory {\n`;
    const categories = new Set(Array.from(this.categoryMap.values()));
    categories.forEach(cat => {
      typesCode += `  ${cat.toUpperCase().replace(/\s+/g, '_')} = '${cat}',\n`;
    });
    typesCode += `}\n\n`;

    // Generate procedure registry
    typesCode += `export const SP_REGISTRY: Record<string, SPDefinition> = {\n`;
    
    this.procedures.forEach((proc, name) => {
      typesCode += `  '${name}': {\n`;
      typesCode += `    name: '${name}',\n`;
      typesCode += `    params: ${JSON.stringify(proc.params)},\n`;
      typesCode += `    returns: ${JSON.stringify(proc.returns)},\n`;
      typesCode += `    tables: ${JSON.stringify(proc.tables)},\n`;
      typesCode += `    calls: ${JSON.stringify(proc.calls)},\n`;
      typesCode += `    description: '${proc.description}',\n`;
      typesCode += `    category: '${proc.category}'\n`;
      typesCode += `  },\n`;
    });
    
    typesCode += `};\n`;

    fs.writeFileSync(path.join(OUTPUT_DIR, 'types.ts'), typesCode);
  }

  private generateIndex() {
    console.log('📄 Generating index exports...');

    const packageJson = {
      name: '@saas-platform/sp-client',
      version: '1.0.0',
      main: './src/index.ts',
      types: './src/index.ts',
      dependencies: {},
      devDependencies: {
        typescript: '^5.0.0'
      }
    };

    const tsconfig = {
      compilerOptions: {
        target: 'ES2020',
        module: 'ESNext',
        moduleResolution: 'bundler',
        strict: true,
        esModuleInterop: true,
        skipLibCheck: true,
        forceConsistentCasingInFileNames: true,
        declaration: true,
        outDir: './dist'
      },
      include: ['src/**/*'],
      exclude: ['node_modules', 'dist']
    };

    fs.writeFileSync(path.join(OUTPUT_DIR, '..', 'package.json'), JSON.stringify(packageJson, null, 2));
    fs.writeFileSync(path.join(OUTPUT_DIR, '..', 'tsconfig.json'), JSON.stringify(tsconfig, null, 2));
    fs.writeFileSync(path.join(OUTPUT_DIR, 'index.ts'), `export { SPClient, sp } from './index';\nexport * from './types';\n`);
  }

  private generateContracts() {
    console.log('📋 Generating SP contracts...');

    if (!fs.existsSync(CONTRACTS_DIR)) {
      fs.mkdirSync(CONTRACTS_DIR, { recursive: true });
    }

    const registry: any = {};
    this.procedures.forEach((proc, name) => {
      registry[name] = {
        type: this.inferContractType(name, proc.category),
        returns: proc.returns,
        writes: proc.tables.filter(t => {
          const body = this.getProcedureBody(name);
          return body && body.match(new RegExp(`INSERT\\s+INTO\\s+${t}|UPDATE\\s+${t}|DELETE\\s+FROM\\s+${t}`, 'i'));
        }),
        reads: proc.tables.filter(t => {
          const body = this.getProcedureBody(name);
          return body && body.match(new RegExp(`FROM\\s+${t}|JOIN\\s+${t}`, 'i'));
        }),
        tables: proc.tables,
        calls: proc.calls,
        frontend_usage: this.inferFrontendUsage(name),
        tenant_required: this.isTenantRequired(name),
        params: proc.params
      };
    });

    fs.writeFileSync(
      path.join(CONTRACTS_DIR, 'sp_io_contracts.json'),
      JSON.stringify({
        generatedAt: new Date().toISOString(),
        source: 'Dump20260606.sql',
        totalProcedures: this.procedures.size,
        contracts: registry
      }, null, 2)
    );

    fs.writeFileSync(
      path.join(CONTRACTS_DIR, 'sp_registry.json'),
      JSON.stringify({
        generatedAt: new Date().toISOString(),
        total: this.procedures.size,
        categories: Array.from(new Set(Array.from(this.categoryMap.values()))),
        procedures: Array.from(this.procedures.keys())
      }, null, 2)
    );

    const frontendMapping: any = {};
    this.procedures.forEach((proc, name) => {
      if (proc.returns.length > 0) {
        frontendMapping[name] = {
          category: proc.category,
          returns: proc.returns,
          params: proc.params.map(p => ({ name: p.name, type: p.type })),
          description: proc.description,
          usage: this.inferFrontendUsage(name)
        };
      }
    });

    fs.writeFileSync(
      path.join(CONTRACTS_DIR, 'sp_front_mapping.json'),
      JSON.stringify({
        generatedAt: new Date().toISOString(),
        total: Object.keys(frontendMapping).length,
        mappings: frontendMapping
      }, null, 2)
    );
  }

  private getProcedureBody(name: string): string | null {
    // Simplified - in real implementation would store body
    return null;
  }

  private inferContractType(name: string, category: string): string {
    if (name.includes('login') || name.includes('auth')) return 'AUTH';
    if (name.includes('senha') || name.includes('fila')) return 'OPERATIONS';
    if (name.includes('atendimento') || name.includes('triagem') || name.includes('ffa')) return 'CLINICAL';
    if (name.includes('estoque') || name.includes('farm')) return 'INVENTORY';
    if (name.includes('faturamento') || name.includes('pdv')) return 'FINANCE';
    if (name.includes('audit') || name.includes('runtime')) return 'GOVERNANCE';
    return category.toUpperCase();
  }

  private inferFrontendUsage(name: string): string {
    const usageMap: { [key: string]: string } = {
      'sp_master_login': 'LOGIN_FLOW',
      'sp_senha_emitir': 'ENTRY_FLOW',
      'sp_fila_chamar_proxima': 'QUEUE_FLOW',
      'sp_triagem_classificar_senha': 'TRIAGE_FLOW',
      'sp_executor_recepcao_abrir_atendimento': 'RECEPTION_FLOW',
      'sp_ffa_orquestrador_transicao': 'CLINICAL_FLOW',
      'sp_gera_protocolo_lab': 'LAB_FLOW',
      'sp_farm_dispensacao_criar': 'PHARMACY_FLOW'
    };
    return usageMap[name] || 'GENERIC';
  }

  private isTenantRequired(name: string): boolean {
    const noTenant = ['sp_seed_', 'sp_patch_', 'sp_fix_', 'sp_assert_', 'sp_raise'];
    return !noTenant.some(prefix => name.startsWith(prefix));
  }
}

// Run generator
const generator = new SPClientGenerator();
generator.generate();
