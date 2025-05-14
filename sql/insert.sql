USE policial_intervencao;

-- tbTipoCrime
INSERT INTO tipo_crime
(artigo, descricao)
SELECT DISTINCT
artigo_crime, descricao_crime
FROM planilha;

-- tbTipoOcorrencia
INSERT INTO tipo_ocorrencia
(descricao)
SELECT DISTINCT
descricao_crime
FROM planilha;

-- tbPessoa
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

-- tbEndereco
INSERT INTO endereco
(cep, logradouro, numero, bairro, estado, cidade, zona)
SELECT DISTINCT
cep, logradouro, numero_logradouro, bairro, estado, cidade, zona
FROM planilha;

-- tbInquerito
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
        ELSE STR_TO_DATE(data_inicio, '%d/%m/%Y')  -- Caso contrário, assume o formato MM/DD/YYYY
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

-- tbPolicial
INSERT INTO policial
(nome, matricula, departamento, cargo, status_servico, status_aposentadoria)
SELECT DISTINCT
nome_policial, matricula_policial, departamento_policial, cargo_policial, status_servico, status_aposentadoria
FROM planilha;

-- tbPessoaHistorico erro    
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
        WHEN pl.data_historico IS NULL 
             OR TRIM(pl.data_historico) = '' 
             OR pl.data_historico = 'NAO_INFORMADO'
        THEN '1900-01-01'
        WHEN pl.data_historico REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN STR_TO_DATE(pl.data_historico, '%d/%m/%Y')
        WHEN pl.data_historico REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN pl.data_historico
        ELSE '1900-01-01'
    END AS data_formatada,
    pl.sentenca
FROM planilha pl
JOIN pessoa p ON p.nome = pl.nome_vitima
JOIN tipo_crime tc ON tc.artigo = pl.artigo_crime
LIMIT 3010 OFFSET 0;

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
        WHEN pl.data_historico IS NULL 
             OR TRIM(pl.data_historico) = '' 
             OR pl.data_historico = 'NAO_INFORMADO'
        THEN '1900-01-01'
        WHEN pl.data_historico REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN STR_TO_DATE(pl.data_historico, '%d/%m/%Y')
        WHEN pl.data_historico REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN pl.data_historico
        ELSE '1900-01-01'
    END AS data_formatada,
    pl.sentenca
FROM planilha pl
JOIN pessoa p ON p.nome = pl.nome_vitima
JOIN tipo_crime tc ON tc.artigo = pl.artigo_crime
LIMIT 3010 OFFSET 3010;

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
        WHEN pl.data_historico IS NULL 
             OR TRIM(pl.data_historico) = '' 
             OR pl.data_historico = 'NAO_INFORMADO'
        THEN '1900-01-01'
        WHEN pl.data_historico REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN STR_TO_DATE(pl.data_historico, '%d/%m/%Y')
        WHEN pl.data_historico REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN pl.data_historico
        ELSE '1900-01-01'
    END AS data_formatada,
    pl.sentenca
FROM planilha pl
JOIN pessoa p ON p.nome = pl.nome_vitima
JOIN tipo_crime tc ON tc.artigo = pl.artigo_crime
LIMIT 3010 OFFSET 6020;

-- tbDelegacia
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

-- tbOcorrecia
INSERT INTO ocorrencia (
    data_hora_fato, 
    status_ocorrencia, 
    endereco_id, 
    inquerito_id, 
    delegacia_id
)
SELECT DISTINCT
    CASE 
        WHEN pl.data_hora_fato_ocorrencia = 'NAO_INFORMADO' 
             OR pl.data_hora_fato_ocorrencia = '' 
        THEN '1900-01-01 00:00:00'
        
        WHEN pl.data_hora_fato_ocorrencia REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN STR_TO_DATE(pl.data_hora_fato_ocorrencia, '%d/%m/%Y %H:%i:%s')

        WHEN pl.data_hora_fato_ocorrencia REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN pl.data_hora_fato_ocorrencia

        ELSE '1900-01-01 00:00:00'
    END AS data_hora_fato,
    status_ocorrencia, 
    e.id AS endereco_id, 
    i.id AS inquerito_id, 
    d.id AS delegacia_id
FROM planilha pl
INNER JOIN endereco e ON
    e.cep = pl.cep
INNER JOIN inquerito i ON
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN delegacia d ON
    d.seccional = pl.SECCIONAL_CIRCUNSCRICAO
LIMIT 3010 OFFSET 0;

INSERT INTO ocorrencia (
    data_hora_fato, 
    status_ocorrencia, 
    endereco_id, 
    inquerito_id, 
    delegacia_id
)
SELECT DISTINCT
    CASE 
        WHEN pl.data_hora_fato_ocorrencia = 'NAO_INFORMADO' 
             OR pl.data_hora_fato_ocorrencia = '' 
        THEN '1900-01-01 00:00:00'
        
        WHEN pl.data_hora_fato_ocorrencia REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN STR_TO_DATE(pl.data_hora_fato_ocorrencia, '%d/%m/%Y %H:%i:%s')

        WHEN pl.data_hora_fato_ocorrencia REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN pl.data_hora_fato_ocorrencia

        ELSE '1900-01-01 00:00:00'
    END AS data_hora_fato,
    status_ocorrencia, 
    e.id AS endereco_id, 
    i.id AS inquerito_id, 
    d.id AS delegacia_id
FROM planilha pl
INNER JOIN endereco e ON
    e.cep = pl.cep
INNER JOIN inquerito i ON
    i.numero_inquerito = pl.numero_inquerito
INNER JOIN delegacia d ON
    d.seccional = pl.SECCIONAL_CIRCUNSCRICAO
LIMIT 6100 OFFSET 3010;
    
-- tabela ocorrencia_pessoa
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
    o.inquerito_id = i.id
LIMIT 10 OFFSET 0;
    
-- tabela ocorrencia_tipo_crime
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
    o.inquerito_id = i.id
LIMIT 10 OFFSET 0;

-- tabela ocorrencia_policial
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
    

