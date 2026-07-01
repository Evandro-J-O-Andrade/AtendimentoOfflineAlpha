# assistencial_quorum_clinico

Objetivo: Monitorar e validar o quorum clínico para eventos de FFAs, assegurando que determinada porcentagem de unidades participe do evento.

Descrição: Esta tabela controla a validação do quorum clínico em sistemas distribuídos, registrando o total de unidades participantes, quantas confirmaram a participação, e se o quorum mínimo foi atingido para um evento específico em uma FFA.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_quorum | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de quorum clínico |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o quorum está associado |
| evento | varchar(60) | NOT NULL | - | Nome ou código do evento assistencial para o qual está sendo validado o quorum |
| total_unidades_participantes | int | YES | '1' | Número total de unidades que deveriam participar do evento |
| unidades_confirmadas | int | YES | '0' | Número de unidades que confirmaram participação no evento |
| quorum_valido | tinyint(1) | YES | '0' | Flag que indica se o quorum mínimo foi validado com sucesso (1) ou não (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o quorum pertence |

## Chaves
- Primária: id_quorum
- Únicas: uk_quorum_ffa_evento (id_ffa, evento) - Garante um único quorum por combinação FFA/evento
- Estrangeiras: Nenhuma

## Índices
- Nenhum índice adicional definido

## Constraints
- uk_quorum_ffa_evento - UNIQUE - Garante unicidade da combinação id_ffa/evento

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_quorum_clinico)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Validação de consensus entre múltiplas unidades para eventos críticos
- Controle do total de unidades participantes vs. unidades que confirmaram
- Verificação de quorum válido para determinar se evento pode prosseguir
- Unicidade garantida por UK para evitar registros duplicados de quorum
- Timestamp para controle de quando a validação foi realizada