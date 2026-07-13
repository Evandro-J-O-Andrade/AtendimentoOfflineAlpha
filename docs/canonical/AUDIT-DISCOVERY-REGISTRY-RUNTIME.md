# AUDIT-DISCOVERY-REGISTRY-RUNTIME

## 1. Objeto auditado

Discovery + Registry Runtime

## 2. Conceito esperado

Camada responsável por descobrir dinamicamente:
- módulos disponíveis
- capacidades do tenant/contexto
- recursos publicados
- metadados necessários para montagem do Portal Runtime

Não é menu.
Não é permissão.
Não é frontend.

É a camada que responde:
> "Dado este contexto autenticado, quais capacidades existem e podem ser resolvidas pelo Kernel?"

## 3. Busca realizada

Busca exaustiva em `bancoMysql.md` (pronto_atendimento) por:
- Tabelas candidatas: modulo, menu, aplicacao, sistema, feature, capacidade, capability, recurso, servico, registry, catalogo, metadado, configuracao, parametro, tenant, empresa, entidade
- Stored Procedures candidatas: sp_*menu*, sp_*module*, sp_*portal*, sp_*config*, sp_*registry*, sp_*context*, sp_*tenant*, sp_*capability*
- Views candidatas: vw_*menu*, vw_*modulo*, vw_*portal*, vw_*config*, vw_*permissao*
- Referências cruzadas entre procedures e tabelas

## 4. Objetos encontrados

### 4.1 Tabelas candidatas

| Tabela | Existe | Função atual | Relevância |
|--------|--------|--------------|------------|
| `sistema` | SIM | Catálogo de sistemas (8 registros: OPE, ASI, HIS, PA, UPA, UBS, FARMACIA, ADMIN) | ALTA - é o catálogo de sistemas mais próximo de módulos |
| `tenant_registry` | SIM | Registro de tenants (uuid, nome_fantasia, razao_social, cnpj, cnes, regiao, status) | ALTA - é o registry de tenants |
| `saas_entidade` | SIM | Entidade SaaS (id_entidade, nome_fantasia, tipo_entidade) | ALTA - é a entidade federadora |
| `config_sistema` | SIM | Configurações por unidade (parametro, valor) | MÉDIA - configuração operacional |
| `configuracao` | SIM | Configuração global (chave, valor) | MÉDIA - configuração global |
| `local_capacidade` | SIM | Capacidade de locais (capacidade_maxima, ocupacao_atual) | BAIXA - capacidade física, não capability |
| `usuario_sistema` | SIM | Vínculo usuário-sistema-perfil | ALTA - define quais sistemas um usuário acessa |
| `usuario_sistema_acl_evento` | SIM | Eventos ACL usuário-sistema | MÉDIA - auditoria de acesso |
| `auth_parametro` | SIM | Parâmetros de auth (senha, sessao, token) | BAIXA - configuração de auth |
| `permissao` | SIM | Permissões + Menu (codigo, nome, dominio, nome_procedure, acao_frontend, metadata, grupo_menu, icone, ordem_menu, visivel_menu) | ALTA - está sobrecarregada com menu |
| `perfil_permissao` | SIM | Perfil-Permissão (id_perfil, id_permissao) | ALTA - base de autorização |
| `auth_grupo_permissao` | SIM | Grupo-Permissão (recurso, acao) | MÉDIA - ACL baseada em recurso |
| `portal_categoria` | SIM | Categorias de portal (nome, descricao, cor_etiqueta) | BAIXA - categorias visuais |
| `painel_config` | SIM | Configuração de painéis (chave, valor_json) | BAIXA - config específica de painel |
| `erro_catalogo` | SIM | Catálogo de erros (codigo, dominio, descricao) | BAIXA - catálogo de erros |
| `contexto_atendimento` | SIM | Contexto de atendimento (id_sistema, nome, tipo, usa_fila, usa_chamada) | MÉDIA - mapeia sistema para contexto |
| `runtime_contexto` | SIM | Contexto runtime (id_sessao, id_unidade, id_local, contexto_clinico, estado_fluxo) | ALTA - estado runtime do usuário |
| `usuario_contexto` | SIM | Contexto do usuário (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) | ALTA - snapshot do contexto ativo |
| `atendimento_evento_ledger` | SIM | Ledger de eventos (modulo, sub_modulo, acao, estado_origem, estado_destino) | MÉDIA - rastreabilidade por módulo |

#### Tabelas NÃO encontradas (candidatas diretas)

