import mysql from 'mysql2/promise'

const config = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

async function seed() {
  const conn = await mysql.createConnection(config)
  try {
    await conn.query("INSERT IGNORE INTO permissao (codigo, nome, dominio, nome_procedure, ativo, grupo_menu, icone, ordem_menu, visivel_menu, id_entidade) VALUES ('DASHBOARD', 'Dashboard', 'PORTAL', 'sp_portal_dashboard', 1, 'Portal', 'dashboard', 1, 1, 1)")
    const [result] = await conn.query("SELECT id_permissao FROM permissao WHERE codigo = 'DASHBOARD' LIMIT 1")
    const idPermissao = result[0]?.id_permissao
    if (idPermissao) {
      await conn.query("INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao) VALUES (1, ?)", [idPermissao])
    }
    console.log('Test permissions seeded')
  } catch (err) {
    console.error('Seed error:', err)
  } finally {
    await conn.end()
  }
}

seed()
