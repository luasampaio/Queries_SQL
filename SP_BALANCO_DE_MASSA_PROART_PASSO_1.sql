USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_1]    Script Date: 10/08/2021 17:25:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PROART_PASSO_1	  						  *
* OBJETIVO  : Centralizador do processo gerador do BM						  *
* AUTOR     : Gilberto J.                                                     *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO:                                                                 * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
/*
EXEC [SP_BALANCO_DE_MASSA_PROART_PASSO_1]
EXEC [SP_BALANCO_DE_MASSA_ANALITICO_PROART]
EXEC [SP_BALANCO_DE_MASSA_SINTETICO_PROART]
*/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_1]
AS
BEGIN
	DECLARE @DT_HOJE CHAR(8)
	SET @DT_HOJE = CONVERT(nvarchar(30), GETDATE(), 112) 

	EXEC [SP_BALANCO_DE_MASSA_PROART_PASSO_2] 

	EXEC [SP_REL_MOVIMENTO_DIARIO_PROART] @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '01', '3'

	EXEC [SP_REL_MOVIMENTO_DIARIO_SINTETICO_PROART]  @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '01', '3'

	EXEC [SP_BALANCO_DE_MASSA_PROART_PASSO_3] 
	
END
