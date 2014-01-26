#Riak2014AGH

Projekt na zajęcia z Erlanga w roku 2013/2014 (semestr zimowy)

Tematem projektu jest Riak -- NoSQLowa baza danych.

Zainstalujmy Riaka i zbudujmy 5-węzłowy klaster na lokalnej maszynie.


##Instalacja i budowanie

Zależności systemowe wymagane do właściwej instalacji:
`$ sudo apt-get install build-essential libc6-dev-i386 git`

Instalacja wymaga również maszyny wirtualnej Erlanga w wersji co najmniej R15B01, którą można pobrać [tutaj](http://www.erlang.org/download.html).

Gdy mamy już Erlanga to przechodzimy do właściwej instalacji Riaka:

```
$ wget http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.6/riak-1.4.6.tar.gz
$ tar zxvf riak-1.4.6.tar.gz
$ cd riak-1.4.6
$ make all
```

`make all` zbiera wszyskie zależości, więc nie trzeba się o nie później martwić. Może to potrwać kilka chwil.


##Uruchomienie węzłów
Kiedy Riak jest już zbudowany, użyjemy Rebara (narzędzia do pakowania i budowania aplikacji erlangowych). 
Aby zmienić ilość tworzonych węzłów, ustawiamy DEVNODES:

`$ make devrel DEVNODES=5`

Właśnie utworzyliśmy katalog `./dev`, a w nim w `./dev/dev[numer_węzła]`. Każdy z nich zawiera jeden węzeł, więc musimy je wystartować pojedynczo:
```
$ dev/dev1/bin/riak start
$ dev/dev2/bin/riak start
$ dev/dev3/bin/riak start
$ dev/dev4/bin/riak start
$ dev/dev5/bin/riak start
```

Aby sprawdzić, czy węzły działają można wpisać: 

`$ ps aux | grep beam`


##Tworzenie klastra
Połączymy 5 węzłów w 1 klaster za pomocą admin tool:
```
$ dev/dev2/bin/riak-admin cluster join dev1@127.0.0.1
$ dev/dev3/bin/riak-admin cluster join dev1@127.0.0.1
$ dev/dev4/bin/riak-admin cluster join dev1@127.0.0.1
$ dev/dev5/bin/riak-admin cluster join dev1@127.0.0.1
```

Aby nasze zmiany przyniosły efekt musimy odswieżyć plan:

`$ dev/dev1/bin/riak-admin cluster plan`


##Instalacja klienta
```
$ git clone git://github.com/basho/riak-erlang-client.git
$ cd riak-erlang-client
$ make
```

Aby połączyć się z Riakiem, potrzebujesz węzła erlangowego z biblioteką riak-erlang-client (riakc) w ścieżce.

`$ erl -pa $PATH_TO_RIAKC/ebin $PATH_TO_RIAKC/deps/*/ebin`

Dowiesz się, czy zrobiłeś to poprawnie, jeżeli możesz uruchomić poniższą komendę i otrzymać ścieżkę do pliku .beam, zamiast atomu 'non_existing':
`1> code:which(riakc_pb_socket).`

Będąc w shellu, przekaż serwer Riaka do riakc_pb_socket:start_link/2, aby połączyć się i mieć dostęp do klienta:
`2> {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 10017).`

Sprawdź swoje połączenie z serwerem przez ping/1.
`3> riakc_pb_socket:ping(Pid).`


##Prezentacja

Prezentacja, oprócz pliku pdf w repozytorium, znajduje się [tutaj](http://prezi.com/ibh4sdzlmtms/?utm_campaign=share&utm_medium=copy).



###Źródła
Wykorzystano Basho [quickstart](http://docs.basho.com/riak/latest/quickstart/)
oraz
[riak-erlang-client](https://github.com/basho/riak-erlang-client/)
