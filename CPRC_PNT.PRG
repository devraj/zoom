hide menu main
hide popup all
@ 0,1 say"Print counter price book" color r/w
DEFINE WINDOW EDIT FROM 1,10 TO 8,63 DOUBLE SHADOW TITLE" Catagory "
MOVE WINDOW EDIT CENTER
ACTIVATE WINDOW EDIT
use &data\catagory shared
store 1 to mchoice
store 0 to tool
@ 1,2 say"Catagory :"
define popup scrollopts FROM 0,0 prompt field cat_name MARGIN SCROLL COLOR SCHEME 11
@ 2,2 GET mchoice POPUP scrollopts SIZE 3, 30
@ 2,37 get tool function'*V Load;Cancel' size 1,12,1
READ CYCLE
IF TOOL=0 .OR. TOOL=2
 CLOSE ALL
 DEACTI WINDOW ALL
 CLEAR WINDOW ALL
 DO CTOP IN LOOKS
 RETURN .T.
ENDIF
