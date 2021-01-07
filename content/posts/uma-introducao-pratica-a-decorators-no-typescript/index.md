---
title: "Uma introdução prática à Decorators no TypeScript"
date: 2020-03-19T12:22:30.419Z
draft: false
---

![](./images/decorators.jpeg)

Os *decorators* são um dos recursos mais poderosos oferecido pelo TypeScript,
tendo como um dos principais objetivos ampliar funcionalidades de classes e
métodos de forma simples e limpa. Atualmente, os *decorators* são uma proposta
de estágio 2 para JavaScript e estão disponíveis como um recurso experimental no
TypeScript. Mesmo sendo um recurso experimental, eles já estão presentes em
grandes projetos de código aberto, como o Angular e Inversify.

Por ser um recurso experimental, para ser possível utilizar no TypeScript, é
necessário habilitar no `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES5"    
  }
}
```

Ou pela linha de comando:

```shell script
tsc --target ES5 --experimentalDecorators
```

Mesmo que inicialmente os *decorators* possam parecer mágicos, eles são simples
de se entender e fáceis de se criar.

### Mas afinal, o que é um decorator?

O site do TypeScript descreve como:

> “Um Decorator é um tipo especial de declaração que pode ser anexada a uma
> declaração de classe, método, acessador, propriedade ou parâmetro.”

Essa definição pode não explicar muito o que um *decorator* realmente
representa. Eu prefiro definir como “uma declaração especial para adicionar
funcionalidades extras a uma declaração de classe, método, acessador,
propriedade ou parâmetro”.

Você pode ter visto em algum projeto a utilização de *decorators*, eles utilizam
o formato `@expression`, onde o valor `expression` representa uma função que
fará as modificações as classes, métodos, acessadores, propriedades ou
parâmetros.

Para se criar um *decorator* é bem simples. Como já previamente explicado, os
*decorators* são apenas funções, essas funções são chamadas em tempo de
execução. Um exemplo bem simples é criarmos uma função `log` que irá realizar um
`console.log` no alvo em que ele for utilizado, ficando desta maneira:

```typescript

function log(target) {
  console.log(target);
}

@log
class Foo {}

// [Function: Foo]
```

Pode ser que em certas situações pode ser necessário você customizar como um
*decorator* é aplicado à uma declaração. Para isso, é necessário criar um
**Decorator Factory**, que é uma função que retorna a expressão que será
executada. Seguindo o mesmo exemplo, imagine que agora você queira adicionar um
prefixo estático nos logs, o resultado seria algo assim:

```typescript
function log(prefix) {
  return target => {
    console.log(`${prefix} - ${target}`);
  }
}

@log('Awesome')
class Foo {}

// Awesome - function Foo() {
// }
```

Como é possível analisar, agora ao invés de recebermos o alvo como parâmetro,
recebemos o parâmetro que informamos e temos que retornar uma função, que será
executada.

### Tipos de decorators

Ao se desenvolver *decorators* é importante saber que existem vários tipos,
esses tipos são determinados pelo alvo em que está sendo aplicado, sendo que
cada tipo tem suas particularidades e assinaturas diferentes. Atualmente os
tipos existentes são:

1.  Class Decorator.
1.  Property Decorator.
1.  Method Decorator.
1.  Accessor Decorator.
1.  Parameter Decorator.

#### Class Decorator

A maneira mais simples de se começar a entender os *decorators* é começar
desenvolvendo para classes. Um *decorator* para classe deve ser declarado antes
da declaração da classe. Esse *decorator* recebe um único parâmetro que é o
construtor da classe alvo.

```typescript
function setApiVersion(constructor) {
  constructor.api = '0.0.1';
}

@setApiVersion
class Wizard {}

console.log(Wizard); // { [Function: Wizard] api: '0.0.1' }
```

Caso o *decorator* retorne um valor, ele substituirá a declaração de classe pelo
valor fornecido, que deve ser um construtor. Dessa maneira, diferente do exemplo
acima, podemos aplicar mudanças diretas à classe, ao invés de apenas no
protótipo da classe.

```typescript
function setApiVersion(constructor) {
  return class extends constructor {
    version = '0.0.1';
  }
}

@setApiVersion
class Wizard {
}

console.log(new Wizard()); // class_1 { version: '0.0.1' }
```

