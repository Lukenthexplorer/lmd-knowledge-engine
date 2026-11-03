# Knowledge Engine: Livros do Goodreads

Projeto individual de Lógica e Matemática Discreta (Insper).
Base de conhecimento em Prolog gerada a partir de um dataset do Kaggle por um ETL em Python.

## Dataset

[Goodreads Books](https://www.kaggle.com/datasets/jealousleopard/goodreadsbooks) (Kaggle). Cada linha é um livro, cerca de 11 mil no total.

Cada livro vira um fato:

```prolog
livro(Titulo, Autor, Idioma, Nota, Paginas, Avaliacoes, Ano, Editora).
```

| Campo | Tipo | Exemplo |
|---|---|---|
| Titulo | texto | `'The Hobbit'` |
| Autor | texto | `'J.R.R. Tolkien'` |
| Idioma | texto | `'eng'` |
| Nota | número | `4.27` |
| Paginas | número | `366` |
| Avaliacoes | número | `2530894` |
| Ano | número | `2002` |
| Editora | texto | `'Houghton Mifflin'` |

## Estrutura

- `data/books.csv`: dataset original
- `etl.py`: lê o CSV e gera a base de fatos
- `livros.pl`: base de fatos gerada (cerca de 11 mil fatos)
- `regras.pl`: regras e as 3 perguntas

## ETL (etl.py)

Tratamentos feitos no CSV:
- Linhas com vírgulas a mais são descartadas (`on_bad_lines="skip"`).
- Livros com vários autores (`Autor A/Autor B`) ficam só com o primeiro autor.
- A data (`9/16/2006`) vira só o ano (`2006`).
- Livros sem nenhuma avaliação são removidos, porque têm nota 0 e distorceriam as médias.
- Aspas simples e barras nos textos são escapadas para gerar átomos Prolog válidos.

## Como rodar

Requisitos: Python 3 com pandas, e [SWI-Prolog](https://www.swi-prolog.org/).

```bash
pip install pandas
python etl.py        # gera o livros.pl
swipl regras.pl      # carrega a base e as regras
```

No prompt do Prolog:

```prolog
?- top10_autores(T).
?- ranking_paginas_idioma(R).
?- top10_destaques(T).
```

## Perguntas

### 1. Quais são os 10 autores com maior nota média?

Só entram autores com pelo menos 3 livros, para que um autor com um único livro de nota 5.0 não fique em primeiro.

```prolog
?- top10_autores(T).
```

| # | Autor | Nota média |
|---|---|---|
| 1 | Bill Watterson | 4.71 |
| 2 | Hiromu Arakawa | 4.55 |
| 3 | Hayao Miyazaki | 4.55 |
| 4 | J.K. Rowling | 4.52 |
| 5 | Joseph Frank | 4.50 |
| 6 | Cook's Illustrated Magazine | 4.48 |
| 7 | Chie Shinohara | 4.45 |
| 8 | Kyoko Hikawa | 4.44 |
| 9 | David R. Hawkins | 4.43 |
| 10 | James Herriot | 4.42 |

### 2. Quais idiomas têm os livros mais longos?

Ranking dos idiomas pela média de páginas. Só entram idiomas com pelo menos 10 livros.

```prolog
?- ranking_paginas_idioma(R).
```

| # | Idioma | Média de páginas |
|---|---|---|
| 1 | mul (vários idiomas) | 437 |
| 2 | ger (alemão) | 394 |
| 3 | spa (espanhol) | 368 |
| 4 | fre (francês) | 342 |
| 5 | eng (inglês) | 337 |
| 6 | en-US | 330 |
| 7 | zho (chinês) | 322 |
| 8 | en-GB | 316 |
| 9 | por (português) | 220 |
| 10 | jpn (japonês) | 191 |

### 3. Quais são os 10 livros mais avaliados entre os que têm nota acima da média geral?

A média geral de todos os livros é 3.94. A regra filtra os livros com nota acima dela e com mais de 10 mil avaliações, depois ordena pelo número de avaliações.

```prolog
?- top10_destaques(T).
```

| # | Livro | Avaliações |
|---|---|---|
| 1 | The Hobbit | 2.530.894 |
| 2 | Harry Potter and the Prisoner of Azkaban | 2.339.585 |
| 3 | Harry Potter and the Chamber of Secrets | 2.293.963 |
| 4 | Harry Potter and the Order of the Phoenix | 2.153.167 |
| 5 | The Fellowship of the Ring | 2.128.944 |
| 6 | Harry Potter and the Half-Blood Prince | 2.095.690 |
| 7 | The Lightning Thief | 1.766.725 |
| 8 | The Giver | 1.585.589 |
| 9 | The Book Thief | 1.516.367 |
| 10 | Little Women | 1.479.727 |