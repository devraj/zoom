hide menu main
hide popup all
if .not. file('&data\catagory.dbf')
 do file_error in looks
 return .t.
endif
@ 0,1 say"Add Counter Pricing Catagory" color r/w
do disk with 1 in looks
define window cat from 1,10 to 7,60 double shadow title" New "
move window cat center
activate window cat
do while .t.
 clear gets
 store space(30) to cat_nm
 store 0 to cat_cd,tool
 @ 1,5 say"Name :"get cat_nm pict'@!' valid name()
 @ 3,1 to 3,47 color w/b
 @ 4,13 get tool function'*H Add;Cancel' size 1,10,4
 read cycle
 if tool=2 .or. tool=0
  deacti window all
  clear window all
  close all
  do ctop in looks
  do disk with 0 in looks
  return .t.
  exit
 endif 
 if tool=1
  use &data\catagory shared
  go bott
  cat_cd=cat_code+1
  append blank
  replace cat_name with cat_nm
  replace cat_code with cat_cd
  use
  loop
 endif
enddo

proc name
if empty(cat_nm)
 do error with "A name is required to start","the pricing catagory","Error"
 return .f.
endif