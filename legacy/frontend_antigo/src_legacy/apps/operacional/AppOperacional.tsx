import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";

export default function AppOperacional() {
    return (
        <Routes>
            <Route path="/" element={<div>Dashboard</div>} />
            <Route path="/contexto/*" element={<div>Contexto</div>} />
            <Route path="/runtime/:acao" element={<div>Runtime</div>} />
            <Route path="/recepcao/*" element={<div>Recepção</div>} />
            <Route path="/triagem/*" element={<div>Triagem</div>} />
            <Route path="/enfermagem/*" element={<div>Enfermagem</div>} />
            <Route path="/medico/*" element={<div>Médico</div>} />
            <Route path="/farmacia/*" element={<div>Farmácia</div>} />
            <Route path="/laboratorio/*" element={<div>Laboratório</div>} />
            <Route path="/internacao/*" element={<div>Internação</div>} />
            <Route path="/estoque/*" element={<div>Estoque</div>} />
            <Route path="*" element={<Navigate to="/" />} />
        </Routes>
    );
}