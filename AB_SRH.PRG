hide menu main
hide popup all
@ 0,1 say"Search for name" color r/w
do while .t.
 clear gets
 close all
 define window agn from 1,10 to 5,60 double shadow title" Search "
 DEFI WIND SAN FROM 2,10 TO 20,75 PANEL NOCLOSE SHADOW GROW
 move window san center 
 move window agn center
 activate window agn
 store 0 to tool
 store space(30) to ag_nm
 @ 1,3 say"Search For: "get ag_nm pict'@!'
 read
 if empty(ag_nm)
  close all
  clear window all
  do ctop in looks
  return .t.
  exit
 endif
 use &data\abook shared
 set order to name
 set exact on
 seek ag_nm
 store 30 to _cnt
 if .not. found()
  set exact off
  do while .t.
   if _cnt=1
    set exact on
    seek substr(ag_nm,1,1)
    exit
   endif
   seek substr(ag_nm,1,_cnt)
   if found() 
    exit
  else
    _cnt=_cnt-1
   endif
  enddo
  BROW FIEL AB_NAME :H='Name',AB_ADD1 :H='Address', AB_ADD2 :H='Address (contd.)', AB_CITY :H='City', AB_TEL :H='Telephone' NOED NOAP WIND SAN TITL "Search results"  COLO SCHE 10 
  set exact on
  clear window all
  close all
 endif
enddo
