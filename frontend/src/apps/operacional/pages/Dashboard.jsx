import Sidebar from "../../../components/Sidebar";

export default function Dashboard() {
    return (
        <div style={{display:'flex',minHeight:'100vh'}}>
            <Sidebar />
            <main style={{flex:1,padding:24}}>
                <h1>Painel Operacional</h1>
                <p>Bem-vindo ao painel. Use a barra lateral para navegar.</p>
            </main>
        </div>
    );
}