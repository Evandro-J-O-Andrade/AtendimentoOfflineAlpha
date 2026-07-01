# codigo_externo_map

Objetivo: Mapear códigos internos do sistema a códigos de sistemas externos.
Descrição: Tabela que mantém mapeamento entre códigos internos (codigo_universal) e códigos de sistemas externos (LAB, FARMACIA, ESTOQUE, etc.).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_map | bigint | NOT NULL | - | Identificador único do mapeamento, chave primária auto incrementada. |
| id_codigo | bigint | NOT NULL | - | Referência ao código interno (codigo_universal). |
| dominio | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | NOT NULL | - | Domínio do sistema externo: LAB, FARMACIA, ESTOQUE, FATURAMENTO, RH, PATRIMONIO ou OUTRO. |
| sistema_externo | varchar(50) | NOT NULL | - | Nome do sistema externo (ex: SISLAB, TASY, GLPI). |
| codigo_externo | varchar(80) | NOT NULL | - | Código no sistema externo. |
| modo_cadastro | enum('AUTO','MANUAL') | NOT NULL | 'MANUAL' | Modo de cadastro: automático ou manual. |
| observacao | varchar(255) | Nullable | - | Observação sobre o mapeamento. |
| payload | json | Nullable | - | Payload adicional com dados do mapeamento. |
| id_sessao_usuario | bigint | Nullable | - | Referência à sessão que realizou o cadastro. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do mapeamento. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o mapeamento pertence. |

## Chaves
- Primária: id_map
- Únicas: uk_externo (dominio, sistema_externo, codigo_externo)
- Estrangeiras:
  - fk_map_codigo: id_codigo → codigo_universal (id_codigo)
  - fk_map_sessao: id_sessao_usuario → sessao_usuario (id_sessao_usuario) - opcional

## Índices
- PRIMARY KEY (id_map)
- UNIQUE KEY uk_externo (dominio, sistema_externo, codigo_externo)
- KEY idx_map_codigo (id_codigo)
- KEY idx_map_lookup (dominio, sistema_externo)
- KEY fk_map_sessao (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id_map
- UNIQUE: uk_externo (dominio, sistema_externo, codigo_externo)
- FOREIGN KEY: fk_map_codigo (id_codigo) REFERENCES codigo_universal (id_codigo)

## Relacionamentos e Cardinalidade
- N:1 com codigo_universal (id_codigo) - muitos mapeamentos podem referenciar um código interno
- N:1 com sessao_usuario (id_sessao_usuario) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: codigo_universal, sessao_usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada quando há integração com sistemas externos
- Domínio identifica área: laboratório, farmácia, estoque, faturamento, RH
- Permite tradução bidirecional entre códigos internos e externos
- Modo automático indica importação via integração
- Usada para sincronização de dados entre sistemas