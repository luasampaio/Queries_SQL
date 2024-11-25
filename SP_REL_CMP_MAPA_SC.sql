USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_REL_CMP_MAPA_SC]    Script Date: 27/07/2021 16:30:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_REL_CMP_MAPA_SC     		  								  *
* OBJETIVO  : Mapa de compras - visao de SC e pedidos						  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 02/08/2011                                                      *
* OBSERVACAO: Principal PRW que a utiliza TFCMPR01			                  * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_REL_CMP_MAPA_SC]
	@CFILIALINI		VARCHAR(2),
	@CFILIALFIN		VARCHAR(2),
	@DEMISSAOINI	VARCHAR(10),
	@DEMISSAOFIN	VARCHAR(10),
	@CEMITENTE		VARCHAR(25),
	@CSEQMRP		VARCHAR(6)
AS
BEGIN
	DECLARE @CEMITENTEINI VARCHAR(25),
			@CEMITENTEFIN VARCHAR(25),
			@CSEQMRPINI	VARCHAR(6),
			@CSEQMRPFIN	VARCHAR(6)
	
	SET @CEMITENTEINI = ''
	SET @CEMITENTEFIN = REPLICATE('Z',25)
	IF ISNULL(@CEMITENTE,'') != ''
		BEGIN
			SET @CEMITENTEINI = @CEMITENTE
			SET @CEMITENTEFIN = @CEMITENTE
		END

	SET @CSEQMRPINI	= ''
	SET @CSEQMRPFIN	= REPLICATE('Z',6)
	IF ISNULL(@CSEQMRP,'') != ''
		BEGIN
			SET @CSEQMRPINI	= @CSEQMRP
			SET @CSEQMRPFIN	= @CSEQMRP
		END

	--
	-- Cria tabela temporaria que recebe todas as SC's dentro da range solicitada 
	--
    CREATE TABLE #TEMP_CMP_SC_COM_E_SEM_PEDIDO
      (
		C1_OK		VARCHAR(2)		 NULL,
		C1_NUMSC	VARCHAR(6)		 NULL,
		C1_ITEMSC	VARCHAR(4)		 NULL,
		C1_PRODUTO	VARCHAR(9)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C1_DATPRF	VARCHAR(10)		 NULL,
		C1_EMISSAO	VARCHAR(10)		 NULL,
		C1_CLASCON	VARCHAR(1)		 NULL,
		C1_LOCAL	VARCHAR(2)		 NULL,
		C1_UM		VARCHAR(2)		 NULL,
		C1_DTVALID	VARCHAR(10)		 NULL,
		C1_OP     	VARCHAR(13)		 NULL,
		C1_TPOP		VARCHAR(1)		 NULL,
		C1_SEQMRP	VARCHAR(6)		 NULL,
		C1_SOLICIT	VARCHAR(25)		 NULL,
		C1_APROV  	VARCHAR(1)		 NULL,
		C1_RESIDUO  VARCHAR(1)		 NULL,
		C1_FILIAL	VARCHAR(2)		 NULL,
		C1_OBS		VARCHAR(100)	 NULL,
		C1_QUANTSC	INT,
		C7_NUM		VARCHAR(6)		 NULL,
		C7_ITEM		VARCHAR(4)		 NULL,
		C7_DATPRF	VARCHAR(10)		 NULL,
		C7_QTPED	INT,
		C7_QUJE		INT,
		C7_EMISSAO	VARCHAR(10)		 NULL,
		C7_TIPO		INT,
		C7_UM		VARCHAR(2)		 NULL,
		C7_PRECO	FLOAT,
		C7_RESIDUO	VARCHAR(1)		 NULL,
		C7_ENCER	VARCHAR(1)		 NULL,
		C7_USER		VARCHAR(6)		 NULL,
		C7_FORNECE	VARCHAR(6)		 NULL,
		C7_DESCFOR	VARCHAR(50)		 NULL,
		C7_SEGUM	VARCHAR(2)		 NULL,
		C7_QTSEGUM	DECIMAL(12,4),
		C1_PEDIDO	VARCHAR(6)		 NULL,
		C1_ITEMPED	VARCHAR(4)		 NULL
      )

	--
	-- Insere todos as SC's dentro da range solicitada
	--
	INSERT INTO #TEMP_CMP_SC_COM_E_SEM_PEDIDO
      (
		C1_OK		,
		C1_NUMSC	,
		C1_ITEMSC	,
		C1_PRODUTO	,
		B1_DESC		,
		C1_DATPRF	,
		C1_EMISSAO	,
		C1_CLASCON	,
		C1_LOCAL	,
		C1_UM		,
		C1_DTVALID	,
		C1_OP     	,
		C1_TPOP		,
		C1_SEQMRP	,
		C1_SOLICIT	,
		C1_APROV  	,
		C1_RESIDUO  ,
		C1_FILIAL	,
		C1_OBS		,
		C1_QUANTSC	,
		C7_NUM		,
		C7_ITEM		,
		C7_DATPRF	,
		C7_QTPED	,
		C7_QUJE		,
		C7_EMISSAO	,
		C7_TIPO		,
		C7_UM		,
		C7_PRECO	,
		C7_RESIDUO	,
		C7_ENCER	,
		C7_USER		,
		C7_FORNECE	,
		C7_DESCFOR	,
		C7_SEGUM	,
		C7_QTSEGUM	,
		C1_PEDIDO	,
		C1_ITEMPED
	  )	SELECT  
			''					AS C1_OK		,
			C1_NUM				AS C1_NUMSC		,
			C1_ITEM				AS C1_ITEMSC	,
			C1_PRODUTO							,
			LEFT(B1_DESC,50)	AS B1_DESC		,
			C1_DATPRF							,
			C1_EMISSAO							,
			C1_CLASCON							,
			C1_LOCAL							,
			C1_UM								,
			C1_DTVALID							,
			C1_OP     							,
			C1_TPOP    							,
			C1_SEQMRP							,
			C1_SOLICIT							,
			C1_APROV  							,
			C1_RESIDUO  						,
			C1_FILIAL							,
			C1_OBS								,
			C1_QTDORIG		AS C1_QUANTSC		,
			''				AS C7_NUM			,
			''				AS C7_ITEM			,
			''				AS C7_DATPRF		,
			0				AS C7_QTPED			,
			0				AS C7_QUJE			,
			''				AS C7_EMISSAO		,
			0				AS C7_TIPO			,
			''				AS C7_UM			,
			0				AS C7_PRECO			,
			''				AS C7_RESIDUO		,
			''				AS C7_ENCER			,
			''				AS C7_USER			,
			''				AS C7_FORNECE		,
			''				AS C7_DESCFOR		,
			''				AS C7_SEGUM			,
			0				AS C7_QTSEGUM		,
			C1_PEDIDO							,
			C1_ITEMPED
		FROM SC1010 SC1
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=C1_PRODUTO 
		WHERE   
			SC1.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SC1.C1_FILIAL	>= @CFILIALINI
			AND SC1.C1_FILIAL	<= @CFILIALFIN
			AND SC1.C1_EMISSAO	>= @DEMISSAOINI
			AND SC1.C1_EMISSAO	<= @DEMISSAOFIN
			AND SC1.C1_SOLICIT	>= @CEMITENTEINI
			AND SC1.C1_SOLICIT	<= @CEMITENTEFIN
			AND SC1.C1_SEQMRP	>= @CSEQMRPINI
			AND SC1.C1_SEQMRP	<= @CSEQMRPFIN

	--
	-- Atualiza nas SC's os dados dos pedidos
	--
	UPDATE CMP_SC
		SET CMP_SC.C7_NUM		= SC7.C7_NUM	,
			CMP_SC.C7_ITEM		= SC7.C7_ITEM	,
			CMP_SC.C7_DATPRF	= SC7.C7_DATPRF	,
			CMP_SC.C7_QTPED		= SC7.C7_QUANT	,
			CMP_SC.C7_QUJE		= SC7.C7_QUJE	,
			CMP_SC.C7_EMISSAO	= SC7.C7_EMISSAO,
			CMP_SC.C7_TIPO		= SC7.C7_TIPO	,		
			CMP_SC.C7_UM		= SC7.C7_UM		,
			CMP_SC.C7_PRECO		= SC7.C7_PRECO	,	
			CMP_SC.C7_RESIDUO	= SC7.C7_RESIDUO,	
			CMP_SC.C7_ENCER		= SC7.C7_ENCER	,	
			CMP_SC.C7_USER		= SC7.C7_USER	,	
			CMP_SC.C7_FORNECE	= SC7.C7_FORNECE,	
			CMP_SC.C7_DESCFOR	= LEFT(SA2.A2_NOME,50),	
			CMP_SC.C7_SEGUM		= SC7.C7_SEGUM	,	
			CMP_SC.C7_QTSEGUM	= SC7.C7_QTSEGUM
	FROM #TEMP_CMP_SC_COM_E_SEM_PEDIDO CMP_SC
		INNER JOIN SC7010 SC7 ON CMP_SC.C1_PEDIDO = SC7.C7_NUM AND CMP_SC.C1_ITEMPED=SC7.C7_ITEM
		INNER JOIN SA2010 SA2 ON SC7.C7_FORNECE=SA2.A2_COD AND SC7.C7_LOJA=SA2.A2_LOJA
	WHERE SC7.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' 
	
	--
	-- Cria tabela que recebe todos os pedidos dentro da range solicitada com SC
	--
    CREATE TABLE #TEMP_CMP_PEDIDO_COM_SC
      (
		C1_OK		VARCHAR(2)		 NULL,
		C7_NUM		VARCHAR(6)		 NULL,
		C7_ITEM		VARCHAR(4)		 NULL,
		C7_NUMSC	VARCHAR(6)		 NULL,
		C7_ITEMSC	VARCHAR(4)		 NULL,
		C7_PRODUTO	VARCHAR(9)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C7_DATPRF	VARCHAR(10)		 NULL,
		C1_DATPRF	VARCHAR(10)		 NULL,
		C7_QTPED	INT,
		C1_QUANTSC	INT,
		C7_QUJE		INT,
		C7_EMISSAO	VARCHAR(10)		 NULL,
		C1_EMISSAO	VARCHAR(10)		 NULL,
		C1_CLASCON	VARCHAR(1)		 NULL,
		C1_LOCAL	VARCHAR(2)		 NULL,
		C1_UM		VARCHAR(2)		 NULL,
		C1_DTVALID	VARCHAR(10)		 NULL,
		C1_OP     	VARCHAR(13)		 NULL,
		C1_TPOP		VARCHAR(1)		 NULL,
		C1_SEQMRP	VARCHAR(6)		 NULL,
		C1_SOLICIT	VARCHAR(25)		 NULL,
		C1_APROV  	VARCHAR(1)		 NULL,
		C1_RESIDUO  VARCHAR(1)		 NULL,
		C1_FILIAL	VARCHAR(2)		 NULL,
		C1_OBS		VARCHAR(100)	 NULL,
		C7_TIPO		INT,
		C7_UM		VARCHAR(2)		 NULL,
		C7_PRECO	FLOAT,
		C7_RESIDUO	VARCHAR(1)		 NULL,
		C7_ENCER	VARCHAR(1)		 NULL,
		C7_USER		VARCHAR(6)		 NULL,
		C7_FORNECE	VARCHAR(6)		 NULL,
		C7_DESCFOR	VARCHAR(50)		 NULL,
		C7_SEGUM	VARCHAR(2)		 NULL,
		C7_QTSEGUM	DECIMAL(12,4)
      )

	INSERT INTO #TEMP_CMP_PEDIDO_COM_SC
      (
		C1_OK		,
		C7_NUM		,
		C7_ITEM		,
		C7_NUMSC	,
		C7_ITEMSC	,
		C7_PRODUTO	,
		B1_DESC		,
		C7_DATPRF	,
		C1_DATPRF	,
		C1_EMISSAO	,
		C7_QTPED	,
		C1_QUANTSC	,
		C7_QUJE		,
		C7_EMISSAO	,
		C1_CLASCON	,
		C1_LOCAL	,
		C1_UM		,
		C1_DTVALID	,
		C1_OP     	,
		C1_TPOP		,
		C1_SEQMRP	,
		C1_SOLICIT	,
		C1_APROV  	,
		C1_RESIDUO  ,
		C1_FILIAL	,
		C1_OBS		,
		C7_TIPO		,
		C7_UM		,
		C7_PRECO	,
		C7_RESIDUO	,
		C7_ENCER	,
		C7_USER		,
		C7_FORNECE	,
		C7_DESCFOR	,
		C7_SEGUM	,
		C7_QTSEGUM
	  )	SELECT  
			'*'				AS C1_OK		,
			C7_NUM		,
			C7_ITEM		,
			C7_NUMSC	,
			C7_ITEMSC	,
			C7_PRODUTO	,
			LEFT(B1_DESC,50) AS B1_DESC		,
			C7_DATPRF	,
			C1_DATPRF	,
			C1_EMISSAO	,
			C7_QUANT		AS C7_QTPED		,
			C1_QTDORIG		AS C1_QUANTSC	,
			C7_QUJE			AS C7_QUJE		,
			C7_EMISSAO	,
			C1_CLASCON	,
			C1_LOCAL	,
			C1_UM		,
			C1_DTVALID	,
			C1_OP     	,
			C1_TPOP    	,
			C1_SEQMRP	,
			C1_SOLICIT	,
			C1_APROV  	,
			C1_RESIDUO  ,
			C1_FILIAL	,
			C1_OBS		,
			C7_TIPO		,
			C7_UM		,
			C7_PRECO	,
			C7_RESIDUO	,
			C7_ENCER	,
			C7_USER		,
			C7_FORNECE	,
			LEFT(SA2.A2_NOME,50) AS C7_DESCFOR,
			C7_SEGUM	,
			C7_QTSEGUM
		FROM SC7010 SC7
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=C7_PRODUTO 
			INNER JOIN SC1010 SC1 ON SC1.C1_NUM = SC7.C7_NUMSC AND SC1.C1_ITEM=SC7.C7_ITEMSC
			INNER JOIN SA2010 SA2 ON SC7.C7_FORNECE=SA2.A2_COD AND SC7.C7_LOJA=SA2.A2_LOJA
		WHERE   
			SC7.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SC1.D_E_L_E_T_ 	<> '*' 
			AND SA2.D_E_L_E_T_ 	<> '*' 
			AND SC7.C7_FILIAL	>= @CFILIALINI
			AND SC7.C7_FILIAL	<= @CFILIALFIN
			AND SC1.C1_FILIAL	>= @CFILIALINI
			AND SC1.C1_FILIAL	<= @CFILIALFIN
			AND SC1.C1_EMISSAO	>= @DEMISSAOINI
			AND SC1.C1_EMISSAO	<= @DEMISSAOFIN
			AND SC1.C1_SOLICIT	>= @CEMITENTEINI
			AND SC1.C1_SOLICIT	<= @CEMITENTEFIN
			AND SC1.C1_SEQMRP	>= @CSEQMRPINI
			AND SC1.C1_SEQMRP	<= @CSEQMRPFIN
			AND SC7.C7_NUMSC	<> ' '
			AND NOT (SC1.C1_PEDIDO = SC7.C7_NUM AND SC1.C1_ITEMPED=SC7.C7_ITEM)

	--
	-- Pedidos SEM SC
	--
    CREATE TABLE #TEMP_CMP_PEDIDO_SEM_SC
      (
		C7_NUM		VARCHAR(6)		 NULL,
		C7_ITEM		VARCHAR(4)		 NULL,
		C7_PRODUTO	VARCHAR(9)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C7_DATPRF	VARCHAR(10)		 NULL,
		C7_QTPED	INT,
		C7_QUJE		INT,
		C7_EMISSAO	VARCHAR(10)		 NULL,
		C7_TIPO		INT,
		C7_UM		VARCHAR(2)		 NULL,
		C7_PRECO	FLOAT,
		C7_RESIDUO	VARCHAR(1)		 NULL,
		C7_ENCER	VARCHAR(1)		 NULL,
		C7_USER		VARCHAR(6)		 NULL,
		C7_FORNECE	VARCHAR(6)		 NULL,
		C7_DESCFOR	VARCHAR(50)		 NULL,
		C7_SEGUM	VARCHAR(2)		 NULL,
		C7_QTSEGUM	DECIMAL(12,4)
      )

	INSERT INTO #TEMP_CMP_PEDIDO_SEM_SC
      (
		C7_NUM		,
		C7_ITEM		,
		C7_PRODUTO	,
		B1_DESC		,
		C7_DATPRF	,
		C7_QTPED	,
		C7_QUJE		,
		C7_EMISSAO	,
		C7_TIPO		,
		C7_UM		,
		C7_PRECO	,
		C7_RESIDUO	,
		C7_ENCER	,
		C7_USER		,
		C7_FORNECE	,
		C7_DESCFOR	,
		C7_SEGUM	,
		C7_QTSEGUM
	  )	SELECT  
			C7_NUM		,
			C7_ITEM		,
			C7_PRODUTO	,
			LEFT(B1_DESC,50) AS B1_DESC	,
			C7_DATPRF	,
			C7_QUANT		AS C7_QTPED	,
			C7_QUJE			AS C7_QUJE	,
			C7_EMISSAO	,
			C7_TIPO		,
			C7_UM		,
			C7_PRECO	,
			C7_RESIDUO	,
			C7_ENCER	,
			C7_USER		,
			C7_FORNECE	,
			LEFT(SA2.A2_NOME,50) AS C7_DESCFOR	,
			C7_SEGUM	,
			C7_QTSEGUM
		FROM SC7010 SC7
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=C7_PRODUTO 
			INNER JOIN SA2010 SA2 ON SC7.C7_FORNECE=SA2.A2_COD AND SC7.C7_LOJA=SA2.A2_LOJA
		WHERE   
			SC7.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SA2.D_E_L_E_T_ 	<> '*' 
			AND SC7.C7_FILIAL	>= @CFILIALINI
			AND SC7.C7_FILIAL	<= @CFILIALFIN
			AND SC7.C7_NUMSC	= ' '
			AND SC7.C7_QUANT	> SC7.C7_QUJE
			AND C7_RESIDUO		<> 'S'


	SELECT 
		C1_OK		,
		C1_NUMSC	,
		C1_ITEMSC	,
		C1_PRODUTO	,
		B1_DESC		,
		C1_DATPRF	,
		C1_EMISSAO	,
		C1_CLASCON	,
		C1_LOCAL	,
		C1_UM		,
		C1_DTVALID	,
		C1_OP     	,
		C1_TPOP		,
		C1_SEQMRP	,
		C1_SOLICIT	,
		C1_APROV  	,
		C1_RESIDUO  ,
		C1_FILIAL	,
		C1_OBS		,
		C1_QUANTSC	,
		C7_NUM		,
		C7_ITEM		,
		C7_DATPRF	,
		C7_EMISSAO	,
		C7_QTPED	,
		C7_QUJE		,
		C7_TIPO		,
		C7_UM		,
		C7_PRECO	,
		C7_RESIDUO	,
		C7_ENCER	,
		C7_USER		,
		C7_FORNECE	,
		C7_DESCFOR	,
		C7_SEGUM	,
		C7_QTSEGUM
	FROM (
			SELECT 
				C1_OK						,
				C1_NUMSC					,
				C1_ITEMSC					,
				C1_PRODUTO					,
				B1_DESC						,
				C1_DATPRF					,
				C1_EMISSAO					,
				C1_CLASCON					,
				C1_LOCAL					,
				C1_UM						,
				C1_DTVALID					,
				C1_OP     					,
				C1_TPOP						,
				C1_SEQMRP					,
				C1_SOLICIT					,
				C1_APROV  					,
				C1_RESIDUO  				,
				C1_FILIAL					,
				C1_OBS						,
				C1_QUANTSC					,
				C7_NUM						,
				C7_ITEM						,
				C7_DATPRF					,
				C7_EMISSAO					,
				C7_QTPED					,
				C7_QUJE						,
				C7_TIPO						,
				C7_UM						,
				C7_PRECO					,
				C7_RESIDUO					,
				C7_ENCER					,
				C7_USER						,
				C7_FORNECE					,
				C7_DESCFOR					,
				C7_SEGUM					,
				C7_QTSEGUM
			FROM #TEMP_CMP_SC_COM_E_SEM_PEDIDO
		UNION ALL
			SELECT 
				C1_OK						,
				C7_NUMSC	AS C1_NUMSC		,
				C7_ITEMSC	AS C1_ITEMSC	,
				C7_PRODUTO	AS C1_PRODUTO	,
				B1_DESC						,
				C1_DATPRF					,
				C1_EMISSAO					,
				C1_CLASCON					,
				C1_LOCAL					,
				C1_UM						,
				C1_DTVALID					,
				C1_OP     					,
				C1_TPOP						,
				C1_SEQMRP					,
				C1_SOLICIT					,
				C1_APROV  					,
				C1_RESIDUO  				,
				C1_FILIAL					,
				C1_OBS						,
				C1_QUANTSC					,
				C7_NUM						,
				C7_ITEM						,
				C7_DATPRF					,
				C7_EMISSAO					,
				C7_QTPED					,
				C7_QUJE						,
				C7_TIPO						,
				C7_UM						,
				C7_PRECO					,
				C7_RESIDUO					,
				C7_ENCER					,
				C7_USER						,
				C7_FORNECE					,
				C7_DESCFOR					,
				C7_SEGUM					,
				C7_QTSEGUM
			FROM #TEMP_CMP_PEDIDO_COM_SC
		UNION ALL
			SELECT 
				''			AS C1_OK		,
				''			AS C1_NUMSC		,
				''			AS C1_ITEMSC	,
				C7_PRODUTO	AS C1_PRODUTO	,
				B1_DESC						,
				''			AS C1_DATPRF	,
				''			AS C1_EMISSAO	,
				''			AS C1_CLASCON	,
				''			AS C1_LOCAL		,
				''			AS C1_UM		,
				''			AS C1_DTVALID	,
				''			AS C1_OP     	,
				''			AS C1_TPOP		,
				''			AS C1_SEQMRP	,
				''			AS C1_SOLICIT	,
				''			AS C1_APROV  	,
				''			AS C1_RESIDUO  	,
				''			AS C1_FILIAL	,
				''			AS C1_OBS		,
				0			AS C1_QUANTSC	,
				C7_NUM						,
				C7_ITEM						,
				C7_DATPRF					, 
				C7_EMISSAO					,
				C7_QTPED					,
				C7_QUJE						,
				C7_TIPO						,
				C7_UM						,
				C7_PRECO					,
				C7_RESIDUO					,
				C7_ENCER					,
				C7_USER						,
				C7_FORNECE					,
				C7_DESCFOR					,
				C7_SEGUM					,
				C7_QTSEGUM
			FROM #TEMP_CMP_PEDIDO_SEM_SC
		  ) TMP
	ORDER BY C1_NUMSC, C1_ITEMSC, C1_OK, C7_NUM, C7_ITEM

END
