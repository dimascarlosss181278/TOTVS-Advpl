#INCLUDE "rwmake.ch"

User function AJUINSA()

_nValDiaria := GETMV("MV_DIA2791")
_NValSal2791 := GETMV("MV_SAL2791")

_NrDiasTrab := 0
_NrDiasDesc := 0
_NDiasMes   := 0
_NDiasMes := (dDatabase - FirstDay(dDataBase)) + 1
If _NDiasMes < 30
	_NDiasMes = 30
EndIf
//(LastDay(dDataBase)


// ----  Tratamento para Admissão

If SRA->RA_ADMISSA >= FirstDay(dDataBase) .AND. SRA->RA_ADMISSA <= DDATABASE
	_NrDiasDesc += (SRA->RA_ADMISSA - FirstDay(dDataBase))//-1
	
	//USADO PARA MUDAR O SALARIO QUE O FUNCIONARIO TEM DIREITO DE ACORDO COM OS DIAS TRABALHADOS
	IF _NrDiasDesc <> 0
		_nValSal2791 := ((_NDiasMes -_NrDiasDesc)*_nValDiaria)
	ENDIF
	
EndIf

// ----  Tratamento para Demissão


If SRA->RA_DEMISSA >= FirstDay(dDataBase) .AND. SRA->RA_ADMISSA <= DDATABASE
	_NrDiasDesc += (dDataBase - SRA->RA_DEMISSA)
	
EndIf

_DiasPericu := _NrDiasDesc  //usado para calcular hrs de periculosidade

// ----  Tratamento para Afastamento

cQry1:=" SELECT R8_FILIAL, R8_MAT, R8_TIPO, R8_DATAINI, R8_DATAFIM  "+;
" FROM "+RetSqlName("SR8")+" "+;
" WHERE (R8_DATAINI BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM > '"+DTOS(DDATABASE)+"') "+;
" AND R8_FILIAL = '"+XFILIAL("SR8")+"' "+;
" AND R8_MAT = '"+SRA->RA_MAT+"' "+;
" AND R8_TIPO <> 'F' "+;
" AND D_E_L_E_T_ = '' "+;
" ORDER BY R8_DATAINI "

cQry1	:= ChangeQuery(cQry1)
//MemoWrite("PosAfast.sql",cQry1)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry1), 'AFAST', .F., .T.)

_QtdAfast := 0

While AFAST->(!Eof())
	_DataIniA := ""
	_DataFimA := ""
	
	
	IF stod(AFAST->R8_DATAINI) < FirstDay(dDatabase) .AND. stod(AFAST->R8_DATAFIM) >= FirstDay(dDatabase)
		//		  IF stod(AFAST->R8_DATAFIM) <= (dDatabase) .AND. stod(AFAST->R8_DATAFIM) >= FirstDay(dDatabase)  // Inicio do afastamento iniciou em mes anterio
		_DataIniA := FirstDay(dDatabase)
	ELSE
		_DataIniA := stod(AFAST->R8_DATAINI)
	ENDIF
	
	
	IF stod(AFAST->R8_DATAFIM) > (dDatabase)  // fim do afastamento é no próximo período
		_DataFimA := (dDatabase)
	ELSE
		_DataFimA := stod(AFAST->R8_DATAFIM)
	ENDIF
	
	_QtdAfast  += (_DataFimA - _DataIniA)+1
	
	AFAST->(DBSKIP())
ENDDO
_NrDiasDesc += _QtdAfast

AFAST->(DBCLOSEAREA())


// ----  Tratamento para Férias


cQry2:=" SELECT R8_FILIAL, R8_MAT, R8_TIPO, R8_DATAINI, R8_DATAFIM  "+;
" FROM "+RetSqlName("SR8")+" "+;
" WHERE (R8_DATAINI BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM > '"+DTOS(DDATABASE)+"') "+;
" AND R8_FILIAL = '"+XFILIAL("SR8")+"' "+;
" AND R8_MAT = '"+SRA->RA_MAT+"' "+;
" AND R8_TIPO = 'F' "+;
" AND D_E_L_E_T_ = '' "+;
" ORDER BY R8_DATAINI "

cQry2	:= ChangeQuery(cQry2)
//MemoWrite("PosFerias.sql",cQry2)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry2), 'FERIAS', .F., .T.)

_QtdFerias := 0

While FERIAS->(!Eof())
	_DataIniF := ""
	_DataFimF := ""
	
	
	IF stod(FERIAS->R8_DATAINI) < FirstDay(dDatabase)  // Inicio do afastamento iniciou em mes anterio
		_DataIniF := FirstDay(dDatabase)
	ELSE
		_DataIniF := stod(FERIAS->R8_DATAINI)
	ENDIF
	
	IF stod(FERIAS->R8_DATAFIM) > (dDatabase)  // fim do afastamento é no próximo período
		_DataFimF := (dDatabase)
	ELSE
		_DataFimF := stod(FERIAS->R8_DATAFIM)
	ENDIF
	
	_QtdFerias  += (_DataFimF - _DataIniF)+1
	
	FERIAS->(DBSKIP())
