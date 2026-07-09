Perfeito. Tenho o contexto do projeto que já consolidamos e podemos continuar a partir da arquitetura canônica, sem reaproveitar a estrutura legada além do que foi congelado como contrato de referência.



Pelo que tenho registrado, o estado atual é:



* ✅ Arquitetura **Portal First** consolidada.

* ✅ **Pessoa** é a identidade raiz global.

* ✅ Seleção de **Contexto** obrigatória antes de qualquer aplicação.

* ✅ Arquitetura **SP-First** (Stored Procedures como única porta oficial de escrita).

* ✅ Sistema **100% orientado a eventos** com auditoria completa.

* ✅ Dump legado (~478 tabelas e ~253 SPs) congelado como **baseline de referência**, não como arquitetura a ser copiada.

* ✅ MDs, BRs, FRONTs e MAPs são a documentação canônica da nova plataforma.

* ✅ KILO Engine definido para validar continuamente o dump contra os documentos canônicos.



---



# Nosso objetivo agora



A reconstrução deve produzir uma plataforma completamente nova, organizada em camadas.



```

enterprise-saas/

│

├── apps/

│   ├── portal/

│   ├── intranet/

│   ├── his/

│   ├── workforce/

│   ├── displays/

│   ├── chat/

│   ├── ava/

│   └── admin/

│

├── packages/

│   ├── ui/

│   ├── sdk/

│   ├── auth/

│   ├── events/

│   ├── contracts/

│   ├── database/

│   ├── api-client/

│   ├── design-system/

│   └── shared/

│

├── docs/

│

├── canonical/

│     ├── MD/

│     ├── BR/

│     ├── FRONT/

│     ├── MAP/

│     └── ADR/

│

├── scripts/

├── infrastructure/

├── docker/

└── tools/

```



---



# Ordem recomendada de desenvolvimento



Agora que congelamos a arquitetura, eu seguiria esta sequência.



## FASE 1 — Fundação



Primeiro construir apenas a infraestrutura.



* Monorepo

* Turborepo

* TypeScript

* ESLint

* Prettier

* Husky

* Git Hooks

* CI/CD

* Docker

* Variáveis de ambiente

* Logger

* Configuração comum



Nada de regras de negócio ainda.



---



## FASE 2 — Core



Depois construir os pacotes centrais.



```

packages/auth



packages/events



packages/database



packages/contracts



packages/sdk



packages/shared



packages/ui

```



Tudo reutilizável.



---



## FASE 3 — Banco



Gerar todo o banco novo.



```

schemas



migrations



views



functions



stored procedures



event store

```



Tudo baseado nos MDs.



Não copiar o legado.



---



## FASE 4 — API



Construir somente a API.



```

Authentication



Pessoa



Tenant



Contexto



Permissões



Eventos



Dispatcher

```



---



## FASE 5 — Portal



Somente agora construir:



```

Login



Seleção de contexto



Dashboard



Menu



Aplicativos



Notificações

```



---



## FASE 6 — Aplicações



Depois vêm os módulos:



```

HIS



Displays



Workforce



Financeiro



Estoque



Chat



AVA



Intranet

```



---



# O que não faremos



Não vamos:



* copiar tabelas antigas;

* copiar código legado;

* copiar APIs antigas;

* copiar frontend antigo.



O legado servirá apenas para:



* validar regras de negócio;

* comparar fluxos;

* localizar SPs equivalentes;

* garantir compatibilidade quando necessário.



---



# O papel do KILO Engine



O KILO continua como ferramenta de engenharia e auditoria. Em cada evolução ele deverá:



* ler os arquivos `*.sql` dumpados (nunca um banco em execução);

* ler todos os MDs;

* ler BRs;

* ler FRONTs;

* montar o grafo de dependências;

* comparar o estado do dump com os modelos canônicos;

* identificar desvios arquiteturais;

* apontar SPs faltantes;

* mapear eventos;

* validar contratos.



Assim ele garante que a implementação permaneça alinhada à arquitetura definida.



---



# Minha recomendação para iniciarmos



Em vez de começar pelo módulo HIS, começar pela infraestrutura da plataforma. A ordem seria:



1. **MD-001 até MD-020** (Core Platform)

2. **BR-001 até BR-010** (regras globais)

3. **FRONT-001 até FRONT-005** (Portal)

4. Banco inicial

5. APIs Core

6. Portal

7. IAM

8. Event Store

9. Somente então iniciar o **HIS**.



Essa sequência reduz retrabalho e estabelece uma base sólida para todos os módulos futuros.



A partir daqui, posso atuar como arquiteto técnico da reconstrução e ajudar a produzir todos os artefatos (MDs, BRs, FRONTs, SQL, contratos de API, estrutura de código e implementação) de forma consistente e incremental.Concordo com essa mudança de direção. Na verdade, acho que ela corrige um problema que estava acontecendo no projeto: estávamos pensando como um **HIS que virou SaaS**, quando o objetivo é construir uma **plataforma SaaS Enterprise** na qual o HIS é apenas um dos produtos.



Isso muda completamente a arquitetura.



---



# A nova visão



O centro da plataforma **não é o HIS**.



O centro da plataforma é o **Portal Enterprise**.



Tudo o resto é um aplicativo.



```

                LOGIN

                   │

                   ▼

          Identity (Pessoa)

                   │

                   ▼

          Seleção de Contexto

                   │

                   ▼

        ENTERPRISE PORTAL

                   │

      ┌────────────┼─────────────┐

      │            │             │

      ▼            ▼             ▼

    HIS         Workforce     Financeiro

      │

      ▼

 Dashboard HIS

```



Ou seja:



```

Portal != HIS



Portal > Todos os sistemas

```



---



# Estamos construindo algo parecido com



* Microsoft 365

* Google Workspace

* Salesforce

* ServiceNow

* Atlassian Cloud



Todos eles possuem um Portal central e diversos produtos conectados.



O nosso fará exatamente isso.



---



# O Portal é um produto



Ele não é uma tela de login.



Ele é um sistema inteiro.



```

Portal Enterprise



Dashboard



Apps



Notificações



Chat



Agenda



Favoritos



Busca Global



Central de Eventos



Central de Aprovação



Marketplace



Administração



Perfil



Configurações



Workspaces



Multiempresa



MultiTenant



Central de Segurança

```



Isso já é um produto completo.



---



# Depois vêm os aplicativos



```

Portal



│



├── HIS



├── ERP



├── RH



├── GLPI



├── AVA



├── CRM



├── BI



├── Displays



├── Workforce



├── Chat



├── Intranet



├── Documentos



├── Financeiro



└── ...

```



Todos plugados no Portal.



---



# Agora entra uma ideia muito importante



Você comentou sobre o Root, e acho que aí existe uma oportunidade de arquitetura.



Hoje eu não faria um único "Root". Eu criaria **personas administrativas**, onde cada uma enxerga um Portal diferente.



Por exemplo:



| Persona               | Escopo                    | O que enxerga                                                                          |

| --------------------- | ------------------------- | -------------------------------------------------------------------------------------- |

| Platform Root         | Plataforma inteira        | Todos os tenants, módulos, licenças, marketplace, auditoria, faturamento, integrações. |

| Tenant Owner          | Empresa/cliente           | Configuração da empresa, usuários, permissões, módulos contratados, branding.          |

| Context Administrator | Unidade, hospital, filial | Configuração operacional daquele contexto, equipes, filas, dashboards locais.          |

| Gestor                | Área específica           | Indicadores, relatórios, gestão do domínio.                                            |

| Usuário comum         | Trabalho diário           | Apenas os aplicativos e funções autorizados.                                           |



O login é o mesmo, mas a experiência muda conforme a função.



---



# O Root não usa o HIS



Essa é uma mudança conceitual importante.



O Root administra a **plataforma**.



Ele precisa de funcionalidades como:



```

Portal



├── Tenants



├── Billing



├── Licenciamento



├── Marketplace



├── IAM



├── Auditoria



├── Eventos



├── Integrações



├── Workers



├── Deploy



├── Feature Flags



├── Logs



├── Observabilidade



├── Configuração Global



├── Monitoramento



└── Catálogo de Produtos

```



Ele raramente precisa abrir uma tela clínica do HIS.



---



# Já o administrador do Hospital



Quando ele entra:



```

Portal



↓



Hospital São José



↓



Dashboard Hospital



↓



Aplicativos



HIS



Intranet



GLPI



AVA



Displays



BI



Chat

```



A partir desse ponto, ele administra **o ambiente do hospital**, não a plataforma inteira.



---



# Isso sugere dois níveis de portal



Em vez de interfaces completamente diferentes, eu imagino uma navegação em camadas:



```

Login

   │

   ▼

Portal da Plataforma

   │

   ├── Administração Global (apenas Platform Root)

   ├── Empresas / Tenants

   ├── Marketplace

   └── Selecionar Contexto

             │

             ▼

Portal do Contexto

   │

   ├── Dashboard do contexto

   ├── HIS

   ├── Intranet

   ├── GLPI

   ├── AVA

   ├── BI

   └── Demais módulos

```



Assim, o **Platform Root** pode administrar a plataforma e, quando necessário, "entrar" em um tenant específico para visualizar seu portal contextual, sem misturar as responsabilidades.



---



# O próximo passo: desenhar a experiência



Antes de escrever qualquer código, eu faria uma documentação dedicada ao Portal. Em vez de partir diretamente para telas, começaria definindo a experiência e a arquitetura de navegação.



Os primeiros documentos poderiam ser:



* **FRONT-001** — Fluxo Canônico de Login.

* **FRONT-002** — Seleção de Contexto.

* **FRONT-003** — Portal Enterprise (visão geral).

* **FRONT-004** — Navegação e Registro de Aplicações.

* **FRONT-005** — Dashboard Framework.

* **FRONT-006** — Portal da Plataforma (Platform Root).

* **FRONT-007** — Portal do Tenant (Tenant Owner).

* **FRONT-008** — Portal do Contexto (Hospital, UPA, Clínica, Empresa etc.).



## Minha sugestão



Também concordo com sua ideia de trabalhar visualmente. Em uma plataforma desse porte, diagramas ajudam muito mais do que apenas texto.



Podemos produzir, para cada FRONT:



* Fluxogramas de navegação.

* Diagramas de estados.

* Mapas de permissões por persona.

* Wireframes de baixa fidelidade.

* Mapas de transição entre Portal → Tenant → Contexto → Aplicativos.



