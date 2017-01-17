hide menu main
hide popup all
if .not. file('&data\wrk_code.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,1 say "Remove work code"
do disk with 1 in looks
set color to g+/b+,w+/bg+
define window chose from 1,10 to 15,65 double shadow title" Remove "
move window chose center
do while .t.
 clear gets
 activate window chose
 @ 1,2 say"Code to remove :"
 store 0 to tool
 store 1 to mchoice
 use &data\wrk_code shared
 set order to code
 define popup scrollopts FROM 0,0 prompt field str(work_code,2)+" "+code_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 33
 @ 2,38 get tool function'*V Remove;Cancel' size 1,12,1
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
  store work_code to wrk_cod
  use
  store 0 to confirm
  deacti window chose
  do confirm in looks
  if confirm=1
   do clock in looks

   use &data\agnfile shared
   delete all for work1=wrk_cod
   delete all for work2=wrk_cod
   delete all for work3=wrk_cod

   use &data\counter shared
   delete for work_code1=wrk_cod
   delete for work_code2=wrk_cod
   delete for work_code3=wrk_cod

   use &data\cprice shared
   delete all for workcode=wrk_cod
   use

   use &data\aprice shared
   delete all for workcode=wrk_cod
   
   use &data\acond shared
   delete all for work_code=wrk_cod
   
   use &data\ccond shared
   delete all for work_code=wrk_cod
    
   use &data\wrk_code shared
   set order to code
   seek wrk_cod
   delete

   close all
   deacti window clock
   close all
   loop
  endif
  close all
  loop
 endif
enddo