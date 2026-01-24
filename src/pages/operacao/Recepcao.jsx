import React, { useState } from "react";
import Sidebar from "../Sidebar";
import "./Recepcao.css";

// Mock inicial da fila
const filaInicial = [
  { senha: 1, nome: "João Silva", prioridade: "Normal", hora: "08:00", status: "Aguardando" },
  { senha: 2, nome: "Maria Souza", prioridade: "Amarela", hora: "08:05", status: "Aguardando" },
];

export default function Recepcao() {
  const [fila, setFila] = useState(filaInicial);
  const [novaSenha, setNovaSenha] = useState(filaInicial.length + 1);
  const [paciente, setPaciente] = useState({
    nome: "",
    cpf: "",
    nascimento: "",
    sexo: "",
    telefone: "",
    prioridade: "Normal",
  });

  const gerarSenha = () => {
    const novaFila = [
      ...fila,
      {
        senha: novaSenha,
        nome: paciente.nome || "Paciente Manual",
        prioridade: paciente.prioridade,
        hora: new Date().toLocaleTimeString(),
        status: "Aguardando",
      },
    ];

    // Ordenar pela prioridade
    novaFila.sort((a, b) => {
      const prioridadeValor = { "Amarela": 1, "Verde": 2, "Normal": 3 };
      return prioridadeValor[a.prioridade] - prioridadeValor[b.prioridade];
    });

    setFila(novaFila);
    setNovaSenha(novaSenha + 1);
    setPaciente({
      nome: "",
      cpf: "",
      nascimento: "",
      sexo: "",
      telefone: "",
      prioridade: "Normal",
    });
  };

  const iniciarAtendimento = (senha) => {
    const novaFila = fila.map((item) =>
      item.senha === senha ? { ...item, status: "Atendendo" } : item
    );
    setFila(novaFila);
  };

  return (
    <div className="recepcao-wrapper">
      {/* Sidebar lateral */}
      <Sidebar />

      {/* Conteúdo principal */}
      <div className="recepcao-content">
        <header className="recepcao-header">
          <h1>Recepção - Cadastro de Paciente</h1>
        </header>

        <main className="recepcao-main">
          {/* Formulário de cadastro manual */}
          <div className="cadastro-form">
            <h2>Cadastro Manual</h2>
            <input
              type="text"
              placeholder="Nome"
              value={paciente.nome}
              onChange={(e) => setPaciente({ ...paciente, nome: e.target.value })}
            />
            <input
              type="text"
              placeholder="CPF"
              value={paciente.cpf}
              onChange={(e) => setPaciente({ ...paciente, cpf: e.target.value })}
            />
            <input
              type="date"
              placeholder="Data Nascimento"
              value={paciente.nascimento}
              onChange={(e) => setPaciente({ ...paciente, nascimento: e.target.value })}
            />
            <select
              value={paciente.sexo}
              onChange={(e) => setPaciente({ ...paciente, sexo: e.target.value })}
            >
              <option value="">Sexo</option>
              <option value="M">Masculino</option>
              <option value="F">Feminino</option>
              <option value="O">Outro</option>
            </select>
            <input
              type="text"
              placeholder="Telefone"
              value={paciente.telefone}
              onChange={(e) => setPaciente({ ...paciente, telefone: e.target.value })}
            />
            <select
              value={paciente.prioridade}
              onChange={(e) => setPaciente({ ...paciente, prioridade: e.target.value })}
            >
              <option value="Normal">Normal</option>
              <option value="Verde">Preferencial</option>
              <option value="Amarela">Mais Urgente</option>
            </select>
            <button onClick={gerarSenha}>Gerar Senha</button>
          </div>

          {/* Fila de atendimento */}
          <div className="fila-container">
            <h2>Fila de Atendimento</h2>
            <table>
              <thead>
                <tr>
                  <th>Senha</th>
                  <th>Nome</th>
                  <th>Prioridade</th>
                  <th>Hora</th>
                  <th>Status</th>
                  <th>Ação</th>
                </tr>
              </thead>
              <tbody>
                {fila.map((item) => (
                  <tr key={item.senha}>
                    <td>{item.senha}</td>
                    <td>{item.nome}</td>
                    <td>{item.prioridade}</td>
                    <td>{item.hora}</td>
                    <td>{item.status}</td>
                    <td>
                      {item.status === "Aguardando" && (
                        <button onClick={() => iniciarAtendimento(item.senha)}>
                          Iniciar Atendimento
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </main>

        {/* Footer com ações rápidas */}
        <footer className="recepcao-footer">
          <button>Chamar Próxima Senha</button>
          <button>Imprimir Ficha</button>
          <button>Trocar Guichê/Sala</button>
        </footer>
      </div>
    </div>
  );
}