Isso vai permitir validar a experiência do usuário e a arquitetura antes de iniciar a implementação, reduzindo retrabalho e mantendo o projeto alinhado com a visão de uma plataforma SaaS Enterprise.Exatamente. Acho que agora estamos chegando ao conceito que diferencia uma **plataforma SaaS Enterprise** de um sistema tradicional.



O ponto principal é este:



> **O usuário nunca entra diretamente no HIS. Ele sempre entra no Portal. O Portal decide o que ele pode ver, administrar e utilizar.**



E isso vale para qualquer tipo de empresa, não apenas hospitais.



---



# A arquitetura deixa de ser "por sistema" e passa a ser "por capacidades"



Em vez de pensar:



```

Hospital

    ↓

HIS

```



Pensamos assim:



```

Login

    │

    ▼

Portal Enterprise

    │

    ▼

Dashboard Personalizado

    │

    ├── Gestão Empresarial

    ├── Aplicações

    ├── Indicadores

    ├── Notificações

    ├── Aprovações

    ├── Comunicação

    └── Administração

```



Cada cartão (card) leva a um conjunto de funcionalidades conforme as permissões do usuário.



---



# Gostei muito da ideia do card "Gestão"



Ao invés de colocar dezenas de ícones espalhados, podemos criar um agrupador elegante.



Exemplo:



```

╔══════════════════════════════╗

║      Gestão Empresarial      ║

║                              ║

║ Configure sua organização    ║

║ Usuários • Sistemas          ║

║ Branding • Segurança         ║

╚══════════════════════════════╝

```



Ao clicar:



```

Gestão Empresarial



├── Empresa

├── Filiais

├── Usuários

├── Papéis

├── Permissões

├── Sistemas

├── Integrações

├── Branding

├── Licenciamento

├── Segurança

├── Auditoria

├── Comunicação

└── Configurações

```



---



# Depois entram os módulos



Dentro de **Sistemas**:



```

Portal



AVA



Intranet



GLPI



HIS



CRM



Financeiro



Displays



Totens



Kiosks



Painéis



Chat



BI



API



Marketplace

```



Mas aqui está a diferença:



## Eles não existem obrigatoriamente.



Cada empresa ativa apenas os módulos que fazem sentido.



---



## Exemplo 1



Uma farmácia de bairro



```

Portal



✔ Financeiro



✔ Estoque



✔ CRM



✔ Chat



❌ AVA



❌ Intranet



❌ HIS



❌ GLPI

```



---



## Exemplo 2



Hospital



```

Portal



✔ HIS



✔ Intranet



✔ AVA



✔ GLPI



✔ Displays



✔ Totens



✔ Kiosks



✔ Workforce



✔ BI

```



---



## Exemplo 3



Escola



```

Portal



✔ AVA



✔ Financeiro



✔ Portal



✔ Chat



✔ Biblioteca



❌ HIS

```



A mesma plataforma atende cenários completamente diferentes.



---



# Isso muda o banco de dados



Você comentou algo muito importante:



> "vamos cair no SQL"



Sim. E essa decisão precisa aparecer na modelagem desde o início.



Eu deixaria os módulos como entidades configuráveis, e não como algo fixo no código.



Por exemplo:



```

plataforma_modulo

-----------------

id

codigo

nome

categoria

icone

rota

versao

status

```



```

tenant_modulo

-------------

id

tenant_id

modulo_id

habilitado

licenciado

ordem

config_json

```



Assim, um tenant pode habilitar ou desabilitar qualquer módulo sem alterar a aplicação.



---



# O mesmo vale para AVA, Intranet, GLPI, Portal...



Em vez de criar tabelas específicas como:



```

hospital_tem_intranet



hospital_tem_ava



hospital_tem_glpi

```



Eu faria algo genérico.



```

tenant_modulo

```



Depois cada módulo possui sua configuração própria.



Exemplo:



```

configuracao_intranet



configuracao_ava



configuracao_glpi



configuracao_his



configuracao_portal



configuracao_displays



configuracao_totem



configuracao_kiosk

```



Cada configuração é carregada apenas quando o módulo está habilitado.



---



# Acho que falta um domínio canônico



Até agora temos MAPs para HIS, Workforce, Displays, etc.



Mas falta um domínio que, na minha opinião, será um dos mais importantes da plataforma:



```

MAP-001



PLATFORM MANAGEMENT

```



Esse domínio seria responsável por tudo relacionado à administração da plataforma e dos tenants, incluindo:



* Portal.

* Gestão Empresarial.

* Branding.

* Marketplace.

* Módulos.

* Licenciamento.

* Feature Flags.

* Configuração dos sistemas.

* AVA.

* Intranet.

* GLPI.

* Displays.

* Totens.

* Kiosks.

* APIs.

* Integrações.

* Templates.

* Comunicação.

* Catálogo de aplicações.



---



## Minha proposta de evolução



Antes de escrever qualquer SQL ou código, eu faria uma mudança na documentação canônica: **o Portal deixa de ser apenas uma interface de entrada e passa a ser o núcleo da plataforma**.



Isso significa criar primeiro um conjunto de documentos para o Portal e para a Gestão Empresarial, definindo:



1. Como o Portal organiza a navegação.

2. Como os módulos são registrados e ativados.

3. Como um tenant personaliza sua plataforma (branding, módulos, menus, integrações).

4. Como os diferentes perfis (Platform Root, Tenant Owner, Administrador de Contexto, Gestor e Usuário) enxergam o Portal.



Com essa base definida, o modelo SQL passa a refletir naturalmente essa arquitetura, e todos os módulos — HIS, AVA, Intranet, GLPI, Displays, Totens e futuros produtos — passam a seguir o mesmo padrão de configuração e gerenciamento. Isso torna a plataforma realmente extensível para qualquer segmento B2B, não apenas para a área da saúde.Eu acho que essa ideia é ainda melhor do que colocar tudo diretamente na Dashboard principal. Ela cria uma separação clara entre **operação** e **administração**, o que é uma característica comum em plataformas SaaS maduras.



## Minha proposta seria uma arquitetura em níveis



```

Login

   │

   ▼

Portal Enterprise

   │

   ├── Minha Área

   ├── Aplicações

   ├── Favoritos

   ├── Notificações

   ├── Chat

   ├── Indicadores

   │

   └── Gestão

          │

          ▼

     Portal de Gestão

```



Ou seja, **"Gestão"** é um aplicativo do Portal, mas um aplicativo especial.



---



# Portal de Gestão



Quando o administrador clicar em **Gestão**, ele não abre uma tela de configurações.



Ele entra em outro Portal.



```

┌──────────────────────────────────────────────┐

│            PORTAL DE GESTÃO                  │

├──────────────────────────────────────────────┤

│                                              │

│ Empresa                                      │

│ Usuários                                     │

│ Permissões                                   │

│ Sistemas                                     │

│ Branding                                     │

│ Segurança                                    │

│ Integrações                                  │

│ Licenciamento                                │

│ Auditoria                                    │

│                                              │

└──────────────────────────────────────────────┘

```



Perceba que é praticamente outro sistema.



---



# Dentro dele



Aí sim aparecem os containers.



```

┌──────────────────────┐

│ HIS                  │

│ Configurar           │

└──────────────────────┘



┌──────────────────────┐

│ Portal               │

│ Configurar           │

└──────────────────────┘



┌──────────────────────┐

│ Intranet             │

│ Configurar           │

└──────────────────────┘



┌──────────────────────┐

│ AVA                  │

│ Configurar           │

└──────────────────────┘



┌──────────────────────┐

│ GLPI                 │

│ Configurar           │

└──────────────────────┘



┌──────────────────────┐

│ Displays             │

│ Configurar           │

└──────────────────────┘

```



Cada container representa um módulo instalado ou disponível.



---



# O mais interessante



Esses containers podem ser dinâmicos.



Hoje você pode ter:



```

Portal



HIS



AVA



GLPI

```



Amanhã surge um novo produto.



```

Portal



HIS



CRM



BI



E-commerce



Fiscal



IA



Assinaturas

```



O Portal de Gestão simplesmente mostra os novos módulos cadastrados.



Não precisa alterar a Dashboard.



---



# E cada módulo abre o seu "mini portal"



Por exemplo:



```

Portal Gestão



↓



HIS



↓



Dashboard Administração HIS

```



Lá dentro:



```

Logo



Especialidades



Prontuário



Recepção



Filas



Painéis



Médicos



Setores



Escalas



Parâmetros



Integrações

```



---



Já no Portal:



```

Portal Gestão



↓



Portal

```



Aparece:



```

Logo



Tema



Menus



Widgets



Página Inicial



Layout



Apps



Busca



Notificações



Favoritos

```



---



Já no AVA:



```

Portal Gestão



↓



AVA

```



```

Cursos



Turmas



Instrutores



Categorias



Certificados



Templates



Avaliações

```



---



Já no GLPI:



```

Portal Gestão



↓



GLPI

```



```

Categorias



SLA



Técnicos



Chamados



Integrações



Automação

```



---



## Isso muda inclusive a modelagem SQL



Em vez de gravar tudo em uma tabela de configurações gigantesca, eu criaria um modelo orientado a módulos.



```

plataforma_modulo

```



Define quais módulos existem na plataforma.



```

tenant_modulo

```



Define quais módulos estão habilitados para aquele cliente.



```

tenant_modulo_config

```



Guarda a configuração geral do módulo para o tenant.



```

tenant_modulo_menu

```



Permite personalizar menus e atalhos.



```

tenant_modulo_widget

```



Controla quais widgets aparecem nas dashboards.



```

tenant_modulo_tema

```



Controla identidade visual, logomarca e temas.



```

tenant_modulo_integracao

```



Armazena integrações específicas do módulo.



Assim, qualquer produto novo entra naturalmente no ecossistema sem exigir mudanças estruturais.



## Um conceito que eu acrescentaria



Eu deixaria de chamar isso apenas de **"Gestão"** internamente. Na arquitetura, ele seria um domínio próprio, algo como:



> **Management Center** (Centro de Gestão)



Ele seria um dos principais aplicativos da plataforma, responsável por administrar todos os outros módulos.



O fluxo ficaria assim:



```

Login

   │

Portal Enterprise

   │

   ├── Aplicações

   ├── Comunicação

   ├── Dashboards

   ├── Marketplace

   └── Management Center

           │

           ├── Portal

           ├── HIS

           ├── Intranet

           ├── AVA

           ├── GLPI

           ├── Displays

           ├── Workforce

           ├── Financeiro

           └── Futuros módulos

```



