import React, { useState } from 'react';
import { useRuntime } from '@/app/providers/RuntimeContext';
import { runtimeService } from '@/services/runtime.service';
import api from '@/services/api'; // Para buscas/GETs simples

/**
 * Página de Recepção - Novo Modelo (Semantic Dispatcher)
 * Baseado em: ANALISE_FFA_ATENDIMENTO_MINUCIOSA.md e MAPA_FRONTEND_TABELAS_CAMPOS.md
 */
const RecepcaoNew = () => {
    const { runtime } = useRuntime();
    const [loading, setLoading] = useState(false);
    const [busca, setBusca] = useState('');
    const [pacientes, setPacientes] = useState([]);
    const [pacienteSelecionado, setPacienteSelecionado] = useState(null);
    const [dadosAtendimento, setDadosAtendimento] = useState({
        tipo_atendimento: 'CONSULTA',
        natureza_atendimento: 'SUS',
        motivo: ''
    });

    // Busca de pacientes (Query simples conforme MAPA_FRONTEND_TABELAS_CAMPOS item 2.1)
    const buscarPaciente = async () => {
        if (!busca) return;
        setLoading(true);
        try {
            const response = await api.get(`/operacional/pacientes?termo=${busca}`);
            setPacientes(response.data || []);
        } catch (err) {
            console.error("Erro ao buscar paciente:", err);
        } finally {
            setLoading(false);
        }
    };

    // Ação Principal: Abrir FFA via Dispatcher (Novo Modelo Imutável)
    const handleAbrirFFA = async () => {
        if (!pacienteSelecionado) return alert("Selecione um paciente");
        
        setLoading(true);
        try {
            // Toda a inteligência de persistência (FFA + Atendimento + Senha + Ledger) 
            // acontece no backend via Procedure chamada pelo Dispatcher
            const result = await runtimeService.dispatch('FFA_ABRIR', {
                id_paciente: pacienteSelecionado.id,
                tipo_atendimento: dadosAtendimento.tipo_atendimento,
                natureza_atendimento: dadosAtendimento.natureza_atendimento,
                motivo: dadosAtendimento.motivo,
                // Dados do totem/origem
                origem: 'RECEPCAO'
            }, runtime);

            alert(`FFA aberta com sucesso! Senha gerada: ${result.data?.payload?.senha_codigo || 'N/A'}`);
            setPacienteSelecionado(null);
            setDadosAtendimento({ tipo_atendimento: 'CONSULTA', natureza_atendimento: 'SUS', motivo: '' });
        } catch (err) {
            console.error("Erro ao despachar abertura de FFA:", err);
            alert("Erro ao processar abertura de atendimento no Ledger.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="p-6 max-w-4xl mx-auto">
            <h1 className="text-2xl font-bold mb-4">Recepção - Abertura de Atendimento</h1>

            {/* Busca de Paciente */}
            <div className="bg-white p-4 rounded shadow mb-6">
                <label className="block text-sm font-medium mb-1">Buscar Paciente (CPF ou Nome)</label>
                <div className="flex gap-2">
                    <input 
                        className="border p-2 flex-1 rounded" 
                        value={busca} 
                        onChange={e => setBusca(e.target.value)} 
                    />
                    <button onClick={buscarPaciente} className="bg-gray-800 text-white px-4 rounded">Buscar</button>
                </div>

                <ul className="mt-4 divide-y">
                    {pacientes.map(p => (
                        <li 
                            key={p.id} 
                            onClick={() => setPacienteSelecionado(p)}
                            className={`p-2 cursor-pointer hover:bg-blue-50 ${pacienteSelecionado?.id === p.id ? 'bg-blue-100' : ''}`}
                        >
                            {p.nome_completo} - CPF: {p.cpf}
                        </li>
                    ))}
                </ul>
            </div>

            {/* Formulário de Atendimento */}
            {pacienteSelecionado && (
                <div className="bg-white p-4 rounded shadow border-t-4 border-blue-500">
                    <h2 className="font-bold mb-4">Dados do Atendimento: {pacienteSelecionado.nome_completo}</h2>
                    
                    <div className="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label className="block text-xs uppercase font-bold">Tipo</label>
                            <select className="border p-2 w-full" value={dadosAtendimento.tipo_atendimento} onChange={e => setDadosAtendimento({...dadosAtendimento, tipo_atendimento: e.target.value})}>
                                <option value="CONSULTA">Consulta</option>
                                <option value="EMERGENCIA">Emergência</option>
                            </select>
                        </div>
                        <div>
                            <label className="block text-xs uppercase font-bold">Motivo/Queixa</label>
                            <input className="border p-2 w-full" value={dadosAtendimento.motivo} onChange={e => setDadosAtendimento({...dadosAtendimento, motivo: e.target.value})} />
                        </div>
                    </div>

                    <button onClick={handleAbrirFFA} disabled={loading} className="w-full bg-green-600 text-white p-3 rounded font-bold">
                        {loading ? 'Processando no Ledger...' : 'Abrir FFA e Gerar Senha'}
                    </button>
                </div>
            )}
        </div>
    );
};

export default RecepcaoNew;