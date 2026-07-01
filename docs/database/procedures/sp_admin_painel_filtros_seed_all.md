# sp_admin_painel_filtros_seed_all

Objetivo: admin painel filtros seed all conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_incluir_nd | TINYINT | IN | |

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
- sp_painel_filtro_locais_seed

## Functions Utilizadas
- (nenhuma)

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
- **Linha 5**: main: BEGIN
- **Linha 6** (Comentario): Recepção: RECxx (ex.: REC01..)
- **Linha 7**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 9** (Comentario): Triagem: TRIxx (ex.: TRI01..)
- **Linha 10**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 12** (Comentario): Médico Clínico: MEDCxx (ex.: MEDC01.. ou MEDC1..)
- **Linha 13**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 15** (Comentario): Médico Pediátrico: MEDPxx (ex.: MEDP01.. ou MEDP1..)
- **Linha 16** (Comentario): OBS: no schema atual, o tipo em local_operacional está como MEDICO_PEDIATRICO (não MEDICO_PEDI).
- **Linha 17**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 19** (Comentario): RX: RXxx (ex.: RX01..)
- **Linha 20**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 22** (Comentario): Medicação (Adulto): MED0x/MEDxx (ex.: MED01..). Exclui prefixo pediátrico (MEDP)
- **Linha 23**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 25** (Comentario): Medicação (Pedi): MEDPxx (ex.: MEDP01..)
- **Linha 26**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 28** (Comentario): Medicação (Infantil): (se você usar código/prefixo diferente, ajuste aqui)
- **Linha 29**: Invoca a procedure sp_painel_filtro_locais_seed.
- **Linha 30**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_admin_painel_filtros_seed_all`(
    IN p_id_sessao_usuario BIGINT,
    IN p_incluir_nd TINYINT
)
main: BEGIN
    -- Recepção: RECxx (ex.: REC01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'RECEPCAO', 'RECEPCAO', 'REC', NULL, p_incluir_nd);

    -- Triagem: TRIxx (ex.: TRI01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'TRIAGEM', 'TRIAGEM', 'TRI', NULL, p_incluir_nd);

    -- Médico Clínico: MEDCxx (ex.: MEDC01.. ou MEDC1..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICO_CLINICO', 'MEDICO_CLINICO', 'MEDC', NULL, p_incluir_nd);

    -- Médico Pediátrico: MEDPxx (ex.: MEDP01.. ou MEDP1..)
    -- OBS: no schema atual, o tipo em local_operacional está como MEDICO_PEDIATRICO (não MEDICO_PEDI).
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICO_PEDI', 'MEDICO_PEDIATRICO', 'MEDP', NULL, p_incluir_nd);

    -- RX: RXxx (ex.: RX01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'RX', 'RX', 'RX', NULL, p_incluir_nd);

    -- Medicação (Adulto): MED0x/MEDxx (ex.: MED01..). Exclui prefixo pediátrico (MEDP)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_ADULTO', 'MEDICACAO', 'MED', 'MEDP', p_incluir_nd);

    -- Medicação (Pedi): MEDPxx (ex.: MEDP01..)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_PEDI', 'MEDICACAO', 'MEDP', NULL, p_incluir_nd);

    -- Medicação (Infantil): (se você usar código/prefixo diferente, ajuste aqui)
    CALL sp_painel_filtro_locais_seed(p_id_sessao_usuario, 'MEDICACAO_INF', 'MEDICACAO', 'MEDP', NULL, p_incluir_nd);
END ;;
```

