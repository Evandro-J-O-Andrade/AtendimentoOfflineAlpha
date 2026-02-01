import React, { useState } from 'react';
import { useFFAs } from '../../shared/hooks/useFFAs';
import { useLocaisAtendimento } from '../../shared/hooks/useLocaisAtendimento';
import { useUI } from '../../shared/hooks/useUI';
import FilaLocal from '../../components/FilaLocal';
import './RecepcaoLayout.css';

/**
 * Página Recepção - Layout Principal
 * Permite cadastro de paciente, abertura de FFA e visualização de filas
 */
export function RecepcaoLayout() {
  const { abrirFFA } = useFFAs();
  const { localAtual, filaLocalAtual, LOCAIS } = useLocaisAtendimento();
  const { confirmar, notificarSucesso, notificarErro } = useUI();

  const [modo, setModo] = useState('fila'); // 'fila' | 'cadastro' | 'chamada'
  const [formulario, setFormulario] = useState({
    nome: '',
    cpf: '',
    data_nascimento: '',
    telefone: '',
  });

  const handleCadastro = async (e) => {
    e.preventDefault();

    confirmar(
      `Confirma abertura de FFA para ${formulario.nome}?`,
      async () => {
        try {
          await abrirFFA({
            nome_paciente: formulario.nome,
            cpf: formulario.cpf,
            data_nascimento: formulario.data_nascimento,
            telefone: formulario.telefone,
          });
          notificarSucesso(`FFA aberta para ${formulario.nome}`);
          setFormulario({ nome: '', cpf: '', data_nascimento: '', telefone: '' });
          setModo('fila');
        } catch (error) {
          notificarErro(`Erro ao abrir FFA: ${error.message}`);
        }
      }
    );
  };

  const chamarProximo = () => {
    if (filaLocalAtual.length === 0) {
      notificarErro('Nenhum paciente em espera');
      return;
    }
    const proximoFFa = filaLocalAtual[0];
    notificarSucesso(`Chamando paciente ${proximoFFa.id_paciente} para ${LOCAIS[localAtual]}`);
  };

  return (
    <div className="recepcao-layout">
      {/* Header */}
      <div className="recepcao-header">
        <h1>🏥 Recepção</h1>
        <p>{LOCAIS[localAtual]}</p>
      </div>

      {/* Abas de Navegação */}
      <div className="recepcao-tabs">
        <button
          className={`tab ${modo === 'fila' ? 'ativo' : ''}`}
          onClick={() => setModo('fila')}
        >
          📋 Fila ({filaLocalAtual.length})
        </button>
        <button
          className={`tab ${modo === 'cadastro' ? 'ativo' : ''}`}
          onClick={() => setModo('cadastro')}
        >
          ➕ Novo Paciente
        </button>
        <button
          className={`tab ${modo === 'chamada' ? 'ativo' : ''}`}
          onClick={() => setModo('chamada')}
        >
          🔊 Chamar Próximo
        </button>
      </div>

      {/* Conteúdo por Modo */}
      <div className="recepcao-conteudo">
        {modo === 'fila' && (
          <div className="secao-fila">
            <FilaLocal local={localAtual} />
          </div>
        )}

        {modo === 'cadastro' && (
          <div className="secao-cadastro">
            <form onSubmit={handleCadastro} className="cadastro-form">
              <div className="form-group">
                <label htmlFor="nome">Nome Completo *</label>
                <input
                  id="nome"
                  type="text"
                  placeholder="Digite o nome do paciente"
                  value={formulario.nome}
                  onChange={(e) => setFormulario({ ...formulario, nome: e.target.value })}
                  required
                />
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="cpf">CPF</label>
                  <input
                    id="cpf"
                    type="text"
                    placeholder="000.000.000-00"
                    value={formulario.cpf}
                    onChange={(e) => setFormulario({ ...formulario, cpf: e.target.value })}
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="data_nascimento">Data de Nascimento</label>
                  <input
                    id="data_nascimento"
                    type="date"
                    value={formulario.data_nascimento}
                    onChange={(e) => setFormulario({ ...formulario, data_nascimento: e.target.value })}
                  />
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="telefone">Telefone</label>
                <input
                  id="telefone"
                  type="tel"
                  placeholder="(00) 00000-0000"
                  value={formulario.telefone}
                  onChange={(e) => setFormulario({ ...formulario, telefone: e.target.value })}
                />
              </div>

              <div className="form-buttons">
                <button type="button" className="btn-secundario" onClick={() => setModo('fila')}>
                  Cancelar
                </button>
                <button type="submit" className="btn-primario">
                  Abrir FFA
                </button>
              </div>
            </form>
          </div>
        )}

        {modo === 'chamada' && (
          <div className="secao-chamada">
            <div className="chamada-container">
              <div className="chamada-info">
                <h3>Chamada de Pacientes</h3>
                <p>Fila: {filaLocalAtual.length} pacientes aguardando</p>
              </div>

              {filaLocalAtual.length > 0 ? (
                <div className="chamada-lista">
                  {filaLocalAtual.slice(0, 5).map((ffa, idx) => (
                    <div key={ffa.id} className={`chamada-item ${idx === 0 ? 'proximo' : ''}`}>
                      <span className="chamada-numero">#{idx + 1}</span>
                      <span className="chamada-paciente">Paciente {ffa.id_paciente}</span>
                      {idx === 0 && <span className="chamada-badge">PRÓXIMO</span>}
                    </div>
                  ))}
                </div>
              ) : (
                <div className="chamada-vazia">Nenhum paciente em espera</div>
              )}

              <button className="btn-chamada" onClick={chamarProximo}>
                🔊 CHAMAR PRÓXIMO
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default RecepcaoLayout;
