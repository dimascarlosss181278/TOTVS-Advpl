#INCLUDE "RWMAKE.CH"
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥AJURESC   ∫Autor  ≥Henrique Tofanelli  ∫ Data ≥  09/12/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Prog. de Ajuste de Valores de Verbas de Rescisao Rurais    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

//TODOS OS CASOS DE RESCISAO PARA RURAIS

USER FUNCTION AJURESC()


_NVS2791 := GETMV("MV_SAL2791")
_VlAvosRural := _NVS2791/12
_nValProd := Fbuscapd("309")
_DtDemissao := M->RG_DATADEM
_DtAdmissao := SRA->RA_ADMISSA 

//local _NVS2791 := GETMV("MV_SAL2791")

if (Fbuscapd("127")>0 .and. Fbuscapd("225")>0)
	FDELPD("127")	
endif              
     


SALMES := _NVS2791
salario := _NVS2791
saldia := _NVS2791/30
salhora := _NVS2791/220                

// Restaurando a referencia do evento 310
_nVal310 := fBuscaPD("310")
fDelPD("310")
fGeraVerba("310",_nVal310, _nVal310/salhora)
         
IF CCOMPL <> "S"
	
	if _nValProd > _NVS2791
		_nValDiaria := _nValProd/30
	else
		_nValDiaria := GETMV("MV_DIA2791")
	endif
	
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// A condiÁ„o abaixo È utilizada para gerar a verba de complemento e apagar a verba de saldo de salario
	// para a funÁ„o rural
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//Gera Verba Demonstrativo Falta
	_mDiasf := Fbuscapd("409","H")*-1
	_mDescDSR := Fbuscapd("505","H")*-1
	_mDescSusp := Fbuscapd("459","H")*-1
	
	_mVar :=  _mDiasf*_nValDiaria
	_mVar2 := _mDescDSR*_nValDiaria
	_mVar3 := _mDescSusp*_nValDiaria
	if (_mDiasf+_mDescDSR+_mDescSusp)<> 0
		FDELPD("306")
		FGERAVERBA("306",_mVar+_mVar2+_mVar3,_mDiasf+_mDescDSR+_mDescSusp,,,,,,,,.T.)
	endif
	
	//Ajusta verba 409
	if (_mDiasf)<> 0
		FDELPD("409")
		//FGERAVERBA("409",_mVar,_mDiasf,,,"D","I",,,,.T.)
		FGERAVERBA("409",_mVar,_mDiasf,,,,,,,,.T.)
	endif
	//Ajusta verba 505
	if (_mDescDSR)<> 0
		FDELPD("505")
		//FGERAVERBA("505",_mVar2,_mDescDSR,,,"D","I",,,,.T.)
		FGERAVERBA("505",_mVar2,_mDescDSR,,,,,,,,.T.)
	endif
	//Ajusta verba 459
	if (_mDescSusp)<> 0
		FDELPD("459")
		//FGERAVERBA("459",_mVar3,_mDescSusp,,,"D","I",,,,.T.)
		FGERAVERBA("459",_mVar3,_mDescSusp,,,,,,,,.T.)
	endif
	
	//Valoriza Verbas de faltas
	/*
	if Fbuscapd("409","H")*-1 > 0 .and. Fbuscapd("409") == 0
	FDELPD("409")
	FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
	//	FGERAVERBA("409",(_mVar),_mDiasf)
	//				FGERAVERBA("409",(_mVar),_mDiasf,,,"D",,,,,.T.)
	//FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
	endif
	
	if Fbuscapd("505","H")*-1 > 0 .and. Fbuscapd("505") == 0
	FDELPD("505")
	FGERAVERBA("505",(_mVar2),_mDescDSR,,,"D","R",,,,.T.)
	//FGERAVERBA("505",(_mVar2),_mDescDSR,,,"D","I",,,,.T.)
	endif
	
	if Fbuscapd("459","H")*-1 > 0 .and. Fbuscapd("459") == 0
	FDELPD("459")
	FGERAVERBA("459",(_mVar3),_mDescSusp,,,"D","R",,,,.T.)
	//FGERAVERBA("459",(_mVar3),_mDescSusp,,,"D","I",,,,.T.)
	endif
	*/
	//Gera Verba para pagamento dos dias de afastamento
	
	// ----  Tratamento para Afastamento
	_QtdAfast := 0
	_nAfasP := 0
	_nAfasO := 0
	_nAfasQ := 0
	
	cQry1:=" SELECT R8_FILIAL, R8_MAT, R8_TIPO, R8_DATAINI, R8_DATAFIM  "+;
	" FROM "+RetSqlName("SR8")+" "+;
	" WHERE (R8_DATAINI BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM BETWEEN '"+DTOS(FirstDay(dDataBase))+"' AND '"+DTOS(DDATABASE)+"' OR R8_DATAFIM > '"+DTOS(DDATABASE)+"') "+;
	" AND R8_FILIAL = '"+XFILIAL("SR8")+"' "+;
	" AND R8_MAT = '"+SRA->RA_MAT+"' "+;
	" AND R8_TIPO <> 'F' "+;
	" AND D_E_L_E_T_ = '' "+;
	" ORDER BY R8_DATAINI "
	
	cQry1	:= ChangeQuery(cQry1)
	MemoWrite("C:\Temp\PosAfast.sql",cQry1)
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
		
		
		IF stod(AFAST->R8_DATAFIM) > (dDatabase)  // fim do afastamento È no prÛximo perÌodo
			_DataFimA := (dDatabase)
		ELSE
			_DataFimA := stod(AFAST->R8_DATAFIM)
		ENDIF
		
		_QtdAfast  += (_DataFimA - _DataIniA)+1
		
		IF AFAST->R8_TIPO == "P"
			_nAfasP += _QtdAfast
		ENDIF
		
		IF AFAST->R8_TIPO == "O"
			_nAfasO += _QtdAfast
		ENDIF
		
		IF AFAST->R8_TIPO == "Q"
			_nAfasQ += _QtdAfast
		ENDIF
		
		_QtdAfast := 0
		
		AFAST->(DBSKIP())
	ENDDO
	
	AFAST->(DBCLOSEAREA())
	
	//GERA VERBAS
	//_nAfasP := 0
	IF _nAfasP <> 0
		IF _nAfasP > 15
			_nAfasP := 15
		ENDIF
		_mVar :=  _nAfasP*_nValDiaria
		FDELPD("115")
		//FGERAVERBA("115",_mVar,_nAfasP,,,"D",,,,,.T.)
		FGERAVERBA("115",_mVar,_nAfasP,,,,,,,,.T.)
		
	ENDIF
	
	IF _nAfasO <> 0
		IF _nAfasO > 15
			_nAfasO := 15
		ENDIF
		_mVar :=  _nAfasO*_nValDiaria
		FDELPD("116")
		FGERAVERBA("116",_mVar,_nAfasO,,,"D",,,,,.T.)
		
	ENDIF
	
	IF _nAfasQ <> 0
		IF _nAfasQ > 15
			_nAfasQ := 15
		ENDIF
		_mVar :=  _nAfasQ*_nValDiaria
		FDELPD("136")
		FGERAVERBA("136",_mVar,_nAfasQ,,,"D",,,,,.T.)
		
	ENDIF
	
	// MUDA VERBA 161 (SALDO SALARIO)  PARA 307 (COMPLEMENTO)
	If Fbuscapd("161") > 0
		
		_QDias   := Fbuscapd("161","H")
		_VSld161 := Fbuscapd("161")
		
		_ValCompl := 0
		_Produtiv := Fbuscapd("309") //Fbuscapd("119")
		_Dsr	  := Fbuscapd("310") //Fbuscapd("308")
		_Falta    := Fbuscapd("306")
		
		_ValCompl := (_VSld161 - (_Produtiv + _Dsr + _Falta))
		IF _ValCompl > 0
			FDELPD("307")
			//FGERAVERBA("307",_ValCompl,,,,,,,,.T.)
			FGERAVERBA("307",_ValCompl,_QDias,,,"D","I",,,,.T.)
		ENDIF
		FDELPD("161")
		
	Endif
	
	
	//-------------------------------------------------------------------------------
	//  AJUSTE VALOR DE FERIAS PROPORCIONAIS E/OU INDENIZADAS                      //
	//-------------------------------------------------------------------------------
	
	//_QtAvosFInd := Fbuscapd("127","H")
	//_ValFerInd  := Fbuscapd("127")
	
	
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	// TRATAMENTO PARA VERBA 128 - FERIAS PROPORCIONAL
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	_QtAvosFPro := Fbuscapd("128","H")
	_ValFerPro  := Fbuscapd("128")
	
	IF _QtAvosFPro > 0
		
		
		IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM F…RIAS VENCIDAS
			_DiaIni := day(SRF->RF_DATABAS)
			_MesIni := month(SRF->RF_DATABAS) //_MesFim - _QtAvosFInd
			_AnoIni := year(SRF->RF_DATABAS) + 1
		ELSE
			_DiaIni := day(SRF->RF_DATABAS)
			_MesIni := month(SRF->RF_DATABAS) //_MesFim - _QtAvosFInd
			_AnoIni := year(SRF->RF_DATABAS)
		ENDIF
		
		if _DiaIni > 15
			_MesIni := _MesIni + 1
			If _MesIni > 12
				_MesIni := 1
				_AnoIni := _AnoIni + 1
			endif
		endif
		
		_MesFim := month(ddatabase)
		_AnoFim := year(ddatabase)
		
		
		
		//VERIFICA QUANT DE MESES RECEBIDOS POR PRODU«√O (VERBA 307 EOU 119)
		
		//_QproFp := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 2)
		_QSalFp := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
		
		IF cTipRes == "01"  // aviso indenizado, devolve o avo do aviso
			_QSalFp += 1
		ENDIF
		
		// Encontrou meses recebidos por salario
		IF _QSalFp > 0 .AND. !((Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao)))
			
			
			_AvPeric := U_BuscPeric()
			
			_AvInsal := U_BuscInsal()
			
			_RefVlAvosRed := 0
			
			//Usado para encontrar a variaÁ„o dos avos devido a falta (x=qtav*valverba/qtav*avrural)
			//_RefAv1 := SRF->RF_DFERAAT/2.5 //Encontra Qtd de avos por direito - sem desc. de faltas    //((int(_QtAvosFPro)*_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
			_RefAv1 := NDFERAVE/2.5 //Encontra Qtd de avos por direito - sem desc. de faltas    //((int(_QtAvosFPro)*_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
			
			//IF cTipRes == "01"  // aviso indenizado, devolve o avo do aviso
			//	_RefAv1 += 1
			//ENDIF
			
			if _RefAv1 <> int(_QtAvosFPro)  //Significa que tem reduÁ„o por falta
				
				//Usado para encontrar a variaÁ„o complementar dos avos, pois pode ter aviso previo
				//_RefAv2 := ((_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
				_RefRed := (_ValFerPro)/((_RefAv1)*(_VlAvosRural+_AvInsal+_AvPeric))
				
				//_RefVlAvosRed := (_VlAvosRural+_AvInsal+_AvPeric)*_RefRed
				_RefVlAvosRed := (_VlAvosRural)*_RefRed
				_AvInsal := (_AvInsal)*_RefRed
				_AvPeric := (_AvPeric)*_RefRed
				
			endif
			
			
			IF _RefVlAvosRed > 0
				
				//_vNovoFerp := _RefVlAvosRed * (_RefAv1 - _QproFp)
				_vNovoFerp := _RefVlAvosRed * _QSalFp
				
			ELSE
				_ValAvosFerp := (_ValFerPro/int(_QtAvosFPro))
				//_vNovoFerp := _ValFerPro - ((int(_QtAvosFPro)-_QSalFp) * _ValAvosFerp)
				_vNovoFerp := (_QSalFp * _VlAvosRural)
				
			ENDIF
			
			//ADICIONA OS AVOS DE PERICULOSIDADE E INSALUBRIDADE REF MESES DE PRODU«√O
			_vNovoFerp += ((_AvInsal * _RefAv1) + (_AvPeric * _RefAv1))   //((_QSalFp*_AvInsal) + (_QSalFp*_AvPeric))
			
			IF _vNovoFerp <= 0
				FDELPD("128")
			ELSE             
				FDELPD("128")
				FGERAVERBA("128",_vNovoFerp,_QtAvosFPro,,,,,,,,.T.)
			ENDIF
		ELSE
			//Verifica se a demissao È no mesmo mes da admissao
			//pois tem tratamento diferenciado
			//
			If (Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao))
				
				_VlMedFPro  := Fbuscapd("226")
				
				if _VlMedFPro > _VlAvosRural
					FDELPD("128")
					FGERAVERBA("128",(_ValFerPro -_VlAvosRural),_QtAvosFPro,,,,,,,,.T.)
				else 
					IF _ValFerPro > _VlMedFPro // ACRESCENTADA CONDICAO PARA EVITAR VALOR NEGATIVO -- THIAGO 26-11-2014 
						FDELPD("128")
						FGERAVERBA("128",(_ValFerPro -_VlMedFPro),_QtAvosFPro,,,,,,,,.T.)
					ENDIF 
				endif
			else
				//Significa que foi tudo por mÈdia, ent„o apaga a verba
				FDELPD("128")
			EndIF
		ENDIF
	ENDIF
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	// TRATAMENTO PARA VERBA 127 - FERIAS INDENIZADA
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	_QtAvosFInd := Fbuscapd("127","H")
	_ValFerInd  := Fbuscapd("127")
	
	IF _QtAvosFInd > 0
		_DiaIni := day(SRF->RF_DATABAS)
		_MesIni := month(SRF->RF_DATABAS) //_MesFim - _QtAvosFInd
		_AnoIni := year(SRF->RF_DATABAS)
		
		if _DiaIni > 15
			_MesIni := _MesIni + 1
			If _MesIni > 12
				_MesIni := 1
				_AnoIni := _AnoIni + 1
			endif
		endif
		
		
		_MesFim := _MesIni - 1
		_AnoFim := _AnoIni + 1
		
		if _MesFim == 0
			_MesFim := 12
			_AnoFim := _AnoFim - 1
		endif
		
		//_QMSALF := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 1)
		
		_QMSALF := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
		
		IF cTipRes == "01"  .AND. Fbuscapd("128") == 0 // aviso indenizado e nao existe ferias proporcional - devolve o avo do aviso
			_QMSALF += 1
		ENDIF
		
		IF _QMSALF > 0
			
			_AvPeric := U_BuscPeric()
			
			_AvInsal := U_BuscInsal()
			
			_RefVlAvosRed := 0
			
			//Usado para encontrar a variaÁ„o dos avos devido a falta (x=qtav*valverba/qtav*avrural)
			//_RefAv1 := SRF->RF_DFERVAT/2.5 //Encontra Qtd de avos por direito - sem desc. de faltas    //((int(_QtAvosFPro)*_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
			_RefAv1 := NDFERVEN/2.5 //Encontra Qtd de avos por direito - sem desc. de faltas    //((int(_QtAvosFPro)*_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
			
			
			//IF cTipRes == "01"  .AND. Fbuscapd("128") == 0 // aviso indenizado e nao existe ferias proporcional - devolve o avo do aviso
			//	_RefAv1 += 1
			//ENDIF
			
			if _RefAv1 <> int(_QtAvosFInd)  //Significa que tem reduÁ„o por falta
				
				//Usado para encontrar a variaÁ„o complementar dos avos, pois pode ter aviso previo
				//_RefAv2 := ((_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
				_RefRed := (_ValFerInd)/((_RefAv1)*(_VlAvosRural+_AvInsal+_AvPeric))
				
				//_RefVlAvosRed := (_VlAvosRural+_AvInsal+_AvPeric)*_RefRed
				_RefVlAvosRed := (_VlAvosRural)*_RefRed
				_AvInsal := (_AvInsal)*_RefRed
				_AvPeric := (_AvPeric)*_RefRed
				
			endif
			
			
			IF _RefVlAvosRed > 0
				
				_vNovoFerv := _RefVlAvosRed * (_QMSALF)
				
			ELSE
				_ValAvosFerv := (_ValFerInd/int(_QtAvosFInd))
				//_vNovoFerv := _ValFerPro - ((int(_QtAvosFInd)-_QMSALF) * _ValAvosFerv)
				_vNovoFerv := (_QMSALF * _VlAvosRural)
				
			ENDIF
			
			//ADICIONA OS AVOS DE PERICULOSIDADE E INSALUBRIDADE REF MESES DE PRODU«√O
			//_vNovoFerv += ((_QMSALF*_AvInsal) + (_QMSALF*_AvPeric))
			_vNovoFerv += ((_AvInsal * _RefAv1) + (_AvPeric * _RefAv1))   //((_QSalFp*_AvInsal) + (_QSalFp*_AvPeric))
			
			FDELPD("127")
			FGERAVERBA("127",_vNovoFerv,_QtAvosFInd,,,,,,,,.T.)
			
			//_QtAvos225 := Fbuscapd("225","H")
			//_ValFer225 := Fbuscapd("225")
			
			//AGRUPA O VALOR DA VERBA 127 COM A 225
			//FGERAVERBA("225",(_ValFer225+_vNovoFInd),_QtAvos225,,,,,,,,.T.)
			
			//APAGA A 127
			//FDELPD("127")
			
			
		ENDIF
		
		//	QMSALF->(DBCLOSEAREA())
		
	ENDIF
	
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	//  AJUSTE VALOR DE 13o INDENIZADO                                             //
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	_QtAvos13o := Fbuscapd("228","H")
	
	
	_MesFim := month(ddatabase)
	_AnoFim := year(ddatabase)
	
	//IF nMed13o > 0   //Variavel que guarda a media de 13o
	
	_MesIni := _MesFim - int(_QtAvos13o)
	_AnoIni := year(ddatabase)
	
	if _MesIni = 0
		_MesIni := 01
	elseif _MesIni < 0
		_MesIni := _MesIni + 12
		_AnoIni := _AnoIni - 1
	endif
	
	_ProdQM13 := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 2)
	
	_QM13 := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
	
	IF (_QM13 + _ProdQM13) > int(_QtAvos13o)
		_QM13 := _QM13 - ((_QM13 + _ProdQM13) - _QtAvos13o)
	ENDIF
	
	_AvPeric := U_BuscPeric()
	_AvInsal := U_BuscInsal()
	

	IF _QM13 > 0 .AND. !((Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao)))
		
		//MSGBOX("Quant. de Meses Prod 13o: " +strzero(QM13->QTDMES,4)+ " ")
		//QMSAL->QTDMES
		
		//_vBase13o := nMed13o*(int(_QtAvos13o))
		//_RefRed13 := (_QM13*_NVS2791)
		
		
		_ValNov13o := (_QM13*_VlAvosRural) + ((_AvInsal * _QtAvos13o) + (_AvPeric * _QtAvos13o))
		//(((_vBase13o - _RefRed13)/int(_QtAvos13o))/12)*(int(_QtAvos13o))
		//		_ValNov13o := (((_vBase13o - _RefRed13)/int(_QtAvos13o))/12)*(int(_QtAvos13o))
		
		//Pega valores da verba 168 e depois apaga
		_QtAvos168 := Fbuscapd("168","H")
		//_Val13o168 := Fbuscapd("168")
		
		//GERA E AGRUPA O VALOR DA VERBA 168 COM A 228
		IF (_ValNov13o) > 0
			FDELPD("168")
			FGERAVERBA("168",_ValNov13o,_QtAvos13o,,,,,,,,.T.)
		ELSE
			FDELPD("168")
		ENDIF
		
	ELSEIf (Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao))
		
		//Verifica se a demissao È no mesmo mes da admissao
		//pois tem tratamento diferenciado
		//
		
		_VlMed13i  := Fbuscapd("228")
		_Val13Ind  := Fbuscapd("168")
		_QAvos13I  := Fbuscapd("168","H")
		
		if _VlMed13i > _VlAvosRural
			FDELPD("168")
			FGERAVERBA("168",IIF(_Val13Ind > _VlAvosRural,(_Val13Ind -_VlAvosRural),0),_QAvos13I,,,,,,,,.T.)  //EVITANDO VALOR NEGATIVO PARA A VERBA
		else          
			FDELPD("168")
			FGERAVERBA("168",IIF(_Val13Ind>_VlMed13i,(_Val13Ind -_VlMed13i),0),_QAvos13I,,,,,,,,.T.) //EVITANDO VALOR NEGATIVO PARA A VERBA
		endif
		
	ELSEIF (_AvPeric + _AvInsal) > 0   //Nao tem avos por salario, mas tem que ser jogado o valor de Insal e Peric
		
		_ValNov13o := ((_AvInsal * int(_QtAvos13o)) + (_AvPeric * int(_QtAvos13o)))
		
		//Pega valores da verba 168 e depois apaga
		_QtAvos168 := Fbuscapd("168","H")
		
		//GERA E AGRUPA O VALOR DA VERBA 168 COM A 228
		IF (_ValNov13o) > 0
			FDELPD("168")
			FGERAVERBA("168",_ValNov13o,_QtAvos13o,,,,,,,,.T.)
		ELSE          
			FDELPD("168")
		ENDIF
	ELSE
		//Significa que foi tudo por mÈdia, ent„o apaga a verba
		FDELPD("168")
	EndIF
	
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	//  AJUSTE VALOR DE AVISO PREVIO INDENIZADO                                    //
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	
	_ValIndAv  := Fbuscapd("166")
	_ValMedAv  := Fbuscapd("227")
	
	IF _ValIndAv > 0
		
		_MesFim := month(ddatabase)
		_AnoFim := year(ddatabase)
		
		
		_MesIni := _MesFim + 1
		_AnoIni := year(ddatabase) - 1
		
		if _MesIni = 13
			_MesIni := 01
			_AnoIni := _AnoIni + 1
		endif
		//VERIFICA QUANT DE MESES RECEBIDOS POR SALARIO (VERBA 307 EOU 119)
		QMAV := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
		
		
		//VERIFICA QUANT DE MESES RECEBIDOS POR PRODU«√O (VERBA 307 EOU 119)
		_QPROV := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 1)
		
		//Usado para completar ultimos 12 meses
		_AdcAviso := 12 - (_QPROV + QMAV)
		
		QMAV += _AdcAviso
		
		
		_ValAvisInd := (_VlAvosRural)*QMAV
		_ValAvisInd += (_AvInsal + _AvPeric)*12
		
		nDAvis := Fbuscapd("166","H")
		
		IF _ValAvisInd > 0
			FDELPD("166")
			FGERAVERBA("166",_ValAvisInd,nDAvis,,,,,,,,.T.)
		ELSE
			FDELPD("166")
		ENDIF
		
		//Verifica se o valor do Aviso È menor que o salario base da categoria para gerar complemento
		
		_TotAvPrevio := Fbuscapd("166") + Fbuscapd("227") - ((_AvInsal + _AvPeric)*12)
		
		If _TotAvPrevio < _NVS2791
			_vCompAvi := _NVS2791 - _TotAvPrevio
			FDELPD("311")
			FGERAVERBA("311",_vCompAvi,nDAvis,,,,,,,,.T.)
		EndIf
	ENDIF
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	//  AJUSTE VALOR DE      DE ADIC. 13o AVISO INDENIZADO                    //
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	IF Fbuscapd("169") > 0 .AND. !((Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao)))
		
		_QtAv13oAv := Fbuscapd("169","H")
		
		_MesFim := month(ddatabase)
		_AnoFim := year(ddatabase)
		
		_MesIni := 01 //_MesFim + 1
		_AnoIni := year(ddatabase)
		
		if _MesIni = 13
			_MesIni := 01
			_AnoIni := _AnoIni + 1
		endif
		
		//VERIFICA QUANT DE MESES RECEBIDOS POR SALARIO (VERBA 307 EOU 119)
		QM13SAL := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
		
		//VERIFICA QUANT DE MESES RECEBIDOS POR PRODU«√O (VERBA 307 EOU 119)
		//_Q13PROV := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 1)
		
		//Usado para completar ultimos 12 meses
		_Adc13Aviso := (12 + QM13SAL) - NAVOS
		
		//QM13SAL += _Adc13Aviso
		
		_Val13Avis := (_VlAvosRural/12)*_Adc13Aviso
		_Val13Avis += (_AvInsal + _AvPeric)
		
		
		IF _Val13Avis > 0                                     
			FDELPD("169")
			FGERAVERBA("169",_Val13Avis,_QtAv13oAv,,,,,,,,.T.)
		ELSE
			FDELPD("169")
		ENDIF
		
		//Verifica se o valor do Aviso È menor que o salario base da categoria para gerar complemento
		
		_Tot13Av := Fbuscapd("169") + Fbuscapd("229") - (_AvInsal + _AvPeric)
		
		If _Tot13Av < _VlAvosRural
			_v13Comp := _VlAvosRural - _Tot13Av
			FDELPD("312")
			FGERAVERBA("312",_v13Comp,_QtAv13oAv,,,,,,,,.T.)
		EndIf
		
	ELSEIf (Month(_DtDemissao) == Month(_DtAdmissao)) .and. (year(_DtDemissao) == year(_DtAdmissao))
		
		//Verifica se a demissao È no mesmo mes da admissao
		//pois tem tratamento diferenciado
		//
		
		_VlAdMed13i  := Fbuscapd("229")
		_ValAd13Ind  := Fbuscapd("169")
		_QAvosAd13I  := Fbuscapd("169","H")
		
		if _VlAdMed13i > _VlAvosRural
			FDELPD("169")
			FGERAVERBA("169",(_ValAd13Ind -_VlAvosRural),_QAvosAd13I,,,,,,,,.T.)
		else         
			FDELPD("169")
			FGERAVERBA("169",(_ValAd13Ind -_VlAdMed13i),_QAvosAd13I,,,,,,,,.T.)
		endif
		
	ENDIF
	
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	// TRATAMENTO DE CACULO DE 1/3 DE FERIAS - RESCISAO
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	_RfTerFer := Fbuscapd("186","H")
	_ValTotFerias := Fbuscapd("226") + Fbuscapd("225") + Fbuscapd("127") + Fbuscapd("128")
	
	
	_VNovTerFer := (_ValTotFerias/3)
	
	FDELPD("186")	
	FGERAVERBA("186",_VNovTerFer,_RfTerFer ,,,,,,,,.T.)
	
	
	/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	// TRATAMENTO PARA AJUSTE DE CACULO DE SALARIO FAMILIA - RESCISAO
	
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
	
	//MSGBOX("Val nSal_fami " +str(nSal_fami,12,2)+ " ")
	//MSGBOX("Val nSalfami_B " +str(nSalfami_B,12,2)+ " ")
	
	//MSGBOX("Val nLimSF1 " +str(nLimSF1,12,2)+ " ")
	//MSGBOX("Val nval_SF1 " +str(nval_SF1,12,2)+ " ")
	//MSGBOX("Val nLimSF1 " +str(nLimSF2,12,2)+ " ")
	//MSGBOX("Val nval_SF2 " +str(nval_SF2,12,2)+ " ")
	
	//AJUSTA BASE DE SALARIO FAMILIA
	_vBaseSFami := nSalfami_B - _NVS2791
	
	if _vBaseSFami < nLimSF2  //Se for menor que o limite maximo significa que tem Sal Familia
		
		_NrMesDia := 30
		
		// ----  Tratamento para Demiss„o
		
		_NrDiasTrab := (M->RG_DATADEM - FirstDay(M->RG_DATADEM))+1
		
		if _NrDiasTrab > 30
			_NrDiasTrab := 30
		endif
		
		if Fbuscapd("129") > 0  //existe verba de sal familia
			_mQtdf    := Fbuscapd("129","H")
		else //tem que buscar qtd de dependentes
			_mQtdf    := val(SRA->RA_DEPSF)
		endif
		
		
		if _vBaseSFami <= nLimSF1
			_valSalFam := nval_SF1
		elseif _vBaseSFami > nLimSF1 .and. _vBaseSFami <= nLimSF2
			_valSalFam := nval_SF2
		endif
		
		// Ajusta valor pela proporcao
		
		if _NrDiasTrab > 0
			_valSalFam := (((_valSalFam)/_NrMesDia)*(_NrDiasTrab))
		endif
		
		if _valSalFam > 0
			FDELPD("129")
			FGERAVERBA("129",(_valSalFam*_mQtdf),_mQtdf,,,,,,,,.T.)
		else
			FDELPD("129")
		endif
	endif
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// A condiÁ„o abaixo verifica se È rescis„o complementar para rurais
	//
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//IF CCOMPL == "S"
ELSE
	
	//------------------------------------------------
	// TRATAMENTO PARA RESCIS√O COMPLEMENTAR RURAIS
	//------------------------------------------------
	
	_MesFolha := getmv("MV_FOLMES")
	_MesDemis := SUBSTR(DTOS(M->RG_DATADEM),1,6)
	
	IF !(_MesDemis == _MesFolha) // Mes Fechado
		
		execblock("AJRESCOMP")
		
	ENDIF
	
