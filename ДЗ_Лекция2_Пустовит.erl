-module(lesson2).
-export([last/1, but_last/1, element_at/2, len/1, reverse/1, is_palindrome/1, flatten/1, compress/1, pack/1, encode/1, encode_modified/1, decode_modified/1, decode/1, duplicate/1, replicate/2]).

% P01 (*) Знайти останній елемент списку:
last([]) -> nil;
last([H|[]]) -> H;
last([_|T]) -> last(T).

% P02 (*) Знайти два останні елементи списку:
but_last(Lst) when length(Lst) < 2 -> nil;	
but_last(Lst) -> 
	List_length=length(Lst),
	[element_at(Lst,List_length-2), element_at(Lst,List_length-1)].


% P03 (*) Знайти N-й елемент списку:
element_at([H | _], 0 ) -> H ;
element_at([_ | T], K ) -> element_at( T , K-1 ).

% P04 (*) Порахувати кількість елементів списку:
len(Lst) -> length(Lst).

% P05 (*) Перевернути список:
reverse(L) -> reverse(L,[]).

reverse([],R) -> R;
reverse([H|T],R) -> reverse(T,[H|R]). 

% P06 (*) Визначити, чи є список паліндромом:
is_palindrome(L) ->
	Reversed_L = reverse(L),
	Reversed_L == L.

% P07 (**) Вирівняти структуру із вкладеними списками:
flatten([]) -> [];
flatten([H|T]) -> flatten(H) ++ flatten(T);
flatten(H) -> [H].

% P08 (**) Видалити послідовно такі дублікати:
compress([])-> [];
compress([H|[]])-> [H];
compress([H|[H|T]])-> compress([H|T]);
compress([H|[H1|T]])-> [H|compress([H1|T])].

% P09 (**) Упакувати послідовно такі дублікати у вкладені списки:
pack([]) -> [];
pack([H|[]]) -> [H];
pack([[H|T1]|[H|T2]]) -> pack([[H|[H|T1]]|T2]);
pack([[H1|T1]|[H2|[]]]) -> [[H1|T1],[H2]];
pack([[H1|T1]|[H2|T2]]) -> [[H1|T1]|pack([H2|T2])];
pack([H|[H|T]])-> pack([[H,H]|T]);
pack([H1|[H2|T]])-> [[H1]|pack([H2|T])].

% P10 (**) Закодувати список за допомогою алгоритму RLE:
encode_list([]) -> [];
encode_list([[Count,Elem]|[Elem|[]]]) -> [[Count+1,Elem]];
encode_list([[Count,Elem]|[Elem|T]]) -> encode_list([[Count+1,Elem]|T]);
encode_list([[Count,Elem1]|[Elem2|[]]]) -> [[Count,Elem1]|[[1,Elem2]]];
encode_list([[Count,Elem1]|[Elem2|T]]) -> [[Count,Elem1]|encode_list([[1,Elem2]|T])];
encode_list([H|T]) -> encode_list([[1,H]|T]).

encode(L) -> [list_to_tuple(X) || X <- encode_list(L)].

% P11 (**) Закодувати список за допомогою модифікованого алгоритму RLE:
encode_list_modified([]) -> [];
encode_list_modified([[Count,Elem]|[Elem|[]]]) -> [[Count+1,Elem]];
encode_list_modified([[Count,Elem]|[Elem|T]]) -> encode_list_modified([[Count+1,Elem]|T]);
encode_list_modified([[Count,Elem1]|[Elem2|[]]]) -> [[Count,Elem1],Elem2];
encode_list_modified([[Count,Elem1]|[Elem2,Elem2|T]]) -> [[Count,Elem1]|encode_list_modified([[2,Elem2]|T])];
encode_list_modified([[Count,Elem1]|[Elem2|T]]) -> [[Count,Elem1]|encode_list_modified([Elem2|T])];
encode_list_modified([Elem1,Elem1|T]) -> encode_list_modified([[2,Elem1]|T]);
encode_list_modified([Elem1,Elem2|T]) -> [Elem1|encode_list_modified([Elem2|T])].

encode_modified(L) -> [convert_list_to_tuple(X) || X <- encode_list_modified(L)].

% P12 (**) Написати декодер для модифікованого алгоритму RLE:
decode_list_modified([])-> [];
decode_list_modified([[2,X]|[]])-> [X,X];
decode_list_modified([[Count,X]|[]])-> [X|decode_list_modified([[Count-1,X]])];
decode_list_modified([[2,X]|T])-> [X|[X|decode_list_modified(T)]];
decode_list_modified([[Count,X]|T])-> [X|decode_list_modified([[Count-1,X]|T])];
decode_list_modified([H|[[Count,X]|T]])-> [H|decode_list_modified([[Count,X]|T])];
decode_list_modified([H|[]])->[H].

decode_modified(L) -> 
	List_of_lists = [convert_tuple_to_list(X) || X <-L],
	decode_list_modified(List_of_lists).

% P13 (**) Написати декодер для стандартного алгоритму RLE:
decode_list([])-> [];
decode_list([[1,X]|[]])-> [X];
decode_list([[Count,X]|[]])-> [X|decode_list([[Count-1,X]])];
decode_list([[1,X]|T])-> [X|decode_list(T)];
decode_list([[Count,X]|T])-> [X|decode_list([[Count-1,X]|T])];
decode_list([H|[]])->[H].

decode(L) ->
	List_of_lists = [convert_tuple_to_list(X) || X <-L],
	decode_list(List_of_lists).

% P14 (*) Написати дублікатор усіх елементів списку:
duplicate([]) -> [];
duplicate([H|T]) -> [H|[H|duplicate(T)]].

% P15 (**) Написати функцію-реплікатор усіх елементів списку:
replicate([],_,_)->[];
replicate([_|T],0,Times)->replicate(T,Times,Times);
replicate([H|T],Count,Times)->[H|replicate([H|T],Count-1,Times)].
replicate([],_)->[];
replicate([H|T],Times)->replicate([H|T],Times,Times).


% Shared functions
convert_list_to_tuple(L) -> if is_list(L) -> list_to_tuple(L); true -> L end.
convert_tuple_to_list(T) -> if is_tuple(T) -> tuple_to_list(T); true -> T end.

% Роботу закінчено
