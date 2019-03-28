%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - Exercício 1 - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Definição de invariante

:- op(900,xfy,'::').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento com informação sobre servico, utente, consulta, medico

:- dynamic(servico/4).
:- dynamic(utente/4).
:- dynamic(consulta/5).
:- dynamic(medico/4).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado servico : IdServ, Descrição, Instituição, Cidade -> { V, F }

servico(1,"Urgencia", "Hospital Sao Joao", "Porto").
servico(2,"Terapia da Fala", "Hospital Sao Joao", "Porto").
servico(3,"Fisioterapia", "Hospital Sao Joao", "Porto").
servico(4, "Pediatria", "Hospital Sao Joao", "Porto").
servico(5,"Ginecologia", "Hospital Sao Joao", "Porto").
servico(6,"Neurologia", "Hospital de Braga", "Braga").
servico(7,"Oncologia", "Hospital de Braga", "Braga").
servico(8,"Urgencia", "Hospital de Braga", "Braga").
servico(9,"Cardiologia", "Hospital de Braga", "Braga").
servico(10,"Fisioterapia", "Hospital de Braga", "Braga").

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado utente : IdUt, Nome, Idade, Cidade -> { V, F }

utente(1, "Luis Martins", 20, "Braga").
utente(2, "Francisco Lomba", 16, "Braga").
utente(3, "Joao Nunes", 20, "Braga").
utente(4, "Renato Silva", 34, "Porto").
utente(5, "Mateus Oliveira", 22, "Porto").
utente(6, "Joana Santos", 45, "Porto").
utente(7, "Mariana Moreira", 20, "Porto").
utente(8, "Maria Ralha", 36, "Braga").
utente(9, "Patricia Nogueira", 57, "Braga").
utente(10, "Carla Queiros", 23, "Porto").

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado consulta : Data, IdUt, IdServ, idM, Custo -> {V,F }

consulta('2019-01-23',1,2,3,25.00).
consulta('2019-01-23',2,10,10,32.50).
consulta('2019-01-23',3,9,9,17.00).
consulta('2019-01-23',4,3,4,50.09).
consulta('2019-01-23',5,1,12,28.00).
consulta('2019-01-23',6,5,1,32.52).
consulta('2019-01-23',7,4,5,29.00).
consulta('2019-01-23',8,7,7,53.59).
consulta('2019-01-23',9,8,8,25.80).
consulta('2019-01-23',10,6,6,38.21).
consulta('2019-01-24',1,8,11,35.00).
consulta('2019-01-24',2,9,9,35.50).
consulta('2019-01-24',3,10,10,13.00).
consulta('2019-01-24',4,3,4,20.09).
consulta('2019-01-24',5,2,3,58.00).
consulta('2019-01-24',6,1,2,42.52).
consulta('2019-01-24',7,5,1,59.00).
consulta('2019-01-24',8,7,7,43.59).
consulta('2019-01-24',9,8,11,26.30).
consulta('2019-01-24',10,6,6,39.11).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado medico : IdM, Nome, Idade, IdServ -> { V, F }

