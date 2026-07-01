# funcionario

Objetivo: Gerenciar os funcionários/profissionais do sistema.

Descrição: Tabela central que armazena os funcionários da instituição, vinculados a pessoas e entidades, com informações de matrícula, cargo, departamento e datas de admissão/demissão. Tipos incluem médicos, enfermeiros, farmacêuticos, recepcionistas, entre outros.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_funcionario | bigint | NOT NULL | - | Identificador único do funcionário, chave primária auto incrementada |
| id_pessoa | bigint | NOT NULL | - | Referência à pessoa física vinculada ao funcionário |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) onde trabalha |
| matricula | varchar(50) | DEFAULT NULL | - | Número da matrícula do funcionário na empresa |
| tipo_funcionario | enum('MEDICO','ENFERMEIRO','TECNICO_ENFERMAGEM','RECEPCIONISTA','FARMACEUTICO','ADMINISTRATIVO','GESTOR','SUPORTE_TI','COORDENADOR','FISIOTERAPEUTA','MANUTENCAO','COORDENADOR_ENFERMAGEM','SUPERVISOR','NUTRICIONISTA','OUTRO') | DEFAULT NULL | - | Tipo/cargo do funcionário: médico, enfermeiro, técnico, recepcionista, farmacêutico, etc |
| cargo | varchar(150) | DEFAULT NULL | - | Nome do cargo do funcionário |
| departamento | varchar(150) | DEFAULT NULL | - | Departamento onde o funcionário trabalha |
| data_admissao | date | DEFAULT NULL | - | Data de admissão do funcionário |
| data_demissao | date | DEFAULT NULL | - | Data de demissão (se aplicável) |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se o funcionário está ativo (1=ativo, 0=inativo) |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |

## Chaves
- Primária: id_funcionario
- Únicas: -
- Estrangeiras: fk_funcionario_entidade (id_entidade → saas_entidade.id_entidade); fk_funcionario_pessoa (id_pessoa → pessoa.id_pessoa)

## Índices
- idx_funcionario_pessoa (id_pessoa)
- idx_funcionario_entidade (id_entidade)
- idx_funcionario_matricula (matricula)

## Constraints
- CONSTRAINT fk_funcionario_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa)

## Relacionamentos e Cardinalidade
- funcionario.id_pessoa → pessoa (id_pessoa): 1:1 (funcionário está vinculado a uma pessoa)
- funcionario.id_entidade → saas_entidade (id_entidade): N:1 (vários funcionários podem trabalhar na mesma entidade)

## Dependências
- Tabelas que dependem desta: funcionario_conselho_profissional, funcionario_especialidade, funcionario_unidade
- Esta tabela depende de: pessoa, saas_entidade

## Fluxo de utilização dentro do sistema
1. Pessoa é cadastrada no sistema
2. Funcionário é criado associando pessoa a uma entidade
3. tipo_funcionario define o cargo principal (médico, enfermeiro, etc)
4. matricula, cargo e departamento são preenchidos conforme dados da empresa
5. data_admissao registra quando entrou na instituição
6. data_demissao preenchida quando deixa (mantém histórico)
7. ativo controla se ainda trabalha na instituição