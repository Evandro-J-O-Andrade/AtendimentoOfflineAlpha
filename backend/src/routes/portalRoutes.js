const express = require("express");
const pool = require("../config/database");
const authMiddleware = require("../auth/authMiddleware");

const router = express.Router();

const PORTAL_MODULES = [
    {
        id: "atendimento",
        name: "Atendimento",
        description: "Fluxos de atendimento, filas e registros operacionais.",
        icon: "ClipboardList",
        path: "/contexto?app=atendimento&redirect=/operacional/atendimento",
        active: true,
        requiresContext: true,
        accent: "blue",
        permissionKeys: ["ATENDIMENTO", "OPERACIONAL", "ASSISTENCIAL", "RECEPCAO", "TRIAGEM", "ENFERMAGEM", "MEDICO"],
        profileKeys: ["ATENDIMENTO", "RECEPCAO", "TRIAGEM", "ENFERMAGEM", "MEDICO", "OPERACIONAL"]
    },
    {
        id: "farmacia",
        name: "Farmácia",
        description: "Solicitações, dispensação e controle de medicamentos.",
        icon: "Pill",
        path: "/contexto?app=farmacia&redirect=/operacional/farmacia",
        active: true,
        requiresContext: true,
        accent: "emerald",
        permissionKeys: ["FARMACIA", "DISPENSACAO", "MEDICAMENTO"],
        profileKeys: ["FARMACIA", "FARMACEUTICO"]
    },
    {
        id: "estoque",
        name: "Estoque",
        description: "Movimentações, saldos e acompanhamento de materiais.",
        icon: "Boxes",
        path: "/contexto?app=estoque&redirect=/operacional/estoque",
        active: true,
        requiresContext: true,
        accent: "amber",
        permissionKeys: ["ESTOQUE", "MATERIAL", "EXECUTOR_ESTOQUE"],
        profileKeys: ["ESTOQUE", "MATERIAL"]
    },
    {
        id: "almoxarifado",
        name: "Almoxarifado",
        description: "Requisições internas, separação e distribuição de itens.",
        icon: "Warehouse",
        path: "/portal/almoxarifado",
        active: false,
        requiresContext: false,
        accent: "orange",
        permissionKeys: ["ALMOXARIFADO", "SUPRIMENTOS"],
        profileKeys: ["ALMOXARIFADO", "SUPRIMENTOS"]
    },
    {
        id: "gestao",
        name: "Gestão",
        description: "Indicadores, administração e visão consolidada da operação.",
        icon: "BarChart3",
        path: "/portal/gestao",
        active: true,
        requiresContext: false,
        accent: "violet",
        permissionKeys: ["GESTAO", "ADMIN", "DASHBOARD", "RELATORIO", "USUARIOS", "PERMISSOES"],
        profileKeys: ["GESTAO", "ADMIN", "COORDENADOR", "SUPERVISOR", "SUPORTE"]
    },
    {
        id: "intranet",
        name: "Intranet",
        description: "Feed, comunicados, eventos e publicações corporativas.",
        icon: "Newspaper",
        path: "/portal/intranet",
        active: false,
        requiresContext: false,
        accent: "cyan",
        permissionKeys: ["INTRANET", "COMUNICADOS", "CORPORATIVO"],
        profileKeys: ["INTRANET", "COMUNICACAO", "RH", "ADMIN"]
    },
    {
        id: "treinamentos",
        name: "Treinamentos",
        description: "Cursos, trilhas, certificados e histórico de capacitação.",
        icon: "GraduationCap",
        path: "/portal/treinamentos",
        active: false,
        requiresContext: false,
        accent: "indigo",
        permissionKeys: ["TREINAMENTOS", "CURSOS", "CAPACITACAO"],
        profileKeys: ["TREINAMENTOS", "RH", "ADMIN"]
    },
    {
        id: "documentos",
        name: "Documentos",
        description: "Gestão documental, versões, aprovações e pesquisa.",
        icon: "Files",
        path: "/portal/documentos",
        active: false,
        requiresContext: false,
        accent: "rose",
        permissionKeys: ["DOCUMENTOS", "GESTAO_DOCUMENTAL", "ARQUIVOS"],
        profileKeys: ["DOCUMENTOS", "QUALIDADE", "ADMIN"]
    },
    {
        id: "chamados",
        name: "Chamados",
        description: "Solicitações, suporte, acompanhamento e resolução.",
        icon: "LifeBuoy",
        path: "/portal/chamados",
        active: false,
        requiresContext: false,
        accent: "teal",
        permissionKeys: ["CHAMADOS", "HELPDESK", "SUPORTE"],
        profileKeys: ["CHAMADOS", "HELPDESK", "SUPORTE", "TI"]
    }
];

