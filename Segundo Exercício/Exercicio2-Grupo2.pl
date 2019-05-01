%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - ExercÃ­cio 1 - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% DefiniÃ§Ã£o de invariante

:- op(900,xfy,'::').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento com informacao sobre prestador, utente, cuidado,
% excecao, nulointerdito

:- dynamic(prestador/4).
:- dynamic(utente/4).
:- dynamic(cuidado/5).
:- dynamic(excecao/1).
:- dynamic(nulointerdito/1).
:- dynamic(evolucao/2).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado utente : IdUt, Nome, Idade, Cidade -> { V, F, D
% }

-utente(Id, Nome, Idade, Cid) :-
    nao(utente(Id, Nome, Idade, Cid)),
    nao(excecao(utente(Id, Nome, Idade, Cid))).

% Definicao de nulo interdito
nulointerdito(imp).

% Conhecimento positivo
utente(1, "Luis Martins", 20, braga).
utente(2, "Francisco Lomba", 16, braga).
utente(3, "Joao Nunes", 20, braga).
utente(4, "Renato Silva", 34, porto).
utente(5, "Mateus Oliveira", 22, porto).
utente(6, "Joana Santos", 45, porto).
utente(7, "Mariana Moreira", 20, porto).
utente(8, "Maria Ralha", 36, braga).
utente(9, "Patricia Nogueira", 57, braga).
utente(10, "Carla Queiros", 23, porto).


% Conhecimento negativo
-utente(20, "Rui Sousa", 40, prado).
-utente(21, "Hugo Boss", 33, barcelos).


% Conhecimento imperfeito

% Tipo 1 -> Incerto
excecao(utente(Id, Nome, Idade, _)) :- utente(Id,Nome,Idade,incerto).
excecao(utente(Id, Nome, _, Cidade)) :- utente(Id, Nome, incerto, Cidade).
excecao(utente(Id, _, Idade, Cidade)) :- utente(Id, incerto, Idade, Cidade).

utente(11, "Gervasio Mota", 24, desc).                                 % ainda nao se sabe de onde este utente é
utente(15, "Jose Meireles", 32, incerto).                            % nao se sabe ainda de onde o utente é

% Tipo 2 -> impreciso
excecao(utente(12, "Otavio Silva", 38, porto)).
excecao(utente(12, "Otavio Silva", 39, porto)).                      % nao se sabe se o utente tem 38 ou 39 anos


% Tipo 3 -> Interdito (Invariantes relativos a nulos interditos
% apresentam-se mais a baixo)

excecao(utente(Id, _, Idade, Cidade)) :- utente(Id, Nome, Idade, Cidade), nulointerdito(Nome).
excecao(utente(Id, Nome, _, Cid)) :- utente(Id, Nome, Idade, Cid), nulointerdito(Idade).
excecao(utente(Id, Nome, Idade, _)) :- utente(Id, Nome, Idade, Cidade), nulointerdito(Cidade).

utente(16, imp, 23, braga).                                                              % e impossivel vir-se a saber o nome deste utente
utente(13, "Joaquim Oliveira", imp, braga).                                              % e impossível vir-se a saber a idade deste utente
utente(14, "Mateus Ferreira", 21, imp).                                                  % e impossivel vir-se a saber a cidade deste utente


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado prestador : IdPrest, Nome, Especialidade
% Instituicao -> { V, F, D }

%Pressuposto Mundo Fechado para prestador
-prestador(IdPrest, Nome, Esp, Inst) :-
    nao(prestador(IdPrest, Nome, Esp, Inst)),
    nao(excecao(prestador(IdPrest, Nome, Esp, Inst))).


