hide menu main
hide popup all
if .not. file('&data\webcat.dbf')
 do file_error in looks
endif
@ 0,1 say"OpenZoom Web Category addition" color r/w
do disk with 1 in looks
define window payment from 1,10 to 8,60 double shadow title" New "
move windows payment center
activate window payment
do while .t.
 clear gets
 store space(30) to p_name
 store 0 to tool,p_typ
 @ 1,3 say"Category : "get p_name pict'@'
 @ 4,1 to 4,46 color w/b
 @ 5,13 get tool function'*H Add;Cancel' size 1,10,4
 read cycle
 if tool=2 .or. tool=0
  deacti window all
  close all
  do disk with 0 in looks
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1
  if empty(p_name)
   do error with "A name is required to start","a web category","Error"
   loop
  endif
  use &data\webcat shared
  go bott
  code=cat_code+1
  append blank
  replace cat_code with code
  replace cat_name with p_name
  use
  loop
 endif
enddo
