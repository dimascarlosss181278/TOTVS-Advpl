#Include 'Protheus.ch'

User Function  MT120OK()

	Local a_Area		:= GetArea()

	Local nPosCC  		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CC'})
	Local lValido		:= .T.
	Local nX       		:= 0
	Local proxreg

	For nX :=1 To Len( aCols )

		If !aCols[nX][Len(aHeader)+1] .AND. Len( aCols ) > 1 	//Verifica se linha nao esta Deletada
				
			If nX == Len( aCols )
				Exit
			ElseIf !aCols[nX+1][Len(aHeader)+1] //Verifica se a proxima linha nao esta Deletada

				prox_reg := aCols[nX+1][nPosCC] // Guarda na variavel o centro de custo do proximo registro
		
				If aCols[nX][nPosCC] == prox_reg // Verifico se o centro de custo do registro posicionado é o centro de custo do próximo registro.
					
					loop
					
				Else
						
					lValido := .F.
					MsgAlert('Não é permitida a inclusão de pedido de compras com centro de custos diferentes.','Centro de Custos x Ped. Compras')
					Exit
					
				EndIf
				
			EndIf
			
		EndIf
				
	Next nX

	RestArea(a_Area)

Return(lValido)