% Conhecimento positivo
prestador(1, joao, urgencia, hospital_sao_joao).
prestador(2, ricardo, terapia_fala, hospital_sao_joao).
prestador(3, flavio, fisioterapia, hospital_sao_joao).
prestador(4, luis, pediatria, hospital_sao_joao).
prestador(5, gervasio, ginecologia, hospital_sao_joao).
prestador(6, tomas, neurologia, hospital_Braga).
prestador(7, tiago, oncologia, hospital_Braga).
prestador(8, hugo,  urgencia, hospital_Braga).
prestador(9, rui, cardiologia, hospital_Braga).
prestador(10, jose, fisioterapia, hospital_Braga).

% Conhecimento negativo
-prestador(11, zeca, cardiologia, hospital_sao_joao).             % nao existe um prestador chamado zeca de cardiologia no hospital de sao joao
-prestador(12, paulo, pediatria, hospital_Braga).                  % nao existe um prestador chamado paulo de pediatria no hospital de braga

% Conhecimento imperfeito

% Tipo 1 -> Incerto

excecao(prestador(Id, _, Especi, Inst)) :- prestador(Id, incerto, Especi, Inst).

prestador(13, incerto, fisioterapia, hospital_Lisboa).              % ainda nao se sabe o nome do prestador de fisioterapia no hospital de lisboa

% Tipo 2 -> Impreciso

% o nome do prestador de cardiologia e joao ou jose
excecao(prestador(14, joao, cardiologia, hospital_Lisboa)).
excecao(prestador(14, jose, cardiologia, hospital_Lisboa)).

% Tipo 3 -> Interdito

excecao(prestador(Id, _, Especi, Inst)) :- prestador(Id, Nome, Especi, Inst), nulointerdito(Nome).

prestador(15, imp, neurologia, hospital_Lisboa).                       % e impossivel vir a saber-se o nome do prestador de neurologia do hospital de Lisboa

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado cuidado : Data, IdUt, IdPrest, Descricao, Custo
% -> {V, F, D}

%Pressuposto Mundo Fechado para cuidados
-cuidado(Data, IdUt, IdPrest, Desc, Custo) :-
    nao(cuidado(Data, IdUt, IdPrest, Desc, Custo)),
    nao(excecao(cuidado(Data, IdUt, IdPrest, Desc, Custo))).


% Conhecimento positivo
cuidado('2019-01-23',1,2,"A",25.00).
cuidado('2019-01-23',2,10,"B",32.50).
cuidado('2019-01-23',3,9,"C",17.00).
cuidado('2019-01-23',4,3,"D",50.09).
cuidado('2019-01-23',5,1,"E",28.00).
cuidado('2019-01-23',6,5,"F",32.52).
cuidado('2019-01-23',7,4,"G",29.00).
cuidado('2019-01-23',8,7,"H",53.59).
cuidado('2019-01-23',9,8,"I",25.80).
cuidado('2019-01-23',10,6,"J",38.21).
cuidado('2019-01-24',1,8,"K",35.00).
cuidado('2019-01-24',2,9,"L",35.50).
cuidado('2019-01-24',3,10,"M",13.00).
cuidado('2019-01-24',4,3,"N",20.09).
cuidado('2019-01-24',5,2,"O",58.00).
cuidado('2019-01-24',6,1,"P",42.52).
cuidado('2019-01-24',7,5,"Q",59.00).
cuidado('2019-01-24',8,7,"R",43.59).
cuidado('2019-01-24',9,8,"S",26.30).
cuidado('2019-01-24',10,6,"T",39.11).

% Conhecimento negativo
-cuidado('2019-01-27',4,2,"U",54).                                 % é falso que o utente 4 tenha ido ao prestador 4 e que tenha pago 54 euros no dia 27 de Jan de 2019

% Conhecimento imperfeito

% Tipo 1 -> Incerto

excecao(cuidado(Data, IdUt, IdPrest, _ , Custo)) :- cuidado(Data, IdUt, IdPrest, incerto, Custo).
excecao(cuidado(Data, IdUt, IdPrest, Desc , _)) :- cuidado(Data, IdUt, IdPrest, Desc, incerto).

