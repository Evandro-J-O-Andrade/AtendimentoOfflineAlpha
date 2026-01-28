# HIS/PA — Rebuild do Zero (Banco + API PHP + Frontend React)

Este repositório é um **baseline “do zero”** que implementa o núcleo que você consolidou:
- **Senha/ticket é entidade primária** (totem/recepção) e **não é paciente**.
- **Paciente + FFA só nascem na recepção** na ação “complementar”.
- **Chamadas são sempre manuais** e sempre viram **evento/auditoria**.
- **Painéis são somente leitura** (consomem VWs/endpoints); não têm botões.
- **Fonte da verdade de perfis**: `usuario_sistema` (não existe `usuario_perfil`).
- **Sessão operacional** obrigatória: sistema + unidade + local (auditoria amarrada na sessão).

> Objetivo: você conseguir **rebuild completo e consistente** (sem legado), e a partir disso evoluir módulos (GLPI, farmácia, laboratório, etc.) mantendo o núcleo estável.

---

## Estrutura

- `db/schema/hispa_schema_v1.sql`  
  Banco completo: tabelas, views, functions e procedures principais (núcleo).
- `db/seed/hispa_seed_demo.sql`  
  Unidade/local/perfis/usuários de exemplo + médico(s) de plantão do dia.
- `api/`  
  API PHP (PDO + JWT) com rotas do núcleo (auth, sessão, totem, recepção, setor, print jobs).
- `frontend/`  
  React + Vite: Login → Contexto → Recepção/Setor + Totem (teste) + Print Jobs.
- `deploy/apache/`  
  Exemplo de VirtualHost e .htaccess para SPA.

---

## Pré-requisitos

- MySQL 8.x (XAMPP ok)
- Apache (XAMPP)
- Node.js 18+ (para build do frontend)

---

## Passo a passo (XAMPP / Windows)

### 1) Criar banco e importar schema

No MySQL:

```sql
CREATE DATABASE pronto_atendimento CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pronto_atendimento;

-- 1) Schema
SOURCE D:/AtendimentoOfflineAlpha/db/schema/hispa_schema_v1.sql;

-- 2) Seed demo (opcional)
SOURCE D:/AtendimentoOfflineAlpha/db/seed/hispa_seed_demo.sql;
```

### 2) Configurar API (PHP)

Arquivo: `api/src/config.php`

Ajuste se necessário:
- DB_HOST, DB_USER, DB_PASS, DB_NAME
- JWT_SECRET (**troque em produção**)

A API está em `api/public/api/index.php` (montada via Apache Alias em `/api`).

Teste rápido:
- `GET http://hispa.local/api/health`

### 3) Configurar Apache (SPA + API)

Exemplo em `deploy/apache/virtualhost-example.conf`.

Padrão recomendado:
- `DocumentRoot` → `frontend/dist`
- `Alias /api` → `api/public/api`

Para SPA funcionar (React Router), o `dist/.htaccess` deve conter o conteúdo de:
- `deploy/apache/spa-dist-htaccess.txt`

### 4) Build do Frontend

```bash
cd frontend
npm install
copy .env.example .env
npm run build
```

Depois:
- coloque o `dist/` como DocumentRoot do Apache
- copie `deploy/apache/spa-dist-htaccess.txt` para `frontend/dist/.htaccess`

Acessos:
- `http://hispa.local/` → Login
- `http://hispa.local/totem` → Totem (teste)

---

## Usuários demo (seed)

- `admin / admin123`
- `recepcao / 123`
- `triagem / 123`
- `medclin / 123`
- `medpedi / 123`

> Em produção, use `password_hash()` (bcrypt).  
> O login atual aceita **seed em texto** e também bcrypt (quando `senha_hash` começa com `$2y$`).

---

## Fluxo do Núcleo

### Totem
- `POST /api/totem/senha`
- Cria `senhas` + `fila_senha`
- **Não cria paciente/FFA**

### Recepção
- `POST /api/recepcao/chamar` (manual)
- `POST /api/recepcao/iniciar-complementacao`
- `POST /api/recepcao/salvar-complementacao`
  - cria `pessoa` + `paciente`
  - abre `ffa` vinculando a `id_senha`
  - registra auditoria
  - enfileira `print_job` (simulado)

### Setor (triagem/médico/RX/medicação)
- `POST /api/setor/encaminhar` (cria `fila_operacional`)
- `POST /api/setor/chamar` / `iniciar` / `finalizar` / `nao-atendido`
- Tudo vira evento + auditoria por sessão

---

## Padrões que já ficaram “blindados” no banco

- Manualidade: nenhuma SP “puxa próximo” automaticamente.
- Auditar sempre: procedures do núcleo chamam `sp_auditar()`.
- Separação: trilha de eventos da fila/senha e trilha assistencial (FFA/eventos).
- Sessão operacional: `sessao_operacional` é a âncora de auditoria.

---

## Próximos módulos (fora do núcleo)

O schema foi desenhado para você evoluir depois (com novas tabelas/procs), mas o núcleo já está “fechado”:
- GLPI/Chamados multiárea
- Farmácia (assistencial + GPAT externo + PDV rua)
- Laboratório terceirizado com protocolo interno/código de barras
- Registros profissionais genéricos (CRM/COREN/CRF)
- Remoção/ambulância/SAMU com senha especial rastreável

---

## Observações importantes

- Se você for migrar dados do seu dump atual, faça por ETL:
  - **senhas antigas** → `senhas`
  - **fila antiga** → `fila_senha` / `fila_operacional`
  - pacientes existentes podem ser importados para `pessoa`/`paciente`, mas **não misture com a regra do totem** (senha não é paciente).
- Este baseline evita “legado”, mas mantém o caminho aberto para importar o que você já tem.

