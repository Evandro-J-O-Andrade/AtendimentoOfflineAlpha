# MAPA DE INTEGRAÇÃO: FRONTEND → API → SP → TABELAS

## VISÃO GERAL DO SISTEMA

Este documento mostra como cada página do frontend se comunica com o banco de dados através das rotas do backend e Stored Procedures (SPs).

---

## 1. FLUXO DE AUTENTICAÇÃO

### Login (/login)
- **Frontend**: `frontend/src/apps/operacional/pages/Login.jsx`
- **API**: `POST /api/auth/login`
- **Backend**: `backend/src/routes/authRoutes.js` → `authController.js`
- **SP**: `sp_auth_login`
- **Tabelas**: `usuario`, `sessao_usuario`, `perfil`, `usuario_perfil`

### Seleção de Contexto (/contexto)
- **Frontend**: `frontend/src/apps/operacional/pages/contexto/SelecionarContexto.jsx`
- **API**: `GET /api/auth/meus-contextos`
- **Backend**: `backend/src/routes/authRoutes.js`
- **SP**: `sp_auth_permissoes` ou `sp_contextos_listar`
- **Tabelas**: `usuario`, `usuario_unidade`, `usuario_local_operacional`, `unidade`, `local_operacional`

---

## 2. MÓDULO RECEPÇÃO

### Página: Recepção.jsx
- **Frontend**: `frontend/src/apps/operacional/pages/recepcao/Recepcao.jsx`
- **Endpoints chamados**:
  1. `GET /api/operacional/pacientes?termo=X` - Buscar pacientes
  2. `POST /api/operacional/atendimentos` - Criar atendimento
  3. `POST /api/operacional/senhas` - Emitir senha

### Rotas do Backend:
- `backend/src/routes/operacionalRoutes.js`
- `backendelRoutes.js`

/src/routes/pain### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Buscar pacientes | `sp_paciente_buscar` | `paciente`, `pessoa` |
| Criar atendimento | `sp_master_atendimento_iniciar` | `atendimento`, `ffa`, `fila_operacional` |
| Emitir senha | `sp_master_senha_emitir` | `senha`, `fila_operacional` |
| Complementar senha | `sp_recepcao_iniciar_complementacao` | `senha` |
| Abrir FFA | `sp_recepcao_complementar_e_abrir_ffa` | `ffa`, `fila_operacional` |

---

## 3. MÓDULO TRIAGEM

### Página: Triagem.jsx
- **Frontend**: `frontend/src/apps/operacional/pages/triagem/Triagem.jsx`
- **Endpoints chamados**:
  1. `POST /api/operacional/atendimentos/chamar` - Chamar paciente
  2. `PUT /api/operacional/atendimentos/:id` - Atualizar triagem
  3. `POST /api/operacional/atendimentos/:id/encaminhar` - Encaminhar

### Rotas do Backend:
- `backend/src/routes/filaRoutes.js`
- `backend/src/routes/dispatcherRoutes.js`

### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Listar fila | Query direta com JOIN | `fila_operacional`, `paciente`, `local_operacional`, `unidade` |
| Chamar paciente | `sp_fila_chamar_proxima` | `fila_operacional`, `senha` |
| Classificar triagem | `sp_triagem_classificar_senha` | `senha`, `fila_operacional` |
| Finalizar triagem | `sp_triagem_finalizar` | `fila_operacional` |
| Encaminhar | `sp_recepcao_encaminhar_ffa` | `fila_operacional`, `ffa` |

---

## 4. MÓDULO ATENDIMENTO MÉDICO

### Página: Medico.jsx
- **Frontend**: `frontend/src/apps/operacional/pages/medico/Medico.jsx`
- **Endpoints chamados**:
  1. `POST /api/operacional/atendimentos/chamar` - Chamar paciente
  2. `PUT /api/operacional/atendimentos/:id` - Atualizar atendimento
  3. `POST /api/operacional/atendimentos/:id/encaminhar` - Encaminhar

### Rotas do Backend:
- `backend/src/routes/filaRoutes.js`
- `backend/src/routes/painelRoutes.js`
- `backend/src/routes/dispatcherRoutes.js`

### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Listar fila | Query direta com JOIN | `fila_operacional`, `paciente`, `local_operacional`, `unidade` |
| Chamar paciente | `sp_fila_chamar_proxima` | `fila_operacional`, `senha` |
| Iniciar atendimento | `sp_atendimento_transicionar` | `atendimento`, `fila_operacional` |
| Encaminhar | `sp_medico_encaminhar` | `fila_operacional`, `ffa` |
| Finalizar | `sp_medico_finalizar` | `fila_operacional`, `atendimento` |
| Marcar retorno | `sp_medico_marcar_retorno` | `senha`, `atendimento` |

---

## 5. MÓDULO ENFERMAGEM

### Página: Enfermagem.jsx
- **Frontend**: `frontend/src/apps/operacional/pages/enfermagem/Enfermagem.jsx`
- **Endpoints chamados**:
  1. `POST /api/operacional/atendimentos/chamar` - Chamar paciente
  2. `PUT /api/operacional/atendimentos/:id` - Atualizar

### Rotas do Backend:
- `backend/src/routes/filaRoutes.js`
- `backend/src/routes/dispatcherRoutes.js`

### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Listar fila | Query direta com JOIN | `fila_operacional`, `paciente`, `local_operacional` |
| Chamar | `sp_fila_chamar_proxima` | `fila_operacional` |
| Transicionar | `sp_atendimento_transicionar` | `atendimento`, `fila_operacional` |
| Registrar administração | `sp_master_registrar_administracao_medicacao` | `administracao_medicacao`, `prescricao` |

---

## 6. MÓDULO FARMÁCIA

### Página: Farmacia.jsx
- **Frontend**: `frontend/src/apps/operacional/pages/farmacia/Farmacia.jsx`
- **Endpoints chamados**:
  1. `GET /api/operacional/farmacia/historico` - Histórico
  2. `GET /api/operacional/farmacia/buscar?termo=X` - Buscar medicamentos
  3. `POST /api/operacional/farmacia/dispensar` - Dispensar
  4. `POST /api/operacional/farmacia/:id/finalizar` - Finalizar dispensação

### Rotas do Backend:
- `backend/src/routes/farmaciaRoutes.js`
- `backend/src/routes/painelRoutes.js`

### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Listar pendentes | Query com JOIN | `farmacia_dispensacao`, `paciente`, `usuario` |
| Buscar medicamentos | `sp_estoque_buscar` | `estoque_produto`, `estoque_lote` |
| Dispensar | `sp_farmacia_dispensar_registrar` | `farmacia_dispensacao`, `estoque_lote` |
| Histórico | Query com JOIN | `farmacia_dispensacao`, `paciente` |
| Prescrições | Query com JOIN | `prescricao`, `prescricao_item`, `medicamento` |

---

## 7. PAINEL DE CHAMADAS

### Página: Painel.jsx
- **Frontend**: `frontend/src/apps/painel/pages/Painel.jsx`
- **Endpoint**: `GET /api/painel/painel`
- **Rota**: `backend/src/routes/painelRoutes.js`

### Tipos de Painel:
| Tipo | SP | Tabelas |
|------|-----|---------|
| Recepção | `sp_painel_listar_recepcao` | `painel`, `senha` |
| Triagem | `sp_painel_listar_triagem` | `painel`, `senha`, `fila_operacional` |
| Clínico | `sp_painel_listar_clinico` | `painel`, `senha`, `fila_operacional` |
| Pediátrico | `sp_painel_listar_pediatrico` | `painel`, `senha`, `fila_operacional` |
| TV Rotativa | `sp_painel_tv_rotativa` | `painel`, `fila_operacional` |

---

## 8. TOTEM

### Página: Totem.jsx
- **Frontend**: `frontend/src/apps/totem/pages/Totem.jsx`
- **Endpoint**: `POST /api/totem/gerar-senha`
- **Rota**: `backend/src/routes/totemRoutes.js`

