---
title: "A questão não é a receita do software e sim os ingredientes"
description: "Programar não é escrever uma receita de bolo?"
date: '2020-04-02T12:13:40.414Z'
draft: false
---

![](./images/paper.jpeg)

É bem provável que quando você começou a estudar programação, seja em uma faculdade, curso online ou pedindo ajuda para alguém, a pessoa responsável por ensinar provavelmente te disse “Programar é como uma receita de bolo, instruções contidas em uma receita”. Se pegarmos a definição de Dasgupta, Papadimitriou e Vazirani, sobre algoritmos, onde diz “algoritmos são procedimentos precisos, não ambíguos, mecânicos, eficientes e corretos”, reforçamos ainda mais essa ideia de estarmos criando sempre receitas.

Vamos imaginar que passamos o dia todo criando CRUD’s em nossa API, basta seguirmos a nossa receita, não é? Afinal, fazer a operação de atualização de um valor é a mesma, certo?

1.  _Crie a rota para que irá atualizar os dados;_
2.  _Adicione a verificação de usuário está autenticado;_
3.  _Valide os dados recebidos na requisição;_
4.  _Busque o registro baseado no valor recebido;_
5.  _Dispare uma exceção caso não encontre nenhum registro;_
6.  _Atualize os valores no banco;_
7.  _Retorne para o usuário que a operação foi concluída com sucesso_.

Graças a receita de 7 passos, podemos construir quase qualquer operação de atualização de um CRUD. Isso não é necessariamente um problema, pois mesmo que você procure outras maneiras de fazer isso, no final sempre irá parecer uma receita. Mesmo este processo sendo o mesmo para a maioria dos casos de CRUD, muitos podem se frustar por sempre estarem seguindo a mesma receita, outros podem até dizer “eu não estou aprendendo nada com isso”.

**A questão nunca foi seguir os passos a passos da nossa receita e sim saber o porquê cada ingrediente está lá. Um grande chefe de cozinha entende o motivo daqueles ingredientes estarem naquela receita.**

Um chefe de cozinha ao se chegar no resultado de uma receita de um prato, provavelmente ele já teve muitas experiências com aqueles ingredientes, pois apenas desta maneira é possível concluir que aquela combinação é algo saboroso. Essa experiência que te da a capacidade de montar uma receita só acontece depois de **muito** teste, pois imagine quantas vezes não foi necessário testar para se chegar as combinações de _páprica, alho e cebola em pó, pimenta-do-reino, salga e tomilho e alecrim_, para se ter um tempero seco para churrasco?

Escrever uma receita é diferente de cozinhar.

No início de nossa carreiras é comum começarmos com atividades simples que seguem um passo a passo. Depois de um tempo fazendo coisas parecidas, começamos a associar o tipo do problema com as possíveis soluções, mas o aprendizado não deve parar ai.

Se você utiliza um framework para gerenciar sua API, provavelmente ele tem um ORM que você usa para salvar seus dados no banco de dados, nenhum problema nisso, mas você sabe se seu ORM segue o padrão Active Record ou Data Mapper? Como seria essa receita com outros ORM’s que seguem um padrão diferente do que o seu ORM segue? Se minha aplicação é basicamente um monte de CRUD, faz sentido eu continuar utilizando meu ORM que é um Data Mapper? São esses questionamentos que importam.

Conforme você for tentando resolver os problemas baseado na sua experiência já associada, você deve ir tentando adicionar novos ingredientes, ou trocar a dosagem, trocar a ordem ou remover um ingrediente. Muitas vezes começamos fritando ovo, mas você já comeu um frango à parmegiana? Então por que não tentar fazer um ovo à parmegiana?

A familiaridade com o resultado é algo extremamente vantajoso, pois você sabe qual deve ser o resultado, então se você mudar algumas coisas, você tem como comparar. Se você cria as _query_ do banco de dados na mão, você pode testar um framework e comparar os quesitos que você já sabe que são importantes, e mesmo que você tenha que refazer, você aprendeu algo novo que pode te ajudar no futuro.

Entender e saber utilizar uma ferramenta vai muito além de ler a documentação, é entender que ela serve para aquele caso e que os benefícios que ela está trazendo valem a pena o preço que você vai pagar. Se você resolve começar a utilizar outra biblioteca que faz gerenciamento de rotas, você pode acreditar que ela é melhor para aquele caso seu, mas você sabe se é melhor para o seu time? Ela resolveu um problema, mas o preço que você pode ter que pegar (ensinando o time, dando manutenções diferentes, migrando outras rotas) pode não valer tanto a pena. Conhecer ferramentas é diferente de se ter um resultado _over engineering_.

Basicamente nossa profissão é resolver problemas com tecnologia, então quando você entende o porque e como utilizar aquele ingrediente para aquele problema, você começa a se tornar um profissional melhor e pronto para resolver mais problemas.

Espero que isso te ajude de alguma forma.

