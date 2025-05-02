# Sistema de Análise de Intervenções Policiais em SP

Este projeto visa analisar e gerar dados relacionados a intervenções policiais no estado de São Paulo, utilizando dados fictícios para simulação e testes. A partir de dados gerados, o sistema permite realizar análises e criar relatórios sobre o impacto das ações policiais.
___

## 🗃️ Dados utilizados neste projeto
- [Portal de Dados Abertos da SSP-SP](https://www.ssp.sp.gov.br/estatistica/consultas)

## ⚙️ Funcionalidades

- Geração de Dados Fictícios com Faker, simulando ocorrências e inquéritos policiais.
- CSV Limpo gerado automaticamente, pronto para análises e visualizações.
- Script SQL para criação do banco de dados com tabelas como Polícia, Ocorrência, Inquérito, etc.

## 🚀 Como Rodar o Projeto

1. Clone o repositório:
    ```bash
    git clone https://github.com/EuEsther/portfolio.git
    cd portfolio/analise-vendas

2. Crie um ambiente virtual (opcional, mas recomendado):
    ```bash
    python -m venv venv
    source venv/bin/activate  # Para Linux/macOS
    venv\Scripts\activate     # Para Windows

3. Instale as dependências do projeto:
    ```bash
    pip install -r requirements.txt

4. Para gerar os dados fictícios em CSV, rode o script `gerar_csv_limpo.py`:
    ```bash
    python scripts/gerar_csv_limpo.py

5. Para criar o esquema do banco de dados, execute o script SQL `create-database.sql` no seu banco de dados preferido (exemplo: MySQL, PostgreSQL ou SQLite).

## 🛠️ Tecnologias 

- Python: linguagem principal
- Pandas: manipulação de dados
- Faker: geração de dados fictícios

## 🤝 Contribuições

Sinta-se à vontade para contribuir com melhorias ou sugestões! Abra uma issue ou faça um pull request.
___

### 📜 Licença

Distribuído sob a [MIT License](LICENSE). Use, modifique e compartilhe como quiser.