### SPs utilizadas:
| Ação | SP | Tabelas |
|------|-----|---------|
| Gerar senha | `sp_totem_gerar_senha` | `senha`, `fila_operacional` |
| Consultar senha | `sp_totem_consultar` | `senha`, `fila_operacional` |
| Cancelar senha | `sp_painel_cancelar_senha` | `senha`, `fila_operacional` |

---

## 9. MAPA COMPLETO DE ROTAS

### Auth (authRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| POST | /api/auth/login | `sp_auth_login` | Todos |
| POST | /api/auth/logout | `sp_auth_logout` | Todos |
| GET | /api/auth/meus-contextos | `sp_auth_permissoes` | Todos |
| POST | /api/auth/selecionar-contexto | `sp_auth_criar_sessao` | Todos |

### Operacional (operacionalRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| GET | /api/operacional/pacientes | `sp_paciente_buscar` | Recepção |
| POST | /api/operacional/atendimentos | `sp_master_atendimento_iniciar` | Recepção |
| POST | /api/operacional/senhas | `sp_master_senha_emitir` | Recepção |

### Fila (filaRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| GET | /api/fila | Query direta | Triagem/Médico/Enfermagem |
| POST | /api/fila/chamar | `sp_fila_chamar_proxima` | Triagem/Médico/Enfermagem |
| POST | /api/fila/iniciar-atendimento | `sp_atendimento_transicionar` | Triagem/Médico/Enfermagem |
| POST | /api/fila/finalizar | `sp_fila_finalizar` | Triagem/Médico/Enfermagem |
| POST | /api/fila/encaminhar | `sp_medico_encaminhar` | Médico |

### Farmacia (farmaciaRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| GET | /api/farmacia/pendentes | Query direta | Farmácia |
| GET | /api/farmacia/medicamentos | `sp_estoque_buscar` | Farmácia |
| POST | /api/farmacia/dispensar | `sp_farmacia_dispensar_registrar` | Farmácia |
| GET | /api/farmacia/historico | Query direta | Farmácia |

### Painel (painelRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| GET | /api/painel/painel | `sp_painel_listar` | Painel |
| POST | /api/painel/chamar | `sp_senha_chamar` | Recepção/Triagem/Médico |

### Totem (totemRoutes.js)
| Método | Endpoint | SP | Perfil |
|--------|----------|-----|--------|
| POST | /api/totem/gerar-senha | `sp_totem_gerar_senha` | Totem |
| GET | /api/totem/consultar/:senha | `sp_totem_consultar` | Totem |

### Dispatcher (dispatcherRoutes.js)
Rota genérica que redireciona para SPs específicas baseado na ação:

| Ação | SP | Contexto |
|------|-----|----------|
| ATENDIMENTO_INICIAR | `sp_master_atendimento_iniciar` | ATENDIMENTO |
| ATENDIMENTO_TRANSICIONAR | `sp_master_atendimento_transicionar` | ATENDIMENTO |
| ATENDIMENTO_FINALIZAR | `sp_master_atendimento_finalizar` | ATENDIMENTO |
| SENHA_EMITIR | `sp_master_senha_emitir` | SENHA |
| CHAMAR_SENHA | `sp_master_chamar_senha` | SENHA |
| TRIAGEM_CLASSIFICAR | `sp_triagem_classificar_senha` | TRIAGEM |
| FFA_CRIAR | `sp_ffa_criar` | FFA |
| ADMINISTRACAO_MEDICACAO | `sp_master_registrar_administracao_medicacao` | FARMACIA |
| REGISTRAR_ALERTA | `sp_master_registrar_alerta` | ALERTA |
| AGENDA_DISPONIBILIDADE | `sp_master_agenda_disponibilidade` | AGENDA |

---

## 10. TABELAS PRINCIPAIS DO SISTEMA

### Núcleo de Usuários
- `usuario` - Usuários do sistema
- `pessoa` - Dados pessoais
- `perfil` - Perfis de acesso
- `usuario_perfil` - Vínculo usuário-perfil
- `sessao_usuario` - Sessões ativas
- `usuario_unidade` - Vínculo usuário-unidade
- `usuario_local_operacional` - Vínculo usuário-local

### Estrutura Organizacional
- `unidade` - Unidades de saúde
- `local_operacional` - Locais (salas, guichês)
- `especialidade` - Especialidades médicas

