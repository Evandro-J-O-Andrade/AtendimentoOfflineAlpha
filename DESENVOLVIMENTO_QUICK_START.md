# GUIA DE DESENVOLVIMENTO - QUICK START

> **LEIA PRIMEIRO:** [MAPA_BANCO_DADOS_COMPLETO.md](./MAPA_BANCO_DADOS_COMPLETO.md)  
> **ARQUITETURA VISUAL:** [FLUXOS_ARQUITETURA_VISUAL.md](./FLUXOS_ARQUITETURA_VISUAL.md)  
> **REFERENCE TECHNIQUES:** [REFERENCIA_TECNICA_PROCEDURES.md](./REFERENCIA_TECNICA_PROCEDURES.md)

---

## 🚀 COMEÇAR EM 5 MINUTOS

### 1️⃣ SETUP DO BANCO (MySQL 8.0.44)

```bash
# No seu servidor MySQL:
mysql -u root -p

# Criar DB
CREATE DATABASE pronto_atendimento 
  DEFAULT CHARACTER SET utf8mb4 
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

# Importar dump
mysql -u root -p pronto_atendimento < Dump20260220.sql

# Verificar
SELECT COUNT(*) FROM information_schema.TABLES 
  WHERE TABLE_SCHEMA='pronto_atendimento';
# Output: ~122 tabelas
```

---

## 📚 ESTRUTURA RECOMENDADA

### Backend + Frontend (Node.js/Express)

```
projeto/
├── backend/
│   ├── app.js
│   ├── package.json
│   ├── .env
│   ├── routes/
│   │   ├── auth.js          (login, sessão)
│   │   ├── recepcao.js      (senhas, chamadas)
│   │   ├── triagem.js       (vital signs)
│   │   ├── medico.js        (consulta, prescrição)
│   │   ├── farmacia.js      (dispensação)
│   │   ├── config.js        (painel, config)
│   │   └── audit.js         (logs)
│   ├── middleware/
│   │   ├── auth.js          (JWT validation)
│   │   └── permissao.js     (RBAC check)
│   ├── controllers/
│   │   ├── sessaoController.js
│   │   ├── senhaController.js
│   │   └── ...
│   ├── db/
│   │   ├── mysql-pool.js    (conexão MySQL)
│   │   └── procedure-wrapper.js
│   └── utils/
│       ├── error-handler.js
│       ├── validators.js
│       └── logger.js
│
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   │   ├── Login.jsx
│   │   │   ├── Recepcao.jsx
│   │   │   ├── Triagem.jsx
│   │   │   ├── Medico.jsx
│   │   │   ├── Farmacia.jsx
│   │   │   ├── PainelPublico.jsx
│   │   │   └── Admin.jsx
│   │   ├── components/
│   │   │   ├── FilaLista.jsx
│   │   │   ├── FormTodosVitais.jsx
│   │   │   ├── FormPrescreve.jsx
│   │   │   └── ...
│   │   ├── services/
│   │   │   ├── api.js          (axios calls)
│   │   │   └── auth.js         (token storage)
│   │   ├── context/
│   │   │   └── SessionContext.jsx (global sessão)
│   │   └── App.jsx
│   └── package.json
│
└── docs/
    ├── MAPA_BANCO_DADOS_COMPLETO.md      ← LER PRIMEIRO
    ├── FLUXOS_ARQUITETURA_VISUAL.md
    ├── REFERENCIA_TECNICA_PROCEDURES.md
    └── DESENVOLVIMENTO_QUICK_START.md    ← ESTE ARQUIVO
```

---

## 💾 CONEXÃO MYSQL (Node.js)

### `backend/db/mysql-pool.js`

```javascript
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || 'password',
    database: 'pronto_atendimento',
    connectionLimit: 10,
    queueLimit: 0,
    enableKeepAlive: true,
    keepAliveInitialDelayMs: 0
});

module.exports = pool;
```

### `backend/db/procedure-wrapper.js`