ENDIF

IF cTipRes == "02"  // aviso trabalhado, cancela verba 13∫ indenizado. Ajustar calculo acima.
	FDELPD("168")
ENDIF
      
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// VERIFICA QUANT DE MESES RECEBIDOS POR PRODU«√O (VERBA 307 EOU 119)
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
*/
User Function BuscaQtdProd(_cMat, _cAnoIni, _cMesIni, _cAnoFim, _cMesFim, _NumOpcao)

QtdMeses := 0

//VERIFICA QUANT DE MESES RECEBIDOS POR PRODU«√O (VERBA 307 EOU 119)

IF _NumOpcao == 1
	
	cQry7:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
	" FROM "+RetSqlName("SRD")+" "+;
	" WHERE RD_FILIAL = '"+XFILIAL("SRD")+"' "+;
	" AND RD_MAT = '"+_cMat+"' "+;
	" AND RD_PD IN ('119','307','306','308','309','310') "+;
	" AND RD_DATARQ BETWEEN '"+strzero(_cAnoIni,4)+strzero(_cMesIni,2)+"' AND '"+strzero(_cAnoFim,4)+strzero(_cMesFim,2)+"' "+;
	" AND D_E_L_E_T_ = '' "
	
ELSEIF _NumOpcao == 2     //Verifica ProduÁ„o no mÍs Aberto. Rescis„o feita com Mes aberto
	
	cQry7:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
	" FROM "+RetSqlName("SRD")+" "+;
	" WHERE RD_FILIAL = '"+XFILIAL("SRD")+"' "+;
	" AND RD_MAT = '"+_cMat+"' "+;
	" AND RD_PD IN ('119','307','306','308','309','310') "+;
	" AND RD_DATARQ BETWEEN '"+strzero(_cAnoIni,4)+strzero(_cMesIni,2)+"' AND '"+strzero(_cAnoFim,4)+strzero(_cMesFim,2)+"' "+;
	" AND D_E_L_E_T_ = '' "+;
	" UNION "+;
	" SELECT COUNT(DISTINCT(RC_MAT)) as QTDMES "+;
	" FROM "+RetSqlName("SRC")+" "+;
	" WHERE RC_FILIAL = '"+XFILIAL("SRC")+"' "+;
	" AND RC_MAT = '"+_cMat+"' "+;
	" AND RC_PD IN ('119','307','306','308','309','310') "+;
	" AND D_E_L_E_T_ = '' "
	
