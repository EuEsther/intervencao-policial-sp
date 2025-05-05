import pandas as pd
from faker import Faker
import random
import os

# Instanciando Faker para dados brasileiros
fake = Faker("pt_BR")

# Carregando a nova planilha original da SSP-SP
caminho_excel = os.path.join(os.path.dirname(__file__), "..", "data", "MDIP_2025.xlsx")
df = pd.read_excel(caminho_excel)

df.drop(
    columns=[col for col in ["LONGITUDE", "LATITUDE"] if col in df.columns],
    inplace=True,
)


# Função auxiliar para adicionar coluna com valores fictícios se ela não existir
def adicionar_coluna(coluna, gerador):
        if coluna not in df.columns:
            df[coluna] = [gerador() for _ in range(len(df))]
        else:
            df[coluna] = df[coluna].fillna(gerador())

# policial
adicionar_coluna("nome_policial", lambda: fake.name())
adicionar_coluna("matricula_policial", lambda: fake.bothify(text="####-#####"))
adicionar_coluna("departamento_policial", lambda: fake.city())
adicionar_coluna(
    "cargo_policial", lambda: random.choice(["soldado", "sargento", "tenente", "capitão"])
)
adicionar_coluna("status_servico", lambda: random.choice(["serviço", "folga"]))
adicionar_coluna("status_aposentadoria", lambda: random.choice(["ativo", "aposentado"]))

# vitima
adicionar_coluna("nome_vitima", lambda: fake.name())

# endereco
adicionar_coluna("bairro", lambda: fake.bairro())
adicionar_coluna("cidade", lambda: fake.city())
adicionar_coluna("estado", lambda: "SP")
adicionar_coluna("cep", lambda: fake.postcode())
adicionar_coluna(
    "zona", 
    lambda: random.choice(['leste', 'norte', 'sul', 'oeste', 'centro'])
)

# inquerito
adicionar_coluna("numero_inquerito", lambda: fake.unique.bothify(text="INQ#####"))
adicionar_coluna(
    "data_inicio",
    lambda: fake.date_between(start_date="-2y", end_date="today")
)
adicionar_coluna(
    "data_conclusao",
    lambda: fake.date_between(start_date="today", end_date="+2y")
)
adicionar_coluna(
    "status_inquerito",
    lambda: random.choice(["em andamento","concluído"])
)
adicionar_coluna("observacoes", lambda: fake.sentence(nb_words=20))

# tipo_ocorrencia
adicionar_coluna(
    "tipo_ocorrencia",
    lambda: random.choice(
        [
            "confronto",
            "abordagem",
            "denúncia",
            "operação policial",
            "patrulhamento",
            "resgate",
            "mandado de prisão",
            "mandado de busca",
            "perseguição",
            "prisão em flagrante",
            "ação preventiva",
            "acompanhamento tático",
            "incursão em área de risco",
            "atendimento de emergência",
            "uso de força letal",
            "uso de arma não letal",
            "intervenção em manifestação",
            "apreensão de armas",
            "apreensão de drogas",
            "blitz de rotina",
            "intervenção em briga de rua",
            "requisição da justiça",
            "vigilância velada",
            "ações com helicóptero",
            "cerco policial",
            "contenção de tumulto",
            "operações integradas com GCM",
            "operação com cães farejadores",
            "tentativa de abordagem frustrada",
            "resposta a chamado de 190",
        ]
    ),
)

# tipo crime
adicionar_coluna(
    "artigo_crime",
    lambda: random.choice(
        [
            "121",
            "129",
            "157",
            "155",
            "33",
            "12",
            "147",
            "213",
            "331",
            "329",
            "331-A",
        ]
    ),
)
adicionar_coluna("descricao_crime", lambda: fake.sentence(nb_words=20))

# ocorrencia
adicionar_coluna("data_hora_fato_ocorrencia", lambda: fake.date_time_this_decade())
adicionar_coluna(
    "status_ocorrencia",
    lambda: random.choice(["em_analise", "encerrada", "em_andamento"])
)

# ocorrencia pessoal
adicionar_coluna("papel", lambda: random.choice(['vítima', 'suspeito', 'testemunha']))

# pessoa historico
adicionar_coluna("data_historico", lambda: fake.date_this_decade())
adicionar_coluna("sentenca", lambda: random.choice(['condenado', 'absolvido', 'aguardando julgamento']))

# converter datas
colunas_data = [
    "data_historico",
    "data_conclusao",
    "data_inicio"
]
for col in colunas_data:
    if col in df.columns:
        df[col] = pd.to_datetime(df[col]).dt.date


df.fillna("NAO_INFORMADO", inplace=True)

df.columns = [col.upper() for col in df.columns]

caminho_saida = os.path.join(os.path.dirname(__file__), "..", "data", "MDIP_2025_tratado.csv")
df.to_csv(caminho_saida, index=False, encoding="utf-8-sig")
print(f"Arquivo CSV gerado: {caminho_saida}")
