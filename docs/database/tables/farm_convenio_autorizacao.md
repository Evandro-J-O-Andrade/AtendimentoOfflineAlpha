# farm_convenio_autorizacao

Objetivo: Tabela do sistema

Descrição: Gerencia autorizações de convênio para dispensação de medicamentos, controlando status (pendente, aprovado, negado) e vínculo com dispensação.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_autorizacao | bigint AUTO_INCREMENT | NO | — | Identificador da autorização de convênio |
| id_dispensacao | bigint | NO | — | Identificador da dispensação |
| numero_autorizacao | varchar(80) DEFAULT | YES | NULL | Número sequencial do documento |
| status | enum('PENDENTE','APROVADO','NEGADO') | NO | 'PENDENTE' | Status atual conforme enumeração definida |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_autorizacao
- Estrangeira (fk_conv_disp): coluna id_dispensacao -> tabela farm_dispensacao(id_dispensacao): Referencia a tabela farm_dispensacao (coluna id_dispensacao) para garantir integridade referencial

## Indices

- fk_conv_disp (id_dispensacao)

## Constraints

- FOREIGN KEY fk_conv_disp: id_dispensacao references farm_dispensacao(id_dispensacao)
- PRIMARY KEY (id_autorizacao)

## Relacionamentos e Cardinalidade

- farm_convenio_autorizacao (1) -> farm_dispensacao (1): campo id_dispensacao

## Dependencias

- Depende de:
  - farm_dispensacao
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