ENDIF

cQry7	:= ChangeQuery(cQry7)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry7), 'QMESPROD', .F., .T.)

IF !QMESPROD->(EOF())
	
	WHILE !QMESPROD->(EOF())
		
		QtdMeses += QMESPROD->QTDMES
		
		QMESPROD->(DBSKIP())
	ENDDO
ENDIF
QMESPROD->(DBCLOSEAREA())

Return(QtdMeses)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// VERIFICA QUANT DE MESES RECEBIDOS POR SAL¡RIO (VERBA 101)
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
*/
User Function BuscaSalQtd(_cMat, _cAnoIni, _cMesIni, _cAnoFim, _cMesFim)

QtdMeses := 0

cQry06:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
" FROM "+RetSqlName("SRD")+" "+;
" WHERE RD_FILIAL = '"+XFILIAL("SR8")+"' "+;
" AND RD_MAT = '"+_cMat+"' "+;
" AND RD_PD = '101' "+;
" AND RD_DATARQ BETWEEN '"+strzero(_cAnoIni,4)+strzero(_cMesIni,2)+"' AND '"+strzero(_cAnoFim,4)+strzero(_cMesFim,2)+"' "+;
" AND D_E_L_E_T_ = '' "

cQry06	:= ChangeQuery(cQry06)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry06), 'QMSAL', .F., .T.)

