hide menu main
hide popup all
if .not. file('&data\wrk_code.dbf')
 do file_error in looks
 return .t.
endif
@ 0,1 say "New Work Code" color r/w
do disk with 1 in looks
set color to g+/b+
define window work from 8,15 to 16,65 double shadow title" New "
move window work center
activate window work
store 0 to cd,tb
cdnm=space(30)
do while .t.
 store 0 to tb
 clear gets
 @ 1,5 say"Code : "get cd pict'99' valid code_check()
 @ 3,5 say"Name : "get cdnm valid name()
 @ 5,1 to 5,47 color w/b
 @ 6,13 get tb function'*H Save;Cancel' size 1,10,4
 read cycle
 if tb=2 .or. tb=0
  close all
  clear window all
  do ctop in looks
  do disk with 0 in looks
  return .t.
  exit
 endif
 if tb=1
  if cd=0
   do error with "The Work Code is not valid","please revise the entry","Error"
   loop
  endif
  use &data\wrk_code shared
  appe blank
  repl work_code with cd
  repl code_name with cdnm
  use
  store 0 to cd,tb
  cdnm=space(30)
  loop
 endif
enddo

proc code_check
use &data\wrk_code shared
set order to code
seek cd
if found()
 do error with "This work code is already in use","please revise the entry","Error"
 use
 return .f.
else
 use 
 return .t.
endif

proc name
if empty(cdnm)
 do error with "A name must be given to activate the code","","Error"
 return .f.
else
 return .t.
endif
