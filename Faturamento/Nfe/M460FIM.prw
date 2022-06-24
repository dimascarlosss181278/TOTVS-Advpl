#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � FFINA001 � Autor � Desconhecido           � Data �17/11/15  ���
���          �          �       �                        �      �          ���
��������������������������������������������������������������������������Ĵ��
���Desc      � Ponto de entrada para gera��o dos titulos de impostos ICMS  ���
���          � /INSS/ no contas a pagar					                   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Sigafat - Campo Lindo                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nao existe                                                  ���
��������������������������������������������������������������������������Ĵ��
���                            ALTERACOES                                  ���
��������������������������������������������������������������������������Ĵ��
��� Data   � Programador �Solic Cliente �Alteracoes                        ���
��������������������������������������������������������������������������Ĵ��
���05/01/16� Junior      �Faturamento/TI �Rotina foi alterada para atender ���
���        �             �mudan�a de ambiente foi alterado TES/COD. Produto���
���        �             �TES 501 para 501 PRODUTO: 010002 Para 0054010002 ���
���        �             �	  502 para 502								   ���											
���        �             �	  503 para 546								   ���
���        �             �	  506 para 									   ���
���        �             �	  509 para								       ���
���        �             �	  511 para 541							       ���  
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function M460FIM()

_AREA:=GETAREA()    

private cData
private cYear

cData := DTOS(DATE())
cYear := SUBSTR(cData, 3, 2)
cForEST := RTRIM(SuperGetMv("MV_RECEST"))
cForINS := RTRIM(SuperGetMv("MV_FORINSS"))

DBSelectArea("SE2")      

// Inclu�da a rotina abaixo para gerar o Contas a Pagar do ICMS Antecipado
IF SD2->D2_TES = "502" .OR. SD2->D2_TES = "547"  //SD2->D2_TES = "506" .OR. 
	Reclock("SE2",.T.)
	REPLACE E2_FILIAL		WITH "01"
	REPLACE E2_PREFIXO		WITH SF2->F2_SERIE
	REPLACE E2_NUM			WITH SF2->F2_DOC
	REPLACE E2_TIPO			WITH "TX"
	REPLACE E2_NATUREZ		WITH "20831"//WITH "1067"
	REPLACE E2_FORNECE		WITH cForEST
	REPLACE E2_LOJA			WITH "001"
	REPLACE E2_NOMFOR		WITH Posicione("SA2",1,xFilial("SA2")+cForEST+"00","A2_NOME")
	REPLACE E2_EMISSAO		WITH SF2->F2_EMISSAO
	REPLACE E2_VENCTO		WITH SF2->F2_EMISSAO
	REPLACE E2_VENCREA		WITH SF2->F2_EMISSAO
	REPLACE E2_VALOR		WITH SF2->F2_VALICM //VALOR
	REPLACE E2_SALDO		WITH SF2->F2_VALICM-((SF2->F2_VALICM*93.8)/100) //VALOR LIQUIDO
	REPLACE E2_VLCRUZ		WITH SF2->F2_VALICM //VALOR
	REPLACE E2_DECRESC		WITH (SF2->F2_VALICM*93.8)/100 //VALOR ICMS
	REPLACE E2_HIST			WITH "VL. ICMS DANFE "+ SUBSTR(SF2->F2_DOC,4,6)
	REPLACE E2_FLUXO		WITH "S"
	REPLACE E2_ORIGEM		WITH "MATA460"
	
	MsUnlock()
ENDIF              

