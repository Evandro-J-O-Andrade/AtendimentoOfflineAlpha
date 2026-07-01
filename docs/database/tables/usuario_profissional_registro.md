# usuario_profissional_registro

Objetivo: Armazenar dados de registro profissional de usuários do sistema, como conselhos de classe e números de registro.
Descrição: Tabela que complementa o cadastro de usuários com informações de registro profissional em conselhos de classe (CRM, COREN, CREFITO, etc.), especialidade principal e UF de registro. Funciona como extensão da tabela de usuários para profissionais de saúde que necessitam de credenciais válidas para exercício da profissão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario | bigint | NO | NULL | Identificador do usuário detentor do registro profissional (chave primária) |
| conselho | varchar(20) | YES | NULL | Nome ou sigla do conselho de classe (ex: CRM, COREN, CREFITO) |
| numero_registro | varchar(30) | YES | NULL | Número do registro no conselho de classe |
| uf_registro | char(2) | YES | NULL | Unidade Federativa (UF) onde o registro profissional está registrado |
| especialidade_principal | varchar(100) | YES | NULL | Especialidade principal declarada pelo profissional |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este registro pertence |

## Chaves
- Primária: id_usuario
- Únicas: Nenhuma
- Estrangeiras: fk_prof_usuario (id_usuario -> usuarios.id)

## Índices
- Nenhum índice adicional (apenas chave primária)

## Constraints
- fk_prof_usuario: FOREIGN KEY (id_usuario) REFERENCES usuarios (id)

## Relacionamentos e Cardinalidade
- 1:1 com usuario (cada usuário tem no máximo um registro profissional)
- N:1 com usuarios (referência à tabela de usuários no schema legado)

## Dependências
- Depende de: usuarios, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Preenchido durante o cadastro ou atualização de usuário profissional (médicos, enfermeiros, fisioterapeutas)
- Usado para validação de registros profissionais antes de permitir acesso a funcionalidades restritas
- Consultado em relatórios de equipe multiprofissional e credenciamento
- Importante para cumprimento de exigências regulatórias de conselhos de classe na área de saúde
