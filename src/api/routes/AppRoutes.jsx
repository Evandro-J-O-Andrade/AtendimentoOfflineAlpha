import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'

// Layouts
import BaseLayout from '@/layouts/BaseLayout'
import MedicoLayout from '@/layouts/MedicoLayout'
import RecepcaoLayout from '@/layouts/RecepcaoLayout'
import AdminLayout from '@/layouts/AdminLayout'

// Operação
import FilaAtendimento from '@/pages/operacao/FilaAtendimento'
import Recepcao from '@/pages/operacao/Recepcao'
import Triagem from '@/pages/operacao/Triagem'
import Enfermagem from '@/pages/operacao/Enfermagem'

// Painéis clínicos / Totem
import Clinico from '@/pages/painel/Clinico'
import Pediatrico from '@/pages/painel/Pediatrico'
import Totem from '@/pages/painel/Totem'
import RX from '@/pages/painel/RX'
import Satisfacao from '@/pages/painel/Satisfacao'
import Coleta from '@/pages/painel/Coleta'
import MedicacaoAdulta from '@/pages/painel/MedicacaoAdulta'
import MedicacaoInfantil from '@/pages/painel/MedicacaoInfantil'

export default function AppRoutes() {
    return (
        <Router>
            <Routes>

                {/* Redirecionamento raiz */}
                <Route path="/" element={<Navigate to="/recepcao" />} />

                {/* Painéis diretos */}
                <Route path="/painel/clinico" element={<Clinico />} />
                <Route path="/painel/pediatrico" element={<Pediatrico />} />
                <Route path="/painel/medicacao-adulta" element={<MedicacaoAdulta />} />
                <Route path="/painel/medicacao-infantil" element={<MedicacaoInfantil />} />
                <Route path="/painel/rx" element={<RX />} />
                <Route path="/painel/coleta" element={<Coleta />} />
                <Route path="/painel/satisfacao" element={<Satisfacao />} />
                <Route path="/painel/totem" element={<Totem />} />

                {/* Layouts operacionais */}
                <Route path="/recepcao/*" element={<RecepcaoLayout />}>
                    <Route path="" element={<Recepcao />} />
                    <Route path="fila" element={<FilaAtendimento />} />
                    <Route path="triagem" element={<Triagem />} />
                    <Route path="enfermagem" element={<Enfermagem />} />
                </Route>

                <Route path="/admin/*" element={<AdminLayout />}>
                    {/* Rotas administrativas */}
                </Route>

                <Route path="*" element={<div>Página não encontrada</div>} />
            </Routes>
        </Router>
    )
}