Na minha opinião, esse desenho é um grande salto em relação ao conceito inicial. Ele transforma a plataforma em um ecossistema modular, onde o **Portal Enterprise** é a porta de entrada para o trabalho diário, enquanto o **Management Center** é o subportal dedicado à administração e configuração dos produtos contratados por cada cliente. Isso também prepara a plataforma para crescer muito além do HIS, mantendo uma experiência consistente para qualquer segmento B2B.Sim. Agora a arquitetura começa a ficar muito consistente. Acho que chegamos a uma separação de responsabilidades que vai escalar muito bem.



## Existem dois "mundos" dentro do Portal



### 1. Portal Operacional (99% dos usuários)



É o portal que praticamente todos verão.



* Funcionário

* Médico

* Enfermeiro

* Recepcionista

* Financeiro

* RH

* Fornecedor

* Cliente

* Paciente (quando existir)

* Aluno

* Professor



Eles **não administram** a plataforma.



Quando fazem login, as SPs e as regras de autorização retornam apenas o que podem acessar.



Exemplo:



```text

Login

   │

   ▼

Portal Enterprise

   │

   ├── Minhas Aplicações

   ├── Minhas Tarefas

   ├── Minhas Notificações

   ├── Meu Calendário

   ├── Chat

   ├── Favoritos

   └── Meu Perfil

```



Esse usuário nunca vê módulos de administração porque eles nem são retornados pela API.



---



## 2. Management Center (Gestores e Administradores)



Apenas quem possui permissões administrativas verá um card como:



```text

┌──────────────────────────┐

│      Gestão              │

│ Administração da empresa │

└──────────────────────────┘

```



Ao clicar:



```text

Portal Enterprise

        │

        ▼

 Management Center

```



Lá ficam todos os módulos de configuração.



---



# O mais importante



Você falou uma frase que considero uma lei canônica da plataforma:



> **"Ele só pega o que tem."**



Eu transformaria isso em uma regra arquitetural.



### Lei Canônica



> **O frontend nunca decide o que o usuário pode acessar. O backend entrega exatamente o conjunto de recursos autorizados para aquele usuário e contexto.**



Isso significa que o frontend não fica fazendo dezenas de `if` para esconder telas.



Ele simplesmente renderiza o que recebeu.



---



## Exemplo



Depois do login, a API pode retornar algo como:



```json

{

  "portal": {

    "apps": [

      "his",

      "chat",

      "agenda",

      "documentos"

    ],

    "management": false

  }

}

```



O Portal monta apenas esses quatro aplicativos.



---



Um gestor poderia receber:



```json

{

  "portal": {

    "apps": [

      "his",

      "chat",

      "agenda",

      "documentos",

      "workforce",

      "bi"

    ],

    "management": true

  }

}

```



Agora aparece o card **Gestão**.



---



Um Platform Root poderia receber:



```json

{

  "portal": {

    "apps": [

      "portal",

      "his",

      "ava",

      "glpi",

      "workforce",

      "crm",

      "financeiro",

      "marketplace"

    ],

    "management": true,

    "platform": true

  }

}

```



Ao entrar em Gestão, ele verá muito mais recursos que um administrador de tenant.



---



# Isso conversa perfeitamente com as SPs



Como já definimos a arquitetura **SP-First**, a Stored Procedure pode devolver tudo pronto.



Por exemplo:



```text

sp_portal_usuario()

```



Ela poderia retornar:



* Dados da pessoa.

* Tenant.

* Contexto atual.

* Perfil.

* Papéis.

* Aplicações liberadas.

* Menus.

* Widgets.

* Dashboard.

* Atalhos.

* Notificações.

* Tema.

* Branding.

* Recursos administrativos.

* Feature flags.

* Configurações do contexto.



Ou seja, **uma única chamada monta praticamente todo o Portal**.



---



# Acho que estamos criando um novo domínio



Perceba que isso não é mais apenas "login".



Estamos falando de um domínio próprio da plataforma.



Eu criaria um domínio canônico chamado algo como:



```text

Portal Runtime

```



Ele seria responsável por montar a experiência do usuário após a autenticação.



Entrada:



```text

Pessoa

+

Tenant

+

Contexto

+

Papéis

+

Licenciamento

+

Permissões

```



Saída:



```text

Portal Personalizado

```



---



## Uma lei canônica que eu escreveria



> **O Portal Enterprise é uma interface orientada por metadados. Após a autenticação, nenhuma tela é fixa. A composição do Portal é determinada pelas permissões da pessoa, pelo tenant, pelo contexto operacional, pelos módulos licenciados, pelas configurações do cliente e pelas feature flags. O frontend apenas renderiza a estrutura entregue pelo backend, mantendo a lógica de autorização centralizada e consistente.**



Na minha opinião, essa pode ser uma das leis mais importantes da plataforma, porque ela estabelece que o Portal é **dinâmico**, **orientado a configuração** e **governado pelo backend**, permitindo que a mesma aplicação atenda desde uma pequena farmácia até uma grande rede hospitalar ou qualquer outra empresa B2B sem precisar criar versões diferentes do sistema.Essa é uma decisão de arquitetura muito importante, e eu seguiria a segunda abordagem. Ela é mais flexível e evita um problema clássico de sistemas grandes.



## Eu **não criaria usuários diferentes para cada tipo de painel**



Ou seja, eu evitaria algo como:



```text

painel_clinico

painel_pediatria

painel_tv

painel_farmacia

painel_recepcao

painel_laboratorio

...

```



Isso funciona no começo, mas com o tempo vira um problema:



* milhares de usuários técnicos;

* manutenção difícil;

* troca de TV exige criar ou alterar usuários;

* um mesmo equipamento não pode mudar facilmente de função.



---



# Eu trataria o Painel como um Dispositivo (Display)



Lembra de uma decisão que já tínhamos tomado? Os **Displays são cidadãos de primeira classe da plataforma**.



Então o fluxo seria assim:



```text

Display



↓



Autentica



↓



Portal



↓



Recebe sua configuração



↓



Exibe o conteúdo

```



O "usuário" é apenas a identidade técnica do equipamento.



---



# O que define o comportamento é o Perfil do Display



Exemplo:



```text

Display LG 55"



↓



Perfil



"Pediatria"

```



Outro:



```text

Samsung 65"



↓



Perfil



"Pronto Atendimento"

```



Outro:



```text

Totem Recepção"



↓



Perfil



"Autoatendimento"

```



O mesmo software roda em todos.



---



# Management Center



No Portal de Gestão existiria um módulo:



```text

Gestão



↓



Displays

```



Lá aparece algo parecido com:



| Equipamento  | Local     | Perfil            | Status |

| ------------ | --------- | ----------------- | ------ |

| TV Recepção  | Recepção  | Painel Geral      | Online |

| TV Pediatria | Pediatria | Painel Pediátrico | Online |

| TV Clínica   | Clínica   | Painel Clínico    | Online |

| Totem 01     | Entrada   | Autoatendimento   | Online |



---



Ao clicar:



```text

TV Pediatria

```



Você configura:



* Nome

* Unidade

* Setor

* Perfil

* Resolução

* Orientação

* Tema

* Playlist

* Layout

* Chamada sonora

* Widgets

* Eventos

* Tempo de atualização



Tudo por configuração.



---



# O login do Display



Eu faria algo semelhante ao que existe em TVs corporativas.



Na primeira inicialização:



```text

Código:



A7K92

```



No Portal de Gestão:



```text

Adicionar Display



↓



Digite o código



↓



Vincular

```



Depois disso, o Display recebe um certificado ou token seguro e passa a se autenticar automaticamente.



---



# Depois basta trocar o perfil



Hoje a TV está na Pediatria.



```text

Perfil



Pediatria

```



Amanhã ela foi para a Clínica.



Basta alterar:



```text

Perfil



Clínica

```



Sem trocar usuário, sem alterar senha, sem reinstalar nada.



---



# Isso serve para tudo



O mesmo conceito vale para:



* Displays

* Totens

* Kiosks

* Video Walls

* Monitores Médicos

* Tablets Fixos

* Chamadores de Senha



Todos são dispositivos registrados na plataforma.



---



# O perfil controla tudo



Imagine uma tabela:



```text

display_profile

```



Exemplo:



```text

Painel Clínico



Mostra:



✔ Chamadas



✔ Médico



✔ Consultório



✔ Tempo



✔ Alertas



❌ Vídeos



❌ Notícias

```



Outro perfil:



```text

Painel Institucional



✔ Notícias



✔ Vídeos



✔ Eventos



✔ Comunicados



❌ Chamadas

```



Outro:



```text

Totem



✔ Autoatendimento



✔ Senha



✔ QR Code



✔ Pesquisa



✔ Cadastro

```



O Display apenas pergunta:



> "Qual é meu perfil?"



E monta a interface.



---



# Isso conversa perfeitamente com o Portal



No **Management Center** teríamos algo como:



```text

Portal de Gestão



↓



Displays



↓



Perfis



↓



Painel Clínico

```



Dentro desse perfil:



* Layout

* Widgets

* Eventos

* Cores

* Fontes

* Playlist

* Chamada sonora

* Filas

* Especialidades

* Setores

* Templates

* Horários

* Regras



Ou seja, você configura uma vez e aplica esse perfil a quantos dispositivos desejar.



---



## Acho que podemos generalizar ainda mais



Aqui vejo uma oportunidade de criar uma lei canônica para toda a plataforma:



> **Nenhum comportamento operacional é definido pelo tipo de usuário técnico. O comportamento é definido por perfis de configuração associados à identidade autenticada.**



Essa regra vale para pessoas, displays, totens, kiosks e até futuras integrações. Um usuário, um display ou um dispositivo não "é" um Painel Clínico ou um Totem de Recepção; ele **assume um perfil**. Isso torna a plataforma muito mais flexível: mover uma TV da Pediatria para a Clínica, transformar um totem em painel institucional ou alterar o layout de dezenas de equipamentos passa a ser apenas uma mudança de configuração, sem recriar contas ou modificar a aplicação. É esse tipo de desacoplamento que faz plataformas SaaS Enterprise escalarem com facilidade.Essa é uma excelente discussão, porque ela toca em um princípio importante: **não misturar identidade com função operacional**.



Eu faria uma separação em três conceitos:



## 1. Pessoas (Usuários)



São pessoas reais.



* Suporte de TI

* Administrador

* Gestor

