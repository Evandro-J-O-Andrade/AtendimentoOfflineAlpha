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
    console.log('=== CHAMADORES DE sp_totem_gerar_senha ===')
    const [routines] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_TYPE FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%sp_totem_gerar_senha%'`)
    if (routines.length === 0) console.log('Nenhum chamador encontrado')
    routines.forEach((r: any) => console.log(`${r.ROUTINE_NAME} | ${r.ROUTINE_TYPE}`))

    console.log('\n=== TODAS AS SPs QUE REFERENCIAM senha ===')
    const [senhaRefs] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_TYPE FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%senha%' ORDER BY ROUTINE_NAME`)
    senhaRefs.forEach((r: any) => console.log(`${r.ROUTINE_NAME} | ${r.ROUTINE_TYPE}`))

    console.log('\n=== TODAS AS SPs COM INSERT INTO senha ===')
    const [inserts] = await conn.query(`SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%INSERT INTO senha%' ORDER BY ROUTINE_NAME`)
    inserts.forEach((r: any) => console.log(r.ROUTINE_NAME))

    console.log('\n=== TODAS AS SPs COM UPDATE senha ===')
    const [updates] = await conn.query(`SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%UPDATE senha%' ORDER BY ROUTINE_NAME`)
    updates.forEach((r: any) => console.log(r.ROUTINE_NAME))

    console.log('\n=== TODAS AS SPs COM SELECT FROM senha ===')
    const [selects] = await conn.query(`SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%FROM senha%' ORDER BY ROUTINE_NAME`)
    selects.forEach((r: any) => console.log(r.ROUTINE_NAME))

    console.log('\n=== ESTRUTURA COMPLETA senha (todas as colunas) ===')
    const [senhaFull] = await conn.query('SELECT * FROM senha LIMIT 1')
    if (senhaFull.length > 0) {
      console.log(JSON.stringify(senhaFull[0], null, 2))
    } else {
      console.log('Tabela senha vazia')
    }

    console.log('\n=== CAMPOS OBRIGATORIOS NA TABELA senha ===')
    const [required] = await conn.query("SELECT COLUMN_NAME, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'pronto_atendimento' AND TABLE_NAME = 'senha' AND IS_NULLABLE = 'NO' ORDER BY ORDINAL_POSITION")
    required.forEach((r: any) => console.log(`${r.COLUMN_NAME} | nullable=${r.IS_NULLABLE} | default=${r.COLUMN_DEFAULT}`))

    console.log('\n=== TODAS AS COLUNAS DA TABELA senha ===')
    const [allCols] = await conn.query("SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'pronto_atendimento' AND TABLE_NAME = 'senha' ORDER BY ORDINAL_POSITION")
    allCols.forEach((r: any) => console.log(`${r.COLUMN_NAME} | ${r.COLUMN_TYPE} | nullable=${r.IS_NULLABLE} | default=${r.COLUMN_DEFAULT}`))

    console.log('\n=== DADOS DE EXEMPLO EM senha ===')
    const [sample] = await conn.query('SELECT * FROM senha LIMIT 5')
    sample.forEach((r: any) => console.log(JSON.stringify(r)))

    console.log('\n=== CONTAGEM senha ===')
    const [count] = await conn.query('SELECT COUNT(*) as cnt FROM senha')
    console.log(`Total senha: ${count[0].cnt}`)

    console.log('\n=== FOREIGN KEYS DE senha ===')
    const [fks] = await conn.query(`SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'pronto_atendimento' AND REFERENCED_TABLE_NAME = 'senha'`)
    if (fks.length === 0) console.log('Nenhuma FK referencia senha')
    fks.forEach((r: any) => console.log(`${r.TABLE_NAME}.${r.COLUMN_NAME} -> senha.${r.REFERENCED_COLUMN_NAME}`))

    console.log('\n=== INDICES DE senha ===')
    const [indexes] = await conn.query(`SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'pronto_atendimento' AND TABLE_NAME = 'senha' ORDER BY INDEX_NAME, SEQ_IN_INDEX`)
    indexes.forEach((r: any) => console.log(`${r.INDEX_NAME} | ${r.COLUMN_NAME} | unique=${r.NON_UNIQUE === 0}`))
  } catch (err) {
    console.error('Error:', err)
  } finally {
    await conn.end()
  }
}

audit()
