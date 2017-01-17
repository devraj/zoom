hide menu main
hide popup all
if .not. file('&data\abook.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,1 say "Edit addresses"
do disk with 1 in looks
set color to g+/b+,w+/bg+
define window agent from 1,10 to 15,70 double shadow title" Edit "
define window chose from 1,10 to 15,65 double shadow title" Edit "
move window chose center
move window agent center
do while .t.
 clear gets
 close all
 deacti window agent
 activate window chose
 @ 1,2 say"Address to edit :"
 store 0 to tool
 store 1 to mchoice
 use &data\abook shared
 set order to name
 define popup scrollopts FROM 0,0 prompt field ab_name MARGIN SCROLL COLOR SCHEME 11
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
  store ab_name to ag_nm
  store ab_add1 to add1
  store ab_city to city
  store ab_tel to tel
  store 0 to tool
  store ab_add2 to add2
  store recno() to _rec
  use
  @ 1,4 say"Name      :"get ag_nm pict'@!' size 1,26 valid name()
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
   if empty(ag_nm)
    do error with "Address name field cannot be blank","","Error"
    loop
   endif
   use &data\abook shared
   goto _rec
   replace ab_name with ag_nm
   replace ab_add1 with add1
   replace ab_add2 with add2
   replace ab_city with city
   replace ab_tel with tel
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