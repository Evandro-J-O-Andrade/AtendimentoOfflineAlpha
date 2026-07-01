# sp_patch_usuario_fk_idx

Objetivo: patch usuario fk idx conforme definida no dump SQL do sistema.

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
- SELECT: information_schema, usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF

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
- **Linha 3** (Comentario): FK idempotente
- **Linha 4**: Estrutura condicional de controle de fluxo.
- **Linha 5**: execucao de query SELECT para consulta de dados.
- **Linha 6**: FROM information_schema.TABLE_CONSTRAINTS
- **Linha 7**: WHERE CONSTRAINT_SCHEMA = DATABASE()
- **Linha 10**: ) THEN
- **Linha 11**: ALTER TABLE usuario
- **Linha 12**: ADD CONSTRAINT fk_usuario_pessoa
- **Linha 13**: FOREIGN KEY (id_pessoa)
- **Linha 14**: REFERENCES pessoa(id_pessoa)
- **Linha 15**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 16**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 19** (Comentario): Índice idempotente
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: FROM information_schema.statistics
- **Linha 23**: WHERE table_schema = DATABASE()
- **Linha 26**: ) THEN
- **Linha 27**: CREATE UNIQUE INDEX uk_usuario_login ON usuario(login);
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patch_usuario_fk_idx`()
BEGIN
    -- FK idempotente
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = DATABASE()
          AND TABLE_NAME = 'usuario'
          AND CONSTRAINT_NAME = 'fk_usuario_pessoa'
    ) THEN
        ALTER TABLE usuario
        ADD CONSTRAINT fk_usuario_pessoa
        FOREIGN KEY (id_pessoa)
        REFERENCES pessoa(id_pessoa)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;
    END IF;

    -- Índice idempotente
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'usuario'
          AND index_name = 'uk_usuario_login'
    ) THEN
        CREATE UNIQUE INDEX uk_usuario_login ON usuario(login);
    END IF;
END ;;
```