medico(1,"Flavio Martins",69,5).
medico(2,"Rodrigo Sousa",38,1).
medico(3,"Catia Costa",30,2).
medico(4,"Joaquina Afonsina",45,3).
medico(5,"Maria Joana",42,4).
medico(6,"Marisa Podence",56,6).
medico(7,"Jose Costa",63,7).
medico(8,"Ricardo Teixeira",43,8).
medico(9,"Elisabete Riccardi",49,9).
medico(10,"Isadora Goncalves",62,10).
medico(11,"Luis Braga", 34, 8).
medico(12,"Joao Rodrigues",59,1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado comprimento : L , R -> {V,R}
comprimento([],0).
comprimento([X|P],N) :- comprimento(P,G) ,
                        N is 1 + G.

remove(T) :- retract(T).

inserir(E) :- assert(E).
inserir(E) :- retract(E),!,fail.

% Extensão do predicado que permite a evolucao do conhecimento
evolucao(E) :- findall(I,+E::I,L),
               inserir(E),
               teste(L).

teste([]).
teste([X|Y]) :- X , teste(Y).

% Extensão do predicado que permite o retrodecimento ou involu��o do
% conhecimento
involucao(E) :- findall(I,-E::I,L),
				 teste(L),
				 remove(E).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para utente que não permite a inserção de
% conhecimento repetido

+utente(Id,_,_,_) :: (findall(Id,(utente(Id,_,_,_)),L),
					 comprimento(L,1)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para medico que não permite a inserção de
% conhecimento repetido, nem associar servicos inexistentes

+medico(IdM,_,_,IdSer) :: (findall(IdM,(medico(IdM,_,_,_)),L),
					 comprimento(L,1),
                                           servico(IdSer, _, _, _)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para servico que não permite a inserção de
% conhecimento repetido

+servico(Id,_,_,_) :: (findall(Id,(servico(Id,_,_,_)),L),
					 comprimento(L,1)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante que certifica a existencia de um ID de utente, um ID
% servico e de um ID de medico e que o dado servico perten�a ao m�dico
+consulta(_,IdUt,IdServ,IdM,_) :: (utente(IdUt,_,_,_),
								  servico(IdServ,_,_,_),
								  medico(IdM,_,_,IdServ)).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para utente que não permite a remo��o de
% conhecimento inexistente e, se existir, n�o pode estar associado a
% consultas.
-utente(IdU,_,_,_) :: (findall(IdU,(utente(IdU,_,_,_)),L),
                            comprimento(L,1),
                              findall(IdU, consulta(_,IdU,_,_,_),C),
                               comprimento(C,0)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para servico que nao permite a remocao de
% conhecimento inexistente e, se existir, nao pode estar associado a
% medicos (e, por consequencia, a consultas).
-servico(IdS,_,_,_) :: (findall(IdS,(servico(IdS,_,_,_)),L),
                          comprimento(L,1),
                           findall(IdS, medico(_,_,_,IdS),M),
                            comprimento(M,0)).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante estrutural para medico que n�o permite a remo��o de
% conhecimento inexistente, nem remover medicos associados a, pelo
% menos, uma consulta.

-medico(IdM,_,_,_) :: (findall(IdM,(medico(IdM,_,_,_)),L),
					 comprimento(L,1),
                                             findall(IdM, (consulta(_,_,_,IdM,_)),C),
                                             comprimento(C,0)).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar as instituicoes prestadoras de servicos
% Extensao do predicado instituicoes

instituicao(I) :- servico(_,_,I,_).
instituicoes(L) :- setof(I,instituicao(I),L).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar utentes por criterios de selecao

procuraUID(ID,R) :- findall((ID,NOME,IDADE,CIDADE),utente(ID,NOME,IDADE,CIDADE),R).

procuraUName(NOME,R) :- findall((ID,NOME,IDADE,CIDADE),utente(ID,NOME,IDADE,CIDADE),R).

procuraUAge(IDADE,R) :- findall((ID,NOME,IDADE,CIDADE),utente(ID,NOME,IDADE,CIDADE),R).

procuraUCidade(CIDADE,R) :- findall((ID,NOME,IDADE,CIDADE),utente(ID,NOME,IDADE,CIDADE),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar servicos por criterios de selecao

procuraSID(ID,R) :- findall((ID,DESCRICAO,INSTITUICAO,CIDADE),servico(ID,DESCRICAO,INSTITUICAO,CIDADE),R).

procuraSDES(DESCRICAO,R) :- findall((ID,DESCRICAO,INSTITUICAO,CIDADE),servico(ID,DESCRICAO,INSTITUICAO,CIDADE),R).

procuraSINS(INSTITUICAO,R) :- findall((ID,DESCRICAO,INSTITUICAO,CIDADE),servico(ID,DESCRICAO,INSTITUICAO,CIDADE),R).

procuraSCID(CIDADE,R) :- findall((ID,DESCRICAO,INSTITUICAO,CIDADE),servico(ID,DESCRICAO,INSTITUICAO,CIDADE),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar consulta por critérios de selecção

procuraCData(Data,R) :- findall((Data,IdUt,IdServ,IdM,Custo),consulta(Data,IdUt,IdServ,IdM,Custo),R).

procuraCIdUt(IdUt,R) :- findall((Data,IdUt,IdServ,IdM,Custo),consulta(Data,IdUt,IdServ,IdM,Custo),R).

procuraCIdServ(IdServ,R) :- findall((Data,IdUt,IdServ,IdM,Custo),consulta(Data,IdUt,IdServ,IdM,Custo),R).

procuraCIdM(IdM,R) :- findall((Data,IdUt,IdServ,IdM,Custo),consulta(Data,IdUt,IdServ,IdM,Custo),R).

procuraCCusto(Custo,R) :- findall((Data,IdUt,IdServ,IdM,Custo),consulta(Data,IdUt,IdServ,IdM,Custo),R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar medico por critérios de selecção

procuraMID(IdM,R) :- findall((IdM,Nome,Idade,IdSer),medico(IdM,Nome,Idade,IdSer),R).

procuraMNome(Nome,R) :- findall((IdM,Nome,Idade,IdSer),medico(IdM,Nome,Idade,IdSer),R).

procuraMIdade(Idade,R) :- findall((IdM,Nome,Idade,IdSer),medico(IdM,Nome,Idade,IdSer),R).

procuraMServ(IdSer,R) :- findall((IdM,Nome,Idade,IdSer),medico(IdM,Nome,Idade,IdSer),R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar serviços prestados por instituição/cidade/datas/custo
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensao do predicado servicoInst
servicoInstAux(Descricao,Inst) :- servico(_,Descricao,Inst,_).
servicoInst(Inst, R) :- setof(Descricao, servicoInstAux(Descricao,Inst), R).

% Extensao do predicado servicoCid
servicoCidAux(Descricao,Cidade) :- servico(_,Descricao,_,Cidade).
servicoCid(Cidade, R) :- setof(Descricao, servicoCidAux(Descricao,Cidade), R).

% Extensao do predicado servicoData
servicoDataAux(Descricao,Data) :- (servico(IdServ,Descricao,_,_), consulta(Data,_,IdServ,_,_)).
servicoData(Data, R) :- setof(Descricao, servicoDataAux( Descricao, Data), R).

% Extensao do predicado servicoCusto
servicoCustoAux(Descricao,Custo) :-  (servico(IdServ,Descricao,_,_), consulta(_,_,IdServ,_,Custo)).
servicoCusto(Custo, R) :- setof(Descricao, servicoCustoAux(Descricao,Custo) ,R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar os utentes de um serviço/instituição
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

utenteSerAux(IdSer,IdU,Nome,Idade) :- (utente(IdU,Nome,Idade,_), consulta(_,IdU,IdSer,_,_)).

utentesSerID(IdSer,R) :- setof((IdU,Nome,Idade),utenteSerAux(IdSer,IdU,Nome,Idade),R).

utenteInstAux(I,IdU,Nome,Idade) :- (utente(IdU,Nome,Idade,_), consulta(_,IdU,IdSer,_,_), servico(IdSer,_,I,_)).

utentesInst(I,R) :- setof((IdU,Nome,Idade),utenteInstAux(I,IdU,Nome,Idade),R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar serviços realizados por utente/instituição/cidade
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

serReaUtAux(IdUt,IdSer,Desc) :- (servico(IdSer,Desc,_,_),consulta(_,IdUt,IdSer,_,_)).
serReaUt(IdUt,R) :-
    setof((IdSer, Desc), serReaUtAux(IdUt,IdSer,Desc), R).

serReaInstAux(IdSer,Desc,Inst) :- (servico(IdSer,Desc,Inst,_),consulta(_,_,IdSer,_,_)).
serReaInst(Inst,R) :-
    setof((IdSer, Desc), serReaInstAux(IdSer,Desc,Inst),R).

serReaCidAux(Cidade,IdSer,Desc) :- (servico(IdSer,Desc,_,Cidade),consulta(_,_,IdSer,_,_)).
serReaCid(Cidade,R) :-
    setof((IdSer, Desc), serReaCidAux(Cidade,IdSer,Desc) ,R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calcular o custo total dos cuidados de saúde por
% utente/serviço/instituição/data
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

somaC([], 0).
somaC([H|T], R) :- somaC(T, R2), R is H+R2.

custoTUt(IdUt,R) :-
    findall(Custo, consulta(_,IdUt,_,_,Custo), R2), somaC(R2,R).

custoTServ(IdSer,R) :-
    findall(Custo, consulta(_,_,IdSer,_,Custo),R2), somaC(R2,R).

custoTInstAux(Inst,Custo) :- (servico(IdSer,_,Inst,_),consulta(_,_,IdSer,_,Custo)).
custoTInst(Inst,R) :-
    setof(Custo, custoTInstAux(Inst,Custo), R2), somaC(R2,R).

custoTData(Data,R) :-
    findall(Custo, consulta(Data,_,_,_,Custo),R2), somaC(R2,R).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extras
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calcula total ganho das consultas dadas por medico

ganhoTMed(IdMed, R) :- findall(Custo, consulta(_,_,_,IdMed,Custo), R2), somaC(R2,R).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calcula total de consultas dadas por um medico

inc([],0).
inc([_|T], R) :- inc(T,R2), R is R2+1.

consultasMed(IdMed, R) :- findall(IdMed, consulta(_,_,_,IdMed,_), R2), inc(R2,R).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% A quantas consultas é que um utente já usufruiu

consultasUt(IdUt,R) :-
    findall(IdUt, consulta(_,IdUt,_,_,_),R2), inc(R2,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% A datas das consultas de um utente

datasUt(IdUt,R) :-
    findall(Data, consulta(Data,IdUt,_,_,_),R).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Ganho de um médico num determinado dia

ganhoMedDia(IdMed,Data,R) :-
    findall(Custo, consulta(Data,_,_,IdMed,Custo),R2), somaC(R2,R).



























