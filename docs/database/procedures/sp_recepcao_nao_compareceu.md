# sp_recepcao_nao_compareceu

Objetivo: recepcao nao compareceu conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_janela_minutos | INT | IN | |
| p_observacao | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_senha_nao_compareceu

## Functions Utilizadas
- CONCAT
- IFNULL

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8** (Comentario): regra: recepção marca a senha como NAO_COMPARECEU + abre janela de retorno
- **Linha 9**: Invoca a procedure sp_senha_nao_compareceu.
- **Linha 10**: CONCAT('setor=RECEPCAO | ', IFNULL(p_observacao,'(n/a)')));
- **Linha 11**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_nao_compareceu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha          BIGINT,
    IN p_janela_minutos    INT,
    IN p_observacao        VARCHAR(255)
)
BEGIN
    -- regra: recepção marca a senha como NAO_COMPARECEU + abre janela de retorno
    CALL sp_senha_nao_compareceu(p_id_sessao_usuario, p_id_senha, p_janela_minutos,
                                 CONCAT('setor=RECEPCAO | ', IFNULL(p_observacao,'(n/a)')));
END ;;
```

