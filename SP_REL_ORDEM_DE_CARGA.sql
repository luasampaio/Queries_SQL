USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_REL_ORDEM_DE_CARGA]    Script Date: 27/07/2021 16:41:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************  
* PROCEDURE : SP_REL_ORDEM_DE_CARGA 										  *  
* OBJETIVO  : Impressao da ordem de carga                                     *  
* AUTOR     : Carlos Torres                                                   *  
* DATA      : 02/08/2013                                                      *  
* OBSERVACAO: Principal PRW que utiliza TFVIEWOC                              *   
*                                                                             *  
*---------------------------------ALTERACOES----------------------------------*  
* DATA       AUTOR       OBJETIVO                                             *  
*----------- ----------- -----------------------------------------------------*  
*                                                                             *  
******************************************************************************/  
ALTER PROCEDURE [dbo].[SP_REL_ORDEM_DE_CARGA]  
	@CNUMOC VARCHAR(10),
	@CFILIAL VARCHAR(2)
AS  
BEGIN  
	SELECT 
		ZC1_FILIAL,
		ZC1_NUMOC,
		ZC1_PEDIDO,
		ZC1_NUMOLD,
		ZC1_FILNOM,
		ZC1_TRANSP+'-'+
		ISNULL((
			SELECT A4_NOME FROM SA4030 SA4 WITH(NOLOCK) WHERE A4_FILIAL=ZC1_FILIAL AND A4_COD=ZC1_TRANSP AND SA4.D_E_L_E_T_	= ''
		),'') AS TRANSPORTE,
		ISNULL((
			SELECT C5_VOLUME1 FROM SC5030 SC5 WITH(NOLOCK) WHERE C5_FILIAL=ZC1_FILIAL AND C5_NUM=ZC1_PEDIDO AND SC5.D_E_L_E_T_	= ''
		),0) AS VOLUME_PEDIDO
	FROM ZC1030 ZC1 WITH(NOLOCK)
	WHERE 
	ZC1_NUMOC		= @CNUMOC
	AND ZC1_FILIAL	= @CFILIAL 
	AND D_E_L_E_T_	= ''
	GROUP BY ZC1_FILIAL, ZC1_NUMOC,	ZC1_PEDIDO,	ZC1_NUMOLD, ZC1_FILNOM,	ZC1_TRANSP
	ORDER BY ZC1_NUMOC, ZC1_PEDIDO
END
