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