#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � SF1100I � Autor � Desconhecido           � Data �05/02/14  ���
���          �          �       �                        �      �          ���
��������������������������������������������������������������������������Ĵ��
���Desc      � Ponto de entrada para gera��o dos titulos de impostos ICMS  ���
���          � Antecipado no contas a pagar	sobre entrada de cana          ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Sigafat - Campo Lindo                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nao existe                                                  ���
��������������������������������������������������������������������������Ĵ��
���                            ALTERACOES                                  ���
��������������������������������������������������������������������������Ĵ��
��� Data   � Programador �Solic Cliente �Alteracoes                        ���
��������������������������������������������������������������������������Ĵ��
���07/01/16� Manoel      �Compras/TI    �Rotina foi alterada para incluir  ���
���        � Crispim -   �              �nova TES e Natureza para inclusao ���
���        �             �              �do titulo                         ��� 
���14/01/16� Jose Luiz   �Compras/TI    �Rotina foi alterada para alterar o���
���        � (Junior-TI) �              �fornecedor SEFAZ/AL para inclusao ���
���        �             �              �do titulo   
���14/10/21� Dimas Carlos�Compras/TI    �Rotina foi Otimizada              ���
���        �             �              �                                  ���
���        �             �              �                                  ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function SF1100I()  
// Ponto de Entrada na inclus�o do Documento de Entrada com formulario proprio.

_AREA:=GETAREA()    

private cData
private cYear

cData := DTOS(DATE())
cYear := SUBSTR(cData, 3, 2)

cForEST := "000006" //Fornecedor SEFAZ/AL //RTRIM(SuperGetMv("MV_RECEST"))

DBSelectArea("SE2")      

// Inclu�da a rotina abaixo para gerar o Contas a Pagar do ICMS Antecipado SOBRE ENTRADA DE CANA (Acordo entre a UCL e Fornecedor para recolher os impostos
// Solicitacao de Eduardo Vanderlei dia 05/02/2014.

IF POSICIONE("SD1",1,xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE,"D1_TES") = "020"
	IF POSICIONE ("SE2",6,xFilial("SE2")+cForEST+"001"+"ICM"+SD1->D1_DOC,"E2_NUM")=SF1->F1_DOC
		RecLock("SE2",.F.)
		dbDelete()	
		MsUnlock()
	ENDIF             

    // Usando MsExecAuto
     aVetor := {}
     aADD(aVetor,{"E2_FILIAL" ,xFilial("SE2") ,Nil})
     aADD(aVetor,{"E2_PREFIXO","ICM"          ,Nil})
     aADD(aVetor,{"E2_NUM"    ,SF1->F1_DOC    ,Nil})
     aADD(aVetor,{"E2_PARCELA","   "          ,Nil})
     aADD(aVetor,{"E2_TIPO"   ,"TX "          ,Nil})
     aADD(aVetor,{"E2_FORNECE",cForEST        ,Nil})
     aADD(aVetor,{"E2_LOJA   ","001"          ,Nil})
     aADD(aVetor,{"E2_EMISSAO",SF1->F1_EMISSAO,Nil})
     aADD(aVetor,{"E2_VENCTO" ,SF1->F1_EMISSAO,Nil})
     aADD(aVetor,{"E2_VALOR"  ,SF1->F1_VALICM ,Nil})
     aADD(aVetor,{"E2_HIST"   ,"VL ICMS S/COMPRA CANA DANFE "+ SF1->F1_DOC ,Nil})
     aADD(aVetor,{"E2_NATUREZ","20832"         ,Nil})
     lMsErroAuto := .F.
     MSExecAuto({|x,y| Fina050(x,y)},aVetor,3) //3-Inclusao //5-Exclusao
     If lMsErroAuto
          MostraErro()
     EndIf    
     
ENDIF              

RESTAREA(_AREA)

Return(.T.)
