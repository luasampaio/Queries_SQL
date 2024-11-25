USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_REL_COMRL008_PREVISAO_IMPORTADO]    Script Date: 27/07/2021 16:14:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_REL_COMRL008_PREVISAO_IMPORTADO							  *
* OBJETIVO  : Relatorio gerencial automatico	                   			  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 19/07/2017                                                      *
* OBSERVACAO: Procedure usada pela rotina COMRL008							  * 
*							                                                  *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
* EXEC SP_REL_COMRL008_PREVISAO_IMPORTADO '20170317'						  *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_REL_COMRL008_PREVISAO_IMPORTADO]
		@CDATAPONT		VARCHAR(10)
AS
BEGIN


SELECT
	C1_DATPRF 
	,QT_A_ENTREGAR
	,TT_QT
	,TT_VL
	,ROUND(((QT_A_ENTREGAR*TT_VL)/TT_QT),2) AS TOTAL
	,ORIGEM
	,B1_TIPO
	,C1_ITEMCTA
	,W3_PO_NUM
	,W3_COD_I
FROM 
(
	SELECT 
		W3_DT_ENTR AS C1_DATPRF
		,((W3_QTDE - W3_SLD_ELI) - (ISNULL((SELECT SUM(W7_QTDE)	
											FROM SW7040 SW7 WITH(NOLOCK) 
											WHERE W7_PO_NUM=W3_PO_NUM 
											AND W7_FILIAL=W3_FILIAL 
											AND SW7.D_E_L_E_T_='' 
											AND W7_COD_I=W3_COD_I 
											AND W7_POSICAO=W3_POSICAO),0))
			) AS QT_A_ENTREGAR
		,(	
			SELECT 
				SUM(QT_A_ENTREGAR) AS QT_A_ENTREGAR
			FROM (
				SELECT 
					((SW3_AUX.W3_QTDE - SW3_AUX.W3_SLD_ELI) - (ISNULL((SELECT SUM(W7_QTDE) 
																		FROM SW7040 SW7 WITH(NOLOCK) 
																		WHERE W7_PO_NUM=SW3_AUX.W3_PO_NUM 
																		AND W7_FILIAL=SW3_AUX.W3_FILIAL 
																		AND SW7.D_E_L_E_T_='' 
																		AND W7_COD_I=SW3_AUX.W3_COD_I 
																		AND W7_POSICAO=SW3_AUX.W3_POSICAO),0))
					) AS QT_A_ENTREGAR
				FROM SW3040 SW3_AUX WITH(NOLOCK) 
				WHERE SW3_AUX.W3_FILIAL=SW3.W3_FILIAL
				AND SW3_AUX.D_E_L_E_T_='' 
				AND SW3_AUX.W3_SEQ=0
				AND SW3_AUX.W3_PO_NUM=SW3.W3_PO_NUM
				) SW3_AUX_I
			)		
		 AS TT_QT
		,(
			ISNULL((SELECT SUM(E2_VLCRUZ) 
					FROM SE2040 WITH(NOLOCK) 
					WHERE E2_FILIAL=W3_FILIAL 
					AND D_E_L_E_T_='' 
					AND E2_PREFIXO='EIC' 
					AND E2_FORNECE=W3_FABR 
					AND E2_NUM = RIGHT(REPLICATE('0',9) + LTRIM(RTRIM(W2_PO_SIGA)),9) AND E2_TIPO IN('PR') ),0) 
				+					
			ISNULL((SELECT SUM(E2_VLCRUZ) 
					FROM SE2040 WITH(NOLOCK) 
					WHERE E2_FILIAL=W3_FILIAL 
					AND D_E_L_E_T_='' 
					AND E2_PREFIXO='EIC' 
					AND E2_FORNECE=W3_FABR 
					AND E2_NUM = 'AD' + LTRIM(RTRIM(W2_PO_SIGA)) AND E2_TIPO IN('PA') ),0) 
				+
			ISNULL((SELECT SUM(E2_VLCRUZ) 
					FROM SE2040 WITH(NOLOCK) 
					WHERE E2_FILIAL=W3_FILIAL 
					AND D_E_L_E_T_='' 
					AND E2_PREFIXO='EIC' 
					AND E2_FORNECE=W3_FABR 
					AND E2_NUM = 'AD' + LTRIM(RTRIM(W2_PO_SIGA)) AND E2_TIPO IN('PR') ),0) 
			) AS TT_VL
		,'IMP' AS ORIGEM
		,B1_TIPO
		,B1_ITEMCC AS C1_ITEMCTA
		,W3_PO_NUM
		,W3_COD_I
	FROM SW3040 SW3 WITH(NOLOCK) 
	INNER JOIN SW2040 SW2 WITH(NOLOCK)
		ON W2_FILIAL=W3_FILIAL
		AND W2_PO_NUM=W3_PO_NUM
		AND SW2.D_E_L_E_T_=''
	INNER JOIN SB1040 SB1 WITH(NOLOCK)
		ON B1_COD=W3_COD_I
		AND B1_FILIAL=W3_FILIAL
		AND SB1.D_E_L_E_T_='' 
	WHERE W3_FILIAL='02' 
		AND SW3.D_E_L_E_T_='' 
		AND W3_DT_ENTR>=@CDATAPONT
		AND W3_SEQ=0
		--AND W3_PO_NUM='ST-2017-006    '
) AUX
WHERE QT_A_ENTREGAR>0 AND TT_VL>0
ORDER BY C1_DATPRF

END


