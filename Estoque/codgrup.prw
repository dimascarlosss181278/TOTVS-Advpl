#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CODGRUP                                  �  ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa procura o produdo de maior codigo baseado no codigo���
���          �do grupo e gera um codigo de produto de acordo com o grupo  ���
���          �escolhid                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CODGRUP()
	
	Local a_Area 	:= GetArea()
	Local _Grupo 	:= M->B1_GRUPO
	Local _Cod	:= Space(6)
	
	_cArqSB1:= retsqlname("SB1")
	
	cQry1 := "SELECT MAX(SB1.B1_COD) AS MCOD, COUNT(*) AS CONT  FROM " + _cArqSB1 +" SB1"
	cQry1 += " WHERE SB1.D_E_L_E_T_ <> '*'"
	cQry1 += " AND SB1.B1_GRUPO = '" + _Grupo + "'"
	cQry1 += " AND SB1.B1_COD LIKE '" + _Grupo + "%'"
	cQry1 += " ORDER BY MCOD"
	
	TCQUERY cQry1 NEW ALIAS "PSQSB1"
	
	dbSelectArea("PSQSB1")
	dbGoTop()
	
	IF PSQSB1->CONT != 0
		_Cod := STRZERO(VAL(PSQSB1->MCOD)+1,10)
	ELSE
		_Cod := SUBSTR(M->B1_GRUPO,1,4)+"000001"
	ENDIF
	
	DbSelectArea("SB1")
	DbSeek(XFILIAL("SB1")+_Cod)
	_Desc:= TRIM (SB1->B1_DESC)
	
	IF !EOF()
		
		MSGBOX("Produto: " + _Cod +" - "+ _Desc ,"REGISTRO JA EXISTENTE !" ,"ALERT")
		_Cod:=""
		
	ENDIF
	
	PSQSB1->(DbCloseArea())
	
	RestArea(a_Area)
	
Return(_Cod)
