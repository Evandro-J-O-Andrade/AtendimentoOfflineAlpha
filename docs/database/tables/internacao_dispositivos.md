# internacao_dispositivos

Objetivo: Controlar dispositivos inseridos durante internações.

Descrição: Tabela que registra dispositivos médicos inseridos em pacientes internados (CVC, SVD, SNG, dreno, cateter, cânula traqueal), controlando data de inserção, prazo de troca e status (ativo, removido, substituído). Utilizada para vigilância de infecção e manutenção.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_dispositivo | bigint | NOT NULL | - | Identificador único do dispositivo, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação onde o dispositivo foi inserido |
| tipo | enum('CVC','SVD','SNG','SNE','DRENO','CATETER_PERIFERICO','CANULA_TRAQUEO') | NOT NULL | - | Tipo de dispositivo: CVC (cateter venoso central), SVD, SNG (sonda nasogástrica), dreno, cateter periférico ou cânula traqueal |
| localizacao | varchar(100) | DEFAULT NULL | - | Localização anatômica onde foi inserido |
| data_insercao | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora da inserção do dispositivo |
| prazo_troca_dias | int | DEFAULT | '7' | Prazo em dias para próxima troca (padrão 7 dias) |
| data_prevista_troca | datetime | DEFAULT NULL | - | Data prevista para troca do dispositivo |
| id_usuario_insercao | bigint | NOT NULL | - | Referência ao usuário que inseriu o dispositivo |
| status | enum('ATIVO','REMOVIDO','SUBSTITUIDO') | DEFAULT | 'ATIVO' | Status do dispositivo: ativo, removido ou substituído |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_dispositivo
- Únicas: -
- Estrangeiras: fk_disp_internacao (id_internacao → internacao.id_internacao)

## Índices
- fk_disp_internacao (id_internacao)

## Constraints
- CONSTRAINT fk_disp_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)

## Relacionamentos e Cardinalidade
- internacao_dispositivos.id_internacao → internacao (id_internacao): N:1 (vários dispositivos podem ser inseridos na mesma internação)
- internacao_dispositivos.id_usuario_insercao → usuario (id_usuario): N:1 (vários dispositivos podem ser inseridos pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao

## Fluxo de utilização dentro do sistema
1. Equipe insere dispositivo no paciente internado
2. Registro é criado com tipo e localizacao
3. prazo_troca_dias define quando deve ser trocado (padrão 7 dias)
4. data_prevista_troca é calculada automaticamente
5. Status inicia como 'ATIVO'
6. Quando removido: status muda para 'REMOVIDO'
7. Quando substituído por outro: status muda para 'SUBSTITUIDO'
8. Permite alertas de troca e vigilância de infecção