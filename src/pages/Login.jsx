import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';
import api from '../api/api';
import Header from '../components/Header';
import Footer from '../components/Footer';

export default function Login() {
    const [login, setLogin] = useState('');
    const [senha, setSenha] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const { signIn } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setLoading(true);

        try {
            // CORREÇÃO: Usando o novo endpoint de autenticação
            const response = await api.post('/auth.php', {
                login,
                senha
            });

            const { token, usuario } = response.data;

            if (!token || !usuario) {
                throw new Error('Resposta inválida da API');
            }

            // Salva no contexto (token + usuário + perfis)
            signIn(token, usuario);

            const perfis = usuario.perfis || [];

            // Redirecionamento por perfil
            if (perfis.includes('ADMIN') || perfis.includes('GESTAO')) {
                navigate('/dashboard');
            } else if (perfis.includes('RECEPCAO')) {
                navigate('/recepcao');
            } else if (perfis.includes('ENFERMAGEM')) {
                navigate('/triagem');
            } else if (perfis.includes('MEDICO')) {
                navigate('/medico/fila');
            } else if (perfis.includes('AUDITORIA')) {
                navigate('/auditoria');
            } else {
                setError('Usuário sem perfil autorizado.');
            }

        } catch (err) {
            const msg =
                err.response?.data?.message ||
                err.message ||
                'Login ou senha inválidos.';
            setError(msg);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>

            {/* BANNER SUPERIOR */}
            <header style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                padding: '15px 30px',
                borderBottom: '1px solid #ccc'
            }}>
                <img src="/img/logo-left.png" alt="Logo esquerda" height="50" />
                <h2>Pronto Atendimento Hospitalar</h2>
                <img src="/img/logo-right.png" alt="Logo direita" height="50" />
            </header>

            {/* CONTEÚDO CENTRAL */}
            <main style={{
                flex: 1,
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center'
            }}>
                <form
                    onSubmit={handleSubmit}
                    style={{
                        width: '100%',
                        maxWidth: '400px',
                        padding: '25px',
                        border: '1px solid #ccc',
                        borderRadius: '6px'
                    }}
                >
                    <h3 style={{ marginBottom: '20px' }}>Acesso ao Sistema</h3>

                    {error && (
                        <p style={{ color: 'red', marginBottom: '15px' }}>
                            {error}
                        </p>
                    )}

                    <div style={{ marginBottom: '15px' }}>
                        <label>Login</label>
                        <input
                            type="text"
                            value={login}
                            onChange={e => setLogin(e.target.value)}
                            required
                            style={{ width: '100%', padding: '8px' }}
                        />
                    </div>

                    <div style={{ marginBottom: '20px' }}>
                        <label>Senha</label>
                        <input
                            type="password"
                            value={senha}
                            onChange={e => setSenha(e.target.value)}
                            required
                            style={{ width: '100%', padding: '8px' }}
                        />
                    </div>

                    <button
                        type="submit"
                        disabled={loading}
                        style={{
                            width: '100%',
                            padding: '10px',
                            cursor: loading ? 'not-allowed' : 'pointer'
                        }}
                    >
                        {loading ? 'Entrando...' : 'Entrar'}
                    </button>
                </form>
            </main>

            {/* RODAPÉ */}
            <footer style={{
                textAlign: 'center',
                padding: '10px',
                borderTop: '1px solid #ccc',
                fontSize: '14px'
            }}>
                © 2025 Pronto Atendimento • Sistema Hospitalar
            </footer>

        </div>
    );
}