* Recepcionista

* Médico

* Enfermeiro



Elas entram no Portal normalmente.



---



## 2. Dispositivos



São equipamentos registrados.



* TV

* Painel

* Totem

* Kiosk

* Tablet

* VideoWall



Eles também possuem identidade, mas **não são pessoas**.



---



## 3. Perfis



São configurações reutilizáveis.



Exemplos:



* Painel Clínico

* Painel Pediatria

* Painel Laboratório

* Totem Autoatendimento

* TV Institucional



O dispositivo recebe um perfil.



---



# Então como o TI configura?



Na minha opinião, o técnico **não deve precisar logar na TV com um usuário administrativo**.



O fluxo seria parecido com o de uma Smart TV ou um Chromecast.



## Primeira instalação



A TV abre:



```text

Dispositivo não configurado.



Código:



X8A2-KP91

```



---



O técnico, no notebook ou celular, entra no Portal:



```text

Portal



↓



Gestão



↓



Displays



↓



Adicionar dispositivo

```



Ele digita:



```text

X8A2-KP91

```



Agora o Portal pergunta:



```text

Qual perfil?



( ) Painel Clínico



( ) Pediatria



( ) Laboratório



( ) TV Institucional



( ) Totem



( ) Outro

```



Depois:



```text

Qual unidade?



Hospital Central

```



```text

Qual setor?



Pediatria

```



Salvar.



A TV já muda automaticamente para o modo configurado.



---



# E se precisar trocar?



O suporte vai novamente ao Portal.



Seleciona:



```text

TV Pediatria

```



Troca o perfil para:



```text

Painel Clínico

```



Em poucos segundos, a TV muda de comportamento.



---



# Mas e se a internet cair?



A TV mantém a última configuração em cache e continua funcionando até conseguir sincronizar novamente.



---



# E o "Usuário Painel"?



Eu não eliminaria totalmente essa ideia.



Criaria um tipo especial de identidade chamado **Conta Técnica**.



Por exemplo:



```text

display-recepcao-01

display-pediatria-02

totem-entrada-01

```



Essas contas:



* não aparecem na lista de funcionários;

* não fazem login no Portal convencional;

* não possuem e-mail;

* não acessam RH, Financeiro ou Chat;

* servem apenas para autenticar o dispositivo.



Elas existem para a infraestrutura da plataforma, não para uso humano.



---



# O papel do Suporte de TI



O Suporte de TI acessa o **Management Center** e tem permissão para:



* Registrar novos dispositivos.

* Alterar perfis.

* Reiniciar dispositivos.

* Atualizar firmware (se aplicável).

* Ver status online/offline.

* Consultar logs.

* Enviar comandos.



Ele **não precisa conhecer a senha do dispositivo**.



---



# Sobre múltiplos logins



Concordo com a regra que você propôs, mas faria uma pequena adaptação.



### Para pessoas



Um usuário humano pode:



* estar logado no notebook;

* estar logado no celular;

* estar logado em casa.



Isso é comum hoje em plataformas corporativas.



O que podemos controlar é:



* impedir duas sessões no **mesmo navegador** usando o mesmo perfil;

* registrar todas as sessões;

* permitir que a política do cliente limite sessões simultâneas, se desejar.



### Para dispositivos



Cada dispositivo registrado possui uma identidade única.



* Uma TV corresponde a um dispositivo.

* Um totem corresponde a um dispositivo.



Não faz sentido a mesma identidade técnica estar ativa em dois equipamentos diferentes ao mesmo tempo.



Se um segundo equipamento tentar usar a mesma identidade, o sistema pode bloquear a nova autenticação ou invalidar a sessão anterior, conforme a política definida.



---



## Minha sugestão final



Eu adotaria uma arquitetura em que **existem apenas dois tipos de identidade na plataforma**:



1. **Pessoa** (identidade humana).

2. **Dispositivo** (identidade técnica).



As permissões determinam o que cada pessoa pode fazer. Um técnico de TI recebe acesso ao módulo **Gestão de Displays** dentro do Management Center e administra todos os painéis a partir dali. Já os dispositivos apenas se autenticam, recebem sua configuração e executam o perfil atribuído.



Essa abordagem mantém a administração centralizada, evita o compartilhamento de senhas entre técnicos e torna a gestão muito mais segura e escalável. Além disso, preserva uma das leis canônicas que já definimos: **o comportamento não é definido pela conta utilizada, mas pela configuração e pelo perfil associados à identidade autenticada**. Isso deixa a plataforma preparada para crescer com centenas ou milhares de dispositivos sem complicar a operaçãoPerfeito. Agora conseguimos conectar a visão da plataforma com o legado de forma organizada. O ponto importante é: **não vamos copiar essas 283 tabelas**, mas elas representam um inventário funcional muito valioso para a reconstrução.



Ao olhar para essa lista, vejo que várias ideias que discutimos hoje **já existiam de forma fragmentada**, e podemos transformá-las em um modelo canônico muito melhor.



## O conceito que eu consolidaria



Eu manteria **as três abordagens ao mesmo tempo**, mas cada uma com uma responsabilidade diferente.



### 1. Usuário Pessoa



É uma pessoa real.



Exemplos:



* Médico

* Enfermeiro

* Recepcionista

* Suporte TI

* Gestor

* Root



Esses usuários entram no Portal Enterprise.



---



### 2. Usuário Técnico



Aqui entra exatamente o exemplo que você deu da medicação.



Hoje vocês já possuem usuários como:



* Medicação Adulto

* Medicação Infantil

* Painel Clínico



Esses não são pessoas.



São identidades técnicas.



E eu manteria isso.



Por quê?



Porque operacionalmente faz muito sentido.



Se o computador da Medicação Adulto reiniciar, ele continua sendo "Medicação Adulto".



Não depende da enfermeira que está trabalhando naquele momento.



Isso é excelente.



---



### 3. Dispositivo



Além do usuário técnico, continua existindo o dispositivo.



Exemplo:



```text

TV Samsung 55"



Patrimônio: 1458



MAC: xx



Serial: xx

```



Ou seja:



```text

TV Samsung



↓



faz login



↓



com usuário técnico



↓



Painel Clínico Adulto

```



A TV é apenas o equipamento.



Quem determina o comportamento é o usuário técnico.



---



# Então surge uma relação interessante



```text

Pessoa



↓



Configura



↓



Usuário Técnico



↓



É usado por



↓



Dispositivo

```



Isso resolve os dois lados.



---



# Exemplo real



Suporte de TI chega na Pediatria.



Liga uma TV nova.



Na tela aparece:



```text

Login



Usuário:



painel_pediatria



Senha:



********

```



Entrou.



Pronto.



Agora ele abre automaticamente o Painel Pediátrico.



---



Mas um Gestor pode acessar:



```text

Portal



↓



Gestão



↓



Painéis



↓



Painel Pediatria

```



E alterar:



* Layout

* Filas

* Voz

* Especialidades

* Widgets

* Horários



Sem nunca tocar na TV.



---



# Isso encaixa muito bem com o legado



Olhando sua lista, por exemplo:



```

painel

painel_config

painel_config_def

painel_grupo

painel_local

painel_lane

painel_mensagem

painel_fila_tipo

painel_monitoramento_especialidade

```



Eu não eliminaria essas tabelas.



Eu reorganizaria.



Por exemplo:



```

painel

```



Passa a representar a entidade lógica do painel.



---



```

painel_perfil

```



Novo.



Define:



* Clínico

* Pediatria

* Laboratório

* Farmácia

* Emergência



---



```

painel_layout

```



Novo.



Define:



* Widgets

* Grid

* Tema

* Fontes



---



```

painel_widget

```



Novo.



Lista todos os componentes.



---



```

painel_playlist

```



Vídeos.



---



```

painel_tts

```



Google TTS.



---



```

painel_evento

```



Eventos recebidos.



---



```

painel_destino

```



Quais filas chegam nesse painel.



---



```

usuario_tecnico

```



Essa, na verdade, eu nem criaria.



Eu faria uma pequena evolução da tabela `usuario`.



Por exemplo:



```

usuario



tipo



------------------



PESSOA



TECNICO



SERVICO



API



DISPLAY

```



Assim, continuamos tendo **uma única identidade de autenticação**, mas com tipos diferentes.



Isso simplifica muito a arquitetura.



---



# Isso conversa com o Portal



Depois do login:



```

Se tipo = Pessoa



↓



Portal Enterprise

```



---



```

Se tipo = Display



↓



Portal Display

```



---



```

Se tipo = Técnico



↓



Aplicação padrão

```



Por exemplo:



```

painel_clinico



↓



abre direto



/app/display

```



Ou:



```

medicacao_adulto



↓



abre direto



/app/medicacao

```



Sem Portal intermediário.



---



# O que mais gostei



Existe uma tabela que me chamou muita atenção:



```

runtime_dispositivo

```



Essa tabela pode evoluir muito.



Ela pode armazenar:



* resolução

* navegador

* heartbeat

* versão

* último acesso

* usuário técnico conectado

* painel carregado

* tenant

* contexto

* IP

* WebSocket

* status



Ela praticamente vira um **Device Manager**.



---



## Minha conclusão



Acho que hoje encontramos uma solução que preserva o que já funciona no legado e, ao mesmo tempo, moderniza a arquitetura.



Eu faria apenas um ajuste importante em relação ao legado: **não criaria tabelas separadas para "usuário técnico"**. Em vez disso, evoluiria a entidade `usuario` para suportar diferentes tipos de identidade (`PESSOA`, `TECNICO`, `DISPLAY`, `SERVICO`, `API`), mantendo uma única infraestrutura de autenticação, auditoria, sessão e permissões.



Dessa forma, um `painel_pediatria`, um `medicacao_adulto` ou um `totem_recepcao` continuam existindo como **identidades técnicas** — algo que faz muito sentido operacionalmente — enquanto o comportamento é definido pelos perfis, configurações e vínculos (`painel_config`, `runtime_dispositivo`, locais, filas, TTS etc.) administrados pelo **Management Center**.



Na minha opinião, essa solução aproveita o que o legado já tem de bom, reduz a complexidade do modelo e mantém a plataforma preparada para crescer sem multiplicar estruturas de autenticação diferentes. É um caminho bastante sólido para a reconstrução do SaaS Enterprise.Entendi perfeitamente. Essa informação muda um detalhe importante da modelagem e, na verdade, **simplifica bastante**.



E você tem razão sobre as tabelas.



