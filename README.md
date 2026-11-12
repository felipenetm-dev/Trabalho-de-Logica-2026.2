# Sistema de Classificação de Veículos em Prolog

Projeto avaliativo da disciplina **Lógica para Ciências da Computação**.

**Autores:** [Nome do aluno 1] e [Nome do aluno 2]

## Sobre o sistema

O sistema guarda informações sobre 12 veículos vendidos no Brasil: categoria, combustível, preço, potência, consumo, porta-malas, carga e tração. Com essas informações, ele usa regras lógicas para:

- **classificar** cada veículo por finalidade: urbano, familiar, trabalho, fora de estrada ou esportivo;
- **classificar** cada veículo por faixa de preço: popular, intermediário, premium ou luxo;
- **recomendar** veículos de acordo com a necessidade e o orçamento do usuário.

> Os preços e consumos são aproximados e servem apenas para fins didáticos.

## Como executar

1. Instale o [SWI-Prolog](https://www.swi-prolog.org/download/stable).
2. Abra o SWI-Prolog e carregue o arquivo pelo menu **File → Consult...**, escolhendo o `veiculos.pl`. Outra opção é abrir o SWI-Prolog na pasta do projeto e digitar:
   ```prolog
   ?- [veiculos].
   ```
3. Faça as consultas, sempre terminando com ponto final. Quando houver mais de uma resposta, aperte `;` para ver a próxima.
4. Para rodar todos os exemplos de uma vez:
   ```prolog
   ?- demo.
   ```

## Base de conhecimento (fatos)

| Fato | Significado |
|---|---|
| `carro(Modelo, Marca, Categoria, Combustivel)` | Dados principais do veículo |
| `qlugares(Modelo, Quantidade)` | Quantidade de passageiros |
| `preco(Modelo, MilReais)` | Preço em mil reais |
| `potencia(Modelo, CV)` | Potência em cavalos |
| `consumo(Modelo, KmPorLitro)` | Consumo na cidade (elétricos não têm) |
| `portamalas(Modelo, Litros)` | Tamanho do porta-malas |
| `carga(Modelo, Kg)` | Capacidade de carga (picapes e utilitários) |
| `tracao(Modelo, Tipo)` | Tração: dianteira, traseira ou integral (4x4) |

### Veículos cadastrados

| Modelo | Marca | Categoria | Combustível | Preço (mil R$) | Lugares |
|---|---|---|---|---|---|
| mobi | Fiat | hatch | flex | 75 | 5 |
| onix | Chevrolet | hatch | flex | 95 | 5 |
| dolphin | BYD | hatch | elétrico | 150 | 5 |
| corolla | Toyota | sedan | flex | 160 | 5 |
| corollahibrido | Toyota | sedan | híbrido | 185 | 5 |
| seal | BYD | sedan | elétrico | 300 | 5 |
| havalh6 | GWM | SUV | híbrido | 270 | 5 |
| spin | Chevrolet | minivan | flex | 120 | 7 |
| strada | Fiat | picape | flex | 105 | 2 |
| hilux | Toyota | picape | diesel | 300 | 5 |
| sprinter | Mercedes | utilitário | diesel | 330 | 3 |
| mustang | Ford | esportivo | gasolina | 530 | 4 |

## Regras lógicas

| # | Regra | Quando é verdadeira |
|---|---|---|
| 1 | `economico(M)` | O veículo é elétrico **ou** faz 13 km/l ou mais |
| 2 | `sustentavel(M)` | O veículo é elétrico ou híbrido |
| 3 | `esportivo(M)` | A categoria é esportivo **ou** tem 400 cv ou mais |
| 4 | `urbano(M)` | É hatch, **ou** é um sedan econômico que não é esportivo |
| 5 | `familiar(M)` | Tem 7 lugares ou mais, **ou** 5 lugares e porta-malas de 400 L ou mais |
| 6 | `trabalho(M)` | É picape ou utilitário e carrega 600 kg ou mais |
| 7 | `fora_de_estrada(M)` | É SUV ou picape com tração integral (4x4) |
| 8 | `faixa_preco(M, Faixa)` | Classifica em popular (até 100), intermediário (até 200), premium (até 400) ou luxo |
| 9 | `primeiro_carro(M)` | Tem preço popular, é econômico e **não** é esportivo |
| 10 | `finalidade(M, F)` | Reúne as regras 3 a 7 em um único predicado |
| 11 | `recomendar(F, Orcamento, M)` | O veículo atende a finalidade F e custa até o orçamento |

Conceitos de Prolog usados nas regras:

- **Várias cláusulas com o mesmo nome** funcionam como **OU**. Exemplos: `economico` e `familiar`.
- **Vírgula** entre condições funciona como **E**.
- **Negação (`\+`)** quer dizer "não é verdade que". É usada em `primeiro_carro`, em `urbano` e para evitar respostas repetidas em `esportivo`.
- **Regras que usam outras regras.** `primeiro_carro` usa `faixa_preco`, `economico` e `esportivo`.
- **Comparações numéricas:** `>=`, `=<`, `>` e `<`.

## Predicados de consulta

| Predicado | O que faz |
|---|---|
| `veiculos_por_finalidade(F, Lista)` | Lista todos os veículos de uma finalidade |
| `mais_barato(F, M, Preco)` | Encontra o veículo mais barato de uma finalidade |
| `ficha(M)` | Mostra todos os dados e classificações de um veículo |
| `demo` | Executa todos os exemplos de consulta |

## Exemplos de consultas

**1. Quais veículos são econômicos?**
```prolog
?- economico(M).
M = dolphin ; M = seal ; M = mobi ; M = onix ; M = corollahibrido ; M = havalh6.
```

**2. Para que serve a hilux?**
```prolog
?- finalidade(hilux, F).
F = trabalho ; F = fora_de_estrada.
```

**3. Quais carros familiares custam até R$ 200 mil?**
```prolog
?- recomendar(familiar, 200, M).
M = spin ; M = corolla ; M = corollahibrido.
```

**4. Quais são bons para o primeiro carro?**
```prolog
?- primeiro_carro(M).
M = mobi ; M = onix.
```

**5. Qual o veículo de trabalho mais barato?**
```prolog
?- mais_barato(trabalho, M, P).
M = strada, P = 105.
```

**6. Quais veículos andam fora de estrada?**
```prolog
?- veiculos_por_finalidade(fora_de_estrada, L).
L = [havalh6, hilux].
```

**7. Em que faixa de preço está o mustang?**
```prolog
?- faixa_preco(mustang, F).
F = luxo.
```

**8. O mobi é esportivo?**
```prolog
?- esportivo(mobi).
false.
```

**9. Ficha completa de um veículo**
```prolog
?- ficha(seal).
=== seal (byd) ===
Categoria:    sedan
Combustivel:  eletrico
Preco:        R$ 300 mil (premium)
Potencia:     531 cv
Lugares:      5
Finalidades:  [familiar,esportivo]
-> Veiculo economico
-> Veiculo sustentavel
```

## Estrutura do repositório

```
veiculos.pl      código-fonte em Prolog (fatos, regras e consultas)
README.md        este arquivo
apresentacao.pdf slides da apresentação
```
