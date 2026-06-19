# MD-017 — Multi-Tenant

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o modelo multi-tenant como camada transversal obrigatória, garantindo isolamento físico, lógico e de auditoria entre todos os tenants da plataforma.

---

## Princípio Fundamental

```text
Nenhum dado de tenant alcança outro tenant.
Nenhuma operação cruza fronteira de tenant.
Nenhum recurso é compartilhado sem autorização explícita.
```

---

## Modelo De Tenant

### O Que É Um Tenant

```text
Cliente da plataforma SaaS.
Unidade organizacional independente.
Possui próprios usuários, unidades, locais, configurações.
Possui próprias aplicações ativas.
Possui próprio isolamento de dados.
```

### Estrutura Canônica

```text
Tenant
 ├─ Organização (dados da empresa)
 ├─ Unidades (filiais, clínicas, centros)
 ├─ Locais (salas, setores, consultórios)
 ├─ Usuários
 ├─ Perfis
 ├─ Permissões
 ├─ Aplicações Ativas
 ├─ Configurações
 ├─ Tema/Branding
 └─ Eventos (isolados)
```

---

## Isolamento

### Isolamento Físico

```text
Banco de dados segregado por tenant (preferencial)
Schema por tenant (alternativa viável)
Partição de tabelas por tenant (cenários específicos)
Storage segregado por tenant
Cache segregado por tenant
```

### Isolamento Lógico

```text
Toda query contém filtro de tenant
Toda stored procedure recebe id_tenant como primeiro parâmetro
Toda entidade canônica possui id_tenant
Views e relatórios filtram por tenant
APIs validam tenant em cada requisição
```

### Isolamento De Auditoria

```text
Eventos são indexados por tenant
Consultas de auditoria requerem tenant válido
Exportação de auditoria é por tenant
Backup respeita tenant
Retenção pode ser configurada por tenant
```

### Isolamento De Aplicação

```text
Aplicação pertence a um tenant
Usuário pertence a um tenant
Contexto operacional pertence a um tenant
Nenhuma operação cruza tenant
```

---

## Regras De Isolamento

1. Toda entidade canônica contém id_tenant.
2. Nenhuma query cruza dados de tenants diferentes.
3. Nenhuma SP executa sem validação de tenant proprietário.
4. Nenhuma API retorna dados de tenant diferente do autenticado.
5. Nenhum cache compartilha dados entre tenants.
6. Nenhum arquivo é acessível por tenant diferente do proprietário.
7. Nenhum relatório cruza dados de tenants sem autorização multi-tenant explícita.
8. Nenhuma operação de IA acessa dados de outro tenant.

---

## Estrutura Física Do Multi-Tenant

### Banco De Dados

```
TENANT_A
  ├─ auth
  ├─ contexto
  ├─ dominio_his
  ├─ dominio_pdv
  ├─ dominio_crm
  ├─ dominio_sac
  ├─ dominio_cat
  ├─ dominio_farmacia
  ├─ dominio_estoque
  ├─ dominio_financeiro
  ├─ dominio_faturamento
  ├─ evento
  ├─ auditoria
  └─ configuracao

TENANT_B
  └─ (estrutura idêntica, isolada)
```

### Alternativa: Schema Por Tenant

```
auth
contexto
evento
auditoria
TENANT_A.dominio_his
TENANT_A.dominio_pdv
TENANT_B.dominio_his
TENANT_B.dominio_pdv
```

### Alternativa: Tabela Com id_tenant

```sql
SELECT * FROM paciente WHERE id_tenant = ? AND id_unidade = ?
```

---

## Configuração Por Tenant

### Metadados Do Tenant

```json
{
  "id_tenant": 0,
  "codigo": "HOSPITAL_X",
  "nome": "Hospital X",
  "ativo": true,
  "tema": {
    "cor_primaria": "#0066CC",
    "logo": "https://...",
    "fonte": "Inter"
  },
  "configuracoes": {
    "modulo_his": true,
    "modulo_pdv": false,
    "modulo_crm": true,
    "max_usuarios": 500,
    "retencao_eventos_meses": 84
  },
  "unidades": [1, 2, 3],
  "data_criacao": "datetime",
  "data_atualizacao": "datetime"
}
```

---

## Fluxo De Isolamento

