# RedesPratica

Este é um trabalho prático para a disciplina de Redes de Computadores. Ele tem o intuito de simular a comunicação entre aplicações utilizando camadas de redes baseadas no modelo OSI, implementadas em diferentes linguagens de programação.


| Camada | Linguagem |
| ------ | ------ |
|  Aplicação | ```PHP``` |
| Rede | ```NodeJS``` |
| Transporte | ```Python``` |
| Física | ```Lua``` |

# Dependências

- Lua Socket (utilizada para trocar pacotes entre computadores na camada física)


### Execução

Iniciar o inteceptador de HTTP (do diretório da aplicação):
```sh
$ php httpClientInterceptor.php
```

Iniciar o servidor da camada física (do diretório do cliente):
```sh
$ lua server.lua
```