cuidado('2019-01-28', 4, 8, "B", incerto).                                  % a pressa era tanta que quer o utente quer a pessoa que passou a fatura não se lembra do valor dela
cuidado('2019-01-28', 2, 5, incerto, 40.20).                    % o medico esqueceu-se de colocar a descricao do cuidado, pelo que ainda nao se conhece o que se fez

% Tipo 2 -> Impreciso

excecao(cuidado('2019-01-27',5,2,"G",C)) :- C >= 40, C =< 100.    % nao sabendo o valor exato do cuidado, pensa-se que estara entre 40 e 100 euros

% Tipo 3 -> Interdito

excecao(cuidado(Data,IdUt, IdPrest, Desc, _)) :- cuidado(Data, IdUt, IdPrest, Desc, Cts), nulointerdito(Cts).
excecao(cuidado(Data,IdUt, IdPrest, _, Custo)) :- cuidado(Data, IdUt, IdPrest, Desc, Custo), nulointerdito(Desc).

cuidado('2019-01-25',10,6,"V",imp).                                 % impossivel vir a saber-se o valor deste cuidado
cuidado('2019-01-28', 3, 7, "A", imp).                              % impossível vir a saber-se o valor deste cuidado
cuidado('2019-01-28', 2, 8, imp, 40).                               % impossível vir a saber-se a descricao deste cuidado



% ---------------------------------Invariantes estruturais-------------------------------
% -----------------------------------------Utente----------------------------------------
% Invariante estrutural que nao permite repeticao de conhecimento
+utente(Id,_,_,_) :: (solucoes(Id,(utente(Id,_,_,_)),L),
					 comprimento(L,0)).

+(-utente(Id,_,_,_)) :: (solucoes(Id,(-utente(Id,_,_,_)),L),
					 comprimento(L,0)).


% Invariante estrutural que nao permite a insercao de
% conhecimento caso ja acha conhecimento negativo do mesmo (contradicao)

+(-utente(_,Nome,Idade,Cidade)) :: ( solucoes( (Id), utente(Id, Nome, Idade, Cidade), L),
                                     comprimento(L,0)).

% Invariantes estruturais que verifica se não existe conhecimento
% imperfeito interdito em relação ao que está a ser inserido

+utente(Id,_,Idade,Cid) :: (solucoes((Id, Nome, Idade, Cid ),(utente(Id, Nome, Idade, Cid), nulointerdito(Nome)),L),
								  comprimento(L,0)).

+(-utente(Id,_,Idade,Cid)) :: (solucoes((Id, Nome, Idade, Cid ),(utente(Id, Nome, Idade, Cid), nulointerdito(Nome)),L),
								  comprimento(L,0)).

+utente(Id,Nome,_,Cid) :: (solucoes((Id, Nome, Idade, Cid ),(utente(Id, Nome, Idade, Cid), nulointerdito(Idade)),L),
								  comprimento(L,0)).

+(-utente(Id,Nome,_,Cid)) :: (solucoes((Id, Nome, Idade, Cid ),(utente(Id, Nome, Idade, Cid), nulointerdito(Idade)),L),
								  comprimento(L,0)).

+utente(Id,Nome,Idade,_) :: (solucoes((Id, Nome, Idade, Cidade ),(utente(Id, Nome, Idade, Cidade), nulointerdito(Cidade)),L),
								  comprimento(L,0)).

+(-utente(Id,Nome,Idade,_)) :: (solucoes((Id, Nome, Idade, Cidade ),(utente(Id, Nome, Idade, Cidade), nulointerdito(Cidade)),L),
								  comprimento(L,0)).

% Invariante estrutural que nao permite a remoção de
% conhecimento inexistente e não pode estar associado a
% nenhum cuidado (no caso de ser conhecimento positivo)

