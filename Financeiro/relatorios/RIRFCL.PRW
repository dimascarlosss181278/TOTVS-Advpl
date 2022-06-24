#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/07/00
#INCLUDE "topconn.ch"


#define  CRLF chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³RdMake    ³ IMPIRPF  ³ Autor ³ R.H. - Recursos Humano    ³ Data ³ 26.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da DIRF em Formulario Continuo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ DIRFPF                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programar ³ Data   ³ BOPS     ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function RIRFCL()        // incluido pelo assistente de conversao do AP5 IDE em 05/07/00
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Solicitacao ao Armazem"
Local cStartPath:= GetSrvProfString("Startpath","")
Local N 		:= 0
Local lExigi	:= .F.
Private Titulo   := "INFORME DE RENDIMENTOS"
Private aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 1, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"wnrel := "RIRFCL"
Private oPrint
oFont07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont08	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)		//negrito 
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10n:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)	//Normal s/negrito
oFont11n:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)		//Negrito
oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)	//Normal s/negrito
oFont12n:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)		//Negrito
oFont13n:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)		//Negrito
oFont13 := TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)		//Negrito
oFont14	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont15	:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
oFont15n:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)		//Negrito
oFont21 := TFont():New("Arial",21,21,,.T.,,,,.T.,.T.)
oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
cPerg := 'RIRFOR'
wnrel := 'RIRFOR'
pergunte(cPerg,.F.)                                               
aOrd := {}                                                            
wnrel:=SetPrint("SD1",wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,)

