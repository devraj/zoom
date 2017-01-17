hide menu main
hide popup all
@ 0,1 say"Headers and Footers" color r/w
define window chg from 1,0 to 13,60 double shadow title" Header & Footer "
move window chg center
activate window chg
use &data\system shared
@ 1,5 say"Header:"get _head(1) size 1,40,60
@ 2,13 get _head(2) size 1,40,60
@ 3,13 get _head(3) size 1,40,60
@ 4,13 get _head(4) size 1,40,60
@ 6,5 say"Footer:"get _foot(1) size 1,40,60
@ 7,13 get _foot(2) size 1,40,60
@ 9,2 to 9,56 color w/b
store 0 to tool
@ 10,16 get tool function'*H Save;Cancel' size 1,10,5
read cycle
if tool=2 .or. tool=0
 clear window all
 close all
 do ctop in looks
 return .t.
endif
if tool=1
 use &data\system shared
 replace header1 with _head(1)
 replace header2 with _head(2)
 replace header3 with _head(3)
 replace header4 with _head(4)
 replace footer1 with _foot(1)
 replace footer2 with _foot(2)
 clear window all
 close all
 do error with "Your printer headers have been updated","others running nodes have to be restarted","Restart"
 do ctop in looks
 return .t.
endif