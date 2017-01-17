set talk off
set color to gr/w
define window autofile from 1,10 to 10,60 double shadow
move window autofile center
activate window autofile
set color to r/w
@ 1,2 say' кФФФП'
@ 2,2 say' Г   Г     Automatic Data file recovery'
@ 3,2 say'ллллллл    Checking & Reparing Database files'
@ 4,2 say'лллмллл'
@ 6,1 to 6,47 color n/w
for i=1 to 47
 @ 7,i say"ў" color w+/w
 wait "" timeout .1
endfor


