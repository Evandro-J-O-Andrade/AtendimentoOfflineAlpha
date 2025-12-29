import React, { useEffect, useState, useContext } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../../services/api'
import { AuthContext } from '../../context/AuthContext'
import './AdminUsers.css'

export default function AdminUsers() {
  const { user, isAdmin, hasPerfil } = useContext(AuthContext)
  const navigate = useNavigate()
  const [usuarios, setUsuarios] = useState([])
  const [perfis, setPerfis] = useState([])
  const [loading, setLoading] = useState(false)
  const [form, setForm] = useState({ login: '', nome: '', cpf: '', senha: '', id_perfis: [] })
  const [error, setError] = useState(null)
  const [message, setMessage] = useState(null)
  const [search, setSearch] = useState('')

  // edição inline
  const [editId, setEditId] = useState(null)
  const [editForm, setEditForm] = useState({ login: '', nome: '', id_perfis: [], senha: '' })

  useEffect(() => {
    if (!isAdmin() && !hasPerfil('SUPORTE')) return
    fetchPerfis()
    fetchUsuarios()
  }, [])

  async function fetchPerfis() {
    try {
      const res = await api.get('/perfil_lista.php')
      setPerfis(res.data || [])
    } catch (err) {
      console.error(err)
    }
  }

  async function fetchUsuarios() {
    setLoading(true)
    try {
      const res = await api.get('/usuario_listar.php')
      if (res.data && res.data.usuarios) setUsuarios(res.data.usuarios)
    } catch (err) {
      setError(err?.response?.data?.message || err.message)
    } finally {
      setLoading(false)
    }
  }

  function updateField(k, v) {
    setForm(prev => ({ ...prev, [k]: v }))
  }

  function updateEditField(k, v) {
    setEditForm(prev => ({ ...prev, [k]: v }))
  }

  async function criarUsuario(e) {
    e.preventDefault()
    setError(null)
    setMessage(null)

    try {
      const payload = {
        nome: form.nome,
        cpf: form.cpf,
        login: form.login,
        senha: form.senha,
        id_perfis: form.id_perfis
      }
      const res = await api.post('/usuario_criar.php', payload)
      if (res.data && res.data.ok) {
        setForm({ login: '', nome: '', cpf: '', senha: '', id_perfis: [] })
        setMessage('Usuário criado com sucesso')
        fetchUsuarios()
      }
    } catch (err) {
      setError(err?.response?.data?.erro || err?.response?.data?.message || err.message)
    }
  }

  async function saveEdit(id) {
    setError(null)
    setMessage(null)
    try {
      const payload = {
        id_usuario: id,
        login: editForm.login,
        nome: editForm.nome,
        id_perfis: editForm.id_perfis
      }
      if (editForm.senha && editForm.senha.trim() !== '') payload.senha = editForm.senha

      const res = await api.post('/usuario_atualizar.php', payload)
      if (res.data && res.data.ok) {
        setMessage('Usuário atualizado')
        setEditId(null)
        setEditForm({ login: '', nome: '', id_perfis: [], senha: '' })
        fetchUsuarios()
      }
    } catch (err) {
      setError(err?.response?.data?.message || err.message)
    }
  }

  async function toggleAtivo(u) {
    const action = u.ativo ? 'Desativar' : 'Ativar'
    if (!window.confirm(`${action} usuário ${u.login}?`)) return

    try {
      await api.post('/usuario_atualizar.php', { id_usuario: u.id_usuario, ativo: !u.ativo })
      setMessage(`${action} realizado`)
      fetchUsuarios()
    } catch (err) {
      setError(err?.response?.data?.message || err.message)
    }
  }

  function startEdit(u) {
    setEditId(u.id_usuario)
    setEditForm({ login: u.login || '', nome: u.nome_completo || '', id_perfis: u.perfis_ids || [], senha: '' })
  }

  function cancelEdit() {
    setEditId(null)
    setEditForm({ login: '', nome: '', id_perfil: '', senha: '' })
  }

  if (!isAdmin() && !hasPerfil('SUPORTE')) {
    return <div>Você não tem permissão para acessar esta página.</div>
  }

  const filtered = usuarios.filter(u => {
    if (!search) return true
    const s = search.toLowerCase()
    return (u.login || '').toLowerCase().includes(s) || (u.nome_completo || '').toLowerCase().includes(s) || ((u.perfis || []).join(', ') || '').toLowerCase().includes(s)
  })

  return (
    <div className="admin-users">
      <h1>Gestão de Usuários</h1>

      <section className="create">
        <h2>Criar Usuário</h2>
        <form onSubmit={criarUsuario}>
          <input placeholder="Nome" value={form.nome} onChange={e => updateField('nome', e.target.value)} required />
          <input placeholder="CPF" value={form.cpf} onChange={e => updateField('cpf', e.target.value)} />
          <input placeholder="Login" value={form.login} onChange={e => updateField('login', e.target.value)} required />
          <input placeholder="Senha inicial" value={form.senha} onChange={e => updateField('senha', e.target.value)} required />

          <select multiple value={form.id_perfis} onChange={e => updateField('id_perfis', Array.from(e.target.selectedOptions).map(o => o.value))} required>
            {perfis.map(p => (
              <option key={p.id_perfil || p.id} value={p.id_perfil || p.id}>{p.nome || p.nome}</option>
            ))}
          </select>

          <button type="submit">Criar</button>
        </form>
        {error && <div className="error">{error}</div>}
        {message && <div className="message">{message}</div>}
      </section>

      <hr />

      <section className="list">
        <h2>Usuários</h2>
        <div style={{ marginBottom: 12 }}>
          <input placeholder="Buscar por login, nome ou perfil" value={search} onChange={e => setSearch(e.target.value)} />
        </div>
        {loading ? (
          <div>Carregando...</div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Login</th>
                <th>Nome</th>
                <th>Perfis</th>
                <th>Ativo</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(u => (
                <tr key={u.id_usuario}>
                  <td>{u.id_usuario}</td>

                  {editId === u.id_usuario ? (
                    <>
                      <td><input value={editForm.login} onChange={e => updateEditField('login', e.target.value)} /></td>
                      <td><input value={editForm.nome} onChange={e => updateEditField('nome', e.target.value)} /></td>
                      <td>
                        <select multiple value={editForm.id_perfis} onChange={e => updateEditField('id_perfis', Array.from(e.target.selectedOptions).map(o => o.value))}>
                          {perfis.map(p => (
                            <option key={p.id_perfil || p.id} value={p.id_perfil || p.id}>{p.nome}</option>
                          ))}
                        </select>
                        <div style={{ marginTop: 6 }}>
                          <input placeholder="Nova senha (opcional)" type="password" value={editForm.senha} onChange={e => updateEditField('senha', e.target.value)} />
                        </div>
                      </td>
                      <td>{u.ativo ? 'Sim' : 'Não'}</td>
                      <td>
                        <button onClick={() => saveEdit(u.id_usuario)}>Salvar</button>
                        <button onClick={cancelEdit} style={{ marginLeft: 6 }}>Cancelar</button>
                      </td>
                    </>
                  ) : (
                    <>
                      <td>{u.login}</td>
                      <td>{u.nome_completo}</td>
                      <td>{(u.perfis || []).join(', ')}</td>
                      <td>{u.ativo ? 'Sim' : 'Não'}</td>
                      <td>
                        <button onClick={() => startEdit(u)}>Editar</button>
                        <button onClick={() => toggleAtivo(u)} style={{ marginLeft: 6 }}>{u.ativo ? 'Desativar' : 'Ativar'}</button>
                      </td>
                    </>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  )
}