* **O dump legado possui aproximadamente 478 tabelas**, que é o que eu tenho registrado como baseline congelado.

* A lista que você colou agora contém **283 tabelas extraídas**. Ou seja, ela é um subconjunto (ou uma extração específica) do dump, não o inventário completo. Eu estava analisando apenas essa lista que você enviou na mensagem, não o dump inteiro.



---



# Sobre a TV



Agora ficou muito mais claro.



A TV não é um dispositivo inteligente para o sistema.



Ela é apenas um monitor.



Então a arquitetura muda para isso:



```text

Monitor / TV

        ▲

        │ HDMI

        │

┌─────────────────┐

│ Mini PC         │

│ Windows/Linux   │

│ Chrome/Edge     │

│ Nossa aplicação │

└─────────────────┘

```



Ou seja:



**quem existe na plataforma não é a TV.**



Quem existe é o **Terminal** (o computador).



Isso é muito melhor.



---



# Então nossos dispositivos passam a ser



* PC Recepção

* PC Medicação Adulto

* PC Medicação Infantil

* PC Painel Clínico

* PC Totem 01

* PC Kiosk 02

* Notebook Médico

* Tablet Enfermagem



Todos são computadores executando nosso sistema.



---



# O usuário técnico continua fazendo sentido



Exemplo:



```text

Usuário:



painel_clinico

```



Esse usuário entra automaticamente.



O Portal detecta:



```text

Tipo



DISPLAY

```



e abre:



```text

/portal/display

```



Sem menus.



Sem Portal Enterprise.



Sem Dashboard.



Direto na aplicação.



---



Outro exemplo:



```text

medicacao_adulto

```



abre direto:



```text

/app/medicacao

```



---



# Acho que podemos melhorar ainda mais



Na verdade eu não chamaria mais de **Display**.



Chamaria de **Terminal**.



Porque tudo é um computador.



Exemplo:



```text

Terminal



id_terminal



hostname



patrimonio



ip



mac



unidade



setor



tipo_terminal



perfil



usuario_tecnico

```



---



Tipos:



```text

PAINEL



TOTEM



KIOSK



ATENDIMENTO



MEDICAÇÃO



FARMÁCIA



LABORATÓRIO



ADMINISTRATIVO



AUTOATENDIMENTO

```



Isso representa melhor a realidade física.



---



# Isso encaixa com o Portal Enterprise



Pessoa:



```text

Login



↓



Portal Enterprise

```



---



Usuário Técnico:



```text

Login



↓



Carrega Perfil



↓



Abre aplicação padrão

```



---



# Acho que essa é uma decisão importante



Eu criaria uma nova entidade canônica.



Hoje temos:



* Pessoa

* Usuário

* Contexto

* Tenant



Eu acrescentaria:



```text

Terminal

```



Porque tudo gira em torno dele.



Ele pode ter:



* um usuário padrão;

* uma aplicação padrão;

* um modo kiosk;

* um perfil de painel;

* permissões locais;

* impressoras;

* leitores biométricos;

* leitores de cartão;

* gaveta de dinheiro;

* webcam;

* TTS;

* múltiplos monitores.



Isso representa exatamente a infraestrutura que vocês encontram em hospitais, clínicas e empresas.



---



## Acho que estamos evoluindo para uma arquitetura mais próxima da realidade



O legado mostra um sistema muito orientado ao **HIS**. Na reconstrução, podemos elevar esse conceito para um **Terminal** genérico, capaz de executar qualquer aplicação da plataforma.



Assim, um terminal pode iniciar automaticamente em um painel de chamadas, uma estação de medicação, um totem de autoatendimento, um posto de recepção ou até mesmo no Portal Enterprise de um usuário comum. O equipamento físico continua sendo apenas um PC conectado a periféricos (TV, monitor, touchscreen, impressora, leitor biométrico etc.), enquanto a identidade técnica e o perfil configurado determinam o comportamento do sistema. Na minha visão, esse modelo representa melhor a infraestrutura real dos clientes e torna a plataforma muito mais flexível para diferentes segmentos B2B.Li o arquivo.



Na verdade, esse arquivo **não é o dump nem a análise estrutural do banco**. Ele é um **relatório gerado** com o inventário das procedures (~253), quais retornam dados para o front-end, quais fazem apenas escrita, joins, tabelas utilizadas etc.



Ou seja, ele confirma algo que nós já tínhamos decidido na arquitetura:



* **SP-First** continua sendo a decisão correta.

* O Portal pode ser completamente montado através de procedures.

* O backend decide tudo; o frontend apenas renderiza.



---



## Agora quero voltar exatamente para o Portal



Você mesmo percebeu uma coisa importante:



> "já estamos desviando o foco novamente"



E eu concordo.



Se continuarmos falando de painel, TV, TTS, totem, HIS, vamos cair novamente na arquitetura operacional.



**Nosso próximo passo deve ser congelar o Portal Enterprise.**



Na minha visão, antes de escrever uma linha de código, precisamos definir o **Portal Runtime**.



---



# Eu proporia que o Portal fosse dividido em 5 domínios



```text

PORTAL



├── Identity

├── Runtime

├── Applications

├── Management Center

└── Personalization

```



Cada um vira um MD próprio.



---



# 1) Identity



Responsável por:



* Login

* Sessão

* MFA

* Pessoa

* Contexto

* Tenant

* Refresh Token



Depois disso o Portal assume.



---



# 2) Portal Runtime



Esse é o coração.



A SP pode ser algo como:



```sql

sp_portal_runtime()

```



Ela retorna tudo.



Exemplo:



```json

{

  "user": {},

  "tenant": {},

  "context": {},



  "dashboard": {},



  "apps": [],



  "widgets": [],



  "favorites": [],



  "management": {},



  "notifications": [],



  "branding": {}

}

```



Uma chamada monta praticamente todo o Portal.



---



# 3) Applications



O Portal não conhece HIS.



Ele conhece Aplicações.



```text

Portal



↓



Aplicações



↓



HIS



↓



CRM



↓



AVA



↓



GLPI



↓



BI



↓



Financeiro

```



Isso permite vender qualquer combinação.



---



# 4) Management Center



Aqui entra tudo que discutimos hoje.



```text

Portal



↓



Gestão



↓



Portal



↓



HIS



↓



AVA



↓



GLPI



↓



Displays



↓



Integrações



↓



Segurança

```



---



# 5) Personalization



Esse será um dos diferenciais da plataforma.



Cada cliente poderá alterar:



* logo

* cores

* dashboard

* atalhos

* menu

* widgets

* módulos

* página inicial



Sem alterar código.



---



# Acho que descobrimos uma SP extremamente importante



Depois de ler esse relatório das procedures, fiquei convencido de que deveríamos criar uma procedure nova, que **não existe no legado**.



Algo como:



```sql

sp_portal_runtime()

```



Ela seria a primeira procedure chamada após o login.



Ela faria internamente chamadas para outras SPs, como por exemplo:



* autenticação;

* contexto;

* permissões;

* aplicações disponíveis;

* widgets;

* branding;

* notificações;

* dashboard;

* favoritos;

* menu.



E retornaria um único contrato para o frontend.



Assim o React (ou qualquer frontend) faria praticamente **uma única requisição para montar o Portal inteiro**.



---



# Acho que este deve ser nosso foco agora



Eu sugiro que a gente **pare de pensar em módulos específicos (HIS, Painéis, Totens, GLPI, AVA)** por alguns dias.



Vamos tratar o **Portal Enterprise** como se fosse um produto independente.



Na minha opinião, ele merece documentação própria, exatamente como um sistema comercial teria. Eu criaria primeiro algo como:



* **MD-PORTAL-001** — Arquitetura Canônica do Portal.

* **MD-PORTAL-002** — Runtime do Portal.

* **MD-PORTAL-003** — Registro e Catálogo de Aplicações.

* **MD-PORTAL-004** — Management Center.

* **MD-PORTAL-005** — Dashboard Framework.

* **MD-PORTAL-006** — Widgets e Containers.

* **MD-PORTAL-007** — Navegação e Menu.

* **MD-PORTAL-008** — Personalização e Branding.



**Só depois** começamos a encaixar o HIS, AVA, GLPI e os demais módulos dentro desse Portal.



Eu acho que essa é a inversão de arquitetura que faltava no projeto: **o Portal deixa de ser a porta de entrada do HIS e passa a ser o produto principal da plataforma SaaS Enterprise.** A partir dele, todos os outros sistemas passam a ser apenas aplicações plugáveis dentro de um ecossistema único. Essa mudança vai deixar toda a reconstrução muito mais consistentePerfeito. E eu acho que essa é a decisão mais importante que tomamos hoje.



**Vamos congelar o assunto Painéis, Totens, Kiosks, HIS, AVA, GLPI, etc.**



Eles vão existir, mas **não agora**.



Agora vamos construir **o Portal**, porque ele é o coração da plataforma.



---



# Nossa regra daqui para frente



Sempre que percebermos que estamos entrando em HIS, Painel, Estoque ou qualquer outro módulo, voltamos para a pergunta:



> **"Isso pertence ao Portal ou pertence ao módulo?"**



Se pertencer ao módulo, documentamos para depois.



---



# Vamos fazer por etapas



## ETAPA 1 — Quem entra no Portal?



Essa é a única pergunta que vamos responder agora.



Hoje levantamos alguns perfis.



```text

Pessoa



├── Root da Plataforma

├── Administrador do Tenant

├── Gestor

├── Supervisor

├── Funcionário

├── Fornecedor

├── Cliente

├── Paciente (futuro)

├── Aluno (AVA)

└── Outros...

```



Esses são **tipos de pessoas**, não permissões.



---



# ETAPA 2 — O que cada um vê ao entrar?



Aqui acho que está a grande ideia que surgiu hoje.



## O Portal possui apenas uma entrada.



```

LOGIN



↓



PORTAL ENTERPRISE

```



Depois disso o Portal é montado dinamicamente.



Não existe:



* Portal do Root

* Portal do Gestor

* Portal do Funcionário



Existe **um único Portal**.



Quem muda é o conteúdo.



---



## Exemplo



Funcionário



```

Portal



✔ Aplicações



✔ Chat



✔ Agenda



✔ Perfil

```



---



Gestor



```

Portal



✔ Aplicações



✔ Chat



✔ Agenda



✔ Dashboard



✔ Indicadores



✔ Gestão

```



---



Root