```
Requisição Entra
  ↓
JWT Extrai id_sessao
  ↓
Session Valida id_tenant
  ↓
Dispatcher Valida Contexto É Do Tenant
  ↓
SP Recebe id_tenant Como Primeiro Parâmetro
  ↓
SP Valida Recurso Pertence Ao Tenant
  ↓
Execução Isolada
  ↓
Evento Registrado Com id_tenant
```

---

## Validações Obrigatórias

### Em Toda Stored Procedure

```sql
CREATE PROCEDURE sp_paciente_buscar
  @id_sessao INT,
  @id_tenant INT,
  @id_paciente INT
AS
BEGIN
  EXEC sp_sessao_assert @id_sessao, @id_tenant;
  
  IF NOT EXISTS (
    SELECT 1 FROM paciente p
    WHERE p.id_paciente = @id_paciente
      AND p.id_tenant = @id_tenant
  )
  BEGIN
    RAISERROR('Paciente não pertence ao tenant', 16, 1);
    RETURN;
  END
  
  -- execução segura
END
```

---

## Acesso Cross-Tenant

### Quando É Permitido

```text
Plataforma (super admin): acesso supervisão
Auditoria regulatória: mediante ordem judicial
Consolidação grupo empresarial: mediante configuração multi-tenant explícita
```

### Quando É Proibido

```text
Operação normal de qualquer usuário
IA executando ações
Integração automática
Sincronização entre tenants
Relatório cross-tenant sem autorização explícita
```

---

## Provisionamento

### Ciclo De Vida Do Tenant

```text
Provisionamento
  ↓
Criação de estrutura (banco, schemas, configurações)
  ↓
Carregamento de dados iniciais (se necessário)
  ↓
Ativação
  ↓
Operação normal
  ↓
Atualizações de configuração
  ↓
Suspensão (opcional)
  ↓
Arquivo (dados consolidados, leitura apenas)
  ↓
Exclusão (conforme regulamentação e política)
```

### Provisionamento Automatizado

```text
Novo tenant solicita acesso
  ↓
Plataforma cria estrutura
  ↓
Aplicações padrão são ativadas
  ↓
Admin do tenant é criado
  ↓
Email de boas-vindas enviado
  ↓
Tenant operacional
```

---

## Backup E Recuperação

### Por Tenant

```text
Backup individual por tenant
Restauração de tenant individual
Retenção configurável por tenant
RPO (Recovery Point Objective) por criticidade
RTO (Recovery Time Objective) por plano de serviço
```

### Estratégias

```text
Backup diário para todos os tenants
Backup em tempo real para tenants de saúde
Replicação cross-region para tenants empresariais
Teste de restauração periódico por tenant
Disaster recovery drill semestral
```

---

## Monitoramento

### Métricas Por Tenant

```text
Uso de banco de dados
Consultas por segundo
Armazenamento utilizado
Eventos gerados por dia
Usuários ativos
Aplicações ativas
Sincronizações pendentes
Taxa de erro por tenant
```

### Alertas

```text
Quota de armazenamento atingida
Quota de eventos atingida
Taxa de erro acima do limite
Falhas de sincronização recorrentes
Uso anômalo de recursos
```

---

## Proibições

São proibidos:

```text
Query sem filtro de tenant
SP sem validação de tenant
API retornando dados de tenant diferente
Cache compartilhado entre tenants
Log misturando tenants diferentes
Backup misturando tenants diferentes
Exportação cross-tenant sem autorização
IA acessando dados de outro tenant
Disparo de webhook para endpoint de outro tenant
Configuração de um tenant aplicada a outro
```

---

## Lei Do Multi-Tenant

```text
Tenant é nação.
Dados não cruzam fronteira.
Isolamento é absoluto.
```

---

## Responsabilidades

Time De Plataforma É Responsável Por:

```text
Implementar isolamento multi-tenant
Manter estrutura segregada por tenant
Garantir performance por tenant
Gerenciar provisionamento e ciclo de vida
Monitorar por tenant
Implementar backup e recuperação por tenant
Documentar políticas de isolamento
```

Times De Aplicação São Responsáveis Por:

```text
Incluir id_tenant em toda operação
Validar tenant antes de executar
NÃO assumir isolamento automático
Reportar gaps de isolamento identificados
Respeitar configurações específicas do tenant
NÃO criar funcionalidades que quebrem isolamento
