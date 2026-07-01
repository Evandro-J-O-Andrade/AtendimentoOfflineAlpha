# sp_kernel_identity_chain_register

Objetivo: kernel identity chain register conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_tenant | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_sessao | BIGINT | IN | |
| p_id_dispositivo | BIGINT | IN | |
| p_estado | VARCHAR(60) | IN | |
| p_ip | VARCHAR(45) | IN | |

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
- (nenhuma)

## Functions Utilizadas
- CONCAT_WS
- IFNULL
- SHA2

## Views Utilizadas
- v_fingerprint

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: SQL SECURITY INVOKER
- **Linha 10**: inicio do bloco de execucao.
- **Linha 12**: Declaracao de variavel local v_fingerprint.
- **Linha 14**: atribuicao de valor Ã  variavel v_fingerprint.
- **Linha 15**: CONCAT_WS('|',
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: ),
- **Linha 22**: 256);
- **Linha 24**: INSERT IGNORE INTO kernel_identity_trust_chain (
- **Linha 25**: id_tenant,
- **Linha 26**: id_usuario,
- **Linha 27**: id_sessao,
- **Linha 28**: id_dispositivo,
- **Linha 29**: ip_origem,
- **Linha 30**: fingerprint_runtime,
- **Linha 31**: estado_runtime
- **Linha 32**: fechamento da lista de Parametros.
- **Linha 33**: VALUES (
- **Linha 34**: p_id_tenant,
- **Linha 35**: p_id_usuario,
- **Linha 36**: p_id_sessao,
- **Linha 37**: p_id_dispositivo,
- **Linha 38**: p_ip,
- **Linha 39**: v_fingerprint,
- **Linha 40**: p_estado
- **Linha 41**: );
- **Linha 43**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kernel_identity_chain_register`(
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_sessao BIGINT,
    IN p_id_dispositivo BIGINT,
    IN p_estado VARCHAR(60),
    IN p_ip VARCHAR(45)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_fingerprint CHAR(64);

    SET v_fingerprint = SHA2(
        CONCAT_WS('|',
            IFNULL(p_id_tenant,''),
            IFNULL(p_id_usuario,''),
            IFNULL(p_id_sessao,''),
            IFNULL(p_id_dispositivo,''),
            IFNULL(p_estado,'')
        ),
    256);

    INSERT IGNORE INTO kernel_identity_trust_chain (
        id_tenant,
        id_usuario,
        id_sessao,
        id_dispositivo,
        ip_origem,
        fingerprint_runtime,
        estado_runtime
    )
    VALUES (
        p_id_tenant,
        p_id_usuario,
        p_id_sessao,
        p_id_dispositivo,
        p_ip,
        v_fingerprint,
        p_estado
    );

END ;;
```

