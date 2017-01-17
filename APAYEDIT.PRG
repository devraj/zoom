HIDE MENU MAIN
HIDE POPUP ALL
SET COLOR TO G+/B+,W+/BG+
@ 0,1 SAY "Agent Price book" COLOR R/W
DEFINE WINDOW EDIT FROM 1,10 TO 8,63 DOUBLE SHADOW TITLE" Agent "
MOVE WINDOW EDIT CENTER
ACTIVATE WINDOW EDIT
use &data\agents shared
store 1 to mchoice
store 0 to tool
@ 1,2 say"Agent :"
define popup scrollopts FROM 0,0 prompt field agn_name MARGIN SCROLL COLOR SCHEME 11
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

IF TOOL=1
 PUBLIC ACODE,ANAME
 STORE AGN_CODE TO ACODE
 STORE AGN_NAME TO ANAME
 CLOSE ALL
 DEACTI WINDOW EDIT
 PDBF=data+"APRICE.DBF"
 PCON=data+"ACOND.DBF"
 DEFINE WINDOW PAY FROM 4,10 TO 20,70 DOUBLE SHADOW TITLE" Price Book "
 ACTIVATE WINDOW PAY
 BOOK=.T.
 COND=.F.
 DO WHILE .T.
  IF BOOK=.T.
   CLEAR GETS
   CLEAR
   SET COLOR TO W+/B+
   STORE 0 TO WIND
   @ 2,2 TO 14,56
   @ 2,2 SAY"³"
   @ 2,3 TO 2,13 CLEAR
   @ 2,13 SAY"À"
   @ 1,2 SAY"³"
   @ 1,13 SAY"³"
   @ 0,2 SAY"ÚÄÄÄÄÄÄÄÄÄÄ¿"
   @ 2,26 SAY"Á"
   @ 1,6 SAY"BOOK"
   SET COLOR TO W/B
   @ 0,14 SAY"ÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1,26 SAY"³"
   @ 1,15 SAY"CONDITIONS"
   SET COLOR TO G+/B+,W+/BG+
   @ 1,56-(LEN(RTRIM(ANAME))) SAY rtrim(ANAME)

   SELECT B
    USE &DATA\WRK_CODE ORDER CODE
   
   SELECT A
    USE &DATA\APRICE SHARED
    COUNT FOR AGN_CODE=ACODE TO NOITMS
   
   IF NOITMS<>0 
    DIMEN ITMS(NOITMS,3)
    GO TOP
    SET ORDER TO ACODE
    SEEK ACODE
    STORE 1 TO CNTR
    DO WHILE AGN_CODE=ACODE
     STORE 0 TO TMPVAR
     STORE PRICE TO ITMS(CNTR,2)
     STORE PRICE TO TMPPRICE
     STORE WORKCODE TO TMPVAR
     SELECT B
     SEEK TMPVAR
     STORE TMPVAR TO ITMS(CNTR,3)
     STORE STR(WORK_CODE,2)+"  "+CODE_NAME+" "+STR(TMPPRICE,7,2) TO ITMS(CNTR,1)
     CNTR=CNTR+1
     SELECT A
     SKIP
    ENDDO
    STORE 1 TO mchoice
    @ 3,4 GET mchoice FROM ITMS SIZE 10, 50
   ELSE
    STORE 0 TO mchoice
   ENDIF
   CLOSE ALL DATABASES
   STORE 0 TO XTOOL
   @ 13,6 GET XTOOL FUNCTION'*H Add;Edit;Delete;Back' size 1,10,2
   @ 1,15 GET WIND FUNCTION'*TI ' SIZE 1,10,1
   READ CYCLE
   IF (XTOOL=4 .OR. XTOOL=0) .AND. WIND=0
    DEACTI WINDOW ALL
    CLEAR WINDOW ALL
    CLOSE ALL
    DO CTOP IN LOOKS
    RETURN .T.
    EXIT
   ENDIF
   
   IF XTOOL=1
    DO _PRCADD
   ENDIF

   IF XTOOL=2
    IF MCHOICE=0
     DO ERROR WITH "This option is currently invalid","","Edit"
     LOOP
    ENDIF
    DO _PRCMOD WITH ITMS(MCHOICE,2), ITMS(MCHOICE,1), ITMS(MCHOICE,3)
   ENDIF
   
   IF XTOOL=3
    IF MCHOICE=0
     DO ERROR WITH "This option is currently invalid","","Delete"
     LOOP
    ENDIF
    DO _PRCDEL WITH ITMS(MCHOICE,3)
   ENDIF
   
   IF WIND=1
    BOOK=.F.
    COND=.T.
    LOOP
   ENDIF
  ENDIF

  ****************** CONDITIONS 

  IF COND=.T.
   CLEAR GETS
   CLEAR
   SET COLOR TO W+/B+
   STORE 0 TO WIND
   @ 2,2 TO 14,56
   SET COLOR TO W+/B+,W+/BG+
   @ 2,13 TO 2,25 CLEAR
   @ 2,13 SAY"Ù"
   @ 1,13 SAY"³"
   @ 0,13 SAY"ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1,26 SAY"³"
   @ 2,26 SAY"À"
   @ 1,15 SAY"CONDITIONS"
   SET COLOR TO W/B
   @ 1,2 SAY"³"
   @ 0,2 SAY"ÚÄÄÄÄÄÄÄÄÄÄ"
   @ 1,6 SAY"BOOK"
   @ 1,56-(LEN(RTRIM(ANAME))) SAY rtrim(ANAME)
   STORE 0 TO WIND
   @ 1,6 GET WIND FUNCTION'*TI ' SIZE 1,4,1
   SET COLOR TO G+/B+,W+/BG+
   USE &DATA\ACOND SHARED  
   *********************************
   COUNT FOR AGN_CODE=ACODE TO _XREC
   if _xrec=0
    USE
    STORE 0 TO CHOICE
   ELSE
    STORE 1 TO CHOICE, CNTR
    DIMEN _OPTS(_xrec,2)
    STORE "" to _CNDSTR
    GO TOP
    DO WHILE .NOT. EOF()
     IF AGN_CODE=ACODE
      _CNDSTR="WCD="+STR(WORK_CODE,2)+" "+VARIABLE+" "+CONDITION+" "
      IF EMPTY(DAT_VALUE)
       _CNDSTR=_CNDSTR+STR(NUM_VALUE,10)
      ELSE
       _CNDSTR=_CNDSTR+DTOC(DAT_VALUE)
      ENDIF
      _CNDSTR=_CNDSTR+" PRICE="+STR(WORK_PRICE,10,2)
      STORE _CNDSTR TO _OPTS(CNTR,1)
      STORE RECNO() TO _OPTS(CNTR,2)
      CNTR=CNTR+1
     ENDIF
     SKIP
    ENDDO
    USE
    @ 3,4 GET choice FROM _OPTS SIZE 10, 51
   ENDIF
   *********************************
   STORE 0 TO YTOOL
   @ 13,10 GET YTOOL FUNCTION'*H Add;Delete;Back' size 1,10,5
   READ CYCLE
   IF WIND=1
    COND=.F.
    BOOK=.T.
    LOOP
   ENDIF
   IF YTOOL=0 .OR. YTOOL=3
    CLEAR WINDOWS ALL
    CLOSE ALL
    DO CTOP IN LOOKS
    RETURN .T.
    EXIT
   ENDIF
   IF YTOOL=1
    DO _CNDADD
   ENDIF
   IF YTOOL=2
    IF CHOICE=0
     DO ERROR WITH "This option is currently unavailable","","Error"
     LOOP
    ENDIF
    DO _CNDDEL WITH _OPTS(CHOICE,2)
   ENDIF
  ENDIF
 ENDDO