| Tabela | Status | Observação |
|--------|--------|------------|
| `modulo` | NÃO EXISTE | Sem tabela de módulos |
| `menu` | NÃO EXISTE | Sem tabela de menu |
| `aplicacao` | NÃO EXISTE | Sem tabela de aplicações |
| `feature` | NÃO EXISTE | Sem tabela de features |
| `capacidade` / `capability` | NÃO EXISTE | Apenas `local_capacidade` (capacidade física) |
| `recurso` | NÃO EXISTE | Sem tabela de recursos |
| `registry` | NÃO EXISTE | Apenas `tenant_registry` |
| `catalogo` | NÃO EXISTE | Apenas `erro_catalogo` |
| `metadado` | NÃO EXISTE | Sem tabela de metadados |
| `parametro` | NÃO EXISTE | Apenas `auth_parametro` e `config_sistema` |
| `empresa` | NÃO EXISTE | Sem tabela de empresas |

### 4.2 Stored Procedures candidatas

| Procedure | Existe | Função | Relevância |
|-----------|--------|--------|------------|
| `sp_auth_menu_get` | SIM | Monta JSON de menu por perfil/local | CRÍTICA - Navigation Runtime |
| `sp_auth_contexto_get` | SIM | Retorna unidades, perfis, locais do usuário | ALTA - Context Resolution |
| `sp_auth_contexto_set` | SIM | Define contexto ativo do usuário | ALTA - Context Resolution |
| `sp_contexto_assert_permissao` | SIM | Assert permissão por acao/recurso | ALTA - Authorization |
| `sp_contexto_assert_transicao` | SIM | Assert transição de estado | MÉDIA - Workflow |
| `sp_tenant_enforce_not_null` | SIM | Garante id_entidade NOT NULL em todas as tabelas | BAIXA - manutenção |
| `sp_permissao_assert` | SIM | Assert permissão por codigo | ALTA - Authorization |
| `sp_permissao_validar` | SIM | Valida permissão por fluxo_transicao | MÉDIA - Workflow |
| `sp_usuario_tem_permissao` | SIM | Verifica permissão via view | ALTA - Authorization |
| `sp_usuario_vincular_sistema` | SIM | Vincula usuário a sistema | ALTA - User-System binding |
| `sp_usuario_vincular_unidade` | SIM | Vincula usuário a unidade | ALTA - User-Unit binding |
| `sp_usuario_vincular_local` | SIM | Vincula usuário a local | MÉDIA - User-Local binding |
| `sp_sessao_contexto_get` | SIM | Obtém contexto da sessão | ALTA - Context Resolution |
| `sp_sessao_contexto_set` | SIM | Define contexto da sessão | ALTA - Context Resolution |
| `sp_sessao_tem_permissao` | SIM | Verifica permissão da sessão | ALTA - Authorization |
| `sp_patch_permissao` | SIM | Patch schema da tabela permissao | BAIXA - migração |
| `sp_master_routes` | SIM | Roteamento dinâmico de operações | MÉDIA - Dispatcher |

#### Procedures NÃO encontradas (candidatas diretas)

| Procedure | Status | Observação |
|-----------|--------|------------|
| `sp_*module*` | NÃO EXISTE | Sem procedure de descoberta de módulos |
| `sp_*portal*` | NÃO EXISTE | Sem procedure de portal |
| `sp_*registry*` | NÃO EXISTE | Sem procedure de registry |
| `sp_*capability*` | NÃO EXISTE | Sem procedure de capabilities |

### 4.3 Views

| View | Existe | Função | Relevância |
|------|--------|--------|------------|
| `vw_usuario_permissoes` | NÃO ENCONTRADA no dump | Referenciada por `sp_usuario_tem_permissao` | CRÍTICA - pode existir no banco mas não foi dumpada |

#### Views NÃO encontradas

| View | Status | Observação |
|------|--------|------------|
| `vw_*menu*` | NÃO EXISTE no dump | |
| `vw_*modulo*` | NÃO EXISTE no dump | |
| `vw_*portal*` | NÃO EXISTE no dump | |
| `vw_*config*` | NÃO EXISTE no dump | |
| `vw_*permissao*` | NÃO EXISTE no dump | |

## 5. Relacionamentos existentes

### 5.1 Modelo de autorização atual

```
usuario
   |
   +-- usuario_perfil (id_usuario, id_perfil, id_entidade)
   |
   +-- usuario_unidade (id_usuario, id_unidade, id_entidade)
   |
   +-- usuario_local (id_usuario, id_local, id_entidade)
   |
   +-- usuario_sistema (id_usuario, id_sistema, id_perfil, id_entidade)
   |
   +-- usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)

perfil
   |
   +-- perfil_permissao (id_perfil, id_permissao)

permissao
   |
   +-- perfil_permissao (id_permissao)
```

