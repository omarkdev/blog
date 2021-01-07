---
title: "Novas funcionalidade do JavaScript em ES2019 (ES10)"
date: 2020-03-31T12:07:07.935Z
draft: false
---

![](./images/reading-journal-in-fire.jpeg)

Faz um certo tempo que o ECMAScript 2019 foi lançado, mas pouco se vê falar ou
utilizar as funcionalidades trazidas pela edição. Várias das novas
funcionalidades podem ajudar muito no seu dia-a-dia em coisas que antes você
precisava “implementar na mão”. Mesmo que já tenha passado algum tempo, é
extremamente necessário sempre reforçamos os aprendizados e analisarmos se
deixamos de passar algo.

É importante saber que para rodar os exemplos que serão apresentados, você
precisará do NodeJS a partir da versão 12, ou com o Chrome na versão 72.

### Array#{flat,flatMap}

O método `flat` cria um novo array concatenando todos os elementos que são
sub-arrays.

```javascript
const arr1 = ['a', 'b', 'c', [1, 2, 3]];
const arr1Flatted = arr1.flat();
// ["a", "b", "c", 1, 2, 3]
```

O parâmetro que esse método pode receber representa o nível de profundidade que
será concatenado os sub-arrays, por ser um parâmetro opcional, caso não seja
informado nenhum valor o seu valor padrão será 1. Caso você queira todos os
níveis, basta informar o valor `Infinity`.

```javascript
const arr1 = ['a', ['b', ['c']], 1, [2, [3, [4, [5]]]]];

const arr1Flatted1 = arr1.flat();
// ["a", "b", Array(1), 1, 2, Array(2)]

const arr1Flatted2 = arr1.flat(2);
// ["a", "b", "c", 1, 2, 3, Array(2)]

const arr1FlattedInfinity = arr1.flat(Infinity);
// ["a", "b", "c", 1, 2, 3, 4, 5]
```

É importante sabermos também que o método exclui intervalos ou elementos vazios
no array.

```javascript
const arr1 = ['a', 'b', , , , ['c', , 1, null, undefined, '', 0]];
const arr1Flatted = arr1.flat();

// ["a", "b", "c", 1, null, undefined, "", 0]
```

Entendendo como o método `flat` funciona, fica mais fácil entendermos qual o
objetivo do método `flatMap`. Resumidamente, o método tem o mesmo efeito usando
o `map` seguido de um `flat` , dessa maneira se o seu `flatMap` retornar um
array, ele será concatenado.

```javascript
const arr1 = [1, 2, 3, 4];

const arr1FlattedMultipliedByTwo = arr1.flatMap(v => [ v * 2 ]);
// arr1FlattedMultipliedByTwo
```

É importante saber que o `flatMap` por padrão é definido com profundidade 1, que
seria como chamar o `flat` sem parâmetros ou informando o valor 1.

### Object.fromEntries()

A função cria um novo objeto a partir de um
[iterable](https://alligator.io/js/iterables/)* *que tenha pares chave-valor.

``` javascript
const entries = [ ['name', 'Marcos'], ['site', 'omark.dev'], ['twitter', '@omarkdev'] ];

Object.fromEntries(entries);
// {name: "Marcos", site: "omark.dev", twitter: "@omarkdev"}
```

### String#{trimStart,trimEnd}

Os métodos `trimStart` e `trimEnd` tem quase a mesma finalidade, ambos removem
os espaços em branco de algum lado de uma string, a diferença é que o `trimEnd`
remove os espaços em branco que estão apenas no final da string e o `trimStart`
apenas os que estão no começo.

```javascript
const message = '     Hello world!     ';

message.trimEnd();
// "     Hello world!"

message.trimStart();
// "Hello world!     "
```

### Symbol#description

Antigamente caso precisássemos saber qual a descrição do nosso `Symbol` era
necessário chamar o método `toString`, que retornava a descrição dentro de
`Symbol()`.

``` javascript
const symbol1 = Symbol('Awesome');

symbol1.toString();
// "Symbol(Awesome)"
```

Dessa maneira antiga, caso fosse necessário obter apenas a descrição, era
necessário fazer algum tipo de formatação. Para resolver isso, foi adicionado a
propriedade de apenas leitura `description` que contém apenas a descrição do
`Symbol`, caso o `Symbol` foi criado sem nenhuma descrição, a propriedade terá o
valor `undefined`.

```javascript
const symbol1 = Symbol('Awesome');

symbol1.description;
// "Awesome"
```

### Parâmetros opcionais no catch

Agora o ES10 nos permite criar blocos de `try/catch` sem que seja necessário
fornecer o parâmetro de erro no bloco de `catch`.

```javascript
try {
  throw new Error('Useless Error');
} catch {
  console.log('Ignoring the exception');
}
// Ignoring the exception
```

Esse tipo de abordagem é muito útil para quando você sabe que não vai utilizar o
objeto de erro.

### Revisão de Function#toString

Nas versões anteriores do ECMAScript, você pode imprimir o código-fonte de uma
função usando o método `toString`, porém todos os espaços em branco e
comentários eram removidos. Agora com o ES10, esses trechos são mantidos.

``` javascript
function /* Sum two numbers */ sum(a, b) {
  return a + b; // Sum a + b
}

sum.toString();
// "function /* Sum two numbers */ sum(a, b) {
//    return a + b; // Sum a + b
// }"
```

### Estabilidade no Array#sort

Anteriormente, o V8 (Motor do JavaScript) usava um método de ordenação chamado
QuickSort para arrays que tinham mais de 10 elementos, apesar de ser um método
extremamente rápido, era bem instável.

A partir do V8 7.0 / Chrome 70, o V8 passou a utilizar o algoritmo TimSort.

Caso você queira saber mais sobre o assunto, você pode ver a
[demo](https://mathiasbynens.be/demo/sort-stability) do [Mathias
Bynens](https://mathiasbynens.be/).

### Melhor formatação no JSON.stringify

Foi adicionado uma melhoria para impedir que o `JSON.stringify` retorne
caracteres Unicode mal formatados.

### Melhorias no JSON

A Sintaxe do JSON é definido pelo
[ECMA-404](http://www.ecma-international.org/publications/standards/Ecma-404.htm)
e permanentemente corrigida pela
[RFC-7159](https://tools.ietf.org/html/rfc7159), permitindo que o separador de
linha (\u2028) e o separador de parágrafo (\u2029) possam ser exibidos
corretamente sem disparar um erro.

Espero que isso te ajude de alguma forma.