-utente(IdU,_,_,_) :: (solucoes(IdU,(utente(IdU,_,_,_)),L),
                            comprimento(L,1),
                              solucoes(IdU, cuidado(_,IdU,_,_,_),C),
                               comprimento(C,0)).

-(-utente(IdU,_,_,_)) :: (solucoes(IdU,(-utente(IdU,_,_,_)),L),
                            comprimento(L,1)).

% ---------------------------------------Prestador---------------------------------------------------
% Invariante estrutural que nao permite a insercao de conhecimento
% repetido

+prestador(Id,_,_,_) :: (solucoes(Id,(prestador(Id,_,_,_)),L),
					 comprimento(L,0)).

+(-prestador(Id,_,_,_)) :: (solucoes(Id, (-prestador(Id,_,_,_)) ,L),
					 comprimento(L,0)).



% Invariante estrutural que nao permite a insercao de
% conhecimento caso ja haja conhecimento negativo do mesmo
% e vice-versa (contradicao)

+(-prestador(_,Nome,Esp,Inst)) :: ( solucoes( (Nome), prestador(_, Nome, Esp, Inst), L),
                                      comprimento(L,0)).

% Invariante estrutural que nao permite a adicao de conhecimento que
% contenha conhecimento imperfeito interdito no nome do prestador

+prestador(Id,_,Especi,Inst) :: ( solucoes( Id, ( prestador(Id, Nome, Especi, Inst), nulointerdito(Nome) ), L ),
                                     comprimento( L , 0 )).

+(-prestador(Id,_,Especi,Inst)) :: ( solucoes( Id, ( prestador(Id, Nome, Especi, Inst), nulointerdito(Nome) ), L ),
                                     comprimento( L , 0 )).


% Invariante estrutural que nao permite a remocao de
% conhecimento inexistente e, se existir, nao pode estar associado a
% cuidados.

-prestador(IdP,_,_,_) :: (solucoes(IdP,(prestador(IdP,_,_,_)),L),
                          comprimento(L,1),
                           solucoes(IdP, cuidado(_,_,IdP,_,_),M),
                            comprimento(M,0)).

-(-prestador(IdP,_,_,_)) :: (solucoes(IdP,(-prestador(IdP,_,_,_)),L),
                             comprimento(L,1)).

% ---------------------------------------Cuidado---------------------------------------------------
% Invariante que certifica a existencia de um ID de utente, um ID
% do prestador

+cuidado(_,IdUt,IdPrest,_,_) :: (utente(IdUt,_,_,_),
                                      prestador(IdPrest,_,_,_)).

+(-cuidado(_,IdUt,IdPrest,_,_)) :: (utente(IdUt,_,_,_),
                                      prestador(IdPrest,_,_,_)).



% Invariante estrutural para cuidado que nao permite a insercao de
% conhecimento caso ja acha conhecimento negativo do mesmo (contradicao)

+(-cuidado(Data,IdUt,IdPrest,Desc,Custo)) :: ( solucoes( (Data,IdUt), cuidado(Data, IdUt, IdPrest, Desc, Custo), L),
                                                     comprimento(L,0)).


% Invariantes estruturais que nao permitem a adicao de conhecimento que
% contenha conhecimento imperfeito do tipo nulo interdito (data,
% descricao e custo)

+cuidado(Data,IdUt,IdPrest,Desc,_) :: (solucoes((Data, IdUt, IdPrest, Desc, Cs),(cuidado(Data, IdUt, IdPrest, Desc, Cs), nulointerdito(Cs)),L),
								  comprimento(L,0)).

+(-cuidado(Data,IdUt,IdPrest,Desc,_)) :: (solucoes((Data, IdUt, IdPrest, Desc, Cs),(cuidado(Data, IdUt, IdPrest, Desc, Cs), nulointerdito(Cs)),L),
								  comprimento(L,0)).

