#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"

//Solicita valor do ICMS no pedido de venda para prencher DAE.

User Function MTA410I()

	_AREA := GETAREA()

	IF (SC6->C6_TES="502" .OR. SC6->C6_TES="547") .AND. (SC6->C6_PRODUTO='0054010002')//.OR. SC6->C6_PRODUTO='010003')
		IF SA1->A1_EST="SE" .AND. SA1->A1_PESSOA<>"F"
			xICMS := (SC6->C6_VALOR*0.25)*0.062
		ELSEIF SA1->A1_EST<>"SE" .AND. SA1->A1_PESSOA<>"F"
			xICMS := (SC6->C6_VALOR*0.12)*0.062
		END
		MESSAGEBOX("VALOR DO ICMS PARA PREENCHER D.A.E. DO PEDIDO: "+SC6->C6_NUM+" �  "+ALLTRIM(TRANSFORM(xICMS,"999,999,999.99")),"ATEN��O",0)
	ELSE
		Return (.F.)
	ENDIF

	dbCloseArea()
	RESTAREA(_AREA)
Return(.T.)