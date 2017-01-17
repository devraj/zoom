hide menu main 
hide popup all
@ 0,1 say "Print counter price book" color r/w
do while .t.
 clear gets 
 close all
 DEFINE WINDOW EDIT FROM 1,10 TO 11,63 DOUBLE SHADOW TITLE" Catagory "
 MOVE WINDOW EDIT CENTER
 ACTIVATE WINDOW EDIT
 use &data\catagory shared
 store 1 to mchoice,devi
 store 0 to tool
 @ 1,2 say"Catagory :"
 define popup scrollopts FROM 0,0 prompt field cat_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET mchoice POPUP scrollopts SIZE 3, 30
 @ 2,37 get tool function'*V Print;Cancel' size 1,12,1
 @ 6,2 to 8,49 color w/b
 @ 6,3 say" Device " color w/b
 @ 7,4 get devi function'*RH Printer;Screen' size 1,10,4
 READ CYCLE
 IF TOOL=0 .OR. TOOL=2
  CLOSE ALL
  DEACTI WINDOW ALL
  CLEAR WINDOW ALL
  DO CTOP IN LOOKS
  RETURN .T.
  EXIT
 ENDIF
 if tool=1
  store cat_code to _cat
  store cat_name to _catnm
  close all
  deacti window edit
  do print_job in looks
  if devi=1
   set printer to &zoom_printer
  else
   file_name=".\reports\"+sys(3)+".rep"
   set printer to &file_name
  endif
  if sys(13)="OFFLINE"
   do error with "Your printer is not responding","Ending print job","Error"
   deacti window all
   return .t.
  endif
  set printer on
  set device to printer
  set console off 

  select a
   use &data\cprice shared order wcode
 
  select b
   use &data\wrk_code shared order code
 
  select a
  go top
  store 51 to _lines
  store 1 to _page,_sno
  do while .not. eof()
   if _lines>50
    ?_head(1)
    ?_head(2)
    ?_head(3)
    ?_head(4)
    ?"                                               Page ->"+str(_page,2)
    store "PRICING LIST FOR "+rtrim(_catnm) to _title
    ?space((59-len(_title))/2)+_title
    ?"-----------------------------------------------------------"
    ?"Sno. | Work | Work Name                      | Price (Rs.)|"
    ?"-----------------------------------------------------------"
    store 0 to _lines
    store _page+1 to _page
   endif
   if cat_code=_cat
    store workcode to _tmpwk
    select b
    seek _tmpwk
    if found()
     store code_name to _wnm
    else
     store "N/A"+space(27) to _wnm
    endif
    select a
    ?str(_sno,4)+" | "+str(workcode,4)+" | "+_wnm+" | "+str(price,10,2)+" | "
    store _lines+1 to _lines
    store _sno+1 to _sno
   endif
   if _lines>50 
    eject
   endif
   skip
  enddo
  ?"-----------------------------------------------------------"
  eject
  set printer to lpt1
  set printer off
  set console on
  set device to screen
  deacti window printer
  set color to g+/b+,w+/bg+
  if devi=2
   deacti window all
   define window list from 2,5 to 21,75 system title" Counter price book " color scheme 11
   activate window list
   modi comm &file_name noedit window list
   deacti window list
   delete file &file_name
  endif
  deacti window all
  clear window all
  close all
 endif
enddo


