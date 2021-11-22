-module(perimeter).

-import (math , [pi/0]).
-export([perimeter/1,start/0]).

perimeter(Form) ->
    case element(1,Form) of
    'square' -> P = element(2,Form) * 4,
                io:fwrite("~w~n",[P]);
                
    'circle' -> P = 2*pi()*element(2,Form),
                io:fwrite("~w~n",[P]);
                
    'triangle' -> P = element(2,Form) + element(3,Form) + element(4,Form),
                  io:fwrite("~w~n",[P])
    end.
   
start() -> 
    % perimeter({square,5}).
    % perimeter({circle,5}).
    perimeter({triangle,5,5,5}).
    % convert({c,100}).