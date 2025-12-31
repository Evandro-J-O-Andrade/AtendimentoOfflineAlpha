import PainelFila from './PainelFila';

export default function MedicacaoInfantil() {
    const usuario = "Medicacao Infantil";

    return (
        <div>
            <h1>Painel Medicacao Infantil</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
