# prescricao_medicacao

Objetivo: Registrar prescrições de medicação no contexto do Prontuário Assistido (PA), com controle de medicamentos controlados e status de ativação.

Descrição: Tabela específica para prescrições de medicação no Prontuário Assistido, permitindo descrição livre, controle de medicamentos controlados (que exigem liberação da farmácia) e gerenciamento de status.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prescricao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da prescrição de medicação |
| id_ffa | bigint | NOT NULL | - | Referência ao id da ficha de atendimento assistido (FFA) à qual a prescrição está vinculada |
| id_medico | bigint | NOT NULL | - | Referência ao id do médico que criou a prescrição (também usuário) |
| descricao | text | NOT NULL | - | Descrição livre da prescrição, permitindo detalhamento completo |
| controlada | tinyint(1) | - | '0' | Flag indicando se o medicamento é controlado e exige liberação especial da farmácia |
| criada_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação da prescrição |
| ativa | tinyint(1) | - | '1' | Flag indicando se a prescrição está ativa (1) ou inativa (0) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a prescrição foi criada |

## Chaves
- Primária: id_prescricao
- Únicas: -
- Estrangeiras: prescricao_medicacao_ibfk_2 (id_medico → usuario.id_usuario) - vincula a prescrição ao médico responsável

## Índices
- PRIMARY KEY (id_prescricao)
- KEY id_medico (id_medico)
- KEY idx_ffa (id_ffa)

## Constraints
- CONSTRAINT prescricao_medicacao_ibfk_2 FOREIGN KEY (id_medico) REFERENCES usuario (id_usuario) ON DELETE RESTRICT

## Relacionamentos e Cardinalidade
- N:1 com ffa (uma ficha de atendimento pode ter várias prescrições)
- N:1 com usuario (um médico pode criar várias prescrições)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa, usuario

## Fluxo de utilização dentro do sistema
- Criada no contexto do Prontuário Assistido (PA)
- Medicamentos controlados requerem fluxo de liberação farmacêutica
- Permite descrição livre para casos específicos
- Usada para controle rigoroso de medicações especiais