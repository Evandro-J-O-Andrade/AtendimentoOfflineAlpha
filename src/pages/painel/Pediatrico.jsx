import PainelFila from './PainelFila';

export default function Pediatrico() {
    const usuario = "Dr. Pediatra";
    return (
        <div>
            <h1>Painel Pediátrico</h1>
            <PainelFila usuario={usuario} />
        </div>
    );
}
