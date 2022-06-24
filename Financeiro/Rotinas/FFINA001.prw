#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � FFINA001 � Autor � Manoel Crispim         � Data �17/11/15  ���
���          �          �       �                        �      �          ���
��������������������������������������������������������������������������Ĵ��
���Desc      � Rotina utlizada para bloquear que os usuarios do financeiro ���
���          � possam desfazer amarracao entre o PC x PA                   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Sigafin - Campo Lindo                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nao existe                                                  ���
��������������������������������������������������������������������������Ĵ��
���                            ALTERACOES                                  ���
��������������������������������������������������������������������������Ĵ��
��� Data   � Programador �Solic Cliente �Alteracoes                        ���
��������������������������������������������������������������������������Ĵ��
���19/11/15� Manoel      �Financeiro/TI �Rotina foi alterada para permitir ���
���        �             �Incluir a amarracao do PC x PA                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function FFINA001
	 
	 ValidPerg()
	 
     SetPrvt("oDlg1","oBmp1","oSay1","oSay2","oSay3","","","oSBtn1","oSBtn2","oSBtn3")

	 oDlg1  := MSDialog():New( 091,232,267,658,"Amarra��o PC x PA",,,.F.,,,,,,.T.,,,.T. )
	 oBmp1  := TBitmap():New( 008,008,056,028,,"\system\CampoLindo.png",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	 oSay1  := TSay():New( 008,115,{||"Amarra��o PC x PA"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
 	 oSay2  := TSay():New( 017,072,{||"Rotina ir� incluir ou excluir a amarra��o entre o Pedido"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
   	 oSay3  := TSay():New( 026,072,{||"de Compras-PC e o Pagamento Antecipado-PA"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
   //oSay4  := TSay():New( 035,072,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
 	 oSBtn1 := SButton():New( 060,164,2,{||Close(oDlg1)},oDlg1,,"", )
	 oSBtn2 := SButton():New( 061,129,1,{||FINA001()},oDlg1,,"", )
	 oSBtn3 := SButton():New( 061,093,5,{||Pergunte('FFINA001')},oDlg1,,"", )

     oDlg1:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
	 oDlg1:Activate(,,,.T.)
Return


/*
Rotina para desfazer a amarracao
entre o PC x PA
*/
Static Function FINA001
Local c_Usuario, c_Fornece, c_Loja

c_Fornece := Space(06)
c_Loja    := Space(03)

c_Usuario := Alltrim(Getmv("CC_USUARIO"))

If __cUserID <> c_Usuario
   MsgBox("Usu�rio n�o tem permiss�o para executar a rotina")
Else
   If MV_PAR08 = 1 // Incluir amarracao entre o PC x PA
      dbSelectArea("FIE")
      dbSetOrder(1)
      dbSeek(xFilial("FIE")+"P"+MV_PAR01,.F.)
      
      If Eof()
         dbSelectArea("SC7")
         dbSetOrder(1)
         dbSeek(xFilial("SC7")+MV_PAR01,.F.)
         
         If !Eof()
            c_Fornece := SC7->C7_FORNECE
            c_Loja    := SC7->C7_LOJA
         EndIf

         If c_Fornece != MV_PAR06 .Or. c_Loja != MV_PAR07
            MsgBox("Fornecedor "+ Alltrim(MV_PAR06) + " e Loja " + Alltrim(MV_PAR07) + " informados nos par�metros s�o diferentes do Fornecedor " + Alltrim(c_Fornece) + " e Loja " + Alltrim(c_Loja) + " do PC!")
         Else
            dbSelectArea("SE2")
            dbSetOrder(1)
            dbSeek(xFilial("SE2")+MV_PAR03+MV_PAR02+MV_PAR04+MV_PAR05+MV_PAR06+MV_PAR07,.F.)

            If !Eof() .And. SE2->E2_SALDO <> 0
               Reclock("FIE",.T.)
               Replace FIE_FILIAL  With SE2->E2_FILIAL
               Replace FIE_CART    With "P"
               Replace FIE_PEDIDO  With MV_PAR01
               Replace FIE_PREFIX  With SE2->E2_PREFIXO
               Replace FIE_NUM     With SE2->E2_NUM
               Replace FIE_PARCEL  With SE2->E2_PARCELA
               Replace FIE_TIPO    With SE2->E2_TIPO
               Replace FIE_FORNECE With SE2->E2_FORNECE
               Replace FIE_LOJA    With SE2->E2_LOJA
               Replace FIE_VALOR   With SE2->E2_VALOR
               Replace FIE_SALDO   With SE2->E2_SALDO
               MsUnlock()
               
               MsgBox("Inclus�o da amarra��o entre o PC e o PA conclu�da com sucesso!")
            Else
               MsgBox("PA informado n�o existe no Financeiro ou j� foi compensado totalmente. Favor Verificar!")
            EndIf
         EndIf
      Else
         dbSelectArea("SE2")
         dbSetOrder(1)
         dbSeek(xFilial("SE2")+FIE->(FIE_PREFIX+FIE_NUM+FIE_PARCEL+FIE_TIPO+FIE_FORNECE+FIE_LOJA),.F.)

         MsgBox("J� existe amarra��o do Pedido de Compras " + Alltrim(MV_PAR01) + " com o PA " + Alltrim(SE2->E2_PREFIXO) + " - "  + Alltrim(SE2->E2_NUM) + " - " + ;
                 Alltrim(SE2->E2_PARCELA) + " - " + Alltrim(SE2->E2_TIPO) + " - " + Alltrim(SE2->E2_FORNECE) + " - " + Alltrim(SE2->E2_LOJA))
      EndIf

   Else              // Excluir amarracao entre o PC x PA
      dbSelectArea("FIE")
      dbSetOrder(3)
      dbSeek(xFilial("FIE")+"P"+MV_PAR06+MV_PAR07+MV_PAR03+MV_PAR02+MV_PAR04+MV_PAR05+MV_PAR01,.F.)
                          // FIE_FILIAL+FIE_CART+FIE_FORNEC+FIE_LOJA+FIE_PREFIX+FIE_NUM+FIE_PARCEL+FIE_TIPO+FIE_PEDIDO 
      If !Eof()
         dbSelectArea("SE2")
         dbSetOrder(1)
         dbSeek(xFilial("SE2")+MV_PAR03+MV_PAR02+MV_PAR04+MV_PAR05+MV_PAR06+MV_PAR07,.F.)

         If !Eof()
            If Empty(SE2->E2_BAIXA)
               Reclock("FIE",.F.)
               DELETE
               MsUnlock()

               MsgBox("Exclus�o da amarra��o entre o PC e o PA conclu�da com sucesso!")
            Else
               MsgBox("PA j� foi compensado, n�o � poss�vel desfazer a amarra��o entre o PC e o PA!")
            EndIf
         EndIf
      Else
         MsgBox("A amarra��o informada n�o existe, favor revisar os par�metros informados!")
      EndIf
   EndIf
EndIf

Return

/*
Cria o par�metro da rotina
*/
Static Function ValidPerg

cAlias := Alias()

dbSelectArea("SX1")
Alert("Teste", "Atencao")
dbSetOrder(1)

cPerg := "FFINA001"
cPerg := PADR(cPerg,10)
aRegs:={}

aAdd(aRegs,{cPerg,"01","Pedido de Compra   ?","Pedido de Compra   ?","Pedido de Compra   ?","mv_ch1","C", 6,0,0,"G","Naovazio()","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7CCL","",""})
aAdd(aRegs,{cPerg,"02","Pagto Antecipado   ?","Pagto Antecipado   ?","Pagto Antecipado   ?","mv_ch2","C", 9,0,0,"G","Naovazio()","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","SPACCL","",""})
aAdd(aRegs,{cPerg,"03","Prefixo            ?","Prefixo            ?","Prefixo            ?","mv_ch3","C", 3,0,0,"G",""          ,"Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Parcela            ?","Parcela            ?","Parcela            ?","mv_ch4","C", 2,0,0,"G",""          ,"Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","011"})
aAdd(aRegs,{cPerg,"05","Tipo               ?","Tipo               ?","Tipo               ?","mv_ch5","C", 3,0,0,"G",""          ,"Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Fornecedor         ?","Fornecedor         ?","Fornecedor         ?","mv_ch6","C", 6,0,0,"G",""          ,"Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","001"})
aAdd(aRegs,{cPerg,"07","Loja               ?","Loja               ?","Loja               ?","mv_ch7","C", 3,0,0,"G",""          ,"Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","002"})
aAdd(aRegs,{cPerg,"08","Tipo da Operacao   ?","Tipo da Operacao   ?","Tipo da Operacao   ?","mv_ch8","C", 1,0,0,"C","Naovazio()","Mv_Par08","Inclusao","Inclusao","Inclusao","","","Exclusao","Exclusao","Exclusao","","","","","","","","","","","","","","","","","","",""})

For i:=1 To Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 To FCount()
			If j <= Len(aRegs[i])
			   FieldPut(j,aRegs[i,j])
			EndIf
		Next
	
		MsUnlock()
	EndIf
Next

dbSelectArea(cAlias)

Return()