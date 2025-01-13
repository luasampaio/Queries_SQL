select * from sys.sysprocesses 
where db_name(dbid) = 'Vetorh'

use vetorh
select a.* , b.*
  from vetorh.r911srv a, 
	   vetorh.r911sec b
 where a.numsec = b.numsec

select top 10 * from vetorh.r911sec

delete from vetorh.r911srv
where NumSrv = 1000010001
 and numsec = 403