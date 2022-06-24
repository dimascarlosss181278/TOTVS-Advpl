#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1100I ³ Autor ³ Desconhecido           ³ Data ³05/02/14  ³±±
±±³          ³          ³       ³                        ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc      ³ Ponto de entrada para geração dos titulos de impostos ICMS  ³±±
±±³          ³ Antecipado no contas a pagar	sobre entrada de cana          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sigafat - Campo Lindo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nao existe                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                            ALTERACOES                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data   ³ Programador ³Solic Cliente ³Alteracoes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³07/01/16³ Manoel      ³Compras/TI    ³Rotina foi alterada para incluir  ³±±
±±³        ³ Crispim -   ³              ³nova TES e Natureza para inclusao ³±±
±±³        ³             ³              ³do titulo                         ³±± 
±±³14/01/16³ Jose Luiz   ³Compras/TI    ³Rotina foi alterada para alterar o³±±
±±³        ³ (Junior-TI) ³              ³fornecedor SEFAZ/AL para inclusao ³±±
±±³        ³             ³              ³do titulo   
±±³14/10/21³ Dimas Carlos³Compras/TI    ³Rotina foi Otimizada              ³±±
±±³        ³             ³              ³                                  ³±±
±±³        ³             ³              ³                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I()  
// Ponto de Entrada na inclusão do Documento de Entrada com formulario proprio.

_AREA:=GETAREA()    

private cData
private cYear

cData := DTOS(DATE())
cYear := SUBSTR(cData, 3, 2)

cForEST := "000006" //Fornecedor SEFAZ/AL //RTRIM(SuperGetMv("MV_RECEST"))

DBSelectArea("SE2")      

// Incluída a rotina abaixo para gerar o Contas a Pagar do ICMS Antecipado SOBRE ENTRADA DE CANA (Acordo entre a UCL e Fornecedor para recolher os impostos
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
