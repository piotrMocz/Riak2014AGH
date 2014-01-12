#Riak2014AGH

Projekt na zajęcia z Erlanga w roku 2013/2014 (semestr zimowy)

Tematem projektu jest Riak -- NoSQLowa baza danych.

Zainstalujmy Riaka i zbudujmy 5-węzłowy klaster na lokalnej maszynie.

##Instalacja

Zależności wymagane do właściwej instalacji:
`sudo apt-get install build-essential libc6-dev-i386 git`

Instalacja wymaga również maszyny wirtualnej Erlanga w wersji co najmniej R15B01, którą można pobrać [tutaj](http://www.erlang.org/download.html).

Gdy mamy już Erlanga to przechodzimy do właściwej instalacji Riaka:

```
wget http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.6/riak-1.4.6.tar.gz
tar zxvf riak-1.4.6.tar.gz
cd riak-1.4.6
make all
```

##Prezentacja

Prezentacja, oprócz pliku pdf w repozytorium, znajduje się [tutaj](http://prezi.com/ibh4sdzlmtms/?utm_campaign=share&utm_medium=copy).
