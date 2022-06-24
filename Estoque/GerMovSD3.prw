#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerMovSD3 º Autor ³ Henrique Tofanelli º Data ³     12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± 28/08/2020 - ALTERADO POR: DIMAS SANTOS  - ROTINA FOI OTIMIZADA   
±±ºDescricao ³ Rotina para gerarcao de Movimento de Estoque - SD3         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CAMPO LINDO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GerMovSD3()

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

private lMsErroAuto := .F.

cQuery:= "SELECT * "
cQuery+= " FROM "+Retsqlname('SZ4')+" SZ4"
cQuery+= " WHERE Z4_PROCESS = 'N' "
cQuery+= " AND D_E_L_E_T_ = '' "
cQuery+= " ORDER BY Z4_EMISSAO,Z4_DOCSIFR "


TCQuery cQuery NEW ALIAS "MOV"


      WHILE MOV->(!EOF())

			cDoc := BUSCAPROX() //GETSXENUM("SD3")
 		    //	aVetor:={{"D3_TM",SZ4->Z4_TM,NIL},;
		   
			//lMsErroAuto := .F.

			aVetor:={{"D3_FILIAL",XFILIAL("SD3"),NIL},;
			{"D3_TM",MOV->Z4_TM,NIL},;
			{"D3_COD",MOV->Z4_COD,NIL},;
			{"D3_EMISSAO",STOD(MOV->Z4_EMISSAO),NIL},;
			{"D3_QUANT",MOV->Z4_QUANT,NIL},;
			{"D3_CF",MOV->Z4_CF,NIL},;
			{"D3_LOCAL",MOV->Z4_LOCAL,NIL},;
			{"D3_DOC",cDoc,NIL},;
			{"D3_CC",MOV->Z4_CC,NIL},;			
			{"D3_USUARIO",MOV->Z4_USUARIO,NIL},;			
			{"D3_DOCSIFR",MOV->Z4_DOCSIFR,NIL},;			
			{"D3_CUSTO1",MOV->Z4_CUSTO1,NIL}}
			//
			MSExecAuto({|x,y| MATA240(x,y)},aVetor,3)
			CONFIRMSX8() 

			conout("Acabou de executar a rotina automática de Movimento Estoque")


			If lMsErroAuto
			conout("erro")
			MostraErro()
			Else
			conout("Ok")
			
			
			_cArqSZ4:= retsqlname("SZ4")

 			cQuery2 := "UPDATE "  + _cArqSZ4
			cQuery2 := cQuery2 + " SET Z4_PROCESS='S'" 
			cQuery2 := cQuery2 + " WHERE Z4_COD = '"+MOV->Z4_COD+"'
			cQuery2 := cQuery2 + " AND Z4_LOCAL='"+MOV->Z4_LOCAL+"' AND Z4_DOCSIFR='"+MOV->Z4_DOCSIFR+"'"
			cQuery2 := cQuery2 + " AND Z4_TM='"+MOV->Z4_TM+"' AND Z4_EMISSAO='"+MOV->Z4_EMISSAO+"'"			
  			cQuery2 := cQuery2 + " AND D_E_L_E_T_ = ''"
  			TCSQLExec(cQuery2)                                                                       
			Endif 
			 
	  MOV->(DBSKIP())
	  END	
	MOV->(DBCLOSEAREA())
	Msgbox("Registros processados com sucesso!","Statisticas do Processo","Info")
Return           

Static Function BUSCAPROX()
			// PARA BUSCAR O PROXIMO NUMERO DO DOCUMENTO
			cQry5:=" SELECT MAX(D3_DOC) AS PROXNUM            "+;
			" FROM "+RetSqlName("SD3")+ " WHERE D_E_L_E_T_='' "+;
			" AND SUBSTRING(D3_DOC,1,3) = 'BIO' "

			cQry5	:= ChangeQuery(cQry5)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry5), 'TD3', .F., .T.)

			IF TD3->(!EOF()) .AND. !EMPTY(TD3->PROXNUM)
				 _cProx := VAL(SUBSTR(TD3->PROXNUM,4,9))+1
				 _cProx := "BIO"+strzero(_cProx,6)
			ELSE
				_cProx := "BIO000001			 
            ENDIF

			TD3->(DBCLOSEAREA())
Return(_cProx)



/*
#include "tbiconn.ch"
User Function TMata010()
Local aVetor := {}

private lMsErroAuto := .F.

prepare environment empresa "99" filial "01" modulo "fat"
aVetor:= { {"B1_DESC" ,"Teste" ,Nil},;
{"B1_TIPO" ,"PA" ,Nil},; 
{"B1_UM" ,"UN" ,Nil},; 
{"B1_LOCPAD" ,"01" ,Nil},; 
{"B1_PICM" ,0 ,Nil},; 
{"B1_IPI" ,0 ,Nil},; 
{"B1_PRV1" ,100 ,Nil},; 
{"B1_TIPOCQ" ,"M" ,Nil},; 
{"B1_CONTRAT" ,"N" ,Nil},; 
{"B1_LOCALIZ" ,"N" ,Nil},; 
{"B1_CODBAR" ,'123456' ,Nil},; 
{"B1_IRRF" ,"N" ,Nil},; 
{"B1_CONTSOC" ,"N" ,Nil},; 
{"B1_MRP" ,"N" ,Nil}} 

MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Inclusao 
CONFIRMSX8() 

conout("Acabou de executar a rotina automática do Produto")


If lMsErroAuto
conout("erro")
MostraErro()
Else
conout("Ok")
Endif 

Return

*/