IF !QMSAL->(EOF())
	QtdMeses := QMSAL->QTDMES
ELSE
	QtdMeses := 0
ENDIF

QMSAL->(DBCLOSEAREA())

Return(QtdMeses)



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// VERIFICA AVOS DE PERICULOSIDADE
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
*/
User Function BuscPeric()

_Peric := 0

IF Fbuscapd("114") > 0 //Verba de Periculosidade. Se existir significa que faz parte do valor de fÈrias proporcionais
	//Aqui calculamos o Avo ref Periculosidade
	_PercPeric := 30
	_Peric := (_NVS2791*(_PercPeric/100))/12
	
ENDIF

Return(_Peric)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// VERIFICA AVOS DE INSALUBRIDADE
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
*/
User Function BuscInsal()

_Insal := 0

IF Fbuscapd("183") > 0  .or. Fbuscapd("182") > 0 .or. Fbuscapd("181") > 0 //Verba de Insalubridade. Se existir significa que faz parte do valor de fÈrias proporcionais
	//Aqui calculamos o Avo ref Insalubridade
	_PercInsa := 0
	IF SRA->RA_INSMIN > 0
		_PercInsa := 10
	ELSEIF SRA->RA_INSMED > 0
		_PercInsa := 20
	ELSEIF SRA->RA_INSMAX > 0
		_PercInsa := 40
	ENDIF
	
	_Insal := (VAL_SALMIN*(_PercInsa/100))/12
	
ENDIF

Return(_Insal)
