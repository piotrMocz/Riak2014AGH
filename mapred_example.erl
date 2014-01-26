%% Prosty przyklad map-reduce'a, zaczerpniety ze strony githubowej
%% riak-erlang-client

%% 1. Przygotowanie gruntu:
%% (dodajemy parę obiektów i tworzymy indeksy)
O1 = riakc_obj:new(<<"mr">>, <<"bob">>, <<"Bob, 26">>).

M0 = dict:new().

M1 = riakc_obj:set_secondary_index(M0, {{integer_index,"age"}, [26]}).

O2 = riakc_obj:update_metadata(O1, M1).

riakc_pb_socket:put(Pid, O2).

O3 = riakc_obj:new(<<"mr">>, <<"john">>, <<"John, 23">>).

M2 = riakc_obj:set_secondary_index(M0, {{integer_index,"age"}, [23]}).

M3 = riakc_obj:set_link(M2, [{<<"friend">>, [{<<"mr">>,<<"bob">>}]}]).

O4 = riakc_obj:update_metadata(O3, M3).

riakc_pb_socket:put(Pid, O4).


%% 2. napiszemy funkcje, ktora zwroci calkowity rozmiar w bajtach obiektow w bazie:
RecSize = fun(G, _, _) -> [byte_size(riak_object:get_value(G))] end.

%% 3. wykonamy mapreduce!
{ok, [{N2, R2}]} = riakc_pb_socket:mapred(Pid,
            {index, <<"mr">>, {integer_index, "age"}, 20, 30},
            [{map, {qfun, RecSize}, none, false},
             {reduce, {modfun, 'riak_kv_mapreduce', 'reduce_sum'}, none, true}]).
