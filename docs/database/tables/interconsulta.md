# interconsulta

Objetivo: Gerenciar solicitações de interconsulta entre médicos.

Descrição: Tabela que armazena solicitações de interconsulta para especialistas, controlando o motivo, status e vínculo com a internação e especialidade solicitada. Utilizada para encaminhamentos entre profissionais.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_interconsulta | bigint | NOT NULL | - | Identificador único da interconsulta, chave primária auto incrementada |
| id_internacao | bigint | DEFAULT NULL | - | Referência à internação que solicitou a interconsulta |
| id_especialidade | bigint | DEFAULT NULL | - | Referência à especialidade solicitada |
| motivo | text | DEFAULT NULL | - | Motivo da solicitação de interconsulta |
| status | enum('SOLICITADA','RESPONDIDA') | NOT NULL | 'SOLICITADA' | Status da interconsulta: solicitada ou respondida |
| data_hora | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora da solicitação |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_interconsulta
- Únicas: -
- Estrangeiras: fk_interconsulta_especialidade (id_especialidade → especialidade.id_especialidade ON DELETE RESTRICT ON UPDATE CASCADE)

## Índices
- fk_interconsulta_especialidade (id_especialidade)

## Constraints
- CONSTRAINT fk_interconsulta_especialidade FOREIGN KEY (id_especialidade) REFERENCES especialidade (id_especialidade) ON DELETE RESTRICT ON UPDATE CASCADE

## Relacionamentos e Cardinalidade
- interconsulta.id_internacao → internacao (id_internacao): N:1 (várias interconsultas podem referenciar a mesma internação)
- interconsulta.id_especialidade → especialidade (id_especialidade): N:1 (várias interconsultas podem solicitar a mesma especialidade)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, especialidade

## Fluxo de utilização dentro do sistema
1. Internação solicita interconsulta para especialidade específica
2. Registro criado com motivo da solicitação
3. Status inicia como 'SOLICITADA'
4. Quando especialista responde: status muda para 'RESPONDIDA'
5. ON DELETE RESTRICT impede exclusão de especialidade com interconsultas
6. ON UPDATE CASCADE atualiza vínculo se especialidade mudar