É importante ressaltar que caso você decida retornar um construtor, você deve
manter a mesma assinatura do alvo.

Você perceberá no decorrer do aprendizado, que esse tipo de *decorator* é o mais
generalista, pois nele você pode ter acesso à classe inteira, ao invés de
pequenas partes do objeto.

#### Property Decorator

Um *decorator* de propriedade deve ser declarado antes da declaração da
propriedade. Dessa vez, o *decorator*, recebe 2 parâmetros, `target` e `key`. O
parâmetro `target` é o protótipo da classe em que está sendo aplicado o
*decorator*, já o parâmetro `key` é o nome da propriedade da classe em que está
sendo aplicado o *decorator*.

```typescript
function analyze(target: any, key: string) {
  console.log(target, key);
}

class Task {
  @analyze
  public title: string;

  constructor(title: string) {
    this.title = title;
  }
}

// Task {} 'title'
```

Com esse pequeno exemplo, foi mostrado na tela `Task {} 'title'`, que representa
o protótipo da classe e o nome da propriedade.

Um ponto interessante e importante de se analisar, como já foi dito, recebemos
como parâmetro o protótipo da classe e não sua instância, sabendo disso é
possível ver no exemplo que o *decorator* foi executado mesmo sem instanciarmos
a classe, isso por que o *decorator* é chamado no tempo de execução do arquivo.
Isso deve ser levado em consideração na hora de se criar seus *decorators* já
que você não terá uma chamada no *decorator* a cada vez que instanciar a classe.

O interessante desse tipo de *decorator* é a possibilidade de aplicar mudanças
de comportamento nas propriedades.

```typescript
function logProperty(target: any, key: string) {
  const newKey = `_${key}`;

  Object.defineProperty(target, key, {
    get() {
      console.log(`Get: ${key} => ${this[newKey]}`);
      return this[newKey];
    },
    set(newVal) {
      console.log(`Set: ${key} => ${newVal}`);
      this[newKey] = newVal;
    },
    enumerable: true,
    configurable: true
  });
}

class Task {

  @logProperty
  public id: number;

  @logProperty
  public title: string;

  constructor(id : number, title : string) {
    this.id = id;
    this.title = title;
  }
}

const task = new Task(1, 'Write more articles');
// Set: id => 1
// Set: title => Write more articles

console.log(task.id, task.title);
// Get: id => 1
// Get: title => Write more articles
// 1 'Write more articles'
```

No exemplo, criamos um *decorator* chamado `logProperty` que tem como objetivo
fazer um `console.log` toda vez que a propriedade tiver seu valor alterado ou
for acessada. Para saber o que acontece na propriedade, utilizamos os `getters`
e `setters` do próprio JavaScript.

#### Method Decorator

Para muitos esse é o tipo de *decorator* mais útil oferecido pelo TypeScript. Um
*decorator* para métodos deve ser declarado antes da declaração do método. Ao se
utilizar um *method decorator* recebemos 3 parâmetros. O primeiro parâmetro é o
`target` que é protótipo da classe, igual ao que vimos no *property decorator*. 
O segundo parâmetro é o `propertyKey` que é o nome do método em que estamos
aplicando. Já o último é o `propertyDescriptor`, que é um conjunto de
propriedades que definem uma propriedade de um objeto em JavaScript, neste
objeto podemos ter acesso a propriedades como: `configurable`, `enumerable`,
`value` e `writable`, além de `get` e `set`. Tendo acesso nesses 3 parâmetros,
somos capazes de realizar quase qualquer operação em cima de nossos métodos.

Vamos imaginar um cenário onde temos um método `changePassword` em uma classe
`User` e queremos alterar o `enumerable` deste método através de um `decorator`
para que esse método não apareça na hora de percorrer as propriedades existentes
na classe.

```typescript
class User {
    name: string = 'Marcos';

    changePassword(newPassword: string) { }
}

const user = new User();

for (const key in user) {
    console.log(key);
}

// name
// changePassword
```

Neste simples exemplo, será mostrado na tela `name` e `changePassword`. Como
queremos alterar o `enumerable` para o valor `false` deste método para não
mostrar na tela, basta alteramos a propriedade dentro do nosso
`propertyDescriptor`.

