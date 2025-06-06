USE policial_intervencao;

-- tbTipoCrime, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO tipo_crime
(artigo, descricao)
SELECT DISTINCT
artigo_crime, descricao_crime
FROM planilha;

-- tbTipoOcorrencia, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO tipo_ocorrencia
(descricao)
SELECT DISTINCT
descricao_crime
FROM planilha;

-- tbPessoa, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO pessoa (
    nome, 
    data_nascimento, 
    genero, 
    profissao, 
    cor_pele
)
SELECT DISTINCT
    CASE 
        WHEN nome_vitima = 'NAO_INFORMADO' THEN 'DESCONHECIDO'
        ELSE nome_vitima
    END,
    
    CASE 
        WHEN data_nascimento_pessoa = 'NAO_INFORMADO' 
             OR data_nascimento_pessoa NOT LIKE '%/%'  -- Verifica se o valor tem o formato esperado (ex: YYYY/MM/DD)
        THEN '1900-01-01'
        ELSE STR_TO_DATE(data_nascimento_pessoa, '%d/%m/%Y')
    END,
    
    CASE 
        WHEN sexo_pessoa = 'NAO_INFORMADO' THEN 'IGN'
        ELSE sexo_pessoa
    END,
    
    CASE 
        WHEN profissao = 'NAO_INFORMADO' THEN 'DESCONHECIDO'
        ELSE profissao
    END,
    
    CASE 
        WHEN cor_pele = 'NAO_INFORMADO' THEN 'IGNORADA'
        ELSE cor_pele
    END
FROM planilha;



-- tbEndereco, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO endereco
(cep, logradouro, numero, bairro, estado, cidade, zona)
SELECT DISTINCT
cep, logradouro, numero_logradouro, bairro, estado, cidade, zona
FROM planilha;

-- tbInquerito, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO inquerito (
    numero_inquerito, 
    status, 
    data_inicio, 
    data_conclusao, 
    observacoes
)
SELECT DISTINCT
    numero_inquerito, 
    CASE 
        WHEN status_inquerito = 'NAO_INFORMADO' THEN 'DESCONHECIDO'
        ELSE status_inquerito
    END, 
    
    CASE 
        WHEN data_inicio = 'NAO_INFORMADO' OR data_inicio = '' THEN '01/01/1900'
        WHEN data_inicio LIKE '%-%-%' THEN STR_TO_DATE(data_inicio, '%Y-%m-%d')  -- Se estiver no formato YYYY-MM-DD
        ELSE STR_TO_DATE(data_inicio, '%d/%m/%Y')  -- Caso contrário, assume o formato DD/MM/YYYY
    END,
    
    CASE 
        WHEN data_conclusao = 'NAO_INFORMADO' OR data_conclusao = '' THEN '01/01/1900'
        WHEN data_conclusao LIKE '%-%-%' THEN STR_TO_DATE(data_conclusao, '%Y-%m-%d')  -- Se estiver no formato YYYY-MM-DD
        ELSE STR_TO_DATE(data_conclusao, '%d/%m/%Y')  -- Caso contrário, assume o formato DD/MM/YYYY
    END,

    CASE 
        WHEN observacoes = 'NAO_INFORMADO' THEN 'Sem observações'
        ELSE observacoes
    END
FROM planilha;



-- tbPolicial, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO policial
(nome, matricula, departamento, cargo, status_servico, status_aposentadoria)
SELECT DISTINCT
nome_policial, matricula_policial, departamento_policial, cargo_policial, status_servico, status_aposentadoria
FROM planilha;

-- tbPessoaHistorico erro, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO pessoa_historico (
	pessoa_id, 
    tipo_crime_id, 
    data, 
    sentenca
)
SELECT DISTINCT
    p.id,
    tc.id,
    CASE 
        WHEN pl.data_historico = 'NAO_INFORMADO' OR pl.data_historico = '' THEN '1900-01-01'
        WHEN pl.data_historico LIKE '%/%/%' THEN STR_TO_DATE(pl.data_historico, '%d/%m/%Y') -- Formato DD/MM/YYYY
        WHEN pl.data_historico LIKE '%-%-%' THEN STR_TO_DATE(pl.data_historico, '%Y-%m-%d') -- Formato YYYY-MM-DD
        ELSE '1900-01-01' -- Data padrão caso o formato não seja reconhecido
    END,
    pl.sentenca
FROM planilha pl
INNER JOIN pessoa p ON 
    p.nome = pl.nome_vitima
