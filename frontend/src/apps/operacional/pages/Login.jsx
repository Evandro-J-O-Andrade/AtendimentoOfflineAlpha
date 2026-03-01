import { useState } from "react";
import { useRuntimeAuth } from "../../auth/RuntimeAuthContext";

export default function Login() {

    const { setSession } = useRuntimeAuth();

    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    async function handleLogin(e) {
        e.preventDefault();

        try {

            const res = await fetch("/api/auth/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    username,
                    password
                })
            });

            const data = await res.json();

            if (data.token) {
                localStorage.setItem("runtime_token", data.token);

                setSession({
                    token: data.token
                });

                window.location.href = "/operacional";
            }

        } catch {
            alert("Erro ao realizar login");
        }
    }

    return (
        <form onSubmit={handleLogin}>
            <h2>Login Operacional</h2>

            <input
                placeholder="Usuário"
                value={username}
                onChange={e => setUsername(e.target.value)}
            />

            <input
                type="password"
                placeholder="Senha"
                value={password}
                onChange={e => setPassword(e.target.value)}
            />

            <button type="submit">
                Entrar
            </button>
        </form>
    );
}