+cuidado(Data,IdUt,IdPrest,_,Custo) :: (solucoes((Data, IdUt, IdPrest, Descs, Custo),(cuidado(Data, IdUt, IdPrest, Descs, Custo), nulointerdito(Descs)),L),
								  comprimento(L,0)).

+(-cuidado(Data,IdUt,IdPrest,_,Custo)) :: (solucoes((Data, IdUt, IdPrest, Descs, Custo),(cuidado(Data, IdUt, IdPrest, Descs, Custo), nulointerdito(Descs)),L),
								  comprimento(L,0)).



% --------------------------------- - - - - - - - - - - - - - - -
% Extensao do predicado comprimento : L , R -> {V,R}
comprimento(L,N) :- length(L,N).

remove(T) :- retract(T).


% Extensao do predicado que permite a evolucao do conhecimento positivo
evolucao(E, positivo) :- solucoes(I,+E::I,L),
                         teste(L),
                         assert(E).

% Extensao do predicado que permite a evolucao de conhecimento negativo
evolucao(E, negativo) :- solucoes(I,+(-E)::I,L),
                         teste(L),
                         assert(-E).

%----------Evolucao Conhecimento Imperfeito--------------

%---------------Incerto (Tipo 1)-----------------------


% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto na idade do utente

evolucao(utente(Id, _, Idade, Cid), incerto, nome) :- evolucao(utente(Id, incerto, Idade, Cid), positivo).


% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto na idade do utente

evolucao(utente(Id, Nome, _, Cid), incerto, idade) :- evolucao(utente(Id, Nome, incerto, Cid), positivo).

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto na cidade do utente

evolucao(utente(Id, Nome, Idade, _), incerto, cidade) :- evolucao(utente(Id, Nome, Idade, incerto), positivo).

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto no nome do prestador

evolucao(prestador(Id, _, Esp, Inst)) :- evolucao(prestador(Id, incerto, Esp, Inst), positivo).


% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto na descricao do cuidado

evolucao(cuidado(Data, IdUt, IdPrest, _, Custo), incerto, descricao) :- evolucao(cuidado(Data, IdUt, IdPrest, incerto, Custo), positivo).

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo incerto no custo do cuidado

evolucao(cuidado(Data, IdUt, IdPrest, Desc, _), incerto, custo) :- evolucao(cuidado(Data, IdUt, IdPrest, Desc, incerto), positivo).

%-------------Impreciso(Tipo 2)--------------------------

evolucao_impreciso(_,_,_,[]).

evolucao_impreciso(utente(Id, Nome, Idade), variado, cidade, [H|T]) :- nao(utente(Id,_,_,_)),
                                                                       assert(excecao(utente(Id, Nome, Idade, H))),
                                                                       evolucao_impreciso(utente(Id, Nome, Idade), variado, cidade, T).

evolucao_impreciso(utente(Id, Nome, Cidade), variado, idade, [H|T]) :-  nao(utente(Id,_,_,_)),
                                                                                   assert(excecao(utente(Id, Nome, H, Cidade))),
                                                                                   evolucao_impreciso(utente(Id, Nome, Cidade), variado, idade, T).

evolucao_impreciso(utente(Id, Nome, Cidade), proximo, idade, V) :- nao(utente(Id,_,_,_)),
                                                                              M1 is V*0.96,
                                                                              M2 is V*1.04,
                                                                              assert(excecao(utente(Id,Nome,Idade,Cidade)) :- (Idade >=M1, Idade =< M2)).

evolucao_impreciso(utente(Id, Nome, Cidade), intervalo, idade, V1, V2) :- nao(utente(Id,_,_,_)),
                                                                          assert(excecao(utente(Id,Nome,Idade,Cidade)) :- (Idade =< V2, Idade >= V1)).

evolucao_impreciso(prestador(Id, Esp, Inst), variado, nome, [H|T]) :- nao(prestador(Id,_,_,_)),
                                                                      assert(excecao(prestador(Id, H, Esp, Inst))),
                                                                      evolucao_impreciso(prestador(Id, Esp, Inst), variado, nome, T).

