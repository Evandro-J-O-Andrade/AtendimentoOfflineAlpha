import { RuntimeAuthProvider } from "./apps/operacional/auth/RuntimeAuthContext";
import AppRouter from "./router";

function App() {
    return (
        <RuntimeAuthProvider>
            <AppRouter />
        </RuntimeAuthProvider>
    );
}

export default App;