```

Portal



✔ Aplicações



✔ Dashboard



✔ Gestão



✔ Marketplace



✔ Auditoria



✔ Plataforma

```



Perceba que **é o mesmo Portal**.



---



# ETAPA 3 — O Card "Gestão"



Essa foi a melhor ideia da conversa de hoje.



Ao invés de poluir a Dashboard.



Teremos um único card.



```

╔════════════════════╗

║      Gestão        ║

║                    ║

║ Administração      ║

║ do Ambiente        ║

╚════════════════════╝

```



Ao clicar...



Entra em outro ambiente.



```

Management Center

```



---



# ETAPA 4 — O Management Center



Aqui não falaremos ainda de HIS.



Só da estrutura.



```

Management Center



├── Empresa



├── Usuários



├── Segurança



├── Sistemas



├── Branding



├── Configurações



├── Integrações



└── Auditoria

```



Perceba que até agora **não apareceu HIS**.



---



# ETAPA 5 — Sistemas



Agora sim.



Dentro de Sistemas.



```

Management Center



↓



Sistemas

```



Aparecem os containers.



```

Portal



HIS



AVA



GLPI



CRM



Financeiro



Displays



...

```



Mas isso será uma etapa futura.



Hoje não vamos desenhar nenhum deles.



---



# Eu proporia uma regra para evitar bagunça



A partir de hoje, para qualquer funcionalidade nova, vamos responder primeiro:



| Pergunta                                                     | Se SIM                | Se NÃO                 |

| ------------------------------------------------------------ | --------------------- | ---------------------- |

| É algo que todo usuário pode ver?                            | Portal                | Continua analisando    |

| É administração da empresa/tenant?                           | Management Center     | Continua analisando    |

| É configuração de um produto específico (HIS, AVA, GLPI...)? | Módulo correspondente | Não pertence ao Portal |



Essa regra vai impedir que o Portal vire um "depósito" de funcionalidades.



---



# Nosso próximo documento



Na minha opinião, o primeiro documento da reconstrução não deveria ser um MD técnico do banco.



Deveria ser algo como:



> **FRONT-001 — Portal Enterprise Experience**



Esse documento responderia apenas cinco perguntas:



1. Quem entra no Portal?

2. O que acontece após o login?

3. Como o Portal decide o que mostrar?

4. O que é o **Management Center**?

5. Como um usuário navega do Portal para um módulo?



**Sem falar de HIS, Painéis, Totens ou AVA.**



---



## Acho que essa vai ser nossa nova disciplina



Nós dois percebemos que sempre acabamos puxando o assunto para um módulo específico. A partir de agora, vamos construir a plataforma **de fora para dentro**:



**Login → Portal → Management Center → Aplicações → Módulos.**



Só quando o Portal estiver completamente definido é que começaremos a desenhar o primeiro módulo. Isso vai evitar retrabalho e manter a arquitetura limpa desde o início.Perfeito. Vamos manter o foco exatamente onde paramos.



**Não vamos discutir login, usuários, HIS, painéis ou dispositivos agora.** Isso vem depois.



O que evoluímos hoje foi o **Portal Enterprise** e principalmente o **Management Center**, e isso precisa virar uma atualização oficial do KILO Engine para que a arquitetura fique congelada antes de começarmos os MDs.



---



# KILO ENGINE v8 — Portal Enterprise & Management Center Evolution



## Objetivo



Consolidar todas as decisões arquitetônicas tomadas hoje sobre o Portal Enterprise, separando definitivamente o ambiente operacional do ambiente administrativo da plataforma.



---



# LEI CANÔNICA 001



## O Portal é o núcleo da plataforma.



O Portal Enterprise deixa de ser apenas a tela inicial.



Ele passa a ser um produto da plataforma.



Todo acesso ocorre através dele.



```

Login



↓



Portal Enterprise



↓



Portal Runtime



↓



Aplicações

```



Nenhum módulo (HIS, AVA, Workforce, CRM, etc.) é acessado diretamente.



---



# LEI CANÔNICA 002



## Existe apenas um Portal.



Não existem:



* Portal Root

* Portal Gestor

* Portal Funcionário

* Portal Médico



Existe apenas:



```

Portal Enterprise

```



O conteúdo é montado dinamicamente.



O Portal nunca muda.



Quem muda é o Runtime.



---



# LEI CANÔNICA 003



## O Portal é orientado por metadados.



Após autenticação, o backend monta completamente o Portal.



O frontend apenas renderiza.



Nunca existe lógica de autorização no frontend.



```

Portal Runtime



↓



Aplicações



↓



Menus



↓



Widgets



↓



Cards



↓



Dashboards



↓



Containers



↓



Management



↓



Branding



↓



Feature Flags

```



Tudo vem do backend.



---



# LEI CANÔNICA 004



## O Portal possui dois mundos.



```

Portal Enterprise



│



├── Mundo Operacional



└── Management Center

```



O usuário continua dentro do Portal.



Apenas muda o ambiente.



---



# Mundo Operacional



É onde o trabalho diário acontece.



Exemplos:



```

Aplicações



Chat



Agenda



Notificações



Favoritos



Busca



Dashboard



Widgets



Perfil

```



Nunca aparecem configurações administrativas.



---



# Management Center



O Management Center é um Subportal Administrativo.



Ele não é um módulo.



Ele é um ambiente especializado de gestão.



```

Portal Enterprise



↓



Management Center

```



---



# LEI CANÔNICA 005



## O Management Center é modular.



Ele não possui configurações fixas.



Ele possui containers.



```

Management Center



┌────────────────────┐

│ Portal             │

└────────────────────┘



┌────────────────────┐

│ HIS                │

└────────────────────┘



┌────────────────────┐

│ AVA                │

└────────────────────┘



┌────────────────────┐

│ Intranet           │

└────────────────────┘



┌────────────────────┐

│ Displays           │

└────────────────────┘



┌────────────────────┐

│ Workforce          │

└────────────────────┘

```



Cada container representa um módulo instalado.



---



# LEI CANÔNICA 006



## Cada container abre um Subportal Administrativo.



Exemplo:



```

Management Center



↓



HIS



↓



Dashboard Administrativo HIS

```



Outro:



```

Management Center



↓



Portal



↓



Dashboard Administrativo Portal

```



Outro:



```

Management Center



↓



Displays



↓



Dashboard Administrativo Displays

```



O Management Center apenas orquestra.



Cada módulo administra a si próprio.



---



# LEI CANÔNICA 007



## O Portal não conhece módulos específicos.



Para o Portal tudo é Aplicação.



```

Portal Runtime



↓



Lista de Aplicações

```



Pode existir:



```

HIS



CRM



ERP



Financeiro



BI



GLPI



AVA



Marketplace



Workforce



Displays



Chat

```



O Portal apenas apresenta.



---



# LEI CANÔNICA 008



## O Management Center também é orientado por módulos.



Ele nunca possui telas codificadas.



Ele pergunta:



```

Quais módulos possuem administração?

```



E monta os containers automaticamente.



---



# LEI CANÔNICA 009



## Cada módulo publica sua Administração.



Cada produto deverá expor dois contratos.



```

Operação



Administração

```



Exemplo:



```

Portal



↓



Operação



↓



Administração

```



```

HIS



↓



Operação



↓



Administração

```



```

AVA



↓



Operação



↓



Administração

```



Assim qualquer produto novo entra automaticamente no ecossistema.



---



# LEI CANÔNICA 010



## O Portal nunca será alterado para adicionar novos produtos.



Novo produto?



Basta registrá-lo.



```

Catálogo de Aplicações



↓



Portal Runtime



↓



Management Center



↓



Tudo aparece automaticamente.

```



Zero alteração estrutural.



---



# Portal Runtime



O Runtime passa a ser o cérebro do Portal.



Ele será responsável por montar:



```

Portal



↓



Dashboard



↓



Cards



↓



Widgets



↓



Containers



↓



Aplicações



↓



Favoritos



↓



Menus



↓



Notificações



↓



Branding



↓



Personalização



↓



Management



↓



Marketplace



↓



Feature Flags

```



Tudo entregue pronto.



---



# Evolução do Management Center



A navegação passa a ser:



```

Portal Enterprise



↓



Dashboard



↓



Card Gestão



↓



Management Center



↓



Container



↓



Subportal Administrativo



↓



Configuração do Produto

```



Isso evita que a Dashboard principal fique sobrecarregada.



---



# Novo conceito: Subportal Administrativo



Todo módulo poderá possuir um Subportal Administrativo.



Exemplo:



```

Portal



↓



Management Center



↓



HIS



↓



Subportal HIS

```



```

Portal



↓



Management Center



↓



Portal



↓



Subportal Portal

```



```

Portal



↓



Management Center



↓



Displays



↓



Subportal Displays

```



Todos seguem o mesmo padrão arquitetural.



---



# Benefícios



* Um único Portal Enterprise.

* Separação clara entre operação e administração.

* Crescimento ilimitado da plataforma.

* Novos produtos entram sem alterar o Portal.

* Management Center atua como orquestrador.

* Cada módulo administra apenas seu próprio domínio.

* Frontend orientado por metadados.

* Backend continua sendo a única fonte de verdade (SP-First).



---



## Próximo passo



Acho que agora devemos continuar exatamente nesta linha e **não falar ainda de login ou tipos de usuários**.



A próxima evolução natural é desenhar a **arquitetura interna do Management Center**:



1. Estrutura dos containers.

2. Layout do Dashboard de Gestão.

3. Como os módulos registram seus subportais administrativos.

4. Como o Portal Runtime descobre automaticamente esses módulos.



Esse documento servirá como base para o **KILO ENGINE v8** e, depois de congelado, será transformado nos MDs e FRONTs do Portal EnterpriseConcordo com a direção que estamos tomando. Agora precisamos parar de pensar como desenvolvedores React e passar a pensar como arquitetos de uma plataforma SaaS.



A pergunta deixa de ser:



> "Onde fica o Header?"



e passa a ser:



> **"O que pertence ao Framework da Plataforma e o que pertence ao Produto?"**



Essa diferença vai evitar que daqui a dois anos tenhamos dezenas de componentes duplicados.



---



# A PRIMEIRA LEI DA ESTRUTURA



