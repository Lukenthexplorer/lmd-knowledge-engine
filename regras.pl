:- encoding(utf8).
:- consult('livros.pl').




% Média das notas de um autor
media_autor(Autor, Media) :-
    findall(Nota, livro(_, Autor, _, Nota, _, _, _, _), Notas),
    Notas \= [],
    sum_list(Notas, Soma),
    length(Notas, N),
    Media is Soma / N.

% Quantidade de livros de um autor
qtd_livros(Autor, N) :-
    findall(Nota, livro(_, Autor, _, Nota, _, _, _, _), Notas),
    length(Notas, N).

% Autor com pelo menos 3 livros, e a média dele
autor_elegivel(Autor, Media) :-
    findall(A, livro(_, A, _, _, _, _, _, _), Todos),
    sort(Todos, Autores),
    member(Autor, Autores),
    qtd_livros(Autor, N),
    N >= 3,
    media_autor(Autor, Media).



% Pergunta 1: os 10 autores com maior nota média (mínimo de 3 livros)
top10_autores(Top) :-
    findall(Media-Autor, autor_elegivel(Autor, Media), Pares),
    sort(0, @>=, Pares, Ordenado),
    length(Top, 10),
    append(Top, _, Ordenado).


media_paginas_idioma(Idioma, Media) :-
    findall(Paginas, livro(_, _, Idioma, _, Paginas, _, _, _), Lista),
    Lista \= [],
    sum_list(Lista, Soma),
    length(Lista, N),
    Media is Soma / N.


% Pergunta 2: ranking de idiomas pela média de páginas (mínimo de 10 livros)
ranking_paginas_idioma(Ranking) :-
    findall(Media-Idioma, idioma_elegivel(Idioma, Media), Pares),
    sort(0, @>=, Pares, Ranking).

% Idioma com pelo menos 10 livros, e a média de páginas dele
idioma_elegivel(Idioma, Media) :-
    findall(I, livro(_, _, I, _, _, _, _, _), Todos),
    sort(Todos, Idiomas),
    member(Idioma, Idiomas),
    findall(P, livro(_, _, Idioma, _, P, _, _, _), Lista),
    length(Lista, N),
    N >= 10,
    media_paginas_idioma(Idioma, Media).

media_geral(Media) :-
    findall(Nota, livro(_, _, _, Nota, _, _, _, _), Notas),
    sum_list(Notas, Soma),
    length(Notas, N),
    Media is Soma / N.

livro_destaque(Titulo, Avaliacoes) :-
    media_geral(MediaGeral),
    livro(Titulo, _, _, Nota, _, Avaliacoes, _, _),
    Nota > MediaGeral,
    Avaliacoes > 10000.

% Pergunta 3: os 10 livros mais avaliados com nota acima da média geral
top10_destaques(Top) :-
    findall(Avaliacoes-Titulo, livro_destaque(Titulo, Avaliacoes), Pares),
    sort(0, @>=, Pares, Ordenado),
    length(Top, 10),
    append(Top, _, Ordenado).
