USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM]    Script Date: 26/07/2021 17:11:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA							  *
* OBJETIVO  : Gerar planilha com posicao de estoque e em separacao			  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 28/01/2016                                                      *
*                                                                             *
*           EXPECIFICO PARA EXTREMA - MG                                      *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
* EXEC [SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM] 
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_POSICAO_DE_ESTOQUE_TAIFF_EXTREMA_BM]
	
AS
BEGIN
	DECLARE @CPRODUTOINI VARCHAR(15),
			@CPRODUTOFIN VARCHAR(15),
			@CLOCAL VARCHAR(02)

	SET @CPRODUTOINI='000000000'
	SET @CPRODUTOFIN='400000000'
	SET @CLOCAL='21'
	
	SELECT
		PRODUTO
		,SUM(B2_SALDO) AS SALDO_ATUAL
		,ARMAZEM 
		,SUM(EM_SEPARACAO_NF) AS OS_x_NF
		,SUM(EM_SEPARACAO_PD) AS OS_x_PEDID
		,(SELECT B1_DESC FROM SB1030 SB1 WITH(NOLOCK) WHERE SB1.D_E_L_E_T_='' AND B1_COD=PRODUTO AND B1_FILIAL='02') AS DESCRICAO
		,CONVERT(VARCHAR(20),getdate(),113) AS DATA_HORA
		,ISNULL((SELECT B5_EAN142 FROM SB5030 SB5 WITH(NOLOCK) WHERE B5_COD=PRODUTO AND B5_FILIAL='02' AND SB5.D_E_L_E_T_=''),0) AS EAN_14
	FROM (
		-- Saldo SB2
		SELECT 
			B2_COD AS PRODUTO
			,B2_QATU AS B2_SALDO
			,B2_LOCAL AS ARMAZEM
			,0 AS EM_SEPARACAO_NF
			,0 AS EM_SEPARACAO_PD
		FROM SB2030 SB2 WITH(NOLOCK)
		WHERE B2_FILIAL='02' 
		AND	SB2.D_E_L_E_T_='' 
		AND SB2.B2_LOCAL=@CLOCAL
		AND SB2.B2_COD>=@CPRODUTOINI
		AND SB2.B2_COD<=@CPRODUTOFIN
		AND SB2.B2_QATU != 0
		
		
		UNION ALL
		
		-- Ordem de separação em andamento
		SELECT 
			CB8_PROD AS PRODUTO
			,0 AS B2_SALDO
			,CB8.CB8_LOCAL AS ARMAZEM
			,(CASE WHEN CB7_NOTA !='' THEN CB8_SALDOS ELSE 0 END) AS EM_SEPARACAO_NF
			,(CASE WHEN CB7_NOTA = '' THEN CB8_SALDOS ELSE 0 END) AS EM_SEPARACAO_PD
		FROM CB8030 CB8 WITH(NOLOCK)
		INNER JOIN CB7030 CB7 WITH(NOLOCK)
		ON CB7_FILIAL=CB8_FILIAL
		AND CB7_ORDSEP=CB8_ORDSEP
		AND CB7.D_E_L_E_T_=''
		AND CB7_DTEMIS>='20190101'
		AND CB7_STATUS!='9'
		WHERE CB8_FILIAL='02'
		AND CB8.D_E_L_E_T_=''
		AND CB8.CB8_LOCAL = @CLOCAL
		AND CB8_PROD>=@CPRODUTOINI
		AND CB8_PROD<=@CPRODUTOFIN
		AND CB8_SALDOS != 0
		
	) AS AUX
	GROUP BY PRODUTO, ARMAZEM
	ORDER BY PRODUTO
END
