#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"                                 
                                                         
                                                         
/*���������������������������������������������������������������������������         
�����������������������������������������������������������������������������
���Programa  �UNIQUI    �Autor  �HENRIQUE TOFANELLI  � Data �  20/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � CALCULO 1 PAR4CELA 13���
�������������������������������������������������������������������������͹��
���������������������������������������������������������������������������*/
USER FUNCTION AJUS131()

local _NValSal2791 := GETMV("MV_SAL2791")

_nSaldoMes      := salmes
_nSalarioMes    := salario

SALMES := _NValSal2791
salario := _NValSal2791

//aSvAlias:={ALIAS(),INDEXORD(),Recno()}    //SAVE AREA



Return()

