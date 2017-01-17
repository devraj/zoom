hide menu main
hide popup all
if .not. file('&data\catagory.dbf')
 do file_error in looks
 return .t.
endif
@ 0,1 say"Remove Catagory Title" color r/w
do disk with 1 in looks
define window mod from 1,10 to 15,60 double shadow title" Remove "
move window mod center
do while .t.
 clear gets
 activate window mod
 close all
 use &data\catagory shared
 store 1 to mchoice
 store 0 to tool
 @ 1,2 say"Catagory to remove :"
 define popup scrollopts FROM 0,0 prompt field cat_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 30
 @ 2,34 get tool function'*V Remove;Cancel' size 1,12,1
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
  store cat_code to catagory
  close all
  store 0 to confirm
  deacti window mod
  do confirm in looks
  if confirm=1
   do clock in looks
   use &data\counter shared
   delete for cat_code=catagory 
   
   use &data\cprice shared
   delete
   
   use &data\catagory shared
   set order to cat_code
   seek catagory
   delete
   close all
   
   deacti window clock
  endif
  close all
  loop
 endif
enddo

