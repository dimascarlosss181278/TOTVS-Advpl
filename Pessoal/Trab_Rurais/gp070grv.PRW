#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³gp070grv  ºAutor  ³Henrique Tofanelli  º Data ³  22/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Alteracao dos Valores de Provisoes   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION GP070GRV() //TODOS OS CASOS DE RURAIS

Local _NValSal2791 := GETMV("MV_SAL2791")
local _VlAvosRural := _NValSal2791/12

//MSGBOX("Passou pelo PE GP040RES")

Local aArea		:= GetArea()
Local cFilial 	:= PARAMIXB[1]
Local cMat 		:= PARAMIXB[2]
Local nTpProv	:= PARAMIXB[3]

//Alert( "Passou pelo PE GP070GRV    Tipo:  "+ str(nTpProv) +"  |  Verba:  "+ SRT->RT_VERBA +"  |  Valor: "+ str(SRT->RT_VALOR,12,2) +" "  )

If nTpProv == 1  //Tipo Ferias Vencidas
	
	//Tratamento das
	//Verbas que contem valor da média |  1/3  | INSS |  FGTS
	If SRT->RT_VERBA == "751" .OR. SRT->RT_VERBA == "806" .OR. SRT->RT_VERBA == "752" .OR. SRT->RT_VERBA == "753"
		
		//Busca Se ocorreu recebimento por produção
		IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
			
			_MesIni := month(SRF->RF_DATABAS) //_MesFim - _QtAvosFInd
			_AnoIni := year(SRF->RF_DATABAS)
			
			_MesFim := _MesIni - 1
			_AnoFim := _AnoIni + 1
			
			if _MesFim == 0
				_MesFim := 12
				_AnoFim := _AnoFim - 1
			endif
			
			cQry3:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
			" FROM "+RetSqlName("SRD")+" "+;
			" WHERE RD_FILIAL = '"+cFilial+"' "+;
			" AND RD_MAT = '"+cMat+"' "+;
			" AND RD_PD IN ('119','307','306','308','309','310') "+;
			" AND RD_DATARQ BETWEEN '"+strzero(_AnoIni,4)+strzero(_MesIni,2)+"' AND '"+strzero(_AnoFim,4)+strzero(_MesFim,2)+"' "+;
			" AND D_E_L_E_T_ = '' "//+;
			//" GROUP BY RD_DATARQ "
			
			cQry3	:= ChangeQuery(cQry3)
			//MemoWrite("PosAfast.sql",cQry1)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry3), 'QMSFERV', .F., .T.)
			
			IF !QMSFERV->(EOF()) .AND. QMSFERV->QTDMES > 0
				
				IF SRT->RT_VERBA == "751" //PARA VERBA FERIAS
					_v1ReduzMed := (_NValSal2791/12)*QMSFERV->QTDMES
					_v1Base := SRT->RT_VALOR
					_v1NvBase := (_v1Base-_v1ReduzMed)
					_v1Dif := _v1Base - _v1NvBase
					
				ELSEIF SRT->RT_VERBA == "806" //PARA 1/3
					_v1ReduzMed := (_NValSal2791/12/3)
					_v1Base := SRT->RT_VALOR
					_v1NvBase := (_v1Base-_v1ReduzMed)
					
					
				ELSEIF SRT->RT_VERBA == "752" //INSS
					_v1ReduzMed := (((_NValSal2791/12)+(_NValSal2791/12/3))*0.027)  // inss 2,7%
					_v1Base := SRT->RT_VALOR
					_v1NvBase := (_v1Base-_v1ReduzMed)
					
					
				ELSEIF SRT->RT_VERBA == "753" //FGTS
					_v1ReduzMed := (((_NValSal2791/12)+(_NValSal2791/12/3))*0.08)  // FGTS 8%
					_v1Base := SRT->RT_VALOR
					_v1NvBase := (_v1Base-_v1ReduzMed)
				ENDIF
				
				IF RecLock( "SRT" , .F. )
					
					SRT->RT_VALOR := _v1NvBase
					
					SRT->( MsUnlock() )
					
					//Alert( "Depois da Gravacao   Tipo:  "+ str(nTpProv) +"  |  Verba:  "+ SRT->RT_VERBA +"  |  Valor: "+ str(SRT->RT_VALOR,12,2) +" "  )
				EndIF
				
				
			ENDIF
			
			QMSFERV->(DBCLOSEAREA())
		ENDIF
	ENDIF