```javascript
const pool = require('./mysql-pool');

/**
 * Chama stored procedure e retorna resultados
 * @param {string} procName - nome da procedure
 * @param {array} params - parâmetros IN/OUT
 * @returns {object} { results, fields, outParams }
 */
async function callProcedure(procName, params = []) {
    const connection = await pool.getConnection();
    try {
        // Monta ? para cada param
        const placeholders = params.map(() => '?').join(', ');
        const sql = `CALL ${procName}(${placeholders})`;
        
        const [results, fields] = await connection.query(sql, params);
        
        return {
            results: results[0] || [],
            fields: fields,
            success: true
        };
    } catch (error) {
        console.error(`[${procName}] Error:`, error.message);
        // Parse SQL Error → HTTP friendly
        if (error.sqlState === '45000') {
            throw {
                code: error.sqlMessage.split(']')[0].slice(1), // [CODIGO] → CODIGO
                message: error.sqlMessage,
                httpStatus: 400
            };
        }
        throw {
            code: 'DB_ERROR',
            message: error.message,
            httpStatus: 500
        };
    } finally {
        await connection.release();
    }
}

module.exports = { callProcedure };
```

---

## 🔐 AUTENTICAÇÃO (JWT)

### `backend/routes/auth.js`

```javascript
const express = require('express');
const router = express.Router();
const { callProcedure } = require('../db/procedure-wrapper');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// LOGIN
router.post('/login', async (req, res) => {
    try {
        const { login, senha } = req.body;
        
        // 1. Validar credentials (comparar hash)
        // SELECT id_usuario, senha_hash FROM usuario WHERE login=?
        // bcrypt.compare(senha, senha_hash)
        
        // 2. Chamar sp_sessao_abrir
        const token = jwt.sign(
            { login },
            process.env.JWT_SECRET,
            { expiresIn: '12h' }
        );
        
        const result = await callProcedure('sp_sessao_abrir', [
            1,                    // p_id_usuario
            1,                    // p_id_sistema (PA)
            1,                    // p_id_unidade
            1,                    // p_id_local_operacional
            token,                // p_token
            req.ip,               // p_ip
            req.get('user-agent') // p_user_agent
            // p_expira_em será retornado
        ]);
        
        const idSessao = result.results[0].p_id_sessao_usuario;
        
        res.json({
            success: true,
            token: token,
            sessionId: idSessao,
            user: {
                id: 1,
                login: login,
                role: 'RECEPCAO'
            }
        });
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.message
        });
    }
});

// LOGOUT
router.post('/logout', authenticateToken, async (req, res) => {
    try {
        const { sessionId } = req.body;
        
        await callProcedure('sp_sessao_encerrar', [
            sessionId,
            'USER_LOGOUT'
        ]);
        
        res.json({ success: true });
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.message
        });
    }
});

// VALIDATE (heartbeat)
router.get('/validate', authenticateToken, async (req, res) => {
    try {
        const { sessionId } = req.query;
        
        // Chama sp_sessao_assert (vai throw se inválida)
        await callProcedure('sp_sessao_assert', [sessionId]);
        
        // Se chegou aqui, sessão válida
        res.json({ valid: true, sessionId });
    } catch (error) {
        res.status(401).json({ valid: false, error: error.message });
    }
});

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) return res.sendStatus(401);
    
    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

module.exports = router;
```

### `backend/middleware/auth.js`

```javascript
const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
        return res.status(401).json({
            error: 'SESSAO_INVALIDA',
            message: 'Token não fornecido'
        });
    }
    
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({
                error: 'TOKEN_EXPIRADO',
                message: 'Token expirado ou inválido'
            });
        }
        
        req.user = decoded;
        next();
    });
}

module.exports = { authenticateToken };
```

---

## 🎫 RECEÇÃO - EMITIR SENHA

### `backend/routes/recepcao.js`

