import './Footer.css';
import { useState, useEffect } from 'react'
import { useAuth } from '@/context/AuthContext'
import SelectLocalModal from './SelectLocalModal'

export default function Footer() {
  const { localAtual, setLocal, user } = useAuth()
  const [open, setOpen] = useState(false)

  useEffect(() => {
    // abrir automaticamente após login caso não haja local selecionado
    if (user && !localAtual) {
      setOpen(true)
    }
  }, [user, localAtual])

  function handleSelect(local) {
    setLocal(local)
    setOpen(false)
  }

  return (
    <>
      <footer className="footer">
        <div className="footer-left">
          <div className="local-label">Local:</div>
          <div className="local-name">{localAtual ? localAtual.nome : 'Nenhum selecionado'}</div>
          <button className="change-local" onClick={() => setOpen(true)}>{localAtual ? 'Alterar' : 'Selecionar'}</button>
        </div>
        <div className="footer-right">© 2025 • Sistema Hospitalar</div>
      </footer>
      <SelectLocalModal open={open} onClose={() => setOpen(false)} onSelect={handleSelect} />
    </>
  );
}
