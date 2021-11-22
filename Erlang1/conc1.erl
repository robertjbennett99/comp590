-module(conc1).
-export([solve/0, solve/1]).

solve() ->
    solve(10).

solve(NrMsgs) ->
   Pid1 = spawn(fun() -> process_1() end),
   spawn(fun() -> process_2(Pid1, NrMsgs) end),
   ok.

process_1() ->
   io:format("Process 1 starts.~n"),
   process_1_loop(),
   io:format("Process 1 ends.~n").

process_1_loop() ->
   receive
      {From, {message, More}} ->
         io:format("Process 1 received message ~p.~n", [More]),
         io:format("Process 1 sends message_reply.~n"),
         From ! {self(), {message_reply}},
         if
            More ->
               process_1_loop();
               true ->
                  ok
      end
   end.

process_2_loop(Pid1, MsgNr, NrMsgs) ->
   io:format("Process 2 sends message nr ~p.~n", [MsgNr]),
   More = (MsgNr < NrMsgs),
   Pid1 ! {self(), {message, More}},
   receive
      {Pid1, {message_reply}} ->
         io:format("Process 2 received message_reply.~n"),
         if
            More ->
               process_2_loop(Pid1, MsgNr + 1, NrMsgs);
               true ->
                  ok
      end
   end.

process_2(Pid1, NrMsgs) ->
   io:format("Process 2 starts.~n"),
   process_2_loop(Pid1, 1, NrMsgs),
   io:format("Process 2 ends.~n").