```javascript
const express = require('express');
const router = express.Router();
const { callProcedure } = require('../db/procedure-wrapper');
const { authenticateToken } = require('../middleware/auth');

// EMITIR SENHA
router.post('/senhas', authenticateToken, async (req, res) => {
    try {
        const { 
            tipo = 'CLINICO',
            origem = 'RECEPCAO',
            idLocalOperacional = 1,
            sessionId
        } = req.body;
        
        // Valida tipo
        const tiposValidos = ['CLINICO', 'PEDIATRICO', 'PRIORITARIO', 'EMERGENCIA', 'VISITA', 'EXAME'];
        if (!tiposValidos.includes(tipo)) {
            return res.status(400).json({
                error: 'TIPO_INVALIDO',
                message: `Tipo deve ser um de: ${tiposValidos.join(', ')}`
            });
        }
        
        // Chama procedure
        const result = await callProcedure('sp_senha_emitir', [
            sessionId,                 // p_id_sessao_usuario
            tipo,                      // p_tipo_atendimento
            origem,                    // p_origem
            idLocalOperacional,        // p_id_local_operacional
            // OUT p_id_senha
            // OUT p_codigo
        ]);
        
        res.json({
            success: true,
            senha: {
                id: result.results[0].p_id_senha,
                codigo: result.results[0].p_codigo,  // ex: A001
                tipo: tipo,
                timestamp: new Date()
            }
        });
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.code || 'UNKNOWN',
            message: error.message
        });
    }
});

// LISTAR SENHAS AGUARDANDO (painel)
router.get('/senhas', authenticateToken, async (req, res) => {
    try {
        const { sessionId, idLocal } = req.query;
        
        // Query direto (não precisa procedure)
        const result = await callProcedure(
            'SELECT * FROM senhas WHERE id_local_operacional = ? AND status IN (?, ?) ORDER BY prioridade DESC, criada_em ASC LIMIT 10',
            [idLocal, 'AGUARDANDO', 'CHAMANDO']
        );
        
        res.json({
            success: true,
            senhas: result.results
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// CHAMAR PRÓXIMA
router.post('/senhas/chamar', authenticateToken, async (req, res) => {
    try {
        const { sessionId, idLocalOperacional, lane } = req.body;
        
        const result = await callProcedure('sp_senha_chamar_proxima', [
            sessionId,
            idLocalOperacional,
            lane || null  // ADULTO, PEDIATRICO, PRIORITARIO ou NULL (qualquer)
            // OUT p_id_senha
            // OUT p_codigo
        ]);
        
        res.json({
            success: true,
            chamada: {
                idSenha: result.results[0].p_id_senha,
                codigo: result.results[0].p_codigo,
                timestamp: new Date()
            }
        });
        
        // EMIT WebSocket ao painel público (grita na TV)
        io.emit('SENHA_CHAMADA', {
            codigo: result.results[0].p_codigo,
            local: 'RECEPÇÃO'
        });
        
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.code,
            message: error.message
        });
    }
});

// COMPLEMENTAR DADOS + ABRIR FFA
router.post('/ffa/abrir', authenticateToken, async (req, res) => {
    try {
        const {
            sessionId,
            idSenha,
            nomeCompleto,
            cpf,
            cns,
            rg,
            dataNascimento,
            sexo,
            nomeMae,
            email,
            telefone,
            cep,
            logradouro,
            numero,
            complemento,
            bairro,
            cidade,
            uf
        } = req.body;
        
        // Valida CPF (básico)
        if (cpf && !validacao.isCPF(cpf)) {
            return res.status(400).json({
                error: 'CPF_INVALIDO',
                message: 'CPF inválido'
            });
        }
        
        // Chama CORE procedure
        const result = await callProcedure('sp_recepcao_complementar_e_abrir_ffa', [
            sessionId,
            idSenha,
            nomeCompleto,
            cpf,
            cns,
            rg,
            dataNascimento,
            sexo,
            nomeMae,
            email,
            telefone,
            cep,
            logradouro,
            numero,
            complemento,
            bairro,
            cidade,
            uf
            // OUT p_id_pessoa
            // OUT p_id_paciente
            // OUT p_id_atendimento
            // OUT p_id_ffa
            // OUT p_gpat
        ]);
        
        const dados = result.results[0];
        
        res.json({
            success: true,
            ffa: {
                id: dados.p_id_ffa,
                idPaciente: dados.p_id_paciente,
                idAtendimento: dados.p_id_atendimento,
                gpat: dados.p_gpat,  // Ex: GPAT-20260220-0000000142
                prontuario: dados.prontuario,
                status: 'ABERTO',
                timestamp: new Date()
            }
        });
        
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.code,
            message: error.message
        });
    }
});

// ENCAMINHAR PARA TRIAGEM
router.post('/ffa/:idFfa/encaminhar', authenticateToken, async (req, res) => {
    try {
        const { sessionId, tipoDestino = 'TRIAGEM' } = req.body;
        const { idFfa } = req.params;
        
        const result = await callProcedure('sp_recepcao_encaminhar_ffa', [
            sessionId,
            idFfa,
            tipoDestino
        ]);
        
        res.json({
            success: true,
            message: 'FFA encaminhado com sucesso',
            ffaId: idFfa
        });
        
        // Notificar triagem via WebSocket
        io.emit('FFA_ENCAMINHADO', {
            idFfa: idFfa,
            destino: 'TRIAGEM'
        });
        
    } catch (error) {
        res.status(error.httpStatus || 500).json({
            success: false,
            error: error.code,
            message: error.message
        });
    }
});

module.exports = router;
```

