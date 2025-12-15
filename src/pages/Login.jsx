import { useContext, useState } from "react";
import { AuthContext } from "../auth/AuthContext";

export default function Login() {
  const { login } = useContext(AuthContext);
  const [form, setForm] = useState({ login: "", senha: "" });

  return (
    <div>
      <h2>Login</h2>
      <input placeholder="Login"
        onChange={e => setForm({ ...form, login: e.target.value })}
      />
      <input type="password" placeholder="Senha"
        onChange={e => setForm({ ...form, senha: e.target.value })}
      />
      <button onClick={() => login(form.login, form.senha)}>
        Entrar
      </button>
    </div>
  );
}
