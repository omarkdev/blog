+++
date = 2021-07-30T16:42:05Z
description = ""
draft = true
title = "Código legado é realmente ruim?"

+++
Quando trabalhamos com programação ouvimos falar muito sobre o "código legado", muitas vezes com conotações negativas. 

Como se fosse uma regra não explicita, aprendemos que devemos fugir de qualquer código legado. Todo código legado nos traz tristeza. Todo contato com código legado será uma experiência horrível. Esses pensamentos começam a se enraizar.

### O que é código legado?

  
Antes de qualquer discussão sobre o quanto a experiência com esse projeto pode ser de fato ruim, temos que definir o que é de fato um código legado.

Se você está há algum tempo nesta área já pode ter percebido que cada pessoa tem uma opinião de como seria um **código perfeito**. Podemos cometer o erro de tentar simplificar dizendo que o **código legado é o oposto do código perfeito**, mesmo muitas vezes não sabendo quais as características os códigos precisam ter para ganhar estes títulos.

No livro [Working Effectively with Legacy Code](https://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code), Michael Feathers compartilha conosco o que para ele é a definição de um código legado:

> Código legado é um código sem testes.

Se analisarmos essa definição podemos concluir que um código tem este atributo, pois ao não ter testes, fica difícil entender o que a aplicação consegue fazer e com isto a manutenção fica mais complicada.

Quando não se tem testes, o fato de não conseguirmos de forma clara entender alguns trechos de código é o que torna a manutenção do mesmo mais complicada.

Mas só isto não caracteriza um código legado.

Não adianta muito se o projeto tem testes, mas os testes são horríveis, pode ser que atrapalhem mais do que ajudam. Neste caso ainda podemos ter um cenário de legado.

Vá também existir caso (talvez bem raros) onde o projeto não tem **nenhum teste**, mas ele é tão simples que é possível entende-lo e realizar manutenções sem nenhuma dor de cabeça.

Com estes aspectos podemos tentar uma nova definição.

> Código legado é um código que não estamos confortáveis em mudar.

Agora vamos imaginar um cenário onde você acaba de entrar em uma empresa nova e te pedem para adicionar uma funcionalidade nova no projeto ou simplesmente resolver algum bug. Um desconforto irá surgir neste caso, mesmo que o projeto esteja com boas práticas, bem documentado, com testes, por que você não conhece o projeto.

Conforme você vai estudando o projeto que está bem feito, você acaba se tornando mais confiante e consegue entregar as tarefas necessárias.

Refletindo agora um cenário quase igual, porém com resultado oposto. O desconforto por não conhecer o projeto no começo pode ser o mesmo, mas conforme você vai estudando, você vai tendo grandes dificuldades em realizar as tarefas, pois não tem testes, documentações, boas práticas, etc.

Nestes dois cenários podemos classificar o primeiro projeto como um **código bom** e o segundo como um **código legado**. Então oque mudou de um para outro? O processo de aprendizagem.

Como não conseguimos formular estaticamente as características dos projetos para associá-los em um tipo, pois pode existir testes bons e ruins, documentações boas e ruins, boas práticas em lugares errados, etc. Então o que nos resta é o nosso processo de aprendizagem com o código.

Desta maneira acho que conseguimos complementar nossa definição de código legado.

> Código legado é um código que não estamos confortáveis em mudar e temos dificuldade de entender.

Ao entendermos que uma das partes fundamentais para a classificação do projeto é o **nosso** processo de aprendizagem, conseguimos então entender que esta classificação é um ponto de vista pessoal.

Alguns códigos podem ser um desafio para todas as pessoas da equipe, outros apenas para algumas. Isso não torna nenhuma pessoa mais qualificada que a outra, apenas diz que as coisas são mais complexas do que a classificação de **legado** ou não.

Aprender a lidar com estes códigos que nos causam este desconforto é o ponto essencial, pois eles sempre existirão.

### A experiência

Quase tudo nessa vida é complexo e difícil de classificar. A qualificação do profissional é uma delas. A pessoa pode mandar super bem no teste técnico, entretanto na hora de desempenhar um papel mais especializado, pode ter algumas dificuldades.

Quando falamos desta classificação de profissionais, tentamos enquadrá-los em níveis como: Junior, Pleno e Sênior. Porém, como fazer isso? Talvez a forma mais fácil seja pela experiência.

Um profissional classificado como Sênior possivelmente irá desempenhar um papel de tomada de decisões importantes na equipe, e como ele pode saber o que pode ou não dar certo se ele não errou bastante?

A experiência é o mais importante da nossa carreira.

Decorar vários padrões de projeto, boa práticas, linguagens, não nos torna um profissional mais qualificado, mas aplicá-las e aprender com os mais diversos cenários sim.

As empresas muitas vezes contratam nossa mão de obra para resolver os problemas com a tecnologia, um código que te cause esses sentimentos é um problema da empresa, então como podemos resolvê-los se não aprendermos a lidar com ele?

Se pensarmos que o código é uma forma de entregar valor, podemos extrair muitos aprendizados disto.

Quando eu digo “forma de entregar valor”, quero expandir ainda mais este horizonte.

É fato que se um código funciona, por mais ruim que ele seja, ele está entregando valor para alguém, seja a empresa ou o cliente final. Porém e se abrangêssemos ainda mais as pessoas que podem recebem este “valor”.

Uma pessoa da equipe técnica ao ter contato com este código legado pode tentar extrair algum valor. Se você não sabe técnicas de **_Refactoring_**, este não seria um cenário ideal para tentar aplicar? Se apenas uma parte da equipe se sente desconfortável, não seria um cenário ideal para tentar aprender técnicas de liderança e comunicação para melhorar o projeto e a equipe?

Podemos tentar converter este monstro que é o legado em atitudes que podem nos transformar em profissionais mais qualificados, afinal eles sempre existirão.

Espero que isso te ajude de alguma maneira.