+++
date = 2021-01-08T11:14:47Z
description = ""
title = "Gerando senhas seguras e memoráveis"

+++
Senhas são sempre a primeira linha de defesa contra acessos não autorizados a suas informações, mesmo sabendo disso, ter uma senha forte já é difícil, porém pode ficar mais complicado ainda quando o recomendável é ter uma senha exclusiva para cada site. Qualquer pessoa ficaria impressionada se você conseguisse memorizar uma senha como **5uXqBXQJa*6** para cada site que você tenha uma conta.

Com essa limitação, você pode acabar optando utilizar a mesma senha em todos os lugares, mesmo sabendo que se ela for comprometida, provavelmente toda as outras informações também serão. Mas a partir de agora nosso objetivo é tentar ampliar o nosso leque de senhas, porém com senhas seguras (pois de nada adianta decorarmos várias senhas se elas são fracas).

## Memorizando uma senha

Quando falamos em memorizar algo, nós devemos saber que a nossa memória é separada em dois tipos: memoria de curto prazo e memoria de longo prazo, sendo que a de curto prazo é responsável por reter a informação por menos tempo, até que ela seja guardada ou esquecida, já a de longo prazo, é responsável por reter todos os conhecimentos que temos sobre a vida. O desafio para qualquer aprendizado então é estabelecer a informação na memoria de longo prazo.

Se eu te pedisse para decorar o valor **p20wr2310**, talvez você possa repetir algumas vezes o valor mentalmente até achar que fixou, mas é bem provável que depois de um tempo curto, você esqueça. O valor informado repetido várias vezes não vai te ajudar a lembrar de forma mais fácil, pois na verdade o que realmente ajuda é fazer uma rede de conhecimentos.

Pense o seguinte, um conhecimento é como se fosse uma pequena ponte que pode te levar até outro conhecimento, então para se chegar mais rápido a algum lugar, basta construir pequenas pontes durante seu caminho. Se pegarmos o valor que te falei e tentarmos associar ao seguinte:

```txt
p = popOs
20 = versão 20
w = was
r = released
23 = dia 23
10 = mes 10
        
p20wr2310 = popOs versão20 was released dia23 mes10
```

Com este exemplo simples conseguimos entender que para gravar as nossas senhas, devemos seguir com a ideia de associar partes da senha com pequenos conhecimentos. Um ponto que pode nos ajudar mais ainda é fazer associações com informações que você já tem retidas (você não precisa construir pontes que já existem).

## Gerando senhas memoráveis

Já tendo ideia de uma técnica para nos ajudar a memorizar, devemos agora utilizá-la. Então vamos abrir qualquer site que tenha um gerador de senha e pegar alguns exemplos.

```txt
UZJ6fbiN
sy0TG14Y
kI6yrO1U
9NxRMHsh
h3eCTCQD
1GX87QWh
aSUHiMdi
bP1nYjL5
cp8xsO0k
WMiSe514
OMCxZfW0
wMdKxpFP
UECDT2np
FM9jI0eX
ChKbChRz
```

Se você pegar qualquer uma dessas senhas, igual no começo do exemplo que eu dei, elas não fazem nenhum sentido, mas como já temos uma técnica então teoricamente basta associar este valor a uma rede de conhecimento. Porém, agora temos uma outra barreira, imaginar uma rede de conhecimentos para uma senha que foi gerada agora. Para nos ajudar com este problema temos um software chamado **apg**, que tem como objetivo gerar senhas realmente seguras e que não sejam tão difíceis de lembrar.

O utilitário `apg` está disponível na maioria das distribuições GNU/Linux. Com ele conseguimos gerar várias senhas pronunciáveis e ainda obter um texto similar a nossa técnica de memorização.

Para se gerar uma senha, o utilitário disponibiliza dois algoritmos de geração de senha, além de ter integrado um gerador de números pseudo-aleatórios.

O algoritmo padrão é o algoritmo de geração de senhas pronunciáveis, desenvolvido por **Morrie Gasser**.