---

## 🏥 FRONTEND - EXEMPLO REACT

### `frontend/src/pages/Recepcao.jsx`

```jsx
import React, { useState, useEffect, useContext } from 'react';
import { SessionContext } from '../context/SessionContext';
import api from '../services/api';

export function RecepcaoPage() {
    const { session } = useContext(SessionContext);
    const [senhas, setSenhas] = useState([]);
    const [selecionada, setSelecionada] = useState(null);
    const [loadingComplementacao, setLoadingComplementacao] = useState(false);

    // LISTAR SENHAS
    useEffect(() => {
        const interval = setInterval(async () => {
            try {
                const response = await api.get('/recepcao/senhas', {
                    params: {
                        sessionId: session.id,
                        idLocal: session.locationId
                    }
                });
                setSenhas(response.data.senhas);
            } catch (error) {
                console.error('Erro ao listar senhas:', error);
            }
        }, 3000); // Atualiza a cada 3s
        
        return () => clearInterval(interval);
    }, [session]);

    // CHAMAR PRÓXIMA
    async function handleChamarProxima() {
        try {
            const response = await api.post('/recepcao/senhas/chamar', {
                sessionId: session.id,
                idLocalOperacional: session.locationId,
                lane: 'ADULTO'
            });
            
            setSelecionada(response.data.chamada);
            alert(`Chamando: ${response.data.chamada.codigo}`);
        } catch (error) {
            alert(`Erro: ${error.response.data.message}`);
        }
    }

    // FORMULÁRIO COMPLEMENTAÇÃO
    async function handleComplementar(formData) {
        setLoadingComplementacao(true);
        try {
            const response = await api.post('/recepcao/ffa/abrir', {
                sessionId: session.id,
                idSenha: selecionada.idSenha,
                ...formData
            });
            
            alert(`FFA criada: ${response.data.ffa.gpat}`);
            setSelecionada(null);
            setLoadingComplementacao(false);
        } catch (error) {
            alert(`Erro: ${error.response.data.message}`);
            setLoadingComplementacao(false);
        }
    }

    return (
        <div className="recepcao-page">
            <h1>Recepção</h1>
            
            <div className="fila-container">
                <h2>Filaaguardando</h2>
                <button onClick={handleChamarProxima}>
                    Chamar Próxima
                </button>
                
                <table>
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Tipo</th>
                            <th>Chegada</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {senhas.map(s => (
                            <tr key={s.id} className={s.id === selecionada?.idSenha ? 'selecionada' : ''}>
                                <td>{s.codigo}</td>
                                <td>{s.tipo_atendimento}</td>
                                <td>{new Date(s.criada_em).toLocaleTimeString()}</td>
                                <td>{s.status}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
            
            {selecionada && (
                <div className="complementacao-modal">
                    <h2>Complementar Dados: {selecionada.codigo}</h2>
                    <FormComplementacao 
                        onSubmit={handleComplementar}
                        loading={loadingComplementacao}
                    />
                </div>
            )}
        </div>
    );
}

function FormComplementacao({ onSubmit, loading }) {
    const [formData, setFormData] = useState({
        nomeCompleto: '',
        cpf: '',
        cns: '',
        dataNascimento: '',
        sexo: 'M',
        email: '',
        telefone: '',
        cidade: '',
        uf: 'SP'
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit(formData);
    };

    return (
        <form onSubmit={handleSubmit}>
            <label>
                Nome Completo:
                <input 
                    type="text" 
                    name="nomeCompleto" 
                    value={formData.nomeCompleto}
                    onChange={handleChange}
                    required
                />
            </label>
            
            <label>
                CPF:
                <input 
                    type="text" 
                    name="cpf" 
                    placeholder="123.456.789-00"
                    value={formData.cpf}
                    onChange={handleChange}
                />
            </label>
            
            <label>
                CNS:
                <input 
                    type="text" 
                    name="cns" 
                    value={formData.cns}
                    onChange={handleChange}
                />
            </label>
            
            <label>
                Data Nascimento:
                <input 
                    type="date" 
                    name="dataNascimento"
                    value={formData.dataNascimento}
                    onChange={handleChange}
                />
            </label>
            
            <label>
                Sexo:
                <select name="sexo" value={formData.sexo} onChange={handleChange}>
                    <option value="M">Masculino</option>
                    <option value="F">Feminino</option>
                    <option value="O">Outro</option>
                </select>
            </label>
            
            <label>
                Cidade:
                <input 
                    type="text" 
                    name="cidade"
                    value={formData.cidade}
                    onChange={handleChange}
                />
            </label>
            
            <label>
                UF:
                <input 
                    type="text" 
                    name="uf"
                    maxLength="2"
                    value={formData.uf}
                    onChange={handleChange}
                />
            </label>
            
            <button type="submit" disabled={loading}>
                {loading ? 'Abrindo FFA...' : 'Abrir FFA'}
            </button>
        </form>
    );
}
```

