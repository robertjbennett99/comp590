-module(lists1).


-import(string,[concat/2,len/1]).
-export([minimum/1,minimum/2,maximum/1,min_max/1, start/0]).

minimum([]) -> io:format("can not find minimum of empty list~n");

minimum([Hd|Tl])  -> minimum(Hd, Tl).

minimum(Min, [Hd|Tl]) ->
    case Min < Hd of
        true -> minimum(Min, Tl);
        false -> minimum(Hd, Tl)
    end;

minimum(Min, []) -> 
    io:fwrite("~w~n",[Min]).

maximum([]) -> io:format("can not find max from empty list~n");

maximum([Hd|Tl])  ->
    maximum(Hd, Tl).

maximum(Max, [Hd|Tl]) ->
    case Max > Hd of
    true    -> maximum(Max, Tl);
    false   -> maximum(Hd, Tl)
    end;
                        
maximum(Max, []) -> io:fwrite("~w~n",[Max]).

% min_max(L) -> 
%     io:format("~w,~w", [2, 2]).
%     %min_max(minimum(L), L).
%     %MM = {minimum(L), maximum(L)},
%     %io:fwrite("~w~n", {MM}).



% start() -> 
%     min_max([3,4,5,6,1,2,9,8,7]).