+++
date = 2021-03-15T19:13:45Z
description = ""
draft = true
title = "Design Patterns: Repository"

+++
O padrão de projeto Repository é um dos mais populares no momento. Eu, particularmente, acredito que é uma ótima escolha adotá-lo na maioria dos cenários, pois ao utilizá-lo, conseguimos centralizar a manipulação dos objetos de domínio além de oferecermos uma abstração para a camada de dados.

## Repository é uma Collection

O jeito mais fácil de entendermos como um _repository_ funciona é pensarmos nele como uma coleção (_collection_) de entidades, desta maneira, sua interface disponibiliza métodos responsáveis para reter e filtrar entidades. Esses métodos não devem ser direcionados a nada técnico, pois um _repository_ não representa nenhuma implementação técnica, como por exemplo: armazenamento em banco de dados ou cache.

Uma ótima maneira de pensarmos em _repositories_ é imaginarmos que sua aplicação está sempre em execução e que os objetos sempre permanecem na memória. 

Vamos imaginar um cenário onde temos um _repository_ chamado `UserRepository` . Pensando em uma _collection_, podemos ter funcionalidades como: adicionar um novo usuário à coleção, procurar um usuário pelo email ou removê-lo da coleção. É desta maneira que um repositório deve ser desenhado. Transformando o exemplo em código, podemos ter a seguinte interface:

```php
<?php

interface UserRepository
{
    public function findByEmail(string $email): ?User;
    public function add(User $user): void;
}
```

Se pegarmos a ideia inicial de pensarmos que os objetos sempre permanecem na memória, podemos ter algo como:

```php
<?php

final class ArrayUserRepository implements UserRepository
{
    private $users = [];

    public function findByEmail(string $email): ?User
    {
        foreach ($this->users as $user) {
            if ($user->email === (string) $email) {
                return $user;
            }
        }
    }

    public function add(User $user): void
    {
        $this->users[] = $user;
    }
}
```

Por isso que se começarmos pensando nesta ideia de uma _collection_ _in-memory_ fica mais fácil visualizar que a implementação técnica não tem nenhuma relevância para quem utiliza o repository, com isso se trocarmos a implementação para algo como `RedisUserRepository`, pouco importa para quem está apenas lidado com `UserRepository`.

## Repositories genéricos?

Um pensamento que vai se alimentando durante a nossa carreira é o de evitar duplicidade de código, porém muitas vezes é difícil saber se estamos cruzando a linha do _overegineering_ ou se realmente estamos evitando problemas futuros.

É muito provável que se você pesquisar outros posts que falam sobre o _Repository Pattern_, você encontrará muitos exemplos contendo uma interface genérica para todos os futuros _repositories_, algo como:

```php
<?php

 interface Repository {
    public function findAll();
    public function add($target);
    public function remove($target);
    public function findById($id);
}
```

Logo de cara esse tipo de interface pode parecer que faz sentido, pois que entidade não vai precisar adicionar, remover, ou buscar pelo id? Porém, está errado.

Seguir com está ideia, mesmo que possa aparentar fazer muito sentido, demonstra que a pessoa que irá desenhar a interface do _repository_ de uma entidade não teve tempo para considerar como o cliente irá consumir, ou quais os comportamentos que a entidade realmente precisa. Por exemplo, se iremos fazer apenas um CRUD de Usuários, você realmente acha que a busca por `id` será utilizada? Ou que não será necessário ter uma paginação? São perguntas que ao olharmos para uma implementação mais específica começam a tirar o sentido de _repositories_ genéricos.

## Dificilmente a implementação técnica será alterada

Quando lidamos com abstrações no mundo da orientação à objetos, sempre tem alguém para dizer: "É importante ter abstrações para caso você tenha que trocar a implementação". Isto é realmente verdade, porém você realmente vai trocar de ORM a cada mês? Eu duvido muito.

Em uma aplicação orientada à objetos bem desenhada, um conceito muito central é o encapsulamento.

Ao encapsular um _repository_, iremos lidar apenas com sua interface, o que pode nos trazer uma imensa vantagem na hora de testarmos nosso código. Imagine o seguinte exemplo:

```php
<?php
    
final class RegisterUserHandler
{
    private $userRepository;
    
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }
        
    public function handle(RegisterUser $command)
    {
        $this->userRepository->add($command->user());
    }
}
```

Neste caso temos uma classe responsável por registrar um usuário. Por depender apenas da interface de `UserRepository` no construtor, ao escrever um teste para esta classe, podemos utilizar um `ArrayUserRepository` ao invés de um _repository_ que faz uma persistência em um banco de dados.

Mesmo que a troca de ORM nunca vá acontecer na vida da sua aplicação, as vantagens da abstração podem ser utilizadas em vários outros cenários para o auxilio.

Um outro exemplo que pode ser bem real, é a utilização de um _Decorator Pattern_ para cache:

```php
<?php

final class CacheUserRepository implements UserRepository
{
    private $userRepository;
    private $cache;
    
    public function __construct(UserRepository $userRepository, \Psr\SimpleCache\CacheInterface $cache)
    {
        $this->userRepository = $userRepository;
        $this->cache = $cache;
    }
    
    public function findByEmail(UserEmail $email): ?User
    {
        $cacheKey = 'user-' . (string) $email;
        if ($this->cache->has($cacheKey)) {
            return $this->cache->get($cacheKey)
        }
            
        $result = $this->userRepository->findByEmail($email);
        $this->cache->set($cacheKey, $result);
        return $result;
    }
    
    public function add(User $user): void
    {
        $this->userRepository->add($user);
    }
}
```

Desta maneira o cliente ainda fica sem conhecer a nova implementação de cache, pois a interface continua a mesma.

Espero que isso te ajude de alguma maneira.