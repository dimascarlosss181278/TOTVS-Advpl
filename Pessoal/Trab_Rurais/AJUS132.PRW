#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �UNIQUI    �Autor  �HENRIQUE TOFANELLI  � Data �  20/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � CALCULO 1 PAR4CELA 13���
�������������������������������������������������������������������������͹��
���������������������������������������������������������������������������*/
USER FUNCTION AJUS132()

local _NValSal2791 := U_PESQSAL2791(SUBSTR(DTOS(ddatabase),1,6),1) //GETMV("MV_SAL2791")
local _VlAvosRural := _NValSal2791/12


_RefAv13   := Fbuscapd("138","H")


if Fbuscapd("138") <> 0  //Existe verba 13 sobre salario
	
	_MesFim := month(ddatabase)
	_AnoFim := year(ddatabase)
	
	_MesIni := 01
	_AnoIni := year(ddatabase)
	
	//_ProdQM13 := U_BuscaQtdProd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim, 2)
	
	_QM13 := U_BuscaSalQtd(SRA->RA_MAT, _AnoIni, _MesIni, _AnoFim, _MesFim)
	
	IF _QM13 > 0 
		
		_ValNov13o := (_QM13*_VlAvosRural)
		
		IF (_ValNov13o) > 0
			FGERAVERBA("138",_ValNov13o,_RefAv13,,,,,,,,.T.)
		ELSE
			FDELPD("138")
		ENDIF
		
	ELSE
		//Significa que foi tudo por m�dia, ent�o apaga a verba
		FDELPD("138")
	EndIF
	
ENDIF

Return()