INNER JOIN tipo_crime tc ON 
    tc.artigo = pl.artigo_crime
-- LIMIT 3010 OFFSET 0;
LIMIT 6050 OFFSET 3010;


-- tbDelegacia, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO delegacia (endereco_id, seccional)
SELECT DISTINCT
  e.id,
  SECCIONAL_CIRCUNSCRICAO
FROM planilha pl
INNER JOIN endereco e ON
	e.cep = pl.cep AND
	e.logradouro = pl.logradouro AND
    e.numero = pl.numero_logradouro AND
    e.bairro = pl.bairro AND
    e.estado = pl.estado AND
    e.cidade = pl.cidade AND
    e.zona = pl.zona;

-- tbOcorrecia, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO ocorrencia (
    data_hora_fato, 
    status_ocorrencia, 
    endereco_id, 
    inquerito_id, 
    delegacia_id
)
SELECT DISTINCT
    CASE 
        WHEN pl.data_hora_fato_ocorrencia = 'NAO_INFORMADO' OR pl.data_hora_fato_ocorrencia = '' THEN '1900-01-01 00:00:00'
        WHEN pl.data_hora_fato_ocorrencia LIKE '%/%/%' THEN STR_TO_DATE(pl.data_hora_fato_ocorrencia, '%d/%m/%Y %H:%i:%s') -- Caso o formato seja DD/MM/YYYY HH:MM:SS
        WHEN pl.data_hora_fato_ocorrencia LIKE '%-%-%' THEN STR_TO_DATE(pl.data_hora_fato_ocorrencia, '%Y-%m-%d %H:%i:%s') -- Caso a data esteja no formato YYYY-MM-DD HH:MM:SS
        ELSE '1900-01-01 00:00:00' -- Data padrão para casos não identificados ou inválidos
    END AS data_hora_fato,
    status_ocorrencia, 
    e.id AS endereco_id, 
    i.id AS inquerito_id, 
    d.id AS delegacia_id
FROM planilha pl
INNER JOIN endereco e ON
    e.cep = pl.cep AND
    e.logradouro = pl.logradouro AND
    e.numero = pl.numero_logradouro AND
    e.bairro = pl.bairro AND
    e.estado = pl.estado AND
    e.cidade = pl.cidade AND
    e.zona = pl.zona
INNER JOIN inquerito i ON
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN delegacia d ON
    d.seccional = pl.SECCIONAL_CIRCUNSCRICAO
-- LIMIT 3010 OFFSET 0;
LIMIT 6050 OFFSET 3010;
    
-- tabela ocorrencia_pessoa, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO ocorrencia_pessoa (
    ocorrencia_id, 
    pessoa_id, 
    papel
)
SELECT DISTINCT
    o.id,
    p.id,
    pl.papel
FROM planilha pl
INNER JOIN pessoa p ON 
    p.nome = pl.nome_vitima
INNER JOIN inquerito i ON 
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN ocorrencia o ON 
    o.inquerito_id = i.id;
    
-- tabela ocorrencia_tipo_crime, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO ocorrencia_tipo_crime (
    ocorrencia_id, 
    tipo_crime_id
)
SELECT DISTINCT
    o.id,
    tc.id
FROM planilha pl
INNER JOIN tipo_crime tc ON 
    tc.artigo = pl.artigo_crime
INNER JOIN inquerito i ON 
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN ocorrencia o ON 
    o.inquerito_id = i.id;
-- LIMIT 3010 OFFSET 0;
-- LIMIT 6050 OFFSET 3010;

-- tabela ocorrecia_tipo_ocorrencia, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario)
INSERT INTO ocorrencia_tipo_ocorrencia (
    ocorrencia_id, 
    tipo_ocorrencia_id
)
SELECT DISTINCT
    o.id,
    tp.id
FROM planilha pl
INNER JOIN tipo_ocorrencia tp ON 
    tp.descricao = pl.descricao_crime
INNER JOIN inquerito i ON 
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN ocorrencia o ON 
    o.inquerito_id = i.id;
    
-- tabela ocorrencia_policial, rodar LIMIT 3010 OFFSET 0 e LIMIT 6050 OFFSET 3010 (se necessario) 
INSERT INTO ocorrencia_policial (
    ocorrencia_id, 
    policial_id
)
SELECT
    o.id,
    p.id
FROM planilha pl
INNER JOIN policial p ON 
    p.matricula = pl.matricula_policial
INNER JOIN inquerito i ON 
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN ocorrencia o ON 
    o.inquerito_id = i.id;
