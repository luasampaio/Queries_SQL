/****** Script for SelectTopNRows command from SSMS  ******/




--INSERT INTO  [dbo].[FactCalls_new]

SELECT distinct 
        'ONS' AS [Customer]
	   ,REPLACE([Node ID - Session ID - Sequence No],'"','') AS  [CallID]
	   ,[Call Start Time]
       ,CONVERT(DATETIME,CONCAT(SUBSTRING([Call Start Time],5,3),' ','1',' ',SUBSTRING([Call Start Time],9,2),' ',SUBSTRING([Call Start Time],11,9)),103)  as CallDate
	   ,REPLACE(REPLACE([CSQ Names],'*',''),'"','') AS [CallQueue]
	   ,REPLACE([Agent Name],'"','') AS [CallAgent]
	   ,REPLACE([Originator DN (Calling Number)],'"','') AS [CallNumber]
	   ,'N/A' AS [CallStatus]
	   ,REPLACE([Queue Time],'"','') as [CallWaitTime]
	   ,REPLACE([Work Time],'"','') as [CallDuration]
       ,CONVERT(DATETIME,CONCAT(SUBSTRING([Call End Time],5,3),' ','1',' ',SUBSTRING([Call End Time],9,2),' ',SUBSTRING([Call End Time],11,9)),103)  as [CallEndedBy]
      ,REPLACE([Contact Disposition],'"','') as [CallDirection]
      ,'' as [CallComments]
      ,'' as [CallRecordPath]
	  
  FROM [stg].[CallsAgent]
  --order by CallDate desc
  where [Called Number] LIKE '%0994268329'

