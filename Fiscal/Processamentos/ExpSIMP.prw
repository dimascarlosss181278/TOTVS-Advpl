#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXPSIMP   บAutor  ณThiago Henrique     บ Data ณ  24/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para gerar o arquivo do ISIMP, contendo as movi-  บฑฑ
ฑฑบ          ณ menta็๕es de combustํveis (Produ็ใo, Devolu็๕es e Saํdas)  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณEXPSIMP   บAlterado por: Dimas Carlos         ณ  02/11/2021 บฑฑ
ฑฑบ  mudan็a de layout conforme resolu็ใo ANP 08/2022                     บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Agro Industrial Campo Lindo                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExpSIMP()

Private cPerg := "EXPSIMP   "

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return()
EndIf

// Inicializa a regua de processamento.
Processa({|| RunCont() },"Gerando arquivo texto para o SIMP ...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRUNCONT   บAutor  ณMicrosiga           บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunCont

Private _aMov := {} //Array com as movimenta็oes

_cQuery  := "SELECT * "
_cQuery  += " FROM "+RetSqlName("SB1")+" AS SB1 "
_cQuery  += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
_cQuery  += "   AND B1_CODSIMP <> '' "
_cQuery  += "   AND SB1.D_E_L_E_T_ <> '*' "
_cQuery  += "ORDER BY B1_CODSIMP, B1_COD"

_nRegs := 0
//Processa a Query principal (do processamento)
TCQUERY _cQuery NEW ALIAS qyPrd
COUNT TO _nRegs

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(_nRegs)

If File(MV_PAR03)
	Ferase(MV_PAR03)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
/*  CODIGOS DE OPERACAO
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipo	Fin	Cla	Especificacao						Seq.    Codigo   Status	        ณ
//ณ1	1	1	Recebimento de Devolu็๕es de Agente Regulado		4	1011004  Implementado  	ณ
//ณ1	1	1	Recebimento de Devolu็๕es de Agente Nใo Regulado	5	1011005  Implementado	ณ
//ณ1	1	1	Total de Entradas Comerciais Nacionais		      998	1011998  Implementado	ณ
//ณ1	2	1	Produ็ใo Pr๓pria					2	1021002  Implementado	ณ
//ณ1	2	1	Total de Entradas Operacionais			      998	1021998  Implementado	ณ
//ณ4	1	1	Total Geral de Entradas				      998	4011998  Implementado	ณ
//ณ1	1	2	Venda para Agente Regulado				1	1012001  Implementado	ณ
//ณ1	1	2	Venda para Agente Nใo Regulado				2	1012002  Implementado	ณ
//ณ1	1	2	Entrega Produtos em Vendas Contr.a Fut.p/Ag.Regula	12	1012012	 Implementado	ณ
//ณ1	1	2	Entrega Produtos em Vendas Contr.a Fut.p/Ag.N.Regu	13	1012013	 Implementado	ณ
//ณ1	2	2	Consumo Pr๓prio de Produto de Origem Interna		2	1022002          	ณ	
//ณ1	2	2	Perdas de Processo					4	1022004		    	ณ
//ณ1	2	2	Total de Saํdas Operacionais			      998	1022998     	        ณ
//ณ1	1	0	Vendas Para Entrega Futura a Agentes Regulados		1	1010001  Implementado	ณ
//ณ1	1	0	Vendas Para Entrega Futura a Agentes Nใo Regulados	2	1010002	 Implementado	ณ
//ณ1	1	0	Cancelamento de venda para Entrega futura		7	1010007        		ณ
//ณ3	1	0	Estoque inicial sem movimenta็ใo pr๓prio		3	3010003  Implementado	ณ
//ณ3	2	0	Estoque final sem movimenta็ใo Pr๓prio			3	3020003  Implementado	ณ
//ณ4	1	2	Total Geral de Saํdas				      998	4012998  Implementado	ณ   	
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

_nSequen    := 0
_nQtdIni  	:= 0
_nQtdFim  	:= 0
_cCodSIMP 	:= ""
_cAgeMAno := "9007454414"+StrZero(Month(MV_PAR01),2)+StrZero(Year(MV_PAR01),4) // Agente Regulado (UCL) + Mes e Ano
_MREF 		:= SUBS(DTOS(MV_PAR01),5,2)+SUBS(DTOS(MV_PAR01),1,4) // 012014
_cCIUCL		:= "1104975"     // Codigo da Instalacao Agro Industrial Campo Lindo Ltda
_cMAESPA 	:= "0790400"     // Massa Especifica Alcool Anidro
_nMAESPA    := VAL(_cMAESPA)/1000000
_cMAESPH 	:= "0810400"     // Massa Especifica Alcool Hidratado
_nMAESPH    := VAL(_cMAESPH)/1000000

_cCODOPE    := "0000000"	 // CODIGO DE OPERAวรO - A SER INICIALIZADO A CADA MUDANวA DE TIPO DE REGISTRO
_cCodInst 	:= "0000000" 
_cDataNF    := "0000000"
_cDataIni   := DTOS(MV_PAR01)
_cDataFin   := DTOS(MV_PAR02)

_nTot1012A := _nTot4012A := 0
_nTot1012H := _nTot4012H := 0
_nTot1022A := _nTot1022H := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa as NFSs (Notas Fiscais de Saida)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IncProc("Processando Notas Fiscais de Saํda")

_cQuery  := "SELECT A1_CODINST, A1_CGC, B1_CODSIMP, B1_DESC, SUM(D2_QUANT) as D2_QUANT,D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, "
_cQuery  += " D2_TIPO, '00000' as A1_ATIVANP, A1_EST, A1_COD_MUN, D2_QTDEDEV, F2_CHVNFE, F4_ESTOQUE, F4_DUPLIC, "
_cQuery  += " CASE WHEN LEN('00'+SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),1,1)+  SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),3,4)) = 7 "
_cQuery  += " THEN CAST('00'+(SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),1,1)+  SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),3,4)) AS VARCHAR) "
_cQuery  += " WHEN LEN('00'+SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),1,1)+  SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),3,4)) = 5 "
_cQuery  += " THEN CAST('00'+(SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),1,1)+  SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),3,4)) AS VARCHAR)+'00' "
_cQuery  += " ELSE CAST('00'+(SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),1,1)+  SUBSTRING(CAST(D2_PRCVEN AS VARCHAR),3,4)) AS VARCHAR)+'000' END as D2_PRCVEN" 
_cQuery  += " FROM "+RetSqlName("SD2")+" AS SD2 "
_cQuery  += "     INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
_cQuery  += "     INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D2_FILIAL = B1_FILIAL AND D2_COD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "
_cQuery  += " 	  INNER JOIN "+RetSqlName("SF2")+" AS SF2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SF2.D_E_L_E_T_ <> '*' "
_cQuery  += "     INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ <> '*' "
//_cQuery  += " 	  INNER JOIN "+RetSqlName("CC2")+" AS CC2 ON CC2_FILIAL = A1_FILIAL AND CC2_CODMUN = A1_COD_MUN AND CC2.D_E_L_E_T_ <> '*' "
_cQuery  += " WHERE B1_CODSIMP <> '' "
_cQuery  += "   AND D2_TIPO = 'N' "
_cQuery  += "   AND F4_ESTOQUE = 'S' "
_cQuery  += "   AND D2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
_cQuery  += "   AND SD2.D_E_L_E_T_ <> '*' "
_cQuery  += " GROUP BY A1_CODINST, A1_CGC, B1_CODSIMP, B1_DESC, D2_PRCVEN,D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, "
_cQuery  += " D2_TIPO, A1_EST, A1_COD_MUN, D2_QTDEDEV, F2_CHVNFE, F4_ESTOQUE, F4_DUPLIC 
_cQuery  += " ORDER BY B1_CODSIMP, D2_EMISSAO, D2_SERIE, D2_DOC, D2_CLIENTE "                          

MemoWrit("c:\temp\NFS.sql",_cQuery)

_nRegs := 0
//Processa a Query principal (do processamento)
TCQUERY _cQuery NEW ALIAS QUERY
COUNT TO _nRegs

ProcRegua(_nRegs)          

_cCodSimp := ""
_cChvSimp := ""
_nQtdItem := 0
_cDoc     := "0000000"
_cSerie   := "00"
_cChvNFe  := REPL('0',44)
_cPrecv   := ""
DbSelectArea("QUERY")
DbGoTop()
While !EOF()	
	_cCodSimp := Query->B1_CODSIMP
	_cCodOper := ""
	_cCodInst := "0000000"
	_cCodMun  := "0000000"
	_cCodAtiv := "00000"
	_cDataNF  := SubsTr(Query->D2_EMISSAO,7,2)+SubsTr(Query->D2_EMISSAO,5,2)+SubsTr(Query->D2_EMISSAO,1,4)
	_cCodTer  := "00000000000000"
	_cDoc     := STRZERO(VAL(Query->D2_DOC),7)	
	_cSerie   := Query->D2_SERIE	          
	_cChvNFe  := REPL('0',44-LEN(TRIM(QUERY->F2_CHVNFE)))+TRIM(QUERY->F2_CHVNFE)
    _cPrecv   := STRZERO(VAL(Query->D2_PRCVEN),7)
	
//	_cCodMun  := StrZero(Val(AllTrim(CC2->CC2_MUNANP)),7)
	If VAL(_cChvNFe)>0 .and. Val(Query->A1_CODINST)>0 	// AGENTE REGULADO
		_cCodInst := TRIM(Query->A1_CODINST)
		_cCodOper := IIf (Query->F4_ESTOQUE="S", IIf (Query->F4_DUPLIC = "S", "1012001", "1012012"), "1010001") //  VENDA NORMAL/ REMESSA / VENDA PARA ENTREGA FUTURA		
		_cDoc     := STRZERO(0,7)	
		_cSerie   := STRZERO(0,2)		          	
		
	Else  							// AGENTE NรO REGULADO
		_cCodOper := IIf (Query->F4_ESTOQUE="S", IIf (Query->F4_DUPLIC = "S", "1012002", "1012013"), "1010002") //  VENDA NORMAL/ REMESSA / VENDA PARA ENTREGA FUTURA				
		_cCodAtiv := If(!Empty(Query->A1_ATIVANP),StrZero(Val(AllTrim(Query->A1_ATIVANP)),5),"00000")
		_cCodTer  := StrZero(Val(AllTrim(Query->A1_CGC)),14)		
		_cCodInst := Repl("0",7)
//		_cChvNFe  := REPL('0',44)
	EndIf                                                   
	
	IF _cCodSimp="810102001" .Or. _cCodSimp="810102004"// ANIDRO
		_nTot1012A += IIF(LEFT(_cCodOper,4) == "1012",Query->D2_QUANT,0)
		_nTot4012A += IIF(LEFT(_cCodOper,4) == "1012",Query->D2_QUANT,0)
		_nTot1022A += IIF(LEFT(_cCodOper,4) == "1022",Query->D2_QUANT,0)
	ELSE
		_nTot1012H += IIF(LEFT(_cCodOper,4) == "1012",Query->D2_QUANT,0)
		_nTot4012H += IIF(LEFT(_cCodOper,4) == "1012",Query->D2_QUANT,0)
		_nTot1022H += IIF(LEFT(_cCodOper,4) == "1022",Query->D2_QUANT,0)
	ENDIF
	_cChvSimp := QUERY->(B1_CODSIMP+D2_SERIE+D2_DOC+D2_CLIENTE)
	_nQtdItem += Query->D2_QUANT
	
	DbSelectArea("QUERY")
	DbSkip()
	
	//_cCodMun:="MUNICIP"
	If _nQtdItem > 0
		AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
		StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"1"+StrZero(0,21)+; //8-18
		_cCodMun+StrZero(0,29)+_cDoc+StrZero(Val(_cSerie),2)+_cDataNF+'0'+'103'+'096'+'12'+'0009931000'+'000000000'+_cPrecv+'00'+_cChvNFe) //25-28
//		_cCodMun+StrZero(0,29)+_cDoc+StrZero(Val(_cSerie),2)+_cDataNF+'0'+'103'+'096'+'12'+'0009931000'+'000000000'+IIF(_cCodSimp="810102001",_cMAESPA,_cMAESPH)+'00'+_cChvNFe) //25-28
		_nQtdItem := 0
		_nSequen++
	EndIf

	If Eof() .or. _cCodSimp # Query->B1_CODSIMP
		//Gera os totais
		AAdd(_aMov,_cAgeMAno+"1012998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+;
			       StrZero(IF(_cCodSimp="810102004",_nTot1012A,_nTot1012H),15)+StrZero(Int(IF(_cCodSimp="810102004",_nTot1012A,_nTot1012H))*IIF(_cCodSimp="810102004",_nMAESPA,_nMAESPH),15)+"9"+;  // SEM MODAL (TOTALIZADOR)           
			       StrZero(0,102)+IIF(_cCodSimp="810102004",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))
		_nSequen++
		
		_nTot1012A := 0
		_nTot1012H := 0

	EndIf
EndDo
DbSelectArea("Query")
DbCloseArea("QUERY")
//////-----------------------------------------------------------------------------------------/////
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento em Planta de BioCombustivel ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa as Evaporacoes                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa as Saํdas para consumo interno                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa das Transferencia entre Produtos               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IncProc("Processando Saํdas para consumo interno")

_nQtdItem := 0

_cQuery  := "SELECT B1_CODSIMP, B1_DESC, B1_COD, D3_QUANT, D3_EMISSAO, D3_CF, D3_TM "
_cQuery  += " FROM "+RetSqlName("SD3")+" AS SD3 "
_cQuery  += "   JOIN "+RetSqlName("SB1")+" AS SB1 ON B1_FILIAL = D3_FILIAL AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ <> '*' "
_cQuery  += " WHERE B1_CODSIMP <> ' ' "
_cQuery  += "		AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cQuery  += "		AND SD3.D_E_L_E_T_ = ''	"
_cQuery  += "		AND D3_ESTORNO = '' "
_cQuery  += "		AND ((D3_TM IN ('900', '903','700') AND D3_CF = 'RE0') OR (D3_TM='999' AND D3_CF='RE4' ) OR (D3_TM IN ('499')  AND D3_CF = 'DE4' AND B1_COD != '0054010002')) "
_cQuery  += "  ORDER BY D3_CF, D3_TM, B1_CODSIMP, D3_EMISSAO "

_nRegs := 0
//Processa a Query principal (do processamento)
TCQUERY _cQuery NEW ALIAS QUERY
COUNT TO _nRegs
MemoWrit("c:\temp\consum.sql",_cQuery)

ProcRegua(_nRegs)

_cCodSimp := _cChvSimp := ""
_cChvNFe  := Replicate("0",44)
_cCodOper := ""	
_cCodMun  := "0000000"
_cCodAtiv := "00000"
_cCodTer  := "00000000000000"	
_cDoc     := "0000000" 
_cDataNF  := "00000000" 
_cSerie   := "00"
_nTot2021M := 0
_nTot4012M := 0
_nTot1061A := 0
_nTot1061A := 0
_nTot2998SA := 0
_nTot1998EA := 0	


DbSelectArea("QUERY")
DbGoTop()

While !EOF()	
	If (QUERY->D3_TM = "999" .And. QUERY->D3_CF = "RE4" .And. QUERY->B1_CODSIMP ="810101001")
		_cCodOper := "1022002"
	ElseIf (QUERY->D3_TM = "900" .And. QUERY->D3_CF = "RE0")
		_cCodOper := "1022004"		// Consumo interno
	ElseIf (QUERY->D3_TM = "700" .And. QUERY->D3_CF = "RE0" .And. QUERY->B1_CODSIMP = "140201001")
		_cCodOper := "1022021"		// Biocombustivel
	ElseIf (QUERY->D3_TM = "999" .And. QUERY->D3_CF = "RE4" .And. QUERY->B1_CODSIMP = "810102001")
		_cCodOper := "1062001"		// Anidro sem corante
		//MsgInfo(_cCodOper,"Saida")
	ElseIf (QUERY->D3_TM = "499" .And. QUERY->D3_CF = "DE4" .And. QUERY->B1_CODSIMP = "810102004")
		_cCodOper := "1061001"		// Anidro Com corante
		//MsgInfo(_cCodOper,"Entrada")
	EndIf
	
	_cCodSimp := Query->B1_CODSIMP	
	_nTot1022A += IF(_cCodSimp="810102001",Query->D3_QUANT,0)
	_nTot1022H += IF(_cCodSimp="810101001",Query->D3_QUANT,0)
	_nTot4012A += IF(_cCodSimp="810102001",Query->D3_QUANT,0)
	_nTot4012H += IF(_cCodSimp="810101001",Query->D3_QUANT,0)
	_nTot2021M += IF(_cCodSimp="140201001",Query->D3_QUANT,0)
	_nTot4012M += IF(_cCodSimp="140201001",Query->D3_QUANT,0)
	_nTot2998SA += IF(_cCodSimp="810102001",Query->D3_QUANT,0)
	_nTot1998EA += IF(_cCodSimp="810102004",Query->D3_QUANT,0)
	_nTot1061A += IF(_cCodSimp="810102004",Query->D3_QUANT,0)
	_nQtdItem := Query->D3_QUANT
	_cDataNF  := STRZERO(VAL(SUBS(Query->D3_EMISSAO,7,2)),2)+STRZERO(VAL(SUBS(Query->D3_EMISSAO,5,2)),2)+STRZERO(VAL(SUBS(Query->D3_EMISSAO,1,4)),4)
	
	DbSkip()	
	If (_cCodSimp = "810101001" .Or. _cCodSimp = "810102001" .Or. _cCodSimp = "810102004")
		If _nQtdItem > 0 .And. _cCodSimp = "810101001"
			AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
			StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
			_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
			StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
			StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		ElseIf _nQtdItem > 0 .And. _cCodSimp = "810102001"
			AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
				_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
				StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+"810102004"+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		ElseIf _nQtdItem > 0 .And. _cCodSimp = "810102004"
			AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
				_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
				StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+"810102001"+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		EndIf
	Else 
		If _nQtdItem > 0
			AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
			StrZero(Int(_nQtdItem *1000),15)+StrZero(Int(_nQtdItem*1000),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
			_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
			StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
			StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		EndIf
	EndIf
	
EndDo
                               
DbSelectArea("Query")
DbCloseArea("QUERY")

_cCodSimp := "810101001"
AAdd(_aMov,_cAgeMAno+"1022998"+_cCIUCL+StrZero(0,7)+"810101001"+; //1-7
			StrZero(IF(_cCodSimp="810102001",_nTot1022A,_nTot1022H),15) +StrZero(Int(IF(_cCodSimp="810102001",_nTot1022A,_nTot1022H))*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH),15)+"9"+;  					
			StrZero(0,102)+IIF(_cCodSimp="810102001",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))									                                                                                        			
_nSequen++  
  
_cCodSimp := "810102001"
AAdd(_aMov,_cAgeMAno+"1022998"+_cCIUCL+StrZero(0,7)+"810102001"+; //1-7
			StrZero(IF(_cCodSimp="810102001",_nTot1022A,_nTot1022H),15) +StrZero(Int(IF(_cCodSimp="810102001",_nTot1022A,_nTot1022H))*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH),15)+"9"+;  					
			StrZero(0,102)+IIF(_cCodSimp="810102001",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))									                                                                                        			
_nSequen++     

                                                                                                                                                                                                  

AAdd(_aMov,_cAgeMAno+"1022998"+_cCIUCL+StrZero(0,7)+"140201001"+; //1-7
			StrZero(_nTot2021M * 1000,15) +StrZero(Int(_nTot2021M)*1000,15)+"9"+;  					
			StrZero(0,102)+IIF(_cCodSimp="810102001",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))									                                                                                        			
_nSequen++

//Atualiza็ใo
_cCodSimp := "810102004"
AAdd(_aMov,_cAgeMAno+"1062998"+_cCIUCL+StrZero(0,7)+"810102001"+; //1-7
			StrZero(IF(_cCodSimp="810102004",_nTot2998SA,_nTot1022H),15) +StrZero(Int(IF(_cCodSimp="810102004",_nTot2998SA,_nTot1022H))*IIF(_cCodSimp="810102004",_nMAESPA,_nMAESPH),15)+"9"+;  					
			StrZero(0,102)+IIF(_cCodSimp="810102004",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))									                                                                                        			
_nSequen++  

_cCodSimp := "810102001"
AAdd(_aMov,_cAgeMAno+"1061998"+_cCIUCL+StrZero(0,7)+"810102004"+; //1-7
			StrZero(IF(_cCodSimp="810102001",_nTot1998EA,_nTot1022H),15) +StrZero(Int(IF(_cCodSimp="810102001",_nTot1998EA,_nTot1022H))*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH),15)+"9"+;  					
			StrZero(0,102)+IIF(_cCodSimp="810102001",_cMAESPA,_cMAESPH)+"00"+REPL("0",44))									                                                                                        			
_nSequen++  

//Atualiza็ใo

AAdd(_aMov, _cAgeMAno+"4012998"+_cCIUCL+StrZero(0,7)+"810101001"+StrZero(_nTot4012H,15)+StrZero(Int(_nTot4012H)*_nMAESPH,15)+"9"+StrZero(0,102)+_cMAESPH+"00"+REPL("0",44))							
_nSequen++                                                                          

//Saida Anidro sem corante
AAdd(_aMov, _cAgeMAno+"4012998"+_cCIUCL+StrZero(0,7)+"810102001"+StrZero(_nTot2998SA,15)+StrZero(Int(_nTot2998SA)*_nMAESPA,15)+"9"+StrZero(0,102)+_cMAESPA+"00"+REPL("0",44))							
_nSequen++  

AAdd(_aMov, _cAgeMAno+"4011998"+_cCIUCL+StrZero(0,7)+"810102004"+StrZero(_nTot2998SA,15)+StrZero(Int(_nTot2998SA)*_nMAESPA,15)+"9"+StrZero(0,102)+_cMAESPA+"00"+REPL("0",44))							
_nSequen++         


AAdd(_aMov, _cAgeMAno+"4012998"+_cCIUCL+StrZero(0,7)+"810102004"+StrZero(_nTot2998SA,15)+StrZero(Int(_nTot2998SA)*_nMAESPA,15)+"9"+StrZero(0,102)+_cMAESPA+"00"+REPL("0",44))							
_nSequen++          


AAdd(_aMov, _cAgeMAno+"4012998"+_cCIUCL+StrZero(0,7)+"140201001"+StrZero(_nTot4012M * 1000,15)+StrZero(Int(_nTot4012M)*1000,15)+"9"+StrZero(0,102)+_cMAESPA+"00"+REPL("0",44))							
_nSequen++  
            
            
            
                                                                                                                                                                                                                                                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa as Notas Fiscais de Entrada (Somente Devolu็ใo) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncProc("Processando Notas Fiscais de Entrada ")

                   //'00000' as 
_cQuery  := "SELECT A1_CODINST, A1_CGC, CC2_MUNANP, '00000' as A1_ATIVANP, B1_CODSIMP, B1_DESC, D1_QUANT, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_FORNECE, D1_LOJA, "
_cQuery  += " A1_EST, A1_COD_MUN, D1_QTDEDEV, F1_CHVNFE "
_cQuery  += " FROM "+RetSqlName("SD1")+" AS SD1 "
_cQuery  += " 	INNER JOIN "+RetSqlName("SF1")+" AS SF1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND SF1.D_E_L_E_T_ <> '*' "
_cQuery  += " 	INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON B1_FILIAL = D1_FILIAL AND B1_COD = D1_COD AND SB1.D_E_L_E_T_ <> '*' "
_cQuery  += " 	INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON F4_FILIAL = D1_FILIAL AND F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ <> '*' "
_cQuery  += " 	INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND SA1.D_E_L_E_T_ <> '*' "
_cQuery  += " 	INNER JOIN "+RetSqlName("CC2")+" AS CC2 ON CC2_FILIAL = A1_FILIAL AND CC2_CODMUN = A1_COD_MUN AND CC2.D_E_L_E_T_ <> '*' AND A1_EST = CC2_EST"
_cQuery  += " WHERE D1_TIPO = 'D' "  
_cQuery  += "   AND B1_CODSIMP <> '' "
_cQuery  += "   AND F4_ESTOQUE = 'S' "
_cQuery  += "   AND D1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
_cQuery  += "   AND SD1.D_E_L_E_T_ <> '*' "
_cQuery  += "ORDER BY B1_CODSIMP, D1_DTDIGIT, D1_SERIE, D1_DOC, D1_FORNECE, D1_LOJA, D1_COD "

_nRegs := 0
//Processa a Query principal (do processamento)
MemoWrit("c:\temp\entrada.sql",_cQuery)
TCQUERY _cQuery NEW ALIAS QUERY
COUNT TO _nRegs

ProcRegua(_nRegs)	

_nTot4011A := _nTot1011A := 0
_nTot4011H := _nTot1011H := 0

_cCodSimp := ""
_cChvSimp := ""
_nQtdItem := 0
_cDoc     := "0000000"
_cSerie   := "00"
_cChvNFe  := Replicate("0",44)
DbSelectArea("QUERY")
DbGoTop()
While !EOF()	
	_cCodSimp := Query->B1_CODSIMP	
	_cCodOper := ""	
	_cCodAtiv := "00000"
	_cCodTer  := "00000000000000"
	_cDoc     := Query->D1_DOC
	_cSerie   := Query->D1_SERIE
	_cDataNF  := SubsTr(Query->D1_DTDIGIT,7,2)+SubsTr(Query->D1_DTDIGIT,5,2)+SubsTr(Query->D1_DTDIGIT,1,4)
	_cChvNFe  := Replicate("0",44)	
	If Val(Query->A1_CODINST) > 0  	
		_cCodInst := left (Query->A1_CODINST, 7) 
		_cCodOper := "1011004"		// Recebimento de Devolu็๕es de Agente Regulado
	Else 							
		_cCodInst := "0000000" 
		_cCodOper := "1011005"		// Recebimento de Devolu็๕es de Agente Nใo Regulado
	EndIf
  	_cCodMun  := StrZero(Val(AllTrim(Query->CC2_MUNANP)),7)
  // 	_cCodMun  := StrZero(Val(AllTrim(Query->A1_COD_MUN)),7)
   	_cCodAtiv := If(!Empty(Query->A1_ATIVANP),StrZero(Val(AllTrim(Query->A1_ATIVANP)),5),"00000")
	_cCodTer  := StrZero(Val(AllTrim(Query->A1_CGC)),14)
	_cChvNFe  := Query->F1_CHVNFE	
	
	_nTot1011A += IF(_cCodSimp="810102001",Query->D1_QUANT,0)
	_nTot1011H += IF(_cCodSimp="810101001",Query->D1_QUANT,0)
	_cChvSimp := QUERY->(B1_CODSIMP+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA)
	_nQtdItem += Query->D1_QUANT
	
	DbSkip()
	
	//Como existem produtos com codigo diferentes (B1_COD), mas com o mesmo codigo SIMP. Sao tratados aqui
	//estes casos, pois deve existir apenas um registro por NF+SERIE, para estes casos
	While !Eof() .and. _cChvSimp == QUERY->(B1_CODSIMP+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA)
		_nTot1011A += IF(_cCodSimp="810102001",Query->D1_QUANT,0)
		_nTot1011H += IF(_cCodSimp="810101001",Query->D1_QUANT,0)
		_nQtdItem += Query->D1_QUANT
		DbSkip()
	EndDo    

	If _nQtdItem > 0
		AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
		StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"1"+StrZero(0,7)+_cCodTer+; //8-12
		_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
		StrZero(0,2)+_cDataNF+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
		StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
		_nSequen++
		_nQtdItem := 0	
	EndIf                     
	
	If Eof() .or. _cCodSimp # Query->B1_CODSIMP
		//Gera os totais
		AAdd(_aMov,_cAgeMAno+"1011998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+; //1-7
		StrZero(Int(IF(_cCodSimp="810102001",_nTot1011A,_nTot1011H)),15)+StrZero(Int(IF(_cCodSimp="810102001",_nTot1011A,_nTot1011H)*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"9"+StrZero(0,7)+StrZero(0,14)+; //8-12
		StrZero(0,7)+StrZero(0,5)+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
		StrZero(0,2)+StrZero(0,8)+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
		StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+Replicate("0",44)) //25-28
		_nSequen++	
	EndIf
EndDo                 

DbSelectArea("Query")
DbCloseArea("QUERY")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa as Entradas por Produ็ใo (Movimentacao Interna)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IncProc("Processando Movimentos de Produ็ใo")

_nTot1021A := _nTot1021H := 0                                          
_nQtdItem := 0

_cQuery  := "SELECT B1_CODSIMP, B1_DESC, B1_COD, D3_QUANT, D3_EMISSAO, D3_TM, D3_CF "
_cQuery  += " FROM "+RetSqlName("SD3")+" AS SD3 "
_cQuery  += "   JOIN "+RetSqlName("SB1")+" AS SB1 ON B1_FILIAL = D3_FILIAL AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = '' "
_cQuery  += "   JOIN "+RetSqlName("SF5")+" AS SF5 ON D3_FILIAL = F5_FILIAL AND F5_CODIGO = D3_TM AND SF5.D_E_L_E_T_ = '' "
_cQuery  += " WHERE (B1_CODSIMP <> ' ' "
_cQuery  += "		AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cQuery  += "		AND SD3.D_E_L_E_T_ = ''	"
_cQuery  += "		AND D3_ESTORNO = '' "
_cQuery  += "		AND F5_TIPO='P') OR (D3_COD = '0055000001' AND D3_TM = '001' AND D3_CF = 'DE0' AND D3_ESTORNO = '' AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
_cQuery  += "  ORDER BY B1_CODSIMP, D3_EMISSAO "

_nRegs := 0
//Processa a Query principal (do processamento)
TCQUERY _cQuery NEW ALIAS QUERY
COUNT TO _nRegs
MemoWrit("c:\temp\entradaprod.sql",_cQuery)

ProcRegua(_nRegs)

_cCodSimp := _cChvSimp := ""
_cChvNFe  := Replicate("0",44)
_cCodOper := ""	
_cCodMun  := "0000000"
_cCodAtiv := "00000"
_cCodTer  := "00000000000000"	
_cCodOper := "1021002"		// Produ็ใo Pr๓pria
_cDoc     := "0000000" 
_cDataNF  := "00000000" 
_cSerie   := "00"
_nTot2021M	:= 0
_nTot4012M	:= 0
DbSelectArea("QUERY")
DbGoTop()

While !EOF()	
	_cCodSimp := Query->B1_CODSIMP	
	_nTot1021A += IF(_cCodSimp="810102001",Query->D3_QUANT,0)
	_nTot1021H += IF(_cCodSimp="810101001",Query->D3_QUANT,0)
	_nTot2021M += IF(_cCodSimp="140201001",Query->D3_QUANT,0)
	_nTot4012M += IF(_cCodSimp="140201001",Query->D3_QUANT,0)
	_nQtdItem := Query->D3_QUANT
	_cDataNF  := STRZERO(VAL(SUBS(Query->D3_EMISSAO,7,2)),2)+STRZERO(VAL(SUBS(Query->D3_EMISSAO,5,2)),2)+STRZERO(VAL(SUBS(Query->D3_EMISSAO,1,4)),4)
	
	DbSkip()	

	If _nQtdItem > 0
		If (_cCodSimp = "810101001" .Or. _cCodSimp = "810102001")
			AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
			StrZero(Int(_nQtdItem),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="810102001",_nMAESPA,_nMAESPH)),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
			_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
			StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
			StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		Else
		AAdd(_aMov,_cAgeMAno+_cCodOper+_cCIUCL+_cCodInst+StrZero(Val(_cCodSimp),9)+; //1-7
			StrZero(Int(_nQtdItem * 1000),15)+StrZero(Int(_nQtdItem*IIF(_cCodSimp="140201001",1000,1000)),15)+"9"+"0"+StrZero(0,7)+_cCodTer+; //8-12
			_cCodMun+_cCodAtiv+StrZero(0,4)+StrZero(0,10)+StrZero(0,9)+StrZero(Val(_cDoc),7)+; //13-18
			StrZero(Val(_cSerie),2)+_cDataNF+StrZero(0,4)+StrZero(0,3)+StrZero(0,2)+; //19-24
			StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+_cChvNFe) //25-28		
			_nSequen++
		EndIf
	EndIf
	
	If Eof() .or. _cCodSimp # Query->B1_CODSIMP
		//Gera os totais
		If (_cCodSimp = "810101001" .Or. _cCodSimp = "810102001")
			AAdd(_aMov,_cAgeMAno+"1021998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(Int(IF(_cCodSimp="810102001",_nTot1021A,_nTot1021H)),15)+StrZero(IF(_cCodSimp="810102001",_nTot1021A*_nMAESPA,_nTot1021H*_nMAESPH),15)+"9"+StrZero(0,7)+StrZero(0,14)+; //8-12		
				StrZero(0,7)+StrZero(0,5)+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
				StrZero(0,2)+StrZero(0,8)+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+Replicate("0",44)) //25-28
				_nSequen++	
		Else 
			AAdd(_aMov,_cAgeMAno+"1021998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(_nTot2021M * 1000,15) +StrZero(Int(_nTot2021M)*1000,15)+"9"+StrZero(0,7)+StrZero(0,14)+; //8-12		
				StrZero(0,7)+StrZero(0,5)+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
				StrZero(0,2)+StrZero(0,8)+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+Replicate("0",44)) //25-28
				_nSequen++	
		EndIf	
		
		IF _cCodSimp="810102001"
			_nTot4011A := _nTot1011A+_nTot1021A  // Acumula Total Geral de Entradas ANIDRO
		ELSE
			_nTot4011H := _nTot1011H+_nTot1021H  // Acumula Total Geral de Entradas HIDRATADO
		ENDIF
		If (_cCodSimp = "810101001" .Or. _cCodSimp = "810102001")
			AAdd(_aMov,_cAgeMAno+"4011998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(Int(IF(_cCodSimp="810102001",_nTot4011A,_nTot4011H)),15)+StrZero(IF(_cCodSimp="810102001",_nTot4011A*_nMAESPA,_nTot4011H*_nMAESPH),15)+"9"+StrZero(0,7)+StrZero(0,14)+; //8-12
				StrZero(0,7)+StrZero(0,5)+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
				StrZero(0,2)+StrZero(0,8)+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+Replicate("0",44)) //25-28
				_nSequen++	
		Else
			AAdd(_aMov,_cAgeMAno+"4011998"+_cCIUCL+StrZero(0,7)+StrZero(Val(_cCodSimp),9)+; //1-7
				StrZero(_nTot4012M * 1000,15) +StrZero(Int(_nTot4012M)*1000,15)+"9"+StrZero(0,7)+StrZero(0,14)+; //8-12
				StrZero(0,7)+StrZero(0,5)+StrZero(0,4)+StrZero(0,10)+StrZero(0,10)+StrZero(0,7)+; //13-18
				StrZero(0,2)+StrZero(0,8)+StrZero(0,1)+StrZero(0,3)+StrZero(0,3)+StrZero(0,2)+; //19-24
				StrZero(0,10)+StrZero(0,9)+StrZero(0,7)+StrZero(0,2)+Replicate("0",44)) //25-28
				_nSequen++
		EndIf
		_nTot1021A := _nTot1021H := 0
	EndIf
EndDo

DbSelectArea("Query")
DbCloseArea("QUERY")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estoque Inicial                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	_cCODOPE = "3010003" // Estoque inicial sem movimenta็ใo pr๓prio
	
	_nQtdIni := CalcEst("0054010001"+SPAC(5),"TY",MV_PAR01)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015	
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810102004"+StrZero(_nQtdIni,15)+StrZero(_nQtdIni*_nMAESPA,15)+;
					"9"+REPL("0",66)+SUBS(_cDataIni,7,2)+SUBS(_cDataIni,5,2)+SUBS(_cDataIni,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)

 	_nQtdIni := CalcEst("0054010003"+SPAC(5),"TY",MV_PAR01)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015	
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810102001"+StrZero(_nQtdIni,15)+StrZero(_nQtdIni*_nMAESPA,15)+;
					"9"+REPL("0",66)+SUBS(_cDataIni,7,2)+SUBS(_cDataIni,5,2)+SUBS(_cDataIni,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)

 	_nQtdIni := CalcEst("0054010002"+SPAC(5),"TY",MV_PAR01)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015	
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810101001"+StrZero(_nQtdIni,15)+StrZero(_nQtdIni*_nMAESPH,15)+;
					"9"+REPL("0",66)+SUBS(_cDataIni,7,2)+SUBS(_cDataIni,5,2)+SUBS(_cDataIni,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)
///-------------------------------------------------
	_nQtdIni := CalcEst("0055000001"+SPAC(5),"01",MV_PAR01)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015	
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000140201001"+StrZero(_nQtdIni * 1000,15)+StrZero(_nQtdIni*_nMAESPA,15)+;
					"9"+REPL("0",66)+SUBS(_cDataIni,7,2)+SUBS(_cDataIni,5,2)+SUBS(_cDataIni,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)


///-------------------------------------------------

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estoque Final                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cCODOPE = "3020003" // Estoque final sem movimenta็ใo Pr๓prio
	
	_nQtdFim := CalcEst("0054010001"+SPAC(5),"TY",MV_PAR02+1)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810102004"+StrZero(_nQtdFim,15)+StrZero(_nQtdFim*_nMAESPA,15)+;
					"9"+REPL("0",66)+SUBS(_cDataFin,7,2)+SUBS(_cDataFin,5,2)+SUBS(_cDataFin,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)

 	_nQtdFim := CalcEst("0054010003"+SPAC(5),"TY",MV_PAR02+1)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810102001"+StrZero(_nQtdFim,15)+StrZero(_nQtdFim*_nMAESPA,15)+;
					"9"+REPL("0",66)+SUBS(_cDataFin,7,2)+SUBS(_cDataFin,5,2)+SUBS(_cDataFin,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)

 	_nQtdFim := CalcEst("0054010002"+SPAC(5),"TY",MV_PAR02+1)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000810101001"+StrZero(_nQtdFim,15)+StrZero(_nQtdFim*_nMAESPH,15)+;
					"9"+REPL("0",66)+SUBS(_cDataFin,7,2)+SUBS(_cDataFin,5,2)+SUBS(_cDataFin,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)
		
//---------------------------------------------------------------
 	_nQtdFim := CalcEst("0055000001"+SPAC(5),"01",MV_PAR02+1)[1] // 01/12/2014 - Toda a produ็ใo de แlcool ้ armazenada no TY a partir da safra 2014/2015
	_cString := _cAgeMAno+_cCODOPE+_cCIUCL+"0000000140201001"+StrZero(_nQtdFim * 1000,15)+StrZero(_nQtdFim*1000,15)+;
					"9"+REPL("0",66)+SUBS(_cDataFin,7,2)+SUBS(_cDataFin,5,2)+SUBS(_cDataFin,1,4)+"0"+"103"+"096"+"12"+"0009931000"+REPL("0",12)+"100000"+REPL("0",44)
		AAdd(_aMov,_cString)
//---------------------------------------------------------------
DbSelectArea("qyPrd")
DbCloseArea("qyPrd")

//REGISTRO DE CONTROLE
U_EditTxt(MV_PAR03,"0000000000"+_cAgeMAno+StrZero(Len(_aMov)+1,7))
_nI   := 1
_nTam := Len(_aMov)
While _nI <= _nTam
	U_EditTxt(MV_PAR03,StrZero(_nI,10)+_aMov[_nI]) //25-28
	_nI++
EndDo

MsgBox("Arquivo "+MV_PAR03+" gerado!")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  29/08/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg
_sAlias := Alias()
aRegs   := {}
i       := ""
j       := ""

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//   Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Data De             ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Ate            ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Arquivo Gerado      ","","","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		If RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		EndIf
	Endif
Next

DbSelectArea(_sAlias)

Return
