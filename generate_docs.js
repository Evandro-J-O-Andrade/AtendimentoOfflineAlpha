const fs = require('fs');
const path = require('path');

const tablesDir = 'D:\\AtendimentoOfflineAlpha\\docs\\database\\tables_raw';
const outputDir = 'D:\\AtendimentoOfflineAlpha\\docs\\database\\tables';

const tables = [
  'estoque_saldo_central','estoque_saldo_master','evento_ffa','evento_geral','evento_limpeza','eventos_fluxo',
  'evolucao_enfermagem','evolucao_medica','evolucao_multidisciplinar','exame','exame_fisico','exame_historico',
  'exame_pedido','exame_pedido_item','farm_atendimento_externo','farm_convenio_autorizacao','farm_dispensacao',
  'farm_dispensacao_item','farm_operacao','farm_receita_controlada','farmacia_atendimento_externo_dispensacao',
  'farmacia_atendimento_externo_item','farmacia_dispensacao_log','farmacia_externo_evento','farmaco_auditoria',
  'farmaco_auditoria_bloqueio','farmaco_movimentacao','farmaco_unidade','faturamento_codigo','faturamento_conta',
  'faturamento_conta_item','faturamento_conta_paciente','faturamento_conta_seq','faturamento_convenio',
  'faturamento_convenios','faturamento_evento','faturamento_insumo','faturamento_item','faturamento_producao',
  'faturamento_producao_sus','faturamento_regras_validacao','faturamento_sigtap','faturamento_sus_config',
  'ffa','ffa_demandas_externas','ffa_diagnostico','ffa_estado','ffa_estoque_conciliacao','ffa_evolucao',
  'ffa_extra','ffa_historico_status'
];

function parseCreateTable(block) {
  const lines = block.split('\n');
  const columns = [];
  let primaryKey = [];
  let uniqueKeys = [];
  let foreignKeys = [];
  let indexes = [];
  let checks = [];
  
  let inColumns = false;
  
  for (let line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith('CREATE TABLE')) { inColumns = true; continue; }
    if (inColumns && trimmed === ')') { inColumns = false; continue; }
    if (inColumns && trimmed.startsWith('`')) {
      const nameMatch = trimmed.match(/^`([^`]+)`\s+(.+),?$/);
      if (nameMatch) {
        const colType = nameMatch[2].replace(/\s+NOT NULL/g, '').replace(/\s+NULL\b/g, '').replace(/\s+DEFAULT\s+[^,]+/, '').replace(/\s+GENERATED ALWAYS AS \([^)]+\) STORED/, '').trim().replace(/,$/, '');
        const nullable = trimmed.includes('NOT NULL') ? 'NO' : 'YES';
        let defaultValue = '—';
        if (trimmed.includes('GENERATED ALWAYS')) defaultValue = 'GENERATED';
        else if (trimmed.includes('DEFAULT')) {
          const defMatch = trimmed.match(/DEFAULT\s+([^,\s]+(?:\s+[^,\s]+)*)/);
          if (defMatch) defaultValue = defMatch[1].trim();
        }
        columns.push({ name: nameMatch[1], type: colType, nullable, default: defaultValue, raw: trimmed });
      }
    }
    if (trimmed.startsWith('PRIMARY KEY')) {
      const keys = trimmed.match(/\(([^)]+)\)/);
      if (keys) primaryKey = keys[1].split(',').map(k => k.trim().replace(/`/g, ''));
    }
    if (trimmed.startsWith('UNIQUE KEY')) {
      const nameMatch = trimmed.match(/UNIQUE KEY\s+`([^`]+)`\s*\(([^)]+)\)/);
      if (nameMatch) uniqueKeys.push({ name: nameMatch[1], columns: nameMatch[2].split(',').map(c => c.trim().replace(/`/g, '')) });
    }
    if (trimmed.startsWith('KEY')) {
      const keyMatch = trimmed.match(/KEY\s+`([^`]+)`\s*\(([^)]+)\)/);
      if (keyMatch) indexes.push({ name: keyMatch[1], columns: keyMatch[2].split(',').map(c => c.trim().replace(/`/g, '')) });
    }
    if (trimmed.startsWith('CONSTRAINT')) {
      const fkMatch = trimmed.match(/CONSTRAINT\s+`([^`]+)`\s+FOREIGN KEY\s*\(([^)]+)\)\s*REFERENCES\s+`([^`]+)`\s*\(([^)]+)\)(.*)/);
      if (fkMatch) foreignKeys.push({ name: fkMatch[1], column: fkMatch[2].replace(/`/g, ''), refTable: fkMatch[3], refColumn: fkMatch[4].replace(/`/g, ''), raw: fkMatch[5].trim() });
    }
    if (trimmed.startsWith('CHECK')) {
      const chkMatch = trimmed.match(/CHECK\s*\((.+)\)/);
      if (chkMatch) checks.push(chkMatch[1]);
    }
  }
  
  return { columns, primaryKey, uniqueKeys, foreignKeys, indexes, checks };
}

