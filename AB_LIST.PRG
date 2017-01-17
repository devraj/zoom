hide menu main
hide popup all
do printer with 1 in looks
@ 0,1 say"Print Address list" color r/w
define window list from 1,10 to 9,50 double shadow title" Print "
move window list center
activate window list
store 0 to tool
store 1 to devi
@ 0,2 to 6,20 color w/b
@ 0,3 say" Output to: " color w/b
@ 2,4 get devi function'*R Printer;Screen' size 1,10,1
@ 2,24 get tool function'*V Print;Cancel' size 1,10,1
read cycle
if tool=2 .or. tool=0
 clear window all
 close all
 do printer with 0 in looks
 do ctop in looks
 return .t.
endif
if tool=1
 deacti window all
 do print_job in looks
 if devi=1
  set printer to &zoom_printer
 else
  file_name=".\reports\"+sys(3)+".rep"
  set printer to &file_name
 endif
 set printer on
 set device to printer
 set console off
 use &data\abook shared
 go top
 store 61 to line
 store 1 to page
 store "----------------------------------------------------------------------------------------" to _lbreak
 do while .not. eof()
  if line>60 
   ?space((len(_lbreak)-len(_head(1)))/2)+_head(1)
   ?space((len(_lbreak)-len(_head(2)))/2)+_head(2)
   ?space((len(_lbreak)-len(_head(3)))/2)+_head(3)
   ?space((len(_lbreak)-len(_head(4)))/2)+_head(4)
   ?" "
   ?"                           LIST OF ADDRESS BOOK ENTRIES           PAGE -> "+str(page,2)
   ?_lbreak
   ?"Name of the member            | CITY                  |  Telephone "
   ?"                              |                       | "
   ?_lbreak
   line=8
  endif
  ?Ab_NAME+"| "+AB_CITY+"  | "+AB_TEL
  line=line+1
  SKIP
  if line>60
   ?_lbreak
   page=page+1
   EJECT
  endif
 enddo
 ?_lbreak
 eject
 set printer to lpt1
 set printer off
 set device to screen
 set console on
 deacti window printer
 set color to g+/b+,w+/bg+
 if devi=2
  deacti window all
  define window list from 2,5 to 21,75 system title" Address list " color scheme 11
  activate window list
  modi comm &file_name noedit window list
  deacti window list
  delete file &file_name
 endif
 deacti window all
 clear window all
 close all
 do printer with 0 in looks
 do ctop in looks
 return .t.
endif