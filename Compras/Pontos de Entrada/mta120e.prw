#Include 'Protheus.ch'

User Function mta120e()

	Local a_Area := GetArea()
	Local ExpN1  := PARAMIXB[1]
	Local ExpC1  := PARAMIXB[2]
	
	Private cDescMot	:= criavar("C7_JUSCOM")
	Private oDlg
	Private ExpL1  := .T.

	#define DS_MODALFRAME   128
	
	If  ExpN1 == 1
		//**************************************************************************
		//  U S O  D A  J U S T I F I C A T I V A
		//**************************************************************************
		DEFINE MSDIALOG oDlg Title "Justificativa da Exclus�o" From 200,001 to 300,330 Pixel Style DS_MODALFRAME

		@ 005,005 SAY "Justifique a exclusao do PC" Of oDlg Pixel
		@ 020,005 SAY "Justificativa :" Of oDlg Pixel
		@ 020,051 Get cDescMot   size 80,10 Valid Execblock("Al_Valid") Of oDlg Pixel

		DEFINE SBUTTON OemToAnsi("Gravar...") FROM 035,100 TYPE 1 ACTION (_Ok4() := 1,oDlg:end() ) ENABLE OF oDlg Pixel

		oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.

		ACTIVATE DIALOG oDlg CENTERED
	
	EndIf
	
	RestArea(a_Area)

    AmarrPCxPA()

Return(ExpL1)

//**************************************************************************
//  GRAVA INFORMAÇÕES DA TELA DE JUSTIFICATIVA
//**************************************************************************
Static Function _Ok4()

	//--------------------------------------------------------------
	//	Atualiza SC1
	//--------------------------------------------------------------
	Reclock("SC7",.F.)
	SC7->C7_JUSCOM := cDescMot
	MsUnlock()

Return

//**************************************************************************
//  VALIDA INFORMAÇÕES DO CAMPO DE JUSTIFICATIVA
//**************************************************************************
User Function Al_Valid
	
	ExpL1 := .T.

	If empty(alltrim(cDescMot))
		ExpL1 := .F.
		msgalert("O preenchimento da justificativa e obrigatorio","Info")
	Else
		ExpL1 := .T.
	EndIf

Return(ExpL1)

/*
Verifica se o PC esta amarrado a um PA e bloqueia a exclusao
Bloqueio solicitado pelo setor financeiro
*/
Static Function AmarrPCxPA
Local c_Alias := Alias()
Local n_Ordem := IndexOrd()
Local n_Recno := Recno()

dbSelectArea("FIE")
dbSetOrder(1)
dbSeek(xFilial("FIE")+"P"+SC7->C7_NUM,.F.)

If !Eof()
   c_PA  := "O pedido de compras est� associado ao PA " + Alltrim(FIE->FIE_PREFIX)+" "+Alltrim(FIE_NUM)+ " " +Alltrim(FIE_PARCEL) + " do Fornecedor " + FIE_FORNEC+"-"+FIE_LOJA + ". Favor entrar em contato com o financeiro!"
   MsgAlert(c_PA,"Info")
   ExpL1 := .F.
EndIf

Return(ExpL1)