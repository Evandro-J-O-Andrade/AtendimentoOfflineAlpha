$content = Get-Content 'backend/sql/Dump20260326 (1).sql' -Raw

$tables = @(
    'atendimento_anamnese',
    'atendimento_balanco_hidrico',
    'atendimento_checagem',
    'atendimento_desfecho',
    'atendimento_diagnostico',
    'atendimento_escalas_risco',
    'atendimento_estado_ativo',
    'atendimento_evento',
    'atendimento_evento_ledger',
    'atendimento_evolucao',
    'atendimento_exame_fisico',
    'atendimento_identidade_fluxo',
    'atendimento_movimentacao',
    'atendimento_observacao',
    'atendimento_pedidos_exame',
    'atendimento_pre_hospitalar',
    'atendimento_prescricao',
    'atendimento_profissional',
    'atendimento_recepcao',
    'atendimento_sinais_vitais',
    'atendimento_sumario_alta',
    'atendimento_transicao_ledger',
    'atendimento_triagem',
    'atendimento_vinculo',
    'gpat_atendimento',
    'farm_atendimento_externo',
    'farmacia_atendimento_externo_dispensacao',
    'assistencial_checkpoint_global',
    'assistencial_runtime_panel',
    'assistencial_runtime_federado',
    'assistencial_simulacao_futura',
    'assistencial_snapshot_runtime',
    'assistencial_telemetria_runtime',
    'assistencial_watchdog_fila',
    'internacao',
    'internacao_medicacao_administracao',
    'internacao_movimentacao',
    'internacao_prescricao',
    'internacao_prescricao_item',
    'internacao_registro_enfermagem',
    'internacao_turno_registro',
    'ordem_assistencial',
    'ordem_assistencial_item',
    'ordem_assistencial_aprazamento',
    'ordem_assistencial_execucao',
    'protocolo_assistencial_global',
    'triagem',
    'reabertura_atendimento',
    'retorno_atendimento',
    'fluxo_orquestrador_canonico'
)

foreach ($t in $tables) {
    $pattern = "CREATE TABLE ``$t``"
    $start = $content.IndexOf($pattern)
    
    if ($start -ge 0) {
        $end = $content.IndexOf(';', $start)
        $block = $content.Substring($start, $end - $start + 1)
        
        if ($block -match 'FOREIGN KEY') {
            Write-Host "=== $t ===" -ForegroundColor Green
            $lines = $block -split "`n"
            foreach ($line in $lines) {
                if ($line -match 'FOREIGN KEY|REFERENCES') {
                    Write-Host $line.Trim()
                }
            }
            Write-Host ""
        } else {
            Write-Host "$t : SEM FK" -ForegroundColor Yellow
        }
    } else {
        Write-Host "$t : NAO ENCONTRADA" -ForegroundColor Red
    }
}
