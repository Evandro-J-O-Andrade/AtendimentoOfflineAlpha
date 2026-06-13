import { useMemo } from "react";
import { RefreshCw, Star } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { PortalModuleCard } from "../components/PortalModuleCard";
import { usePortalModules } from "../hooks/usePortalModules";
import { getPortalBranding } from "../services/branding";
import type { PortalModule } from "../types";

export default function PortalHomePage() {
    const navigate = useNavigate();
    const { modules, loading, error } = usePortalModules();
    const brand = getPortalBranding();

    const favorites = modules.filter(m => m.favorite);
    const groupedModules = useMemo(() => {
        return {
            operacional: modules.filter(m => m.category === 'operacional'),
            corporativo: modules.filter(m => m.category === 'corporativo'),
            gestao: modules.filter(m => m.category === 'gestao'),
            activeCount: modules.filter(m => m.active).length,
        };
    }, [modules]);

    function openModule(module: PortalModule) {
        if (!module.path) return;
        navigate(module.path);
    }

    return (
        <main className="portal-page">
            <section className="portal-intro" aria-labelledby="portal-title">
                <div>
                    <p className="portal-eyebrow">{brand.companyName}</p>
                    <h1 id="portal-title">{brand.productName}</h1>
                    <p className="portal-subtitle">
                        Bem-vindo ao seu ecossistema de trabalho. Todas as ferramentas autorizadas estão disponíveis abaixo.
                    </p>
                </div>

                <div className="portal-summary">
                    <span>
                        <strong>{groupedModules.activeCount}</strong>
                        Ativos
                    </span>
                </div>
            </section>

            {loading && (
                <div className="portal-loading">
                    <RefreshCw className="animate-spin" size={20} />
                    <span>Sincronizando módulos...</span>
                </div>
            )}

            {!loading && error && (
                <div className="portal-error">
                    <RefreshCw size={18} />
                    <p>{error}</p>
                </div>
            )}

            {!loading && !error && (
                <div className="space-y-10">
                    {favorites.length > 0 && (
                        <section aria-labelledby="cat-favorites">
                            <div className="portal-section-divider">
                                <span id="cat-favorites">
                                    <Star size={16} className="inline mr-1" />
                                    Favoritos
                                </span>
                            </div>
                            <div className="portal-module-grid">
                                {favorites.map((module) => (
                                    <PortalModuleCard key={module.id} module={module} onOpen={openModule} />
                                ))}
                            </div>
                        </section>
                    )}

                    {groupedModules.operacional.length > 0 && (
                        <section aria-labelledby="cat-operacional">
                            <div className="portal-section-divider">
                                <span id="cat-operacional">Operacional</span>
                            </div>
                            <div className="portal-module-grid">
                                {groupedModules.operacional.map((module) => (
                                    <PortalModuleCard key={module.id} module={module} onOpen={openModule} />
                                ))}
                            </div>
                        </section>
                    )}

                    {groupedModules.corporativo.length > 0 && (
                        <section aria-labelledby="cat-corporativo">
                            <div className="portal-section-divider">
                                <span id="cat-corporativo">Corporativo</span>
                            </div>
                            <div className="portal-module-grid">
                                {groupedModules.corporativo.map((module) => (
                                    <PortalModuleCard key={module.id} module={module} onOpen={openModule} />
                                ))}
                            </div>
                        </section>
                    )}

                    {groupedModules.gestao.length > 0 && (
                        <section aria-labelledby="cat-gestao">
                            <div className="portal-section-divider">
                                <span id="cat-gestao">Gestão</span>
                            </div>
                            <div className="portal-module-grid">
                                {groupedModules.gestao.map((module) => (
                                    <PortalModuleCard key={module.id} module={module} onOpen={openModule} />
                                ))}
                            </div>
                        </section>
                    )}
                </div>
            )}
        </main>
    );
}