ENDDO
_NrDiasDesc += _QtdFerias
FERIAS->(dbclosearea())

_NrDiasTrab := (_NDiasMes - _NrDiasDesc)  //(DDATABASE - FIRSTDAY(DDATABASE)+1) - _NrDiasDesc


//=========================================================================
// TRATAMENTO PARA PERICULOSIDADE  -  RA_PERICUL
//=========================================================================
/*
IF SRA->RA_PERICUL > 0
	
	_NvalPericul := 0
	if _DiasPericu > 0
		_HrsPer := (220/30)*(_NDiasMes - _DiasPericu)
	else
		_HrsPer := 220
	endif
	_NrPerTrab := (30 - _NrDiasDesc)
	
	_NvalPericul := ((_nValSal2791/30) * (_NrPerTrab))*(30/100)
	
	FDELPD("114")
	FGERAVERBA("114",_NvalPericul,_HrsPer,,,,,,,,.T.)
	
ENDIF
*/
// ----  FIM Tratamento para PERICULOSIDADE


//=========================================================================
// TRATAMENTO PARA HORA EXTRA 50%
//=========================================================================

IF 	Fbuscapd("103","H") <> 0
	
	_Qtd50 := Fbuscapd("103","H")
	
	_ValHr50 := ((_nValSal2791/220) * 1.5 )* _Qtd50
	
	FDELPD("103")
	FGERAVERBA("103",_ValHr50,_Qtd50,,,"H","I",,,,.T.)
	
	//			FDELPD("409")
	//		FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
	
ENDIF
// ----  FIM Tratamento para HORA EXTRA 50%


//=========================================================================
// TRATAMENTO PARA HORA EXTRA 100%
//=========================================================================

IF 	Fbuscapd("123","H") <> 0
	
	_Qtd100 := Fbuscapd("123","H")
	
	_ValHr100 := ((_nValSal2791/220) * 2.0 )* _Qtd100
	
	FDELPD("123")
	FGERAVERBA("123",_ValHr100,_Qtd100,,,"H","I",,,,.T.)
	
ENDIF

// ----  FIM Tratamento para HORA EXTRA 100%


//=========================================================================
// TRATAMENTO PARA ADICIONAL NOTURNO VERBAS 302 E 109
//=========================================================================

// VERBA 302	
//IF 	Fbuscapd("302","H") <> 0
	
//	_QtdAd302 := Fbuscapd("302","H")
	
//	_ValAd302 := ((_nValSal2791/220) * (25/100))* _QtdAd302
	
//	//FDELPD("302")
//	FGERAVERBA("302",_ValAd302,_QtdAd302,,,"H","I",,,,.T.)
//ENDIF


// VERBA 109
IF 	Fbuscapd("109","H") <> 0
	
	_QtdAd109 := Fbuscapd("109","H")
	
	_ValAd109 := ((_nValSal2791/220) * (20/100))* _QtdAd109
	
	FDELPD("109")
	FGERAVERBA("109",_ValAd109,_QtdAd109,,,"H","I",,,,.T.)
ENDIF

// ----  FIM Tratamento para ADICIONAL NOTURNO


//=========================================================================
// TRATAMENTO PARA VERBAS DE DEVOLUÇÕES 255 - 253 - 254
//=========================================================================

	_Produc := Fbuscapd("119")

	if _Produc < _NValSal2791
	 _Produc := _NValSal2791
	endif
	_ValDia := _Produc/30 	
	_ValHr := _Produc/220 


// VERBA 253
IF 	Fbuscapd("253","H") <> 0

	_Ref253 := Fbuscapd("253","H")
	
	_ValVb253 := (_Ref253 * _ValDia)
	
	FDELPD("253")
	FGERAVERBA("253",_ValVb253,_Ref253,,,"H","I",,,,.T.)
ENDIF

// VERBA 255
IF 	Fbuscapd("255","H") <> 0

	_Ref255 := Fbuscapd("255","H")
	
	_ValVb255 := (_Ref255 * _ValDia)
	
	FDELPD("255")
	FGERAVERBA("255",_ValVb255,_Ref255,,,"H","I",,,,.T.)
ENDIF

// VERBA 254
IF 	Fbuscapd("254","H") <> 0

	_Ref254 := Fbuscapd("254","H")
	
	_ValVb254 := (_Ref254 * _ValHr)
	
	FDELPD("254")
	FGERAVERBA("254",_ValVb254,_Ref254,,,"H","I",,,,.T.)
ENDIF

// FIM DEVOLUÇÕES


_NrDiasTrab := 0
_NrDiasDesc := 0


//------------------------------------------------------------------------------------------------------------------------

Return(.t.)
