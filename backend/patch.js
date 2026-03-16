const fs=require('fs');
const path='src/auth/authController.js';
let t=fs.readFileSync(path,'utf8');
const old=`            try {
                const [spResult] = await conn.query(
                    "CALL sp_auth_criar_sessao(?, ?, ?, ?, ?, ?)",
                    [
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        id_perfil,
                        tokenRuntime,
                    ]
                );
                sessao = spResult?.[0]?.[0] || spResult?.[0] || null;
            } catch (err) {
                console.warn("sp_auth_criar_sessao falhou, fallback manual:", err.message);
                const expira = new Date(Date.now() + 8 * 60 * 60 * 1000);
                const uuidSessao = crypto.randomUUID();
                await conn.query(
                    `INSERT INTO sessao_usuario 
                        (uuid_sessao, id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, id_dispositivo, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo, revogado, criado_em)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(6), ?, 1, 0, NOW(6))`,
                    [
                        uuidSessao,
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        id_perfil,
                        id_dispositivo,
                        tokenRuntime,
                        ip,
                        userAgent,
                        expira,
                    ]
                );

                const [sessaoRows] = await conn.execute(
                    `SELECT id_sessao_usuario, token_jwt AS token_jwt, expira_em AS expiracao_em
                     FROM sessao_usuario
                     WHERE id_usuario = ?
                     ORDER BY id_sessao_usuario DESC
                     LIMIT 1`,
                    [user.id_usuario]
                );
                sessao = sessaoRows?.[0] || null;
            }
`;
const nw=`            try {
                const [spResult] = await conn.query(
                    "CALL sp_auth_criar_sessao(?, ?, ?, ?, ?, ?)",
                    [
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        id_perfil,
                        tokenRuntime,
                    ]
                );
                sessao = spResult?.[0]?.[0] || spResult?.[0] || null;
            } catch (err) {
                console.warn("sp_auth_criar_sessao falhou, fallback manual:", err.message);
                const expira = new Date(Date.now() + 8 * 60 * 60 * 1000);
                const uuidSessao = crypto.randomUUID();
                const inserir = async (perfilParaUsar) => {
                    await conn.query(
                        `INSERT INTO sessao_usuario 
                            (uuid_sessao, id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, id_dispositivo, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo, revogado, criado_em)
                         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(6), ?, 1, 0, NOW(6))`,
                        [
                            uuidSessao,
                            user.id_usuario,
                            id_sistema,
                            id_unidade,
                            id_local_operacional,
                            perfilParaUsar,
                            id_dispositivo,
                            tokenRuntime,
                            ip,
                            userAgent,
                            expira,
                        ]
                    );
                };

                try {
                    await inserir(id_perfil);
                } catch (fkErr) {
                    console.warn("Fallback sessao_usuario com id_perfil=1 (perfil ausente?)", fkErr.message);
                    await inserir(1);
                }

                const [sessaoRows] = await conn.execute(
                    `SELECT id_sessao_usuario, token_jwt AS token_jwt, expira_em AS expiracao_em
                     FROM sessao_usuario
                     WHERE id_usuario = ?
                     ORDER BY id_sessao_usuario DESC
                     LIMIT 1`,
                    [user.id_usuario]
                );
                sessao = sessaoRows?.[0] || null;
            }
`;
if(!t.includes(old)) { console.error('pattern not found'); process.exit(1);} 
t = t.replace(old,nw);
fs.writeFileSync(path,t);
"patched";