function normalize(value) {
    return String(value || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toUpperCase()
        .trim();
}

function isAdminProfile(profile) {
    const name = normalize(profile.nome || profile.perfil_nome);
    return Number(profile.id_perfil) === 42 || name.includes("ADMIN") || name.includes("SUPORTE") || name.includes("MASTER");
}

function matchesAnyToken(keys, tokens) {
    const normalizedTokens = tokens.map(normalize).filter(Boolean);
    return keys.some((key) => {
        const normalizedKey = normalize(key);
        return normalizedTokens.some((token) => token === normalizedKey || token.includes(normalizedKey));
    });
}

function toPublicModule(module) {
    const { permissionKeys, profileKeys, ...publicModule } = module;
    return {
        ...publicModule,
        status: module.active ? "active" : "inactive"
    };
}

async function getUserProfiles(idUsuario, reqUser) {
    const profiles = [];

    try {
        const [rows] = await pool.query(
            `SELECT up.id_perfil, p.nome
               FROM usuario_perfil up
               LEFT JOIN perfil p ON p.id_perfil = up.id_perfil
              WHERE up.id_usuario = ?`,
            [idUsuario]
        );
        profiles.push(...(rows || []));
    } catch (err) {
        console.warn("[portal] usuario_perfil indisponivel:", err.message);
    }

    if (!profiles.length) {
        try {
            const [rows] = await pool.query(
                `SELECT us.id_perfil, p.nome
                   FROM usuario_sistema us
                   LEFT JOIN perfil p ON p.id_perfil = us.id_perfil
                  WHERE us.id_usuario = ? AND us.ativo = 1`,
                [idUsuario]
            );
            profiles.push(...(rows || []));
        } catch (err) {
            console.warn("[portal] usuario_sistema indisponivel:", err.message);
        }
    }

    if (!profiles.length) {
        try {
            const [rows] = await pool.query(
                `SELECT uc.id_perfil, p.nome
                   FROM usuario_contexto uc
                   LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
                  WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                [idUsuario]
            );
            profiles.push(...(rows || []));
        } catch (err) {
            console.warn("[portal] usuario_contexto indisponivel:", err.message);
        }
    }

    if (!profiles.length && reqUser?.id_perfil) {
        profiles.push({ id_perfil: reqUser.id_perfil, nome: reqUser.perfil || null });
    }

    return profiles;
}

async function getProfilePermissions(profileIds) {
    if (!profileIds.length) return [];

    try {
        const placeholders = profileIds.map(() => "?").join(",");
        const [rows] = await pool.query(
            `SELECT DISTINCT p.codigo, p.acao_frontend, p.grupo_menu, p.nome
               FROM perfil_permissao pp
               JOIN permissao p ON p.id_permissao = pp.id_permissao
              WHERE pp.id_perfil IN (${placeholders})
                AND COALESCE(pp.ativo, 1) = 1
                AND COALESCE(p.ativo, 1) = 1`,
            profileIds
        );

        return rows || [];
    } catch (err) {
        console.warn("[portal] permissoes indisponiveis:", err.message);
        return [];
    }
}

router.get("/modules", authMiddleware, async (req, res) => {
    const idUsuario = req.user?.id_usuario;

    if (!idUsuario) {
        return res.status(401).json({ sucesso: false, erro: "USUARIO_NAO_AUTENTICADO" });
    }

    try {
        const profiles = await getUserProfiles(idUsuario, req.user);
        const profileIds = [...new Set(profiles.map((profile) => profile.id_perfil).filter(Boolean))];
        const permissions = await getProfilePermissions(profileIds);
        const hasFullAccess = profiles.some(isAdminProfile);

        const permissionTokens = permissions.flatMap((permission) => [
            permission.codigo,
            permission.acao_frontend,
            permission.grupo_menu,
            permission.nome
        ]);
        const profileTokens = profiles.flatMap((profile) => [profile.nome, profile.perfil_nome, profile.id_perfil]);

        const modules = PORTAL_MODULES
            .filter((module) => {
                if (hasFullAccess) return true;
                return (
                    matchesAnyToken(module.permissionKeys, permissionTokens) ||
                    matchesAnyToken(module.profileKeys, profileTokens)
                );
            })
            .map(toPublicModule);

        return res.json({
            sucesso: true,
            modules,
            total: modules.length
        });
    } catch (err) {
        console.error("[portal] erro ao listar modulos:", err.message);
        return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
    }
});

module.exports = router;
