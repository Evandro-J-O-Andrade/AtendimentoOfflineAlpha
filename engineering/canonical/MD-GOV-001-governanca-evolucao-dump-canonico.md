# MD-GOV-001 — Governança de Evolução do Dump Canônico do Banco

**Status**: APROVADO  
**Versão**: 1.0  
**Data**: 2026-08-04  
**Autores**: Equipe de Arquitetura Enterprise  
**Aprovadores**: Equipe de Arquitetura Enterprise  

---

## 1. Objetivo

Este documento define o processo oficial para evolução, correção e manutenção do banco de dados canônico do projeto.

O objetivo é garantir que qualquer alteração estrutural ou lógica no banco seja realizada de forma controlada, rastreável e validada, mantendo o dump canônico como única fonte oficial de verdade.

---

## 2. Princípio Canônico

O banco de dados possui uma única representação oficial:

```
Dump Canônico
```

O dump representa o estado aprovado do banco contendo:

* Tabelas;
* Colunas;
* Índices;
* Constraints;
* Foreign Keys;
* Views;
* Triggers;
* Stored Procedures;
* Functions;
* Eventos;
* Dados base necessários.

Nenhuma alteração definitiva existe fora do dump após aprovação.

---

## 3. Regra Fundamental

## O dump é atualizado. Não são criados arquivos SQL fragmentados como fonte permanente.

Exemplo proibido como estado final:

```
migration_001.sql
fix_painel.sql
alter_sp.sql
patch_temp.sql
correcao_final.sql
```

Esses arquivos podem existir temporariamente durante testes, mas não representam a arquitetura oficial.

O estado aprovado sempre deve ser consolidado novamente no:

```
Dump Canônico
```

### 3.1 Tratamento de Artefatos SQL Temporários

Arquivos SQL gerados por ferramentas de análise, IA ou processos automatizados **não são migrações**. Eles são **propostas**.

Fluxo correto:

```
SQL solto gerado pela IA
          │
          ▼
Análise contra Dump Canônico
          │
          ▼
Validação do que realmente falta
          │
          ▼
Incorporação no Dump Canônico
          │
          ▼
Teste
          │
          ▼
Aprovação
```

#### Regras específicas

1. **Não executar** SQL gerado por ferramentas diretamente no banco de produção/teste sem validação.
2. **Não criar** arquivos SQL permanentes como `add_painel.sql`, `fix_sp.sql`, `patch.sql`.
3. **Não versionar** patches SQL fragmentados no repositório.
4. **Sempre comparar** objeto por objeto com o Dump Canônico antes de propor qualquer alteração.
5. **Gerar relatório de análise** ao invés de executar alterações.

#### Relatório esperado

```text
AUDITORIA SQL GERADOS

Arquivo analisado:
painel.sql

Objeto:
CREATE TABLE painel_widget

Status:
🟢 Já existe no Dump Canônico

Ação:
Nenhuma


Objeto:
CREATE TABLE painel_layout

Status:
🟡 Existe parcialmente

Diferença:
Falta coluna:
- id_layout


Ação:
Adicionar no Dump Canônico


Objeto:
CREATE PROCEDURE sp_painel_config_get

Status:
🔴 Não existe

Ação:
Validar regra de negócio antes de incorporar
```

---

## 4. Processo Oficial de Alteração

Toda evolução do banco deve seguir o fluxo:

```
Backup do Banco Atual
        |
        ▼
Leitura do Dump Canônico
        |
        ▼
Análise de Diferenças
        |
        ▼
Proposta de Alteração
        |
        ▼
Aplicação no Dump
        |
        ▼
Restauração/Teste em Ambiente Controlado
        |
        ▼
Validação Técnica
        |
        ▼
Aprovação
        |
        ▼
Novo Dump Canônico
```

---

## 5. Backup Obrigatório

Antes de qualquer alteração:

Deve ser criado um backup completo do banco existente.

O backup representa o estado anterior:

