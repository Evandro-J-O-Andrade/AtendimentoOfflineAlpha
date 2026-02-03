-- scripts/create_refresh_tokens.sql
-- Cria a tabela para armazenar refresh tokens (hash) com rotação e revogação

CREATE TABLE IF NOT EXISTS usuario_refresh (
  id_refresh BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_usuario BIGINT UNSIGNED NOT NULL,
  token_hash CHAR(64) NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  revoked TINYINT(1) NOT NULL DEFAULT 0,
  user_agent VARCHAR(255) DEFAULT NULL,
  ip VARCHAR(45) DEFAULT NULL,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  UNIQUE KEY (token_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
