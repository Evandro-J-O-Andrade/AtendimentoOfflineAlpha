# MD-CANONICAL-DOCUMENT-MAP

## Objetivo

Este arquivo é o índice mestra dos arquivos `.md` do repositório. Seu propósito é classificar cada documento em categorias operacionais para permitir governança efetiva e evitar documentação infinita.

## Classificações propostas

- CANON: decisão / contrato canônico da plataforma (fonte de verdade).
- REFERENCE: documentação de suporte (guia, exemplos) derivada de CANON.
- AUDIT: registros imutáveis, logs, dossiês de auditoria.
- DRAFT: rascunhos em progresso, não-canônicos.
- GENERATED: arquivos produzidos automaticamente (dumps, exports).
- OBSOLETE: descontinuados / migrados / arquivados.

## Colunas sugeridas para o índice

- `path` — caminho relativo do arquivo
- `title` — título do documento
- `classification` — uma das categorias acima
- `canonical` — `yes`/`no` (se for fonte de verdade)
- `owner` — time ou pessoa responsável
- `product` — consumidor primário (HIS, Portal, Mobile, BI, etc.)
- `derivedFrom` — referência (ex: bancoMysql.md, script X)
- `generatesSQL` — `yes`/`no` (indica se deve gerar artefatos SQL)
- `notes` — observações rápidas

## Como popular o índice (exemplo rápido)

No Windows PowerShell (na raiz do repo):

```powershell
Get-ChildItem -Recurse -Filter "*.md" | Select-Object -ExpandProperty FullName | ForEach-Object { $_.Replace((Get-Location).Path + '\\', '') } | Set-Content md_files.txt
```

Depois, processe `md_files.txt` para gerar um CSV inicial com as colunas acima (pode ser feito em Python, PowerShell ou Node).

## Workflow recomendado

1. Executar script de varredura para criar lista inicial.
2. Classificar automaticamente alguns arquivos (dumps, docs/generated) como `GENERATED` ou `AUDIT`.
3. Revisão humana para marcar `CANON` e `OBSOLETE`.
4. Bloquear criação de novos `CANON` sem ADR vinculada.

## Próximos passos imediatos

- Gerar CSV inicial (automático).
- Iniciar `REVIEW-KERNEL-TRANSVERSAL.md` para validar lacunas do Kernel.

---

Gerado automaticamente por assistente em apoio à governança (template inicial).