### `frontend/src/services/api.js`

```javascript
import axios from 'axios';

const api = axios.create({
    baseURL: process.env.REACT_APP_API_URL || 'http://localhost:3000/api'
});

// Adiciona token a todos os requests
api.interceptors.request.use(
    config => {
        const token = localStorage.getItem('auth_token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    error => Promise.reject(error)
);

// Handle erro de autenticação
api.interceptors.response.use(
    response => response,
    error => {
        if (error.response?.status === 401) {
            // Sessão expirou
            localStorage.removeItem('auth_token');
            localStorage.removeItem('session_id');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

export default api;
```

### `frontend/src/context/SessionContext.jsx`

```jsx
import React, { createContext, useState, useEffect } from 'react';

export const SessionContext = createContext();

export function SessionProvider({ children }) {
    const [session, setSession] = useState(null);

    useEffect(() => {
        // Restaura sessão do localStorage
        const savedSession = localStorage.getItem('session');
        if (savedSession) {
            setSession(JSON.parse(savedSession));
        }
    }, []);

    const loginSession = (sessionData) => {
        setSession(sessionData);
        localStorage.setItem('session', JSON.stringify(sessionData));
        localStorage.setItem('auth_token', sessionData.token);
    };

    const logoutSession = async () => {
        setSession(null);
        localStorage.removeItem('session');
        localStorage.removeItem('auth_token');
    };

    return (
        <SessionContext.Provider value={{ session, loginSession, logoutSession }}>
            {children}
        </SessionContext.Provider>
    );
}
```

---

## 🔧 VARIÁVEIS DE AMBIENTE

### `.env`

```
# Database
DB_HOST=localhost
DB_USER=root
DB_PASS=sua_senha
DB_NAME=pronto_atendimento

# JWT
JWT_SECRET=sua_chave_secreta_super_segura_123456

# Server
PORT=3000
NODE_ENV=development

# Frontend
REACT_APP_API_URL=http://localhost:3000/api
```

---

