

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
