# gpat_atendimento

Objetivo: Gerenciar atendimentos do GPAT (prescrições e protocolos terapêuticos).

Descrição: Tabela que representa um GPAT vinculado a um atendimento específico, controlando o ciclo de vida da prescrição com status, médico prescritor e validade. Utilizada para gerenciar protocolos de medicação e terapia.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gpat | bigint | NOT NULL | - | Identificador único do GPAT de atendimento, chave primária auto incrementada |
| codigo | varchar(30) | NOT NULL | - | Código do GPAT para identificação |
| status | enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | NOT NULL | 'ABERTO' | Status: aberto, em atendimento, finalizado ou cancelado |
| id_cliente | bigint | NOT NULL | - | Referência ao cliente/paciente |
| tipo_prescritor | enum('INTERNO','EXTERNO') | NOT NULL | 'EXTERNO' | Tipo de prescritor: interno (do sistema) ou externo |
| id_usuario_medico | bigint | DEFAULT NULL | - | Referência ao usuário médico prescritor (se interno) |
| id_prescritor_externo | bigint | DEFAULT NULL | - | Referência ao prescritor externo (se externo) |
| data_emissao | date | DEFAULT NULL | - | Data de emissão do GPAT |
| data_validade | date | DEFAULT NULL | - | Data de validade do GPAT |
| observacao | text | DEFAULT NULL | - | Observações sobre o GPAT |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação |
| atualizado_em | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE | CURRENT_TIMESTAMP | Data e hora da última atualização |
| id_sessao_abertura | bigint | DEFAULT NULL | - | Referência à sessão do usuário que abriu o GPAT |
| id_sessao_fechamento | bigint | DEFAULT NULL | - | Referência à sessão do usuário que fechou o GPAT |
| id_usuario_abertura | bigint | DEFAULT NULL | - | Referência ao usuário que abriu o GPAT |
| id_usuario_fechamento | bigint | DEFAULT NULL | - | Referência ao usuário que fechou o GPAT |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento ao qual o GPAT pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gpat
- Únicas: uk_gpat_codigo (codigo) |
- Estrangeiras: fk_gpat_cliente (id_cliente → cliente.id_cliente); fk_gpat_usuario_medico (id_usuario_medico → usuario.id_usuario); fk_gpat_sessao_abertura (id_sessao_abertura → sessao_usuario.id_sessao_usuario); fk_gpat_sessao_fechamento (id_sessao_fechamento → sessao_usuario.id_sessao_usuario); fk_gpat_atendimento_atendimento (id_atendimento → atendimento.id_atendimento ON DELETE CASCADE ON UPDATE CASCADE); fk_gpat_atendimento_entidade (id_entidade → saas_entidade.id_entidade)

## Índices
- idx_gpat_status (status)
- idx_gpat_cliente (id_cliente)
- idx_gpat_prescritor (id_prescritor_externo)
- fk_gpat_usuario_medico (id_usuario_medico)
- fk_gpat_sessao_abertura (id_sessao_abertura)
- fk_gpat_sessao_fechamento (id_sessao_fechamento)
- fk_gpat_atendimento_atendimento (id_atendimento)
- idx_gpat_ent (id_entidade)

## Constraints
- CONSTRAINT fk_gpat_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
- CONSTRAINT fk_gpat_usuario_medico FOREIGN KEY (id_usuario_medico) REFERENCES usuario (id_usuario)
- CONSTRAINT fk_gpat_sessao_abertura FOREIGN KEY (id_sessao_abertura) REFERENCES sessao_usuario (id_sessao_usuario)
- CONSTRAINT fk_gpat_sessao_fechamento FOREIGN KEY (id_sessao_fechamento) REFERENCES sessao_usuario (id_sessao_usuario)
- CONSTRAINT fk_gpat_atendimento_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_gpat_atendimento_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_gpat_prescritor_externo FOREIGN KEY (id_prescritor_externo) REFERENCES prescritor_externo (id_prescritor_externo)

## Relacionamentos e Cardinalidade
- gpat_atendimento.id_cliente → cliente (id_cliente): N:1
- gpat_atendimento.id_usuario_medico → usuario (id_usuario): N:1
- gpat_atendimento.id_prescritor_externo → prescritor_externo (id_prescritor_externo): N:1
- gpat_atendimento.id_atendimento → atendimento (id_atendimento): N:1

## Dependências
- Tabelas que dependem desta: gpat_item, gpat_evento, gpat_dispensacao
- Esta tabela depende de: cliente, usuario, sessao_usuario, atendimento, saas_entidade, prescritor_externo

## Fluxo de utilização dentro do sistema
1. GPAT é criado para atendimento com status 'ABERTO'
2. tipo_prescritor define se é médico interno ou externo
3. data_emissao e data_validade controlam o período de validade
4. Médico ou usuário abre/fecha o GPAT registrando sessões
5. Itens são adicionados em gpat_item
6. Quando em atendimento: status muda para 'EM_ATENDIMENTO'
7. Após conclusão: status muda para 'FINALIZADO'
8. Se cancelado: status muda para 'CANCELADO'