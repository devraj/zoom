hide menu main
hide popup all
set color to r/w
@ 0,1 say "Delete agent information"
set color to g+/b+,w+/bg+
define window chose from 1,10 to 15,65 double shadow title" Remove "
move window chose center
do while .t. 
 close all
 clear gets
 activate window chose
 @ 1,2 say"Agent to remove :"
 store 0 to tool
 store 1 to mchoice
 use &data\agents shared
 set order to name
 define popup scrollopts FROM 0,0 prompt field agn_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 10, 30
 @ 2,36 get tool function'*V Remove;Cancel' size 1,12,1
 read cycle
 store agn_code to ag_cd
 use
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
   do clock in looks
   use &data\agnfile shared
   delete for agent_code=ag_cd
   use &data\agents shared
   set order to code
   seek ag_cd
   delete
   use
  endif
  deacti window all
  close all
  loop
 endif
enddo