Já o segundo algoritmo disponível é um gerador simples de caracteres aleatórios, mas que utiliza quatro conjuntos de símbolos definidos pelo usuário. Isso significa que o usuário pode escolher os tipo de símbolos que devem aparecer na senha. Os conjuntos de símbolos são:  números (0-9), letras maiúsculas (A-Z), letras minúsculas (a-z) e símbolos especiais (#,@,!,...).

Se simplesmente digitarmos `apg` no nosso terminal, teremos um resultado mais ou menos assim:

```txt
➜ apg
Dixfocs'obit8 (Dix-focs-APOSTROPHE-ob-it-EIGHT)
injejEd%3bla (in-jej-Ed-PERCENT_SIGN-THREE-bla)
dofAn^ok4 (dof-An-CIRCUMFLEX-ok-FOUR)
Or:Knett8 (Or-COLON-Knett-EIGHT)
knyisjewv2Ol_ (knyis-jewv-TWO-Ol-UNDERSCORE)
Snev>quiazjog6 (Snev-GREATER_THAN-quiaz-jog-SIX)
```

O resultado já segue o nosso objetivo, pois mostra uma senha forte e um texto que pode vai nos ajudar a memorizar.

Você pode também especificar quantos resultados deseja obter passando o parâmetro `-n` com o valor que deseja.

```txt
➜ apg -n 12   
ewdEtnic
drokhowJid
Lytbukdu
vewdyeann
ishgasVud
HyefBeibs
drinyofKa
Shrejketry
rulEshkIj
JuGhegdo
yocwefAdem
yayftyuol8
```

Agora notamos que o nosso texto de ajuda sumiu, para mostrá-lo junto com outros parâmetros você pode utilizar os parâmetros `-l` ou `-t`, sendo que `-l` mostra o texto com o [alfabeto fonético da OTAN](https://pt.wikipedia.org/wiki/Alfabeto_fon%C3%A9tico_da_OTAN "Texto Alfabeto fonetico da OTAN na wikipedia").

```txt
➜ apg -n 4 -l
redFamNo romeo-echo-delta-Foxtrot-alfa-mike-November-oscar
mocKibr$ mike-oscar-charlie-Kilo-india-bravo-romeo-DOLLAR_SIGN
DiadtaujAr Delta-india-alfa-delta-tango-alfa-uniform-juliett-Alfa-romeo
MeenPef& Mike-echo-echo-november-Papa-echo-foxtrot-AMPERSAND

➜ apg -n 4 -t
DergonUr6 (Derg-on-Ur-SIX)
ayctAin6 (ayct-Ain-SIX)
7OsvuOpnu (SEVEN-Os-vu-Op-nu)
OnJacjeOv (On-Jac-je-Ov)
```

Além dessas opções, você também pode informar quantos caracteres quer que sua senha tenha e quais os conjuntos de símbolos que quer utilizar.

```txt
➜ apg -n 6 -x 10 -M sNcl -l
dresemnen0 delta-romeo-echo-sierra-echo-mike-november-echo-november-ZERO
RapEawm4 Romeo-alfa-papa-Echo-alfa-whiskey-mike-FOUR
CrejSet4 Charlie-romeo-echo-juliett-Sierra-echo-tango-FOUR
Aiswidyop0 Alfa-india-sierra-whiskey-india-delta-yankee-oscar-papa-ZERO
dovFitwuv9 delta-oscar-victor-Foxtrot-india-tango-whiskey-uniform-victor-NINE
Shapjifat0 Sierra-hotel-alfa-papa-juliett-india-foxtrot-alfa-tango-ZERO
```

* `-x` diz quantos caracteres devem ter nossa senha;
* `-M` com o valor `sNcl` diz que deve combinar símbolos/numerais, letras maiúsculas e minúsculas.

Caso tenha alguma duvida você sempre pode obter ajuda utilizando o parâmetro `--help`.

Espero que isso te ajude de alguma maneira.