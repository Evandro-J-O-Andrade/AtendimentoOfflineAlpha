# farm_operacao

Objetivo: Tabela do sistema

Descrição: Cadastro de tipos de operação de farmácia por ambiente (HIS, PA, UPA, UBS, HOSPITAL, RUA), definindo regras de negócio e exigência de dupla baixa.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_operacao | bigint AUTO_INCREMENT | NO | — | Identificador da operação de farmácia |
| tipo_ambiente | enum('HIS','PA','UPA','UBS','HOSPITAL','RUA') | NO | — | Endereço IP de origem da requisição |
| tipo_operacao | enum('INTERNO','VENDA_BALCAO','CONVENIO') | NO | — | Endereço IP de origem da requisição |
| exige_dupla_baixa | tinyint(1) | NO | '1' | Indica se a operação exige dupla checagem |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_operacao

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- PRIMARY KEY (id_operacao)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
