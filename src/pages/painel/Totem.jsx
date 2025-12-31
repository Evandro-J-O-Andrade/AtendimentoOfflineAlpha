import PainelFila from './PainelFila';

export default function Totem() {
    const usuario = "Totem";

    return (
        <div>
            <h1>Painel Totem</h1>
            <PainelFila usuario={usuario} />
            <p>Touch para gerar senha</p>
        </div>
    );
}
