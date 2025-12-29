import { useParams } from "react-router-dom";

export default function Atendimento() {
  const { id } = useParams();
  return <h2>Atendimento #{id}</h2>;
}
