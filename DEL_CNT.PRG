hide menu main
hide popup all
@ 0,1 say"Delete completed counter orders" color r/w
store 0 to confirm
do confirm in looks
if confirm=0 .or. confirm=2
 close all
 clear window all
 do ctop in looks
 return .t.
endif
_update=zoom_date-90
define window del from 1,0 to 9,60 double shadow
move window del center
activate window del
@ 1,4 say"Zoom Suite 6 is now deleting completed counter orders."
@ 2,4 say"Status: Preparing ..."
@ 4,4 to 6,54
use &data\counter shared
_rec=reccount()
_limit=round(_rec/46,0)
_col=5
go top
store 0 to _cntr
@ 2,4 say"Status: Finding and deleting orders ..."
do while .not. eof()
 if delivered=.t. .and. delon<=_update
  delete
 endif
 _cntr=_cntr+1
 if _cntr>=_limit
  @ 5,_col say"þ" color gr+/b+
  store 0 to _cntr
  store _col+1 to _col
 endif
 skip
enddo
@ 2,4 say"Status: Winding up !                       "
close all
deacti window all
clear window all
do ctop in looks
return .t.
