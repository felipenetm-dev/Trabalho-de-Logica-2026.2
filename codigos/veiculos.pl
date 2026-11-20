

:- encoding(utf8).

/*BASE DE CONHECIMENTO (FATOS)*/

% carro(Modelo, Marca, Categoria, Combustivel).
%   Categoria:   hatch | sedan | suv | minivan | picape | utilitario | esportivo
%   Combustivel: flex | gasolina | diesel | hibrido | eletrico
carro(mobi,            fiat,      hatch,      flex).
carro(onix,            chevrolet, hatch,      flex).
carro(dolphin,         byd,       hatch,      eletrico).
carro(corolla,         toyota,    sedan,      flex).
carro(corollahibrido, toyota,    sedan,      hibrido).
carro(seal,            byd,       sedan,      eletrico).
carro(havalh6,        gwm,       suv,        hibrido).
carro(spin,            chevrolet, minivan,    flex).
carro(strada,          fiat,      picape,     flex).
carro(hilux,           toyota,    picape,     diesel).
carro(sprinter,        mercedes,  utilitario, diesel).
carro(mustang,         ford,      esportivo,  gasolina).

% qlugares(Modelo, QuantidadeDePassageiros).
qlugares(mobi, 5).            qlugares(onix, 5).
qlugares(dolphin, 5).         qlugares(corolla, 5).
qlugares(corollahibrido, 5). qlugares(seal, 5).
qlugares(havalh6, 5).        qlugares(spin, 7).
qlugares(strada, 2).          qlugares(hilux, 5).
qlugares(sprinter, 3).        qlugares(mustang, 4).

% preco(Modelo, PrecoEmMilReais).
preco(mobi, 75).             preco(onix, 95).
preco(dolphin, 150).         preco(corolla, 160).
preco(corollahibrido, 185). preco(seal, 300).
preco(havalh6, 270).        preco(spin, 120).
preco(strada, 105).          preco(hilux, 300).
preco(sprinter, 330).        preco(mustang, 530).

% potencia(Modelo, PotenciaEmCV).
potencia(mobi, 75).          potencia(onix, 116).
potencia(dolphin, 95).       potencia(corolla, 175).
potencia(corollahibrido, 122). potencia(seal, 531).
potencia(havalh6, 393).     potencia(spin, 111).
potencia(strada, 107).       potencia(hilux, 204).
potencia(sprinter, 163).     potencia(mustang, 488).

% consumo(Modelo, KmPorLitroNaCidade).
% Veiculos eletricos NAO tem este fato (nao usam combustivel liquido).
consumo(mobi, 13.5).         consumo(onix, 13.3).
consumo(corolla, 11.5).      consumo(corollahibrido, 17.5).
consumo(havalh6, 15.0).     consumo(spin, 10.5).
consumo(strada, 12.0).       consumo(hilux, 9.5).
consumo(sprinter, 9.0).      consumo(mustang, 7.5).

% portamalas(Modelo, Litros).
% Picapes e utilitarios usam o fato carga/2 no lugar deste.
portamalas(mobi, 215).      portamalas(onix, 275).
portamalas(dolphin, 345).   portamalas(corolla, 470).
portamalas(corollahibrido, 470). portamalas(seal, 400).
portamalas(havalh6, 560).  portamalas(spin, 553).
portamalas(mustang, 382).

% carga(Modelo, CapacidadeDeCargaEmKg).
carga(strada, 650).
carga(hilux, 1000).
carga(sprinter, 1500).

% tracao(Modelo, Tipo).   Tipo: dianteira | traseira | integral (4x4)
tracao(mobi, dianteira).     tracao(onix, dianteira).
tracao(dolphin, dianteira).  tracao(corolla, dianteira).
tracao(corollahibrido, dianteira). tracao(seal, integral).
tracao(havalh6, integral).  tracao(spin, dianteira).
tracao(strada, dianteira).   tracao(hilux, integral).
tracao(sprinter, traseira).  tracao(mustang, traseira).

/*REGRAS LOGICAS*/
% REGRA 1 - economico(M)
% Um veiculo e economico se for eletrico OU se fizer 13 km/l ou mais.
% (Duas clausulas = "OU" logico em Prolog.)
economico(M) :-
    carro(M, _, _, eletrico).
economico(M) :-
    consumo(M, KmL),
    KmL >= 13.0.

% REGRA 2 - sustentavel(M)
% Sustentavel = movido a energia eletrica ou hibrido.
sustentavel(M) :-
    carro(M, _, _, Combustivel),
    member(Combustivel, [eletrico, hibrido]).
    
% REGRA 3 - esportivo(M)
% E esportivo se a categoria ja e "esportivo" OU se tem 400 cv ou mais.
% O "\+" (negacao) evita repetir o mesmo carro nas duas clausulas.
esportivo(M) :-
    carro(M, _, esportivo, _).
esportivo(M) :-
    potencia(M, CV),
    CV >= 400,
    \+ carro(M, _, esportivo, _).

% REGRA 4 - urbano(M)
% Bom para a cidade: todo hatch, ou um seda economico que nao seja esportivo.
urbano(M) :-
    carro(M, _, hatch, _).
urbano(M) :-
    carro(M, _, sedan, _),
    economico(M),
    \+ esportivo(M).
    
% REGRA 5 - familiar(M)
% Familiar: 7 lugares ou mais, OU 5-6 lugares com porta-malas >= 400 L.
familiar(M) :-
    qlugares(M, L),
    L >= 7.
familiar(M) :-
    qlugares(M, L),
    L >= 5, L < 7,
    portamalas(M, Litros),
    Litros >= 400.

% REGRA 6 - trabalho(M)
% Para trabalho: picape ou utilitario que carregue pelo menos 600 kg.
trabalho(M) :-
    carro(M, _, Categoria, _),
    member(Categoria, [picape, utilitario]),
    carga(M, Kg),
    Kg >= 600.

% REGRA 7 - fora_de_estrada(M)
% Off-road: SUV ou picape com tracao integral (4x4).
fora_de_estrada(M) :-
    tracao(M, integral),
    carro(M, _, Categoria, _),
    member(Categoria, [suv, picape]).
