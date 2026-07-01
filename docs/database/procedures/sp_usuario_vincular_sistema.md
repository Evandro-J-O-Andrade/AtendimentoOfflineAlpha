# sp_usuario_vincular_sistema

Objetivo: usuario vincular sistema conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: usuario_sistema
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
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
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Insere um novo registro na tabela usuario_sistema.
- **Linha 8**: id_usuario,
- **Linha 9**: id_sistema,
- **Linha 10**: id_perfil,
- **Linha 11**: ativo,
- **Linha 12**: criado_em
- **Linha 13**: ) VALUES (
- **Linha 14**: p_id_usuario,
- **Linha 15**: p_id_sistema,
- **Linha 16**: p_id_perfil,
- **Linha 17**: 1,
- **Linha 18**: NOW()
- **Linha 19**: fechamento da lista de Parametros.
- **Linha 20**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 21**: id_perfil = VALUES(id_perfil),
- **Linha 22**: ativo = 1;
- **Linha 23**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_vincular_sistema`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    INSERT INTO usuario_sistema (
        id_usuario,
        id_sistema,
        id_perfil,
        ativo,
        criado_em
    ) VALUES (
        p_id_usuario,
        p_id_sistema,
        p_id_perfil,
        1,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        id_perfil = VALUES(id_perfil),
        ativo = 1;
END ;;
```

