import React, { useEffect, useState } from 'react'
import { useAuth } from '../../context/AuthContext'
import api from '../../services/api'
import './AdminUsers.css'

export default function AdminUsers() {
  const { user, loading, isAdmin, hasPerfil } = useAuth()
  const [usuarios, setUsuarios] = useState([])
  const [perfis, setPerfis] = useState([])
  const [search, setSearch] = useState('')
  const [editId, setEditId] = useState(null)
  const [editForm, setEditForm] = useState({ login: '', nome: '', id_perfis: [], senha: '' })

  // Aguardando user carregar
  useEffect(() => {
    if (!user) return
    if (!isAdmin() && !hasPerfil('SUPORTE')) return
    fetchPerfis()
    fetchUsuarios()
  }, [user])

  async function fetchPerfis() {
    try {
      const res = await api.get('/perfil_lista.php')
      setPerfis(res.data || [])
    } catch (err) { console.error(err) }
  }

  async function fetchUsuarios() {
    try {
      const res = await api.get('/usuario_listar.php')
      if (res.data && res.data.usuarios) setUsuarios(res.data.usuarios)
    } catch (err) { console.error(err) }
  }

  if (loading) return <div>Carregando...</div>
  if (!user) return <div>Carregando...</div>
  if (!isAdmin() && !hasPerfil('SUPORTE')) return <div>Você não tem permissão para acessar esta página.</div>

  const filtered = usuarios.filter(u => {
    if (!search) return true
    const s = search.toLowerCase()
    return (u.login || '').toLowerCase().includes(s) ||
           (u.nome_completo || '').toLowerCase().includes(s) ||
           ((u.perfis || []).join(', ') || '').toLowerCase().includes(s)
  })

  // ... resto do componente igual (form, tabela, edição inline)
  return (
    <div className="admin-users">
      <h1>Gestão de Usuários</h1>
      {/* ... formulário de criação e tabela */}
    </div>
  )
}
