# painel_alertas_tempo

Objetivo: Registrar alertas temporais relacionados a senhas e tempos de atendimento.
Descrição: Tabela que armazena alertas gerados quando senhas ultrapassam tempos limite de espera ou atendimento, permitindo monitoramento e ação corretiva em filas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Identificador único do alerta (chave primária, auto incremento) |
| id_senha | bigint | YES | NULL | ID da senha à qual o alerta está vinculado |
| mensagem | varchar(255) | YES | NULL | Texto da mensagem de alerta |
| nivel | enum('AVISO','CRITICO') | YES | NULL | Nível de severidade do alerta: aviso ou crítico |
| data_alerta | datetime | YES | CURRENT_TIMESTAMP | Data/hora em que o alerta foi gerado |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o alerta pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com senha: Muitos alertas podem estar vinculados a uma senha (quando id_senha preenchido)
- N:1 com saas_entidade: Muitos alertas pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada pelo sistema de monitoramento de filas para gerar alertas quando senhas ficam muito tempo sem serem atendidas ou chamadas. O nível CRITICO indica situação urgente, enquanto AVISO é para situações que requerem atenção. Permite que gestores tomem ações corretivas em tempo hábil.