evolucao_impreciso(cuidado(Data, IdU, IdP, Desc), variado, custo, [H|T]) :- nao(cuidado(Data, IdU, IdP, Desc, _)),
                                                                            assert(excecao(cuidado(Data, IdU, IdP, Desc, H))),
                                                                            evolucao_impreciso(cuidado(Data, IdU, IdP, Desc), variado, custo, T).

evolucao_impreciso(cuidado(Data, IdU, IdP, Desc), proximo, custo, V) :- nao(cuidado(Data, IdU, IdP, Desc, _)),
                                                                              M1 is V*0.96,
                                                                              M2 is V*1.04,
                                                                              assert(excecao(cuidado(Data,IdU,IdP,Desc,Custo)) :- (Custo >=M1, Custo =< M2)).

evolucao_impreciso(cuidado(Data, IdU, IdP, Desc), intervalo, custo, V1, V2) :- nao(cuidado(Data, IdU, IdP, Desc, _)),
                                                                               assert(excecao(cuidado(Data,IdU,IdP,Desc,Custo)) :- (Custo >=V1, Custo =< V2)).


%------------Nulo Interdito(Tipo 3)----------------------

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito no nome do utente

evolucao(utente(Id, Nome, Idade, Cid), interdito, nome) :- evolucao(utente(Id, Nome, Idade, Cid), positivo),
                                                            testaInterdito(Nome).


% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito na idade do utente

evolucao(utente(Id, Nome, Idade, Cid), interdito, idade) :- evolucao(utente(Id, Nome, Idade, Cid), positivo),
                                                            testaInterdito(Idade).


% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito na cidade do utente

evolucao(utente(Id, Nome, Idade, Cid), interdito, cidade) :- evolucao(utente(Id, Nome, Idade, Cid), positivo),
                                                             testaInterdito(Cid).

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito no nome do prestador

evolucao(prestador(Id, Nome, Esp, Inst), interdito, nome):- evolucao(prestador(Id, Nome, Esp, Inst), positivo),
                                                            testaInterdito(Nome).

% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito no descricao do cuidado

evolucao(cuidado(Data, IdUt, IdPrest, Desc, Custo), interdito, descricao) :- evolucao(cuidado(Data, IdUt, IdPrest, Desc, Custo), positivo),
                                                                             testaInterdito(Desc).
% Extensao do predicado que permite a evolucao de conhecimento
% imperfeito do tipo interdito no custo do cuidado

evolucao(cuidado(Data, IdUt, IdPrest, Desc, Custo), interdito, custo) :- evolucao(cuidado(Data, IdUt, IdPrest, Desc, Custo), positivo),
                                                                         testaInterdito(Custo).


%--------Update, atualizar conhecimento imperfeito do tipo 1 (incerto)---------

update(Remover, Novo) :- retract(Remover), assert(Novo).

update_Utente(Id, Nome, nome) :- utente(Id, OldName, Idade, Cidade),
                                 OldName == incerto,
                                 update(utente(Id, OldName, Idade, Cidade), utente(Id, Nome, Idade, Cidade)).

update_Utente(Id, Idade, idade) :- utente(Id, Nome, OldAge, Cidade),
                                   OldAge == incerto,
                                   update(utente(Id, Nome, OldAge, Cidade), utente(Id, Nome, Idade, Cidade)).

update_Utente(Id, Cidade, cidade) :- utente(Id, Nome, Idade, OldCity),
                                     OldCity == incerto,
                                     update(utente(Id, Nome, Idade, OldCity), utente(Id, Nome, Idade, Cidade)).

update_Prestador(Id, Nome, nome) :- prestador(Id, OldName, Esp, Inst),
                                    OldName == incerto,
                                    update(prestador(Id,OldName,Esp,Inst), prestador(Id, Nome, Esp, Inst)).