cQuery := " SELECT "+IIF(MV_PAR08==MV_PAR09, " ", "D1_FORNECE, D1_LOJA, ")+" A2_NOME NOME, A2_CGC CGC, SUM(D1_TOTAL) TOTAL, SUM(D1_VALINS) INSS "
cQuery += " FROM "+RetSQLName("SD1")+" SD1 "
cQuery += " JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA "
cQuery += " WHERE (D1_TES = 018 OR D1_TES = 019 OR D1_TES = 020) "
cQuery += " AND D1_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
cQuery += " AND A2_COD BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'"
cQuery += " AND A2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"'"
cQuery += " AND A2_CGC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'"
cQuery += " AND YEAR(D1_EMISSAO)="+MV_PAR01
cQuery += " AND SD1.D_E_L_E_T_ = '' AND SA2.D_E_L_E_T_ = '' "
cQuery += " GROUP BY "+IIF(MV_PAR08==MV_PAR09, " A2_CGC, A2_NOME "," D1_FORNECE, D1_LOJA, A2_CGC, A2_NOME ")
cQuery += " ORDER BY A2_NOME "
//MemoWrit("c:\Temp\NFS.sql",cQuery)
TCQuery cQuery NEW ALIAS "TRB" 
//oPrint:= TAVPrinter():New( "INFORME DE RENDIMENTOS" )
oPrint 	:= TMSPrinter():New("COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IRPF") //"COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IRPF"
oPrint	:SetPortrait()



	WHILE TRB->(!EOF())
		
		oPrint:StartPage() 			// Inicia uma nova pagina
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Cabecalho                                                     ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		cFileFaz 	:= cStartPath+ "RECEITA" + ".BMP" 		// Empresa+Filial
		
		nLin := 030
		nLinI:= 030
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Cabecalho³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		nLin +=20
		oPrint:Box( nLinI,0030,nLin+190,2350)  				// box Cabecalho
		oPrint:Line(nLinI,1450,nLin+190,1450)				// Linha Div.Cabecalho
		If File(cFileFaz)
			oPrint:SayBitmap(nLinI+10,050, cFileFaz,235,195) // Tem que estar abaixo do RootPath
		Endif
		nLin +=10
		oPrint:say(nLin,500 ,"MINISTÉRIO DA FAZENDA ",oFont13n)				//	ministerio da fazenda
		oPrint:Say(nLin,1500,"COMPROVANTE DE RENDIMENTOS PAGOS E DE",oFont10)				//Comprovante de rendimento
		nLin +=50
		oPrint:say(nLin+10,500 ,"SECRETARIA DA RECEITA FEDERAL",oFont11)			//secretaria de receita
		oPrint:Say(nLin,1500,"RETENÇÃO DE IMPOSTO DE RENDA NA FONTE",oFont10)              //Retencao de rendimentos
		nLin +=50
		oPrint:say(nLin+10,500 ,"IMPOSTO SOBRE A RENDA DA PESSOA FÍSICA",oFont10n)			//secretaria de receita
		oPrint:Say(nLin,1560,"( Ano Calendário ",oFont10n) 				//ano calendario
		oPrint:Say(nLin,1950,mv_par01,oFont10n)    		  	//ano  base
		oPrint:Say(nLin,2035,")",ofont10n)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³1. Fonte pagadora³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin +=100
		oPrint:Say(nLin,040,"  1. - Fonte Pagadora Pessoa Jurídica ou Pessoa Física",oFont12n) 			 	//"  1. - Fonte Pagadora Pessoa Juridica ou Pessoa Fisica"
		nLin +=60
		nLinI:=nLin -10
		oPrint:Box(nLinI ,0030,nLin + 120,2350)				//box
		oPrint:Line(nLinI,1800,nLin + 120,1800)
		
		oPrint:Say(nLIn,040,"Nome Empresarial/Nome",ofont08) 				//Nome  empresarial
		oPrint:Say(nLin,1950,"CNPJ/CPF",oFont08)				//CPF/CNPJ
		nLin+=50
		oPrint:Say(nLin,050,PADR("AGRO INDUSTRIAL CAMPO LINDO LTDA",100),oFont10)
		oPrint:Say(nLin,1960,PADR("07.454.414/0001-30",100),oFont10)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2. Pessoa fisica/benefic.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin+=100
		oPrint:Say(nLin,040, "  2. - Pessoa Física Beneficiária dos Rendimentos ", oFont12n) 							//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
		nLin +=60
		nLinI:=nLin - 10
		
		oPrint:Box(nLinI,030,nLin+220,2350)						//box
		
		oPrint:Say(nLin,040,"CPF",oFont08)								//cpf
		oPrint:Say(nLin,440,"NOME",oFont08)        						//Nome  completo
		nLin +=50
		oPrint:Say(nLin,050,TRB->CGC ,oFont10)
		oPrint:Say(nLin,450,PADR(TRB->NOME,140),oFont10)
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)									//Linha horizontal
		oPrint:Line(nLinI,430,nLin,430)									//Linha vertical
		nLin +=20
		oPrint:Say(nLin,040,"Natureza do Rendimento",oFont08)								//Natureza do rendimento
		nLin +=30
		oPrint:Say(nLin,050,PADR("9999" + "-" + "AQUISIÇÃO DE PRODUÇÃO RURAL",153),oFont10)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3. Rendimentos tributaveis/deducoes e irpf³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin +=100
		oPrint:say(nLin,0040,left("  3. - Rendimentos Tributáveis, Deduções e Imposto Retido na Fonte",50),oFont12n)										//"  3. - Rendimentos Tributaveis, Deducoes e Imposto Retido na Fonte"
		oPrint:Say(nLIn,1950,"Valores em Reais",oFont10n)
		
		nLin +=60
		nLinI:=nLin -10
		oPrint:Box(nLinI ,0030,nLin + 400,2350)													//box
		oPrint:Line(nLinI,1900,nLin + 400,1900)
		
		nLin +=10
		oPrint:Say(nLin,0040,"01.Total dos Rendimentos(Inclusive Férias)",oFont10)											//1.Total de rendimentos(+ferias)
		oPrint:Say(nLin,2000,Transform(Round(TRB->TOTAL,2),"@E 99,999,999.99"),oFont12) 	//"| 01. Total dos Rendimentos (Inclusive Ferias)"
		nLin+=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin+=30
		oPrint:say(nLin,0040,"02. Contribuição Previdenciária Oficial ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(TRB->INSS,2),"@E 99,999,999.99"), oFont12)	//"| 02. Contribuicao Previdenciaria Oficial "
		
		nLin +=50
		oPrint:Line(nLin,030, nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"03. Contribuição à Previdência Privada",oFont10)
		oPrint:say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 03. Contribuicao a Previdencia Privada"
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"04. Pensão Alimentícia (Informar Benefic. no Campo 06)   ",ofont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 04. Pensao Alimenticia (Informar Benefic. no Campo 06)   "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin+=30
		oPrint:Say(nLin,0040,"05. Imposto Retido na Fonte",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 05. Imposto Retido na Fonte"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³4. Rendimentos Isentos e nao tributaveis³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin += 100
		oPrint:Say(nLin,0040,left(" 4. - Rendimentos Isentos e Não Tributáveis",50),oFont12n)	//"  4. - Rendimentos Isentos e Nao Tributaveis"
		oPrint:Say(nLIn,1950,"Valores em Reais",oFont10n)
		
		nLin +=60
		nLinI:=nLin -10
		oPrint:Box(nLinI ,0030,nLin + 560,2350)
		oPrint:Line(nLinI,1900,nLin + 560,1900)
		
		nLin +=10
		oPrint:Say(nLin,0040,"01. Parte dos Proventos Aposentadoria,Reforma ou Pensão  ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 01. Parte dos Proventos Aposentadoria,Reforma ou Pensao  "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"02. Diárias e Ajudas de Custo  ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 02. Diarias e Ajudas de Custo  "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"03. Pensão, Prov.de Aposent.ou Reforma por Moléstia Grave",ofont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 03. Pensao, Prov.de Aposent.ou Reforma por Molestia Grave"
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"04. Lucro e Dividendo a partir de 1996 pago por PJ       ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 04. Lucro e Dividendo a partir de 1996 pago por PJ       "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"05. Val.Pagos Tit./Soc.Micro-Emp. exceto Pró-Labore      ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 05. Val.Pagos Tit./Soc.Micro-Emp. exceto Pro-Labore      "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"06. Indenização por Rescisão Inc.a Tit.PDV e Acid.Trab.  ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 06. Indenizacao por Rescisao Inc.a Tit.PDV e Acid.Trab.  "
		nLin +=50
		oPrint:Line(nLin,030,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"07. Outros                                               "+"("+SPACE(45)+")",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 07. Outros                                               "
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³5.  Rendimentos sujeitos a tributacao exclusiva ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin +=100
		oPrint:Say(nLin,0040,left("  5. - Rendimentos Sujeitos a Tributação Exclusiva",50),oFont12n)								  					//"  5. - Rendimentos Sujeitos a Tributacao Exclusiva (Rend.Liquido)        R$    "
		oPrint:Say(nLIn,1950,"Valores em Reais",oFont10n)
		
		nLin +=60
		nLinI:=nLin-10
		
		oPrint:Box(nLinI ,0030,nLin+160,2350)
		oPrint:Line(nLinI,1900,nLin+160,1900)
		
		nLin +=10
		oPrint:Say(nLIn,0040,"01. Décimo Terceiro Salário ",oFont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99") ,oFont12)			//"| 01. Decimo Terceiro Salario "
		nLin +=50
		oPrint:Line(nLin,040,nLin,2350)
		
		nLin +=30
		oPrint:Say(nLin,0040,"02. Outros ",ofont10)
		oPrint:Say(nLin,2000,Transform(Round(0,2),"@E 99,999,999.99"),oFont12)		//"| 02. Outros "
/*		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³6. Informacoes complementares³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aComplem:={}      
		nLinhas:=0
		If len(aComplem) > 0
			If Ascan(aComplem,{|x| Subs(x[3],18,1) == "W" .or. Subs(x[3],18,1) == "2"} ) > 0
				aEval(aComplem,{|| nLinhas+=110})
				lExigi := .T.
			Else
				aEval(aComplem,{|| nLinhas+=80})
			EndIf
			
			If (nLinhas+nLin+280) > 3080
				oPrint:EndPage() 			// Finaliza a pagina
				//-- CABECALHO
				oPrint:StartPage() 			// Inicia uma nova pagina
				nLin := 030
				nLinI:= 030
				nLin +=20
				oPrint:Box( nLinI,0030,nLin+190,2350)  				// box Cabecalho
				oPrint:Line(nLinI,1450,nLin+190,1450)				// Linha Div.Cabecalho
				If File(cFileFaz)
					oPrint:SayBitmap(nLinI+10,050, cFileFaz,235,195) // Tem que estar abaixo do RootPath
				Endif
				nLin +=20
				oPrint:say(nLin,500 ,"Ministerio da Fazenda",oFont13n)				//	ministerio da fazenda
				oPrint:Say(nLin,1500,"COMPROVANTE DE RENDIMENTOS PAGOS E DE",oFont10)				//Comprovante de rendimento
				nLin +=50
				oPrint:say(nLin+10,500 ,"SECRETARIA DA RECEITA FEDERAL",oFont13)			//secretaria de receita
				oPrint:Say(nLin,1500,"RETENÇÃO DE IMPOSTO DE RENDA NA FONTE",oFont10)             	//Retencao de rendimentos
				nLin +=50
				oPrint:Say(nLin,1560,"(EXERCÍCIO ",oFont10) 				//ano calendario
				oPrint:Say(nLin,1950,mv_par08,oFont10n)    			//ano  base
				oPrint:Say(nLin,2035,")",ofont10)
			EndIF
			
		EndIF
  */		
		nLin += 100
		
		oPrint:Say(nLin,0040,left("  6. - Informações Complementares                                        R$     ",50),oFont12n)	//"  6. - Informacoes Complementares                                        R$     "
		
		nLin	+=50
		oPrint:Box(nLin,0030,nLin + 220,2350)
//		nLinI:=nLin -10
		nLin +=20
		oPrint:say(nLin,0040,"3.1/3.2 - NA FORMA DE ARTS. 57 A 71 DO REGULAMENTO DO IMPOSTO DE RENDA (DECRETO 3000/99)",oFont10)
		nLin +=45
		oPrint:say(nLin,0040,"TRIBUTA-SE COMO RESULTADO DA ATIVIDADE RURAL, OS RENDIMENTOS RECEBIDOS",oFont10)
		nLin +=45
		oPrint:say(nLin,0040,"RELATIVOS À ATIVIDADE AGRÍCOLA",oFont10)
		nLin +=45
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³7. Responsavel pelas informacoes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLin 	+=100
		oPrint:Say(nLin,0040,"  7. - Responsável Pelas Informações",ofont12n)			//"  7. - Responsavel Pelas Informacoes"
		nLin	+=50
		oPrint:Box(nLin,0030,nLin + 100,2350)
		oPrint:Line(nLin,1300,nLin+ 100,1300)
		oPrint:Line(nLin,1540,nLin+ 100,1540)
		
		nLin +=20
		oPrint:say(nLin,0040,"Nome",oFont08)
		oPrint:Say(nLin,1340,"Data",oFont08)
		oPrint:Say(nLin,1550,"Assinatura",oFont08)
		
		nLin += 30
		oPrint:say(nLin,0050,MV_PAR10,ofont10)
		oPrint:say(nLin,1340,DtoC(dDataBase),oFont10)
		
		nLin+=50
		oPrint:say(nLin,0040,"Aprovado pela IN/RFB nº 1215, de 15 de dezembro de 2011",oFont08)		// "Aprovado pela IN/SRF No. 120/2000, com alterações da IN/SRF n} 288/2003"
		
		oPrint:EndPage() 		// Finaliza a pagina
		
		TRB->(DBSKIP())
		
	ENDDO
	
	
	
	TRB->(DBCLOSEAREA())                                                 
	oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir

	Return
	
