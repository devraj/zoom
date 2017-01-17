SET TALK OFF
CLEA
use data\counter order worder
go top
X=0
C=0
do while !eof()
	IF X<>WORDER
		X=WORDER
	ELSE
		? X,ORDDT
WAIT ""
		C=C+1
	ENDIF
	SKIP
ENDDO
? C
	