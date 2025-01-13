SELECT total_worker_time/execution_count AS [Avg CPU Time],
 SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
 ((CASE qs.statement_end_offset
 WHEN -1 THEN DATALENGTH(st.text)
 ELSE qs.statement_end_offset
 END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
order by 1 desc