# sp_sequencia_proximo_numero

Objetivo: sequencia proximo numero conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_chave | VARCHAR(100) | IN | |
| p_numero | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: protocolo_sequencia
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- LAST_INSERT_ID

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
- **Linha 6**: /*
- **Linha 7**: Tabela protocolo_sequencia:
- **Linha 8**: chave VARCHAR(100) PK
- **Linha 9**: ultimo_numero BIGINT
- **Linha 10**: criado_em / atualizado_em (auto)
- **Linha 11**: */
- **Linha 12**: Insere um novo registro na tabela protocolo_sequencia.
- **Linha 13**: VALUES (p_chave, LAST_INSERT_ID(1))
- **Linha 14**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 15**: ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);
- **Linha 17**: atribuicao de valor Ã  variavel p_numero.
- **Linha 18**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sequencia_proximo_numero`(
    IN  p_chave   VARCHAR(100),
    OUT p_numero  BIGINT
)
BEGIN
    /*
      Tabela protocolo_sequencia:
        chave VARCHAR(100) PK
        ultimo_numero BIGINT
        criado_em / atualizado_em (auto)
    */
    INSERT INTO protocolo_sequencia(chave, ultimo_numero)
    VALUES (p_chave, LAST_INSERT_ID(1))
    ON DUPLICATE KEY UPDATE
        ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);

    SET p_numero = LAST_INSERT_ID();
END ;;
```

