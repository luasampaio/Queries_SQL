USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS_CT]    Script Date: 29/07/2021 14:14:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS						  *
* OBJETIVO  : Relatorio de horas improdutivas                   			  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 25/05/2017                                                      *
* OBSERVACAO: Procedure usada pela rotina PCPHRIMPR							  * 
*							                                                  *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
* EXEC SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS_CT '201707', 'SEC10 ','','20170701','20170730' *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_REL_PCP_HORAS_IMPRODUTIVAS_PROTHEUS_CT]
		@CDATAPONT		VARCHAR(06),
		@CFILRECURSO	VARCHAR(07),
		@CFILOPERADOR	VARCHAR(06),
		@CDTAPOINI		VARCHAR(10),
		@CDTAPOFIM		VARCHAR(10)
AS
BEGIN

	--DECLARE	@CDATAPONT VARCHAR(6),
	--	@CFILRECURSO VARCHAR(07),
	--	@CFILOPERADOR VARCHAR(06)
	
	--SET @CDATAPONT='201705'
	--SET @CFILRECURSO = 'SEC10'
	--SET @CFILOPERADOR = '000319'
	
	DECLARE @nULTDIA INT
	DECLARE @nQTDCEL INT
	DECLARE @NLOOPCEL INT
	DECLARE @NLOOPDIA INT
	DECLARE @SSQL VARCHAR(MAX)
	DECLARE @SSQLZ NVARCHAR(MAX)
	DECLARE @NQTRECURSO INT
	DECLARE @CCONSOLIDA VARCHAR(1)
	DECLARE @NFATOR INT
	
	SET @NFATOR = 1 -- Fator de convers�o quando 1 manter� a vis�o por minutos

	SET @CCONSOLIDA='N'
	IF @CFILRECURSO='TODOS'
		BEGIN
			SET @CFILRECURSO = ''
			SET @CCONSOLIDA='S'
		END
	
	IF (@CDTAPOFIM != '' AND @CDTAPOINI != '' AND CONVERT(DATETIME,@CDTAPOINI)>CONVERT(DATETIME,@CDTAPOFIM)) OR (@CDTAPOINI = '') OR (@CDTAPOFIM = '')
	BEGIN 
		SET @CDTAPOINI = @CDATAPONT + '01'
		SET @CDTAPOFIM = CONVERT(VARCHAR(10),DATEADD(DD, -DAY(DATEADD(M, 1, CONVERT(DATE,@CDTAPOINI))), DATEADD(M, 1, CONVERT(DATE,@CDTAPOINI))),112)
	END
	
	PRINT 'DATAS INICIO E FIM'
	PRINT @CDTAPOINI
	PRINT @CDTAPOFIM

	IF ISNULL(OBJECT_ID('TEMP_CT_ID_CELULA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_CT_ID_CELULA
	END

	IF ISNULL(OBJECT_ID('TEMP_CT_CBH_DETALHE'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_CT_CBH_DETALHE
	END

	IF ISNULL(OBJECT_ID('TEMP_CT_PCP_HORAS'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_CT_PCP_HORAS
	END
	
	IF ISNULL(OBJECT_ID('TEMP_CT_CBH_TRANSA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_CT_CBH_TRANSA
	END

	CREATE TABLE TEMP_CT_CBH_TRANSA
	(
		CBH_TRANSA	VARCHAR(02),
		CBH_TIPO	VARCHAR(01)
	)
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='01' --INICIO PRODUCAO CELULA                      
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='02' --FIM PRODUCAO CELULA                         
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='03' --INICIO SUP. LIBERACAO                       
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='04' --FIM SUP. LIBERACAO                          
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='05' --INICIO CQ LIBERACAO                         
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='06' --FIM CQ LIBERACAO                            
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='07' --INCIO EXPEDICAO                             
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='08' --FIM EXPEDICAO                               
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='50' --GINASTICA LABORAL                       
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='51' --PAUSA PARA DESCANSO MANHA                                      
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='52' --ALMOCO                                  
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='53' --PAUSA PARA DESCANSO TARDE                         
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='54' --BANHEIRO / BEBER AGUA                             
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='55' --REUNIAO                                           
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'N' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='56' --MANUTENCAO                                        
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'N' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='57' --QUEDA DE ENERGIA                                  
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'N' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='58' --FALTA DE MATERIA PRIMA                            
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='59' --AMBULATORIO                                       
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='60' --RH                                                
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'N' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='61' --PROBLEMAS QUALIDADE                               
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'N' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='62' --COLETOR / INTERNET / SINAL                        
	INSERT INTO TEMP_CT_CBH_TRANSA (CBH_TRANSA,CBH_TIPO) SELECT CBI_CODIGO,'S' FROM CBI040 WHERE D_E_L_E_T_='' AND CBI_CODIGO='99' --FINAL DO DIA               


	CREATE TABLE TEMP_CT_PCP_HORAS
	(
		QTD_CELULAS	INT,
		QTD_DIAS	INT
	)
	PRINT 'Busca o ultimo dia na opera��o do periodo referenciado'
	SET @nULTDIA =  DAY(CONVERT(DATETIME,
		(
			SELECT
				ISNULL(MAX(ULTIMO_DIA),'') AS ULTIMO_DIA
			FROM
			(
			SELECT 
				MAX(CBH_DTFIM) AS ULTIMO_DIA
			FROM CBH040 CBH WITH(NOLOCK)
			INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
			WHERE CBH_FILIAL = '02'
			AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
			AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM  AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
			AND CBH_OPERAC = '01'
			AND CBH_TRANSA >= '50'
			--AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
			--AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
			UNION ALL
			SELECT 
				MAX(CBH_DTFIM) AS ULTIMO_DIA
			FROM CBH040 CBH WITH(NOLOCK)
			INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
			WHERE CBH_FILIAL = '02'
			AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
			AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM  AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
			AND CBH_OPERAC = '01'
			AND CBH_TRANSA = '02'
			--AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
			--AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
			) AUX
		)))
	PRINT @nULTDIA
	
	PRINT 'Conta a quantidade de celulas na opera��o do periodo referenciado '
	SET @nQTDCEL = 1
		--(SELECT COUNT(*) 
		--	FROM 
		--	(
		--	SELECT DISTINCT CBH_RECUR
		--	FROM 
		--		(
		--			(
		--				SELECT DISTINCT CBH_RECUR
		--				FROM CBH040 CBH WITH(NOLOCK)
		--				INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
		--				WHERE CBH_FILIAL = '02'
		--				AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
		--				AND LEFT(CBH_DTFIM,6) = @CDATAPONT
		--				AND CBH_OPERAC = '01'
		--				AND CBH_TRANSA >= '50'
		--				AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
		--				AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		--				UNION ALL
		--				SELECT DISTINCT CBH_RECUR
		--				FROM CBH040 CBH WITH(NOLOCK)
		--				INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
		--				WHERE CBH_FILIAL = '02'
		--				AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
		--				AND LEFT(CBH_DTFIM,6) = @CDATAPONT
		--				AND CBH_OPERAC = '01'
		--				AND CBH_TRANSA = '02'
		--				AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
		--				AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		--			)
		--		) AUX
		--	) AUX_i
		--)
	
	PRINT 'Alimenta numero de celulas e quantidade de dias'
	INSERT INTO TEMP_CT_PCP_HORAS (QTD_CELULAS,QTD_DIAS) VALUES (@nQTDCEL,@nULTDIA)

	PRINT 'Alimenta tabela de identifica��o da celula'
	SELECT 
		CBH_RECUR
		,1 AS CELULA --,ROW_NUMBER() OVER(ORDER BY CBH_RECUR) AS CELULA 
	INTO TEMP_CT_ID_CELULA
	FROM (
		SELECT 
			DISTINCT CBH_RECUR
		FROM 
			(
				(
					SELECT DISTINCT CBH_RECUR
					FROM CBH040 CBH WITH(NOLOCK)
					INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
					WHERE CBH_FILIAL = '02'
					AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
					AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM  AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
					AND CBH_OPERAC = '01'
					AND CBH_TRANSA >= '50'
					AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
					AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
					UNION ALL
					SELECT DISTINCT CBH_RECUR
					FROM CBH040 CBH WITH(NOLOCK)
					INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
					WHERE CBH_FILIAL = '02'
					AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
					AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM  AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
					AND CBH_OPERAC = '01'
					AND CBH_TRANSA = '02'
					AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
					AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
				)
			) AUX
		) AUX_ii

	PRINT 'Cria a tabela a matriz do relat�rio'
	SELECT @SSQL = ''

	SET @NLOOPCEL = 0
	SET @NLOOPDIA = 0
	SELECT @SSQL = 'CREATE TABLE TEMP_CT_CBH_DETALHE '
	SELECT @SSQL = @SSQL + '( '
	SELECT @SSQL = @SSQL + ' ID_SEQUEN	VARCHAR(02)'
	SELECT @SSQL = @SSQL + ' ,ID_NOME	VARCHAR(40)'
	WHILE (@NLOOPCEL < @nQTDCEL)
		BEGIN
			SET @NLOOPCEL = @NLOOPCEL + 1
			SET @NLOOPDIA = 0
			WHILE (@NLOOPDIA < @nULTDIA)
				BEGIN
			
					SET @NLOOPDIA = @NLOOPDIA + 1
					SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' INT'

				END
		END
	SELECT @SSQL = @SSQL + ' ,LTOTAL	INT'
	SELECT @SSQL = @SSQL + ')'
	
	EXEC(@SSQL)
	/*----------- fim da cria��o da matriz -----------*/
	
	PRINT 'Insere linha da transa��o improdutiva e ZERA campos numericos antes da carga'
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT 
			DISTINCT CBH_TRANSA,CBI_DESCRI
		FROM CBH040 CBH WITH(NOLOCK)
		INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
		WHERE CBH_FILIAL = '02'
		AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
		AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM  AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
		AND CBH_OPERAC = '01'
		AND CBH_TRANSA >= '50'
		AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
		AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')

	OPEN Estrutura_Cursor;

	DECLARE @CBIDESCR	VARCHAR(40),
			@CBHTRANS	VARCHAR(02)

	FETCH NEXT FROM Estrutura_Cursor INTO @CBHTRANS,@CBIDESCR;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			SELECT @SSQL = 'INSERT INTO TEMP_CT_CBH_DETALHE '
			SELECT @SSQL = @SSQL + '( '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	'
			SELECT @SSQL = @SSQL + ' ,ID_NOME	'
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,LTOTAL	'
			SELECT @SSQL = @SSQL + ')'

			SELECT @SSQL = @SSQL + 'SELECT '
			SELECT @SSQL = @SSQL + 	'''' + @CBHTRANS  + '''' + ' AS ID_SEQUEN '
			SELECT @SSQL = @SSQL + ','	+ '''' + @CBIDESCR + '''' + 'AS ID_NOME '
			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' , 0 AS CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,0 AS LTOTAL	'

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @CBHTRANS,@CBIDESCR
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;
	
	PRINT 'Insere linha da transa��o das horas trabalhadas e de outros processo tamb�m ZERA campos numericos antes da carga'
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT 
			'Z1' CBH_TRANSA, 'HORAS PRODUTIVAS' AS CBI_DESCRI
		UNION ALL
		SELECT 
			'Z2' CBH_TRANSA, 'QUANTIDADE DE RECURSOS' AS CBI_DESCRI
		UNION ALL
		SELECT 
			'Z3' CBH_TRANSA, 'CAPACIDADE PRODUTIVA' AS CBI_DESCRI

	OPEN Estrutura_Cursor;


	FETCH NEXT FROM Estrutura_Cursor INTO @CBHTRANS,@CBIDESCR;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			SELECT @SSQL = 'INSERT INTO TEMP_CT_CBH_DETALHE '
			SELECT @SSQL = @SSQL + '( '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	'
			SELECT @SSQL = @SSQL + ' ,ID_NOME	'
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,LTOTAL	'
			SELECT @SSQL = @SSQL + ')'

			SELECT @SSQL = @SSQL + 'SELECT '
			SELECT @SSQL = @SSQL + 	'''' + @CBHTRANS  + '''' + ' AS ID_SEQUEN '
			SELECT @SSQL = @SSQL + ','	+ '''' + @CBIDESCR + '''' + 'AS ID_NOME '
			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' , 0 AS CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,0 AS LTOTAL	'

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @CBHTRANS,@CBIDESCR
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Carga de movimentos da celula IMPRODUTIVAS '
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT
			(SELECT CELULA FROM TEMP_CT_ID_CELULA AUX_ii WHERE AUX_ii.CBH_RECUR=AUX.CBH_RECUR) AS CELULA
			,SUM(CBH_MINUTOS)*@NFATOR AS CBH_MINUTOS
			,CONVERT(INT,DIA_INI) AS DIA_INI
			,CBH_TRANSA
		FROM 
		(
			SELECT 
				DATEDIFF(minute ,CONVERT(DATETIME,CBH_DTINI) + CBH_HRINI ,CONVERT(DATETIME,CBH_DTFIM) + CBH_HRFIM ) AS CBH_MINUTOS,
				RIGHT(CBH_DTINI,2) AS DIA_INI,
				CBH_OPERAD , CBH_RECUR , CBH_DTINI , CBH_DTFIM, CBH_HRINI , CBH_HRFIM, CBI_DESCRI, CBI_TIPO ,CBH_TRANSA
			FROM CBH040 CBH WITH(NOLOCK)
			INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
			WHERE CBH_FILIAL = '02'
			AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
			AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM AND CBH_DTFIM!=''--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
			AND CBH_OPERAC = '01'
			--AND CBH_TRANSA = '02'
			AND CBH_TRANSA >= '50'
			AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
			AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		) AUX
		GROUP BY DIA_INI, CBH_TRANSA,CBH_RECUR
	
	OPEN Estrutura_Cursor;

	DECLARE @NCELULA	INT,
			@NMINUTOS	INT,
			@NDIAINI	INT			

	FETCH NEXT FROM Estrutura_Cursor INTO @NCELULA,@NMINUTOS,@NDIAINI,@CBHTRANS;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SELECT @SSQL = 'UPDATE AUX SET '
			SELECT @SSQL = @SSQL + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + ' = ' + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + '+' + '''' + CAST(@NMINUTOS AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' ,LTOTAL	= LTOTAL + ' + '''' + CAST(@NMINUTOS AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' FROM TEMP_CT_CBH_DETALHE AUX'
			SELECT @SSQL = @SSQL + ' WHERE '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	= ' + '''' + @CBHTRANS + ''''

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @NCELULA,@NMINUTOS,@NDIAINI,@CBHTRANS
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Insere linha da soma das horas improdutivas '
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT 
			'Z0' CBH_TRANSA, 'TOTAL HORAS IMPRODUTIVAS' AS CBI_DESCRI

	OPEN Estrutura_Cursor;


	FETCH NEXT FROM Estrutura_Cursor INTO @CBHTRANS,@CBIDESCR;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			SELECT @SSQL = 'INSERT INTO TEMP_CT_CBH_DETALHE '
			SELECT @SSQL = @SSQL + '( '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	'
			SELECT @SSQL = @SSQL + ' ,ID_NOME	'
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,LTOTAL	'
			SELECT @SSQL = @SSQL + ') '

			SELECT @SSQL = @SSQL + 'SELECT '
			SELECT @SSQL = @SSQL + 	'''' + @CBHTRANS  + '''' + ' AS ID_SEQUEN '
			SELECT @SSQL = @SSQL + ','	+ '''' + @CBIDESCR + '''' + 'AS ID_NOME '
			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,SUM(CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ')  AS CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,SUM(LTOTAL) AS LTOTAL FROM TEMP_CT_CBH_DETALHE	'

			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @CBHTRANS,@CBIDESCR
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Insere linha da soma das horas improdutivas programadas'
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT 
			'Ya' CBH_TRANSA, 'TOTAL HORAS IMPRODUTIVAS PROGRAMADAS' AS CBI_DESCRI

	OPEN Estrutura_Cursor;


	FETCH NEXT FROM Estrutura_Cursor INTO @CBHTRANS,@CBIDESCR;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			SELECT @SSQL = 'INSERT INTO TEMP_CT_CBH_DETALHE '
			SELECT @SSQL = @SSQL + '( '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	'
			SELECT @SSQL = @SSQL + ' ,ID_NOME	'
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,LTOTAL	'
			SELECT @SSQL = @SSQL + ') '

			SELECT @SSQL = @SSQL + 'SELECT '
			SELECT @SSQL = @SSQL + 	'''' + @CBHTRANS  + '''' + ' AS ID_SEQUEN '
			SELECT @SSQL = @SSQL + ','	+ '''' + @CBIDESCR + '''' + 'AS ID_NOME '
			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,SUM(CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ')  AS CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,SUM(LTOTAL) AS LTOTAL FROM TEMP_CT_CBH_DETALHE	'
			SELECT @SSQL = @SSQL + ' WHERE 	''S'' =  (SELECT CBH_TIPO FROM TEMP_CT_CBH_TRANSA WHERE CBH_TRANSA=ID_SEQUEN )'  

			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @CBHTRANS,@CBIDESCR
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Insere linha da soma das horas improdutivas nao programadas'
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT 
			'Yb' CBH_TRANSA, 'TOTAL HORAS IMPRODUTIVAS NAO PROGRAMADAS' AS CBI_DESCRI

	OPEN Estrutura_Cursor;


	FETCH NEXT FROM Estrutura_Cursor INTO @CBHTRANS,@CBIDESCR;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			SELECT @SSQL = 'INSERT INTO TEMP_CT_CBH_DETALHE '
			SELECT @SSQL = @SSQL + '( '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	'
			SELECT @SSQL = @SSQL + ' ,ID_NOME	'
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,LTOTAL	'
			SELECT @SSQL = @SSQL + ') '

			SELECT @SSQL = @SSQL + 'SELECT '
			SELECT @SSQL = @SSQL + 	'''' + @CBHTRANS  + '''' + ' AS ID_SEQUEN '
			SELECT @SSQL = @SSQL + ','	+ '''' + @CBIDESCR + '''' + 'AS ID_NOME '
			SET @NLOOPCEL = 0
			SET @NLOOPDIA = 0
			WHILE (@NLOOPCEL < @nQTDCEL)
				BEGIN
					SET @NLOOPCEL = @NLOOPCEL + 1
					SET @NLOOPDIA = 0
					WHILE (@NLOOPDIA < @nULTDIA)
						BEGIN
					
							SET @NLOOPDIA = @NLOOPDIA + 1
							SELECT @SSQL = @SSQL + ' ,SUM(CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ')  AS CEL' + CAST(@NLOOPCEL AS VARCHAR) + 'D' + CAST(@NLOOPDIA AS VARCHAR) + ' '

						END
				END
			SELECT @SSQL = @SSQL + ' ,SUM(LTOTAL) AS LTOTAL FROM TEMP_CT_CBH_DETALHE	'
			SELECT @SSQL = @SSQL + ' WHERE 	''N'' =  (SELECT CBH_TIPO FROM TEMP_CT_CBH_TRANSA WHERE CBH_TRANSA=ID_SEQUEN )'  

			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @CBHTRANS,@CBIDESCR
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Carga de movimentos da celula horas produtivas - Z1'
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT
			(SELECT CELULA FROM TEMP_CT_ID_CELULA AUX_ii WHERE AUX_ii.CBH_RECUR=AUX.CBH_RECUR) AS CELULA
			,SUM(CBH_MINUTOS)*@NFATOR AS CBH_MINUTOS
			,CONVERT(INT,DIA_INI) AS DIA_INI
			,'Z1' AS CBH_TRANSA
		FROM 
		(
			SELECT 
				CASE WHEN LEFT(H6_TEMPO,3)/24 >= 1 
					THEN DATEDIFF(minute ,CONVERT(DATETIME,H6_DATAINI) + H6_HORAINI , CONVERT(DATETIME,H6_DATAFIN) + H6_HORAFIN  )
					ELSE DATEDIFF(minute ,CONVERT(DATETIME,H6_DATAINI) + '00:00' , CONVERT(DATETIME,H6_DATAINI) + H6_TEMPO)
					END AS CBH_MINUTOS
				,RIGHT(H6_DATAINI,2) AS DIA_INI
				,H6_RECURSO AS CBH_RECUR
				,'Z1' AS CBH_TRANSA
			FROM SH6040 SH6
			WHERE H6_FILIAL='02'
			AND SH6.D_E_L_E_T_='' 
			AND H6_OPERAC='01'
			AND H6_TIPO='P'
			AND H6_DATAINI>=@CDTAPOINI AND H6_DATAFIN <= @CDTAPOFIM  AND H6_DATAFIN!=''--AND LEFT(H6_DTPROD,6) = @CDATAPONT
			AND ((H6_RECURSO = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
			AND ((H6_OPERADO = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')

			--SELECT 
			--	DATEDIFF(minute ,CONVERT(DATETIME,CBH_DTFIM) + CBH_HRINI ,CONVERT(DATETIME,CBH_DTFIM) + CBH_HRFIM ) AS CBH_MINUTOS,
			--	RIGHT(CBH_DTINI,2) AS DIA_INI,
			--	CBH_OPERAD , CBH_RECUR , CBH_DTINI , CBH_DTFIM, CBH_HRINI , CBH_HRFIM, CBI_DESCRI, CBI_TIPO ,CBH_TRANSA
			--FROM CBH040 CBH WITH(NOLOCK)
			--INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
			--WHERE CBH_FILIAL = '02'
			--AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
			--AND LEFT(CBH_DTFIM,6) = @CDATAPONT
			--AND CBH_OPERAC = '01'
			--AND CBH_TRANSA = '02'
			--AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
			--AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		) AUX
		GROUP BY DIA_INI, CBH_TRANSA,CBH_RECUR
	
	OPEN Estrutura_Cursor;

	FETCH NEXT FROM Estrutura_Cursor INTO @NCELULA,@NMINUTOS,@NDIAINI,@CBHTRANS;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SELECT @SSQL = 'UPDATE AUX SET '
			SELECT @SSQL = @SSQL + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + ' = ' + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + ' + ' + '''' + CAST(@NMINUTOS AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' ,LTOTAL	= LTOTAL + ' + '''' + CAST(@NMINUTOS AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' FROM TEMP_CT_CBH_DETALHE AUX'
			SELECT @SSQL = @SSQL + ' WHERE '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	= ' + '''' + @CBHTRANS + ''''

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @NCELULA,@NMINUTOS,@NDIAINI,@CBHTRANS
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;


	PRINT 'Carga de numero de recusos - Z2'
	DECLARE @NRECURSO	INT
	
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT
			(SELECT CELULA FROM TEMP_CT_ID_CELULA AUX_ii WHERE AUX_ii.CBH_RECUR=AUX.CBH_RECUR) AS CELULA
			,SUM(RECURSO) AS RECURSO
			,DIA_INI
			,'Z2' AS CBH_TRANSA
		FROM
		(
		SELECT 
			RIGHT(CBH_DTINI,2) AS DIA_INI,
			CBH_OPERAD , CBH_RECUR 
			,1 AS RECURSO
		FROM CBH040 CBH WITH(NOLOCK)
		INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
		WHERE CBH_FILIAL = '02'
		AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
		AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM AND CBH_DTFIM!='' --AND LEFT(CBH_DTFIM,6) = @CDATAPONT
		AND CBH_OPERAC = '01'
		AND CBH_TRANSA = '02'
		AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
		AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		GROUP BY RIGHT(CBH_DTINI,2),CBH_RECUR,CBH_OPERAD
		) AUX
		GROUP BY DIA_INI,CBH_RECUR
	
	OPEN Estrutura_Cursor;

	FETCH NEXT FROM Estrutura_Cursor INTO @NCELULA,@NRECURSO,@NDIAINI,@CBHTRANS;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQL = ''

			SELECT @SSQL = 'UPDATE AUX SET '
			SELECT @SSQL = @SSQL + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + ' = ' + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + '+' + '''' + CAST(@NRECURSO AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' ,LTOTAL	= LTOTAL + ' + '''' + CAST(@NRECURSO AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' FROM TEMP_CT_CBH_DETALHE AUX'
			SELECT @SSQL = @SSQL + ' WHERE '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	= ' + '''' + @CBHTRANS + ''''

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @NCELULA,@NRECURSO,@NDIAINI,@CBHTRANS
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	PRINT 'Carga de capacidade produtiva - Z3 * Z2 (recursos)'
	
	DECLARE Estrutura_Cursor CURSOR FOR
		SELECT
			(SELECT CELULA FROM TEMP_CT_ID_CELULA AUX_ii WHERE AUX_ii.CBH_RECUR=AUX.CBH_RECUR) AS CELULA
			,SUM(RECURSO) AS RECURSO
			,DIA_INI
			,'Z3' AS CBH_TRANSA
		FROM
		(
		SELECT 
			RIGHT(CBH_DTINI,2) AS DIA_INI
			, CBH_RECUR 
			, (CASE Datepart(dw,CONVERT(DATETIME,CBH_DTINI)) WHEN 6 
				THEN DATEDIFF(minute ,CONVERT(DATETIME,CBH_DTINI) + '07:00' ,CONVERT(DATETIME,CBH_DTINI) + '16:00' ) 
				ELSE DATEDIFF(minute ,CONVERT(DATETIME,CBH_DTINI) + '07:00' ,CONVERT(DATETIME,CBH_DTINI) + '17:00' ) 
				END	)	
			AS RECURSO
		FROM CBH040 CBH WITH(NOLOCK)
		INNER JOIN CBI040 CBI WITH(NOLOCK) ON CBI_FILIAL = CBH_FILIAL AND CBI_CODIGO  = CBH_TRANSA 
		WHERE CBH_FILIAL = '02'
		AND CBH.D_E_L_E_T_ <> '*' AND CBI.D_E_L_E_T_ <> '*'
		AND CBH_DTINI>=@CDTAPOINI AND CBH_DTFIM <= @CDTAPOFIM AND CBH_DTFIM!='' --AND LEFT(CBH_DTFIM,6) = @CDATAPONT
		AND CBH_OPERAC = '01'
		AND CBH_TRANSA = '02'
		AND ((CBH_RECUR = @CFILRECURSO AND @CFILRECURSO!='') OR @CFILRECURSO='')
		AND ((CBH_OPERAD = @CFILOPERADOR AND @CFILOPERADOR!='') OR @CFILOPERADOR='')
		GROUP BY RIGHT(CBH_DTINI,2),CBH_RECUR,CBH_DTINI
		) AUX
		GROUP BY DIA_INI,CBH_RECUR
	
	OPEN Estrutura_Cursor;

	FETCH NEXT FROM Estrutura_Cursor INTO @NCELULA,@NRECURSO,@NDIAINI,@CBHTRANS;
	WHILE @@FETCH_STATUS = 0
	  BEGIN
		BEGIN 

			SELECT @SSQLZ = 'SELECT @NQTRECURSO =  ' 
			SELECT @SSQLZ = @SSQLZ + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR)
			SELECT @SSQLZ = @SSQLZ + ' FROM TEMP_CT_CBH_DETALHE AUX WHERE ID_SEQUEN=''Z2'' ' 
			
			EXEC sp_executesql @SSQLZ, N'@NQTRECURSO INT out', @NQTRECURSO output 
			
			IF @NQTRECURSO != 0
				BEGIN
				SET @NRECURSO = @NRECURSO * @NQTRECURSO
				END
			
			SELECT @SSQL = ''

			SELECT @SSQL = 'UPDATE AUX SET '
			SELECT @SSQL = @SSQL + ' CEL' + CAST(@NCELULA AS VARCHAR) + 'D' + CAST(@NDIAINI AS VARCHAR) + ' = ' + '''' + CAST(@NRECURSO AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' ,LTOTAL	= LTOTAL + ' + '''' + CAST(@NRECURSO AS VARCHAR) + ''''
			SELECT @SSQL = @SSQL + ' FROM TEMP_CT_CBH_DETALHE AUX'
			SELECT @SSQL = @SSQL + ' WHERE '
			SELECT @SSQL = @SSQL + ' ID_SEQUEN	= ' + '''' + @CBHTRANS + ''''

			
			EXEC(@SSQL)

		END
		
		FETCH NEXT FROM Estrutura_Cursor
		INTO @NCELULA,@NRECURSO,@NDIAINI,@CBHTRANS
		
	END;
	-- fim do cursor
	CLOSE Estrutura_Cursor;
	DEALLOCATE Estrutura_Cursor;

	
	SELECT * FROM TEMP_CT_CBH_DETALHE
	ORDER BY ID_SEQUEN

END


