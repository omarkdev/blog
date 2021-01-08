---
title: "Yoda Conditions — Aprender devo eu?"
date: 2018-07-26T17:53:50.741Z
draft: false
---

![Yoda learning grammar](/uploads/2018/07/26/yoda-learning-grammar.jpeg)

Provavelmente em algum momento do tempo em que você passou programando, você fez
uma atribuição de uma variável dentro de um `if` que não era para existir,
quando era para ser `name == "Yoda"` mas por algum motivo você esqueceu de
colocar outro `=` e saiu `name = "Yoda"`. Com certeza isso gerou algum bug e
deve ter sido difícil descobrir o que era, já que nenhum erro foi informado. As
**Yoda Conditions** vieram para resolver exatamente esse problema.

> In [programming](https://en.wikipedia.org/wiki/Computer_programming)
> [jargon](https://en.wikipedia.org/wiki/Jargon), **Yoda conditions** (also called
Yoda notation) is a [programming
style](https://en.wikipedia.org/wiki/Programming_style) where the two parts of
an expression are reversed from the typical order in a [conditional
statement](https://en.wikipedia.org/wiki/Conditional_(computer_programming)). A
Yoda condition places the constant portion of the expression on the left side of
the conditional statement. The name for this programming style is derived from
the [Star Wars](https://en.wikipedia.org/wiki/Star_Wars) character named
[Yoda](https://en.wikipedia.org/wiki/Yoda), who [spoke
English](https://en.wikipedia.org/wiki/Yoda#Character_overview) in a
non-standard syntax.

A ideia das condições Yoda é que devemos inverter nossas expressões
condicionais, colocando o operando que não pode ser atribuído do lado esquerdo.
Invertendo a ordem natural de como é feito as condições.

Então, se temos um código assim,

```javascript
if (age = 18) {
    // ...
}
```

Sempre irá funcionar, pois atribuição de variável resulta em um valor
verdadeiro. E se ao invés disso, nós fizermos isso,


```javascript
if (18 = age) {
    // ...
}
```

Desta maneira, a constante `18` não pode ter seu valor alterado, logo ao
tentarmos mudar o valor dessa constante, uma exceção será disparada. Dessa
forma, conseguimos encontrar os bugs de forma mais simples.

## Quando utilizar ou não utilizar?

O único propósito desse estilo de programação é pegar uma atribuição de variável
indesejada quando você fizer uma comparação. Logo, **você deve utilizar quando
há uma chance de uma variável acidentalmente ser atribuída a um novo valor**.
Vamos a alguns exemplos.

### Exemplo 1

```javascript
if (user.getName() == "Barbara Liskov") {
    // ...
}
```

Nessa expressão não é necessário a utilização desse estilo, pois se tentarmos
atribuir um valor a expressão, uma exceção será disparada, já que não
conseguimos atribuir valores a uma chamada de função. Porém, alguns
desenvolvedores podem optar pela utilização do estilo nessa situação, caso
posteriormente refatorem o código e substituam a chamada de função por uma
variável.

### Exemplo 2

```javascript
if (userEmail != user.getEmail()) {
    // ...
}
```

Já nessa expressão, é necessário utilizar esse estilo, pois é muito fácil
esquecermos o operador de negação, ao fazer isso a variável `userEmail` poderia
ter seu valor alterado.

### Exemplo 3

```javascript
if (userEmail == authenticatedUserEmail) {
    // ...
}
```

E nessa expressão, o que você acha? Se você pensou que **não** **é necessário**
utilizar, você acertou. Nessa expressão, não faz diferença invertemos a ordem,
porque ambos são variáveis, então mesmo que esquecermos um operador de igual não
há nada que possa ser feito, pois haverá atribuição de qualquer maneira.

### Exemplo 4

```javascript
if (userAge >= 18) {
    ...
}
```

E por último, nessa expressão não é necessário utilizar esse estilo, porque não
é uma expressão de igualdade e sim queremos saber se a idade do usuário é maior
ou igual a 18. Usar condições Yoda aqui tornaria esse código mais difícil de
ler. É recomendável utilizar condições Yoda apenas em expressões de igualdade.

## O beneficio ficou bem claro, mas…

Ficou simples de entender quais são os benefícios de utilizar as condições Yoda,
mas como tudo nessa vida, temos efeitos colaterais ao adotarmos esse estilo de
código.

O principal efeito colateral é tornar o código menos legível. Muitos críticos
desse estilo de programação vêem a falta de legibilidade como algo que não é
superado pelos benefícios que isso pode trazer para você. Parte do seu trabalho
é escrever um código legível para outros desenvolvedores, pode ser que ao adotar
as condições Yoda, isso se torne um problema para alguns desenvolvedores do seu
time.

Críticos para esse estilo de programação tem de monte, no meio desses críticos
temos o **Uncle Bob (Robert C. Martin)**, que é uma personalidade bem forte na
área de desenvolvimento de software, principalmente em questões de *design de
software*, *código limpo*, etc. Em seu blog ele diz,

> “I dislike any statement in code that causes the reader to do a double-take.
> Code that protects the author at the expense of the reader is flawed code.” —
Uncle Bob

Talvez faça mais sentido ao invés de adotar esse estilo de programação, você
adotar um **linter** para seu projeto que pode te avisar sobre atribuições
dentro de condições. Além disso, hoje já temos alguns compiladores que mostram
um aviso quando temos esse tipo de atribuição. Sem contar que algumas linguagens
como **Python** e **Swift** não permitem atribuições dentro de condições.

Outro efeito colateral que pode se tornar problema gigantesco em linguagens como
**Java**, e a percepção atrasada de ponteiros nulos. A questão é que ponteiros
nulos são percebidos de forma melhor no início da execução e se for ignorado,
poderá criar vulnerabilidades no código adiante. Ficou confuso? Que tal com um
um exemplo,

```java
class Bank {
    public void creditAccount(Customer cst, int amt) {
        //Verification steps.
        if ("closed".equals(cst.getAccountState()) {
            throw new RuntimeException("Account is closed.");
        } else {
            cst.credit(amt);
        }
    }
}
class Customer {
    private String state;
    public Customer(){
    }
    public void setAccountState(){
        this.state = "open";
    }
    public String getAccountState(){
        return this.state;
    }
    public void credit(int amt) {
        //Logic to credit account;
    }
}
public class Main {
    public static void main(String[] args) {
        Bank bank = new Bank();
        Customer customer = new Customer();
        bank.creditAccount(customer, 100000);
    }
}

// Exemplo retirado de Yoda Conditions its advantages and disadvantages.
```

No exemplo, podemos ver que o estado da classe `Customer` não foi inicializado,
logo é um valor nulo, então quando comparamos dentro da classe `Bank` no método
`creditAccount` não conseguimos saber quando uma conta está “fechada”, logo
temos uma vulnerabilidade que será difícil de rastrear.

Por mais que exista efeitos colaterais ao adotar esse estilo de código, pode ser
que esses efeitos colaterais não se tornem tão relevantes em seu projeto, então
você só vai saber ao tentar. Pode ser que faça sentido e funcione perfeitamente
para você, ou pode ser que fique uma merda, no final você só vai descobrir
testando.

### Alguns cases

Pode ser que esse conceito seja bem famoso para você, ou talvez você nunca tenha
ouvido falar, mas no mundo da programação isso já não é mais uma novidade.

Temos dois cases bem famosos na área de **PHP** que utilizam esse estilo de
programação em seu coding standard, sendo eles o **WordPress** e o **Symfony**.
Inclusive esses coding standard, dizem para sempre colocarmos a constante ou o
literal à esquerda, independentemente da expressão.

* [Coding Standard do
WordPress](https://make.wordpress.org/core/handbook/best-practices/coding-standards/php/#yoda-conditions)
* [Coding Standard do
Symfony](https://symfony.com/doc/current/contributing/code/standards.html)

