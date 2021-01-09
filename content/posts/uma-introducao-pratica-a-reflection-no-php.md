---
title: Uma introdução prática à Reflection no PHP
description: Analisando ou modificando estruturas no PHP com PHP
date: 2020-03-24T11:58:20.718+00:00

---
São inúmeras linguagens de programação que disponibiliza mecanismos para se
fazer reflexão em estruturas de dados, no PHP isso também não seria diferente.
Mas antes precisamos entender, o que é **reflexão**?

> Em ciência da computação, **reflexão computacional** (ou somente **reflexão**) é
> a capacidade de um programa observar ou até mesmo modificar sua estrutura ou
> comportamento. — Wikipedia.

Se você tem uma pequena vivência com o PHP, provavelmente já deve ter encontrado
algum código “mágico” que resolve algum problema. Um exemplo um pouco comum é a
injeção de dependência do Laravel (que não é exclusividade da ferramenta), vamos
ver um exemplo (caso você não tenha vivência com o Laravel, não tem problema):

```php
<?php

namespace App\Http\Controllers;

use App\Repositories\UserRepository;

class UserController extends Controller
{
    /**
     * The user repository instance.
     */
    protected $users;

    /**
     * Create a new controller instance.
     *
     * @param  UserRepository  $users
     * @return void
     */
    public function __construct(UserRepository $users)
    {
        $this->users = $users;
    }
}
```

Se analisarmos o exemplo, vemos que o construtor da nossa classe
`UserController` espera uma instância de `UserRepository`, certo? Até aqui, sem
problemas, apenas PHP. A “mágica” do Laravel acontece quando o próprio framework
cria a instância de `UserRepository` e passa automaticamente para o nosso
controller. Para isso, o framework utiliza um padrão chamado _service container_
que por outro lado utiliza uma técnica chamada injeção de dependência.
Basicamente, o _service container_ analisa que a classe `UserController` precisa
de um `UserRepository` para ser instanciado e cria essa instância, mas como ele
sabe que ele precisa dessa instância? Com **reflexão**.

