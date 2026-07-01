# md_arquivo_fonte_evento

Objetivo: Registrar eventos de processamento de arquivos fonte para auditoria e rastreabilidade.
Descrição: Tabela que registra todas as mudanças de status e eventos que ocorrem durante o processamento de arquivos fonte.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_md_arquivo_fonte_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_md_arquivo_fonte` | bigint | NOT NULL | - | Referência ao arquivo fonte |
| `ocorrido_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento |
| `acao` | enum('CRIADO','BAIXADO','PROCESSADO','ERRO','REPROCESSAR') | NOT NULL | - | Tipo de ação ocorrida |
| `detalhes` | varchar(500) | NULL | NULL | Detalhes do evento em formato texto |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que realizou a ação |
| `id_usuario` | bigint | NULL | NULL | Usuário que realizou a ação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_md_arquivo_fonte_evento`
- Únicas: -
- Estrangeiras: 
  - `fk_md_fonte_evt_fonte` (`id_md_arquivo_fonte`) → `md_arquivo_fonte` (`id_md_arquivo_fonte`) - Vincula evento ao arquivo
  - `fk_md_fonte_evt_usuario` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula evento ao usuário

## Índices
- `idx_md_fonte_evt_fonte` (KEY) - Índice em `id_md_arquivo_fonte`
- `idx_md_fonte_evt_dt` (KEY) - Índice em `ocorrido_em`
- `fk_md_fonte_evt_sessao` (KEY) - Índice em `id_sessao_usuario`
- `fk_md_fonte_evt_usuario` (KEY) - Índice em `id_usuario`

## Constraints
- `fk_md_fonte_evt_fonte` FOREIGN KEY - Relaciona `id_md_arquivo_fonte` com `md_arquivo_fonte`.`id_md_arquivo_fonte`
- `fk_md_fonte_evt_usuario` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `md_arquivo_fonte` - Muitos eventos pertencem a um arquivo fonte
- N:1 com `usuario` - Muitos eventos podem ter sido feitos pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitos eventos podem estar associados a uma sessão

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `md_arquivo_fonte`, `usuario`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança no arquivo fonte gera um evento
2. Ação CRIADO indica registro inicial
3. Ação BAIXADO indica download concluído
4. Ação PROCESSADO indica dados importados com sucesso
5. Ação ERRO indica falha no processamento
6. Ação REPROCESSAR indica necessidade de nova tentativa
7. Usado para auditoria de atualizações de tabelas auxiliares
8. Permite identificar falhas na importação automática
9. Base para relatórios de atualização de dados