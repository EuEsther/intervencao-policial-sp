USE	policial_intervencao;

show tables;

desc planilha;
desc tipo_crime;
desc tipo_ocorrencia;
desc pessoa;
desc endereco;
desc inquerito;
desc delegacia;
desc policial;
desc ocorrencia;
desc pessoa_historico;

select * from tipo_crime limit 10;
select * from tipo_ocorrencia limit 10;
select * from planilha limit 10;
select * from inquerito limit 10;
select * from endereco limit 10;
select * from pessoa limit 10;
select * from policial limit 10;
select * from delegacia limit 10;
select * from pessoa_historico limit 10;
select * from ocorrencia;

select data_nascimento_pessoa from planilha;
SELECT logradouro, cidade, COUNT(*) FROM endereco GROUP BY logradouro, cidade HAVING COUNT(*) > 1;

SELECT STR_TO_DATE(NULLIF(DATA_HISTORICO, ''), '%m/%d/%Y') FROM planilha;

SELECT
  pl.nome_vitima,
  p.id as pessoa_id,
  pl.artigo_crime,
  tc.id as crime_id
FROM planilha pl
LEFT JOIN pessoa p ON TRIM(LOWER(p.nome)) = TRIM(LOWER(pl.nome_vitima))
LEFT JOIN tipo_crime tc ON TRIM(LOWER(tc.artigo)) = TRIM(LOWER(pl.artigo_crime))
WHERE p.id IS NULL OR tc.id IS NULL;



 