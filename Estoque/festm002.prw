#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
 
User Function festm002

	Local nRecCount := 0
	
	BEGINSQL ALIAS "TRB"
		SELECT * FROM SB2989
	ENDSQL
	
	COUNT TO nRecCount

	If nRecCount > 1
	
		dbSelectArea("TRB")
		TRB->(dbGoTop())
	
		ConOut(Repl("-",80))
		ConOut(PadC("Teste de Cadastro de Saldos Iniciais",80))
		ConOut("Inicio: "+Time())
		//------------------------//| Teste de Inclusao    |//------------------------
		Begin Transaction

			For nX := 1 to nRecCount
		
				dbSelectArea('SB9')
				dbSetOrder(1) //B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
				If dbSeek(xFilial("SB9")+TRB->B1_COD+TRB->B2_LOCAL+'20160104',.F.)
					msgInfo("Atencao o produto "+ALLTRIM(TRB->B1_COD)+" ja foi incluido","RECDUP")
					TRB->(dbSkip())
					loop
				Else
					RecLock("SB9",.T.)
			
					SB9->B9_FILIAL 	:= TRB->B2_FILIAL
					SB9->B9_LOCAL	:= TRB->B2_LOCAL
					SB9->B9_COD		:= TRB->B1_COD
					SB9->B9_QINI	:= TRB->B2_QATU
					SB9->B9_VINI1	:= TRB->B2_VATU1
					SB9->B9_DATA	:= StoD('20160104')
			
					TRB->(msUnLock())
					TRB->(dbSkip())
					
				EndIf

			Next nX
		
			ConOut("Fim  : "+Time())
		End Transaction
	Else
		msgInfo("NOREC","Nenhum registro a ser importado!")
	EndIf

Return Nil
