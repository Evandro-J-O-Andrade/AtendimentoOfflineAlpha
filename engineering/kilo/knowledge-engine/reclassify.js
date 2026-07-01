const fs = require('fs');
const path = require('path');

const data = JSON.parse(fs.readFileSync('engineering/inventory/tables.json'));

const refined = data.all.map(t => {
    const name = t.name;
    let domain = t.domain;
    
    if (domain === 'Unknown') {
        if (/^(pessoa|usuario|sessao|portal|tenant|entidade|unidade|setor|contexto|local|tipo_local|tipo_sala|acompanhante)/.test(name)) domain = 'Core';
        else if (/^(perfil|permissao|papel|grupo|acl|perfil_usuario)/.test(name)) domain = 'IAM';
        else if (/^(senha|fila|triagem|totem|ffa|atendimento|internacao|triage|workflow_ffa|retorno_atendimento|reabertura_atendimento)/.test(name)) domain = 'HIS';
        else if (/^(painel|tela|menu|navegacao|tv_rotativo|display)/.test(name)) domain = 'Displays';
        else if (/^(profissional|funcionario|vinculo|alocacao|colaborador|registro_profissional)/.test(name)) domain = 'Workforce';
        else if (/^(relatorio|indicadores|dashboard|bi_|analytics|estatistica|metric)/.test(name)) domain = 'BI';
        else if (/^(agenda|agendamento|disponibilidade|agendamentos_eventos)/.test(name)) domain = 'Agendamento';
        else if (/^(sac|solicitacao|chamado|ticket|ticket_sac|atendimento_sac)/.test(name)) domain = 'SAC';
        else if (/^(regula|regulacao|transferencia)/.test(name)) domain = 'Regulacao';
        else if (/^(integra|webhook|integracao)/.test(name)) domain = 'Integration';
        else if (/^(auditoria_|audit_)/.test(name)) domain = 'Runtime/Auditoria';
        else if (/^(assistencial_|almoxarifado_|estoque_|farm_|medicacao_|anamnese|anotacao|administracao_)/.test(name)) domain = 'Runtime';
        else if (/^(alerta_|status_timeout)/.test(name)) domain = 'Operational';
        else if (/^cids?$/.test(name)) domain = 'Regulacao';
        else if (/^laboratorio|laudo/.test(name)) domain = 'Diagnostics';
    }
    
    return { ...t, refined_domain: domain };
});

data.all = refined;
fs.writeFileSync('engineering/inventory/tables.json', JSON.stringify(data, null, 2));

const count = {};
refined.forEach(t => { count[t.refined_domain] = (count[t.refined_domain] || 0) + 1; });
console.log('Reclassified:', JSON.stringify(count, null, 2));