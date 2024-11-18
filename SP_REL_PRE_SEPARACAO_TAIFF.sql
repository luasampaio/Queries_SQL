USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_REL_PRE_SEPARACAO_TAIFF]    Script Date: 27/07/2021 14:54:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************  
* PROCEDURE : SP_REL_PRE_SEPARACAO_TAIFF									  *  
* OBJETIVO  : Impressao dos pedidos de venda da ordem de faturamento          *  
* AUTOR     : Carlos Torres                                                   *  
* DATA      : 09/04/2015                                                      *  
* OBSERVACAO: Principal PRW que utiliza TFSEPTAI                              *   
*                                                                             *  
*---------------------------------ALTERACOES----------------------------------*  
* DATA       AUTOR       OBJETIVO                                             *  
*----------- ----------- -----------------------------------------------------*  
* 29/10/2015 CT          Atender CROSS DOCKIN remodelado                      *  
******************************************************************************/  
/*
Modelo de chamada
EXEC [SP_REL_PRE_SEPARACAO_TAIFF] '1','20160201','20160220','3','090143','090184'
*/
ALTER PROCEDURE [dbo].[SP_REL_PRE_SEPARACAO_TAIFF]  
	@C9_MARCA VARCHAR(01),
	@C9_DTLIB_DE VARCHAR(10),
	@C9_DTLIB_ATE VARCHAR(10),
	@C9_ORDSEP VARCHAR(01),
	@COS_INICIO VARCHAR(06),
	@COS_FINAL VARCHAR(06)
AS  
BEGIN 
	/*
	@C9_ORDSEP 
	1 - Sem OS
	2 - Somente com OS
	3 - Todas
	*/
	SELECT 
		 C9_PRODUTO		AS COD_PRODUTO
		 ,B1_DESC		AS DESCRICAO
		 ,C9_QTDLIB		AS QTD_A_SEPARAR
		 ,C9_PEDIDO		AS PEDIDO
		 ,C9_ITEM		AS ITEM_PEDIDO
		 ,C9_DATALIB	AS DT_LIBERACAO
		 ,ISNULL(C9_PRCVEN*C9_QTDLIB ,0) AS VL_DA_OS 
		 ,C9_ORDSEP		AS ORDEM_DE_SEPARACAO
	FROM SC9030 SC9 WITH(NOLOCK)
	INNER JOIN SB1030 SB1 WITH(NOLOCK)
	ON SB1.D_E_L_E_T_=''
	AND B1_FILIAL=C9_FILIAL
	AND B1_COD=C9_PRODUTO
	WHERE SC9.D_E_L_E_T_=''
	AND C9_FILIAL	= '02'
	AND C9_XFIL		= '01'
	AND C9_XITEM	= @C9_MARCA
	AND	(C9_DATALIB>=@C9_DTLIB_DE AND @C9_DTLIB_DE!='' AND C9_DATALIB<=@C9_DTLIB_ATE AND @C9_DTLIB_ATE!='')
	AND (
		(@C9_ORDSEP='1' AND C9_ORDSEP	= '') 
		OR 
		(@C9_ORDSEP='2' AND C9_ORDSEP	!= '') 
		OR 
		(@C9_ORDSEP='3' AND @COS_FINAL != '' AND @COS_INICIO!='' AND C9_ORDSEP>=@COS_INICIO AND C9_ORDSEP<=@COS_FINAL)
		)
	ORDER BY C9_PRODUTO
END