Trabalhar com **reflexão** no PHP é possível graças as classes mágicas de
[Reflection](https://www.php.net/manual/pt_BR/book.reflection.php) do PHP. Essas
classes estão disponíveis no _core_ da linguagem desde a versão 5, então não é
necessário fazer nenhuma instalação. Existem algumas classes de **Reflection**
no PHP, sendo que cada uma depende de onde você vai aplicar:

* [_ReflectionClass_](https://www.php.net/manual/pt_BR/class.reflectionclass.php) _— Utilizar em classes_;
* [_ReflectionExtension_](https://www.php.net/manual/pt_BR/class.reflectionextension.php) _— Utilizar em extensões_;
* [_ReflectionFunction_](https://www.php.net/manual/pt_BR/class.reflectionfunction.php) _— Utilizar em funções_;
* [_ReflectionFunctionAbstract_](https://www.php.net/manual/pt_BR/class.reflectionfunctionabstract.php) _— Utilizar em funções abstratas_;
* [_ReflectionMethod_](https://www.php.net/manual/pt_BR/class.reflectionmethod.php) _— Utilizar em métodos_;
* [_ReflectionObject_](https://www.php.net/manual/pt_BR/class.reflectionobject.php) _— Utilizar em_ [_objetos_](https://www.php.net/manual/pt_BR/language.types.object.php);
* [_ReflectionParameter_](https://www.php.net/manual/pt_BR/class.reflectionparameter.php) _— Utilizar em parâmetros (de métodos ou funções)_;
* [_ReflectionProperty_](https://www.php.net/manual/pt_BR/class.reflectionproperty.php) _— Utilizar em propriedades de classes_;
* [_ReflectionType_](https://www.php.net/manual/pt_BR/class.reflectiontype.php) _— Utilizar para saber sobre tipos de retorno_;
* [_ReflectionGenerator_](https://www.php.net/manual/pt_BR/class.reflectiongenerator.php) _— Utilizar em_ [_geradores_](https://www.php.net/manual/pt_BR/class.generator.php).

Vamos seguir com a ideia do exemplo em Laravel, mas agora fora do framework.
Imagine que precisamos instanciar a classe `UserController` que espera uma
instância de `UserRepository`, tudo isso fora do framework.

```php
<?php

class UserRepository
{ }

class UserController {
    private $userRepository;

    public function __construct(UserRepository $repository)
    {
        $this->userRepository = $repository;
    }
}
```

Analisando o nosso pequeno exemplo podemos ver que precisamos descobrir o que o
construtor necessita para que possamos instanciar, tudo isso de forma “mágica”,
utilizando **reflexão**. Se olharmos a lista das classes disponíveis, podemos
notar que existem 2 tipos de classes que chamam a nossa atenção para esse caso,
são as *ReflectionParameter *e _ReflectionMethod_, porem olhando a assinatura é
possível notar que _ReflectionParameter_ não serve diretamente para o nosso
caso, pois o primeiro argumento é um
[callable](https://www.php.net/manual/pt_BR/language.types.callable.php) e não é
o caso do nosso `__construct`, então sobra o _ReflectionMethod_. Então, basta
instanciar a classe _ReflectionMethod_ passando o nosso controller junto com o
nome do nosso método que é `__construct`.

```php
<?php

class UserRepository
{ }

class UserController {
    private $userRepository;

    public function __construct(UserRepository $repository)
    {
        $this->userRepository = $repository;
    }
}

$constructorReflected = new ReflectionMethod(UserController::class, '__construct');
$constructorParameters = $constructorReflected->getParameters();

$argumentsToConstruct = [];

foreach ($constructorParameters as $parameter) {
    $name = $parameter->getClass()->name;
    var_dump($name);
    // string(14) "UserRepository"

    $instance = new $name();
    var_dump($instance);
    // object(UserRepository)#3 (0) {
    //}

    $argumentsToConstruct[] = $instance;
}

$userController = new UserController(...$argumentsToConstruct);
var_dump ($userController);
// object(UserController)#4 (1) {
//  ["userRepository":"UserController":private]=>
//  object(UserRepository)#3 (0) {
//  }
//}
```

Criamos a nossa reflexão do método `__construct` utilizando a classe
_ReflectionMethod_. O interessante de se analisar é que o método
`getParameters()` da classe de reflexão retorna uma lista de
_ReflectionParameter_ que representa cada parâmetro, ou seja, mesmo que não
utilizando o _ReflectionParameter_ diretamente acabamos chegando na ideia do
mesmo resultado, tudo isso graças à uma ótima API das classes. Isso não é
particularidade apenas da _ReflectionMethod_, podemos fazer o mesmo utilizando a
classe _ReflectionClass_, criando uma reflexão para o nosso controller e
analisando o construtor do alvo.

```php
<?php

class UserRepository
{ }

class UserController {
    private $userRepository;

    public function __construct(UserRepository $repository)
    {
        $this->userRepository = $repository;
    }
}

$userReflected = new ReflectionClass(UserController::class);
var_dump($userReflected);
// object(ReflectionClass)#1 (1) {
//  ["name"]=>
//  string(14) "UserController"
//}

$constructorParameters = $userReflected->getConstructor()->getParameters();

$argumentsToConstruct = [];

foreach ($constructorParameters as $parameter) {
    $name = $parameter->getClass()->name;
    var_dump($name);
    // string(14) "UserRepository"

    $instance = new $name();
    var_dump($instance);
    // object(UserRepository)#2 (0) {
    //}

    $argumentsToConstruct[] = $instance;
}

$userController = new UserController(...$argumentsToConstruct);
var_dump($userController);
// object(UserController)#4 (1) {
//  ["userRepository":"UserController":private]=>
//  object(UserRepository)#2 (0) {
//  }
//}
```

Dessa maneira, conseguimos começar do nível de cima e ir acessando às nossas
necessidades até o último nível. Com esses pequenos exemplos, conseguimos
começar a entender como utilizar a API de reflexão do PHP e o básico (bem
básico) de como um _service container_ funciona.

Os exemplos podem ter ficado um pouco longos mas são bem simples, pois são
apenas um começo de como a reflexão do PHP funciona, de qualquer maneira
aconselho você a começar a testar cada uma das classes e entender suas
particularidades e funcionalidades.

Espero que isso te ajude de alguma forma.