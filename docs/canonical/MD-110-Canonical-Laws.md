# MD-110 — Canonical Laws

## Status

Documento Canônico Supremo.
Consolida todas as leis canônicas da Plataforma New Wave Enterprise.

---

## Objetivo

Ser a fonte única de verdade para todas as regras, princípios e leis que governam a plataforma.

---

## Princípio Fundamental

```text
Este documento é a lei máxima.
Nenhuma implementação pode contradizer o MD-110.
Qualquer divergência exige atualização deste documento.
Nenhuma alteração em MD-110 é feita sem discussão arquitetônica.
```

---

## Leis Supremas

### LEI 01 — Portal é a Porta

```text
Todo acesso começa no Portal.
Nenhuma app abre diretamente.
Nenhum módulo operacional é acessado por URL direta.
Fluxo obrigatório:
  Login → Portal → App Registry → App → Contexto → Dashboard → Operação
```

---

### LEI 02 — Apps Executam Negócio

```text
Portal orquestra.
Apps executam.
Portal não faz regra de negócio.
Apps são registradas, não hardcoded.
Toda app respeita Design System.
```

---

### LEI 03 — IA Auxilia, Não Decide

```text
IA sugere.
IA analisa.
IA resume.
IA não altera dados sem autorização humana explícita.
Decisão final é sempre humana.
Todo output de IA é auditável.
```

---

### LEI 04 — Nenhum Dado Fica Isolado

```text
Dado isolado é risco.
Dado conectado é poder.
Customer 360 unifica toda visão de cliente.
Knowledge Graph conecta entidades.
Event Store registra tudo.
Data Lakehouse centraliza inteligência.
```

---

### LEI 05 — Regra de Negócio Pertence à SP

```text
Nenhuma regra de negócio no frontend.
Nenhuma regra de negócio no backend Node.
Nenhum CRUD direto.
Toda escrita passa por Stored Procedure.
SP é a única porta de escrita no banco.
Frontend exibe. Backend roteia. SP executa.
```

---

### LEI 06 — Nenhuma App Roda Sem Registry

```text
Toda capacidade da plataforma é uma App registrada.
App sem Registry não existe.
App sem IAM não abre.
App opera dentro do Shell.
App respeita Design System.
```

---

### LEI 07 — Nenhuma Integração Sem IAM

```text
Toda integração exige identidade.
Toda integração exige permissão.
Toda integração exige token válido.
OAuth2, JWT, mTLS são obrigatórios conforme o caso.
Sem IAM, sem acesso.
```

---

### LEI 08 — Automação Sem Governança é Risco

```text
N8N é infraestrutura, não ferramenta isolada.
Todo workflow é versionado.
Todo workflow é auditado.
Workflow sem aprovação não vai para produção.
Credenciais no Vault, nunca no código.
```

---

### LEI 09 — Expansão Sem Ilhas

```text
Toda nova app entra pelo Registry.
Toda nova app usa IAM canônico.
Toda nova app usa Dispatcher canônico.
Toda nova app emite eventos.
Toda nova app usa Design System.
Nenhuma app cria próprio banco, próprio login, própria auditoria.
Ecossistema forte não tem ilhas.
```

---

### LEI 10 — A Experiência é Única

```text
Multi-tenant, mas experiência unificada.
Multi-app, mas Shell único.
Multi-dispositivo, mas contexto fluido.
Design System canônico.
White label muda marca, não experiência.
Multi-brand muda posicionamento, não core.
```

---

### LEI 11 — Authorization is Decision

```text
Acesso não é cargo.
Acesso é decisão.
Decisão é:
  identidade + tenant + app + escopo + permissão + contexto.
IAM decide. Nenhuma app decide.
Decisão é centralizada, auditável e multi-tenant.
```

---

### LEI 12 — Identidade é Permanente, Contexto é Variável

```text
Usuário não muda.
Contexto muda.
Um usuário pode operar em múltiplos tenants, unidades, locais e perfis.
Sem criar nova conta.
Sem perder histórico.
Sem perder permissões.
```

---

### LEI 13 — Senha é a Entrada Operacional do HIS

```text
Paciente existe no cadastro mestre.
Operacionalmente, quem entra no fluxo é a Senha.
Fluxo canônico:
  Senha → Fila → FFA → Atendimento → Triagem → Execução → Farmácia → Faturamento
Nenhuma operação clínica começa sem senha.
Nenhum atendimento é criado sem senha.
```

---

### LEI 14 — Multi-Tenant é Transversal

```text
Tenant é a primeira dimensão de tudo.
Todo dado carrega id_tenant.
Toda query filtra por tenant.
Todo evento registra tenant.
Todo usuário pertence a tenant.
Nenhuma operação cruza tenants sem autorização explícita.
```

---

### LEI 15 — Evento é Rastro Oficial

```text
Sem evento não existe operação.
Evento é imutável.
Evento é append-only.
Evento é consultável.
Evento é a memória da plataforma.
Todo evento relevante é registrado no Event Store canônico (kernel_ledger).
```

