SELECT  T1.TicketID, ticketactualsolutionteam as StartTeam,
T2.EndTeam, T1.Customer,
MIN(CreateTime) AS Data_Inicial
FROM [dbo].FactTicketHistory as T1 

LEFT JOIN (SELECT  T1.TicketID, T1.ticketactualsolutionteam AS EndTeam,
MAX(T1.CreateTime) AS Data_Final
FROM [dbo].FactTicketHistory as T1

WHERE T1.HistoryType = 'StateUpdate' and T1.customer = 'AENA' 
				 group by T1.TicketActualSolutionTeam, T1.TicketID,T1.Customer) T2 on T1.TicketID = T2.TicketID
				 
WHERE T1.HistoryType = 'StateUpdate' and T1.customer = 'AENA' 

group by T1.TicketActualSolutionTeam,t1.TicketID, T1.Customer, T2.EndTeam