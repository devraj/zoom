**********************************************************************
* Backup program for ZOOM v6.1 part of the Suite open source project
* Author: M.Devraj Written on: 12/99
* Open backup program for FoxPro based applications, requires
* a database with the appropriate field with file information
* --------------------------------------------------------------------
* This program is only made to backup .dbf file, without their CDX
* or IDX files, all information about the file will be obtained at
* run time. Designed to run on shared environments
**********************************************************************

hide menu main
hide popup all

* Define the view of the backup system

set color to r/w
set talk off
set safety off
ON KEY LABEL Ctrl+F3 do abort in backup
@ 0,0 to 0,80 clear
@ 0,1 say"Backup System"
do disk with 1 in looks
set color to g+/b+
define window backup from 1,5 to 15,75 double shadow footer " Ctrl+F3 aborts this process "
move window backup center
activate window backup
@ 10,1 to 12,67
@ 0,1 to 9,40
@ 0,41 to 9,67
@ 0,2 say " Status "
@ 0,42 say " File Details "
use zoom.cfg && Open the cfg file for backup drive details
store rtrim(backuppath) to target
use
@ 2,3 say"Source: "+data
if len(target)<15
 @ 3,3 say"Target: "+target
else
 @ 3,3 say"Target: "+substr(target,1,12)+"..."
endif
do disp_stat with 0
@ 7,3 say"Processing:"
@ 2,43 say"Total Records:"
close all
store 0 to rec_pntr,rec_total
rec_pntr=1
use &data\files shared
rec_total=reccount()
go top
do while rec_pntr!=rec_total
 goto rec_pntr
 if backup=.t.
  @ 8,3 say file_des 
  @ 11,3 say "Obtaining database file information"
  fl_name=data+rtrim(file_name)
  bak_name=target+rtrim(file_name)
  
  @ 11,3 say "Duplicating file structure         "
  use &fl_name shared
  @ 3,43 say ltrim(str(reccount()))
  copy structure to &bak_name
  @ 11,3 say "Duplicating records        "
  use &bak_name excl
  append from &fl_name
 endif
 @ 11,3 say "Closing files ...        "
 pcent=int((rec_pntr/rec_total)*100)
 do disp_stat with pcent in backup
 use &data\files shared
 goto rec_pntr
 replace last_back with zoom_date
 rec_pntr=rec_pntr+1
enddo
clear window all
close all
do ctop in looks

* supporting functions for the backup process

* display percentage completed
function disp_stat
para percent
@ 5,3 say ltrim(str(percent))+"% Complete"
return .t.

proc abort
deacti window backup
close all databases
return to main