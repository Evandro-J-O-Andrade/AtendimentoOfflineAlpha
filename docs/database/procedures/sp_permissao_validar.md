# sp_permissao_validar

Objetivo: permissao validar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_perfil | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_tem_permissao | BOOLEAN | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_status, fluxo_transicao
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT

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
- **Linha 8**: atribuicao de valor Ã  variavel p_tem_permissao.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: JOIN fluxo_status fs_origem ON fs_origem.id_fluxo_status = ft.id_status_origem
- **Linha 11**: JOIN fluxo_status fs_destino ON fs_destino.id_fluxo_status = ft.id_status_destino
- **Linha 12**: WHERE ft.id_perfil_requerido = p_id_perfil
- **Linha 16**: );
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_permissao_validar`(
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_contexto VARCHAR(50),
    OUT p_tem_permissao BOOLEAN
)
BEGIN
    SET p_tem_permissao = EXISTS (
        SELECT 1 FROM fluxo_transicao ft
        JOIN fluxo_status fs_origem ON fs_origem.id_fluxo_status = ft.id_status_origem
        JOIN fluxo_status fs_destino ON fs_destino.id_fluxo_status = ft.id_status_destino
        WHERE ft.id_perfil_requerido = p_id_perfil
          AND ft.ativo = 1
          AND (fs_origem.codigo LIKE CONCAT(p_contexto, '%') 
               OR fs_destino.codigo LIKE CONCAT(p_contexto, '%'))
    );
END ;;
```

