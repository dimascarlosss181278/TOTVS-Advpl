#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �PESQSAL2791 �Autor  �HENRIQUE TOFANELLI  � Data �  31/03/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � BUSCA SALARIO BASE RURAL
�������������������������������������������������������������������������͹��
���������������������������������������������������������������������������*/
USER FUNCTION PESQSAL2791(_RefMes,_nOpcao)

//_nOpcao
// 1 = Busca Valor do Salario
// 2 = Busca Valro da Di�ria

_ValReturn := 0

IF empty(_RefMes)
	
	MSGBOX("Fun��o PesqSal2791  -  O par�metro de Ref. do M�s n�o foi informado corretamente", "Alert")
	return(_ValReturn)
	
ELSE
	
	If _nOpcao == 1
		
		_ValReturn := POSICIONE("SZ6",1,xFilial("SZ6")+_RefMes,"Z6_SAL2791")
		
	Elseif _nOpcao == 2
		
		_ValReturn := POSICIONE("SZ6",1,xFilial("SZ6")+_RefMes,"Z6_DIA2791")
		
	ENDIF
	
	IF _ValReturn == 0
		
		MSGBOX("Fun��o PesqSal2791  -  N�o foi encontrado sal�rio definido para o per�odo "+ _RefMes +"  Verifique os par�metros", "Alert")
		return(_ValReturn)
		
	ENDIF
ENDIF
Return(_ValReturn)

