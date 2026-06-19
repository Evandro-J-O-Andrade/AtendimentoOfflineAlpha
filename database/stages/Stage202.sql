-- Stage 202 - Integration Schema
CREATE TABLE IF NOT EXISTS integracao (
    id_integracao INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE,
    configuracao JSON
);

CREATE TABLE IF NOT EXISTS integracao_credencial (
    id_credencial INT PRIMARY KEY AUTO_INCREMENT,
    id_integracao INT,
    nome VARCHAR(100),
    chave VARCHAR(255),
    valor TEXT,
    FOREIGN KEY (id_integracao) REFERENCES integracao(id_integracao)
);

CREATE TABLE IF NOT EXISTS webhook_entrada (
    id_webhook INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(500),
    evento VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS webhook_saida (
    id_saida INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(500),
    evento VARCHAR(100),
    payload JSON
);