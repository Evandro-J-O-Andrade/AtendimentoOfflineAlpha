-- Stage 201 - Social Schema
CREATE TABLE IF NOT EXISTS social_perfil (
    id_perfil INT PRIMARY KEY AUTO_INCREMENT,
    id_pessoa INT,
    bio TEXT,
    avatar_url VARCHAR(500),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS social_post (
    id_post INT PRIMARY KEY AUTO_INCREMENT,
    id_perfil INT,
    conteudo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_perfil) REFERENCES social_perfil(id_perfil)
);

CREATE TABLE IF NOT EXISTS social_grupo (
    id_grupo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    descricao TEXT
);

CREATE TABLE IF NOT EXISTS social_membro (
    id_membro INT PRIMARY KEY AUTO_INCREMENT,
    id_grupo INT,
    id_pessoa INT,
    papel VARCHAR(50),
    FOREIGN KEY (id_grupo) REFERENCES social_grupo(id_grupo),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);