ENDIF
//--------------------------------------------------------------------------------

If nTpProv == 2  //Tipo Ferias a Vencer (PROPORCIONAIS)
	
	//Tratamento das
	//Verbas que contem valor da média |  1/3  | INSS |  FGTS
	//If SRT->RT_VERBA == "805" .OR. SRT->RT_VERBA == "806" .OR. SRT->RT_VERBA == "752" .OR. SRT->RT_VERBA == "753"
	IF SRT->RT_VERBA == "751" .OR. SRT->RT_VERBA == "806" .OR. SRT->RT_VERBA == "752" .OR. SRT->RT_VERBA == "753"
		
		//Busca Se ocorreu recebimento por produção
		
		IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
			_MesIni := month(SRF->RF_DATABAS)  //_MesFim - _QtAvosFInd
			_AnoIni := year(SRF->RF_DATABAS) + 1
		ELSE
			_MesIni := month(SRF->RF_DATABAS) //_MesFim - _QtAvosFInd
			_AnoIni := year(SRF->RF_DATABAS)
		ENDIF
		
		IF _MesIni = 0
			_MesIni := 12
			_AnoIni := _AnoIni - 1
		Endif
		//_MesIni := month(ddatabase)
		//_AnoIni := year(ddatabase)
		
		_MesFim := month(ddatabase)
		_AnoFim := year(ddatabase)
		
		
		//Alert( "Datas:  "+ strzero(_AnoIni,4)+strzero(_MesIni,2) +"  |  Data Fim:  "+ strzero(_AnoFim,4)+strzero(_MesFim,2)+""  )
		
		cQry3:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
		" FROM "+RetSqlName("SRD")+" "+;
		" WHERE RD_FILIAL = '"+cFilial+"' "+;
		" AND RD_MAT = '"+cMat+"' "+;
		" AND RD_PD IN ('119','307','306','308','309','310') "+;
		" AND RD_DATARQ BETWEEN '"+strzero(_AnoIni,4)+strzero(_MesIni,2)+"' AND '"+strzero(_AnoFim,4)+strzero(_MesFim,2)+"' "+;
		" AND D_E_L_E_T_ = '' "//+;
		//" GROUP BY RD_DATARQ "
		
		cQry3	:= ChangeQuery(cQry3)
		//MemoWrite("PosAfast.sql",cQry1)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry3), 'QMSFERP', .F., .T.)
		
		IF !QMSFERP->(EOF()) .AND. QMSFERP->QTDMES > 0
			
			IF SRT->RT_VERBA == "751"
				IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v2ReduzMed := (_NValSal2791/12)*QMSFERP->QTDMES
				ELSE
					_v2ReduzMed := (_NValSal2791/12)
				ENDIF
				_v2Base := SRT->RT_VALOR
				_v2NvBase := (_v2Base-_v2ReduzMed)
				_v2Dif := _v2Base - _v2NvBase
				
				//			IF SRT->RT_VERBA == "805"
				//				_v2ReduzMed := (_NValSal2791/12)
				//				_v2Base := SRT->RT_VALOR
				//				_v2NvBase := (_v2Base-_v2ReduzMed)
				//				_v2Dif := _v2Base - _v2NvBase
				//
			ELSEIF SRT->RT_VERBA == "806"
				IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v2ReduzMed := ((_NValSal2791*QMSFERP->QTDMES)/12/3)
				ELSE
					_v2ReduzMed := (_NValSal2791/12/3)
				ENDIF
				_v2Base := SRT->RT_VALOR
				_v2NvBase := (_v2Base-_v2ReduzMed)
				
			ELSEIF SRT->RT_VERBA == "752" //INSS
				IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v2ReduzMed := ((((_NValSal2791*QMSFERP->QTDMES)/12)+((_NValSal2791*QMSFERP->QTDMES)/12/3))*0.027)  // inss 2,7%
				ELSE
					_v2ReduzMed := (((_NValSal2791/12)+(_NValSal2791/12/3))*0.027)  // inss 2,7%
				ENDIF
				_v2Base := SRT->RT_VALOR
				_v2NvBase := (_v2Base-_v2ReduzMed)
				
				
			ELSEIF SRT->RT_VERBA == "753" //FGTS
				IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v2ReduzMed := ((((_NValSal2791*QMSFERP->QTDMES)/12)+((_NValSal2791*QMSFERP->QTDMES)/12/3))*0.08)  // FGTS 8%
				ELSE
					_v2ReduzMed := (((_NValSal2791/12)+(_NValSal2791/12/3))*0.08)  // FGTS 8%
				ENDIF
				_v2Base := SRT->RT_VALOR
				_v2NvBase := (_v2Base-_v2ReduzMed)
			ENDIF
			
			
			IF RecLock( "SRT" , .F. )
				
				SRT->RT_VALOR := _v2NvBase
				
				SRT->( MsUnlock() )
				
			EndIF
			
			
		ENDIF
		
		QMSFERP->(DBCLOSEAREA())
	ENDIF
