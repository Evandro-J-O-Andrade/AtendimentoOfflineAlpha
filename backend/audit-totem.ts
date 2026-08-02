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
    const [tables] = await conn.query(`SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'pronto_atendimento' AND (TABLE_NAME LIKE '%totem%' OR TABLE_NAME LIKE '%painel%' OR TABLE_NAME LIKE '%senha%' OR TABLE_NAME LIKE '%fila%' OR TABLE_NAME LIKE '%chamada%' OR TABLE_NAME LIKE '%satisfacao%' OR TABLE_NAME LIKE '%display%' OR TABLE_NAME LIKE '%evento%') ORDER BY TABLE_NAME`)
    console.log('=== TABELAS ===')
    tables.forEach((r: any) => console.log(r.TABLE_NAME))

    const [sps] = await conn.query(`SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND (ROUTINE_NAME LIKE '%totem%' OR ROUTINE_NAME LIKE '%painel%' OR ROUTINE_NAME LIKE '%senha%' OR ROUTINE_NAME LIKE '%fila%' OR ROUTINE_NAME LIKE '%chamada%' OR ROUTINE_NAME LIKE '%satisfacao%' OR ROUTINE_NAME LIKE '%display%' OR ROUTINE_NAME LIKE '%evento%') ORDER BY ROUTINE_NAME`)
    console.log('\n=== SPs ===')
    sps.forEach((r: any) => console.log(r.ROUTINE_NAME))
  } catch (err) {
    console.error('Error:', err)
  } finally {
    await conn.end()
  }
}

audit()
