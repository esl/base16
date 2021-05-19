%%%-------------------------------------------------------------------
%%% @copyright (C) 2012, Erlang Solutions Ltd.
%%% This file is licensed under GPLv3 license due to using `proper`
%%% See http://www.gnu.org/licenses/gpl-3.0.txt
%%%
%%% @doc Basic tests for base16 module
%%% @end
%%%-------------------------------------------------------------------

-module(base16_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

%%--------------------------------------------------------------------
%% Tests and properties
%%--------------------------------------------------------------------

properties_test() ->
    ?assertEqual([], proper:module(?MODULE, [long_result])).

prop_decode_encode() ->
    ?FORALL(B, binary(),
            B =:= base16:decode(base16:encode(B))).

prop_encode_decode_lowercase() ->
    ?FORALL(H, even_len_binary(hex_lowercase_digit()),
            H =:= base16:encode(base16:decode(H))).

prop_encode_decode() ->
    ?FORALL(H1, even_len_binary(hex_digit()), begin
            H2 = base16:encode(base16:decode(H1)),
            H2 =:= list_to_binary(string:to_lower(binary_to_list(H1)))
    end).

prop_compare_algorithms_encode() ->
    ?FORALL(B, binary(),
            slow_encode(B) =:= base16:encode(B)).

prop_compare_algorithms_decode() ->
    ?FORALL(B, even_len_binary(hex_digit()),
            slow_decode(B) =:= base16:decode(B)).

encode_spec_test() ->
    proper:check_spec({base16, encode, 1}).

decode_spec_test() ->
    proper:check_spec({base16, decode, 1}).

decode_odd_even_length_test() ->
    ?assertEqual(<<>>,            base16:decode(<<"">>)),
    ?assertError(function_clause, base16:decode(<<"0">>)),
    ?assertEqual(<<0>>,           base16:decode(<<"00">>)),
    ?assertError(function_clause, base16:decode(<<"000">>)),
    ?assertEqual(<<0,1>>,         base16:decode(<<"0001">>)),
    ?assertError(function_clause, base16:decode(<<"00010">>)),
    ?assertEqual(<<0,1,2>>,       base16:decode(<<"000102">>)).

dead_beef_test() ->
    ?assertEqual(<<16#DE, 16#AD, 16#BE, 16#EF>>,
                 base16:decode(<<"DeadBeef">>)).

%%--------------------------------------------------------------------
%% Generators
%%--------------------------------------------------------------------

hex_lowercase_digit() ->
    union([integer($0, $9), integer($a, $f)]).

hex_digit() ->
    union([hex_lowercase_digit(), integer($A, $F)]).

even_len_binary(Digit) ->
    ?LET(L, even_len_list(Digit), list_to_binary(L)).

even_len_list(Elem) ->
    ?SUCHTHAT(L, list(Elem), length(L) rem 2 =:= 0).


%%--------------------------------------------------------------------
%% Older algorithm
%%--------------------------------------------------------------------
-spec slow_encode(binary()) -> <<_:_*16>>.
slow_encode(Data) ->
    << <<(hex(N div 16)), (hex(N rem 16))>> || <<N>> <= Data >>.

-spec slow_decode(<<_:_*16>>) -> binary().
slow_decode(Base16) when size(Base16) rem 2 =:= 0 ->
    << <<(unhex(H) bsl 4 + unhex(L))>> || <<H,L>> <= Base16 >>.

hex(N) when N < 10 -> N + $0;
hex(N) when N < 16 -> N - 10 + $a.

unhex(D) when $0 =< D andalso D =< $9 -> D - $0;
unhex(D) when $a =< D andalso D =< $f -> 10 + D - $a;
unhex(D) when $A =< D andalso D =< $F -> 10 + D - $A.