function getDesc(colName) {
  const n = colName.toLowerCase();
  if (n.includes('_em') && !n.includes('baixa')) return 'Data e hora do registro';
  if (n.includes('data_receita')) return 'Data da receita médica';
  if (n.includes('data_producao')) return 'Data de produção do serviço';
  if (n.includes('data_emissao')) return 'Data de emissão do documento';
  if (n.includes('data_fechamento')) return 'Data de fechamento da conta';
  if (n.includes('data_mov')) return 'Data da movimentação';
  if (n.includes('data_mudanca')) return 'Data da mudança de status';
  if (n.includes('data_hora')) return 'Data e hora do evento';
  if (n === 'payload') return 'Dados complementares no formato JSON';
  if (n === 'contexto_fluxo') return 'Contexto do fluxo de atendimento em formato JSON';
  if (n === 'contexto') return 'Contexto do atendimento em formato JSON';
  if (n === 'metadata') return 'Metadados adicionais em formato JSON';
  if (n === 'dados_antes') return 'Snapshot dos dados antes da alteração em formato JSON';
  if (n === 'dados_depois') return 'Snapshot dos dados após a alteração em formato JSON';
  if (n === 'xml_gerado') return 'Conteúdo XML da guia de convênio gerada';
  if (n === 'hash_integridade') return 'Hash SHA-256 para verificação de integridade';
  if (n === 'observacao') return 'Observação ou detalhe textual';
  if (n === 'descricao') return 'Descrição textual do registro';
  if (n === 'nome_fantasia') return 'Nome fantasia do convênio';
  if (n === 'paciente_nome') return 'Nome completo do paciente';
  if (n === 'nome_paciente') return 'Nome completo do paciente';
  if (n === 'nome_medico') return 'Nome do médico responsável';
  if (n === 'paciente_documento') return 'Documento de identificação do paciente';
  if (n.includes('cns_paciente')) return 'Cartão Nacional de Saúde do paciente';
  if (n.includes('registro_ans')) return 'Registro ANS do convênio';
  if (n.includes('cnes_')) return 'Código CNES da unidade';
  if (n.includes('numero_')) return 'Número sequencial do documento';
  if (n.includes('codigo_interno')) return 'Código interno sequencial do pedido';
  if (n === 'codigo') return 'Código de identificação do registro';
  if (n.includes('_codigo') && !n.includes('id_codigo')) return 'Código de identificação';
  if (n === 'valor_unitario') return 'Valor unitário do item';
  if (n === 'valor_total') return 'Valor total calculado';
  if (n === 'valor_venda') return 'Valor de venda do item';
  if (n === 'valor_custo') return 'Valor de custo do item';
  if (n === 'total_bruto') return 'Valor total bruto da conta';
  if (n === 'total_desconto') return 'Valor total de descontos';
  if (n === 'total_liquido') return 'Valor total líquido da conta';
  if (n === 'desconto') return 'Valor de desconto aplicado à linha';
  if (n === 'total_linha') return 'Valor total da linha do item';
  if (n.includes('_valor_')) return 'Valor monetário';
  if (n.includes('_sh')) return 'Valor do serviço hospitalar';
  if (n.includes('_sa')) return 'Valor do serviço ambulatorial';
  if (n.includes('qtd_fisica')) return 'Quantidade física registrada em estoque';
  if (n.includes('qtd_reservada')) return 'Quantidade reservada para atendimento';
  if (n.includes('qtd_projetada')) return 'Quantidade projetada (física - reservada)';
  if (n === 'quantidade') return 'Quantidade numérica do item';
  if (n.includes('quantidade_total')) return 'Quantidade total prescrita';
  if (n.includes('dias_tratamento')) return 'Quantidade de dias de tratamento';
  if (n.includes('dias')) return 'Quantidade de dias';
  if (n.includes('status')) return 'Status atual conforme enumeração definida';
  if (n.includes('status_guia')) return 'Status da guia de convênio';
  if (n.includes('status_faturamento')) return 'Status do faturamento';
  if (n.includes('status_remessa')) return 'Status da remessa SUS';
  if (n.includes('status_conta') && !n.includes('status_conta_paciente')) return 'Status da conta';
  if (n.includes('status_conta_paciente')) return 'Status da conta do paciente';
  if (n.includes('status_origem')) return 'Status clínico anterior ao evento';
  if (n.includes('status_destino')) return 'Status clínico após o evento';
  if (n.includes('cbo_profissional')) return 'CBO do profissional responsável pela produção';
  if (n.includes('complexidade')) return 'Nível de complexidade do procedimento';
  if (n.includes('material')) return 'Material necessário para o exame';
  if (n.includes('posologia')) return 'Posologia e forma de uso do medicamento';
  if (n.includes('perfil_usuario')) return 'Perfil do usuário que executou o evento';
  if (n.includes('ip')) return 'Endereço IP de origem da requisição';
  if (n.includes('user_agent')) return 'User-Agent do navegador ou aplicativo';
  if (n.includes('senha') && !n.includes('usuario') && !n.startsWith('id_')) return 'Senha de acesso criptografada';
  if (n.includes('token')) return 'Token de autenticação ou acesso';
  if (n.includes('estado_clinico')) return 'Estado clínico atual do atendimento';
  if (n.includes('tipo_evento')) return 'Tipo de evento';
  if (n.includes('tipo_operacao')) return 'Tipo de operação de farmácia';
  if (n.includes('tipo_ambiente')) return 'Ambiente de saúde da operação';
  if (n.includes('tipo_extra')) return 'Tipo de item extra associado';
  if (n.includes('tipo_demanda')) return 'Tipo de demanda externa';
  if (n.includes('numero_receita')) return 'Número da receita médica';
  if (n.includes('numero_guia')) return 'Número da guia de convênio';
  if (n.includes('numero_guia_principal')) return 'Número da guia principal';
  if (n.includes('numero_conselho')) return 'Número do conselho profissional';
  if (n.includes('uf_conselho')) return 'UF do conselho profissional';
  if (n.includes('conselho_medico')) return 'Conselho profissional do médico';
  if (n === 'origem') return 'Origem do registro (sistema ou operação que gerou o evento)';
  if (n === 'origem') return 'Origem do registro (sistema ou operação que gerou o evento)';
  if (n === 'usuario') return 'Usuário responsável pela ação';
  if (n === 'perfil_usuario') return 'Perfil do usuário que executou o evento';
  if (n === 'local') return 'Local físico onde o evento ocorreu';
  if (n === 'usuario') return 'Usuário responsável pela ação';
  if (n.includes('id_atendimento')) return 'Identificador do atendimento';
  if (n.includes('id_internacao')) return 'Identificador da internação';
  if (n.includes('id_senha')) return 'Identificador da senha de atendimento';
  if (n.includes('id_ffa')) return 'Identificador do fluxo de atendimento ambulatorial';
  if (n.includes('id_lote')) return 'Identificador do lote de medicamento';
  if (n.includes('lote')) return 'Identificador do lote de medicamento';
  if (n.includes('id_local_estoque')) return 'Identificador do local de estoque';
  if (n.includes('id_local')) return 'Identificador do local';
  if (n.includes('_local')) return 'Identificador do local associado';
  if (n.includes('local')) return 'Local físico onde o evento ocorreu';
  if (n.includes('id_operacao')) return 'Identificador da operação de farmácia';
  if (n.includes('id_pedido')) return 'Identificador do pedido';
  if (n.includes('id_exame')) return 'Identificador do exame';
  if (n.includes('id_codigo')) return 'Identificador do código de faturamento';
  if (n.includes('id_atendimento_ext')) return 'Identificador do atendimento externo';
  if (n.includes('id_gpat')) return 'Identificador do GPAT';
  if (n.includes('id_movimento_item')) return 'Identificador do movimento de item';
  if (n.includes('id_ffa_item')) return 'Identificador do item do FFA';
  if (n.includes('id_diagnostico')) return 'Identificador do diagnóstico';
  if (n.includes('id_estado')) return 'Identificador do estado';
  if (n.includes('id_conciliacao')) return 'Identificador da conciliação';
  if (n.includes('id_movimentacao')) return 'Identificador da movimentação';
  if (n.includes('id_farmaco')) return 'Identificador do medicamento';
  if (n.includes('id_cidade')) return 'Identificador da cidade/localidade';
  if (n.includes('id_entidade')) return 'Identificador da entidade multitenant';
  if (n.includes('id_saldo')) return 'Identificador do saldo de estoque';
  if (n.includes('id_item')) return 'Identificador do item';
  if (n.includes('id_receita')) return 'Identificador da receita médica';
  if (n.includes('id_autorizacao')) return 'Identificador da autorização de convênio';
  if (n.includes('id_dispensacao')) return 'Identificador da dispensação';
  if (n.includes('id_atendimento')) return 'Identificador do atendimento';
  if (n.includes('id_produto')) return 'Identificador do produto/medicamento';
  if (n.includes('id_prescricao_item')) return 'Identificador do item de prescrição';
  if (n.includes('id_sessao_usuario')) return 'Identificador da sessão do usuário';
  if (n.includes('id_unidade')) return 'Identificador da unidade de saúde';
  if (n.includes('primeira_baixa') || n.includes('segunda_baixa')) return 'Usuário responsável pela baixa';
  if (n.includes('baixa_final')) return 'Usuário responsável pela baixa final';
  if (n.includes('registrado_por')) return 'Usuário que registrou o evento';
  if (n.includes('atualizado_por')) return 'Usuário responsável pela última atualização';
  if (n.includes('criado_por')) return 'Usuário responsável pela criação';
  if (n.includes('ultima_atualizacao')) return 'Data e hora da última atualização do saldo';
  if (n.includes('unidade_medida')) return 'Unidade de medida do item';
  if (n.includes('competencia')) return 'Competência (mês/ano) do faturamento';
  if (n === 'fechado_por') return 'Usuário responsável pelo fechamento do registro';
  if (n === 'cancelado_por') return 'Usuário responsável pelo cancelamento do registro';
  if (n.includes('confirmado')) return 'Flag indicando se o diagnóstico foi confirmado';
  if (n.includes('validade')) return 'Data de validade do lote';
  if (n.includes('ativo')) return 'Flag indicando se o registro está ativo';
  if (n.includes('exige_dupla_baixa')) return 'Indica se a operação exige dupla checagem';
  if (n === 'versao_ledger') return 'Versão do ledger de eventos do FFA';
  if (n === 'motivo') return 'Motivo do bloqueio ou ação';
  if (n === 'area') return 'Área profissional da evolução multidisciplinar';
  if (n === 'modulo') return 'Módulo do sistema onde a evolução foi registrada';
  if (n.startsWith('id_') && n.includes('_')) {
    const parts = n.split('_').slice(1);
    return 'Identificador único de ' + parts.join(' ');
  }
  return 'Campo do registro';
}

