import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import authRoutes from './routes/auth.js'
import portalRoutes from './routes/portal.js'
import contextoRoutes from './routes/contexto.js'
import eventosRoutes from './routes/eventos.js'
import auditoriaRoutes from './routes/auditoria.js'
import integracaoRoutes from './routes/integracoes.js'
import dispatcherRoutes from './routes/dispatcher.js'
import totemRoutes from './routes/totem.js'
import { getDatabasePool } from './database/mysql/connection.js'

const app = express()

app.use(cors())
app.use(express.json())

app.get('/health', async (_req, res) => {
  try {
    const conn = await getDatabasePool().getConnection()
    await conn.query('SELECT 1')
    conn.release()
    res.json({ status: 'ok', db: 'up' })
  } catch {
    res.status(503).json({ status: 'degraded', db: 'down' })
  }
})

app.use('/auth', authRoutes)
app.use('/portal', portalRoutes)
app.use('/contexto', contextoRoutes)
app.use('/eventos', eventosRoutes)
app.use('/auditoria', auditoriaRoutes)
app.use('/integracoes', integracaoRoutes)
app.use('/dispatcher', dispatcherRoutes)
app.use('/totem', totemRoutes)

const PORT = process.env.PORT ?? 3001

app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`)
})
