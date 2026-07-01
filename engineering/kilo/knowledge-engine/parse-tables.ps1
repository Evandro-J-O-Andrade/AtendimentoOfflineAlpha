# PARSE SQL TABLE SCHEMA
param($SourcePath = "docs/database/tables_raw", $TargetPath = "engineering/inventory")

$inventory = @{
    generated = (Get-Date).ToString()
    total = 0
    by_domain = @{}
    all = @()
}

$files = Get-ChildItem -Path $SourcePath -Filter *.json
foreach ($file in $files) {
    $name = $file.BaseName
    $domain = switch -Regex ($name) {
        "^(pessoa|usuario|sessao|portal|tenant|entidade|unidade|setor)" { "Core"; break }
        "^(perfil|permissao|papel|grupo|acl)" { "IAM"; break }
        "^(senha|fila|triagem|totem|ffa|atendimento|internacao|triage)" { "HIS"; break }
        "^(display|tela|menu|navegacao)" { "Displays"; break }
        "^(profissional|funcionario|vinculo|alocacao|colaborador)" { "Workforce"; break }
        "^(relatorio|indicadores|dashboard|bi_|analytics)" { "BI"; break }
        "^(agenda|agendamento|disponibilidade)" { "Agendamento"; break }
        "^(sac|solicitacao|chamado|ticket)" { "SAC"; break }
        "^(regula|regulacao|transferencia)" { "Regulacao"; break }
        "^(integra|webhook|endpoint)" { "Integration"; break }
        default { "Unknown"; break }
    }
    
    $inventory.all += @{ name = $name; domain = $domain; file = $file.Name }
    if (-not $inventory.by_domain.ContainsKey($domain)) { $inventory.by_domain[$domain] = @() }
    $inventory.by_domain[$domain] += $name
}

$inventory.total = $inventory.all.Count
$inventory | ConvertTo-Json -Depth 10 | Set-Content "$TargetPath/tables.json"
Write-Host "Parsed $inventory.total tables" -ForegroundColor Green