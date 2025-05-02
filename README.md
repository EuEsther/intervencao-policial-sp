# Sistema de Análise de Intervenções Policiais em SP

Este projeto visa analisar e gerar dados relacionados a intervenções policiais no estado de São Paulo, utilizando dados fictícios para simulação e testes. A partir de dados gerados, o sistema permite realizar análises e criar relatórios sobre o impacto das ações policiais.

## ⚙️ Funcionalidades

- Geração de Dados Fictícios: Utiliza o pacote Faker para criar dados simulados sobre intervenções policiais, incluindo informações sobre ocorrências e inquéritos.
- CSV Limpo: Geração de um arquivo CSV limpo contendo dados fictícios prontos para análise.
- Dependências: Contém todas as dependências necessárias para rodar o projeto, incluindo bibliotecas como Pandas, SQLAlchemy e Faker.

## 🚀 Instalação

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

5. Para criar o esquema do banco de dados, execute o script SQL schema.sql no seu banco de dados preferido (exemplo: MySQL, PostgreSQL ou SQLite).

## 🛠️ Tecnologias 

- Python: Linguagem de programação principal.
- Pandas: Para manipulação e análise de dados.
- Faker: Para geração de dados fictícios.

## 🤝 Contribuições

Sinta-se à vontade para contribuir com melhorias ou sugestões! Abra uma issue ou faça um pull request.
___

### 📜 Licença

Este projeto está licenciado sob a [MIT License](LICENSE). Consulte o arquivo `LICENSE` para mais detalhes.

