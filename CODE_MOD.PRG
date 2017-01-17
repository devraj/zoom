hide menu main
hide popup all
if .not. file('&data\wrk_code.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,1 say "Edit work code"
do disk with 1 in looks
set color to g+/b+,w+/bg+
define window chose from 1,10 to 15,65 double shadow title" Edit "
define window work from 8,15 to 16,65 double shadow title" Edit "
move window work center
move window chose center
do while .t.
 clear gets
 deacti window work
 activate window chose
 @ 1,2 say"Code to edit :"
 store 0 to tool
 store 1 to mchoice
 use &data\wrk_code shared
 set order to code
 define popup scrollopts FROM 0,0 prompt field str(work_code,2)+" "+code_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 33
 @ 2,38 get tool function'*V Edit;Cancel' size 1,12,1
 read cycle
 if tool=0 .or. tool=2
  deacti window all
  clear window all
  close all
  do ctop in looks
  do disk with 0 in looks
  return .t.
 endif
 if tool=1
  store work_code to old_code,code
  store code_name to name
  use
  deacti window chose
  activate window work
  ****
  store 0 to tb
  clear gets
  @ 1,5 say"Code : "get code pict'99' valid code_check()
  @ 3,5 say"Name : "get name valid name()
  @ 5,1 to 5,47 color w/b
  @ 6,13 get tb function'*H Save;Cancel' size 1,10,4
  read cycle
  if tb=2 .or. tb=0
   close all
   loop
  endif
  if tb=1
   if code=0
    do error with "The Work Code is not valid","please revise the entry","Error"
    loop
   endif

   use &data\wrk_code shared
   set order to code
   seek old_code
   repl work_code with code
   repl code_name with name

   if code!=old_code
    set color to r/w
    do clock in looks
    set color to g/b
    use &data\agnfile shared
    replace work1 with code for work1=old_code
    replace work2 with code for work2=old_code
    replace work3 with code for work3=old_code

    use &data\counter shared
    replace work_code1 with code for work_code1=old_code
    replace work_code2 with code for work_code2=old_code
    replace work_code3 with code for work_code3=old_code

    use &data\aprice shared
    replace workcode with code for workcode=old_code

    use &data\cprice shared
    replace workcode with code for workcode=old_code

    use
    deacti window clock
   endif
   use
  endif
  ****
 endif
enddo

proc code_check
use &data\wrk_code shared
set order to code
seek code
if found() .and. code<>old_code
 do error with "This work code is already in use","please revise the entry","Error"
 use
 return .f.
else
 use 
 return .t.
endif

proc name
if empty(name)
 do error with "A name must be given to activate the code","","Error"
 return .f.
else
 return .t.
endif