function getFlow(tableName) {
  const t = tableName.toLowerCase();
  if (t.includes('estoque_saldo')) {
    return [
      `- Controle centralizado de saldo de medicamentos e insumos.`,
      `- Consultado em operações de dispensação, faturamento e conciliação.`,
      `- Atualizado por movimentações de entrada (compras, transferências) e saída (atendimento a pacientes).`,
      `- Publicado para ambientes master quando aplicável para sincronização.`
    ].join('\n');
  }
  if (t === 'farm_dispensacao') {
    return [
      `- Recebe receitas controladas para dispensação.`,
      `- Permite dupla baixa com dois usuários conferentes.`,
      `- Ao ser finalizada, gera itens de dispensação e atualiza saldos de estoque.`,
      `- Integra com auditoria e log de dispensação.`
    ].join('\n');
  }
  if (t.includes('farmacia_atendimento_externo_dispensacao')) {
    return [
      `- Executa a baixa final do medicamento no estoque.`,
      `- Acionada após confirmação de segunda baixa na receita controlada.`,
      `- Gera log de dispensação e atualiza saldos de estoque.`,
      `- Vinculada diretamente a atendimentos externos e itens de farmácia.`
    ].join('\n');
  }
  if (t === 'farm_receita_controlada') {
    return [
      `- Receita médica controlada para dispensação de medicamentos.`,
      `- Vinculada a operação de farmácia (HIS, PA, UPA, etc.).`,
      `- Pode ser criada internamente ou originada de atendimento externo.`,
      `- Segue fluxo de recebimento, primeira baixa e segunda baixa até finalização.`
    ].join('\n');
  }
  if (t === 'faturamento_conta') {
    return [
      `- Conta de faturamento principal associada a FFA ou internação.`,
      `- Gerada automaticamente a partir de eventos assistenciais fechados.`,
      `- Permite revisão, auditoria, fechamento e cancelamento.`,
      `- Agrega itens faturáveis consolidados e alimenta relatórios e exportações SUS/TISS.`
    ].join('\n');
  }
  if (t === 'faturamento_item') {
    return [
      `- Itens faturáveis gerados a partir de procedimentos, exames, medicações e materiais consumidos.`,
      `- Consolidados em contas de faturamento vinculadas a FFA ou internação.`,
      `- Permitem descontos, alteração de status e correção contábil.`,
      `- Alimentam exportações SUS/TISS e relatórios de produção.`
    ].join('\n');
  }
  if (t === 'evento_ffa') {
    return [
      `- Registra transições de estado e ações no fluxo de atendimento ambulatorial.`,
      `- Consumido por painéis de totem, recepção, triagem, médico e procedimentos.`,
      `- Alimenta a máquina de estados do FFA e os displays de chamada.`,
      `- Utilizado para auditoria de fluxo e estatísticas de atendimento.`
    ].join('\n');
  }
  if (t === 'ffa') {
    return [
      `- Representa o atendimento do paciente na unidade desde a abertura até o fechamento.`,
      `- Transit por estados clínicos (triagem, atendimento, exames, alta, etc.).`,
      `- Centraliza contexto, eventos, evoluções, diagnósticos e itens adicionais.`,
      `- É o hub central do módulo ambulatorial, vinculando todas as outras tabelas FFA.`
    ].join('\n');
  }
  if (t === 'ffa_evolucao') {
    return [
      `- Registra anotações textuais (evoluções) sobre o atendimento.`,
      `- Associada diretamente ao FFA para histórico completo.`,
      `- Permite integridade via hash e rastreabilidade por IP/user-agent.`,
      `- Consultada em relatórios de evolução e prontuário eletrônico.`
    ].join('\n');
  }
  if (t === 'farmaco_movimentacao') {
    return [
      `- Registra todas as entradas e saídas de estoque de medicamentos.`,
      `- Origem: compras, transferências entre unidades, atendimento a pacientes, ajustes e PDV.`,
      `- Alimenta os saldos centrais e master de estoque.`,
      `- Consumida por relatórios de movimentação e conciliação contábil.`
    ].join('\n');
  }
  return [
    `- Tabela componente do módulo de atendimento e faturamento hospitalar.`,
    `- Utilizada para persistência e consulta de dados específicos do domínio.`,
    `- Associada a operações de cadastro, evolução e faturamento.`,
    `- Integrada com fluxos de auditoria e sincronização.`
  ].join('\n');
}

