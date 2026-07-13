# ASSET-INVENTORY

## Objetivo

Inventariar assets de frontend (imagens, logos, backgrounds, ícones, ilustrações) sem mover arquivos. Fornecer classificação inicial para revisão humana.

## Diretivas

- Não mover nem renomear arquivos.
- Catalogar: `path`, `name`, `type`, `size` (se disponível), `usage_sugerido`, `domain`, `classification` (REUSE / ADAPT / REPLACE / OBSOLETE) e `notes`.
- Marcar `classification` como sugestão; revisão manual obrigatória.

## Inventário preliminar (Captures/dashboard)

| path               | name                    |       type | size | usage_sugerido                   | domain    | classification   | notes                                          |
| ------------------ | ----------------------- | ---------: | ---: | -------------------------------- | --------- | ---------------- | ---------------------------------------------- |
| Captures/dashboard | logo.png                |  image/png |  n/a | Branding principal               | branding  | REUSE (sugerido) | Usado no portal; validar vetor/transparência   |
| Captures/dashboard | logoSemFundo.png        |  image/png |  n/a | Branding alternativo (sem fundo) | branding  | REUSE (sugerido) | Preferir para temas claros/escuros             |
| Captures/dashboard | teladelogin.png         |  image/png |  n/a | Background login                 | login     | REUSE/ADAPT      | Verificar resolução e cortes responsivos       |
| Captures/dashboard | dashboardMedico.jpg     | image/jpeg |  n/a | Hero/dashboard médico            | dashboard | ADAPT            | Recomenda otimizar e gerar variantes webp      |
| Captures/dashboard | baseporta.jpeg          | image/jpeg |  n/a | Exemplo de layout                | portal    | ADAPT            | Revisar direitos autorais e source             |
| Captures/dashboard | frontend.jpeg           | image/jpeg |  n/a | Mock/layout                      | portal    | ADAPT            | Mock — talvez substituir por componentes reais |
| Captures/dashboard | backend e frontend.jpeg | image/jpeg |  n/a | Documentação visual              | docs      | REFERENCE        | Arte informacional                             |
| Captures/dashboard | dashbaoadGestão.jpeg    | image/jpeg |  n/a | Dashboard gestão                 | dashboard | ADAPT            | Revisar clareza dos widgets                    |
| Captures/dashboard | lador do formulario.png |  image/png |  n/a | Ilustração formulário            | portal    | ADAPT            | Checar uso em formulários responsivos          |
| Captures/dashboard | logo.png                |  image/png |  n/a | (duplicate entry noted)          | branding  | REUSE            | Checar duplicatas e consolidar                 |

## Classificação sugerida

- `REUSE`: asset pronto para produção sem alterações.
- `ADAPT`: usar após ajustes (tamanho, compressão, corte).
- `REPLACE`: não adequado, precisa de nova versão.
- `OBSOLETE`: arquivar.

## Próximos passos

1. Gerar sizes e mime-types (script) para preencher coluna `size`.
2. Revisão por design/brand para aprovar `classification`.
3. Migrar assets aprovados para `apps/portal/src/assets` (apenas após aprovação).

Script sugerido (PowerShell) para coletar tamanhos:

```powershell
Get-ChildItem -Recurse -Filter "*.png","*.jpg","*.jpeg","*.svg" | Select-Object FullName,Length | Export-Csv asset-sizes.csv -NoTypeInformation
```

Observação: Não executar migração automática até revisão humana.
