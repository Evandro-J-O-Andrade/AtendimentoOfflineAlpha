import { useState, useEffect } from 'react';

export default function PainelFila({ usuario }) {
    const [paciente, setPaciente] = useState(null);

    // Pega próximo paciente do backend
    const carregarProximo = async () => {
        const res = await fetch('/api/routes/fila.php?proximo=true');
        if (res.status === 204) {
            setPaciente(null);
            return;
        }
        const data = await res.json();
        setPaciente(data);
    };

    // Chamar paciente (registro na auditoria + TTS)
    const chamarPaciente = async () => {
        if (!paciente) return;
        const res = await fetch('/api/routes/chamada.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                id_ffa: paciente.id,
                usuario_chamador: usuario
            })
        });
        const data = await res.json();
        console.log(data);
        carregarProximo(); // atualiza próximo paciente
    };

    useEffect(() => {
        carregarProximo();
        const intervalo = setInterval(carregarProximo, 5000); // atualiza fila a cada 5s
        return () => clearInterval(intervalo);
    }, []);

    return (
        <div>
            <h2>Painel Fila</h2>
            {paciente ? (
                <div>
                    <p>Próximo: {paciente.nome_completo} (Senha: {paciente.gpat})</p>
                    <p>Plantão: {paciente.tipo_plantao} | Médico: {paciente.nome_medico}</p>
                    <button onClick={chamarPaciente}>Chamar</button>
                </div>
            ) : (
                <p>Nenhum paciente aguardando</p>
            )}
        </div>
    );
}
