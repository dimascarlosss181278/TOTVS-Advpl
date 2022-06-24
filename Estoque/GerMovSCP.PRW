#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"                               
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RatFolha  º Autor ³ Henrique Tofanelli º Data ³  08/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para gerarcao de PV e PC referente ao rateio entre  º±±
±±º          ³ as areas - busca informações no fechamento da folha        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 28/08/2020 - ALTERADO POR: DIMAS SANTOS                               º±±
±±  GERA REQUISIÇÃO NO PROTHEUS, O SIFROTA ATRAVES DA INTERFACE SISMON
GERA REGISTROS NA TABELA SZ5 DO BANCO Protheus12, ESSE PONTO DE ENTRADA
GERA REQUISICAO NO PROTHEUS APENAS DE REGISTROS QEU TEM O CAMPO Z5_PROCESS'N'
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GerMovSCP()

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

cQuery:= "SELECT Z5_OSSIFRO AS OS, Z5_REQSIFR AS REQ"
cQuery+= " FROM "+Retsqlname('SZ5')+" SZ5"
cQuery+= " WHERE Z5_PROCESS = 'N' "
cQuery+= " GROUP BY Z5_OSSIFRO,Z5_REQSIFR"
cQuery+= " ORDER BY Z5_OSSIFRO,Z5_REQSIFR"

TCQuery cQuery NEW ALIAS "DOCS"


IF DOCS->(!EOF())
	WHILE DOCS->(!EOF())
		
		cQuery2:= "SELECT * "
		cQuery2+= " FROM "+Retsqlname('SZ5')+" SZ5"
		cQuery2+= " WHERE Z5_PROCESS = 'N' "
		cQuery2+= " AND Z5_OSSIFRO = '"+DOCS->OS+"' "
		cQuery2+= " AND Z5_REQSIFR = '"+DOCS->REQ+"' "
		cQuery2+= " ORDER BY Z5_OSSIFRO,Z5_REQSIFR "
		
		TCQuery cQuery2 NEW ALIAS "LANC"
		
		WHILE LANC->(!EOF())
			
			IF POSICIONE("SB1",1,XFILIAL("SB1")+LANC->Z5_PRODUTO,"B1_SERVIC") == "S"  // caso seja serviço gera solicitação de compra direta
				cNUMSC := GETSXENUM("SC1")
				RECLOCK("SC1",.T.)
				REPLACE C1_FILIAL  WITH xFILIAL("SC1")
				REPLACE C1_FILENT  WITH xFILIAL("SC1")
				REPLACE C1_NUM     WITH cNUMSC
				REPLACE C1_ITEM    WITH "0001" //strzero(1,4)
				REPLACE C1_PRODUTO WITH LANC->Z5_PRODUTO
				REPLACE C1_DESCRI  WITH POSICIONE("SB1",1,XFILIAL("SB1")+LANC->Z5_PRODUTO,"B1_DESC")
				REPLACE C1_UM      WITH LANC->Z5_UM
				REPLACE C1_QUANT   WITH LANC->Z5_QUANT
				REPLACE C1_EMISSAO WITH DATE()
				REPLACE C1_DATPRF  WITH DATE()
				REPLACE C1_LOCAL   WITH LANC->Z5_LOCAL
				REPLACE C1_OSSIFRO WITH LANC->Z5_OSSIFRO
				REPLACE C1_REQSIFR WITH LANC->Z5_REQSIFR
				REPLACE C1_SOLICIT WITH "SIFROTA"
				REPLACE C1_OBS     WITH "SC GERADA P/ SIFROTA - "+ALLTRIM(LANC->Z5_OBS)
				SC1->(MSUNLOCK())
				ConfirmSX8()
				
			ELSE
				cDoc := GETSXENUM("SCP")
				RECLOCK("SCP",.T.)
				REPLACE SCP->CP_FILIAL WITH XFILIAL("SCP")
				REPLACE SCP->CP_NUM  WITH cDoc
				REPLACE SCP->CP_ITEM WITH "01"
				REPLACE SCP->CP_PRODUTO WITH LANC->Z5_PRODUTO
				REPLACE SCP->CP_UM WITH LANC->Z5_UM
				REPLACE SCP->CP_QUANT WITH LANC->Z5_QUANT
				REPLACE SCP->CP_DATPRF WITH STOD(LANC->Z5_DATPRF)
				REPLACE SCP->CP_LOCAL WITH LANC->Z5_LOCAL
				REPLACE SCP->CP_OBS WITH LANC->Z5_OBS
				REPLACE SCP->CP_CC WITH LANC->Z5_CC
				REPLACE SCP->CP_EMISSAO WITH STOD(LANC->Z5_EMISSAO)
				REPLACE SCP->CP_DESCRI WITH POSICIONE("SB1",1,XFILIAL("SB1")+LANC->Z5_PRODUTO,"B1_DESC")
				REPLACE SCP->CP_SOLICIT WITH LANC->Z5_SOLICIT
				REPLACE SCP->CP_DOCSIFR WITH LANC->Z5_DOCSIFR
				REPLACE SCP->CP_OSSIFRO WITH LANC->Z5_OSSIFRO
				REPLACE SCP->CP_REQSIFR WITH LANC->Z5_REQSIFR
				MSUNLOCK()
				CONFIRMSX8()
			ENDIF
		
			LANC->(DBSKIP())
		END
		LANC->(DBCLOSEAREA())
		
		
		cQuery3:= "UPDATE "+Retsqlname('SZ5')+" "
		cQuery3+= " SET Z5_PROCESS = 'S' "
		cQuery3+= " WHERE Z5_PROCESS = 'N' "
		cQuery3+= " AND Z5_OSSIFRO = '"+DOCS->OS+"' "
		cQuery3+= " AND Z5_REQSIFR = '"+DOCS->REQ+"' "
		TCSQLExec(cQuery3)
		
		DOCS->(DBSKIP())
	END
Endif
Msgbox("Registros processados com sucesso!","Statisticas do Processo","Info")
DOCS->(DBCLOSEAREA())
Return
