hide menu main
hide popup all
if .not. file('&data\webcat.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,1 say "Edit Web category titles"
do disk with 1 in looks
set color to g+/b+,w+/bg+
define window chose from 1,10 to 15,65 double shadow title" Edit "
define window payment from 1,10 to 8,60 double shadow title" Edit "
move windows payment center
move window chose center
do while .t.
 clear gets
 deacti window payment
 activate window chose
 @ 1,2 say"Entry to edit :"
 store 0 to tool
 store 1 to mchoice
 use &data\webcat shared
 set order to code
 define popup scrollopts FROM 0,0 prompt field cat_name MARGIN SCROLL COLOR SCHEME 11
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
  activate window payment
  store cat_code to code
  store cat_name to p_name
  use
  @ 1,2 say"Category : "get p_name pict'@' valid name()
  @ 4,1 to 4,46 color w/b
  @ 5,13 get tool function'*H Edit;Cancel' size 1,10,4
  read cycle
  if tool=2 .or. tool=0
   deacti window payment
   loop
  endif
  if tool=1
   use &data\webcat shared
   set order to code
   seek code
   if found()
    replace cat_name with p_name
   else
    use
    do error with "Data TAG has been deleted","contact for support","Alert"
   endif
   deacti window all
   close all
   loop
  endif
 endif
enddo

proc name
if empty(p_name)
 do error with "The name cannot be blank space","please check","Error"
 return .f.
else
 return .t.
endif
