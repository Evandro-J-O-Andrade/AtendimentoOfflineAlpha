import PainelFila from './PainelFila';

export default function Satisfacao() {
    const usuario = "Satisfacao";

    return (
        <div>
            <h1>Painel Satisfacao</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
