# MODELO_DOMINIO_CANONICO.md

## Entidades Canônicas da Plataforma

### 1. SAAS_ENTIDADE (SaaS Entidade)

Entidade cliente da plataforma. Todos os dados pertencem a uma SaaS Entidade.

```sql
saas_entidade (
    id_saas_entidade PK,
    nome_fantasia,
    razao_social,
    cnpj,
    logo_url,
    cor_primaria,
    cor_secundaria,
    ativo,
    created_at,
    updated_at
)
```

### 2. PESSOA

Entidade raiz do sistema. Toda identidade humana deve originar-se em Pessoa.

```sql
pessoa (
    id_pessoa PK,
    nome,
    data_nascimento,
    sexo,
    cpf,
    rg,
    telefone,
    email,
    endereco,
    created_at,
    updated_at
)
```

### 3. USUARIO

Representa a identidade digital utilizada para autenticação.

```sql
usuario (
    id_usuario PK,
    id_pessoa FK,
    login,
    senha_hash,
    ativo,
    data_criacao,
    data_atualizacao
)
```

### 4. SESSAO_USUARIO

Sessão é a identidade operacional da plataforma.

```sql
sessao_usuario (
    id_sessao_usuario PK,
    id_usuario FK,
    id_saas_entidade FK,
    token,
    refresh_token,
    data_criacao,
    data_expiracao,
    ativo
)
```

### 5. CONTEXTO_OPERACIONAL

Unidade, Local, Setor, Sala, Painel, Guichê.

```sql
contexto_operacional (
    id_contexto PK,
    id_saas_entidade FK,
    tipo (UNIDADE | LOCAL | SETOR | SALA | PAINEL | GUICHE),
    id_referencia,
    nome,
    codigo,
    ativo
)
```

### 6. APLICACAO

Aplicações são módulos independentes hospedados na plataforma.

```sql
aplicacao (
    id_aplicacao PK,
    id_saas_entidade FK,
    nome,
    codigo,
    descricao,
    rota,
    icone,
    ativo
)
```

### 7. EVENTO

Todo evento relevante é registrado.

```sql
evento (
    id_evento PK,
    id_sessao_usuario FK,
    id_aplicacao FK,
    id_contexto FK,
    tipo,
    categoria,
    acao,
    payload,
    resultado,
    data_hora,
    ip_origem
)
```

### 8. AUDITORIA

Rastreabilidade completa.

```sql
auditoria (
    id_auditoria PK,
    id_evento FK,
    id_usuario FK,
    acao,
    tabela,
    id_registro,
    dados_antigos,
    dados_novos,
    data_hora,
    ip_origem
)
```

---

## Domínio Assistencial (Aplicação Assistencial)

### SEQUÊNCIA OBRIGATÓRIA

```
Pessoa → Senha → FFA → GPAT → Atendimento
```

### Senha

Início do episódio assistencial.

```sql
senha (
    id_senha PK,
    id_pessoa FK,
    id_unidade FK,
    numero,
    tipo,
    prioridade,
    status,
    data_criacao,
    data_chamacao
)
```

### FFA (Ficha de Atendimento)

Container operacional do episódio assistencial.

```sql
ffa (
    id_ffa PK,
    id_senha FK,
    id_pessoa FK,
    id_unidade FK,
    id_local FK,
    id_usuario_criacao FK,
    status,
    data_criacao,
    data_fechamento
)
```

### GPAT (Gestão de Protocolo de Atendimento)

Identifica o episódio assistencial.

```sql
gpat (
    id_gpat PK,
    id_ffa FK,
    codigo,
    status,
    data_geracao,
    data_validacao
)
```

---

## PROIBIÇÕES CANÔNICAS

- Não criar tabelas `paciente_v2`, `cliente_novo`, `usuario_alt`
- Não criar procedures `sp_novo`, `sp_revisado`, `sp_v3`
- Toda entidade nova deve seguir o modelo canônico de auditoria
- Toda operação deve gerar evento
- Toda operação assistencial deve obedecer Pessoa → Senha → FFA → GPAT