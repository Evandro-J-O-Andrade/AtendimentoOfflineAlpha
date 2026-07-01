# sp_executor_assistencial_anamnese_salvar

Objetivo: executor assistencial anamnese salvar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: atendimento_anamnese
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- historico

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 14**: Insere um novo registro na tabela atendimento_anamnese.
- **Linha 15**: id_saas_entidade,
- **Linha 16**: id_unidade,
- **Linha 17**: id_ffa,
- **Linha 18**: id_usuario,
- **Linha 19**: id_sessao_usuario,
- **Linha 20**: queixa_principal,
- **Linha 21**: historico_doenca,
- **Linha 22**: antecedentes_pessoais,
- **Linha 23**: ip_origem,
- **Linha 24**: device_info,
- **Linha 25**: criado_em
- **Linha 26**: ) VALUES (
- **Linha 27**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
- **Linha 28**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
- **Linha 29**: p_id_referencia,
- **Linha 30**: v_id_usuario,
- **Linha 31**: p_id_sessao,
- **Linha 32**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.queixa_principal')),
- **Linha 33**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.historico_doenca')),
- **Linha 34**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.antecedentes_pessoais')),
- **Linha 35**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
- **Linha 36**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
- **Linha 37**: NOW(6)
- **Linha 38**: );
- **Linha 40**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_anamnese_salvar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_id_usuario BIGINT;

    SELECT id_usuario INTO v_id_usuario 
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    INSERT INTO atendimento_anamnese (
        id_saas_entidade,
        id_unidade,
        id_ffa,
        id_usuario,
        id_sessao_usuario,
        queixa_principal,
        historico_doenca,
        antecedentes_pessoais,
        ip_origem,
        device_info,
        criado_em
    ) VALUES (
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
        p_id_referencia,
        v_id_usuario,
        p_id_sessao,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.queixa_principal')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.historico_doenca')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.antecedentes_pessoais')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
        NOW(6)
    );

END ;;
```

