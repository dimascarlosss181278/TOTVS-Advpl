#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"                                 
                                                         
                                                         
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ         
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³UNIQUI    ºAutor  ³HENRIQUE TOFANELLI  º Data ³  20/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CALCULO RESCISAO           
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION AJSALFAM()

local _NValSal2791 := GETMV("MV_SAL2791")
local _Quantidade := SRA->RA_DEPSF
Local _valor129 := 0
//MsgInfo(_valor129,"Atencao")
_nBaseSalFam   := NSALFAMI_B


//MSGBOX("Val NSALFAMI_B " +str(NSALFAMI_B,12,2)+ " ")
		
NSALFAMI_B := NSALFAMI_B - _NValSal2791

//MSGBOX("Val NSALFAMI_B DEPOIS " +str(NSALFAMI_B,12,2)+ " ")

//MSGBOX("Val NSAL_FAMI " +str(NSAL_FAMI,12,2)+ " ")

//MSGBOX("Val Verba 129 " +str(Fbuscapd("129"),12,2)+ " ")

If CFUNROTEXEC == "S_ROT__FOL()" .And. Val(_Quantidade) # 0
	If NSALFAMI_B <= NLIMSF1
		_valor129 := Val(_Quantidade) * NVAL_SF1
		FDELPD("129")
		FGERAVERBA("129",_valor129,,,,,,,,,.T.)
 	elseIf NSALFAMI_B <= NLIMSF2
 		_valor129 := Val(_Quantidade) * NVAL_SF2
 		FDELPD("129")
 		FGERAVERBA("129",_valor129,,,,,,,,,.T.)
 	EndIf

EndIf


Return()

