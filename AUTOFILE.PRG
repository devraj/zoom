set talk off
set color to gr/w
define window autofile from 1,10 to 10,60 double shadow
move window autofile center
activate window autofile
set color to r/w
@ 1,2 say' ���Ŀ'
@ 2,2 say' �   �     Automatic Data file recovery'
@ 3,2 say'�������    Checking & Reparing Database files'
@ 4,2 say'�������'
@ 6,1 to 6,47 color n/w
for i=1 to 47
 @ 7,i say"�" color w+/w
 wait "" timeout .1
endfor


