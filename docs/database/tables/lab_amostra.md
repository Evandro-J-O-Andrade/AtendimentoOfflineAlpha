# lab_amostra

Objetivo: Gerenciar amostras de exames laboratoriais coletadas durante atendimentos médicos.
Descrição: Tabela que representa as amostras físicas coletadas para exames laboratoriais, incluindo código de identificação, tipo de material, status de coleta e processamento. Vincula-se ao protocolo de laboratório e ao FFA (Fila de Atendimento) do paciente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_amostra` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da amostra |
| `id_protocolo` | bigint | NOT NULL | - | Referência ao protocolo de laboratório |
| `codigo_amostra` | varchar(50) | NOT NULL | - | Código único de identificação da amostra |
| `tipo_material` | varchar(50) | NULL | NULL | Tipo de material coletado (ex: SANGUE, URINA) |
| `status` | enum('GERADO','COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO','CANCELADO') | NOT NULL | 'GERADO' | Status do ciclo de vida da amostra |
| `impresso` | tinyint(1) | NOT NULL | '0' | Indica se a etiqueta foi impressa (1) ou não (0) |
| `coletado_em` | datetime | NULL | NULL | Timestamp do momento da coleta |
| `id_sessao_coleta` | bigint | NULL | NULL | Sessão do usuário que coletou a amostra |
| `id_usuario_coleta` | bigint | NULL | NULL | Usuário que coletou a amostra |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `atualizado_em` | datetime | NULL | NULL | Timestamp da última atualização |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_amostra`
- Únicas: `uk_lab_codigo` (`codigo_amostra`) - Garante unicidade do código da amostra
- Estrangeiras: 
  - `fk_lab_amostra_protocolo` (`id_protocolo`) → `lab_protocolo` (`id_protocolo`) - Relaciona amostra ao protocolo; RESTRICT na deleção
  - `fk_lab_proto` (`id_protocolo`) → `procedimento_protocolo` (`id_protocolo`) - Relaciona ao protocolo de procedimento
  - `fk_lab_user_col` (`id_usuario_coleta`) → `usuario` (`id_usuario`) - Identifica o usuário que coletou

## Índices
- `idx_lab_status` (KEY) - Índice composto em `status` e `criado_em` para filtros de status
- `fk_lab_sessao_col` (KEY) - Índice em `id_sessao_coleta`
- `fk_lab_user_col` (KEY) - Índice em `id_usuario_coleta`
- `idx_lab_amostra_protocolo_ffa` (KEY) - Índice composto em `id_protocolo` e `id_ffa`
- `idx_lab_amostra_ffa` (KEY) - Índice em `id_ffa`
- `idx_lab_amostra_protocolo` (KEY) - Índice em `id_protocolo`

## Constraints
- `fk_lab_amostra_protocolo` FOREIGN KEY - Relaciona `id_protocolo` com `lab_protocolo`.`id_protocolo` (ON DELETE RESTRICT ON UPDATE CASCADE)
- `fk_lab_proto` FOREIGN KEY - Relaciona `id_protocolo` com `procedimento_protocolo`.`id_protocolo`
- `fk_lab_user_col` FOREIGN KEY - Relaciona `id_usuario_coleta` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `lab_protocolo` - Muitas amostras podem pertencer a um protocolo de laboratório
- N:1 com `procedimento_protocolo` - Muitas amostras podem estar associadas a um protocolo de procedimento
- N:1 com `usuario` - Muitas amostras podem ter sido coletadas pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitas amostras podem estar associadas a uma sessão
- N:1 com `ffa` - Muitas amostras podem estar associadas a um FFA

## Dependências
- Esta tabela é referenciada por: `lab_resultado` (via protocolo_interno indireto), `laboratorio_protocolo`
- Esta tabela depende de: `lab_protocolo`, `procedimento_protocolo`, `usuario`, `sessao_usuario`, `ffa`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Amostra é criada com status GERADO quando protocolo é gerado
2. O código de barras/etiqueta é impresso (`impresso=1`)
3. Usuário coleta a amostra mudando status para COLETADO
4. A amostra entra em EM_TRANSPORTE até chegar à bancada
5. Na bancada, status muda para NA_BANCADA
6. Após processamento, status CONCLUIDO indica amostra processada
7. Amostras podem ser CANCELADO em caso de erro
8. Usado para controle de qualidade e rastreabilidade de exames