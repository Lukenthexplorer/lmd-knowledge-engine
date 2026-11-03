:- encoding(utf8).
:- consult('livros.pl').

% livro(Titulo, Autor, Idioma, Nota, Paginas, Avaliacoes, Ano, Editora)


% calcula a media de uma lista
media(Lista, Media) :-
    Lista \= [],
    sum_list(Lista, Soma),
    length(Lista, N),
    Media is Soma / N.

% pega os N primeiros da lista
primeiros(N, Lista, Primeiros) :-
    length(Primeiros, N),
    append(Primeiros, _, Lista).


% ---------- Pergunta 1 ----------
% top 10 autores com maior nota media (minimo 3 livros)

media_autor(Autor, Media) :-
    findall(Nota, livro(_, Autor, _, Nota, _, _, _, _), Notas),
    media(Notas, Media).

qtd_livros(Autor, N) :-
    findall(Titulo, livro(Titulo, Autor, _, _, _, _, _, _), Livros),
    length(Livros, N).

autor_elegivel(Autor, Media) :-
    findall(A, livro(_, A, _, _, _, _, _, _), Todos),
    sort(Todos, Autores),
    member(Autor, Autores),
    qtd_livros(Autor, N),
    N >= 3,
    media_autor(Autor, Media).

top10_autores(Top) :-
    findall(Media-Autor, autor_elegivel(Autor, Media), Pares),
    sort(0, @>=, Pares, Ordenado),
    primeiros(10, Ordenado, Top).


% ---------- Pergunta 2 ----------
% ranking dos idiomas pela media de paginas (minimo 10 livros)

media_paginas_idioma(Idioma, Media) :-
    findall(Paginas, livro(_, _, Idioma, _, Paginas, _, _, _), Lista),
    media(Lista, Media).

idioma_elegivel(Idioma, Media) :-
    findall(I, livro(_, _, I, _, _, _, _, _), Todos),
    sort(Todos, Idiomas),
    member(Idioma, Idiomas),
    findall(P, livro(_, _, Idioma, _, P, _, _, _), Lista),
    length(Lista, N),
    N >= 10,
    media_paginas_idioma(Idioma, Media).

ranking_paginas_idioma(Ranking) :-
    findall(Media-Idioma, idioma_elegivel(Idioma, Media), Pares),
    sort(0, @>=, Pares, Ranking).


% ---------- Pergunta 3 ----------
% top 10 livros mais avaliados com nota acima da media geral

media_geral(Media) :-
    findall(Nota, livro(_, _, _, Nota, _, _, _, _), Notas),
    media(Notas, Media).

livro_destaque(Titulo, Avaliacoes) :-
    media_geral(MediaGeral),
    livro(Titulo, _, _, Nota, _, Avaliacoes, _, _),
    Nota > MediaGeral,
    Avaliacoes > 10000.

top10_destaques(Top) :-
    findall(Avaliacoes-Titulo, livro_destaque(Titulo, Avaliacoes), Pares),
    sort(0, @>=, Pares, Ordenado),
    primeiros(10, Ordenado, Top).
