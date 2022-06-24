#Include 'Protheus.ch'

User Function mta105lin()

	Local a_Area		:= GetArea()
	Local lRet 			:= .F.
	Local nPosProd 		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_PRODUTO'})
	Local nPosLocal		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_LOCAL'})
	
	Private aSaldos 	:= {}
	Private nQuant 		:= 0

	For nX :=1 To Len( aCols )
	
		c_Produto := aCols[nX][nPosProd] // Retorna o codigo do produto que foi informado no item
		c_Local := aCols[nX][nPosLocal] // Retorna o codigo do produto que foi informado no item
		
		aSaldos := CalcEst(c_Produto, c_Local, dDatabase+1)
	
		nQuant := aSaldos[1]

		If nQuant > 0
			lRet := .T.
		Else
			MsgInfo("O produto informado nao possui saldo disponivel nesse armazem","Atencao")
		EndIf
	
	Next nX
	
	RestArea(a_Area)

Return lRet