### 5.2 Modelo de contexto atual

```
sessao_usuario
   |
   +-- usuario_contexto (snapshot)
   |
   +-- runtime_contexto (estado clinico, estado_fluxo)
```

### 5.3 Modelo de tenant atual

```
saas_entidade (id_entidade)
   |
   +-- tenant_registry (id_tenant, uuid_tenant, nome_fantasia, cnpj, cnes, regiao, status)
   |
   +-- sistema (id_sistema, nome, codigo, ativo, id_entidade)
```

### 5.4 Observação crítica

A tabela `permissao` está sobrecarregada com campos de menu:
- `grupo_menu`
- `icone`
- `ordem_menu`
- `visivel_menu`
- `acao_frontend`

Isso viola a separação entre:
- **Authorization** (o que o usuário pode fazer)
- **Navigation** (como o menu é apresentado)

## 6. Evidências

### 6.1 sp_auth_menu_get (linha 17613)

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_menu_get`(
    IN p_id_sessao BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
BEGIN
    ...
    SET p_resultado = (
        SELECT JSON_OBJECT(
            'modulos', JSON_ARRAYAGG(
                JSON_OBJECT(
                    'modulo', modulos.modulo,
                    'nome', modulos.nome,
                    'icone', modulos.icone,
                    'ordem', modulos.ordem,
                    'flags', JSON_OBJECT(
                        'ativo', modulos.flag_ativo,
                        'externo', modulos.flag_externo,
                        'restrito', modulos.flag_restrito
                    ),
                    'acoes', modulos.acoes
                )
            )
        )
        FROM (
            SELECT
                m.modulo,
                m.nome,
                m.icone,
                m.ordem,
                m.flag_ativo,
                m.flag_externo,
                m.flag_restrito,
                (
                    SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'codigo', a.codigo,
                            'nome', a.nome,
                            'sp', a.nome_procedure,
                            'ordem', a.ordem
                        )
                    )
                    FROM (
                        SELECT p.codigo, p.nome, p.nome_procedure, p.ordem
                        FROM permissao p
                        JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                        LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                        WHERE pp.id_perfil = v_id_perfil
                          AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                          AND p.modulo = m.modulo
                          AND p.ativo = 1
                          AND p.id_entidade = v_id_entidade
                        ORDER BY p.ordem, p.nome
                    ) AS a
                ) AS aces
            FROM (
                SELECT DISTINCT
                    p.modulo,
                    p.modulo AS nome,
                    COALESCE(p.icone, 'default') AS icone,
                    COALESCE(p.ordem, 999) AS ordem,
                    COALESCE(p.flag_ativo, 1) AS flag_ativo,
                    COALESCE(p.flag_externo, 0) AS flag_externo,
                    COALESCE(p.flag_restrito, 0) AS flag_restrito
                FROM permissao p
                JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                WHERE pp.id_perfil = v_id_perfil
                  AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                  AND p.ativo = 1
                  AND p.id_entidade = v_id_entidade
                ORDER BY p.ordem, p.modulo
            ) AS m
        ) AS modulos
    );
    ...
    INSERT INTO menu_evento(id_sessao_usuario, sucesso, mensagem, criado_em)
    VALUES (p_id_sessao, 1, 'MENU_OK', NOW());
END
```

**Problemas identificados:**
1. Referencia `permissao.modulo` — coluna NÃO existe na tabela `permissao`
2. Referencia `permissao.flag_ativo`, `flag_externo`, `flag_restrito` — colunas NÃO existem na tabela `permissao`
3. Referencia `permissao_local` — tabela NÃO existe
4. Referencia `menu_evento` — tabela NÃO existe

### 6.2 sp_contexto_assert_permissao (linha 18632)

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contexto_assert_permissao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_acao VARCHAR(100),
    IN p_recurso VARCHAR(100)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(1)
      INTO v_count
      FROM sessao_usuario su
      JOIN usuario_contexto uc
        ON uc.id_usuario = su.id_usuario
       AND uc.id_unidade = su.id_unidade
       AND uc.id_sistema = su.id_sistema
       AND uc.ativo = 1
      JOIN perfil_permissao pp
        ON pp.id_perfil = uc.id_perfil
       AND pp.acao = p_acao
       AND pp.recurso = p_recurso
       AND pp.ativo = 1
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativa = 1;

    CALL sp_assert_true(
        v_count > 0,
        'PERMISSAO_NEGADA',
        CONCAT('Sem permissão para ', p_acao, ' em ', p_recurso)
    );
