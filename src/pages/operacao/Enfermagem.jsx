import React from "react";
import Header from "@/components/Header";
import Sidebar from "@/pages/Sidebar";

export default function Enfermagem() {
  return (
    <div className="enfermagem-page">
      <Header />
      <div className="content-wrapper">
        <Sidebar />
        <main className="main-content">
          <h2>Enfermagem</h2>
          <p>Este módulo ainda está em construção. O login, contexto e seleção de local já estão operacionais.</p>
        </main>
      </div>
    </div>
  );
}
