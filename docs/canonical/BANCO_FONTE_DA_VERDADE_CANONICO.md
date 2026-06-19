# BANCO_FONTE_DA_VERDADE_CANONICO.md

## LEI FUNDAMENTAL

O Dump Oficial é a Fonte da Verdade.

## Estrutura do Banco

```
database/schema/           # DDL canônico
database/migrations/       # Scripts de migração
database/procedures/       # Stored Procedures
database/functions/        # Funções
database/views/            # Views
database/triggers/         # Triggers
database/seeds/            # Seeds canônicos
database/dicionario/       # Dicionário de dados
```

## Proibições

- ❌ Criar tabela diretamente no banco
- ❌ Alterar estrutura diretamente
- ❌ Depender exclusivamente de ORM
- ❌ Criar procedures _v2, _old, _legacy

## Convenções

- Tabelas em lowercase com underscore
- PK sempre id_{nome_tabela}
- FK sempre id_{tabela_referenciada}
- Auditoria obrigatória em todas tabelas
- Índices nomeados idx_{tabela}_{campos}