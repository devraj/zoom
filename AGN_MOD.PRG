hide menu main
hide popup all
if .not. file('&data\agents.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,1 say "Edit agent information"
do disk with 1 in looks
set color to g+/b+,w+/bg+
define window agent from 1,10 to 15,70 double shadow title" Edit "
define window chose from 1,10 to 15,65 double shadow title" Edit "
move window chose center
move window agent center
do while .t.
 clear gets
 deacti window agent
 activate window chose
 @ 1,2 say"Agent to edit :"
 store 0 to tool
 store 1 to mchoice
 use &data\agents shared
 set order to name
 define popup scrollopts FROM 0,0 prompt field agn_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 30
 @ 2,36 get tool function'*V Edit;Cancel' size 1,12,1
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
  deacti window chose
  activate window agent
  store agn_code to code,old_code
  store agn_name to ag_nm
  store agn_add1 to add1
  store agn_city to city
  store agn_tel to tel
  store 0 to tool
  store agn_add2 to add2
  use
  @ 1,4 say"Code      :"get code pict'9999' valid code()
  @ 1,22 say "Name : "get ag_nm pict'@!' size 1,26 valid name()
  @ 3,4 say"Address   :"get add1
  @ 4,16 get add2
  @ 6,4 say"City      :"get city pict'@!'
  @ 8,4 say"Telephone :"get tel pict'@!'
  @ 10,1 to 10,56 color w/b
  @ 11,18 get tool function'*H Save;Cancel' size 1,10,4
  read cycle
  if tool=2 .or. tool=0
   deacti window all
   close all
   loop
  endif
  if tool=1
   use &data\agents shared
   set order to code
   seek old_code
   if found()
    replace agn_name with ag_nm
    replace agn_add1 with add1
    replace agn_add2 with add2
    replace agn_city with city
    replace agn_code with code
    replace agn_tel with tel
    if code<>old_code
     do clock in looks
     use &data\agnfile
     replace agent_code with code for agent_code=old_code
     use &data\aprice
     replace agn_code with code for agn_code=old_code
     use
     deacti window clock
    endif
   else
    do error with "Data files are being tampered with","ensure security","Security"
   endif
   use
  endif
 endif
enddo


proc code
use &data\agents shared
set order to code
seek code
if found() .and. code<>old_code
 use
 do error with "This agent code is already in use","please revise the entry"," Error "
 return .f.
else
 use
 return .t.
endif

proc name
if empty(ag_nm)
 do error with "A name must be provided to activate","this agent","Error"
 return .f.
else
 return .t.
endif