ENDIF


********** procedures for pricing

proc _prcadd
deacti window pay
define window _add from 1,10 to 9,60 double shadow title" Add " color scheme 2
move window _add center
activate window _add

do while .t.
 clear gets
 @ 1,2 say"Item :"
 store 0 to add_prc
 CLOSE ALL
 SELECT A
  use &data\wrk_code shared
  set order to code
 
 SELECT B
  use &data\aprice shared
  set order to wcode,acode
  
 set color to g+/b+,w/bg+
 SELECT A
 store 1 to Xmchoice
 define popup scrollopts FROM 0,0 prompt field str(work_code,2)+" "+code_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 GET Xmchoice POPUP scrollopts SIZE 3, 33
 @ 2,37 say"Price :"
 @ 3,37 GET ADD_PRC PICT'9999.99' when check()
 @ 5,1 to 5,47 color w/b
 store 0 to add_tool
 @ 6,12 get add_tool function'*H Add;Cancel' size 1,10,4 color scheme 11
 READ cycle
 if add_tool=2 .or. add_tool=0
  CLOSE ALL
  DEACTI WINDOW _ADD
  ACTIVATE WINDOW PAY
  return .t.
 endif
 if add_tool=1
  store work_code to wrk
  SELECT B
  locate for workcode=wrk .and. agn_code=acode
  if .not. found()
   append blank
   replace workcode with wrk
   replace agn_code with acode
   replace price with add_prc
  endif
 endif
