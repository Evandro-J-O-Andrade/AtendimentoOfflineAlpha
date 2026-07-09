import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import authRoutes from './routes/auth.js'
import portalRoutes from './routes/portal.js'

const app = express()

app.use(cors())
app.use(express.json())

app.use('/auth', authRoutes)
app.use('/portal', portalRoutes)

const PORT = process.env.PORT ?? 3001

app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`)
})
