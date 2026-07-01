# medico

Objetivo: Armazenar informações profissionais específicas de médicos no sistema.
Descrição: Tabela que complementa o cadastro de usuários com informações específicas de médicos, incluindo CRM e especialidade. Cada médico está associado a um usuário do sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_usuario` | bigint | NOT NULL | - | Identificador do usuário (PK e FK para usuario) |
| `crm` | varchar(20) | NULL | NULL | Número do CRM (Cadastro de Médicos) |
| `uf_crm` | char(2) | NULL | NULL | Estado do CRM (ex: "SP", "RJ") |
| `id_especialidade` | bigint | NULL | NULL | Referência à especialidade do médico |
| `ativo` | tinyint(1) | NULL | '1' | Indica se o médico está ativo (1) ou inativo (0) |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `atualizado_em` | datetime | NULL | NULL | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_usuario` (também é FK para usuario)
- Únicas: -
- Estrangeiras: 
  - `fk_medico_especialidade` (`id_especialidade`) → `especialidade` (`id_especialidade`) - Vincula à especialidade
  - `fk_medico_usuario` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula ao usuário

## Índices
- `fk_medico_especialidade` (KEY) - Índice em `id_especialidade`

## Constraints
- `fk_medico_especialidade` FOREIGN KEY - Relaciona `id_especialidade` com `especialidade`.`id_especialidade` (ON DELETE RESTRICT ON UPDATE CASCADE)
- `fk_medico_usuario` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- 1:1 com `usuario` - Cada médico tem um usuário único
- N:1 com `especialidade` - Muitos médicos podem ter a mesma especialidade
- N:1 com `saas_entidade` - Muitos médicos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: `medico_especialidade` (via id_usuario)
- Esta tabela depende de: `usuario`, `especialidade`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Médico é cadastrado vinculando a um usuário existente
2. CRM e UF são validados contra sistema estadual
3. Especialidade é usada para agendamento e encaminhamentos
4. O campo `ativo` permite desativar médicos sem remover do sistema
5. Usado para validação de prescrições médicas
6. Base para relatórios de produtividade por especialidade
7. Integração com sistema de agendamento para definição de agenda
8. Usado na validação de atendimentos realizados por médicos