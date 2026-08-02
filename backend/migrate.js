import mysql from 'mysql2/promise'

const config = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

async function migrate() {
  const conn = await mysql.createConnection(config)
  try {
    await conn.query("ALTER TABLE permissao ADD COLUMN modulo VARCHAR(50) NOT NULL DEFAULT 'GERAL' COMMENT 'modulo agrupador do menu'")
    await conn.query("ALTER TABLE permissao ADD COLUMN flag_ativo TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'flag de ativo para menu'")
    await conn.query("ALTER TABLE permissao ADD COLUMN flag_externo TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'flag de modulo externo'")
    await conn.query("ALTER TABLE permissao ADD COLUMN flag_restrito TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'flag de modulo restrito'")
    await conn.query("ALTER TABLE permissao ADD COLUMN ordem INT NOT NULL DEFAULT 999 COMMENT 'ordem de exibicao no menu'")
    await conn.query("UPDATE permissao SET modulo = COALESCE(grupo_menu, 'GERAL'), flag_ativo = COALESCE(ativo, 1), ordem = COALESCE(ordem_menu, 999)")
    await conn.query('CREATE INDEX idx_permissao_modulo ON permissao (modulo)')
    await conn.query('CREATE INDEX idx_permissao_flag_ativo ON permissao (flag_ativo)')
    await conn.query('CREATE INDEX idx_permissao_ordem ON permissao (ordem)')
    console.log('Migration applied')
  } catch (err) {
    console.error('Migration error:', err)
  } finally {
    await conn.end()
  }
}

migrate()
