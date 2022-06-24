#INCLUDE "rwmake.ch"

User function AJUCOMP()

FDELPD("101")  //Apaga Verba de Salario Base do Rural

_mDiasf := Fbuscapd("409","H")*-1
_mDescDSR := Fbuscapd("505","H")*-1
_mDescSusp := Fbuscapd("459","H")*-1
_nValDiaria := GETMV("MV_DIA2791")
_NValSal2791 := GETMV("MV_SAL2791")

If Empty(Fbuscapd("119")) .or. Fbuscapd("119") <= _NValSal2791
	
	_mVar :=  _mDiasf*_nValDiaria
	_mVar2 := _mDescDSR*_nValDiaria
	_mVar3 := _mDescSusp*_nValDiaria
	if (_mDiasf+_mDescDSR+_mDescSusp)<> 0
		FDELPD("306")
		FGERAVERBA("306",_mVar+_mVar2+_mVar3,_mDiasf+_mDescDSR+_mDescSusp,,,,,,,,.T.)
	endif
	if _mDescDSR <> 0
		FDELPD("505")
		FGERAVERBA("505",(_mVar2),_mDescDSR,,,"D","I",,,,.T.)
	Endif
	if _mDescSusp <> 0
		FDELPD("459")
		FGERAVERBA("459",(_mVar3),_mDescSusp,,,"D","I",,,,.T.)
	Endif
	If _mDiasf <> 0
		FDELPD("409")
		FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
	Endif
	If Fbuscapd("115","H") <> 0
		_mDias_115 := Fbuscapd("115","H")
		_mVar_115 :=  _mDias_115*_nValDiaria
		FDELPD("115")
		FGERAVERBA("115",_mVar_115,_mDias_115,,,,,,,,.T.)
	End
	If Fbuscapd("116","H") <> 0
		_mDias_116 := Fbuscapd("116","H")
		_mVar_116 :=  _mDias_116*_nValDiaria
		FDELPD("116")
		FGERAVERBA("116",_mVar_116,_mDias_116,,,,,,,,.T.)
	End
	If Fbuscapd("136","H") <> 0
		_mDias_136 := Fbuscapd("136","H")
		_mVar_136 :=  _mDias_136*_nValDiaria
		FDELPD("136")
		FGERAVERBA("136",_mVar_136,_mDias_136,,,,,,,,.T.)
	End
	
	//-------------------------------------------
	
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
	
	//	_DiasPericu := _NrDiasDesc  //usado para calcular hrs de periculosidade
	
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
	
	if month(dDatabase)=02 .and. _QtdAfast>=27
		_QtdAfast := 31
	endif
		
	
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
	
	_Produtiv := Fbuscapd("119")
	_Dsr	  := Fbuscapd("308")
	_Falta    := Fbuscapd("306")
	_nSuspens := Fbuscapd("459") + Fbuscapd("409") + Fbuscapd("505")
	_ValAfast := Fbuscapd("115") + Fbuscapd("116") + Fbuscapd("136")
	_Dif      := 0
	_nDifComp := 0
	
	//DEFINIÇÃO DO VALOR DE COMPLEMENTO
	
	_mVar_Compl := (_NrDiasTrab*_nValDiaria) - (_Falta + _Dsr + _Produtiv)
	IF _mVar_Compl > _nValSal2791 .AND. _NrDiasTrab >= _NDiasMes
		_mVar_Compl := _nValSal2791
		//	Else
		//	  _mVarSal := _mVar_Compl
	ENDIF
	
	//===============================
	
	if (_mVar_Compl + (_Produtiv + _Dsr + _Falta + _ValAfast)) > _nValSal2791
		_nDifComp := (_mVar_Compl + (_Produtiv + _Dsr + _Falta + _ValAfast)) - _nValSal2791
	endif
	
	//	if (_mVar_Compl + (_Produtiv + _Dsr + _ValAfast)) > _nValSal2791
	//		_nDifComp := (_mVar_Compl + (_Produtiv + _Dsr + _ValAfast)) - _nValSal2791
	//	endif
	
	
	//	_mVar_Compl :=	_mVar_Compl - _nDifComp //- (_nSuspens*-1) //(Fbuscapd("119")+Fbuscapd("115")+Fbuscapd("116")+Fbuscapd("136")+Fbuscapd("306")+Fbuscapd("308"))
	
	//===============================
	
	_mVar_Compl := (_mVar_Compl - _nDifComp) //(_mVar_Compl - (_Produtiv + _Dsr + _Falta + _ValAfast)) - _nDifComp
	
	//    _Dif  := (_mVar_Compl + _ValAfast)-(_nValSal2791)
	
	//    If _Dif > 0
	//     _mVar_Compl := _mVar_Compl - _Dif
	//	End If
	
	FDELPD("307")
	FGERAVERBA("307",_mVar_Compl,,,,,,,,,.T.)
	
	//_NrDiasTrab := 0
	//_NrDiasDesc := 0
	
	
	_NrDiasTrab := 0
	_NrDiasDesc := 0
	
	
	//------------------------------------------------------------------------------------------------------------------------
