import PainelFila from './PainelFila';

export default function Clinico() {
    const usuario = "Dr. Fulano";
    return (
        <div>
            <h1>Painel Clínico</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
