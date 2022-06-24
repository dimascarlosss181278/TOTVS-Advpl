#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณAJUFER    บAutor  ณHENRIQUE TOFANELLI  บ Data ณ  12/2010    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ AJUSTE DE VALORES DE FERIAS PARA RURAL - CAMPO LINDO
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

USER FUNCTION AJUFERI()

local _NValSal2791 := U_PESQSAL2791(SUBSTR(DTOS(ddatabase),1,6),1) //GETMV("MV_SAL2791")
local _VlAvosRural := _NValSal2791/12


/*-------------------------------------------------------------------*/
/*-Alteracao - Junior Silva - 03/12/2018 --------------*/
/*-------------------------------------------------------------------*/
Local _valorUmTerco := Fbuscapd("122")
Local _valorDiaTerco := Fbuscapd("189")
Local _umTercoTotal := (_valorUmTerco + _valorDiaTerco) / 3
Local _tercoProp := _valorDiaTerco / 3
FDelPD("121")
FGERAVERBA("121",_umTercoTotal,,,,,,,,,.T.) 
FDelPD("190")
//FGERAVERBA("190",0.01,,,,,,,,,.T.) 

/*-------------------------------------------------------------------
_mDiasfer := Fbuscapd("126","H")
_nValDiaria := GETMV("MV_DIA2791")
_NValSal2791 := GETMV("MV_SAL2791")

If Empty(Fbuscapd("126")) .or. Fbuscapd("126") <= _NValSal2791
	
	_mVar :=  _mDiasfer*_nValDiaria
		FDELPD("126")
		FGERAVERBA("126",_mVar,_mDiasfer,,,,,,,.T.)
	
Endif
-------------------------------------------------------------------*/  
   	FDelPD("188")

	_RefAvFer := Fbuscapd("126","H")	
	_QtAvosFer := Fbuscapd("126","H")/2.5
	_ValFer    := Fbuscapd("126")

	IF _QtAvosFer > 0
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
		
		if _MesFim <= 12 .and. _AnoFim <= 2010  //Faz ajuste para periodos de ferias de meses anteriores a mudan็a da folha para produ็ใo
		  
		  if !(_MesIni == _MesFim)
		  _QMSALF := (((12 -_MesIni)+1) +  _MesFim)
		  else
		  _QMSALF := (_MesFim - _MesIni)+1
		  endif

		  if _QMSALF >= 12
		  _QMSALF := 12
		  endif
		
		else
		_QMSALF := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
		endif
		//msgbox("Quantidade Avos: "+str(_QMSALF,12)+" ")
		IF _QMSALF > 0
			
			
			_RefVlAvosRed := 0
			
			//Usado para encontrar a varia็ใo dos avos devido a falta (x=qtav*valverba/qtav*avrural)

			_RefAv1 := NDFERVEN/2.5 
			
			if _RefAv1 <> int(_QtAvosFer)  //Significa que tem redu็ใo por falta
				
				//Usado para encontrar a varia็ใo complementar dos avos, pois pode ter aviso previo
				//_RefAv2 := ((_ValFerPro)/(int(_QtAvosFPro)* (_VlAvosRural+_AvInsal+_AvPeric)))
				_RefRed := (_ValFer)/((_RefAv1)*(_VlAvosRural))
				
				//_RefVlAvosRed := (_VlAvosRural+_AvInsal+_AvPeric)*_RefRed
				_RefVlAvosRed := (_VlAvosRural)*_RefRed
				
			endif
			
			
			IF _RefVlAvosRed > 0
				
				_vNovoFerv := _RefVlAvosRed * (_QMSALF)
				
			ELSE
				_ValAvosFerv := (_ValFer/int(_QtAvosFer))
				//_vNovoFerv := _ValFerPro - ((int(_QtAvosFInd)-_QMSALF) * _ValAvosFerv)
				_vNovoFerv := (_QMSALF * _VlAvosRural)
				
			ENDIF
			
			FGERAVERBA("126",_vNovoFerv,_RefAvFer,,,,,,,,.T.)
		ELSE
		 FDELPD("126")
		ENDIF
		
	ENDIF
  

Return

