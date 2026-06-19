// Script para executar o seed do contexto admin
const mysql = require('mysql2/promise');

async function seedAdminContexto() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 10
    });

    try {
        // Primeiro verificar se o usuário existe
        const [users] = await pool.query(
            'SELECT id_usuario, login FROM usuario WHERE login = ?',
            ['evandro.andrade']
        );
        
        console.log('Usuários encontrados:', users);

        if (users.length === 0) {
            console.log('Usuário evandro.andrade não encontrado!');
            return;
        }

        const userId = users[0].id_usuario;

        // Verificar se já existe contexto
        const [contextos] = await pool.query(
            'SELECT * FROM usuario_contexto WHERE id_usuario = ?',
            [userId]
        );

        console.log('Contextos existentes:', contextos);

        if (contextos.length > 0) {
            console.log('Usuário já tem contexto!');
            return;
        }

        // Buscar unidade, local_operacional e perfil
        const [unidades] = await pool.query('SELECT id_unidade FROM unidade WHERE ativo = 1 LIMIT 1');
        const [locais] = await pool.query('SELECT id_local_operacional FROM local_operacional WHERE ativo = 1 LIMIT 1');
        const [perfis] = await pool.query('SELECT id_perfil FROM perfil WHERE nome LIKE ? LIMIT 1', ['%ADMIN%']);

        console.log('Unidade:', unidades);
        console.log('Local:', locais);
        console.log('Perfil:', perfis);

        if (unidades.length === 0 || locais.length === 0 || perfis.length === 0) {
            console.log('Faltam dados básicos (unidade, local ou perfil)!');
            return;
        }

        // Inserir contexto
        await pool.query(
            `INSERT INTO usuario_contexto 
            (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo) 
            VALUES (?, 1, ?, ?, ?, 1)`,
            [userId, unidades[0].id_unidade, locais[0].id_local_operacional, perfis[0].id_perfil]
        );

        console.log('Contexto criado com sucesso!');

        // Verificar resultado
        const [novosContextos] = await pool.query(
            'SELECT * FROM usuario_contexto WHERE id_usuario = ?',
            [userId]
        );
        console.log('Novos contextos:', novosContextos);

    } catch (error) {
        console.error('Erro:', error.message);
    } finally {
        await pool.end();
    }
}

seedAdminContexto();
