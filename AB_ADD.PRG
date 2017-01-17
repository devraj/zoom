hide menu main
hide popup all
if .not. file('&data\abook.dbf')
 do file_error in looks
 return .t.
endif
set color to r/w
@ 0,0 to 0,80 clear
@ 0,1 say"Add new Address"
do disk with 1 in looks
set color to g+/b+
define window agent from 1,10 to 15,70 double shadow title" New "
move window agent center
activate window agent
store space(30) to ag_nm,tel
store space(40) to add1,add2
store space(20) to city
store 0 to tool
do while .not. eof()
 set color to g+/b+,w+/bg+
 store 0 to tool
 clear gets
 @ 1,4 say"Name      :"get ag_nm pict'@!' valid name()
 @ 3,4 say"Address   :"get add1
 @ 4,16 get add2
 @ 6,4 say"City      :"get city pict'@!'
 @ 8,4 say"Telephone :"get tel pict'@!'
 @ 10,1 to 10,56 color w/b
 @ 11,18 get tool function'*H Add;Cancel' size 1,10,4
 read cycle
 if tool=2 .or. tool=0
  clear window all
  close all
  do ctop in looks
  do disk with 0 in looks
  return .t.
  exit
 endif
 if tool=1
  if empty(ag_nm)
   do error with "The Agent code 0 cannot be accepted","please provide a valid code","Error"
   loop
  endif
  use &data\abook shared
  append blank
  replace ab_name with ag_nm
  replace ab_add1 with add1
  replace ab_add2 with add2
  replace ab_city with city
  replace ab_tel with tel
  use
  store space(30) to ag_nm,tel
  store space(40) to add1,add2
  store space(20) to city
  loop
 endif
enddo

proc name
if empty(ag_nm)
 do error with "A name must be provided to store","this record","Error"
 return .f.
else
 return .t.
endif