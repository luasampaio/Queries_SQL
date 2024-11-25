USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PASSO_5]    Script Date: 10/08/2021 17:17:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PASSSO_5	  								  *
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
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PASSO_5]
AS
BEGIN
	CREATE TABLE TEMP_ANALITICO_BM_DAIHATSU_SP
	(
		ID_LOCAL	VARCHAR(2)	 NULL,
		NM_ARMAZ	VARCHAR(50)	 NULL,
		B1_TIPO	VARCHAR(2)		 NULL,
		EMPRESA	VARCHAR(20)		 NULL,
		L_T		VARCHAR(1)		 NULL,
		ID_PRODUTO	VARCHAR(15)	 NULL,
		NM_PRODUTO	VARCHAR(50)	 NULL,
		TT_QUANT	INT,
		VL_CUSTO_UN	DECIMAL(12,4),
		TT_CUSTO	DECIMAL(12,4),
		UN_NEGOCIO	VARCHAR(9)		 NULL
	)

	INSERT INTO TEMP_ANALITICO_BM_DAIHATSU_SP
	(
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO	,
		EMPRESA	,
		L_T		,
		ID_PRODUTO	,
		NM_PRODUTO	,
		TT_QUANT	,
		VL_CUSTO_UN	,
		TT_CUSTO	,
		UN_NEGOCIO
	  ) SELECT 
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO	,
		EMPRESA	,
		L_T		,
		ID_PRODUTO	,
		NM_PRODUTO	,
		TT_QUANT	,
		VL_CUSTO_UN	,
		TT_CUSTO	,
		UN_NEGOCIO
	FROM TEMP_ANALITICO_BM_DAIHATSU
END