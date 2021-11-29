-module(sb).
-compile([export_all]).
-define(EAT,1000).
-define(THINK,1000).

college() ->
    R = spawn_link(?MODULE, report,[]),
    F1 = spawn_link(?MODULE, fork,["fork1",R]),
    F2 = spawn_link(?MODULE, fork,["fork2",R]),
    F3 = spawn_link(?MODULE, fork,["fork3",R]),
    F4 = spawn_link(?MODULE, fork,["fork4",R]),
    F5 = spawn_link(?MODULE, fork,["fork5",R]),
    spawn_link(?MODULE, philosopher,["Socrates", R, F1,F2]),
    spawn_link(?MODULE, philosopher,["Confucius", R, F2,F3]),
    spawn_link(?MODULE, philosopher,["Aristole", R, F3,F4]),
    spawn_link(?MODULE, philosopher,["Homer", R, F4,F5]),
    spawn_link(?MODULE, sphilosopher,["Plato", R, F1,F5]).


%% create philosophers randomly
philosopher(Name, Report, LeftF, RightF) ->
    random:seed(
        erlang:phash2([node()]),
        erlang:monotonic_time(),
        erlang:unique_integer()
    ),
    create_phils( Name, Report, LeftF, RightF ) .

%% create special philosopher
sphilosopher(Name, Report, RightF, LeftF) ->
    random:seed(
        erlang:phash2([node()]),
        erlang:monotonic_time(),
        erlang:unique_integer()
    ),
    create_special_phil( Name, Report, RightF, LeftF ).


%% creates random 4 philos who get the Left fork first then the right
create_phils(Name,Report,LeftF,RightF) ->
    %% thinking state
    reporting(Name,Report,thinking),
    timer:sleep(random:uniform(?THINK)),

    %% hungry state
    reporting(Name,Report,hungry),
    LeftF ! RightF ! {pick,self()},
    receive
        {picked, LeftF} -> reporting(Name, Report, left);
        {picked, RightF} -> reporting(Name, Report, right)
    end,
    receive
        {picked, LeftF} -> reporting(Name, Report, left);
        {picked, RightF} -> reporting(Name, Report, right)
    end,

    %% eating state
    reporting(Name,Report,eating),
    timer:sleep(random:uniform(?EAT)),
    LeftF ! RightF ! {let_go,self()},
    create_phils(Name,Report,LeftF,RightF).


%% create special philosopher who attempts to communicate first with the
%% right fork proccess instead of the left fork
create_special_phil(Name,Report,RightF,LeftF) ->
    %% thinking state
    reporting(Name,Report,thinking),
    timer:sleep(random:uniform(?THINK)),

    %% hungry state
    reporting(Name,Report,hungry),
    RightF ! LeftF ! {pick,self()},
    receive
        {picked, RightF} -> reporting(Name, Report, right);
        {picked, LeftF} -> reporting(Name, Report, left)
    end,
    receive
        {picked, RightF} -> reporting(Name, Report, right);
        {picked, LeftF} -> reporting(Name, Report, left)
    end,

    %% eating state
    reporting(Name,Report,eating),
    timer:sleep(random:uniform(?EAT)),
    RightF ! LeftF ! {let_go,self()},
    create_special_phil(Name,Report,RightF,LeftF).

%%prepares what the Report proccess will print
reporting(Name,Report,Status) ->
    Report ! {Name,Status,self()},
    receive
        {Report,ack} -> ok
    end.

%%Report proccess, receives and prints
report() ->
    receive
        {Name,Status,Pid} ->
            io:format("~s : ~s ~n",[Name,status(Status)]),
            Pid ! {self(),ack},
            report()
    end.


status(Status) ->
    case Status of
        thinking -> "is thinking";
        hungry -> "is hungry";
        eating -> "is eating";
        right -> "got right fork";
        left -> "got left fork";
        on_table -> "on table";
        in_use ->"in use";
        Status -> atom_to_list(Status)
    end.

fork(Name,Report) ->
    receive
        {pick,Pid} ->
            reporting(Name,Report,in_use),
            Pid ! {picked,self()},
            receive
                {let_go,Pid} -> reporting(Name,Report,on_table)
            end,
            fork(Name,Report)
    
    end.