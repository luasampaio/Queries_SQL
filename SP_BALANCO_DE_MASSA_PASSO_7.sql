USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PASSO_7]    Script Date: 10/08/2021 17:19:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PASSSO_7	  								  *
* OBJETIVO  : Processo gerador do BM										  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO:                                                                 * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PASSO_7]
AS
BEGIN
	CREATE TABLE TEMP_MOVIMENTOS_BM_MERCABEL_SP
	(
		ID_LOCAL	VARCHAR(2)	 NULL,
		NM_ARMAZ	VARCHAR(50)	 NULL,
		B1_TIPO	VARCHAR(2)		 NULL,
		EMPRESA	VARCHAR(20)		 NULL,
		TT_QUANT	INT,
		TT_CUSTO	DECIMAL(12,4),
		DE_QUANT	INT,
		DE_CUSTO	DECIMAL(12,4),
		EM_QUANT	INT,
		EM_CUSTO	DECIMAL(12,4),
		UN_NEGOCIO	VARCHAR(9)		 NULL
	)


	INSERT INTO TEMP_MOVIMENTOS_BM_MERCABEL_SP
	(
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO	,
		EMPRESA	,
		TT_QUANT	,
		TT_CUSTO	,
		DE_QUANT	,
		DE_CUSTO	,
		EM_QUANT	,
		EM_CUSTO	,
		UN_NEGOCIO
	  ) SELECT
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO	,
		EMPRESA	,
		TT_QUANT	,
		TT_CUSTO	,
		DE_QUANT	,
		DE_CUSTO	,
		EM_QUANT	,
		EM_CUSTO	,
		UN_NEGOCIO
	FROM TEMP_MOVIMENTOS_BM_MERCABEL

END