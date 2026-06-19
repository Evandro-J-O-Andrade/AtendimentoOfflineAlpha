-- Stage 100 - Core Schema
-- Pessoa, Usuário, Sessão, Sistema, Unidade, Local

CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_pessoa INT,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS sessao_usuario (
    id_sessao INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_perfil INT,
    data_login TIMESTAMP,
    data_logout TIMESTAMP,
    ativa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS sistema (
    id_sistema INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) UNIQUE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS unidade (
    id_unidade INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    endereco TEXT,
    ativa BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS local_operacional (
    id_local INT PRIMARY KEY AUTO_INCREMENT,
    id_unidade INT,
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(50),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
);