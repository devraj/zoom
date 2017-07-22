* about the software
hide menu main
hide popup all
set color to r/w
@ 0,0 to 0,79 clear
@ 0,1 say "About Suite v6.1"
set color to g+/b
define window about from 1,1 to 15,50 double shadow
move window about center
activate window about
@ 1,6 say "ZOOM PhotoLab management Sutie v6.1" color w+/b
@ 3,6 say "       A FreeWare Project of"
@ 4,6 say "      The Photo Makers, Patna"
@ 5,6 say " Web: www.thephotomakers.com/zoom/"
@ 6,6 say "  E-mail: zoom@thephotomakers.com"
@ 8,6 say "          Configured for"
use &data\system shared
store RTRIM(header1) to _header
store space((35-len(_header))/2)+_head to _owner
@ 9,6 say _owner color w+/b
@ 11,1 to 11,46 color w/b
store 1 to mchoice
@ 12,36 get mchoice function'*H Close' size 1,10
read
deacti window all
clear window all
do ctop in looks
return to menu
