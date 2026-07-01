const fs = require('fs');
const data = JSON.parse(fs.readFileSync('engineering/inventory/tables.json'));

const refined = data.all.map(t => {
    const name = t.name;
    let domain = t.refined_domain;
    
    if (domain === 'Unknown') {
        if (/^auth_/.test(name)) domain = 'IAM/Auth';
        else if (/^(dispensacao|medicamento|medicacao_)/.test(name)) domain = 'HIS/Farmacia';
        else if (/^(caixa|financeiro|pagamento|conta)/.test(name)) domain = 'Financeiro';
        else if (/^(documento_|arquivo_|arquivo)/.test(name)) domain = 'Documents';
        else if (/^(dispositivo_|equipamento)/.test(name)) domain = 'Operational';
        else if (/^(config_|parametro_|regra_|cat_)/.test(name)) domain = 'Config';
        else if (/^(cidade|estado|pais|endereco|cep|logradouro)/.test(name)) domain = 'Core';
        else if (/^(classificacao|risco|categoria)/.test(name)) domain = 'Core';
        else if (/^(conselho_|profissional_)/.test(name)) domain = 'Workforce';
        else if (/^(anamnese|prontuario|evolucao|prescricao)/.test(name)) domain = 'HIS';
        else if (/^(remocao_|transporte_)/.test(name)) domain = 'Operational';
        else if (/^(reg_|export_|auditoria_|audit_)/.test(name)) domain = 'Compliance';
        else if (/^(sinan_|notificacao_|cid_|agravo)/.test(name)) domain = 'Epidemiologia';
        else if (/^(sus_|cnes_|sigtap)/.test(name)) domain = 'Regulacao/SUS';
        else if (/^(reg_export_|reg_auditoria_|reg_anexo)/.test(name)) domain = 'Compliance';
        else if (/^(runtime_|sincronizacao_|retry_|concurrency|lock)/.test(name)) domain = 'Runtime';
        else if (/^(rh_|funcionario_)/.test(name)) domain = 'Workforce';
        else if (/^totem|^tv_|^painel/.test(name)) domain = 'Displays';
        else if (/^regulacao|^regula/.test(name)) domain = 'Regulacao';
        else if (/^agenda|^agendamento/.test(name)) domain = 'Agendamento';
        else if (/^sac|^chamado|^ticket|^atendimento_sac/.test(name)) domain = 'SAC';
        else if (/^fila|^senha|^triagem|^totem|^triage|^retorno|^reabertura/.test(name)) domain = 'HIS/Fila';
        else if (/^atendimento$|^atendimento_|^internacao$|^internacao_|^alta|^epidemiolog/.test(name)) domain = 'HIS';
        else if (/^cliente|^contrato|^regra|^config|^parametro/.test(name)) domain = 'Core/Business';
    }
    
    return { ...t, refined_domain: domain };
});

data.all = refined;
fs.writeFileSync('engineering/inventory/tables.json', JSON.stringify(data, null, 2));

const count = {};
refined.forEach(t => { count[t.refined_domain] = (count[t.refined_domain] || 0) + 1; });
console.log('Reclassified:', JSON.stringify(count, null, 2));