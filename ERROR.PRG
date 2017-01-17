********************************************
* Common Dialog box for Suite v6 system
* Author: Devraj Mukherjee
* PART OF the OPEN SOURCE PROJECT
********************************************

parameter line1,line2,line3
close all
if len(line1)>len(line2)
 width=len(line1)+6
else
 width=len(line2)+6
endif
if len(line2)=0
 length=7
else
 length=8
endif
set color to gr/w
define window error from 1,1 to length,width double shadow title " &line3 " color scheme 2 IN SCREEN
move window error center
activate window error
set color to n+/w
@ 1,2 say line1
col=width-12
set cursor off
if len(line2)>0
 @ 2,2 say line2
 @ 4,1 to 4,width-4
 @ 5,col say"<  OK  >" color w+/n+
else 
 @ 3,1 to 3,width-4
 @ 4,col say"<  OK  >" color w+/n+
endif
read timeout 10
deacti window error
set cursor on
set color to
set color to g+/b+,w+/bg+
return