### Paciente
- `paciente` - Cadastro de pacientes
- `pessoa` - Dados pessoais (comum com usuário)

### Atendimento
- `atendimento` - Atendimentos
- `fila_operacional` - Fila de atendimento
- `senha` - Senhas emitidas
- `ffa` - Prontuário/Formulário de Atendimento

### Prescrição e Medicação
- `prescricao` - Prescrições médicas
- `prescricao_item` - Itens da prescrição
- `medicamento` - Catálogo de medicamentos
- `administracao_medicacao` - Registros de administração
- `prescricao_uso` - Tipos de uso

### Farmácia
- `farmacia_dispensacao` - Dispensações
- `estoque_produto` - Produtos em estoque
- `estoque_lote` - Lotes de produtos
- `estoque_movimento` - Movimentos de estoque

### Painel e Totem
- `painel` - Cadastro de painéis
- `painel_tipo` - Tipos de painel
- `dispositivo` - Dispositivos (totem, kiosk)

---

## 11. PERFIS DO SISTEMA

| Código | Descrição | Módulos Permitidos |
|--------|-----------|-------------------|
| ROOT | Administrador full | Todos |
| ADMIN | Administrador | Admin, Relatórios |
| ADMINISTRATIVO | Administrativo | Recepção, Pacientes |
| SUPORTE_TI | Suporte TI | Todos (visualizar) |
| MEDICO | Médico | Médico, Prescrição |
| ENFERMAGEM | enfermagem | Enfermagem, Triagem |
| FARMACIA | Farmacêutico | Farmácia |
| CAIXA | Caixa farmácia | Farmácia Rua |
| PAINEL | Painel | Visualização |
| TOTEM | Totem | Geração de senha |

---

## 12. VERIFICAÇÃO DE JOINs

### ✅ JOINs já implementados corretamente:

#### fila_operacional (filaRoutes.js)
```sql
fila_operacional fo
LEFT JOIN paciente p ON p.id = fo.id_paciente
LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
LEFT JOIN unidade u ON u.id_unidade = fo.id_unidade
```

#### farmacia_dispensacao (farmaciaRoutes.js)
```sql
farmacia_dispensacao fd
LEFT JOIN paciente p ON p.id = fd.id_paciente
LEFT JOIN usuario u ON u.id_usuario = fd.id_solicitante
```

#### prescricao (farmaciaRoutes.js)
```sql
prescricao p
LEFT JOIN usuario m ON m.id_usuario = p.id_medico
LEFT JOIN prescricao_item mp ON mp.id_prescricao = p.id_prescricao
LEFT JOIN medicamento med ON med.id_medicamento = mp.id_medicamento
```

### ⚠️ Pontos de atenção:
1. Verificar se `sp_master_dispatcher` retorna dados completos do paciente
2. Verificar se FFA/prontuário está com JOIN para pessoa/paciente
3. Verificar se senhas estão com dados do paciente

---

## 13. RESUMO: FRONTEND ↔ BACKEND ↔ BANCO

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND                                │
│  Login.jsx → SelecionarContexto.jsx → Recepcao/Triagem/etc   │
└────────────────────────────┬────────────────────────────────────┘
                             │ authFetch() / fetch()
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        BACKEND                                 │
│  authRoutes.js → operacionalRoutes.js → filaRoutes.js etc    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              sp_master_dispatcher                       │   │
│  │    (Orquestrador central de todas as ações)            │   │
│  └────────────────────────────┬────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │ CALL sp_xxx()
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BANCO DE DADOS                            │
│  usuario | paciente | atendimento | fila_operacional | senha   │
│  ffa | prescricao | farmacia_dispensacao | estoque_xxx        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 14. PRÓXIMOS PASSOS

1. ✅ Verificar se todas as páginas chamam APIs corretas
2. ✅ Mapear endpoints → SPs → tabelas
3. ✅ Verificar JOINs implementados
4. [ ] Testar integração completa (login → contexto → fila)
5. [ ] Verificar se SPs retornam dados completos para frontend
6. [ ] Criar seed para popular banco com dados de teste
