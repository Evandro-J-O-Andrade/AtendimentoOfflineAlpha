# FRONT-084 — Estratégia de Assets Responsivos do Portal Enterprise

> **Status:** Aprovado  
> **Domínio:** FRONT  
> **Tipo:** Estratégia de Assets e UX  
> **Companheiro:** FRONT-001 (Login), FRONT-003 (Portal Enterprise), FRONT-017 (Theme Experience), MD-109 (Display Event Distribution Engine)

---

## 1. Objetivo

Padronizar a utilização de imagens de fundo (Hero Backgrounds) em todo o ecossistema New Wave Enterprise Platform, garantindo:

- máxima qualidade visual;
- estabilidade durante troca de tema;
- desempenho;
- ausência de deslocamentos (layout shift);
- renderização consistente em qualquer resolução.

---

## 2. Problema

Utilizar uma única imagem para todas as resoluções causa diversos problemas:

- reposicionamento da imagem durante mudança de tema;
- mudança perceptível do enquadramento;
- perda de qualidade;
- cortes diferentes conforme resolução;
- recálculo do `background-size: cover`;
- CLS (Cumulative Layout Shift).

Esses efeitos são perceptíveis principalmente durante a alternância entre Light e Dark Theme.

---

## 3. Princípio Arquitetural

O Portal Enterprise **NÃO** utiliza uma única imagem para todas as telas.

Cada breakpoint possui seu próprio asset otimizado.

Cada tema possui sua própria composição gráfica.

---

## 4. Estrutura Oficial

```
assets/
├── login/
│   └── hero/
│       ├── desktop-dark.webp
│       ├── desktop-light.webp
│       ├── notebook-dark.webp
│       ├── notebook-light.webp
│       ├── tablet-dark.webp
│       ├── tablet-light.webp
│       ├── mobile-dark.webp
│       └── mobile-light.webp
```

---

## 5. Breakpoints Oficiais

| Dispositivo | Largura |
|-------------|---------|
| Desktop XL | ≥ 1600px |
| Desktop | 1280–1599px |
| Notebook | 1024–1279px |
| Tablet | 768–1023px |
| Mobile | ≤ 767px |

---

## 6. Regras de Utilização

Cada breakpoint utiliza exclusivamente sua imagem correspondente.

Jamais utilizar uma única imagem para todas as resoluções.

Exemplo:

- Desktop → `desktop-dark.webp`
- Notebook → `notebook-dark.webp`
- Tablet → `tablet-dark.webp`
- Mobile → `mobile-dark.webp`

---

## 7. Troca de Tema

A mudança entre Light e Dark nunca altera:

- `background-size`;
- `background-position`;
- `background-repeat`;
- `background-attachment`.

A única alteração permitida é:

```css
background-image
```

Exemplo:

```css
.themeDark .leftPanel {
  background-image: url('desktop-dark.webp');
}

.themeLight .leftPanel {
  background-image: url('desktop-light.webp');
}
```

---

## 8. Background

Todos os Hero Backgrounds seguem obrigatoriamente:

```css
background-repeat: no-repeat;
background-position: center center;
background-size: cover;
background-attachment: scroll;
```

Não alterar estes parâmetros durante runtime.

---

## 9. Overlay

O Overlay deve ser independente da imagem.

Estrutura:

```
Hero
├── Imagem
├── Overlay
└── Conteúdo
```

Nunca incorporar o overlay diretamente na arte.

---

## 10. Estrutura Visual

```
Hero
│
├── Background
├── Overlay
├── Blur (quando necessário)
├── Logo
├── Texto
├── Ícones
```

Cada camada possui responsabilidade única.

---

## 11. Responsividade

A seleção da imagem deve ocorrer exclusivamente através de Media Queries.

Exemplo:

```css
@media (max-width: 1600px) {
  .leftPanel {
    background-image: url('hero-notebook.webp');
  }
}

@media (max-width: 1024px) {
  .leftPanel {
    background-image: url('hero-tablet.webp');
  }
}

@media (max-width: 768px) {
  .leftPanel {
    background-image: url('hero-mobile.webp');
  }
}
```

---

## 12. Mobile

No Mobile não é obrigatório utilizar a mesma composição do Desktop.

É recomendado utilizar uma arte específica.

Objetivos:

- preservar leitura;
- evitar cortes importantes;
- reduzir tamanho do arquivo;
- melhorar desempenho.

---

## 13. Performance

Todos os Hero Assets devem utilizar:

- WebP;
- Compressão otimizada;
- Lazy Loading quando aplicável;
- Cache de longo prazo.

---

## 14. Benefícios

Esta arquitetura elimina:

- layout shift;
- movimentação da imagem ao trocar tema;
- reflow visual;
- perda de enquadramento;
- diferenças entre navegadores.

Também melhora:

- UX;
- performance;
- branding;
- estabilidade visual.

---

## 15. Padrão Corporativo

Esta especificação aplica-se obrigatoriamente aos seguintes componentes:

- Login Enterprise
- Portal Enterprise
- Landing Pages
- Dashboard Principal
- Tela Inicial dos Módulos
- Splash Screens
- Wizards Corporativos

---

## 16. Compatibilidade

Compatível com:

- React;
- Vite;
- CSS Modules;
- Tailwind;
- Next.js;
- Electron;
- PWA.

---

## Estado

**Aprovado para utilização como padrão oficial da New Wave Enterprise Platform.**