update_Cuidado(Data, IdUt, IdPrest, NewDesc, descricao) :- cuidado(Data, IdUt, IdPrest, Desc, Custo),
                                                           Desc == incerto,
                                                           update(cuidado(Data, IdUt, IdPrest, Desc, Custo), cuidado(Data, IdUt, IdPrest, NewDesc, Custo)).

update_Cuidado(Data, IdUt, IdPrest, NewCusto, custo) :- cuidado(Data, IdUt, IdPrest, Desc, Custo),
                                                        Custo == incerto,
                                                        update(cuidado(Data, IdUt, IdPrest, Desc, Custo), cuidado(Data, IdUt, IdPrest, Desc, NewCusto)).


%--------Update, atualizar conhecimento imperfeito do tipo 2 (impreciso)---------



teste([]).
teste([X|Y]) :- X , teste(Y).

testaInterdito(X) :- nao(nulointerdito(X)), assert(nulointerdito(X)).
testaInterdito(X) :- nulointerdito(X).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }

si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.
si( Questao,desconhecido ) :-
    nao( Questao ),
    nao( -Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( _ ).

solucoes(X, Y, Z) :- findall(X, Y, Z).


%--------------Involucao do conhecimento------------------------------

% Extensao do predicado que permite o retrodecimento ou involucao do
% conhecimento positivo

involucao(E, positivo) :- solucoes(I,-E::I,L),
				 teste(L),
				 remove(E).

% Extensao do predicado que permite o retrodecimento ou involucao do
% conhecimento negativo

involucao(E, negativo) :- solucoes(I, -(-E)::I, L),
                          teste(L),
                          remove(E).




% Extensao do predicado que permite o retrodecimento ou involucao do
% conhecimento imperfeito do tipo 1 (incerto)

involucao(utente(Id), incerto, nome) :- utente(Id, incerto, Idade, Cidade),
                                        involucao(utente(Id, incerto, Idade, Cidade), positivo).

involucao(utente(Id), incerto, idade) :- utente(Id, Nome, incerto, Cidade),
                                         involucao(utente(Id, Nome, incerto, Cidade), positivo).

involucao(utente(Id), incerto, cidade) :- utente(Id, Nome, Idade, incerto),
                                          involucao(utente(Id, Nome, Idade, incerto), positivo).

involucao(prestador(Id), incerto, nome) :- prestador(Id, incerto, Esp, Inst),
                                           involucao(prestador(Id, incerto, Esp, Inst), positivo).

involucao(cuidado(Data, IdU, IdP, Custo), incerto, descricao) :- cuidado(Data, IdU, IdP, incerto, Custo),
                                                                 involucao(prestador(Data, IdU, IdP, incerto, Custo), positivo).

involucao(cuidado(Data, IdU, IdP, Desc), incerto, custo) :- cuidado(Data, IdU, IdP, Desc, incerto),
                                                            involucao(prestador(Data, IdU, IdP, Desc, incerto), positivo).

% Extensao do predicado que permite o retrodecimento ou involucao do
% conhecimento imperfeito do tipo 2 (impreciso)

retirarExcecoes([]).
retirarExcecoes([H|T]) :- remove(H), retirarExcecoes(T).

involucao_impreciso(utente(Id), variado) :- solucoes( excecao(utente(Id, Nome, Idade, Cidade)), excecao(utente(Id, Nome, Idade, Cidade)), L),
                                            comprimento(L,N),
                                            N > 0,
                                            retirarExcecoes(L).


involucao_impreciso(utente(Id), proximo, V) :- M1 is V*0.96,
                                               M2 is V*1.04,
                                               remove(excecao(utente(Id, _, Idade, _) :- M1=<Idade, M2>=Idade)).

involucao_impreciso(utente(Id), intervalo, M1, M2) :- remove(excecao(utente(Id, _, Idade, _) :- M1=<Idade, M2>=Idade)).


involucao_impreciso(prestador(Id), variado) :- solucoes( excecao(prestador(Id, Nome, Esp, Inst)), excecao(prestador(Id, Nome, Esp, Inst)), L),
                                               comprimento(L, N),
                                               N > 0,
                                               retirarExcecoes(L).


involucao_impreciso(cuidado(Data, IdU, IdP, Desc), variado, custo) :- solucoes( excecao(cuidado(Data, IdU, IdP, Desc, Custo)), excecao(prestador(Data, IdU, IdP, Custo)), L),
                                                                      comprimento(L, N),
                                                                      N > 0,
                                                                      retirarExcecoes(L).

involucao_impreciso(cuidado(Data, IdU, IdP, Desc), proximo, V) :- M1 is V*0.96,
                                                                  M2 is V*1.04,
                                                                  remove(excecao(cuidado(Data, IdU, IdP, Desc, Custo)) :- Custo=< M2, Custo >= M1).

involucao_impreciso(cuidado(Data, IdU, IdP, Desc), intervalo, M1, M2) :- remove(excecao(cuidado(Data, IdU, IdP, Desc, Custo)) :- Custo=< M2, Custo >= M1).



% Extensao do predicado que permite o retrocidemento ou involucao do
% conhecimento imperfeito do tipo 3 (interdito)

involucao(utente(Id), interdito, nome) :- utente(Id, Nome, Idade, Cidade),
                                          nulointerdito(Nome),
                                          involucao(utente(Id, Nome, Idade, Cidade), positivo).

involucao(utente(Id), interdito, idade) :- utente(Id, Nome, Idade, Cidade),
                                           nulointerdito(Idade),
                                           involucao(utente(Id, Nome, Idade, Cidade), positivo).

involucao(utente(Id), interdito, cidade) :- utente(Id, Nome, Idade, Cidade),
                                            nulointerdito(Cidade),
                                            involucao(utente(Id, Nome, Idade, Cidade), positivo).

involucao(prestador(Id), interdito) :- prestador(Id, Nome, Esp, Inst),
                                       nulointerdito(Nome),
                                       involucao(prestador(Id, Nome, Esp, Inst), positivo).

involucao(cuidado(Data, IdU, IdP, Custo), interdito, descricao) :- cuidado(Data, IdU, IdP, Desc, Custo),
                                                                   nulointerdito(Desc),
                                                                   involucao(cuidado(Data, IdU, IdP, Desc, Custo), positivo).

involucao(cuidado(Data, IdU, IdP, Desc), interdito, custo) :- cuidado(Data, IdU, IdP, Desc, Custo),
                                                              nulointerdito(Custo),
                                                              involucao(cuidado(Data, IdU, IdP, Desc, Custo), positivo).

%--------------Perguntas ao sistema (com 'e' e 'ou')-----------

pergunta([],verdadeiro).

pergunta([Questao], R) :- si(Questao, R).

pergunta([Questao, e |T], R) :- si(Questao, V1),
                                pergunta(T, V2),
                                conjuncao(V1, V2, R).

pergunta([Questao, ou |T], R) :- si(Questao, V1),
                                    pergunta(T, V2),
                                    disjuncao(V1, V2, R).

conjuncao(verdadeiro, verdadeiro, verdadeiro).
conjuncao(verdadeiro, desconhecido, desconhecido).
conjuncao(desconhecido, verdadeiro, desconhecido).
conjuncao(desconhecido, desconhecido, desconhecido).
conjuncao(falso, _, falso).
conjuncao(_, falso, falso).

disjuncao(verdadeiro, _, verdadeiro).
disjuncao(_, verdadeiro, verdadeiro).
disjuncao(desconchecido, desconhecido, desconhecido).
disjuncao(desconhecido, falso, desconhecido).
disjuncao(falso, desconhecido, desconhecido).
disjuncao(falso, falso, falso).



















