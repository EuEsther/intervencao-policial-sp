USE policial_intervencao;

-- tbTipoCrime
INSERT INTO tipo_crime
(artigo, descricao)
SELECT 
artigo_crime, descricao_crime
FROM planilha;

-- tbTipoOcorrencia
INSERT INTO tipo_ocorrencia
(descricao)
SELECT 
descricao_crime
FROM planilha;

-- tbPessoa
INSERT INTO pessoa
(nome, data_nascimento, genero, profissao, cor_pele)
SELECT 
nome_vitima, str_to_date(data_nascimento_pessoa, '%Y/%m/%d'), sexo_pessoa, profissao, cor_pele
FROM planilha;

-- tbEndereco
INSERT INTO endereco
(cep, logradouro, numero, bairro, estado, cidade, zona)
SELECT
cep, logradouro, numero_logradouro, bairro, estado, cidade, zona
FROM planilha;

-- tbInquerito
INSERT INTO inquerito
(numero_inquerito, status, data_inicio, data_conclusao, observacoes)
SELECT
numero_inquerito, status_inquerito, str_to_date(nullif(data_inicio, ''),'%m/%d/%Y'), str_to_date(nullif(data_conclusao, ''),'%m/%d/%Y'), observacoes
FROM planilha;

-- tbPolicial
INSERT INTO policial
(nome, matricula, departamento, cargo, status_servico, status_aposentadoria)
SELECT
nome_policial, matricula_policial, departamento_policial, cargo_policial, status_servico, status_aposentadoria
FROM planilha;

-- tbPessoaHistorico erro
INSERT INTO pessoa_historico
(pessoa_id, tipo_crime_id, data, sentenca)
SELECT
p.id,
tc.id,
str_to_date(data_historico, '%m/%d/%Y'),
sentenca
FROM planilha pl
INNER JOIN pessoa p ON 
	p.nome = pl.nome_vitima
INNER JOIN
	tipo_crime tc ON tc.artigo = pl.artigo_crime;

-- tbDelegacia
INSERT INTO delegacia (endereco_id, seccional)
SELECT
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

-- tbOcorrecia erro
INSERT INTO ocorrencia
(data_hora_fato, status_ocorrencia, policial_id, endereco_id, inquerito_id, delegacia_id)
SELECT distinct
	STR_TO_DATE(NULLIF(pl.data_hora_fato_ocorrencia, ''),'%m/%d/%Y %H:%i'),
    status_ocorrencia, 
    p.id,
    e.id, 
    i.id, 
    d.id
FROM planilha pl
INNER JOIN policial p ON
	p.matricula = pl.matricula_policial AND
    p.departamento = pl.departamento_policial AND 
    p.cargo = pl.cargo_policial AND 
    p.status_servico = pl.status_servico AND 
    p.status_aposentadoria = pl.status_aposentadoria
INNER JOIN endereco e ON
	e.cep = pl.cep AND
	e.logradouro = pl.logradouro AND
    e.numero = pl.numero_logradouro AND
    e.bairro = pl.bairro AND
    e.estado = pl.estado AND
    e.cidade = pl.cidade AND
    e.zona = pl.zona
INNER JOIN inquerito i ON
	i.numero_inquerito = pl.numero_inquerito AND
	i.status = pl.status_inquerito AND 
    i.data_inicio = pl.data_inicio AND
	i.data_conclusao = pl.data_conclusao AND
    i.observacoes = pl.observacoes
INNER JOIN delegacia d ON
	d.seccional = pl.SECCIONAL_CIRCUNSCRICAO;

select * from ocorrencia;
select * from delegacia limit 1000;
