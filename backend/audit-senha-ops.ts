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
    const [sps] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%INSERT INTO senha%' ORDER BY ROUTINE_NAME`)
    sps.forEach((r: any) => {
      console.log(`\n=== ${r.ROUTINE_NAME} ===`)
      const match = r.ROUTINE_DEFINITION.match(/INSERT INTO senha \([^)]+\) VALUES \([^)]+\)/)
      if (match) console.log(match[0])
      else console.log('INSERT complexo')
    })

    console.log('\n=== SELECTS FROM senha ===')
    const [selects] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%FROM senha%' ORDER BY ROUTINE_NAME`)
    selects.forEach((r: any) => {
      console.log(`\n--- ${r.ROUTINE_NAME} ---`)
      const matches = r.ROUTINE_DEFINITION.match(/SELECT[^;]+FROM senha[^;]*/g)
      if (matches) matches.forEach((m: string) => console.log(m.trim()))
      else console.log('SELECT complexo')
    })

    console.log('\n=== UPDATES senha ===')
    const [updates] = await conn.query(`SELECT ROUTINE_NAME, ROUTINE_DEFINITION FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'pronto_atendimento' AND ROUTINE_DEFINITION LIKE '%UPDATE senha%' ORDER BY ROUTINE_NAME`)
    updates.forEach((r: any) => {
      console.log(`\n--- ${r.ROUTINE_NAME} ---`)
      const matches = r.ROUTINE_DEFINITION.match(/UPDATE senha[^;]+/g)
      if (matches) matches.forEach((m: string) => console.log(m.trim()))
      else console.log('UPDATE complexo')
    })
  } catch (err) {
    console.error('Error:', err)
  } finally {
    await conn.end()
  }
}

audit()
