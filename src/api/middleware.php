<?php
// middleware.php - Verifica o Token de Autorização em TODAS as requisições

/**
 * Função simples de validação de token.
 * EM PRODUÇÃO, esta função deveria validar um JWT (JSON Web Token)
 * e o token deveria ser armazenado em uma tabela de Sessões para ser revogado.
 * * Por enquanto, apenas checa se o token existe e, opcionalmente, busca o usuário.
 *
 * @param PDO $pdo Objeto de conexão PDO.
 * @return array Retorna o array de dados do usuário autenticado.
 */
function validarToken($pdo) {
    // 1. Pega o token do cabeçalho 'Authorization' (padrão Bearer)
    $headers = getallheaders();
    $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
    
    // Espera-se "Bearer [token_sha256]"
    if (!preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
        http_response_code(401);
        echo json_encode(["erro" => "Token de Autorização ausente ou mal formatado."]);
        exit;
    }
    
    $token = $matches[1];
    
    // 2. Aqui você faria a validação real (ex: Decodificar o JWT ou buscar na tabela de sessões)
    // Para simplificar, neste modelo estamos APENAS verificando se o token existe.
    
    // Simulação: se o token fosse real, você buscaria o usuário no banco
    // através de uma tabela de sessões onde o token estaria registrado.
    
    // **Ajuste para seu ambiente:** Crie uma tabela de sessões e valide o token nela.
    
    // Se a validação falhar:
    // http_response_code(401);
    // echo json_encode(["erro" => "Token inválido ou expirado."]);
    // exit;
    
    // 3. Se for válido, retorna os dados do usuário para uso nos scripts
    // Simulação dos dados do usuário (em uma API real, viriam da busca do token)
    return [
        'id_usuario' => 1, // Exemplo: Substituir pelo ID real obtido via token
        'nome' => 'Usuário Autenticado',
        'perfil' => 'MEDICO'
    ]; 
}