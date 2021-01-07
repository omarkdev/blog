---
title: "Usando o operador de coalescência nula do ES2020 no JavaScript"
description: "Entendendo e utilizando o operador de coalescência nula que foi introduzido no ES2020"
date: 2020-03-10T12:30:51.333Z
draft: false
---

### Usando o operador de coalescência nula do ES2020 no JavaScript

![](./images/question-mark.jpeg)

Foi introduzido um novo operador para gerenciar valores indefinidos ou nulos no
ECMAScript 2020. A sintaxe do novo operador são dois pontos de interrogação
seguidos “`??`”. O operador irá retornar o valor do lado direito quando o valor
do lado esquerdo for nulo ou indefinido.

Atualmente a [proposta](https://github.com/tc39/proposal-nullish-coalescing) de
adicionar este operador está no estágio 4, que significa que está pronto para
ser incluído. Você pode testar essa funcionalidade nas versões mais recentes do
Chrome e Firefox.

A utilização é bem simples:

```javascript
const task = null ?? 'Write a article';

console.log(task);
// Write a article
```

### Bem parecido como antigamente

A similaridade com os outros operador `&&` e `||` é bem grande, mas por que não
utilizar os operadores antigos? Esses operadores são utilizados para manipular
valores *truthy* e *falsy*. Os valores *falsy* são: `null`, `undefined`,
`false`, número 0, `NaN` e `string` vazia. Já os valores *truthy*, são todos os
outros valores não *falsy*.

A particularidade dos operadores `&&` e `||` algumas vezes pode nos induzir a
alguns erros. Imagine que um valor `null` ou `undefined` para você é algo que
você tenha que se preocupar, mas o número 0 não, se você optar por utilizar
esses operadores pode ser que você seja induzido ao erro.

```javascript
const request = {
    volume: 0
};

const volume = request.volume ?? 1;
console.log(volume);
// 1
```

Com o operador `||`, o valor da direita é retornado pois o valor da esquerda é
um valor *falsy*, na qual no nosso caso é um problema. Utilizando o novo
operador de coalescência nula, fica mais simples essa abordagem.

```javascript
const request = {
    volume: 0
};

const volume = request.volume ?? 1;
console.log(volume);
// 0
```

E como já foi dito, o valor se preocupa apenas com `undefined` e `null`, todos
os outros valores *falsy *são considerados como “verdadeiro”.

```javascript
console.log(0 ?? 'Awesome'); // 0
console.log(null ?? 'Awesome'); // Awesome
console.log(false ?? 'Awesome'); // false
console.log(undefined ?? 'Awesome'); // Awesome
console.log(NaN ?? 'Awesome'); // NaN
console.log('' ?? 'Awesome'); //
console.log(0n ?? 'Awesome'); // 0n
```

Esse operador é algo extremamente simples e útil, com a evolução da
especificação estamos cada vez mais prontos para lidar com essas divergências de
valores.

Espero que isso te ajude de alguma forma.