A pasta **apps/** nunca deve compartilhar código diretamente.



**Nunca teremos isso:**



```text

apps/

   his/

      components/

   workforce/

      components/

```



Porque depois começamos a copiar componentes.



Tudo compartilhável deve nascer em **packages/**.



---



# A NOVA ESTRUTURA



```text

enterprise-saas/

│

├── apps/

│

├── packages/

│

├── canonical/

│

├── infrastructure/

│

├── tools/

│

├── scripts/

│

├── docker/

│

├── docs/

│

└── turbo.json

```



Até aqui continua igual.



Agora vamos detalhar.



---



# APPS



Aqui ficam apenas aplicações.



Nunca bibliotecas.



```text

apps/



portal/



management/



his/



workforce/



displays/



intranet/



chat/



ava/



crm/



financeiro/



marketplace/

```



Perceba uma mudança.



## Eu criaria Management separado.



Não colocaria dentro do Portal.



Porque ele é outro produto.



Ele apenas é aberto pelo Portal.



```

Portal



↓



Management

```



Não:



```

Portal



↓



pages



↓



management

```



Essa separação vai evitar acoplamento.



---



# Cada APP



Exemplo Portal.



```text

apps/



portal/



src/



app/



routes/



pages/



features/



services/



hooks/



providers/



runtime/



contracts/



main.tsx

```



Nada de componentes compartilhados aqui.



---



# HIS



```text

apps/



his/



src/



app/



routes/



pages/



features/



services/



runtime/



contracts/

```



Mesma estrutura.



---



# Management



```text

apps/



management/



src/



app/



routes/



pages/



features/



services/



runtime/



contracts/

```



---



# Packages



Agora vem o segredo da arquitetura.



Tudo reutilizável nasce aqui.



---



## packages/ui



Aqui NÃO ficam telas.



Aqui ficam componentes puros.



```text

Button



Input



Modal



Tabs



Accordion



Avatar



Badge



Toast



Tooltip



Dialog



DataTable



Icon



Skeleton



EmptyState

```



Nada sabe o que é HIS.



Nada sabe o que é Portal.



---



## packages/design-system



Aqui ficam:



```text

cores



tipografia



tokens



ícones



spacing



themes



dark



light



brand engine

```



---



## packages/layout



Aqui muda tudo.



Não teremos um único layout.



Teremos um Framework de Layout.



```text

layouts/



portal/



management/



module/



fullscreen/



authentication/



display/



kiosk/

```



Cada um exporta um Layout.



Exemplo:



```tsx

<PortalLayout>

```



```tsx

<ManagementLayout>

```



```tsx

<ModuleLayout>

```



```tsx

<FullscreenLayout>

```



---



Então o HIS usa:



```tsx

<ModuleLayout>

```



O Portal usa:



```tsx

<PortalLayout>

```



O Login usa:



```tsx

<AuthLayout>

```



O Painel usa:



```tsx

<DisplayLayout>

```



Sem duplicação.



---



## packages/navigation



Essa pasta será extremamente importante.



```text

Sidebar



Breadcrumb



Topbar



QuickSearch



MenuEngine



Favorites



AppLauncher



Dock



NavigationTree

```



Mas atenção.



A Sidebar NÃO é fixa.



Ela recebe metadados.



---



Exemplo:



```tsx

<Sidebar menu={menu}/>

```



Quem cria o menu?



O backend.



---



## packages/runtime



Esse será um dos pacotes mais importantes.



Ele monta tudo.



```text

Portal Runtime



↓



Widgets



↓



Cards



↓



Containers



↓



Apps



↓



Menu



↓



Theme



↓



Branding

```



---



## packages/widgets



Os widgets reutilizáveis.



```text

Weather



Agenda



Tasks



Notifications



Calendar



Metrics



Chart



News



Shortcut



RecentAccess

```



O Portal apenas monta.



---



## packages/dashboard



Aqui ficam containers.



```text

DashboardGrid



DashboardContainer



WidgetLoader



CardLoader



LayoutEngine

```



---



## packages/module-sdk



Esse pacote será fantástico.



Todo módulo deverá implementar uma interface.



Exemplo.



HIS.



```ts

export default defineModule({



id:"his",



name:"Hospital",



icon:"hospital",



routes:[],



management:{},



runtime:{}



})

```



CRM.



Mesmo padrão.



AVA.



Mesmo padrão.



Portal lê isso automaticamente.



---



## packages/contracts



Todos os DTOs.



```text

PortalRuntime



ManagementRuntime



AppContract



UserContract



ContextContract



NotificationContract



WidgetContract

```



---



## packages/api



Cliente HTTP.



Nada de axios espalhado.



Tudo passa por aqui.



---



## packages/auth



Tudo relacionado à autenticação.



---



## packages/events



Barramento.



---



## packages/database



Somente contratos.



Nunca SQL.



---



## packages/sdk



SDK público.



---



# PUBLIC



Aqui muda bastante.



Eu **não teria uma pasta `public/` global cheia de imagens e logos**.



Cada aplicação deve possuir seus próprios assets versionados, e os recursos compartilhados ficam em um pacote.



Minha proposta:



```text

packages/assets/



icons/



logos/



illustrations/



fonts/



animations/

```



E dentro de cada app:



```text

apps/portal/src/assets/



apps/his/src/assets/



apps/management/src/assets/

```



Assim o Portal pode ter uma identidade visual diferente do HIS, e um cliente pode personalizar apenas um módulo sem afetar os demais.



---



# Header



Não será compartilhado.



Teremos um Framework.



```text

packages/layout/



PortalHeader



ManagementHeader



ModuleHeader



DisplayHeader

```



---



# Footer



Mesma ideia.



```text

PortalFooter



ManagementFooter



ModuleFooter



DisplayFooter

```



---



# Sidebar



Não existe uma Sidebar única.



Existe um motor.



```tsx

<SidebarEngine />

```



Ele recebe.



```ts

menu



permissions



favorites



context



```



e monta a sidebar.



---



# Login



O Login é exclusivo do Portal.



Nunca do HIS.



```text

apps/



portal/



authentication/

```



O HIS nunca implementa login.



---



# Portal



É exclusivo.



```text

Portal



↓



Runtime



↓



Dashboard



↓



Applications



↓



Management

```



---



# Management



Outro produto.



Outro runtime.



Outra dashboard.



---



# HIS



Outro produto.



Outro runtime.



Outra dashboard.



---



# O que realmente será reaproveitado?



A resposta é: **muito menos do que normalmente se imagina**, mas o que for compartilhado será compartilhado da forma correta.



## ✅ Compartilhado (packages)



* Design System (cores, tipografia, tokens, temas)

* Componentes base (Button, Input, Modal, Tabs, etc.)

* Engine de Layout

* Engine de Navegação (Sidebar, Menu, Breadcrumb)

* Runtime Engine

* Dashboard Framework

* Widget Framework

* Cliente de API

* SDK

* Eventos

* Autenticação

* Contratos (DTOs)

* Hooks genéricos

* Utilitários

* Internacionalização

* Assets compartilhados (ícones, fontes)



## ❌ Não compartilhado (apps)



* Páginas

* Regras de negócio

* Dashboards

* Headers específicos

* Footers específicos

* Menus específicos

* Rotas

* Features

* Casos de uso

* Configurações de cada produto



---



# A principal evolução da arquitetura



O erro comum em monorepos é compartilhar **componentes prontos**.



Eu faria diferente.



Nós compartilharemos **engines**.



Por exemplo:



* Não existe uma Sidebar pronta.



* Existe uma **Sidebar Engine**.



* Não existe um Dashboard pronto.



* Existe um **Dashboard Framework**.



* Não existe um Header pronto.



* Existe um **Layout Engine** que permite ao Portal, ao Management e a qualquer módulo fornecerem seus próprios Header, Footer, Sidebar e áreas de conteúdo.



Na minha opinião, essa é a arquitetura que melhor se encaixa em tudo o que definimos até agora: um **Portal Enterprise** como produto principal, um **Management Center** como produto administrativo independente e módulos (HIS, Workforce, Displays, AVA etc.) completamente desacoplados, mas todos apoiados por um conjunto sólido de engines reutilizáveis em `packages/`. Essa separação reduz acoplamento, facilita evolução independente dos produtos e mantém a plataforma preparada para crescer sem reorganizações estruturais futuras.Perfeito. Vou consolidar tudo que já estava na memória do projeto + as decisões de hoje em um **documento mestre de arquitetura**, para servir como base do KILO ENGINE.



Um ponto importante: **eu não tenho acesso a uma ferramenta de gravação permanente de memória nesta conversa**, então não consigo garantir que isso seja gravado no armazenamento de memória do sistema agora. Porém, vou deixar a consolidação pronta aqui para você salvar como arquivo canônico (ex.: `ARCHITECTURE_UPDATE_2026-07-06.md`) e passar para o KILO.



---



# ARCHITECTURE UPDATE — PORTAL ENTERPRISE + MANAGEMENT CENTER



## Status



**Atualização arquitetural oficial**



Data: 2026-07-06



Projeto:



```

FCA / MIDAS SaaS Enterprise Platform

```



---



# 1. Visão Geral Consolidada



A plataforma deixa de ser tratada como um HIS que evoluiu para SaaS.



A arquitetura correta é:



```

SaaS Enterprise Platform



        |

        |

        v



Portal Enterprise



        |

        |

        +----------------+

        |                |

        v                v



Management Center      Applications



                         |

                         |

             +-----------+-----------+

             |           |           |

             v           v           v



            HIS        AVA        GLPI



             ...



```



---



# 2. Lei Canônica Principal



## Portal First Architecture



Nenhum usuário entra diretamente em um sistema.



Fluxo obrigatório:



```

Login



↓



Identity



↓



Context Selection



↓



Portal Enterprise



↓



Applications

```



Exceção:



Identidades técnicas podem possuir inicialização automática em aplicações específicas.



Exemplo:



```

Terminal Técnico



↓



Perfil



↓



Aplicação operacional

```



---



# 3. Identity Architecture



A identidade continua baseada em:



```

Pessoa

```



Pessoa é a raiz global.



Não existe:



```

Usuario = Pessoa

```



Correção:



```

Pessoa



 |

 +---- Usuário humano

 |

 +---- Usuário técnico

 |

 +---- Conta serviço

 |

 +---- API Identity

 |

 +---- Terminal Identity

```



---



# 4. Portal Enterprise



O Portal é um produto independente.



Ele é responsável por montar a experiência.



Ele NÃO conhece regras internas dos módulos.



Ele conhece:



```

Aplicações disponíveis



Permissões



Widgets



Menus



Dashboards



Contexto



Tenant



Branding



Preferências

```



---



# 5. Portal Runtime



Criar domínio:



```

Portal Runtime

```



Responsável por montar o ambiente após login.



Contrato:



```

sp_portal_runtime()

```



Retorno:



```json

{

 user:{},



 tenant:{},



 context:{},



 apps:[],



 menu:[],



 widgets:[],



 dashboard:{},



 notifications:[],



 branding:{},



 management:{}

}

```



---



# 6. Management Center



Novo conceito canônico.



Não é uma tela de configuração.



É um aplicativo dentro do Portal.



Fluxo:



```

Portal Enterprise



↓



Management Center



↓



Configuração da Plataforma

```



Responsável por:



```

Empresa



Tenant



Usuários



Permissões



Aplicações



Branding



Segurança



Integrações



Auditoria



Licenciamento



Feature Flags

```



---



# 7. Separação Operação x Administração



## Portal Operacional



Usuários comuns:



```

Funcionário



Médico



Enfermeiro



Gestor



Cliente



Fornecedor

```



Veem:



```

Aplicações



Tarefas



Chat



Agenda



Dashboards



Notificações

```



---



## Management Center



Somente permissões administrativas.



Exemplo:



```

Tenant Owner



Administrador



Platform Root

```



---



# 8. Aplicações são módulos plugáveis



O Portal não possui:



```

if(HIS)



if(GLPI)



if(AVA)

```



Ele recebe metadados.



Modelo:



```

Application Registry

```



Exemplo:



```

Aplicação



codigo



nome



rota



ícone



versão



status



permissão

```



---



# 9. Estrutura de Frontend



Monorepo:



```

enterprise-saas/

│

├── apps/

│

│   ├── portal/

│   │

│   ├── management/

│   │

│   ├── his/

│   │

│   ├── displays/

│   │

│   ├── workforce/

│   │

│   ├── chat/

│   │

│   └── ava/

│

│

├── packages/

│

│   ├── ui/

│   │

│   ├── design-system/

│   │

│   ├── auth/

│   │

│   ├── sdk/

│   │

│   ├── api-client/

│   │

│   ├── contracts/

│   │

│   ├── events/

│   │

│   ├── database/

│   │

│   └── shared/

│

│

├── canonical/

│

│   ├── MD/

│   ├── BR/

│   ├── FRONT/

│   ├── MAP/

│   └── ADR/

│

│

├── infrastructure/

│

├── docker/

│

├── scripts/

│

└── tools/

```



---



# 10. Reaproveitamento de Componentes



Aqui está uma decisão importante.



Não criar um único frontend gigante.



Criar um Design System compartilhado.



---



## packages/ui



Componentes universais:



```

Button



Input



Modal



Table



Card



Avatar



Badge



Tabs



Dropdown



Form



Loading



Toast



Notification

```



---



## packages/design-system



Identidade visual:



```

Theme



Colors



Typography



Spacing



Icons



Tokens

```



---



# 11. Header / Footer / Sidebar



Decisão:



## Não fazer tudo igual.



Porque cada domínio pode ter uma experiência própria.



---



## Portal Enterprise



Possui:



```

Portal Header



Portal Sidebar



Portal Footer

```



---



## Management Center



Pode possuir:



```

Management Header



Management Sidebar

```



---



## HIS



Pode possuir:



```

HIS Header



HIS Navigation



HIS Workspace

```



---



## AVA



Outro domínio.



---



Porém todos reutilizam:



```

packages/ui



packages/design-system



packages/auth



packages/sdk

```



---



# 12. Public Folder



A ausência da pasta public não é problema.



Cada app terá sua própria estrutura.



Exemplo:



```

apps/portal



src/



├── app/



├── components/



├── features/



├── layouts/



├── routes/



├── hooks/



├── services/



├── stores/



├── styles/



├── assets/



└── main.tsx

```



---



# 13. Estrutura interna padrão de cada aplicação



Modelo:



```

app-name/



src/



├── app/



│   ├── router.tsx

│   ├── providers.tsx

│   └── config.ts





├── features/



│   ├── authentication/



│   ├── dashboard/



│   ├── settings/



│   └── ...





├── components/



├── layouts/



├── hooks/



├── services/



├── stores/



├── contracts/



├── assets/



└── main.tsx

```



---



# 14. Displays / Painéis / Totens



Decisão consolidada:



Não fazem parte do Portal agora.



Serão um módulo futuro.



Conceito:



```

Terminal



+



Perfil



+



Configuração

```



Não criar:



```

painel_clinico_user



painel_pediatria_user

```



Separar:



```

Pessoa



Terminal



Perfil Técnico

```



---



# 15. KILO ENGINE Atualização



Adicionar estas regras:



## KILO deve validar:



```

Portal First



Management Center



Application Registry



Portal Runtime



Identity Separation



Pessoa != Usuário Técnico != Terminal



Frontend orientado por metadados



Backend controla autorização

```



---



# 16. Ordem de desenvolvimento atualizada



## FASE 1



Fundação:



```

Monorepo



TypeScript



React



Packages



CI/CD



Docker

```



---



## FASE 2



Core:



```

Auth



Identity



Portal Runtime



Contracts



SDK

```



---



## FASE 3



Portal:



```

Login



Context Selection



Portal Dashboard



Application Registry



Widgets



Navigation

```



---



## FASE 4



Management Center:



```

Tenant



Users



Roles



Permissions



Applications



Branding

```



---



## FASE 5



Somente depois:



```

HIS



Displays



AVA



Workforce



Chat



Financeiro

```



---



# Regra final para o KILO



> Não implementar módulos antes de concluir Portal Enterprise + Management Center. Toda aplicação futura deve ser plugável pelo Application Registry e consumir identidade, contexto, permissões e design system compartilhados.



---



Esse é o ponto onde o projeto está agora: **sair da mentalidade de sistema e entrar na mentalidade de plataforma SaaS Enterprise.**

tirando a parte que e pra o kilo fazer olha como o nosso portal evoluiu voce não pode fazer voltar para traz essa e a estrura que queremos ok voce esta passando assim? isso aqui foi o que nos decidimos hoje mais cedo temo que fazer nosso arquivo baseado assim lembrnado que nos mds estão aquo no kilo so falar para ele buscar os arquviso baseado no banco que ele tem que e o dump la tem as tabelas as procedures que ele tem que suar podemos fazer sem tb fazer com que depois nos moltamos  com isso ok mais nosso potal agora tem portal de gestão 
Li o arquivo completo que você enviou e agora ficou bem claro o ponto que você está reforçando. A resposta é: **sim, a estrutura que eu devo seguir é essa evolução de hoje. Eu não posso voltar para a visão antiga de "Portal só como tela inicial".**

O arquivo mostra uma mudança arquitetural importante: o **Portal Enterprise virou o produto principal da plataforma**, e o HIS, AVA, Workforce, Displays etc. deixam de ser o centro. Eles passam a ser aplicações plugáveis. 

A estrutura correta que vamos seguir é:

```text
LOGIN

↓

IDENTITY (Pessoa)

↓

SELEÇÃO DE CONTEXTO

↓

PORTAL ENTERPRISE

↓

PORTAL RUNTIME

↓

┌─────────────────────────────┐
│                             │
│   Mundo Operacional          │
│                             │
│   Aplicações                 │
│   Widgets                    │
│   Dashboards                 │
│   Favoritos                 │
│                             │
├─────────────────────────────┤
│                             │
│   Management Center          │
│                             │
│   Gestão da Plataforma       │
│                             │
└─────────────────────────────┘
```

O documento deixa claro que existe **um único Portal Enterprise**, não vários portais por perfil. Não existe Portal Root, Portal Gestor ou Portal Funcionário. O conteúdo muda através do Runtime. 

---

## A evolução do Portal que você comentou

Antes a ideia poderia parecer:

```
Login
 ↓
Dashboard
 ↓
HIS
```

Isso era pensar como HIS.

A decisão de hoje mudou para:

```
Login
 ↓
Portal Enterprise
 ↓
Dashboard do Portal
 ↓
Aplicações
 ↓
Containers
 ↓
Módulos
```

E dentro do Portal existe:

```
Portal Enterprise

├── Operação
│
└── Management Center
```

O Management Center não é uma página de configuração. Ele é um ambiente administrativo especializado dentro do ecossistema. 

---

## Sobre o Portal de Gestão

Sim, agora temos o conceito de **Portal de Gestão / Management Center**.

Ele não deve ser criado assim:

```
portal/pages/configuracoes
```

Ele deve ser:

```
Portal Enterprise

↓

Management Center

↓

Containers administrativos

↓

Subportal administrativo do módulo
```

Cada módulo publica sua própria administração.

Exemplo:

```
Management Center

↓

HIS

↓

Administração HIS
```

ou:

```
Management Center

↓

Displays

↓

Administração Displays
```

O Management Center apenas orquestra. 

---

## Sobre o KILO e os MDs

Também entendi sua regra:

Nós **não vamos pedir para o KILO inventar banco ou copiar estrutura antiga**.

Ele deve:

1. Ler os MDs canônicos.
2. Ler BRs.
3. Ler FRONTs.
4. Ler o dump SQL congelado.
5. Usar tabelas e procedures existentes como referência.
6. Criar a nova arquitetura baseada nos documentos.

O dump continua como fonte de evidência do legado, não como arquitetura final. O KILO deve ler arquivos `.sql` dumpados, nunca um banco rodando, e comparar contra os modelos canônicos. 

---

## Então nosso arquivo FRONT agora não pode ser antigo

O próximo documento não pode ser somente:

```
FRONT-001 Login
```

Antes dele precisamos congelar:

```
FRONT-000
Frontend Platform Architecture Constitution
```

E nele precisa entrar:

### Portal

```
Login
Identity
Context Selection
Portal Runtime
Portal Dashboard
Application Registry
Containers
Widgets
Navigation
Branding
```

### Management Center

```
Management Runtime
Containers administrativos
Subportais administrativos
Configuração modular
```

### Aplicações

```
HIS
AVA
Workforce
Displays
CRM
Financeiro
Chat
```

como plugins.

---

E confirmando sua preocupação: **não vou voltar a criar uma arquitetura onde Login fica em cada app, ou onde HIS tem seu próprio Portal.**

A direção correta é exatamente essa que você trouxe:

> **Platform Core → Portal Enterprise → Management Center → Applications → Modules**

Essa é a base que devemos usar para começar os TSX. Primeiro construímos o **Portal Shell + Runtime + Login + Context Selection + Dashboard do Portal**. Depois abrimos os containers das aplicações.






















