import mysql from 'mysql2/promise'

const config = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

async function update() {
  const conn = await mysql.createConnection(config)
  try {
    await conn.query("UPDATE permissao SET id_entidade = 1 WHERE id_entidade IS NULL")
    console.log('Updated permissao id_entidade')
  } catch (err) {
    console.error('Update error:', err)
  } finally {
    await conn.end()
  }
}

update()