```typescript
function enumerable(newValue: boolean) {
    return (
        target: any,
        propertyKey: string,
        propertyDescriptor: PropertyDescriptor,
    ) => {
        propertyDescriptor.enumerable = newValue;
    }
}

class User {
    name: string = 'Marcos';

    @enumerable(false)
    changePassword(newPassword: string) { }
}

const user = new User();

for (const key in user) {
    console.log(key);
}

// name
```

Agora será mostrado na tela apenas `name`.

Esse tipo de *decorator* é extremamente útil quando queremos aplicar mudanças no
comportamento dos nossos métodos e como temos acesso a quase tudo que representa
o método, se torna muito simples aplicarmos as mudanças que queremos.

#### Accessor Decorator

Os accessor *decoratos* são os mesmos que os *method decorators*, mas são
aplicados aos métodos *setter* ou *getter*.

```typescript
function enumerable(newValue: boolean) {
    return (
        target: any,
        propertyKey: string,
        propertyDescriptor: PropertyDescriptor,
    ) => {
        propertyDescriptor.enumerable = newValue;
    }
}
class User {
    _name: string;

    constructor(name: string) {
        this._name = name;
    }

    @enumerable(true)
    get name() {
        return this._name;
    }
}

const user = new User('Marcos');

for (let key in user) {
    console.log(key);
}

// _name
// name
```

É importante entender que o TypeScript não permite aplicar um *decorator* a
ambos os acessadores de um único membro. Em vez disso, deve ser aplicado o
*decorator* ao primeiro acessador especificado na ordem do objeto.

```typescript
function enumerable(newValue: boolean) {
    return (
        target: any,
        propertyKey: string,
        propertyDescriptor: PropertyDescriptor,
    ) => {
        propertyDescriptor.enumerable = newValue;
    }
}
class User {
    _name: string;

    constructor(name: string) {
        this._name = name;
    }

    @enumerable(true)
    get name() {
        return this._name;
    }

    @enumerable(true)
    set name(newName: string) {
        this._name = newName;
    }
}

const user = new User('Marcos');

for (let key in user) {
    console.log(key);
}

//  error TS1207: Decorators cannot be applied to multiple get/set accessors of the same name.
```

#### Parameter Decorator

Por último, mas não menos importante, temos os *parameter decorators*. Um
*parameter decorator* deve ser declarado antes da declaração de um parâmetro.
Esse decorator recebe 3 parâmetros. O primeiro, como na maioria dos *decorators*
que já vimos é o `target` que é o protótipo da classe. O segundo é o
`propertyKey` que é o nome do método que contém o parâmetro estamos trabalhando,
bem semelhante ao que ja vimos no *method decorator*. Já o último parâmetro, é o
`parameterIndex` que é o número da posição do parâmetro na função, lembrando que
começa a partir do 0.

```typescript
function showInfo() {
    return (
        target: any,
        propertyKey: string,
        parameterIndex: number,
    ) => {
        console.log('target', target);
        console.log('property key', propertyKey);
        console.log('parameter index', parameterIndex);
    }
}

class User {
    changeName(
        @showInfo() name: string,
    ) {}
}

// target User { changeName: [Function] }
// property key changeName
// parameter index 0
```

Dessa maneira como estamos construindo os nossos *decorators*, só é possível
analisar o objeto e o método, qualquer alteração necessária no comportamento
requer o uso do
[reflect-metadata](https://www.typescriptlang.org/docs/handbook/decorators.html#metadata)
(que é um assunto para outro post).

### Quando usar

É comum quando estamos aprendendo algo novo entendermos como algo funciona mas
dificilmente conseguiremos enxergar cenários para aquele aprendizado. Para
alguns, não é diferente ao começar a aprender a trabalhar com os *decorators*.

Os *decorators* são extremamente úteis quando devemos adicionar ou alterar
comportamento de nossos alvos através de meta-programação. Quando temos algo que
pode ser considerado genérico, mas que pode ser reutilizado em vários lugares no
objetivo de facilitar alguma mudança em cima do alvo, talvez seja uma ótima
situação para se utilizar.

Ao se começar a pensar na criação de nossos próprios *decorators* podemos ver
que um grande benefício é a reutilização, porém mesmo que isso seja uma verdade,
devemos tomar muito cuidado para não acabar criando coisas extremamente
complexas com várias responsabilidades e efeitos colaterais.

Espero que isso te ajude de alguma forma.