End

//Nesta condição o valor da produção é maior que o salario base, portanto as verbas de faltas serão calculadas pelo valor da produção


//----------------------------------------------------------
// VERBA DE PRODUÇÃO MAIOR QUE SAL BASE
//----------------------------------------------------------

If Fbuscapd("119") > _NValSal2791
	
	
	_Produc := Fbuscapd("119")
	_ValDiaR := _Produc/30
	_ValHrR := _Produc/220
	
	
	If (Fbuscapd("115","H")<=15 .or. Fbuscapd("116","H")<=15 .or. Fbuscapd("136","H")<=15)
		If Fbuscapd("115","H") <= 15
			_mDias_115 := Fbuscapd("115","H")
			_mVar_115 :=  _mDias_115*_ValDiaR
			FDELPD("115")
			FGERAVERBA("115",_mVar_115,_mDias_115,,,,,,,,.T.)
		End
		If Fbuscapd("116","H") <= 15
			_mDias_116 := Fbuscapd("116","H")
			_mVar_116 :=  _mDias_116*_ValDiaR
			FDELPD("116")
			FGERAVERBA("116",_mVar_116,_mDias_116,,,,,,,,.T.)
		End
		If Fbuscapd("136","H") <= 15
			_mDias_136 := Fbuscapd("136","H")
			_mVar_136 :=  _mDias_136*_ValDiaR
			FDELPD("136")
			FGERAVERBA("136",_mVar_136,_mDias_136,,,,,,,,.T.)
		End
	End
	If Fbuscapd("409","H") <> 0 .or. Fbuscapd("505") <> 0 .or. Fbuscapd("459") <> 0
		_mVar :=  _mDiasf*_ValDiaR
		_mVar2 := _mDescDSR*_ValDiaR
		_mVar3 := _mDescSusp*_ValDiaR
		FDELPD("409")
		FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
		FDELPD("459")
		FGERAVERBA("459",(_mVar3),_mDescSusp,,,"D","I",,,,.T.)
		FDELPD("505")
		FGERAVERBA("505",(_mVar2),_mDescDSR,,,"D","I",,,,.T.)
		FDELPD("306")
		FGERAVERBA("306",_mVar+_mVar2+_mVar3,_mDiasf+_mDescDSR+_mDescSusp,,,,,,,,.T.)
		If Fbuscapd("115","H") <> 0
			_mDias_115 := Fbuscapd("115","H")
			_mVar_115 :=  _mDias_115*_ValDiaR
			FDELPD("115")
			FGERAVERBA("115",_mVar_115,_mDias_115,,,,,,,,.T.)
		End
		If Fbuscapd("116","H") <> 0
			_mDias_116 := Fbuscapd("116","H")
			_mVar_116 :=  _mDias_116*_ValDiaR
			FDELPD("116")
			FGERAVERBA("116",_mVar_116,_mDias_116,,,,,,,,.T.)
		End
		If Fbuscapd("136","H") <> 0
			_mDias_136 := Fbuscapd("136","H")
			_mVar_136 :=  _mDias_136*_ValDiaR
			FDELPD("136")
			FGERAVERBA("136",_mVar_136,_mDias_136,,,,,,,,.T.)
		End
		
	End
	
	//-----------------------------------------------
	
	If _mDiasf <> 0
		FDELPD("306")
		FGERAVERBA("306",(Fbuscapd("409","V")*-1)+(Fbuscapd("505","V")*-1)+(Fbuscapd("459","V")*-1),_mDiasf+_mDescDSR+_mDescSusp,,,,,,,,.T.)
	End
