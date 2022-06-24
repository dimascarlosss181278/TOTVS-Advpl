#INCLUDE "rwmake.ch"

User function AJUFGTS()

/*
If Fbuscapd("116","H") <> 0
_ValFGTS := Fbuscapd("710")
_mDias := Fbuscapd("116","H")
_mProd :=  Fbuscapd("119")
_AbtFgts := _mDias * (_mProd/30)
FDELPD("710")
FGERAVERBA("710",(_ValFGTS-_AbtFgts),,,,"I",,,,,.T.)
End
*/


If Fbuscapd("116","H") <> 0
	_mDias := Fbuscapd("116","H")
	_Val116 := Fbuscapd("116")
else
	_mDias := 0
	_Val116 := 0
Endif

_NDiasMes := (dDatabase - FirstDay(dDataBase)) + 1
If _NDiasMes < 30
	_NDiasMes = 30
EndIf

_nComplBase := 0
_ValFGTS := Fbuscapd("710")
_mProd :=  Fbuscapd("119")


//=========================================================================
// BUSCA COMPLEMENTO DE BASE DE FGTS PARA AFASTAMENTO POR ACIDENTE TRABALHO
//=========================================================================

// ----  Tratamento para Afastamento tipo "O" (gera verba 116)

cQry1:=" SELECT R8_FILIAL, R8_MAT, R8_TIPO, R8_DATAINI, R8_DATAFIM  "+;
" FROM "+RetSqlName("SR8")+" "+;
" WHERE (R8_DATAINI BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM > '"+DTOS(DDATABASE)+"') "+;
" AND R8_FILIAL = '"+XFILIAL("SR8")+"' "+;
" AND R8_MAT = '"+SRA->RA_MAT+"' "+;
" AND R8_TIPO = 'O' "+;
" AND D_E_L_E_T_ = '' "+;
" ORDER BY R8_DATAINI "

cQry1	:= ChangeQuery(cQry1)
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
	
	_QtdAfast  += ((_DataFimA - _DataIniA)+1)  // 30 - ( _NDiasMes - ((_DataFimA - _DataIniA)+1) )
	
	AFAST->(DBSKIP())
ENDDO

if _QtdAfast > 30
	_QtdAfast := 30
endif

AFAST->(DBCLOSEAREA())

IF _QtdAfast > 0
	_AbtFgts := _QtdAfast * (_mProd/30)
	_nComplBase := ((_QtdAfast - _mDias)*getmv("MV_DIA2791"))
ELSE
	_AbtFgts := _mDias * (_mProd/30)
ENDIF


//=========================================================================
// GERA VERBA FGTS COM O RESULTADO
//=========================================================================

FDELPD("710")
FGERAVERBA("710",((_ValFGTS+_Val116+_nComplBase)-_AbtFgts),,,,,,,,,.T.)

//=========================================================================
// GERA VERBA FGTS DEPOSITADO COM O RESULTADO
//=========================================================================

FDELPD("711")
FGERAVERBA("711",(Fbuscapd("710")*(8/100)),,,,,,,,,.T.)


//=========================================================================
// CORRIGE VERBA SAL. FAMILIA
//=========================================================================
_valSalFam := 0
_NrDescDias := 0
_NrMesDia := 30

//MsgBox("conteudo do campo 129:  "+ str(Fbuscapd("129"),12,2) +" ","Escolha")

//verifica proporcionalidade de acordo com admissao e demissao
// ----  Tratamento para Admissão

If SRA->RA_ADMISSA >= FirstDay(dDataBase) .AND. SRA->RA_ADMISSA <= DDATABASE
	_NrDescDias += (SRA->RA_ADMISSA - FirstDay(dDataBase))//-1
EndIf

// ----  Tratamento para Demissão

If SRA->RA_DEMISSA >= FirstDay(dDataBase) .AND. SRA->RA_ADMISSA <= DDATABASE
	_NrDescDias += (dDataBase - SRA->RA_DEMISSA)
EndIf

//-------------------------------------------------------------

if Fbuscapd("129") > 0
	_vBaseSal := Fbuscapd("706")
	_mQtdf    := Fbuscapd("129","H")
	//MsgBox("conteudo do campo h 129:  "+ str(_mQtdf) +" ","Escolha")
/*
	if _vBaseSal <= 573.58
		_valSalFam := 29.41
	elseif _vBaseSal > 573.58 .and. _vBaseSal <= 862.11
		_valSalFam := 20.73
	endif
*/
	if _vBaseSal <= nLimSF1
		_valSalFam := nval_SF1
	elseif _vBaseSal > nLimSF1 .and. _vBaseSal <= nLimSF2
		_valSalFam := nval_SF2
	endif

	
	// Ajusta valor pela proporcao
	if _NrDescDias > 0
		_valSalFam := ((_valSalFam/_NrMesDia)*(_NDiasMes-_NrDescDias))
	endif
	if _valSalFam > 0
		FDELPD("129")
		FGERAVERBA("129",(_valSalFam*_mQtdf),_mQtdf,,,,,,,,.T.)
	else
		FDELPD("129")
	endif
endif

//=========================================================================
// GERA VERDA DEMONSTRATIVO DE SALARIO BASE
//=========================================================================

//	If Fbuscapd("116","H") <> 0
FDELPD("999")
FGERAVERBA("999",getmv("MV_SAL2791"),,,,,,,,,.T.)
//	End

Return(.t.)
