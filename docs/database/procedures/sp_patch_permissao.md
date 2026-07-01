# sp_patch_permissao

Objetivo: patch permissao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: information_schema, permissao
- INSERT: auth_audit
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- IF
- JSON_OBJECT
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 3** (Comentario): Variáveis de controle
- **Linha 4**: Declaracao de variavel local idx_existe.
- **Linha 6** (Comentario): Drop seguro do índice
- **Linha 7**: execucao de query SELECT para consulta de dados.
- **Linha 8**: FROM information_schema.statistics
- **Linha 9**: WHERE table_schema = DATABASE()
- **Linha 13**: Estrutura condicional de controle de fluxo.
- **Linha 14**: ALTER TABLE permissao DROP INDEX uk_permissao_codigo;
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 17** (Comentario): Adiciona colunas idempotentes
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: execucao de query SELECT para consulta de dados.
- **Linha 20**: WHERE table_name = 'permissao' AND column_name = 'dominio'
- **Linha 21**: ) THEN
- **Linha 22**: ALTER TABLE permissao ADD COLUMN dominio VARCHAR(40) DEFAULT 'GERAL';
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 26**: execucao de query SELECT para consulta de dados.
- **Linha 27**: WHERE table_name = 'permissao' AND column_name = 'metadata'
- **Linha 28**: ) THEN
- **Linha 29**: ALTER TABLE permissao ADD COLUMN metadata JSON NULL;
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32** (Comentario): Criação de índice seguro
- **Linha 33**: ALTER TABLE permissao ADD UNIQUE INDEX uk_permissao_codigo (codigo);
- **Linha 35** (Comentario): Auditoria de patch
- **Linha 36**: Insere um novo registro na tabela auth_audit.
- **Linha 37**: VALUES ('PATCH_EXECUTADO', 'permissao', JSON_OBJECT('procedimento','sp_patch_permissao','executado_em',NOW()), NOW());
- **Linha 38**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patch_permissao`()
BEGIN
    -- Variáveis de controle
    DECLARE idx_existe INT DEFAULT 0;

    -- Drop seguro do índice
    SELECT COUNT(*) INTO idx_existe
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'permissao'
      AND index_name = 'uk_permissao_codigo';

    IF idx_existe > 0 THEN
        ALTER TABLE permissao DROP INDEX uk_permissao_codigo;
    END IF;

    -- Adiciona colunas idempotentes
    IF NOT EXISTS (
        SELECT * FROM information_schema.COLUMNS 
        WHERE table_name = 'permissao' AND column_name = 'dominio'
    ) THEN
        ALTER TABLE permissao ADD COLUMN dominio VARCHAR(40) DEFAULT 'GERAL';
    END IF;

    IF NOT EXISTS (
        SELECT * FROM information_schema.COLUMNS 
        WHERE table_name = 'permissao' AND column_name = 'metadata'
    ) THEN
        ALTER TABLE permissao ADD COLUMN metadata JSON NULL;
    END IF;

    -- Criação de índice seguro
    ALTER TABLE permissao ADD UNIQUE INDEX uk_permissao_codigo (codigo);

    -- Auditoria de patch
    INSERT INTO auth_audit (acao, recurso, detalhes, criado_em)
    VALUES ('PATCH_EXECUTADO', 'permissao', JSON_OBJECT('procedimento','sp_patch_permissao','executado_em',NOW()), NOW());
END ;;
```