END
```

**Problemas identificados:**
1. Referencia `perfil_permissao.acao` — coluna NÃO existe
2. Referencia `perfil_permissao.recurso` — coluna NÃO existe
3. Referencia `perfil_permissao.ativo` — coluna NÃO existe

### 6.3 sp_auth_contexto_get (linha 17370)

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_get`(
    IN p_id_sessao_usuario BIGINT UNSIGNED
)
BEGIN
    ...
    SELECT DISTINCT
        uu.id_unidade,
        un.nome AS nome_unidade
    FROM usuario_unidade uu
    INNER JOIN unidade un
        ON un.id_unidade  = uu.id_unidade
       AND un.id_entidade = uu.id_entidade
    WHERE uu.id_usuario  = v_id_usuario
      AND uu.id_entidade = v_id_entidade
    ORDER BY un.nome;

    SELECT DISTINCT
        up.id_perfil,
        p.nome AS nome_perfil,
        up.id_unidade
    FROM usuario_perfil up
    INNER JOIN perfil p
        ON p.id_perfil   = up.id_perfil
       AND p.id_entidade = up.id_entidade
    INNER JOIN usuario_unidade uu
        ON uu.id_unidade  = up.id_unidade
       AND uu.id_usuario  = up.id_usuario
       AND uu.id_entidade = up.id_entidade
    WHERE up.id_usuario  = v_id_usuario
      AND up.id_entidade = v_id_entidade
    ORDER BY p.nome;
    ...
END
```

**Problemas identificados:**
1. `usuario_perfil` não possui coluna `id_unidade` — join vai falhar

### 6.4 sp_usuario_tem_permissao (linha 33504)

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_tem_permissao`(
    IN  p_id_usuario BIGINT,
    IN  p_permissao  VARCHAR(100),
    OUT p_ok         TINYINT
)
BEGIN
    DECLARE v_ok INT DEFAULT 0;

    SELECT 1
      INTO v_ok
      FROM vw_usuario_permissoes v
     WHERE v.id_usuario = p_id_usuario
       AND v.permissao = p_permissao
     LIMIT 1;

    SET p_ok = IFNULL(v_ok, 0);
END
```

**Problemas identificados:**
1. Referencia `vw_usuario_permissoes` — view NÃO encontrada no dump

### 6.5 sp_auth_contexto_set (linha 17469)

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_set`(
    IN p_id_sessao_usuario BIGINT UNSIGNED,
    IN p_id_unidade        BIGINT UNSIGNED,
    IN p_id_perfil         BIGINT UNSIGNED,
    IN p_id_local          BIGINT UNSIGNED
)
BEGIN
    ...
    INSERT INTO usuario_contexto (
        id_usuario,
        id_entidade,
        id_sistema,
        id_unidade,
        id_local_operacional,
        id_perfil,
        ativo,
        criado_em
    ) VALUES (...);
