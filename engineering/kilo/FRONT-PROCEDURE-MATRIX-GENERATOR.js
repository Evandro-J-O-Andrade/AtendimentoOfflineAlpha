const fs = require('fs');
const path = require('path');

const OUTPUT_FILE = 'engineering/canonical/FRONT-PROCEDURE-MATRIX.md';

const PROCEDURES = [
  { sp: 'sp_master_login', tela: 'Login', dominio: 'IAM' },
  { sp: 'sp_auth_contexto_get', tela: 'Portal', dominio: 'IAM' },
  { sp: 'sp_master_dispatcher', tela: 'Portal', dominio: 'Core' },
  { sp: 'sp_master_atendimento_iniciar', tela: 'Recepção', dominio: 'HIS' },
  { sp: 'sp_master_senha_emitir', tela: 'Senha', dominio: 'HIS' },
  { sp: 'sp_senha_emitir', tela: 'Painel', dominio: 'HIS' },
  { sp: 'sp_senha_chamar', tela: 'Triagem', dominio: 'HIS' },
  { sp: 'sp_senha_finalizar', tela: 'Senha', dominio: 'HIS' },
  { sp: 'sp_fila_chamar_proxima', tela: 'Atendimento', dominio: 'HIS' },
  { sp: 'sp_fila_finalizar', tela: 'Atendimento', dominio: 'HIS' },
  { sp: 'sp_recepcao_iniciar_complementacao', tela: 'Recepção', dominio: 'HIS' },
  { sp: 'sp_recepcao_complementar_e_abrir_ffa', tela: 'FFA', dominio: 'HIS' },
  { sp: 'sp_recepcao_encaminhar_ffa', tela: 'FFA', dominio: 'HIS' },
  { sp: 'sp_ffa_orquestrador_transicao', tela: 'FFA', dominio: 'HIS' },
  { sp: 'sp_triagem_finalizar', tela: 'Triagem', dominio: 'HIS' },
  { sp: 'sp_medico_encaminhar', tela: 'Médico', dominio: 'HIS' },
  { sp: 'sp_medico_finalizar', tela: 'Médico', dominio: 'HIS' },
  { sp: 'sp_atendimento_transicionar', tela: 'Dashboard', dominio: 'HIS' },
  { sp: 'sp_atendimento_finalizar_evasao', tela: 'Dashboard', dominio: 'HIS' },
  { sp: 'sp_farmacia_dispensar_registrar', tela: 'Farmácia', dominio: 'HIS' },
  { sp: 'sp_estoque_movimento_criar', tela: 'Estoque', dominio: 'Financeiro' },
];

function generateMatrix() {
  let content = `# Matriz Front × Procedure

## Tela → SP → Tabela → Evento → Permissão

${PROCEDURES.map(p => `### ${p.tela}
- SP: \`${p.sp}\`
- Domínio: ${p.dominio}
- Tela → /portal/${p.tela.toLowerCase()}
`).join('\n')}

---

## Matriz Completa

| Tela | SP | Endpoint |
|------|-----|----------|
${PROCEDURES.map(p => `| ${p.tela} | \`${p.sp}\` | \`/api/${p.dominio.toLowerCase()}\` |`).join('\n')}
`;

  fs.writeFileSync(OUTPUT_FILE, content);
  console.log(`Gerada matriz em ${OUTPUT_FILE}`);
}

generateMatrix();