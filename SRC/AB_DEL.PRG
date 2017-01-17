hide menu main
hide popup all
set color to r/w
@ 0,1 say "Delete address"
set color to g+/b+,w+/bg+
define window chose from 1,10 to 15,65 double shadow title" Remove "
move window chose center
do while .t. 
 close all
 clear gets
 activate window chose
 @ 1,2 say"Address to remove :"
 store 0 to tool
 store 1 to mchoice
 use &data\abook shared
 set order to name
 define popup scrollopts FROM 0,0 prompt field ab_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 30
 @ 2,36 get tool function'*V Remove;Cancel' size 1,12,1
 read cycle
 deacti window all
 if tool=0 .or. tool=2
  clear window all
  close all
  do ctop in looks
  do disk with 0 in looks
  return .t.
 endif
 if tool=1
  deacti window chose
  store 0 to confirm
  do confirm in looks
  if confirm=1
   delete
  endif
  deacti window all
  close all
  loop
 endif
enddo
