# sp_usuario_vincular_local

Objetivo: usuario vincular local conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: usuario_local_operacional
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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Insere um novo registro na tabela usuario_local_operacional.
- **Linha 7**: id_usuario,
- **Linha 8**: id_local_operacional,
- **Linha 9**: criado_em
- **Linha 10**: ) VALUES (
- **Linha 11**: p_id_usuario,
- **Linha 12**: p_id_local_operacional,
- **Linha 13**: NOW()
- **Linha 14**: fechamento da lista de Parametros.
- **Linha 15**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 16**: id_local_operacional = VALUES(id_local_operacional);
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_vincular_local`(
    IN p_id_usuario BIGINT,
    IN p_id_local_operacional BIGINT
)
BEGIN
    INSERT INTO usuario_local_operacional (
        id_usuario,
        id_local_operacional,
        criado_em
    ) VALUES (
        p_id_usuario,
        p_id_local_operacional,
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        id_local_operacional = VALUES(id_local_operacional);
END ;;
```

