import mysql from 'mysql2/promise'

const config = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

async function audit() {
  const conn = await mysql.createConnection(config)
  try {
    console.log('=== DOMÍNIO TOTEM/SENHA/PAINEL/FILA — INVENTÁRIO COMPLETO ===')

    console.log('\n--- TABELAS DO DOMÍNIO ---')
    const [tables] = await conn.query(`SELECT TABLE_NAME, TABLE_TYPE, ENGINE, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'pronto_atendimento' AND (TABLE_NAME LIKE '%totem%' OR TABLE_NAME LIKE '%painel%' OR TABLE_NAME LIKE '%senha%' OR TABLE_NAME LIKE '%fila%' OR TABLE_NAME LIKE '%chamada%' OR TABLE_NAME LIKE '%satisfacao%' OR TABLE_NAME LIKE '%display%' OR TABLE_NAME LIKE '%local_fila%') ORDER BY TABLE_NAME`)
    tables.forEach((r: any) => console.log(`${r.TABLE_NAME} | ${r.TABLE_TYPE} | rows=${r.TABLE_ROWS} | engine=${r.ENGINE}`))

    console.log('\n--- VIEWS DO DOMÍNIO ---')
    const [views] = await conn.query(`SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = 'pronto_atendimento' AND (TABLE_NAME LIKE '%totem%' OR TABLE_NAME LIKE '%painel%' OR TABLE_NAME LIKE '%senha%' OR TABLE_NAME LIKE '%fila%' OR TABLE_NAME LIKE '%chamada%' OR TABLE_NAME LIKE '%display%') ORDER BY TABLE_NAME`)
    if (views.length === 0) console.log('Nenhuma view encontrada')
    views.forEach((r: any) => console.log(r.TABLE_NAME))

    console.log('\n--- PROCEDURES DO DOMÍNIO ---')
    const [sps] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_TYPE FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND (ROUTINE_NAME LIKE '%totem%' OR ROUTINE_NAME LIKE '%painel%' OR ROUTINE_NAME LIKE '%senha%' OR ROUTINE_NAME LIKE '%fila%' OR ROUTINE_NAME LIKE '%chamada%' OR ROUTINE_NAME LIKE '%satisfacao%' OR ROUTINE_NAME LIKE '%display%' OR ROUTINE_NAME LIKE '%local_fila%') ORDER BY ROUTINE_NAME`)
    sps.forEach((r: any) => console.log(`${r.ROUTINE_NAME} | ${r.ROUTINE_TYPE}`))

    console.log('\n--- FUNCTIONS DO DOMÍNIO ---')
    const [funcs] = await conn.query(`SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_TYPE = 'FUNCTION' AND (ROUTINE_NAME LIKE '%totem%' OR ROUTINE_NAME LIKE '%painel%' OR ROUTINE_NAME LIKE '%senha%' OR ROUTINE_NAME LIKE '%fila%' OR ROUTINE_NAME LIKE '%chamada%' OR ROUTINE_NAME LIKE '%display%') ORDER BY ROUTINE_NAME`)
    if (funcs.length === 0) console.log('Nenhuma function encontrada')
    funcs.forEach((r: any) => console.log(r.ROUTINE_NAME))

    console.log('\n--- TRIGGERS DO DOMÍNIO ---')
    const [triggers] = await conn.query(`SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE FROM INFORMATION_SCHEMA.TRIGGERS WHERE TRIGGER_SCHEMA = 'pronto_atendimento' AND (TRIGGER_NAME LIKE '%totem%' OR TRIGGER_NAME LIKE '%painel%' OR TRIGGER_NAME LIKE '%senha%' OR TRIGGER_NAME LIKE '%fila%' OR TRIGGER_NAME LIKE '%chamada%' OR EVENT_OBJECT_TABLE LIKE '%totem%' OR EVENT_OBJECT_TABLE LIKE '%painel%' OR EVENT_OBJECT_TABLE LIKE '%senha%' OR EVENT_OBJECT_TABLE LIKE '%fila%' OR EVENT_OBJECT_TABLE LIKE '%chamada%') ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME`)
    if (triggers.length === 0) console.log('Nenhum trigger encontrado')
    triggers.forEach((r: any) => console.log(`${r.TRIGGER_NAME} | ${r.EVENT_MANIPULATION} | on ${r.EVENT_OBJECT_TABLE}`))

    console.log('\n--- FOREIGN KEYS DO DOMÍNIO ---')
    const [fks] = await conn.query(`SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME, CONSTRAINT_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'pronto_atendimento' AND REFERENCED_TABLE_NAME IS NOT NULL AND (TABLE_NAME LIKE '%totem%' OR TABLE_NAME LIKE '%painel%' OR TABLE_NAME LIKE '%senha%' OR TABLE_NAME LIKE '%fila%' OR TABLE_NAME LIKE '%chamada%' OR TABLE_NAME LIKE '%display%' OR TABLE_NAME LIKE '%evento%' OR REFERENCED_TABLE_NAME LIKE '%totem%' OR REFERENCED_TABLE_NAME LIKE '%painel%' OR REFERENCED_TABLE_NAME LIKE '%senha%' OR REFERENCED_TABLE_NAME LIKE '%fila%' OR REFERENCED_TABLE_NAME LIKE '%chamada%') ORDER BY TABLE_NAME, CONSTRAINT_NAME`)
    if (fks.length === 0) console.log('Nenhuma FK encontrada')
    fks.forEach((r: any) => console.log(`${r.TABLE_NAME}.${r.COLUMN_NAME} -> ${r.REFERENCED_TABLE_NAME}.${r.REFERENCED_COLUMN_NAME} (${r.CONSTRAINT_NAME})`))

    console.log('\n--- ESTRUTURA DAS TABELAS PRINCIPAIS ---')
    const mainTables = ['totem', 'totem_senha_opcao', 'totem_evento', 'totem_feedback', 'painel', 'painel_config', 'painel_local', 'painel_lane', 'painel_fila_tipo', 'painel_grupo', 'painel_grupo_local', 'painel_mensagem', 'fila_operacional', 'senha', 'senha_status', 'senha_transicao_matriz', 'senha_sequencia', 'local_fila']
    for (const table of mainTables) {
      const [desc] = await conn.query(`DESCRIBE ${table}`)
      console.log(`\n--- ${table} ---`)
      desc.forEach((r: any) => console.log(`  ${r.Field} | ${r.Type} | null=${r.Null} | key=${r.Key} | default=${r.Default} | extra=${r.Extra}`))
    }

    console.log('\n--- SPs DETALHADAS ---')
    const mainSps = ['sp_totem_gerar_senha', 'sp_painel_inserir_senha', 'sp_painel_chamar_senha', 'sp_painel_cancelar_senha', 'sp_painel_config_set', 'sp_fila_chamar_proxima', 'sp_fila_tipo_por_local', 'sp_fila_finalizar', 'sp_executor_fila_runtime']
    for (const sp of mainSps) {
      const [spDesc] = await conn.query(`SHOW CREATE PROCEDURE ${sp}`)
      if (spDesc.length > 0) {
        const createSql = spDesc[0]['Create Procedure'] || ''
        console.log(`\n--- ${sp} ---`)
        console.log(createSql.substring(0, 2000))
      }
    }

    console.log('\n--- CONTAGEM DE REGISTROS ---')
    const countTables = ['totem', 'totem_senha_opcao', 'totem_evento', 'totem_feedback', 'painel', 'painel_config', 'painel_local', 'painel_lane', 'painel_fila_tipo', 'painel_grupo', 'painel_grupo_local', 'painel_mensagem', 'fila_operacional', 'senha', 'senha_status', 'senha_transicao_matriz', 'senha_sequencia', 'local_fila']
    for (const table of countTables) {
      try {
        const [count] = await conn.query(`SELECT COUNT(*) as cnt FROM ${table}`)
        console.log(`${table}: ${count[0].cnt} registros`)
      } catch (e) {
        console.log(`${table}: erro ao contar`)
      }
    }

    console.log('\n--- AMOSTRAS ---')
    try {
      const [totemSample] = await conn.query('SELECT * FROM totem LIMIT 5')
      console.log('\n--- totem ---')
      totemSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('totem sample: erro') }

    try {
      const [opcoesSample] = await conn.query('SELECT * FROM totem_senha_opcao LIMIT 10')
      console.log('\n--- totem_senha_opcao ---')
      opcoesSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('totem_senha_opcao sample: erro') }

    try {
      const [painelSample] = await conn.query('SELECT * FROM painel LIMIT 5')
      console.log('\n--- painel ---')
      painelSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('painel sample: erro') }

    try {
      const [filaSample] = await conn.query('SELECT * FROM fila_operacional LIMIT 5')
      console.log('\n--- fila_operacional ---')
      filaSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('fila_operacional sample: erro') }

    try {
      const [senhaStatusSample] = await conn.query('SELECT * FROM senha_status LIMIT 10')
      console.log('\n--- senha_status ---')
      senhaStatusSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('senha_status sample: erro') }

    try {
      const [transicaoSample] = await conn.query('SELECT * FROM senha_transicao_matriz LIMIT 10')
      console.log('\n--- senha_transicao_matriz ---')
      transicaoSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('senha_transicao_matriz sample: erro') }

    try {
      const [sequenciaSample] = await conn.query('SELECT * FROM senha_sequencia LIMIT 10')
      console.log('\n--- senha_sequencia ---')
      sequenciaSample.forEach((r: any) => console.log(JSON.stringify(r)))
    } catch (e) { console.log('senha_sequencia sample: erro') }

    console.log('\n=== AUDITORIA CONCLUÍDA ===')
  } catch (err) {
    console.error('Erro na auditoria:', err)
  } finally {
    await conn.end()
  }
}

audit()
