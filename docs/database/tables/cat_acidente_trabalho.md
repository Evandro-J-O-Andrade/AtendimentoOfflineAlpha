# cat_acidente_trabalho

Objetivo: Registrar informações sobre acidentes de trabalho e doenças ocupacionais.
Descrição: Tabela que documenta acidentes de trabalho, incluindo tipo, data, descrição, agente causador, parte do corpo atingida e status da CAT.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|--------------------------------------------------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro CAT, chave primária auto incrementada. |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento médico relacionado ao acidente. |
| id_pessoa_trabalhador | bigint | NOT NULL | - | Referência à pessoa que sofreu o acidente de trabalho. |
| data_acidente | datetime | NOT NULL | - | Data e hora do acidente de trabalho. |
| tipo_acidente | enum('TIPICO','TRAJETO','DOENCA_OCUPACIONAL','OUTRO') | NOT NULL | - | Tipo: acidente típico, trajeto, doença ocupacional ou outro. |
| descricao_acidente | text | Nullable | - | Descrição detalhada do acidente ocorrido. |
| agente_causador | varchar(120) | Nullable | - | Agente ou causa que provocou o acidente. |
| parte_corpo | varchar(120) | Nullable | - | Parte do corpo atingida no acidente. |
| cid10_relacionado | varchar(10) | Nullable | - | CID-10 relacionado ao acidente ou doença. |
| status_cat | enum('ABERTA','EMITIDA','ENVIADA','ARQUIVADA') | NOT NULL | 'ABERTA' | Status: aberta, emitida, enviada ao MTE ou arquivada. |
| numero_cat | varchar(40) | Nullable | - | Número oficial da CAT emitida. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que registrou a CAT. |
| id_usuario_criador | bigint | NOT NULL | - | Referência ao usuário que criou o registro. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro. |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp da última atualização. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_cat_trabalhador: id_pessoa_trabalhador → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id)
- KEY idx_cat_atendimento (id_atendimento)
- KEY idx_cat_trabalhador (id_pessoa_trabalhador)
- KEY idx_cat_status (status_cat)
- KEY fk_cat_sessao (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_cat_trabalhador (id_pessoa_trabalhador) REFERENCES pessoa (id_pessoa)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento (id_atendimento) - cada acidente está ligado a um atendimento
- N:1 com pessoa (id_pessoa_trabalhador) - trabalhador que sofreu acidente
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com usuario (id_usuario_criador)
- N:1 com saas_entidade (id_entidade)
- 1:N com cat_acidente_trabalho_evento (id) - um acidente pode ter muitos eventos

## Dependências
- Tabelas que dependem desta: cat_acidente_trabalho_evento
- Dependência desta tabela: atendimento, pessoa, sessao_usuario, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada quando há registro de acidente de trabalho no atendimento
- Usada para emissão de CAT (Comunicação de Acidente do Trabalho) ao MTE
- Status acompanha o progresso da tramitação da CAT
- Cada mudança de status é registrada em cat_acidente_trabalho_evento
- Integrada ao sistema de notificação para aprovação/documentação