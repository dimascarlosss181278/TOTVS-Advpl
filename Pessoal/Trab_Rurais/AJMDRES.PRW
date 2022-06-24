#INCLUDE "RWMAKE.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณAJMDRES   บAutor  ณHenrique Tofanelli  บ Data ณ  09/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prog. de Ajuste de Valores de Medias de Fer e 13o Rurais   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

//TODOS OS CASOS DE RESCISAO PARA RURAIS

USER FUNCTION AJMDRES()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

// TRATAMENTO PARA AJUSTE DE CACULO DE CONTRIBUICAO SINDICAL

ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

//AJUSTA BASE DE CONTRIBUICAO SINDICAL

_vBaseSindical  := 0
_vValSind 		:= 0
_DifSindic      := 0

IF Fbuscapd("407") <> 0  //existe verba de contr. sindical
	
	_RefSind := Fbuscapd("407","H")
	
	_vBaseSindical := Fbuscapd("706")
	
	if _vBaseSindical > 0
		
		_vValSind := _vBaseSindical/30
		
		_DifSindic := (Fbuscapd("407")*-1) - _vValSind
		
		FGERAVERBA("407",_vValSind,_RefSind,,,,,,,,.T.)
		
	endif
	
	//Ajustar Multa Contratual
	
	if _DifSindic > 0 .and. Fbuscapd("420") <> 0
		_vMultContr := Fbuscapd("420")
		_RefMultC   := Fbuscapd("420","H")

		if _vMultContr < 0
		 _vMultContr := _vMultContr *-1
		endif

		if _DifSindic < 0 
		  _DifSindic := _DifSindic *-1
		endif  

		_vNovaMulta := (_vMultContr + _DifSindic)

		FGERAVERBA("420",(_vNovaMulta),_RefMultC,,,,,,,,.T.)
	endif
	
endif


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

//  AJUSTE VALOR DE FGTS                                                  //

ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

/*
_nValDiaria := GETMV("MV_DIA2791")


If Fbuscapd("116","H") <> 0

_mDias := Fbuscapd("116","H")
_Val116 := Fbuscapd("116")

_NDiasMes := (dDatabase - FirstDay(dDataBase)) + 1
If _NDiasMes < 30
_NDiasMes = 30
EndIf

_nComplBase := 0
_ValFGTS := Fbuscapd("803")
_mProd :=  Fbuscapd("309")


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


IF stod(AFAST->R8_DATAFIM) > (dDatabase)  // fim do afastamento ้ no pr๓ximo perํodo
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

IF _QtdAfast > _mDias  //Afastou masi de 15 dias

_DifDias := _QtdAfast - _mDias

ELSE
_DifDias := 0
ENDIF

_AdicFGTS := _Val116+(_DifDias*_nValDiaria)

//=========================================================================
// GERA VERBA FGTS COM O RESULTADO
//=========================================================================

//	FDELPD("803")
FGERAVERBA("803",(_ValFGTS+_AdicFGTS),,,,,,,,,.T.)

Endif

//=========================================================================
// GERA VERBA FGTS DEPOSITADO COM O RESULTADO                                                                                                 
//=========================================================================

//FDELPD("711")
//FGERAVERBA("711",(Fbuscapd("710")*(8/100)),,,,,,,,,.T.)
*/

RETURN
