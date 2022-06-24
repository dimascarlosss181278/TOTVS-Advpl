#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณPESQSAL2791 บAutor  ณHENRIQUE TOFANELLI  บ Data ณ  31/03/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ BUSCA SALARIO BASE RURAL
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION PESQSAL2791(_RefMes,_nOpcao)

//_nOpcao
// 1 = Busca Valor do Salario
// 2 = Busca Valro da Diแria

_ValReturn := 0

IF empty(_RefMes)
	
	MSGBOX("Fun็ใo PesqSal2791  -  O parโmetro de Ref. do M๊s nใo foi informado corretamente", "Alert")
	return(_ValReturn)
	
ELSE
	
	If _nOpcao == 1
		
		_ValReturn := POSICIONE("SZ6",1,xFilial("SZ6")+_RefMes,"Z6_SAL2791")
		
	Elseif _nOpcao == 2
		
		_ValReturn := POSICIONE("SZ6",1,xFilial("SZ6")+_RefMes,"Z6_DIA2791")
		
	ENDIF
	
	IF _ValReturn == 0
		
		MSGBOX("Fun็ใo PesqSal2791  -  Nใo foi encontrado salแrio definido para o perํodo "+ _RefMes +"  Verifique os parโmetros", "Alert")
		return(_ValReturn)
		
	ENDIF
ENDIF
Return(_ValReturn)

