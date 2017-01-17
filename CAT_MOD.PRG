hide menu main
hide popup all
if .not. file('&data\catagory.dbf')
 do file_error in looks
 return .t.
endif
@ 0,1 say"Edit Catagory Title" color r/w
do disk with 1 in looks
define window mod from 1,10 to 15,60 double shadow title" Edit "
move window mod center
do while .t.
 clear gets
 activate window mod
 close all
 use &data\catagory shared
 store 1 to mchoice
 store 0 to tool
 @ 1,2 say"Catagory to edit :"
 define popup scrollopts FROM 0,0 prompt field cat_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 30
 @ 2,34 get tool function'*V Edit;Cancel' size 1,12,1
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
  deacti window mod
  if rlock()=.f.
   do error with "This record is currently in exclusive use","try this operation later","Error"
   loop
  endif
  cat_nm=cat_name
  cat_cd=cat_code
  define window cat from 1,10 to 7,60 double shadow title" Edit "
  move window cat center
  activate window cat
  store 0 to tool
  @ 1,5 say"Name :"get cat_nm pict'@!' valid name()
  @ 3,1 to 3,47 color w/b
  @ 4,13 get tool function'*H Change;Cancel' size 1,10,4
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
   set order to cat_code
   seek cat_cd
   if found()
    replace cat_name with cat_nm
   else
    do error with "The record reference is missing","Network useage error","Error"
   endif
   use
   deacti window cat
   loop
  endif
 endif
enddo

proc name
if empty(cat_nm)
 do error with "A name is required to start","the pricing catagory","Error"
 return .f.
endif
 





