# nucleo_governanca_assistencial

Objetivo: Manter configurações de governança assistencial central para controle de consistência e versionamento de estrutura.
Descrição: Tabela que armazena o núcleo central de governança do sistema assistencial, incluindo hash da estrutura, versão de protocolo e estado de migração.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_nucleo` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do núcleo |
| `hash_nucleo_estrutura` | char(64) | NOT NULL | - | Hash SHA256 da estrutura do núcleo |
| `versao_protocolo` | bigint | NOT NULL | - | Versão do protocolo de governança |
| `descricao_release` | text | NULL | NULL | Descrição das mudanças na versão |
| `estado_nucleo` | enum('ATIVO','MIGRANDO','BLOQUEADO') | NULL | 'ATIVO' | Estado atual do núcleo |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação |
| `id_entidade` | bigint unsigned | NULL | NULL | Referência à entidade (opcional) |

## Chaves
- Primária: `id_nucleo`
- Únicas: `uk_nucleo_hash` (`hash_nucleo_estrutura`) - Garante unicidade do hash
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Pode ter entidade associada (opcional)

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Núcleo é inicializado com hash da estrutura padrão
2. Versão de protocolo permite evolução da estrutura
3. Estado ATIVO indica núcleo em operação normal
4. MIGRANDO indica atualização em andamento
5. BLOQUEADO indica núcleo bloqueado por inconsistência
6. Hash permite verificação de integridade de configurações
7. Usado para consistência entre ambientes distribuídos
8. Base para RAIM e healthy checks
9. Integração com assistencial_quorum_clinico para validação