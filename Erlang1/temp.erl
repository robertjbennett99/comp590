-module(temp).

-import (math , [pi/0]).
-export([c2f/1,convert/1,f2c/1]). 

f2c(F) -> 
   C = (F-32)*(5/9), 
   io:fwrite("~w~n",[C]). 
  
c2f(C) ->
    F = (C*(9/5))+32,
    io:fwrite("~w~n",[F]).
    
convert(T) ->
    case element(1,T) of
    'c' -> c2f(element(2,T));
    'f' -> f2c(element(2,T))
    end.
    

