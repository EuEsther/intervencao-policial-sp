CREATE DATABASE IF NOT EXISTS policial_intervencao;
USE policial_intervencao;

-- Tabela Tipo_Ocorrencia
CREATE TABLE IF NOT EXISTS Tipo_Ocorrencia (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

-- Tabela Policial
CREATE TABLE IF NOT EXISTS Policial (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    status_servico VARCHAR(20) NOT NULL CHECK (status_servico IN ('serviço', 'folga')),
    status_aposentadoria VARCHAR(20) NOT NULL CHECK (status_aposentadoria IN ('ativo', 'aposentado'))
);

-- Tabela Tipo_Crime
CREATE TABLE IF NOT EXISTS Tipo_Crime (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    artigo VARCHAR(20) NOT NULL,
    descricao VARCHAR(255) NOT NULL
);

-- Tabela Endereco
CREATE TABLE IF NOT EXISTS Endereco (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    zona VARCHAR(20) CHECK (zona IN ('leste', 'norte', 'sul', 'oeste', 'centro'))
);

-- Tabela Delegacia
CREATE TABLE IF NOT EXISTS Delegacia (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    endereco_id INT NOT NULL,
    seccional VARCHAR(50) NOT NULL,
    FOREIGN KEY (endereco_id) REFERENCES Endereco(ID)
);

-- Tabela Inquerito
CREATE TABLE IF NOT EXISTS Inquerito (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    numero_inquerito VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL CHECK (status IN ('em andamento', 'concluído')),
    data_inicio DATE NOT NULL,
    data_conclusao DATE,
    observacoes TEXT NOT NULL
);

-- Tabela Pessoa
CREATE TABLE IF NOT EXISTS Pessoa (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20) NOT NULL CHECK (genero IN ('masculino', 'feminino', 'outro')),
    profissao VARCHAR(50) NOT NULL,
    cor_pele VARCHAR(20) CHECK (cor_pele IN ('Branca', 'Negra', 'Parda', 'Amarela', 'Indígena'))
);

-- Tabela Ocorrencia
CREATE TABLE IF NOT EXISTS Ocorrencia (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_fato TIMESTAMP NOT NULL,
    status_ocorrencia VARCHAR(30) NOT NULL CHECK (status_ocorrencia IN ('em_analise', 'encerrada', 'em_andamento')),
    policial_id INT NOT NULL,
    endereco_id INT NOT NULL,
    inquerito_id INT,
    delegacia_id INT NOT NULL,
    FOREIGN KEY (policial_id) REFERENCES Policial(ID),
    FOREIGN KEY (endereco_id) REFERENCES Endereco(ID),
    FOREIGN KEY (inquerito_id) REFERENCES Inquerito(ID),
    FOREIGN KEY (delegacia_id) REFERENCES Delegacia(ID)
);

-- Tabela Ocorrencia_Tipo_Ocorrencia
CREATE TABLE IF NOT EXISTS Ocorrencia_Tipo_Ocorrencia (
    ocorrencia_id INT NOT NULL,
    tipo_ocorrencia_id INT NOT NULL,
    PRIMARY KEY (ocorrencia_id, tipo_ocorrencia_id),
    FOREIGN KEY (ocorrencia_id) REFERENCES Ocorrencia(ID),
    FOREIGN KEY (tipo_ocorrencia_id) REFERENCES Tipo_Ocorrencia(ID)
);

-- Tabela Ocorrencia_Tipo_Crime
CREATE TABLE IF NOT EXISTS Ocorrencia_Tipo_Crime (
    ocorrencia_id INT NOT NULL,
    tipo_crime_id INT NOT NULL,
    PRIMARY KEY (ocorrencia_id, tipo_crime_id),
    FOREIGN KEY (ocorrencia_id) REFERENCES Ocorrencia(ID),
    FOREIGN KEY (tipo_crime_id) REFERENCES Tipo_Crime(ID)
);

-- Tabela Ocorrencia_Pessoa
CREATE TABLE IF NOT EXISTS Ocorrencia_Pessoa (
    ocorrencia_id INT NOT NULL,
    pessoa_id INT NOT NULL,
    papel VARCHAR(50) NOT NULL,
    PRIMARY KEY (ocorrencia_id, pessoa_id, papel),
    FOREIGN KEY (ocorrencia_id) REFERENCES Ocorrencia(ID),
    FOREIGN KEY (pessoa_id) REFERENCES Pessoa(ID)
);

-- Tabela Pessoa_Historico
CREATE TABLE IF NOT EXISTS Pessoa_Historico (
    pessoa_id INT NOT NULL,
    tipo_crime_id INT NOT NULL,
    data DATE NOT NULL,
    sentenca VARCHAR(255) NOT NULL,
    PRIMARY KEY (pessoa_id, tipo_crime_id, data),
    FOREIGN KEY (pessoa_id) REFERENCES Pessoa(ID),
    FOREIGN KEY (tipo_crime_id) REFERENCES Tipo_Crime(ID)
);