import PainelFila from './PainelFila';

export default function MedicacaoAdulta() {
    const usuario = "Medicacao Adulta";

    return (
        <div>
            <h1>Painel Medicacao Adulta</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
