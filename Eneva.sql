/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  T1.[Customer]
      ,T1.[TicketNumber]
      ,T1.[TicketID]
      ,T1.[ServiceCategory]
      ,T1.[ServiceSubCategory]
      ,T1.[ServiceThirdLevelCategory]
      ,T1.[ServiceFourthLevelCategory]
      ,T1.[ServiceFifthLevelCategory]
      ,T1.[ServiceName]
      ,T1.[Title]
      ,T1.[Description]
      ,T1.[FCRElegible]
      ,T1.[Urgency]
      ,T1.[Impact]
      ,T1.[Priority]
      ,T1.[RegisterAnalyst]
      ,T1.[StartTicket]
      ,T1.[EndTicket]
      ,T1.[TicketWorkStart]
      ,T1.[TicketChanged]
      ,T1.[CustomerLocation]
      ,T1.[CustomerDepartment]
      ,T1.[Owner]
      ,T1.[VipCustomer]
      ,T1.[TypeOfRequirement]
      ,T1.[TicketStatus]
      ,T1.[Resolution]
      ,T1.[TicketSource]
      ,T1.[InitialSolutionTeam]
      ,T1.[ActualSolutionTeam]
      ,T1.[SolverAnalyst]
      ,T1.[SLAonHold]
      ,T1.[TTOGoalSeconds]
      ,T1.[TTOActualSeconds]
      ,T1.[TTRGoalSeconds]
      ,T1.[TTRActualSeconds]
      ,T1.[Contact]
      ,T1.[SupplierTicket]
      ,T1.[ExpiredSLA]
      ,T1.[SLASolutionDueDate]
      ,T1.[SLAFirstReponseDueDate]
      ,T1.[SLAFirstResponseTime]
      ,T1.[SLASolutionTime]
      ,T1.[SolutionTime]
      ,T1.[DeltaResponseTime]
      ,T1.[IsSolutionTimeSLAStoppedCalculated]
      ,T1.[TotalTime]
      ,T1.[TotalResponseTime]
      ,T1.[PercentualScaleSLA]
      ,T1.[PercentualScaleResponseTime]
      ,T1.[agent]
      ,T1.[TotalReopen]
      ,T1.[TicketResolved]
      ,T1.[ServiceSixthLevelCategory]
	  ,T2.AREA AS AREATI
	  ,T2.DiasViolados 
  FROM [dbo].[FactTickets] AS T1 INNER JOIN 
  [dbo].[TicketsViolated] AS T2 ON T1.TicketID=T2.ticket_id 
  WHERE MONTH(T1.StartTicket)=6 AND YEAR(T1.StartTicket)=2021
  AND T1.Customer = 'ENEVA'