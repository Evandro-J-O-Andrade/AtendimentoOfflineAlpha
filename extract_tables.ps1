$tables = @('internacao_prescricao_item','internacao_registro_enfermagem','internacao_turno_registro','kernel_authz_policy','kernel_identity_trust_chain','kernel_ledger','kernel_runtime_evento','kernel_runtime_heartbeat','kernel_runtime_single_writer_lock','kernel_single_writer_lock','lab_amostra','lab_evento','lab_pedido','lab_protocolo_interno','lab_resultado','laboratorio_protocolo','laboratorio_protocolo_evento','ledger_evento_sincronizacao','ledger_evento_sincronizacao_local','ledger_global_sincronismo','leito','local','local_capacidade','local_dispositivo','local_fila','local_runtime','local_turno','log_acesso_prontuario','log_auditoria','log_leitura_prontuario','login_tentativa','logradouro','manutencao_execucao','md_arquivo_fonte','md_arquivo_fonte_evento','md_cid10','md_cnes_estabelecimento','md_competencia','md_sigpat_medicamento','md_sigtap_procedimento','medicacao_reavaliacao','medico','medico_especialidade','notificacao_epidemiologica','notificacao_epidemiologica_evento','notificacao_violencia','notificacao_violencia_evento','obito','obito_evento','observacoes_eventos')
$sql = Get-Content -Path "D:\AtendimentoOfflineAlpha\legacy\backend_antigo\sql\Dump20260606.sql" -Raw
$output = @()
foreach ($table in $tables) {
  $idx = $sql.IndexOf("CREATE TABLE `$table")
  if ($idx -ge 0) {
    $endIdx = $sql.IndexOf("ENGINE=InnoDB", $idx)
    if ($endIdx -ge 0) {
      $stmt = $sql.Substring($idx, $endIdx - $idx + 20)
      $output += "TABLE: $table"
      $output += $stmt
      $output += ""
    }
  }
}
$output | Out-File -FilePath "D:\AtendimentoOfflineAlpha\extracted_tables.txt" -Encoding utf8
"Found tables"