ENDIF


//--------------------------------------------------------------------------------

If nTpProv == 3  //13 salario
	
	If SRT->RT_VERBA == "757" .OR. SRT->RT_VERBA == "758" .OR. SRT->RT_VERBA == "759"  //Verba que contem valor da média
		
		//Busca Se ocorreu recebimento por produção
		
		_MesIni := 01
		_AnoIni := year(ddatabase)
		
		_MesFim := month(ddatabase)//12
		_AnoFim := year(ddatabase)
		
		//		_MesIni := month(ddatabase)
		//		_AnoIni := year(ddatabase)
		
		//		_MesFim := month(ddatabase)
		//		_AnoFim := year(ddatabase)
		
		cQry3:=" SELECT COUNT(DISTINCT(RD_DATARQ)) as QTDMES "+;
		" FROM "+RetSqlName("SRD")+" "+;
		" WHERE RD_FILIAL = '"+cFilial+"' "+;
		" AND RD_MAT = '"+cMat+"' "+;
		" AND RD_PD IN ('119','307','306','308','309','310') "+;
		" AND RD_DATARQ BETWEEN '"+strzero(_AnoIni,4)+strzero(_MesIni,2)+"' AND '"+strzero(_AnoFim,4)+strzero(_MesFim,2)+"' "+;
		" AND D_E_L_E_T_ = '' "//+;
		//" GROUP BY RD_DATARQ "
		
		cQry3	:= ChangeQuery(cQry3)
		//MemoWrite("PosAfast.sql",cQry1)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry3), 'QMS130', .F., .T.)
		
		IF !QMS130->(EOF()) .AND. QMS130->QTDMES > 0
			
			IF SRT->RT_VERBA == "757" //Verba 13o
				_v3ReduzMed := (_NValSal2791/12) * QMS130->QTDMES
				_v3Base := SRT->RT_VALOR
				_v3NvBase := (_v3Base-_v3ReduzMed)
				_v3Dif := _v3Base - _v3NvBase
				
				
				/*
				IF SRT->RT_VERBA == "812" //Verba 13o
				
				_v3ReduzMed := (_NValSal2791/12)
				_v3Base := SRT->RT_VALOR
				_v3NvBase := (_v3Base-_v3ReduzMed)
				_v3Dif := _v3Base - _v3NvBase
				*/
				
			ELSEIF SRT->RT_VERBA == "758" //INSS
				//IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v3ReduzMed := ((_NValSal2791*QMS130->QTDMES)/12*0.027)  // inss 2,7%
				//ELSE
				//	_v3ReduzMed := (_NValSal2791/12*0.027)  // inss 2,7%
				//ENDIF
				
				_v3Base := SRT->RT_VALOR
				_v3NvBase := (_v3Base-_v3ReduzMed)
				
				
			ELSEIF SRT->RT_VERBA == "759" //FGTS
				//IF SRF->RF_DFERVAT > 0  //SIGNIFICA QUE TEM FÉRIAS VENCIDAS
					_v3ReduzMed := ((_NValSal2791*QMS130->QTDMES)/12*0.08)  // FGTS 8%
				//ELSE
				//	_v3ReduzMed := (_NValSal2791/12*0.08)  // FGTS 8%
				//ENDIF
				
				_v3Base := SRT->RT_VALOR
				_v3NvBase := (_v3Base-_v3ReduzMed)
			ENDIF
			
			IF RecLock( "SRT" , .F. )
				
				SRT->RT_VALOR := _v3NvBase
				
				SRT->( MsUnlock() )
				
			EndIF
			
			
		ENDIF
		
		QMS130->(DBCLOSEAREA())
	ENDIF
ENDIF


RestArea( aArea )

Return



