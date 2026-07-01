# lab_protocolo_interno

Objetivo: Gerenciar protocolos internos de amostras para exames laboratoriais antes da integração com sistemas externos.
Descrição: Tabela que registra protocolos internos de coleta de amostras, antes da integração com sistemas laboratoriais externos. Controla o status da coleta e processamento interno.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador numérico único do protocolo interno |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `codigo_amostra` | varchar(50) | NULL | NULL | Código da amostra coletada |
| `tipo_material` | varchar(50) | NULL | NULL | Tipo de material da amostra (ex: SANGUE, URINA) |
| `status_laboratorial` | enum('COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO') | NULL | NULL | Status do processamento laboratorial |
| `impresso` | tinyint(1) | NULL | '0' | Indica se foi impresso (1) ou não (0) |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: `codigo_amostra` (`codigo_amostra`) - Garante unicidade do código de amostra
- Estrangeiras: -

## Índices
- `fk_lab_protocolo_ffa_v1` (KEY) - Índice em `id_ffa`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `ffa` - Muitos protocolos internos podem estar associados a um FFA

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `ffa`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Protocolo interno é criado quando FFA gera solicitação de exame
2. Código de amostra é atribuído durante o processo
3. Status acompanha a coleta: COLETADO, EM_TRANSPORTE, NA_BANCADA, CONCLUIDO
4. Usado como fase intermediária antes da integração com LIMS externo
5. Permite rastreamento de amostras antes do resultado final
6. Sincronizado com laboratorio_protocolo após integração