enddo

**************** delete process
proc _prcdel
parameter itcd_del
store 0 to confirm
do confirm in looks
if confirm=1
 use &data\aprice shared
 set order to wcode,acode
 locate for workcode=itcd_del .and. agn_code=acode
 if found()
  delete
 else
  do error with "The Link for this record has already","been remvoed","Alert !"
 endif
endif
CLOSE ALL
ACTIVATE WINDOW PAY
RETURN .T.

**************** EDIT PRICES
proc _prcmod
parameter mod_prc,mod_desc,mod_code
define window _mod from 1,10 to 7,60 double shadow title" Modify " color scheme 2
move window _mod center
activate window _mod
set color to g+/b+,w+/bg+
@ 1,2 say "Change price to : Rs. "get mod_prc pict'9999.99'
@ 3,1 to 3,47 color w/b
store 0 to mod_tool
store 0 to mod_tool
@ 4,12 get mod_tool function'*H Edit;Cancel' size 1,10,4 color scheme 11
READ cycle
if mod_tool=2 .or. mod_tool=0
 close all
 deacti window _mod
 activate window pay
endif
if mod_tool=1
 use &data\aprice shared
 set order to wcode,acode
 locate for workcode=mod_code .and. agn_code=acode
 if found()
  replace price with mod_prc
 else 
  do error with "The record link is missing","cannot complete your request","Alert"
 endif
 close all
 deacti window _mod
 activate window pay
endif
return .t.

**************** plugin check procedures

proc check
SELECT B
locate for agn_code=acode .and. workcode=A->work_code
if found()
 do error with "This entry already exists","please use the edit option","Error"
 SELECT A
 return .f.
else
 SELECT A
 return .t.
endif


******************************************************************
******************** CONDITIONS PROGRAMING ***********************
******************** PROCEDURE TO CPAYEDIT ***********************
******************************************************************

