USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_3]    Script Date: 10/08/2021 17:27:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PROART_PASSSO_3	  						  *
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
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PROART_PASSO_3]
AS
BEGIN

	IF ISNULL(OBJECT_ID('TEMP_RESUMO_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_RESUMO_BM_PROART
	END

	CREATE TABLE TEMP_RESUMO_BM_PROART
	(
		ID_LOCAL	VARCHAR(2)		COLLATE Latin1_General_CI_AI NULL,
		NM_ARMAZ	VARCHAR(50)		COLLATE Latin1_General_CI_AI NULL,
		B1_TIPO		VARCHAR(2)		COLLATE Latin1_General_CI_AI NULL,
		VL_LOCAL	DECIMAL(12,4),
		VL_EM3OS	DECIMAL(12,4),
		VL_CQ		DECIMAL(12,4),
		VL_ALM		DECIMAL(12,4),
		VL_PA		DECIMAL(12,4),
		VL_3OS		DECIMAL(12,4),
		VL_ASSTEC	DECIMAL(12,4),
		VL_REFUGO	DECIMAL(12,4),
		VL_OTS_3OS	DECIMAL(12,4),
		VL_DEV_MP	DECIMAL(12,4),
		VL_DIV		DECIMAL(12,4),
		VL_NCONF	DECIMAL(12,4)
	)


	INSERT INTO TEMP_RESUMO_BM_PROART
	(
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO		,
		VL_LOCAL	,
		VL_EM3OS	,
		VL_CQ		,
		VL_ALM		,
		VL_PA		,
		VL_3OS		,
		VL_ASSTEC	,
		VL_REFUGO	,
		VL_OTS_3OS	,
		VL_DEV_MP	,
		VL_DIV		,
		VL_NCONF	
	  ) SELECT 
		ID_LOCAL	,
		NM_ARMAZ	,
		B1_TIPO		,
		SUM(VL_LOCAL)	AS VL_LOCAL	,
		SUM(VL_EM3OS)	AS VL_EM3OS	,
		SUM(VL_CQ)		AS VL_CQ	,
		SUM(VL_ALM)		AS VL_ALM	,
		SUM(VL_PA)		AS VL_PA	,
		SUM(VL_3OS)		AS VL_3OS	,	
		SUM(VL_ASSTEC)	AS VL_ASSTEC,
		SUM(VL_REFUGO)	AS VL_REFUGO,
		SUM(VL_OTS_3OS)	AS VL_OTS_3OS,
		SUM(VL_DEV_MP)	AS VL_DEV_MP,
		SUM(VL_DIV)		AS VL_DIV	,
		SUM(VL_NCONF)	AS VL_NCONF
		FROM (
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			TT_CUSTO	AS VL_LOCAL	,
			EM_CUSTO	AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,	
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			TT_CUSTO	AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,	
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('01','96')
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			TT_CUSTO	AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,	
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('02','10','11')
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			TT_CUSTO	AS VL_PA	,
			0			AS VL_3OS	,	
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL = '21'
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			(TT_CUSTO+EM_CUSTO)	AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL = '31'
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			TT_CUSTO	AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('51','52') AND B1_TIPO != 'PA'
		UNION ALL
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			TT_CUSTO	AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('32','93','94','53') 
		UNION ALL
			-- TUDO 3º - 31T - 92T + PA 51 E 52
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			EM_CUSTO	AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
		UNION ALL
			-- TUDO 3º - 31T - 92T + PA 51 E 52
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			(EM_CUSTO * -1)	AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('31','92') 
		UNION ALL
			-- TUDO 3º - 31T - 92T + PA 51 E 52
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			TT_CUSTO	AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('51','52') AND B1_TIPO='PA'
		UNION ALL
			-- DEVOLUCAO MP - 92 LOCAL + TERCEIROS
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			(TT_CUSTO+EM_CUSTO)	AS VL_DEV_MP,
			0			AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL = '92'
		UNION ALL
			-- N CONF
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			0			AS VL_DIV	,
			TT_CUSTO	AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('61','62','63','NA','25')
		UNION ALL
			-- DIVERGENCIA (TODO LOCAL - 01,02,10,11,21,96,31,51,52,53,93,94,92,32,61,62,63,25,NA)
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			TT_CUSTO	AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
		UNION ALL
			-- DIVERGENCIA (TODO LOCAL - 01,02,10,11,21,96,31,51,52,53,93,94,92,32,61,62,63,25,NA)
			SELECT
			ID_LOCAL	,
			NM_ARMAZ	,
			B1_TIPO		,
			0			AS VL_LOCAL	,
			0			AS VL_EM3OS	,
			0			AS VL_CQ	,
			0			AS VL_ALM	,
			0			AS VL_PA	,
			0			AS VL_3OS	,
			0			AS VL_ASSTEC,
			0			AS VL_REFUGO,
			0			AS VL_OTS_3OS,
			0			AS VL_DEV_MP,
			(TT_CUSTO * -1)	AS VL_DIV	,
			0			AS VL_NCONF	
			FROM TEMP_MOVIMENTOS_BM_PROART
			WHERE ID_LOCAL IN ('01','02','10','11','21','96','31','51','52','53','93','94','92','32','61','62','63','25','NA')
		) TMP
		GROUP BY ID_LOCAL, NM_ARMAZ, B1_TIPO

	DELETE FROM TEMP_RESUMO_BM_PROART
		WHERE VL_LOCAL + VL_EM3OS + VL_CQ + VL_ALM + VL_PA + VL_3OS + VL_ASSTEC + VL_REFUGO + VL_OTS_3OS + VL_DEV_MP + VL_DIV + VL_NCONF = 0


END
