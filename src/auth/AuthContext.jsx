import { createContext, useState, useEffect } from "react"; // 1. Importar useEffect
import api from "../api/api"; // Assume que 'api' é o cliente Axios configurado

export const AuthContext = createContext();

export function AuthProvider({ children }) {
    // 2. Inicialmente, o estado é null. A validação do token o definirá.
    const [user, setUser] = useState(null); 
    const [loading, setLoading] = useState(true); // 3. Estado para controlar o carregamento inicial

    // Função de login está correta
    async function login(login, senha) {
        try {
            const res = await api.post("/auth.php", { login, senha });
            const { token, usuario } = res.data; // Pega o token e o objeto 'usuario'

            // Ajuste aqui: O PHP envia o objeto 'usuario' (que tem id, nome, perfil)
            localStorage.setItem("token", token);
            localStorage.setItem("user", JSON.stringify(usuario)); // Armazena o objeto 'usuario'
            setUser(usuario);
            return true; // Sucesso
        } catch (error) {
            // Lógica de erro de login
            console.error("Login falhou:", error);
            throw error; 
        }
    }

    function logout() {
        localStorage.clear();
        setUser(null);
    }

    // 4. EFEITO PARA VALIDAR O TOKEN NA INICIALIZAÇÃO
    useEffect(() => {
        async function loadUserFromStorage() {
            const token = localStorage.getItem("token");
            const userString = localStorage.getItem("user");

            if (token && userString) {
                // Configura o token no cabeçalho do Axios para a validação
                api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
                
                try {
                    // Chama a rota de validação no PHP
                    const res = await api.get("/auth.php?action=validate");
                    
                    if (res.data.ok) {
                         // Se o PHP retornar ok, a sessão é válida
                         setUser(res.data.usuario || JSON.parse(userString)); 
                    } else {
                        // Se o PHP retornar 200, mas com erro de sessão (caso improvável)
                        logout(); 
                    }
                } catch (error) {
                    // Se a API retornar 401 (Token inválido/expirado)
                    console.error("Token expirado/inválido. Fazendo logout automático.", error);
                    logout();
                }
            }
            setLoading(false); // Termina o carregamento
        }
        
        loadUserFromStorage();
    }, []); // Executa apenas uma vez na montagem do componente

    // Se estiver carregando, mostra um componente de loading (opcional, mas recomendado)
    if (loading) {
        return <div>Carregando sessão...</div>; // Ou um spinner de carregamento
    }

    return (
        <AuthContext.Provider value={{ user, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}

// Observação: Você também precisará configurar o Axios ('../api/api.js') para incluir o token em todas as requisições após o login.