******** PROCEDURE FOR ADDITION
proc _cndadd
do while .t.
 clear gets
 rele _vararr, _varcond
 dimen _vararr(6), _varcond(6)
 store "QUANTITY" to _vararr(1)
 store "WORKCODE 1" to _vararr(2)
 store "WORKCODE 2" to _vararr(3)
 store "WORKCODE 3" to _vararr(4)
 store "DATE" to _vararr(5)
 store "ALL WCD" to _vararr(6)
 store "Less than" to _varcond(1)
 store "Less than & equal to" to _varcond(2)
 store "Equal to" to _varcond(3)
 store "Greater than & equal to" to _varcond(4)
 store "Greater than" to _varcond(5)
 store "Not equal to" to _varcond(6)
 define window cond from 1,10 to 18,70 double shadow title " Condition addition Wizard "
 move window cond center
 activate window cond
 store 1 to _chv,_chc
 store ctod('  /  /    ') to dt_var
 store 0 to wcod,num, st_prc, mchoice, tool
 use &data\wrk_code shared
 set order to code
 define popup scrollopts FROM 0,0 prompt field str(work_code,2)+" "+code_name MARGIN SCROLL COLOR SCHEME 11
 @ 2,2 say"FOR WORK CODE = "
 store 1 to mchoice
 @ 1,20 GET mchoice POPUP scrollopts SIZE 3, 35
 @ 5,2 say"A"
 @ 6,2 say"N"
 @ 7,2 say"D"
 @ 5,4 get _chv from _vararr size 3,15  color scheme 11
 @ 5,21 get _chc from _varcond size 3,27 when wone(_chv) color scheme 11
 @ 6,49 say"ÄÄÄÄÄÄ¿"
 @ 7,55 say"³"
 @ 8,55 say"Ù"
 @ 8,30 say"AWAITING FIELD CHOICE" color w/b
 @ 10,2 say "Work code    Quantity     Date"
 @ 11,6 get wcod pict'99' disabled
 @ 11,17 get NUM pict'9999' disabled
 @ 11,27 get dt_var pict'99/99/9999' disabled
 @ 9,1 to 12,12 
 @ 9,14 to 12,23
 @ 9,25 to 12,39
 @ 10,43 say"SET PRICE TO"
 @ 11,43 get st_prc pict'9999999.99'
 @ 14, 16 get tool function'*H Add;Cancel' size 1,10,6
 read cycle
 if tool=0 .or. tool=2
  DEACTI WINDOW COND
  return .t.
 endif
 if tool=1
  store work_code to wcd
  close all
  use &data\acond
  append blank
  replace work_code with wcd
  replace agn_code with acode
  if _chv=1
   replace variable with "QUANTITY"
   replace num_value with num
  endif 
  if _chv=2
   replace variable with "WCD1"
   replace num_value with wcod
  endif
  if _chv=3
   replace variable with "WCD2"
   replace num_value with wcod
  endif
  if _chv=4
   replace variable with "WCD3"
   replace num_value with wcod
  endif
  if _chv=5
   replace variable with "DATE"
   replace dat_value with dt_var
  endif
  if _chv=6
   replace variable with "WCD"
   replace num_value with wcod
  endif
  do case
   case _chc=1
    repl condition with "<"
   case _chc=2
    repl condition with "<="
   case _chc=3
    repl condition with "="
   case _chc=4
    repl condition with ">="
   case _chc=5
    repl condition with ">"
   case _chc=6
    repl condition with "<>"
  endcase
  if _chv=2 .or. _chv=3 .or. _chv=4 .or. _chv=6
   repl condition with "="
  endif
  replace work_price with st_prc
  use
 endif
enddo

proc wone
param _tmp
@ 8,2 to 8,54 clear
if _tmp=1
 @ 8,19 say"Ú"
 @ 8,20 to 8,54 color w+/b
 show get num enabled
 show get wcod disabled
 show get dt_var disabled
endif
if _tmp=2 .or. _tmp=3 .or. _tmp=4 .or. _tmp=6
 @ 8,7 say"Ú"
 @ 8,8 to 8,54 color w+/b
 show get num disabled
 show get wcod enabled
 show get dt_var disabled
endif
if _tmp=5
 @ 8,29 say"Ú"
 @ 8,30 to 8,54 color w+/b
 show get num disabled
 show get wcod disabled
 show get dt_var enabled
endif
return .t.

PROC _CNDDEL
PARAMETER _RCNO
CLOSE ALL
STORE 0 TO CONFIRM
DO CONFIRM IN LOOKS
IF CONFIRM=1
 USE &DATA\ACOND SHARED
 GOTO _RCNO
 DELETE
ENDIF
RETURN .T.

