# hospital_leitos

Objetivo: Gerenciar leitos hospitalares e sua ocupação.

Descrição: Tabela que armazena os leitos do hospital (observação, emergência, internação, isolamento) com status de ocupação, vinculando a unidade e possibilitando acompanhar qual atendimento está ocupando cada leito.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_leito | int | NOT NULL | - | Identificador único do leito, chave primária auto incrementada |
| id_unidade | bigint unsigned | DEFAULT NULL | - | Referência à unidade onde o leito está localizado |
| nome_leito | varchar(50) | NOT NULL | - | Nome ou identificador do leito |
| tipo_leito | enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') | DEFAULT NULL | - | Tipo do leito: observação, emergência, internação ou isolamento |
| status | enum('LIVRE','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO') | DEFAULT | 'LIVRE' | Status do leito: livre, ocupado, reservado, limpeza ou manutenção |
| id_atendimento_atual | bigint | DEFAULT NULL | - | Referência ao atendimento atualmente no leito |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_leito
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- hospital_leitos.id_unidade → unidade (id_unidade): N:1 (vários leitos podem estar na mesma unidade)
- hospital_leitos é referenciado por: internacao (id_leito)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Leito é cadastrado com nome e tipo
2. Status inicia como 'LIVRE'
3. Quando paciente entra: status muda para 'OCUPADO', id_atendimento_atual preenchido
4. Para reserva: status muda para 'RESERVADO'
5. Após alta: status muda para 'LIMPEZA' ou 'OCUPADO'
6. Para manutenção: status muda para 'MANUTENCAO'
7. tabela internacao vincula paciente ao leito