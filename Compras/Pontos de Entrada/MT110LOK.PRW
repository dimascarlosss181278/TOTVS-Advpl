/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1100I ³ Autor: José Luiz F.S.Junior  Data ³novembro/2017  ³±±
±±³          ³          ³       ³                        ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc      ³ Ponto de entrada para verificar saldo em estoque na geração³ ±±
±±³          ³ da SIC                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sigacom - Campo Lindo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nao existe                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                            ALTERACOES                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data   ³ Programador ³Solic Cliente ³Alteracoes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³04/12/17³ Dimas    ³TI    ³Rotina foi alterada para alterar não permitir³±±
±±³        ³          ³                 ³inserir nova linha apos a menssagem±±
±±³        ³          ³                 ³de alerta que possui saldo        ³±±
±±³18/07/19³ Junior   ³TI    ³Rotina foi otimizada                         ³±±
±±³        ³          ³                 ³								    ±±
±±³        ³          ³                 ³								   ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110LOK()

Local a_Area		:= GetArea()
Local lRet 			:= .F.
Local nPosProd 		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nPosLocal		:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_LOCAL'})
//Local userId		:= RetCodUsr()
Local usersId		:= "000142/000146/000019/000024/000013/000037/000000/000016"
//usersId := REJANE/ALIANE/MARLINGTHON/FERNANDA/ADRIANA/DIMAS/ADMIN/CICERO
Private aSaldos 	:= {}
Private nQuant 		:= 0

For nX :=1 To Len( aCols )

	c_Produto := aCols[nX][nPosProd] // Retorna o codigo do produto que foi informado no item
	c_Local := aCols[nX][nPosLocal] // Retorna o codigo do produto que foi informado no item
	
	aSaldos := CalcEst(c_Produto, c_Local, dDatabase+1)

	nQuant := aSaldos[1]
	
	lRet := IIf((RetCodUsr() $ usersId), .T., .F.)
	
	If lRet == .F.
		If nQuant <= 0
			lRet := .T.
		Else
			lRet := .F.
			MsgInfo("O produto Cod: "+ AllTrim(c_Produto) +"Arm: "+(AllTrim(c_Local)) +" informado possui saldo disponivel ","Atencao")
		EndIf
	EndIf
Next nX	
	
RestArea(a_Area)

Return lRet