// Inclu�da a rotina abaixo para gerar o Contas a Pagar do ICMS Substituto - que s� ocorre para vendas fora de Sergipe
//IF (SD2->D2_TES = "502" .OR. SD2->D2_TES = "505" .OR. SD2->D2_TES = "506") .AND. Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_ESTADO")<> "SE"
//IF (SD2->D2_TES $ "502/505/506") .AND. Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_ESTADO")<> "SE" 
IF (SD2->D2_TES $ "502/547") .AND. Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_ESTADO")<> "SE"  
	Reclock("SE2",.T.)
	REPLACE E2_FILIAL		WITH "01"
	REPLACE E2_PREFIXO		WITH SF2->F2_SERIE
	REPLACE E2_NUM			WITH SF2->F2_DOC
	REPLACE E2_TIPO			WITH "TX"
	REPLACE E2_NATUREZ		WITH "20830"
	REPLACE E2_FORNECE		WITH "000005"    //"000963"
	REPLACE E2_LOJA			WITH "001"
	REPLACE E2_NOMFOR		WITH Posicione("SA2",1,xFilial("SA2")+Alltrim("000005")+"01","A2_NOME")
	REPLACE E2_EMISSAO		WITH SF2->F2_EMISSAO
	REPLACE E2_VENCTO		WITH SF2->F2_EMISSAO
	REPLACE E2_VENCREA		WITH SF2->F2_EMISSAO
	REPLACE E2_VALOR		WITH SF2->F2_ICMSRET
	REPLACE E2_SALDO		WITH SF2->F2_ICMSRET
	REPLACE E2_VLCRUZ		WITH SF2->F2_ICMSRET
	REPLACE E2_HIST			WITH "VL. ICMS SUBST. DANFE "+ SUBSTR(SF2->F2_DOC,4,6)
	REPLACE E2_FLUXO		WITH "S"
	REPLACE E2_ORIGEM		WITH "MATA460"
       
	MsUnlock()
ENDIF              

//Inclu�da a rotina abaixo para gerar o Contas a Pagar do INSS referente �s NFs de venda de �lcool
//IF (SD2->D2_TES $ "501/502/503/506/509/511") .AND. (SD2->D2_COD = ALLTRIM("010002") .OR. SD2->D2_COD = ALLTRIM("010003") .OR. SD2->D2_COD = ALLTRIM("010001"))
IF (SD2->D2_TES $ "501/502/503/546/541/542/547") .AND. (SD2->D2_COD = ALLTRIM("0054010002") .OR. SD2->D2_COD = ALLTRIM("0054010001")) //.OR. SD2->D2_COD = ALLTRIM("010003") 
	Reclock("SE2",.T.)
	REPLACE E2_FILIAL		WITH "01"
	REPLACE E2_PREFIXO		WITH SF2->F2_SERIE
	REPLACE E2_NUM			WITH SF2->F2_DOC
	REPLACE E2_TIPO			WITH "INS"
	REPLACE E2_NATUREZ		WITH "20810" //WITH "1203"
	REPLACE E2_FORNECE		WITH cForINS
	REPLACE E2_LOJA			WITH "000"
	REPLACE E2_NOMFOR		WITH Posicione("SA2",1,xFilial("SA2")+E2_FORNECE+"00","A2_NOME")
	REPLACE E2_EMISSAO		WITH POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")
	EMIS:= POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")
	cMES := SUBSTR(DTOS(EMIS),5,2)
	cANO := SUBSTR(DTOS(EMIS),1,4)
	cMES := IIF(cMES='12','01',STRZERO(VAL(cMES)+1,2))
	aANO := IIF(cMES='12',STRZERO(VAL(cANO)+1,4),cANO)
//	VENCTO := "20/"+(STRZERO(VAL(SUBSTR(DTOS(EMIS),5,2))+1,2))+"/"+cYear
    VENCTO := "20/"+cMES+"/"+cANO
	REPLACE E2_VENCTO		WITH ctod(VENCTO)
	REPLACE E2_VENCREA		WITH ctod(VENCTO)
	REPLACE E2_VALOR		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_SALDO		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_VLCRUZ		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_HIST			WITH "VL. INSS S/FAT REF DANFE "+ SUBSTR(SF2->F2_DOC,4,6)
	REPLACE E2_FLUXO		WITH "S"
	REPLACE E2_ORIGEM		WITH "MATA460"

	MsUnlock()
ENDIF  

