# internacao_prescricao

Objetivo: Gerenciar prescrições médicas durante internação.

Descrição: Tabela que controla as prescrições médicas criadas durante internação hospitalar, com status (ativa, suspensa, encerrada) e vínculo com atendimento. Agrupa os itens de prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_internacao_prescricao | bigint | NOT NULL | - | Identificador único da prescrição, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação onde a prescrição foi criada |
| data_prescricao | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora da prescrição |
| status | enum('ATIVA','SUSPENSA','ENCERRADA') | NOT NULL | 'ATIVA' | Status da prescrição: ativa, suspensa ou encerrada |
| observacoes | text | DEFAULT NULL | - | Observações sobre a prescrição |
| id_usuario_prescritor | bigint | NOT NULL | - | Referência ao usuário médico que prescreveu |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que prescreveu |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE | CURRENT_TIMESTAMP | Data e hora da última atualização |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento principal |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_internacao_prescricao
- Únicas: -
- Estrangeiras: fk_internacao_prescricao_atendimento (id_atendimento → atendimento.id_atendimento ON DELETE CASCADE ON UPDATE CASCADE); fk_internacao_prescricao_entidade (id_entidade → saas_entidade.id_entidade); fk_ip_internacao (id_internacao → internacao.id_internacao); fk_ip_usuario (id_usuario_prescritor → usuario.id_usuario)

## Índices
- idx_ip_internacao (id_internacao)
- idx_ip_data (data_prescricao)
- idx_ip_status (status)
- idx_ip_usuario (id_usuario_prescritor)
- idx_ip_sessao (id_sessao_usuario)
- fk_internacao_prescricao_atendimento (id_atendimento)
- idx_int_presc_ent (id_entidade)

## Constraints
- CONSTRAINT fk_internacao_prescricao_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_internacao_prescricao_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_ip_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT fk_ip_usuario FOREIGN KEY (id_usuario_prescritor) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- internacao_prescricao.id_internacao → internacao (id_internacao): N:1
- internacao_prescricao.id_atendimento → atendimento (id_atendimento): N:1
- internacao_prescricao.id_usuario_prescritor → usuario (id_usuario): N:1

## Dependências
- Tabelas que dependem desta: internacao_medicacao_administracao, internacao_cuidados, internacao_dietas
- Esta tabela depende de: internacao, atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
1. Médico cria prescrição para paciente internado
2. Registro é criado com status 'ATIVA'
3. id_usuario_prescritor identifica quem prescreveu
4. Itens de prescrição são adicionados (medicação, cuidados, dietas)
5. Se preciso suspender: status muda para 'SUSPENSA'
6. Ao finalizar: status muda para 'ENCERRADA'
7. ON DELETE CASCADE mantém consistência com atendimento