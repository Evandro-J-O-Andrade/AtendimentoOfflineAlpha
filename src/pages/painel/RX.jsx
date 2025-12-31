import PainelFila from './PainelFila';

export default function RX() {
    const usuario = "RX";

    return (
        <div>
            <h1>Painel RX</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