tables.forEach(tableName => {
  const jsonPath = path.join(tablesDir, `${tableName}.json`);
  if (!fs.existsSync(jsonPath)) { console.log(`SKIP: ${tableName}.json`); return; }
  const json = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
  const parsed = parseCreateTable(json.block);
  
  let md = `# ${tableName}\n\n`;
  md += `Objetivo: ${tableName.includes('estoque') ? 'Gerenciamento de saldo e quantidades de estoque' : tableName.includes('evento') ? 'Registro de eventos e fluxos do sistema' : tableName.includes('evolucao') ? 'Registro de evoluções clínicas por profissional' : tableName.includes('exame') ? 'Gestão de exames médicos, pedidos e laudos' : tableName.includes('farm') && tableName.includes('dispensacao') ? 'Controle de dispensação de medicamentos' : tableName.includes('farm') && tableName.includes('receita') ? 'Controle de receitas médicas e prescrições' : tableName.includes('farmaco') || tableName.includes('farmacia') ? 'Gestão de medicamentos, movimentações e auditoria' : tableName.includes('faturamento') ? 'Gestão de contas, itens e regras de faturamento' : tableName.includes('ffa') ? 'Fluxo de Atendimento Ambulatorial (FFA)' : 'Tabela do sistema'}\n\n`;
  md += `Descrição: `;
  const descs = {
    estoque_saldo_central: 'Armazena o saldo físico, reservado e projetado de itens de estoque por unidade, local e lote no ambiente central. Utilizada para controle de disponibilidade e conciliação de estoque.',
    estoque_saldo_master: 'Armazena o saldo físico, reservado e projetado de itens de estoque por unidade, local e lote no ambiente master. Utilizada para controle de disponibilidade e conciliação de estoque em ambiente master.',
    evento_ffa: 'Ledger de eventos específicos do fluxo de atendimento ambulatorial (FFA), registrando mudanças de estado, chamadas, triagens e ações do sistema e usuários.',
    evento_geral: 'Ledger canônico que registra todos os eventos gerais do sistema HIS/PA, permitindo auditoria e rastreabilidade de ações por domínio, tipo e referência.',
    evento_limpeza: 'Registra eventos operacionais da equipe de limpeza, como rotinas de limpeza, reposição de higiene e intercorrências por setor.',
    eventos_fluxo: 'Registra eventos genéricos de fluxo de atendimento, associados a entidades e usuários, permitindo rastreamento de ações no sistema.',
    evolucao_enfermagem: 'Registra evoluções de enfermagem durante internações, com descrição textual, identificação do profissional e data/hora.',
    evolucao_medica: 'Registra evoluções médicas durante internações, com descrição textual, identificação do profissional e data/hora.',
    evolucao_multidisciplinar: 'Registra evoluções de profissionais de diferentes áreas (multidisciplinar) vinculadas a atendimentos, preservando contexto do usuário e timestamp.',
    exame: 'Catálogo mestra de exames com código, descrição e tipo (LAB, RX, OUTROS), servindo como referência para pedidos de exame.',
    exame_fisico: 'Registra exames físicos realizados durante atendimentos, com descrição textual, usuário responsável e timestamp.',
    exame_historico: 'Registra o histórico de eventos de pedidos de exame (solicitação, coleta, recebimento, laudo, cancelamento) com usuário e timestamp.',
    exame_pedido: 'Pedido de exame com herança completa de atendimento e FFA, permitindo rastreamento de status, solicitante e vínculos assistenciais.',
    exame_pedido_item: 'Itens individuais de um pedido de exame, contendo código de procedimento, nome do exame, material, valores de custo e venda.',
    farm_atendimento_externo: 'Registra atendimentos de farmácia para pacientes externos, com dados do médico prescritor, receita, status e vínculo com atendimento.',
    farm_convenio_autorizacao: 'Gerencia autorizações de convênio para dispensação de medicamentos, controlando status (pendente, aprovado, negado) e vínculo com dispensação.',
    farm_dispensacao: 'Dispensação de receitas controladas, com suporte a dupla baixa (segundo conferente) e status de fluxo de dispensação.',
    farm_dispensacao_item: 'Itens individuais dispensados em uma dispensação, com vínculo a lote de estoque, quantidade e valores unitário.',
    farm_operacao: 'Cadastro de tipos de operação de farmácia por ambiente (HIS, PA, UPA, UBS, HOSPITAL, RUA), definindo regras de negócio e exigência de dupla baixa.',
    farm_receita_controlada: 'Receita médica controlada para dispensação de medicamentos, vinculada a operação de farmácia e podendo ser de origem interna ou externa.',
    farmacia_atendimento_externo_dispensacao: 'Dispensação efetiva de medicamentos para atendimento externo, ligando itens de farmácia a atendimentos, com confirmação de entrega e cancelamento.',
    farmacia_atendimento_externo_item: 'Itens de prescrição para atendimento externo de farmácia, com posologia, quantidade, status e vínculo a lote e local de estoque.',
    farmacia_atendimento_externo_item: 'Itens de prescrição para atendimento externo de farmácia, com posologia, quantidade, status e vínculo a lote e local de estoque.',
    farmacia_dispensacao_log: 'Log detalhado de dispensação de medicamentos pela farmácia, registrando sessão do usuário, lote, quantidade e timestamp para auditoria.',
    farmacia_externo_evento: 'Registra eventos operacionais de farmácia para atendimentos externos, permitindo rastreamento de ações e ocorrências.',
    farmaco_auditoria: 'Auditoria geral de tabelas de farmácia, registrando inserts, updates e deletes com dados antes e depois da alteração.',
    farmaco_auditoria_bloqueio: 'Registra bloqueios de medicamentos por lote e cidade, com motivo, responsável e vínculo a FFA quando aplicável.',
    farmaco_movimentacao: 'Registra movimentações de entrada e saída de medicamentos (compras, transferências, atendimento a paciente, ajustes, PDV).',
    farmaco_unidade: 'Define cotas mínimas e máximas de medicamentos por cidade/localidade, permitindo controle de estoque por unidade geográfica.',
    faturamento_codigo: 'Catálogo de códigos de faturamento (SIGTAP, TUSS, CBHPM, INTERNO) com tipo de item, unidade de medida e status ativo.',
    faturamento_conta: 'Conta de faturamento principal, associada a FFA ou internação, com status, valores monetários, competência e trilha de auditoria.',
    faturamento_conta_item: 'Tabela de relacionamento entre itens faturáveis (procedimentos, exames, medicamentos, materiais, taxas) e contas de faturamento.',
    faturamento_conta_paciente: 'Conta de faturamento do paciente vinculada a atendimento e convênio, com status de conta, valor total, guia principal e data de fechamento.',
    faturamento_conta_seq: 'Sequência/controle numérico para geração de contas de faturamento, registrando usuário e timestamp de criação.',
    faturamento_convenio: 'Registro de guias de convênio associadas a atendimentos, com número, valor, status, XML gerado e data de emissão.',
    faturamento_convenios: 'Cadastro de convênios credenciados com nome fantasia, registro ANS e tabela de preços associada.',
    faturamento_evento: 'Auditoria humana do faturamento, registrando eventos de abertura, fechamento, reabertura e cancelamento de contas com observações.',
    faturamento_insumo: 'Detalhe de insumos faturáveis (farmácia, almoxarifado, manutenção) vinculados a itens de faturamento, com lote e validade.',
    faturamento_item: 'Itens faturáveis gerados a partir de eventos assistenciais (procedimentos, exames, medicações, materiais, taxas), com valores e descontos.',
    faturamento_producao: 'Registro de produção assistencial para faturamento, com código de procedimento, CBO do profissional e status de processamento.',
    faturamento_producao_sus: 'Produção SUS para faturamento, vinculada a atendimento e SIGTAP, com CNS do paciente, data de produção e status de remessa.',
    faturamento_regras_validacao: 'Validação de regras de faturamento por atendimento, verificando presença de CID, CBO e prescrição para determinar aptidão para faturar.',
    faturamento_sigtap: 'Catálogo de procedimentos do sistema SIGTAP com valores de serviço hospitalar (SH), serviço ambulatorial (SA) e complexidade.',
    faturamento_sus_config: 'Configuração de unidades para faturamento SUS, com CNES da unidade e tipo de gestão (municipal ou estadual).',
    ffa: 'Fluxo de Atendimento Ambulatorial (FFA) representando o atendimento completo do paciente na unidade, com estados clínicos, contexto de fluxo, versão de ledger e trilha de abertura.',
    ffa_demandas_externas: 'Demandas externas associadas a atendimentos (RX externo, medicação externa, exame externo), com status e profissional externo responsável.',
    ffa_diagnostico: 'Diagnósticos CID-10 associados a FFA, com tipo (principal, secundário, suspeita), confirmação, observação clínica e auditoria por usuário/sessão.',
    ffa_estado: 'Catálogo de estados possíveis para o fluxo de atendimento ambulatorial (FFA), com nome e descrição do estado.',
    ffa_estoque_conciliacao: 'Conciliação entre itens de estoque e movimentos de faturamento, comparando valores faturados versus custos para reconciliação contábil.',
    ffa_evolucao: 'Evoluções textuais associadas a FFA, com tipo, módulo, local operacional, IP, user-agent e hash de integridade para auditoria.',
    ffa_extra: 'Registros extras complementares ao atendimento (medicação externa, RX externo, exame externo, procedimento avulso).',
    ffa_historico_status: 'Histórico de mudanças de status do FFA, registrando status anterior, novo status, data da mudança e usuário responsável pela ação.'
  };
  md += (descs[tableName] || 'Tabela do sistema de atendimento hospitalar.') + '\n\n';
  
  md += `## Colunas\n\n| Coluna | Tipo | Nullable | Default | Funcao/Descricao |\n|---------|------|----------|---------|------------------|\n`;
  parsed.columns.forEach(col => {
    const def = col.default || '—';
    md += `| ${col.name} | ${col.type} | ${col.nullable} | ${def} | ${getDesc(col.name)} |\n`;
  });
  
  md += `\n## Chaves\n\n`;
  if (parsed.primaryKey.length > 0) md += `- Primaria: ${parsed.primaryKey.join(', ')}\n`;
  if (parsed.uniqueKeys.length > 0) {
    parsed.uniqueKeys.forEach(uk => md += `- Unica (${uk.name}): ${uk.columns.join(', ')}\n`);
  }
  if (parsed.foreignKeys.length > 0) {
    parsed.foreignKeys.forEach(fk => {
      const on = [];
      if (fk.raw.includes('ON DELETE')) on.push(fk.raw.match(/ON DELETE\\s+(\\w+)/)?.[1] || '');
      if (fk.raw.includes('ON UPDATE')) on.push(fk.raw.match(/ON UPDATE\\s+(\\w+)/)?.[1] || '');
      const extra = on.filter(Boolean).length > 0 ? ` (${on.filter(Boolean).join(', ')})` : '';
      const desc = `Referencia a tabela ${fk.refTable} (coluna ${fk.refColumn}) para garantir integridade referencial`;
      md += `- Estrangeira (${fk.name}): coluna ${fk.column} -> tabela ${fk.refTable}(${fk.refColumn})${extra}: ${desc}\n`;
    });
  }
  
  md += `\n## Indices\n\n`;
  if (parsed.indexes.length > 0) {
    parsed.indexes.forEach(idx => md += `- ${idx.name} (${idx.columns.join(', ')})\n`);
  } else {
    md += `Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.\n`;
  }
  
  md += `\n## Constraints\n\n`;
  const hasCons = parsed.foreignKeys.length > 0 || parsed.uniqueKeys.length > 0 || parsed.primaryKey.length > 0 || parsed.checks.length > 0;
  if (hasCons) {
    parsed.foreignKeys.forEach(fk => md += `- FOREIGN KEY ${fk.name}: ${fk.column} references ${fk.refTable}(${fk.refColumn})\n`);
    parsed.uniqueKeys.forEach(uk => md += `- UNIQUE KEY ${uk.name} (${uk.columns.join(', ')})\n`);
    parsed.checks.forEach(chk => md += `- CHECK (${chk})\n`);
    if (parsed.primaryKey.length > 0) md += `- PRIMARY KEY (${parsed.primaryKey.join(', ')})\n`;
  } else {
    md += `Nenhuma constraint adicional definida.\n`;
  }
  
  md += `\n## Relacionamentos e Cardinalidade\n\n`;
  parsed.foreignKeys.forEach(fk => md += `- ${tableName} (1) -> ${fk.refTable} (1): campo ${fk.column}\n`);
  
  md += `\n## Dependencias\n\n`;
  if (parsed.foreignKeys.length > 0) {
    md += `- Depende de:\n`;
    parsed.foreignKeys.forEach(fk => md += `  - ${fk.refTable}\n`);
  }
  md += `- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.\n`;
  
  md += `\n## Fluxo de utilizacao dentro do sistema\n\n`;
  md += getFlow(tableName) + '\n';
  
  fs.writeFileSync(path.join(outputDir, `${tableName}.md`), md);
  console.log(`Created: ${tableName}.md`);
});

console.log('Done.');
