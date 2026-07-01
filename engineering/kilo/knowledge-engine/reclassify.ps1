# RECLASSIFY UNKNOWN TABLES

$tables = Get-Content "engineering/inventory/tables.json" | ConvertFrom-Json
$refined = $tables.all | ForEach-Object {
    $name = $_.name
    $domain = switch -Regex ($name) {
        "^(pessoa|usuario|sessao|portal|tenant|entidade|unidade|setor|contexto|local|tipo_local|tipo_sala)" { "Core"; break }
        "^(perfil|permissao|papel|grupo|acl|perfil_usuario)" { "IAM"; break }
        "^(senha|fila|triagem|totem|ffa|atendimento|internacao|triage|workflow_ffa)" { "HIS"; break }
        "^(painel|tela|menu|navegacao|tv_rotativo|display)" { "Displays"; break }
        "^(profissional|funcionario|vinculo|alocacao|colaborador|registro_profissional)" { "Workforce"; break }
        "^(relatorio|indicadores|dashboard|bi_|analytics|estatistica|metric)" { "BI"; break }
        "^(agenda|agendamento|disponibilidade|agendamentos_eventos)" { "Agendamento"; break }
        "^(sac|solicitacao|chamado|ticket|ticket_sac|atendimento_sac)" { "SAC"; break }
        "^(regula|regulacao|regulacao_evento|transferencia)" { "Regulacao"; break }
        "^(integra|webhook|endpoint|integracao)" { "Integration"; break }
        "^(auditoria_|audit_)" { "Runtime/Auditoria"; break }
        "^(assistencial_|almoxarifado_|estoque_|farm_|medicacao_|anamnese|anotacao)" { "Runtime"; break }
        "^(alerta_|status_timeout|timeout)" { "Operational"; break }
        "^acompanhante$" { "Pessoa"; break }
        default { $_.domain; break }
    }
    $_ | Add-Member -NotePropertyName "refined_domain" -NotePropertyValue $domain -Force
    $_
}

$tables.all = $refined
$tables | ConvertTo-Json -Depth 10 | Set-Content "engineering/inventory/tables.json"
Write-Host "Reclassified unknown tables" -ForegroundColor Green