// Inclu�da a rotina abaixo para gerar o Contas a Pagar do INSS referente �s NFs de venda de baga�o de cana
IF ((SD2->D2_TES $ "806/807") .AND. SD2->D2_COD = ALLTRIM("020006"))
	Reclock("SE2",.T.)
	REPLACE E2_FILIAL		WITH "01"
	REPLACE E2_PREFIXO		WITH SF2->F2_SERIE
	REPLACE E2_NUM			WITH SF2->F2_DOC
	REPLACE E2_TIPO			WITH "INS"
	REPLACE E2_NATUREZ		WITH "20810"
	REPLACE E2_FORNECE		WITH cForINS
	REPLACE E2_LOJA			WITH "000"
	REPLACE E2_NOMFOR		WITH Posicione("SA2",1,xFilial("SA2")+E2_FORNECE+"00","A2_NOME")
	REPLACE E2_EMISSAO		WITH POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")
	EMIS:= POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")

	cMES := SUBSTR(DTOS(EMIS),5,2)
	cANO := SUBSTR(DTOS(EMIS),1,4)
	cANO := IIF(cMES='12',STRZERO(VAL(cANO)+1,4),cANO)
	cMES := IIF(cMES='12','01',STRZERO(VAL(cMES)+1,2))
    VENCTO := "20/"+cMES+"/"+cANO
//	VENCTO := "20/"+(STRZERO(VAL(SUBSTR(DTOS(EMIS),5,2))+1,2))+"/"+cYear
	REPLACE E2_VENCTO		WITH ctod(VENCTO)
	REPLACE E2_VENCREA		WITH ctod(VENCTO)
	REPLACE E2_VALOR		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_SALDO		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_VLCRUZ		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_HIST			WITH "VL. INSS S/FAT REF DANFE "+ SUBSTR(SF2->F2_DOC,4,6)
	REPLACE E2_FLUXO		WITH "S"
	REPLACE E2_ORIGEM		WITH "MATA460"

	MsUnlock()
ENDIF              


// Inclu�da a rotina abaixo para gerar o Contas a Pagar do INSS referente �s NFs de venda de energia
// Thiago - 21-05-2014
IF (SD2->D2_TES $ "511")//"553")
	Reclock("SE2",.T.)
	REPLACE E2_FILIAL		WITH "01"
	REPLACE E2_PREFIXO		WITH SF2->F2_SERIE
	REPLACE E2_NUM			WITH SF2->F2_DOC
	REPLACE E2_TIPO			WITH "INS"
	REPLACE E2_NATUREZ		WITH "20811" //Natureza para venda de energia
	REPLACE E2_FORNECE		WITH cForINS
	REPLACE E2_LOJA			WITH "000"
	REPLACE E2_NOMFOR		WITH Posicione("SA2",1,xFilial("SA2")+E2_FORNECE+"00","A2_NOME")
	REPLACE E2_EMISSAO		WITH POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")
	EMIS:= POSICIONE("SF2",1,xFILIAL("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"F2_EMISSAO")

	cMES := SUBSTR(DTOS(EMIS),5,2)
	cANO := SUBSTR(DTOS(EMIS),1,4)
	cANO := IIF(cMES='12',STRZERO(VAL(cANO)+1,4),cANO)
	cMES := IIF(cMES='12','01',STRZERO(VAL(cMES)+1,2))
    VENCTO := "20/"+cMES+"/"+cANO
	REPLACE E2_VENCTO		WITH ctod(VENCTO)
	REPLACE E2_VENCREA		WITH ctod(VENCTO)
	REPLACE E2_VALOR		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_SALDO		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_VLCRUZ		WITH SF2->F2_VALMERC*0.0285
	REPLACE E2_HIST			WITH "VL.INSS S/ENERGIA REF DANFE "+ SUBSTR(SF2->F2_DOC,4,6)
	REPLACE E2_FLUXO		WITH "S"
	REPLACE E2_ORIGEM		WITH "MATA460"

	MsUnlock()
ENDIF              


//dbCloseArea()
RESTAREA(_AREA)
Return(.T.)
