# evento_ffa

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Ledger de eventos específicos do fluxo de atendimento ambulatorial (FFA), registrando mudanças de estado, chamadas, triagens e ações do sistema e usuários.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evento | bigint AUTO_INCREMENT | NO | — | Identificador único de evento |
| id_ffa | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_paciente | bigint DEFAULT | YES | NULL | Identificador único de paciente |
| id_usuario | bigint DEFAULT | YES | NULL | Identificador único de usuario |
| origem | enum('PAINEL_TOTEM','PAINEL_RECEPCAO','PAINEL_TRIAGEM','PAINEL_MEDICO','PAINEL_PROCEDIMENTO','PAINEL_SATISFACAO','SISTEMA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| tipo_evento | enum('GERAR_SENHA','IMPRIMIR_SENHA','CHAMAR_SENHA','CONFIRMAR_PRESENCA','CRIAR_FFA','INICIO_TRIAGEM','FINAL_TRIAGEM','CHAMADA_MEDICA','INICIO_ATENDIMENTO_MEDICO','FINAL_ATENDIMENTO_MEDICO','CHAMADA_PROCEDIMENTO','INICIO_PROCEDIMENTO','FINAL_PROCEDIMENTO','STATUS_AUTOMATICO','NAO_COMPARECEU','TIMEOUT','AVALIACAO_ATENDIMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Endereço IP de origem da requisição |
| status_origem | enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Status atual conforme enumeração definida |
| status_destino | enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Status atual conforme enumeração definida |
| payload | json DEFAULT | YES | NULL | Dados complementares no formato JSON |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evento

## Indices

- idx_evento_ffa (id_ffa)
- idx_evento_tipo (tipo_evento)
- idx_evento_origem (origem)

## Constraints

- PRIMARY KEY (id_evento)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Registra transições de estado e ações no fluxo de atendimento ambulatorial.
- Consumido por painéis de totem, recepção, triagem, médico e procedimentos.
- Alimenta a máquina de estados do FFA e os displays de chamada.
- Utilizado para auditoria de fluxo e estatísticas de atendimento.