```
Banco Produção/Teste
        |
        ▼
Backup de Segurança
        |
        ▼
Alteração do Dump
```

Esse backup permite:

* comparação;
* rollback;
* validação;
* auditoria histórica.

---

## 6. Papel da IA na Evolução do Banco

A IA pode atuar como ferramenta de análise e manutenção assistida.

Responsabilidades permitidas:

* Ler o dump completo;
* Mapear estrutura existente;
* Comparar documentação e implementação;
* Encontrar tabelas ausentes;
* Encontrar campos ausentes;
* Identificar SPs inconsistentes;
* Sugerir alterações;
* Aplicar alterações no dump consolidado após aprovação.

---

## 7. Regra de Comparação

Antes de qualquer alteração definitiva devem ser comparados:

```
Banco Atual
      +
Dump Canônico
      +
Documentação Arquitetural
      +
ADRs
```

A alteração somente é aceita quando os quatro elementos estiverem alinhados.

---

## 8. Alterações Permitidas

## Nova tabela

Fluxo:

```
Identificar necessidade
        |
        ▼
Criar definição no dump
        |
        ▼
Validar dependências
        |
        ▼
Testar criação
        |
        ▼
Aprovar
```

---

## Novo campo

Fluxo:

```
Identificar ausência
        |
        ▼
Alterar CREATE TABLE no dump
        |
        ▼
Validar índices e constraints
        |
        ▼
Testar
        |
        ▼
Aprovar
```

---

## Stored Procedure

Fluxo:

```
Analisar SP existente
        |
        ▼
Atualizar definição no dump
        |
        ▼
Validar parâmetros
        |
        ▼
Executar testes
        |
        ▼
Aprovar
```

---

## 9. Nomenclatura Canônica

### Tabelas

Tabelas devem representar a entidade que armazenam:

```text
painel
painel_config
painel_evento
painel_widget
dispositivo
dispositivo_tipo
```

**Proibido**:

```text
painel_v2
painel_final
painel_new
painel_old
painel_tmp
```

### Stored Procedures

SPs devem representar a ação que executam:

```text
sp_painel_get
sp_painel_config_get
sp_painel_evento_insert
sp_painel_status_update
```

**Proibido**:

```text
sp_painel_fix
sp_painel_old
sp_painel_new
sp_painel_temp
sp_painel_patch
```

### Views

Views devem representar a perspectiva que fornecem:

```text
vw_painel_ativo
vw_painel_por_local
vw_dispositivo_status
```

**Proibido**:

```text
vw_painel_tmp
vw_painel_fix
vw_painel_old
```

---

## 10. Critérios de Aprovação

Uma alteração somente entra no dump oficial quando:

* [ ] Banco restaurado com sucesso;
* [ ] Todas as tabelas criadas;
* [ ] Todas as FKs válidas;
* [ ] Todas as SPs compiladas;
* [ ] Testes executados;
* [ ] Documentação atualizada;
* [ ] ADR atualizado quando necessário.

---

## 10. Controle de Versão

Cada nova versão do dump deve possuir:

```
DumpYYYYMMDD.sql
```

Exemplo:

```
Dump20260804.sql
```

Cada versão deve possuir registro:

```
Versão:
Data:
Responsável:
Alterações:
Motivo:
ADR relacionado:
Resultado dos testes:
```

---

## 11. Regra de Ouro

Nenhuma alteração estrutural de banco deve existir apenas no código da aplicação.

A aplicação deve sempre refletir o banco canônico aprovado.

```
Arquitetura
      |
      ▼
Documentação
      |
      ▼
Dump Canônico
      |
      ▼
Backend
      |
      ▼
Frontend
```

---

## 12. Estado Esperado

Ao final do processo:

Existe apenas uma referência oficial:

```
Banco Canônico Aprovado
```

Todos os ambientes devem conseguir ser reconstruídos a partir dele.

O dump é a representação definitiva da arquitetura física do banco.