---

### LEI 16 — Cache é Atalho, Não Verdade

```text
Cache nunca é fonte da verdade.
Cache é derivado do banco ou do Event Store.
Cache é invalidado por evento.
Cache é invalidado por mudança de contexto.
Cache não serve para decisão de negócio.
Cache serve para performance.
```

---

### LEI 17 — Frontend é Janela, Não Cérebro

```text
Frontend exibe.
Frontend captura input.
Frontend chama API.
Frontend não decide regra de negócio.
Frontend não valida permissão.
Frontend não acessa banco.
Frontend é a projeção do motor.
```

---

### LEI 18 — Backend é Porteiro, Não Juiz

```text
Backend valida sessão.
Backend valida contexto.
Backend roteia para Dispatcher.
Backend não decide regra de negócio.
Backend não altera dados diretamente.
Backend é a camada de transporte confiável.
```

---

### LEI 19 — Dispatcher Orquestra, Não Executa

```text
Dispatcher valida contrato.
Dispatcher valida permissão.
Dispatcher chama SP.
Dispatcher registra evento.
Dispatcher não executa regra de negócio.
Dispatcher é o maestro. SP é o músico.
```

---

### LEI 20 — N8N é Patrimônio, Não Brinquedo

```text
Automação é estratégica.
Workflow é código.
Workflow é governado.
Workflow é testado.
Workflow é auditado.
Automação sem governança é risco.
Automação com governança é poder.
```

---

### LEI 21 — Banco é a Fonte da Verdade

```text
MySQL é a fonte da verdade.
Nenhuma camada acima do banco é fonte de verdade.
Frontend nunca é fonte da verdade.
IA nunca é fonte da verdade.
N8N nunca é fonte da verdade.
Node/Backend nunca é fonte da verdade.
Cache nunca é fonte da verdade.
```

---

## Matriz de Responsabilidade

| Camada | Decidir | Validar | Executar | Escrever | Exibir |
|--------|---------|---------|----------|----------|--------|
| Frontend | ❌ | ❌ | ❌ | ❌ | ✅ |
| Backend | ❌ | ✅ | ❌ | ❌ | ❌ |
| Dispatcher | ❌ | ✅ | ✅ (roteia) | ❌ | ❌ |
| SP | ✅ | ✅ | ✅ | ✅ | ❌ |
| Event Store | ❌ | ✅ | ✅ (registra) | ✅ (append) | ❌ |
| IA | ❌ | ❌ | ✅ (sugere) | ❌ | ✅ (sugere) |
| N8N | ❌ | ❌ | ✅ (automa) | ✅ (via SP) | ❌ |

---

## Hierarquia de Verdade

```
BANCO (MySQL)
  └── Fonte da Verdade
      └── Stored Procedures
          └── Regra de Negócio Canônica
              └── Event Store (kernel_ledger)
                  └── Rastro Oficial
                      └── Analytics (derivado)
                          └── BI / Dashboards (derivado)
                              └── Frontend (leitura/projeção)
                                  └── Cache (atalho)
```

---

## Anti-Patterns Proibidos

```text
❌ Regra de negócio em controller
❌ Regra de negócio em service
❌ Regra de negócio em middleware
❌ Regra de negócio em frontend
❌ Regra de negócio em N8N
❌ Regra de negócio em IA
❌ CRUD direto em tabela
❌ SELECT sem filtro de tenant
❌ INSERT/UPDATE/DELETE sem SP
❌ SELECT em tabela de outro tenant
❌ Frontend decide permissão
❌ App decide acesso
❌ Dados hardcoded no frontend
❌ Token em localStorage (proibido por SEGURANCA_CANONICA)
❌ Prompt sem auditoria
❌ Workflow sem aprovação
❌ Evento sem tenant
❌ Deleção física de dado (sempre soft delete com auditoria)
```

---

## Integrações

```text
Todos os MDs canônicos (MD-001 até MD-110) são complementares.
Em caso de conflito, MD-110 prevalece.
Qualquer alteração em MD-110 impacta toda a plataforma.
Mudança em MD-110 exige revalidação de todos os MAPs e BRs dependentes.
```

---

## Lei Final Absoluta

```text
A plataforma existe para amplificar
a capacidade humana de criar,
decidir e crescer.

Tecnologia é meio.
Pessoa é fim.
Dados são ativos.
Conhecimento é poder.

Banco é a Fonte da Verdade.
SP é a porta de entrada.
Evento é a memória.
Portal é a porta.
Apps executam.
IA auxilia.
Contexto é chave.
Tenant é ilha.
Plataforma é oceano.

E a lei é uma só:
  Nada existe fora do Banco.
  Nada existe fora do Contexto.
  Nada existe fora do Evento.
  Nada existe fora da Lei Canônica.
```

---

Documento Canônico Supremo — MD-110

**Esta é a lei final do projeto AtendimentoOfflineAlpha.**
