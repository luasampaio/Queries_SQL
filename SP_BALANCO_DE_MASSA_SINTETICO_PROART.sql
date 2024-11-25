USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_SINTETICO_PROART]    Script Date: 10/08/2021 17:31:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_SINTETICO_PROART							  *
* OBJETIVO  : VIsão analitica do Processo gerador do BM						  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO:                                                                 * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_SINTETICO_PROART]
AS
BEGIN
	SELECT * FROM TEMP_RESUMO_BM_PROART
END