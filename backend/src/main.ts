import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import authRoutes from './routes/auth.js'
import portalRoutes from './routes/portal.js'
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

const PORT = process.env.PORT ?? 3001

app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`)
})
