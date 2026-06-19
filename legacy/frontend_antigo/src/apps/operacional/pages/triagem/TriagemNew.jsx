import React, { useState } from 'react';
import { useRuntime } from '@/app/providers/RuntimeContext';
import { runtimeService } from '@/services/runtime.service';

const TriagemNew = ({ ffaAtivo }) => {
    const { runtime } = useRuntime();
    const [loading, setLoading] = useState(false);
    const [sinaisVitais, setSinaisVitais] = useState({
        pa: '', fc: '', temp: '', sat: ''
    });

    const finalizarTriagem = async () => {
        setLoading(true);
        try {
            // Envia a ação via Dispatcher conforme sugerido no seu MD de Arquitetura
            await runtimeService.dispatch('TRIAGEM_REGISTRAR', {
                id_ffa: ffaAtivo.id,
                sinais_vitais: sinaisVitais,
                classificacao_risco: 'AMARELO',
                queixa: 'Paciente com dor abdominal'
            }, runtime);
            
            alert('Triagem realizada e gravada no Ledger!');
        } catch (err) {
            console.error("Erro no dispatch:", err);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="p-4">
            <h2 className="text-xl font-bold">Registro de Triagem</h2>
            {/* Campos de input aqui... */}
            <button 
                onClick={finalizarTriagem}
                disabled={loading}
                className="bg-blue-600 text-white p-2 rounded"
            >
                {loading ? 'Processando...' : 'Finalizar e Enviar ao Médico'}
            </button>
        </div>
    );
};

export default TriagemNew;