End

//----------------------------------------------------------
// VERBA DE PRODUÇÃO ZERADA - CONDIÇÃO FEITA POR ROSANGELA
//----------------------------------------------------------
If Fbuscapd("119") = 0
	//If Fbuscapd("409","H")=0 .and. Fbuscapd("115","H")=0 .and. Fbuscapd("116","H")=0 .and. Fbuscapd("136","H")=0  // verificar questao de afastamento
	//	FDELPD("307")
	//	FGERAVERBA("307",525,,,,,,,,,.T.)
	//End
	If (Fbuscapd("115","H")<=15 .or. Fbuscapd("116","H")<=15 .or. Fbuscapd("136","H")<=15)
		If Fbuscapd("115","H") <= 15
			_mDias_115 := Fbuscapd("115","H")
			_mVar_115 :=  _mDias_115*_nValDiaria
			FDELPD("115")
			FGERAVERBA("115",_mVar_115,_mDias_115,,,,,,,,.T.)
		End
		If Fbuscapd("116","H") <= 15
			_mDias_116 := Fbuscapd("116","H")
			_mVar_116 :=  _mDias_116*_nValDiaria
			FDELPD("116")
			FGERAVERBA("116",_mVar_116,_mDias_116,,,,,,,,.T.)
		End
		If Fbuscapd("136","H") <= 15
			_mDias_136 := Fbuscapd("136","H")
			_mVar_136 :=  _mDias_136*_nValDiaria
			FDELPD("136")
			FGERAVERBA("136",_mVar_136,_mDias_136,,,,,,,,.T.)
		End
		//	   If nDiasafas < 30
		//	      _mVar_Compl := 525-(Fbuscapd("115")+Fbuscapd("116")+Fbuscapd("136"))
		//          FDELPD("307")
		//          FGERAVERBA("307",_mVar_Compl,,,,,,,,,.T.)
		//       End
	End
	If Fbuscapd("409","H") <> 0 .or. Fbuscapd("505") <> 0 .or. Fbuscapd("459") <> 0
		_mVar :=  _mDiasf*_nValDiaria
		_mVar2 := _mDescDSR*_nValDiaria
		_mVar3 := _mDescSusp*_nValDiaria
		FDELPD("409")
		FGERAVERBA("409",(_mVar),_mDiasf,,,"D","I",,,,.T.)
		FDELPD("459")
		FGERAVERBA("459",(_mVar3),_mDescSusp,,,"D","I",,,,.T.)
		FDELPD("505")
		FGERAVERBA("505",(_mVar2),_mDescDSR,,,"D","I",,,,.T.)
		FDELPD("306")
		FGERAVERBA("306",_mVar+_mVar2+_mVar3,_mDiasf+_mDescDSR+_mDescSusp,,,,,,,,.T.)
		If Fbuscapd("115","H") <> 0
			_mDias_115 := Fbuscapd("115","H")
			_mVar_115 :=  _mDias_115*_nValDiaria
			FDELPD("115")
			FGERAVERBA("115",_mVar_115,_mDias_115,,,,,,,,.T.)
		End
		If Fbuscapd("116","H") <> 0
			_mDias_116 := Fbuscapd("116","H")
			_mVar_116 :=  _mDias_116*_nValDiaria
			FDELPD("116")
			FGERAVERBA("116",_mVar_116,_mDias_116,,,,,,,,.T.)
		End
		If Fbuscapd("136","H") <> 0
			_mDias_136 := Fbuscapd("136","H")
			_mVar_136 :=  _mDias_136*_nValDiaria
			FDELPD("136")
			FGERAVERBA("136",_mVar_136,_mDias_136,,,,,,,,.T.)
		End
		
		//-----------------------------------
		//	FDELPD("307")
		//	_mVar_Compl := 525-(Fbuscapd("115")+Fbuscapd("116")+Fbuscapd("136")+Fbuscapd("306"))
		//	FGERAVERBA("307",_mVar_Compl,,,,,,,,,.T.)
	End
	
	//	If Diastrab < 30          // rever lógica - por exemplo "Fevereiro" - Julho (está pegando 29 dias para funcionários normais)
	//	   FDELPD("119")
	//	   FGERAVERBA("119",(diastrab*_nValDiaria),diastrab,,,,,,,,.T.)
	//	End

End
Return(.t.)
