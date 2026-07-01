# internacao_ferida_avaliacao

Objetivo: Avaliar feridas e lesões por pressão (LPP) em pacientes internados.

Descrição: Tabela que registra avaliações de feridas, lesões por pressão (LPP) e cirurgias em pacientes internados, incluindo características clínicas, dimensões, aspecto, dreno e curativo. Utilizada para documentação e acompanhamento de feridas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_internacao_ferida_avaliacao | bigint | NOT NULL | - | Identificador único da avaliação, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação onde a ferida foi avaliada |
| data_hora | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora da avaliação |
| tipo | enum('FERIDA','LPP','CIRURGICA','OUTRA') | NOT NULL | 'FERIDA' | Tipo de lesão: ferida comum, LPP (lesão por pressão), cirúrgica ou outra |
| local_anatomico | varchar(120) | NOT NULL | - | Localização anatômica da ferida no paciente |
| estagio_lpp | enum('I','II','III','IV','NAO_CLASSIFICAVEL','TECIDO_PROFUNDO') | DEFAULT NULL | - | Estágio da LPP: I, II, III, IV, não classificável ou tecido profundo |
| tamanho_cm | varchar(60) | DEFAULT NULL | - | Tamanho da ferida em centímetros (ex: 5x3 cm) |
| aspecto | varchar(120) | DEFAULT NULL | - | Aspecto da ferida (ex: exsudativa, necrótica) |
| exsudato | enum('AUSENTE','POUCO','MODERADO','ABUNDANTE') | DEFAULT NULL | - | Quantidade de exsudato: ausente, pouco, moderado ou abundante |
| odor | enum('NAO','SIM') | DEFAULT NULL | - | Presença de odor: não ou sim |
| dor | enum('NAO','SIM') | DEFAULT NULL | - | Presença de dor: não ou sim |
| curativo | text | DEFAULT NULL | - | Tipo de curativo aplicado |
| observacoes | text | DEFAULT NULL | - | Observações complementares sobre a avaliação |
| id_documento | bigint | DEFAULT NULL | - | Referência ao documento de emissão |
| id_usuario_responsavel | bigint | NOT NULL | - | Referência ao usuário que realizou a avaliação |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_internacao_ferida_avaliacao
- Únicas: -
- Estrangeiras: fk_ifa_documento (id_documento → documento_emissao.id_documento); fk_ifa_internacao (id_internacao → internacao.id_internacao); fk_ifa_usuario (id_usuario_responsavel → usuario.id_usuario)

## Índices
- idx_ifa_internacao (id_internacao)
- idx_ifa_data_hora (data_hora)
- idx_ifa_usuario (id_usuario_responsavel)
- idx_ifa_sessao (id_sessao_usuario)
- idx_ifa_documento (id_documento)

## Constraints
- CONSTRAINT fk_ifa_documento FOREIGN KEY (id_documento) REFERENCES documento_emissao (id_documento)
- CONSTRAINT fk_ifa_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT fk_ifa_usuario FOREIGN KEY (id_usuario_responsavel) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- internacao_ferida_avaliacao.id_internacao → internacao (id_internacao): N:1 (várias avaliações podem referenciar a mesma internação)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, documento_emissao, usuario

## Fluxo de utilização dentro do sistema
1. Enfermeiro avalia ferida/LPP do paciente internado
2. tipo define a categoria da lesão
3. local_anatomico registra onde está a lesão
4. estagio_lpp classifica o estágio (quando for LPP)
5. tamanho_cm, aspecto, exsudato, odor, dor caracterizam a ferida
6. curativo registra tratamento aplicado
7. Histórico é mantido para acompanhamento evolutivo