USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_PASSO_1]    Script Date: 10/08/2021 17:10:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_PASSSO_1	  								  *
* OBJETIVO  : Centralizador do processo gerador do BM						  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO: O resultado das tabelas cridadas são utilizadas por TFEXECBM	  * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
/*
EXEC [SP_BALANCO_DE_MASSA_PASSO_1]
EXEC [SP_BALANCO_DE_MASSA_ANALITICO]
EXEC [SP_BALANCO_DE_MASSA_SINTETICO]
EXEC [SP_BALANCO_DE_MASSA_DROP_TEMP]
--\\taiff.com.br\daihatsu\publico\TORRES\
--D:\BalancodeMassas\
--\\192.168.0.22\BalancodeMassas\
*/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_PASSO_1]
AS
BEGIN
	DECLARE @DT_HOJE CHAR(8)
	SET @DT_HOJE = CONVERT(nvarchar(30), GETDATE(), 112) 

	IF ISNULL(OBJECT_ID('TEMP_SEMAFARO_BM'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_SEMAFARO_BM
	END

	--EXEC [SP_BALANCO_DE_MASSA_PASSO_2] 

	--EXEC [SP_BALANCO_DE_MASSA_PROART_PASSO_2] 

	--EXEC [SP_REL_MOVIMENTO_DIARIO]  @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '01', '3'

	--EXEC [SP_REL_MOVIMENTO_DIARIO_MERCABEL] @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '01'

	--EXEC [SP_REL_MOVIMENTO_DIARIO_ACTION]  @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '02', '3'

	--EXEC [SP_REL_MOVIMENTO_DIARIO_PROART_FILIAIS]  @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '02', '3'
	 
	--EXEC [SP_BALANCO_DE_MASSA_PASSO_3] /* Copia dados analiticos para MERCABEL na tabela de BARUERI */
	
	--EXEC [SP_BALANCO_DE_MASSA_PASSO_4] /* Copia dados analiticos para PROART FILIAL na tabela de EXTREMA */
	
	--EXEC [SP_BALANCO_DE_MASSA_PASSO_5] /* Copia dados analiticos para DAIHATSU na tabela de NACOES UNIDAS */

	--EXEC [SP_BALANCO_DE_MASSA_PASSO_6] /* Copia dados sintetico para DAIHATSU na tabela de BARUERI */
	
	--EXEC [SP_BALANCO_DE_MASSA_PASSO_8] /* Copia dados sintetico para PROART na tabela de EXTREMA */
	
	--EXEC [SP_REL_MOVIMENTO_DIARIO]  @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '02', '3'

	--EXEC [SP_REL_MOVIMENTO_DIARIO_PROART_FILIAIS] @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '03', '3'

	--EXEC [SP_REL_MOVIMENTO_DIARIO_MERCABEL]	@DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '02'

	--EXEC [SP_BALANCO_DE_MASSA_PASSO_7] /* Copia dados sintetico para MERCABEL na tabela de BARUERI */

	--EXEC [SP_REL_MOVIMENTO_DIARIO_PROART] @DT_HOJE, @DT_HOJE, '', 'ZZZZZZZZZ', '  ', '  ', '01', '3'

	--EXEC [SP_BALANCO_DE_MASSA_PASSO_9] /* Consolida dados sinteticos */
	
	CREATE TABLE TEMP_SEMAFARO_BM
	(
		BM_SEMAFARO VARCHAR(1),
		BM_PASTABM VARCHAR(40)
	)
	INSERT INTO TEMP_SEMAFARO_BM (BM_SEMAFARO,BM_PASTABM) VALUES ('X','\\192.168.20.24\EXTREMA\')

END

