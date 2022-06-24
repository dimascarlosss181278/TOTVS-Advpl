#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"                                 
                                                         
                                                         
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ         
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณUNIQUI    บAutor  ณHENRIQUE TOFANELLI  บ Data ณ  20/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CALCULO RESCISAO           
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION AJSALRE()

local _NValSal2791 := GETMV("MV_SAL2791")
//local _nValDiaria := GETMV("MV_DIA2791")

_nSaldoMes      := salmes
_nSalarioMes    := salario

/*
SALMES := _NValSal2791
salario := _NValSal2791	
saldia := _NValSal2791/30
salhora := _NValSal2791/220        
*/

salmes := 0
saldia := 0
salhora := 0
SALARIO := 0
              
//aSvAlias:={ALIAS(),INDEXORD(),Recno()}    //SAVE AREA

Return()

