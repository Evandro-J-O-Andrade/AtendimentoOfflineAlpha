# viatura

Objetivo: Cadastrar e gerenciar viaturas/veículos da frota de atendimento móvel (ambulâncias e outros veículos operacionais).
Descrição: Tabela que armazena informações das viaturas utilizadas no atendimento móvel e transporte de pacientes. Controla o tipo de viatura (ambulância básica, avançada ou outro), sua unidade de vinculação e status operacional. Funciona como cadastro mestre de frota para módulos de remoção, transporte e atendimento pré-hospitalar.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_viatura | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a viatura |
| id_unidade | bigint unsigned | NO | NULL | Identificador da unidade à qual a viatura está vinculada |
| prefixo | varchar(30) | NO | NULL | Prefixo ou identificação visual da viatura (ex: USB-01, AMB-15) |
| tipo | enum('AMBULANCIA_BASICA','AMBULANCIA_AVANCADA','OUTRO') | NO | 'OUTRO' | Classificação do tipo de viatura: ambulância básica, avançada ou outro tipo de veículo |
| ativo | tinyint(1) | YES | '1' | Flag que indica se a viatura está ativa (1) ou inativa/desativada (0) |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta viatura pertence |

## Chaves
- Primária: id_viatura
- Únicas: uk_viatura (id_unidade, prefixo)
- Estrangeiras: fk_viatura_unidade (id_unidade -> unidade.id_unidade)

## Índices
- uk_viatura (id_unidade, prefixo) - unique

## Constraints
- fk_viatura_unidade: FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (muitas viaturas pertencem a uma unidade)

## Dependências
- Depende de: unidade, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, mas é referenciada por módulos de transporte/remoção

## Fluxo de utilização dentro o sistema
- Cadastrada no módulo de frota/transporte com tipo, prefixo e unidade de vinculação
- Usada em atendimentos pré-hospitalares e remoções para indicar qual viatura realizou o transporte
- Consultada para disponibilidade de frota no agendamento de remoções
- O tipo da viatura determina qual tipo de atendimento pode ser realizado (básica vs avançada)
- Usada em relatórios de utilização de frota e tempo de resposta