## 📦 DEPENDÊNCIAS RECOMENDADAS

### Backend (`package.json`)

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mysql2": "^3.0.0",
    "jsonwebtoken": "^9.0.0",
    "dotenv": "^16.0.3",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "express-rate-limit": "^6.7.0",
    "bcryptjs": "^2.4.3",
    "socket.io": "^4.6.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.22"
  }
}
```

### Frontend (`package.json`)

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "axios": "^1.3.0",
    "react-router-dom": "^6.10.0"
  },
  "devDependencies": {
    "vite": "^4.1.0"
  }
}
```

---

## ⚡ EXECUTAR LOCAL

```bash
# Backend
cd backend
npm install
npm start
# Server rodando em http://localhost:3000

# Frontend (novo terminal)
cd frontend
npm install
npm run dev
# App rodando em http://localhost:5173
```

---

## 🎯 CHECKLIST DE DESENVOLVIMENTO

### SEMANA 1 (MVP)
- [ ] Setup DB + import dump
- [ ] Backend: autenticação (login/logout)
- [ ] Backend: rotas recepcao (emitir, chamar, complementar)
- [ ] Frontend: tela login
- [ ] Frontend: tela recepcao (fila + botões)
- [ ] Frontend: modal complementação dados
- [ ] WebSocket painel público

### SEMANA 2
- [ ] Backend: triagem (vital signs)
- [ ] Backend: médico (prescrição)
- [ ] Backend: encaminhamento
- [ ] Frontend: telas triagem, médico
- [ ] Dashboard operacional

### SEMANA 3
- [ ] Backend: farmácia
- [ ] Backend: estoque
- [ ] Frontend: farmácia
- [ ] Relatórios básicos

### SEMANA 4+
- [ ] Internação
- [ ] Laboratório
- [ ] RX/Imagem
- [ ] Faturamento

---

## 🐛 DEBUG & TROUBLESHOOTING

### Error: "SQLSTATE 45000"
Seu código SQL está falhando. Verifique:
1. Sessão inválida? → `sp_sessao_assert` no início
2. Parâmetro NULL? → Validar antes de chamar
3. Permissão negada? → `sp_permissao_assert`

### Error: "SESSAO_INVALIDA"
- Token expirou
- Sessão encerrada no servidor
- IP mudou (suspeitoso)
→ Redirecione para login

### Painel público não atualiza
- WebSocket desconectado?
- Verifique conexão Socket.io
- Emitir evento: `io.emit('SENHA_CHAMADA', dados)`

### Fila lenta
- Sem índice em senhas/fila_operacional?
- Query sem WHERE?
- Muitos clientes simultâneos?
→ Adicione índices nas colunas de filtro

---

## 📞 PROCEDIMENTOS MAIS USADOS

**Diária:**
1. `sp_sessao_abrir` - Login
2. `sp_senha_emitir` - Cria senha
3. `sp_senha_chamar_proxima` - Chama fila
4. `sp_recepcao_complementar_e_abrir_ffa` - Opens chart
5. `sp_recepcao_encaminhar_ffa` - Routes to triage

**Triagem:**
6. `sp_triagem_chamar` - Calls next
7. `INSERT triagem` - Records data

**Médico:**
8. `sp_medico_chamar` - Calls next
9. `INSERT atendimento_evolucao` - Notes
10. `INSERT atendimento_prescricao` - Prescriptions
11. `sp_medico_encaminhar` - Routes to procedure/exam

---

## 🎓 RECURSOS ADICIONAIS

- Dump SQL completo: `scripts/Dump20260220.sql`
- Documentação arquitetura: `MAPA_BANCO_DADOS_COMPLETO.md`
- Diagramas de fluxo: `FLUXOS_ARQUITETURA_VISUAL.md`
- Referência procedures: `REFERENCIA_TECNICA_PROCEDURES.md`

---

**Versão:** 2.0  
**Atualizado:** 2026-02-20  
**Status:** PRONTO PARA DESENVOLVIMENTO  

### Próximo: Clone repositório, setup MySQL, e comece o backend com autenticação! 🚀
