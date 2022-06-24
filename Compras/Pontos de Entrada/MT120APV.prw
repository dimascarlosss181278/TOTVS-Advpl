#include "rwmake.ch"
#include "topconn.CH"

/*
Programa:	MT120APV.PRW
Descri��o:  Ponto de entrada executado na inclus�o do pedido de compra e durante 
			a gera��o do pedido atrav�s da an�lise da cota��o. Tem o objetivo de
			gravar no pedido o grupo de aprovadores associado � ag�ncia 
			informada no pedido ou na solicita��o de compras.
*/          

User Function MT120APV()
	
	//Local ExpC1 	:= PARAMIXB[1]
	//Local ExpC2 	:= PARAMIXB[2]	
	Local cGrupoap:= ""

	Local cAliasP := Alias()
	Local nOrd 	:= dbSetOrder()
	Local nReg		:= Recno()
	Local a_Area	:= GetArea()	
	Local cCC		:= SC7->C7_CC
	Local cPedido := SC7->C7_NUM
	
	If FunName() == "MATA121"
		dbSelectArea('SC7')
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+cPedido)
		
		cGrupoap	:= posicione("CTT",1,xFILIAL("CTT")+cCC,"CTT_GPPCAP")
		//cGrupoap	:= "000001"
		
		If Found()
			Do While !Eof() .And. SC7->C7_NUM = cPedido
				RecLock("SC7",.F.)
				REPLACE SC7->C7_APROV WITH cGrupoap
				MsUnLock()
				SC7->(dbSkip())
			Enddo
		Endif
	    
		If empty(cGrupoap)
			nTitulo := "Erro C7_APROV"
			nMsg	:= " N�o foi poss�vel salvar a Pedido."
			nMsg	+= " A rotina nao conseguiu achar um grupo de aprova��o."
			nMsg	+= " Favor verificar as configura��es de Aprovadores."
	    	msgbox(" "+nMsg+" ","Alerta")
		EndIf
		
		Alert("Ponto de Entrada MT120APV - Pedido de Compra")	
	ElseIf FunName() == "MATA161"  // Se for executado a partir da rotina de an�lise de cota��o,
		ExpC1 	:= PARAMIXB[1]
		ExpC1 	:= PARAMIXB[2]
		dbSelectArea(cAliasP)
		dbSetOrder(nOrd)
		dbGoTo(nReg)
				
		cGrupoap	:= posicione("CTT",1,xFILIAL("CTT")+cCC,"CTT_GPPCAP")
		//cGrupoap	:= "000001"
		
		If Found()
			Do While !Eof() .And. SC7->C7_NUM = cPedido
				RecLock("SC7",.F.)
				REPLACE SC7->C7_APROV WITH cGrupoap
				MsUnLock()
				SC7->(dbSkip())
			Enddo
		Endif
		
		MsgInfo("Ponto de Entrada MT120APV - Analise de Cota��o", "Aviso")
				
	EndIf
	
	RestArea(a_Area)

Return(cGrupoap)