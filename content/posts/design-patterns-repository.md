+++
date = 2021-03-15T19:13:45Z
description = ""
draft = true
title = "Design Patterns: Repository"

+++
O padrão de projeto Repository é um dos mais populares no momento. Eu, particularmente, acredito que é uma ótima escolha adotá-lo na maioria dos cenários, pois ao utilizá-lo, conseguimos centralizar a manipulação dos objetos de domínio além de oferecermos uma abstração para a camada de dados.

## Repository é uma Collection

O jeito mais fácil de entendermos como um Repository funciona é pensarmos nele como uma coleção (Collection) de entidades, desta maneira, sua interface disponibiliza métodos responsáveis para reter e filtrar entidades.

Com esta associação feita, é importante também entendermos que um repository não deve representar nenhuma implementação técnica como por exemplo: armazenamento em banco de dados ou cache.

Uma ótima maneira de pensarmos em _Repositories_ é imaginarmos que sua aplicação está sempre em execução e que os objetos sempre permanecem na memória. 

Vamos imaginar um cenário onde temos um repository chamado `UserRepository` . Pensando em uma _Collection_, podemos ter funcionalidades como: adicionar um novo usuário à coleção, procurar um usuário pelo email ou removê-lo da coleção. É desta maneira que um repositório deve ser desenhado. Transformando o exemplo em código, podemos ter a seguinte interface:

    <?php
    
    interface UserRepository
    {
        public function findByEmail(UserEmail $email): ?User;
        public function add(User $user): void;
    }

Se pegarmos a ideia inicial de pensarmos que os objetos sempre permanecem na memória, podemos ter algo como:

    <?php
    
    final class ArrayUserRepository implements UserRepository
    {
        private $users = [];
    
        public function findByEmail(UserEmail $email): ?User
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

Por isso que se começarmos pensando nesta ideia de uma Collection _in-memory_ fica mais fácil visualizar que a implementação técnica não tem nenhuma relevância para quem utiliza o repository, com isso se trocarmos a implementação para algo como `RedisUserRepository`, pouco importa para quem está apenas lidado com `UserRepository`.

## Repositories genéricos?

Um pensamento que vai se alimentando durante a nossa carreira é o de evitar duplicidade de código, porém muitas vezes é difícil saber se estamos cruzando a linha do _overegineering_ ou se realmente estamos evitando problemas futuros.

É muito provável que se você pesquisar outros posts que falam sobre o Repository Pattern, você encontrará muitos exemplos contendo uma interface genérica para todos os futuros repositories, algo como:

    <?php
    
    interface Repository {
        public function findAll();
        public function add($target);
        public function remove($target);
        public function findById($id);
    }

Logo de cara esse tipo de interface pode parecer que faz sentido, pois que entidade não vai precisar adicionar, remover, ou buscar pelo id? Porém, está errado.

Seguir com está ideia, mesmo que possa aparentar fazer muito sentido, demonstra que a pessoa que irá desenhar a interface do repository de uma entidade não teve tempo para considerar como o cliente irá consumir, ou quais os comportamentos que a entidade realmente precisa. Por exemplo, se iremos fazer apenas um CRUD de Usuários, você realmente acha que a busca por `id` será utilizada? Ou que não será necessário ter uma paginação? São perguntas que ao olharmos para uma implementação mais específica começam a tirar o sentido de repositories genéricos.

## Dificilmente a implementação técnica será alterada

Quando lidamos com abstrações no mundo da orientação à objetos, sempre tem alguém para dizer: "É importante ter abstrações para caso você tenha que trocar a implementação". Isto é realmente verdade, porém você realmente vai trocar de ORM a cada mês? Eu duvido muito.

Em uma aplicação orientada à objetos bem desenhada, um conceito muito central é o encapsulamento.

Ao encapsular um repository, iremos lidar apenas com sua interface, o que pode nos trazer uma imensa vantagem na hora de testarmos nosso código. Imagine o seguinte exemplo:

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

Neste caso temos uma classe responsável por registrar um usuário. Por depender apenas da interface de `UserRepository` no construtor ao escrever um teste para esta classe, podemos utilizar um `ArrayUserRepository` ao invés de um repository que faz uma persistência em um banco de dados.

Mesmo que a troca de ORM nunca vá acontecer na vida da sua aplicação, as vantagens da abstração podem ser utilizadas em vários outros cenários para o auxilio.

Um outro exemplo que pode ser bem real, é a utilização de um Decorator Pattern para cache:

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

Desta maneira o cliente ainda fica sem conhecer a nova implementação de cache, pois a interface continua a mesma.

Espero que isso te ajude de alguma maneira.