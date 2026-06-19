-- Stage 200 - Portal Schema
CREATE TABLE IF NOT EXISTS portal_noticia (
    id_noticia INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    conteudo TEXT,
    publicado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS portal_comunicado (
    id_comunicado INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    mensagem TEXT,
    prioridade VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS portal_calendario (
    id_evento INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    descricao TEXT,
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP
);

CREATE TABLE IF NOT EXISTS portal_documento (
    id_documento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    url VARCHAR(500),
    categoria VARCHAR(100)
);