import { createPool } from 'mysql2/promise'
import { randomUUID } from 'node:crypto'

const cfg = {
  host: process.env.DB_HOST ?? 'localhost',
  port: Number(process.env.DB_PORT ?? 3306),
  user: process.env.DB_USER ?? 'root',
  password: process.env.DB_PASSWORD ?? 'root',
  database: process.env.DB_NAME ?? 'pronto_atendimento'
}

const pool = createPool(cfg)

async function main() {
  const conn = await pool.getConnection()
  try {
    const idSessao = 201
    const dominio = 'TOTEM'
    const acao = 'GERAR_SENHA'
    const uuid = crypto.randomUUID()
    const idReferencia = 1
    const payload = JSON.stringify({
      id_opcao: 1,
      id_unidade: 2,
      id_local_operacional: 1,
      id_paciente: null
    })

    console.log('dispatch_request', { idSessao, dominio, acao, payload })

    const [rows] = await conn.query(
      'CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)',
      [idSessao, uuid, dominio, acao, idReferencia, payload]
    )

    console.log('raw_rows', JSON.stringify(rows, null, 2))

    const allRows = rows as any[]
    const out = allRows[allRows.length - 2]
    const result = out?.[0]?.result

    console.log('dispatch_result', result)
  } catch (e: any) {
    console.error('dispatch_failed', e?.message ?? e)
    process.exitCode = 1
  } finally {
    conn.release()
    await pool.end()
  }
}

main()
