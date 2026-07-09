$ErrorActionPreference = 'SilentlyContinue'

$domainList = @('atendimento','auditoria','configuracao','display','enfermagem','estoque','farmacia','faturamento','ffa','fila','financeiro','governanca','iam','identity','internacao','kernel','laboratorio','medico','notificacao','paciente','painel','pessoa','recepcao','runtime','senha','triagem')

$subfolders = @('api','application','components','contracts','dashboard','entities','events','hooks','pages','procedures','queries','routes','services','store','tests','types','validators','workflow','ai','automation','docs')

foreach ($domain in $domainList) {
    $base = "modules\$domain"
    foreach ($sub in $subfolders) {
        $p = Join-Path $base $sub
        if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
    }

    $dashContent = @"
import { ModuleDashboard } from '@/core/components/ModuleDashboard';

export function HomeDashboard() {
  return <ModuleDashboard title="$domain - Início" moduleId="$domain" />;
}

export function AnalyticsDashboard() {
  return <ModuleDashboard title="$domain - Analytics" moduleId="$domain" />;
}

export function TimelineDashboard() {
  return <ModuleDashboard title="$domain - Timeline" moduleId="$domain" />;
}
"@
    Set-Content -LiteralPath "$base\dashboard\index.tsx" -Value $dashContent -Encoding UTF8

    $routesContent = @"
import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/$domain', component: 'Dashboard', label: '$domain' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/$domain', component: 'AdminDashboard', label: '$domain Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/$domain', component: 'ApiList', label: '$domain API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/$domain', component: 'MobileDashboard', label: '$domain Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/$domain', component: 'DisplayBoard', label: '$domain Display' },
];
"@
    Set-Content -LiteralPath "$base\routes\index.ts" -Value $routesContent -Encoding UTF8

    $manifest = @{
        id = $domain
        nome = $domain
        icone = 'Box'
        categoria = 'Core'
        ordem = 1
        permissions = @()
        routes = @("/$domain")
        dashboard = './dashboard'
        widgets = @()
        menu = @(@{ label = $domain; route = "/$domain"; icone = 'Box' })
        featureFlags = @()
        procedures = @()
        events = @()
        ai = @('./ai')
        automation = @('./automation')
    } | ConvertTo-Json -Depth 5
    Set-Content -LiteralPath "$base\manifest.ts" -Value "export default $manifest" -Encoding UTF8

    $index = "// Módulo $domain`n`nexport { default as manifest } from './manifest';`nexport * from './routes';`nexport * from './types';"
    Set-Content -LiteralPath "$base\index.ts" -Value $index -Encoding UTF8

    Set-Content -LiteralPath "$base\permissions.ts" -Value "// Permissões do módulo $domain`nexport const permissions = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\menu.ts" -Value "// Menu do módulo $domain`nexport const menu = { label: '$domain', route: '/$domain', icone: 'Box' };" -Encoding UTF8
    Set-Content -LiteralPath "$base\types\index.ts" -Value "// Tipos do módulo $domain`nexport interface ${domain}_Entity { id: string; }" -Encoding UTF8
    Set-Content -LiteralPath "$base\contracts\index.ts" -Value "// Contratos do módulo $domain`nexport interface ${domain}Contract { }" -Encoding UTF8
    Set-Content -LiteralPath "$base\entities\index.ts" -Value "// Entidades do módulo $domain`nexport class ${domain}Entity { }" -Encoding UTF8
    Set-Content -LiteralPath "$base\events\index.ts" -Value "// Eventos do módulo $domain`nexport type ${domain}Event = { type: string; payload: unknown };" -Encoding UTF8
    Set-Content -LiteralPath "$base\hooks\index.ts" -Value "// Hooks do módulo $domain`nexport const use$domain = () => { };" -Encoding UTF8
    Set-Content -LiteralPath "$base\services\index.ts" -Value "// Services do módulo $domain`nexport class ${domain}Service { }" -Encoding UTF8
    Set-Content -LiteralPath "$base\store\index.ts" -Value "// Store do módulo $domain`nexport const ${domain}Store = { };" -Encoding UTF8
    Set-Content -LiteralPath "$base\procedures\index.ts" -Value "// Procedures do módulo $domain`nexport const procedures = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\queries\index.ts" -Value "// Queries do módulo $domain`nexport const queries = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\validators\index.ts" -Value "// Validadores do módulo $domain`nexport const validators = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\workflow\index.ts" -Value "// Workflow do módulo $domain`nexport const workflow = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\ai\index.ts" -Value "// IA do módulo $domain`nexport const aiConfig = { prompts: [], rag: [], knowledge: [] };" -Encoding UTF8
    Set-Content -LiteralPath "$base\automation\index.ts" -Value "// Automação do módulo $domain`nexport const automation = [];" -Encoding UTF8
    Set-Content -LiteralPath "$base\docs\README.md" -Value "# Módulo $domain`n`nDocumentação do domínio $domain." -Encoding UTF8

    if (-not (Test-Path "$base\pages\Dashboard")) { New-Item -ItemType Directory -Path "$base\pages\Dashboard" -Force | Out-Null }
    Set-Content -LiteralPath "$base\pages\Dashboard\index.tsx" -Value "export default function Dashboard() { return <div>$domain Dashboard</div>; }" -Encoding UTF8

    if (-not (Test-Path "$base\application")) { New-Item -ItemType Directory -Path "$base\application" -Force | Out-Null }
    Set-Content -LiteralPath "$base\application\index.ts" -Value "// Application layer do módulo $domain" -Encoding UTF8
}

Write-Host "✅ Estrutura completa criada para $($domainList.Count) domínios em modules/"