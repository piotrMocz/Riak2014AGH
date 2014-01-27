%% DZIESIECIOPUNKTOWA INSTRUKCJA RIAKOWANIA
%% Wymagania: zainstalowane:
%% 1) Erlang (najlepiej dziala z wersja R15B01)
%% 2) Riak (obecna wersja: 1.4.7)
%% 3) riak-erlang-client

%% 1. uruchamiamy vm erlanga  nastepujacym poleceniem:
%% $ erl -pa /home/ubuntu/riak-erlang-client/ebin/ /home/ubuntu/riak-erlang-client/deps/*/ebin/
%% gdzie "/home/ubuntu/riak-erlang-client/" nalezy zastapic wlasna sciezka instalacji klienta


%% 2. sprawdzamy, czy wszystko dziala:
code:which(riakc_pb_socket). 
%% ==>"/home/ubuntu/riak-erlang-client/ebin/riakc_pb_socket.beam"

%% 3. laczymy sie z nodem Riaka:
{ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 10017).
%% ==> {ok,<0.35.0>}

%% 4. sprawdzamy, czy udalo sie polaczyc:
riakc_pb_socket:ping(Pid).
%% ==> pong

%% 5. utworzymy pare obiektow:
MyBucket = <<"test">>.
%% ==> <<"test">>

%% 6. zapiszemy liczbe:
Val1 = 1.
%% ==> 1
Obj1 = riakc_obj:new(MyBucket, <<"one">>, Val1).
%% ==> {riakc_obj,<<"test">>,<<"one">>,undefined,[],undefined,1}
riakc_pb_socket:put(Pid, Obj1).
%% ==> ok

%% 7. string:
Val2 = "two".
%% ==> "two"
Obj2 = riakc_obj:new(MyBucket, <<"two">>, Val2).
%% ==> {riakc_obj,<<"test">>,<<"two">>,undefined,[],undefined,"two"}
riakc_pb_socket:put(Pid, Obj2).
%% ==> ok

%% 8. oraz tuple:
Val3 = {value, 3}.
%% ==> {value, 3}
Obj3 = riakc_obj:new(MyBucket, <<"three">>, Val3).
%% ==> {riakc_obj,<<"test">>,<<"three">>,undefined,[],undefined,{value,3}}
riakc_pb_socket:put(Pid, Obj3).
%% ==> ok


%% 9. pobierzemy te wartosci z powrotem:
{ok, Fetched1} = riakc_pb_socket:get(Pid, MyBucket, <<"one">>).
%% ==> {ok,{riakc_obj,<<"test">>,<<"one">>,
%                <<107,206,97,96,96,96,204,96,202,5,82,28,202,156,255,126,
%                  6,61,121,26,157,193,148,...>>,
%                [{{dict,3,16,16,8,80,48,
%                        {[],[],[],[],[],[],[],[],[],[],[],[],...},
%                        {{[],[],[],[],[],[],[],[],[],[],...}}},
%                  <<131,97,1>>}],
%                undefined,undefined}}

{ok, Fetched2} = riakc_pb_socket:get(Pid, MyBucket, <<"two">>).
{ok, Fetched3} = riakc_pb_socket:get(Pid, MyBucket, <<"three">>).

%% 10. mozemy rowniez uaktualniac obiekty w bazie:
NewVal3 = setelement(2, Val3, 42).
%% ==> {value, 42}
UpdatedObj3 = riakc_obj:update_value(Fetched3, NewVal3).
%% ==> {riakc_obj,<<"test">>,<<"three">>,
%            <<107,206,97,96,96,96,204,96,202,5,82,28,202,156,255,126,
%              6,61,121,26,147,193,148,200,152,...>>,
%            [{{dict,3,16,16,8,80,48,
%                    {[],[],[],[],[],[],[],[],[],[],[],[],[],[],...},
%                    {{[],[],[],[],[],[],[],[],[],[],[[...]|...],[],...}}},
%              <<131,104,2,100,0,5,118,97,108,117,101,97,3>>}],
%           undefined,
%           {value,42}}
{ok, NewestObj3} = riakc_pb_socket:put(Pid, UpdatedObj3, [return_body]).
%% ==> {ok,{riakc_obj,<<"test">>,<<"three">>,
%                <<107,206,97,96,96,96,204,96,202,5,82,28,202,156,255,126,
%                  6,61,121,26,147,193,148,...>>,
%                [{{dict,3,16,16,8,80,48,
%                        {[],[],[],[],[],[],[],[],[],[],[],[],...},
%                        {{[],[],[],[],[],[],[],[],[],[],...}}},
%                  <<131,104,2,100,0,5,118,97,108,117,101,97,42>>}],
%                undefined,undefined}}