END
```

**Observação:**
- Insere em `usuario_contexto` que tem `id_sistema` mas o procedure recebe `p_id_sistema` implicitamente da sessão
- `sessao_usuario` possui `id_sistema` — correto

## 7. Classificação

### 7.1 Estado atual

| Dimensão | Avaliação |
|----------|-----------|
| Existe tabela de módulos | NÃO |
| Existe tabela de menu | NÃO |
| Existe tabela de capabilities | NÃO |
| Existe registry canônico | PARCIAL (`tenant_registry` + `saas_entidade`) |
| Existe capability discovery | NÃO |
| Existe module discovery | NÃO |
| Existe runtime metadata para Portal | NÃO |
| Procedures de descoberta | NÃO |
| Views de descoberta | NÃO |

### 7.2 Classificação

**PROPOSE**

Não há nenhuma implementação existente de Discovery + Registry Runtime.

O que existe são:
1. **Catálogo de sistemas** (`sistema`) — estático, não dinâmico, sem capabilities
2. **Registro de tenants** (`tenant_registry`) — existente, mas isolado
3. **Autorização** (`permissao`, `perfil_permissao`, `auth_grupo_permissao`) — sobrecarregada com menu
4. **Contexto** (`usuario_contexto`, `runtime_contexto`, `sessao_usuario`) — existente, mas focado em sessão
5. **Navigation** (`sp_auth_menu_get`) — procedure existente mas com **schema incompatível**

## 8. GAP

### 8.1 Schema incompatível (BLOQUEANTE)

As procedures existentes de Navigation/Authorization referenciam colunas e tabelas que não existem no dump:

| Procedure | Referência | Status no dump |
|-----------|-----------|----------------|
| `sp_auth_menu_get` | `permissao.modulo` | NÃO EXISTE |
| `sp_auth_menu_get` | `permissao.flag_ativo` | NÃO EXISTE |
| `sp_auth_menu_get` | `permissao.flag_externo` | NÃO EXISTE |
| `sp_auth_menu_get` | `permissao.flag_restrito` | NÃO EXISTE |
| `sp_auth_menu_get` | `permissao_local` | NÃO EXISTE |
| `sp_auth_menu_get` | `menu_evento` | NÃO EXISTE |
| `sp_contexto_assert_permissao` | `perfil_permissao.acao` | NÃO EXISTE |
| `sp_contexto_assert_permissao` | `perfil_permissao.recurso` | NÃO EXISTE |
| `sp_contexto_assert_permissao` | `perfil_permissao.ativo` | NÃO EXISTE |
| `sp_auth_contexto_get` | `usuario_perfil.id_unidade` | NÃO EXISTE |
| `sp_usuario_tem_permissao` | `vw_usuario_permissoes` | NÃO ENCONTRADA |

### 8.2 Arquitetural

1. **Menu ≠ Capability**: A tabela `permissao` está sendo usada como fonte de verdade tanto para autorização quanto para navegação. Isso viola a separação de responsabilidades.

2. **Falta de metamodelo**: Não existe uma estrutura canônica que responda:
   > "Quais módulos/capabilities estão disponíveis para este tenant?"

3. **Falta de discovery dinâmico**: O sistema atual usa catálogos estáticos (`sistema`, `permissao`). Não há mecanismo de descoberta dinâmica de capacidades publicadas pelo Kernel.

4. **Sobreposição de conceitos**:
   - `sistema` é um catálogo de sistemas, não um registry de módulos
   - `permissao` é uma autorização, mas carrega metadados de menu
   - `tenant_registry` é um registry, mas não está integrado ao discovery de capabilities

### 8.3 GAP resumido

```
GAP-001: Falta tabela de módulos/capabilities
GAP-002: Falta registry canônico de capabilities por tenant
GAP-003: Falta procedure de descoberta dinâmica
GAP-004: Falta view de capabilities disponíveis por contexto
GAP-005: permissao está sobrecarregada (auth + menu)
GAP-006: Schema de procedures incompatível com tabelas existentes
GAP-007: Falta metadados de runtime para Portal Assembly
```

## 9. Decisão pendente

**Classificação: PROPOSE**

O Discovery + Registry Runtime não existe no banco. É necessário propor uma nova implementação que:

1. **Separe** Navigation de Authorization
2. **Crie** um registry canônico de capabilities/módulos
3. **Implemente** descoberta dinâmica por tenant/contexto
4. **Resolva** as incompatibilidades de schema existentes
5. **NÃO reuse** a tabela `permissao` como fonte de menu

### 9.1 Opções de materialização

| Opção | Descrição |
|-------|-----------|
| A | Criar tabelas `modulo`, `capability`, `registry` do zero |
| B | Estender `sistema` para ser um module registry e adicionar `capability` |
| C | Usar `tenant_registry` + nova tabela `tenant_capability` + nova tabela `module_registry` |

**Recomendação: Opção C**

Motivo:
- `tenant_registry` já existe e é um bom ponto de partida para o registry de tenants
- `sistema` deve permanecer como catálogo de sistemas operacionais
- Nova tabela `module_registry` deve conter módulos/capabilities publicáveis
- Nova tabela `tenant_capability` deve vincular tenants a capabilities disponíveis
- Nova procedure `sp_discovery_capabilities_get` deve resolver capabilities por contexto autenticado

## 10. Próximos passos

1. Abrir GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
2. Definir modelo de dados para:
   - `module_registry` (id, nome, codigo, versao, metadados, ativo)
   - `capability` (id, modulo_id, codigo, nome, descricao, sp_responsavel, metadados)
   - `tenant_capability` (id_tenant, id_capability, configuracao_json, ativo)
   - `tenant_module` (id_tenant, id_modulo, configuracao_json, ativo)
3. Resolver incompatibilidades de schema:
   - Decidir se `permissao` ganha colunas `modulo`, `flag_ativo`, `flag_externo`, `flag_restrito`
   - Decidir se `perfil_permissao` ganha colunas `acao`, `recurso`, `ativo`
   - Decidir se `usuario_perfil` ganha coluna `id_unidade`
   - Criar/recriar `permissao_local`, `menu_evento`
   - Criar/recriar `vw_usuario_permissoes`
4. Implementar `sp_discovery_capabilities_get`
5. Implementar `sp_navigation_menu_get` (separada de auth)
