#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"                                 
                                                         
                                                         
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ         
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AJDELSAL  ºAutor  ³HENRIQUE TOFANELLI  º Data ³  20/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CALCULO FOLHA           
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION AJDELSAL()

//local _NValSal2791 := GETMV("MV_SAL2791")
//local _nValDiaria := GETMV("MV_DIA2791")

//IF SRM->RM_CALCULO == "FOL" .AND. FUNNAME() <> "GPEA070"

IF  FUNNAME() == "GPEM020"

_nSaldoMes      := salmes
_nSalarioMes    := salario

//SALMES := _NValSal2791
//salario := _NValSal2791

salmes := 0
saldia := 0
salhora := 0
SALARIO := 0

ENDIF
//FDELPD("101")  //Apaga Verba de Salario Base do Rural

//aSvAlias:={ALIAS(),INDEXORD(),Recno()}    //SAVE AREA

Return()

