import mysql from 'mysql2/promise'

const config = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

async function fix() {
  const conn = await mysql.createConnection(config)
  try {
    await conn.query(`
      CREATE TABLE IF NOT EXISTS \`permissao_local\` (
        \`id_permissao\` BIGINT NOT NULL,
        \`id_local\` BIGINT NOT NULL,
        \`id_sistema\` BIGINT NOT NULL,
        \`id_unidade\` BIGINT NULL,
        PRIMARY KEY (\`id_permissao\`, \`id_local\`, \`id_sistema\`),
        INDEX \`ix_permissao_local_local\` (\`id_local\`),
        INDEX \`ix_permissao_local_unidade\` (\`id_unidade\`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    `)
    console.log('permissao_local table created')
  } catch (err) {
    console.error('Error creating permissao_local:', err)
  } finally {
    await conn.end()
  }
}

fix()
