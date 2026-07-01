# lab_resultado

Objetivo: Armazenar os resultados de exames laboratoriais após processamento.
Descrição: Tabela que contém os resultados dos exames laboratoriais, podendo armazenar o resultado como link para arquivo ou texto livre. Permite identificar resultados críticos que requerem atenção imediata.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_resultado` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do resultado |
| `protocolo_interno` | varchar(100) | NOT NULL | - | Protocolo interno do exame (referência ao pedido) |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `resultado_link` | text | NULL | NULL | Link para o arquivo PDF ou documento do resultado |
| `resultado_texto` | text | NULL | NULL | Texto com o resultado do exame (quando não é arquivo) |
| `critico` | tinyint(1) | NOT NULL | '0' | Indica se o resultado é crítico (1) ou normal (0) |
| `recebido_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do recebimento do resultado |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que recebeu o resultado |
| `id_usuario` | bigint | NULL | NULL | Usuário que recebeu/confirmou o resultado |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_resultado`
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_lab_res_protocolo` (KEY) - Índice em `protocolo_interno`
- `idx_lab_res_ffa` (KEY) - Índice em `id_ffa`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `ffa` - Muitos resultados podem estar associados a um FFA
- N:1 com `usuario` - Muitos resultados podem ter sido recebidos pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitos resultados podem estar associados a uma sessão

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `ffa`, `usuario`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Resultado é recebido do laboratório ou sistema LIMS
2. Armazenado como link (PDF) ou texto dependendo do tipo de exame
3. Flag `critico=1` é setado quando valores estão fora dos limites normais
4. Usado para notificação automática ao médico em resultados críticos
5. Resultado é vinculado ao FFA para disponibilização ao paciente
6. Usado para emissão de relatórios e histórico de exames
7. Integração com prontuário eletrônico para disponibilização ao médico