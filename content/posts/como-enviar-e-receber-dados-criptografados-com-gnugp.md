+++
date = 2021-01-09T20:48:05Z
description = ""
draft = true
title = "Como enviar e receber dados criptografados com GnuGP"

+++
Se importar com a segurança de seus dados é um hábito que todos deveríamos cultivar, principalmente quando falamos de trafegar informações sensíveis. Precisamos saber proteger as informações privadas e tentar garantir que esses dados não sejam lidos por pessoas erradas.

Para começarmos a lidar um pouco com essa segurança de dados podemos utilizar o [GNU Privacy Guard (GnuPG ou GPG)](https://www.gnupg.org/), que é uma implementação do OpenGP que nos permite criptografar, descriptografar e assinar dados.

O GPG utiliza um método de duas chaves, sendo uma pública e a outra privada. Desta maneira uma pessoa criptografa um dado com uma chave pública e este dado só pode ser descriptografado utilizando a chave privada. Isto se chama [Criptografia assimétrica](https://pt.wikipedia.org/wiki/Criptografia_de_chave_p%C3%BAblica).

Exemplificando, vamos imaginar que você queira me enviar uma mensagem criptografada, para isto você precisa ter a minha chave pública. Tendo a chave, você irá criptografar a mensagem para aquela chave, então, somente eu que tenho a chave privada consigo descriptografar.

## Gerando uma chave

Entendendo os conceitos, agora precisamos aplicá-los, o primeiro passo é gerar uma chave utilizando o GPG.

É bem provável que você já tenha o software instalado em sua máquina linux, mas caso não tenha, para instalar (no Ubuntu), basta digitar:

```sh
sudo apt-get install gnupg
```

Para gerar a chave é bem simples, basta digitar no terminal `gpg --gen-key`, com isto o software irá pedir **seu nome**, **email** e uma **senha** para a chave privada.

``` txt
➜ gpg --gen-key
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

GnuPG needs to construct a user ID to identify your key.

Real name: Marcos Felipe
Email address: omarkdev@gmail.com
You selected this USER-ID:
    "Marcos Felipe <omarkdev@gmail.com>"

Change (N)ame, (E)mail, or (O)kay/(Q)uit? O
```

É importante preencher o nome e o email corretamente, pois servem como identificação para a sua chave.

> O ponto que temos que ter mais atenção é a senha que você utiliza, pois ela é a parte mais vulnerável desta implementação, então escolha com sabedoria uma senha forte. Caso você tenha dúvidas como ter uma senha que seja fácil de memorizara e também seja forte, recomendo a leitura do [post Gerando senhas seguras e memoráveis](/posts/gerando-senhas-seguras-e-memoraveis/).

Logo após preenchermos essas informações, iremos obter uma mensagem que diz que o software está gerando nossas chaves. Uma boa ideia é manter o sistema ocupado fazendo outras ações (como utilizar mouse e teclado, abrir conteúdos, etc), pois isto ajuda a "gerar ruído" e aumenta a complexidade das suas chaves.

Depois de gerado é bem provável que tenhamos uma resposta mais ou menos assim:

```txt
gpg: key 1EAAFF57B330604D marked as ultimately trusted
gpg: revocation certificate stored as '/home/omarkdev/.gnupg/openpgp-revocs.d/86327B7DC506B95BBAC39C6A1EAAFF57B330604D.rev'
public and secret key created and signed.

pub   rsa3072 2021-01-09 [SC] [expires: 2023-01-09]
      86327B7DC506B95BBAC39C6A1EAAFF57B330604D
uid                      Marcos Felipe <omarkdev@gmail.com>
sub   rsa3072 2021-01-09 [E] [expires: 2023-01-09]
```

Desta maneira, já temos as nossas chaves que estão prontas para serem utilizadas.

## Lidando com as chaves públicas

Como já sabemos, para criptografar um arquivo, a pessoa precisa ter a chave pública do recipiente (quem vai conseguir descriptografar), então precisamos obter a nossa chave pública para poder compartilhar.

Para exportar a nossa chave pública é bem simples, basta digitar o comando:

```sh
gpg --armor --export seu-email > minha-chave-publica.asc
```

Substitua o `seu-email` para o email que você informou ao gerar a chave. Por isso é de extrema importância que você digite as informações corretamente ao gerar uma chave, pois este email está associado a esta chave. A partir de agora em quase todas as operações iremos utilizar o email como identificador da chave.

Além disso, você pode substituir o `minha-chave-publica.asc` para qualquer nome de arquivo que queira que a sua chave seja exportada.

Após rodar este comando, você deve ter um arquivo chamado `minha-chave-publica.asc` na pasta em que você rodou o comando, para ver o conteúdo basta digitar `cat minha-chave-publica.asc`.

```txt
➜ cat minha-chave-publica.asc 
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQGNBF/6BGYBDADG0gpaxvI9Ep5vVJu2lclaaZT162yfAtIgoQRlZLCMqUwisV88
joXMTOFiNkCGJGgQtsfnoaCI8nJoNB5dE8OOKGvFZLKOgTnBWpzLv8lfURSfsfQX
pZMFwJSG5XnmX82KcAZ+9jovDf1oZYqZvaREnDUeTZgmj4LkoIXx4jAT9WV1w6k8

...

2bV5SPdSa6QgHNbn5/BTN/eMgmVAAjgOjMfcJy9Pio/gAe40AcBwiX0hn6cZBO0f
jTnVE5lLUkTVjWqfid8lbDxf/H7MDc6CILKE47fu5y5d9dQC4LP4Fk2iGzhF5cvy
9N2voY4ajpsZgp/iJX2BThKYVj7ZNfHlL5M=
=4yri
-----END PGP PUBLIC KEY BLOCK-----
```

Este arquivo é a sua chave pública, então você pode enviar para qualquer pessoa que você deseja que consiga te enviar uma mensagem criptografada.

### Importando chaves públicas

Bom, mas também existe o outro lado da moeda, você pode ser a pessoa que queira criptografar uma mensagem para alguém, então precisamos saber como lidar com a chave pública de outra pessoa.

Existem muitos sites que armazenam chaves públicas (que as pessoas enviam), como o [pgp.mit.edu.br](https://pgp.mit.edu/), [keybase.io](https://keybase.io/), entre outros. A pessoa pode colocar a chave ali e você pesquisar, ou ela pode simplesmente te mandar.

Vamos imaginar que você já tenha o arquivo `fulano.asc`  que é a chave de **Fulano** em sua máquina. Para importar esta chave, basta rodar o comando:

```sh
gpg --import fulano.asc
```

Sendo que `fulano.asc` é o nome do arquivo que contém a chave a ser importada.

Com isto temos uma mensagem de sucesso mais ou menos assim:

```txt
gpg: key C3512E03DBE289D7: public key "Fulano <fulano@gmail.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

Caso você queira saber todas as chaves públicas que você tem importadas em sua máquina, basta digitar o comando:

```sh
gpg --list-keys
```

Pronto, agora já podemos utilizar as chaves para criptografar alguma mensagem.

## Criptografando e descriptografando arquivos

Depois de todo esse percurso de gerar chave, exportar e importar chave pública, vamos para o mais interessante: criptografar um arquivo.

Primeiro vamos criar o nosso arquivo que sera criptografado, algo bem simples, para apenas exemplificar.

```sh
echo 'Top secret message!' > message.txt
```

Temos um arquivo `message.txt` que tem o conteúdo `Top secret message!`.

Para criptografar este arquivo, é bem simples:

```sh
gpg -e -r fulano@gmail.com message.txt
```

Substitua `fulano@gmail.com` para o email que está associado a chave pública que você importou, e `message.txt` com o nome do arquivo que deseja criptografar.

Pode ser que o software peça para você confirmar que deseja utilizar esta chave, basta confirmar.

Após executar esse comando é bem provável que você tenha um arquivo `message.txt.gpg` na sua pasta (ou qualquer nome que tenha seu arquivo utilizado, acrescentando `.gpg` no final). Com isso, já podemos remover o antigo arquivo.

```sh
rm message.txt
```

Se olharmos o conteúdo do novo arquivo, veremos algo mais ou menos assim:

![](/uploads/2021/01/09/screenshot-from-2021-01-09-17-49-25.png)

Pronto! Temos o nosso arquivo criptografado que pode ser enviado para a pessoa responsável por aquela chave pública.

Mas agora e se formos a pessoa que recebe a mensagem, precisamos saber ler o conteúdo do arquivo.

Para descriptografar o arquivo é bem simples, mas antes saiba que você precisa ter a chave privada. Se já temos, execute:

```sh
gpg -d message.txt.gpg > message.txt
```

Ao executar este comando, o software irá perguntar a senha daquela chave privada, que é a senha que você digitou ao gerar as chaves.

Com isso temos o arquivo `message.txt` na nossa pasta com o conteúdo descriptografado.

```txt
➜ cat message.txt
Top secret message!
```

É importante notar que na hora de descriptografar não foi perguntado nenhum email, pois o arquivo já tem a assinatura da chave responsável por aquele arquivo. Se você tentar descriptografar um arquivo que você não tem a chave privada, você irá receber uma mensagem mais ou menos assim:

```txt
gpg: encrypted with 3072-bit RSA key, ID 5CC858003CBB6CA2, created 2021-01-09
      "Fulano <fulano@gmail.com>"
gpg: decryption failed: No secret key
```

## Lidando com as chaves privadas

Já compreendido bem como o GPG funciona, podemos concluir que uma das partes mais importantes é a nossa chave privada, pois sem ela não conseguimos ler as mensagens.

Você pode querer exportar a sua chave privada para backup, desta maneira ao trocar de máquina não será necessário gerar uma nova chave (e ter que repassar para todos, etc.). Para fazer isto é bem simples e o comando é bem parecido com o de exportar chave pública, porém é necessário passar alguns parâmetros a mais para conseguir extrair toda a informação necessária para um backup:

```sh
gpg --armor --export-secret-keys --export-options export-backup omarkdev@gmail.com > minha-chave-secreta.asc
```

Ao executar o comando, o software irá pedir a senha associada a chave e logo depois disto irá gerar o arquivo `minha-chave-secreta.asc`.

Para importar o comando é exatamente igual ao de importar chave pública, a única diferença é que o software irá pedir a senha da chave privada.

```sh
gpg --import minha-chave-secreta.asc
```

O interessante é notar que ao importar a chave secreta, você também importa a chave pública, então não é necessário guardar o backup das duas chaves.

Espero que isso te ajude de alguma maneira.