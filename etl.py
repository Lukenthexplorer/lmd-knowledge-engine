import pandas as pd

ENTRADA = "data/books.csv"
SAIDA = "livros.pl"


def atomo(texto):
    texto = str(texto).strip()
    texto = texto.replace("\\", "\\\\").replace("'", "\\'")
    return f"'{texto}'"


# Algumas linhas do CSV têm campos extras.
df = pd.read_csv(ENTRADA, on_bad_lines="skip")
df.columns = df.columns.str.strip()

df = df[[
    "title", "authors", "language_code", "average_rating",
    "num_pages", "ratings_count", "publication_date", "publisher"
]].dropna()

# Usa apenas o primeiro autor quando há mais de um.
df["authors"] = df["authors"].str.split("/").str[0]
df["ano"] = df["publication_date"].str.split("/").str[-1].astype(int)

df = df[df["ratings_count"] > 0]

with open(SAIDA, "w", encoding="utf-8") as arquivo:
    arquivo.write(":- encoding(utf8).\n")
    arquivo.write("% Base de livros do Goodreads\n")
    arquivo.write(
        "% livro(Titulo, Autor, Idioma, Nota, Paginas, Avaliacoes, Ano, Editora).\n\n"
    )

    for _, livro in df.iterrows():
        arquivo.write(
            f"livro({atomo(livro['title'])}, {atomo(livro['authors'])}, "
            f"{atomo(livro['language_code'])}, {float(livro['average_rating'])}, "
            f"{int(livro['num_pages'])}, {int(livro['ratings_count'])}, "
            f"{livro['ano']}, {atomo(livro['publisher'])}).\n"
        )

print(f"{len(df)} fatos gravados em {SAIDA}")