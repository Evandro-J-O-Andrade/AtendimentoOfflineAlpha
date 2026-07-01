# conselho_profissional

Objetivo: Manter referencial de conselhos profissionais para registro de profissionais.
Descrição: Tabela que armazena os conselhos profissionais reconhecidos (CRM, COREM, CREFITO, etc.) com sigla e UF para validação de registros profissionais.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_conselho | int | NOT NULL | - | Identificador único do conselho, chave primária auto incrementada. |
| sigla | varchar(10) | NOT NULL | - | Sigla do conselho (ex: CRM, COREM, CREFITO, CRF, CRN, CRP, CRESS). |
| nome | varchar(100) | NOT NULL | - | Nome completo do conselho. |
| uf | char(2) | Nullable | 'SP' | Unidade federativa padrão do conselho. |
| id_entidade | bigint unsigned | Nullable | - | Referência à entidade (opcional). |

## Chaves
- Primária: id_conselho
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_conselho)

## Constraints
- PRIMARY KEY: id_conselho

## Relacionamentos e Cardinalidade
- Própria tabela é referencial
- N:1 com saas_entidade (id_entidade) - opcional
- 1:N com profissional_registro (id_conselho) - inferido

## Dependências
- Tabelas que dependem desta: profissional_registro (inferido)
- Dependência desta tabela: saas_entidade (opcional)

## Fluxo de utilização dentro do sistema
- Usada como referencial para validação de números de registro
- Profissionais são vinculados ao conselho ao se cadastrar
- Siglas padronizadas permitem integração com sistemas externos
- UF permite identificar conselhos regionais
- Dados iniciais incluem os principais conselhos da saúde