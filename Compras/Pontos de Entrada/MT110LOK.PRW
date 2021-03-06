/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � SF1100I � Autor: Jos� Luiz F.S.Junior  Data �novembro/2017  ���
���          �          �       �                        �      �          ���
��������������������������������������������������������������������������Ĵ��
���Desc      � Ponto de entrada para verificar saldo em estoque na gera��o� ��
���          � da SIC                                                      ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Sigacom - Campo Lindo                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nao existe                                                  ���
��������������������������������������������������������������������������Ĵ��
���                            ALTERACOES                                  ���
��������������������������������������������������������������������������Ĵ��
��� Data   � Programador �Solic Cliente �Alteracoes                        ���
��������������������������������������������������������������������������Ĵ��
���04/12/17� Dimas    �TI    �Rotina foi alterada para alterar n�o permitir���
���        �          �                 �inserir nova linha apos a menssagem��
���        �          �                 �de alerta que possui saldo        ���
���18/07/19� Junior   �TI    �Rotina foi otimizada                         ���
���        �          �                 �								    ��
���        �          �                 �								   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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
