USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_2]    Script Date: 10/08/2021 17:26:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PROART_PASSSO_2	  						  *
* OBJETIVO  : DROP de tabelas temporarias do BM								  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO:                                                                 * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_2]
AS
BEGIN

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_PROART
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_PROART
	END

	IF ISNULL(OBJECT_ID('TEMP_RESUMO_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_RESUMO_BM_PROART
	END


END
