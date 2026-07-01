# codigo_universal

Objetivo: Gerenciar códigos universais únicos para identificação de entidades no sistema.
Descrição: Tabela central que mantém códigos únicos para pacientes, produtos, usuários, clientes e FFAs, com suporte a domínios, barcode e status.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_codigo | bigint | NOT NULL | - | Identificador único do código, chave primária auto incrementada. |
| dominio | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | NOT NULL | - | Domínio do código: LAB, FARMACIA, ESTOQUE, FATURAMENTO, RH, PATRIMONIO ou OUTRO. |
| prefixo_5 | char(5) | Nullable | - | Prefixo de 5 dígitos para identificação do domínio/escopo. |
| sequencia | int | Nullable | - | Sequencial usado na geração de código único. |
| codigo_interno | varchar(50) | NOT NULL | - | Código interno gerado, único no sistema. |
| barcode | varchar(60) | NOT NULL | - | Código de barras associado ao código. |
| origem_interno | enum('AUTO','MANUAL') | NOT NULL | 'AUTO' | Modo de origem: automático ou manual. |
| id_ffa | bigint | Nullable | - | Referência a FFA (Ficha de Atendimento) - opcional. |
| id_senha | bigint | Nullable | - | Referência a senha - opcional. |
| id_paciente | bigint | Nullable | - | Referência a paciente - opcional. |
| id_produto | bigint | Nullable | - | Referência a produto - opcional. |
| id_usuario | bigint | Nullable | - | Referência a usuário - opcional. |
| id_cliente | bigint | Nullable | - | Referência a cliente - opcional. |
| status | enum('ATIVO','CANCELADO','SUBSTITUIDO') | NOT NULL | 'ATIVO' | Status do código: ativo, cancelado ou substituído. |
| payload | json | Nullable | - | Dados complementares em formato JSON. |
| id_sessao_usuario | bigint | Nullable | - | Referência à sessão que criou o código. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do código. |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp da última atualização. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Chaves
- Primária: id_codigo
- Únicas:
  - uk_codigo_interno (codigo_interno)
  - uk_barcode (barcode)
  - uk_prefixo_seq (dominio, prefixo_5, sequencia)
- Estrangeiras:
  - fk_codigo_cliente: id_cliente → cliente (id_cliente)
  - fk_codigo_paciente: id_paciente → paciente (id_paciente)
  - fk_codigo_senha: id_senha → senha (id_senha)
  - fk_codigo_sessao: id_sessao_usuario → sessao_usuario (id_sessao_usuario) - opcional

## Índices
- PRIMARY KEY (id_codigo)
- UNIQUE KEY uk_codigo_interno (codigo_interno)
- UNIQUE KEY uk_barcode (barcode)
- UNIQUE KEY uk_prefixo_seq (dominio, prefixo_5, sequencia)
- KEY idx_codigo_dom_status (dominio, status, criado_em)
- KEY idx_codigo_ffa (id_ffa)
- KEY idx_codigo_produto (id_produto)
- KEY idx_codigo_usuario (id_usuario)
- KEY fk_codigo_senha (id_senha)
- KEY fk_codigo_paciente (id_paciente)
- KEY fk_codigo_cliente (id_cliente)
- KEY fk_codigo_sessao (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id_codigo
- UNIQUE: uk_codigo_interno (codigo_interno)
- UNIQUE: uk_barcode (barcode)
- UNIQUE: uk_prefixo_seq (dominio, prefixo_5, sequencia)
- FOREIGN KEY: fk_codigo_cliente (id_cliente) REFERENCES cliente (id_cliente)
- FOREIGN KEY: fk_codigo_paciente (id_paciente) REFERENCES paciente (id_paciente)
- FOREIGN KEY: fk_codigo_senha (id_senha) REFERENCES senha (id_senha)
- FOREIGN KEY: fk_codigo_sessao (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- 1:1 com cliente (id_cliente) - opcional
- 1:1 com paciente (id_paciente) - opcional
- 1:1 com senha (id_senha) - opcional
- 1:1 com produto (id_produto) - opcional
- 1:1 com usuario (id_usuario) - opcional
- 1:1 com FFA (id_ffa) - opcional
- N:1 com sessao_usuario (id_sessao_usuario) - opcional
- N:1 com saas_entidade (id_entidade)
- 1:N com codigo_externo_map (id_codigo)
- 1:N com codigo_externo_vinculo (id_codigo_universal)

## Dependências
- Tabelas que dependem desta: codigo_externo_map
- Dependência desta tabela: cliente, paciente, senha, produto, usuario, sessao_usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Código interno único gerado automaticamente para qualquer entidade
- Barcode permite identificação física via leitor
- Domínio e prefixo permitem classificação e agrupamento
- Status substituído mantém histórico de códigos cancelados
- Usado como chave primária ou identificador único em todo o sistema