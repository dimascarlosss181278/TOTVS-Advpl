#include "RwMake.Ch"
#INCLUDE "XGPE340.CH"  //Grafico
#INCLUDE "XGPER340.CH"
#INCLUDE "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER340  ³ Autor ³ R.H. - Marcos Stiefano³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Cargos e Salarios                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER340(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauro      ³12/01/01³------³ Nao estava Filtrando categoria na Impress³±±
±±³ Silvia     ³04/03/02³------³ Ajustes na Picture para Localizacoes    .³±±
±±³ Natie      ³05/09/02³------³ Acerto devido mudanca C.custo c/tam 20   ³±±
±±³ Emerson    ³16/10/02³------³ Somente quebrar C.C. se nao quebrou Fil. ³±±
±±³ Mauro      ³13/11/02³060517³ Saltar Pagina a cada Quebra de Filial    ³±±
±±³ Silvia     ³11/09/03³065152³ Inclusao de Query                        ³±±
±±³ Emerson    ³23/03/04³------³ Inclusao de 2 casas decimais na criacao  ³±±
±±³            ³        ³      ³ dos campos SALMES e SALHORA. 		      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function yGPE340()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString := "SRA"        // alias do arquivo principal (Base)
Local aOrd    := {STR0001,STR0002,OemtoAnsi(STR0003),STR0029,STR0030,OemtoAnsi(STR0031)}    //"C.Custo + Matricula "###"C.Custo + Nome"###"C.Custo + Fun‡„o"###"Nome"###"Matricula"###"Fun‡„o"
Local cDesc1  := STR0004		//"Rela‡„o de Cargos e Salario."
Local cDesc2  := STR0005		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0006		//"usuario."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 1, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg := "GPER340"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    := "GPR340"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := STR0009		//"RELA€O DE CARGOS E SALARIOS"
Private AT_PRG   := "GPER340"
Private Wcabec0  := 2
Private Wcabec1  := STR0010		//"FI  MATRIC NOME                           ADMISSAO   FUNCAO                  MAO DE       SALARIO   PERC.   PERC.   PERC."
Private Wcabec2  := STR0011		//"                                                                                      OBRA         NOMINAL  C.CUSTO  FILIAL  EMPRESA"
Private CONTFL   := 1
Private LI		  := 0
Private nTamanho := "G"
Private cPict1	:=	If (MsDecimais(1)==2,"@E 999,999,999,999.99",TM(999999999999,18,MsDecimais(1)))  // "@E 999,999,999,999.99
Private cPict2	:=	If (MsDecimais(1)==2,"@E 999,999,999.99",TM(999999999,14,MsDecimais(1)))  // "@E 999,999,999.99
private _fol := 0//Grafico
Private centro
//FI C.CUSTO	MATRIC NOME             				  ADMISSAO FUNCAO 						 MAO DE		  SALARIO	PERC.   PERC.	 PERC."
// 																												 OBRA 		  NOMINAL  C.CUSTO  FILIAL  EMPRESA"
//01 123456789 123456 123456789012345678901234567890 01/01/01 1234 12345678901234567890  IND   99.999.999,99	999,99  999,99   999,99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER340"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)


//Grafico
oFont08 := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)  
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)  
oFont12 := TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.T.,.F.)  
oFont13 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont17 := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)  
oFont14 := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)  
oFont15 := TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.T.,.F.)  
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)  

oPrint:= TAVPrinter():New( "ROMANEIO DE SEPARACAO" )
//oPrint:SetPortrait() // ou SetLandscape()  Ró define se é retrato ou paisagem
oPrint:SetLandscape()
oPrint:Setup()
oPrint:StartPage()   // Inicia uma nova página
*-*
If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| GP340Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GP340IMP ³ Autor ³ R.H.                  ³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ImpressÆo da Relacao de Cargos e Salarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GP340IMP(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GP340IMP(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSalario   := nSalMes := nSalDia := nSalHora := 0
Local aTFIL 	 := {}
Local aTCC       := {}
Local aTFILF	 := {}
Local aTCCF 	 := {}
Local TOTCC      := 0 //Alterado o Tipo de Array para Numerico
Local TOTCCF     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFIL     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFILF    := 0 //Alterado o Tipo de Array para Numerico
Local cAcessaSRA := &("{ || " + ChkRH("GPER340","SRA","2") + "}")
Local aStruSRA                                          
Local cArqNtx   := cIndCond := ""
Local cAliasSRA := "SRA" 	//Alias da Query
Local xCC_SAL := 0
Local xCC_PERIC := 0
Local TOTCC_REL := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aInfo     := {}
Private aCodFol   := {}
Private aRoteiro  := {}
Private lQuery

Pergunte("GPR340",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem	    := aReturn[8]
cFilDe	    := mv_par01									//  Filial De
cFilAte	    := mv_par02									//  Filial Ate
cCcDe 	    := mv_par03									//  Centro de Custo De
cCcAte	    := mv_par04									//  Centro de Custo Ate
cMatDe	    := mv_par05									//  Matricula De
cMatAte	    := mv_par06									//  Matricula Ate
cNomeDe	    := mv_par07									//  Nome De
cNomeAte    := mv_par08									//  Nome Ate
cFuncDe	    := mv_par09									//  Funcao De
cFuncAte    := mv_par10									//  Funcao Ate
cSituacao   := mv_par11									//  Situacao Funcionario
cCategoria  := mv_par12									//  Categoria Funcionario
lSalta	    := If( mv_par13 == 1 , .T. , .F. )		//  Salta Pagina Quebra C.Custo
nQualSal    := mv_par14									//  Sobre Salario Mes ou Hora
nBase       := mv_par15                                //  Sobre Salario Composto Base
nTipoRel    := mv_par16                                //  Imprime             Analitico               Sintetico
lImpTFilEmp := If( mv_par17 == 1 , .T. , .F. )		//  Imprime Total Filial/Empresa

//-- Modifica variaveis para a Query
cSitQuery := ""
For nS:=1 to Len(cSituacao)
	cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
	If ( nS+1) <= Len(cSituacao)
		cSitQuery += "," 
	Endif
Next
cCatQuery := ""
For nS:=1 to Len(cCategoria)
	cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
	If ( nS+1) <= Len(cCategoria)
		cCatQuery += "," 
	Endif
Next

Titulo := STR0012			//"RELACAO DE CARGOS E SALARIOS "
/*/
If nOrdem==1
	Titulo += STR0013		//"(C.CUSTO + MATRICULA)"
ElseIf nOrdem==2
	Titulo +=STR0014		//"(C.CUSTO + NOME)"
ElseIf nOrdem==3 
	Titulo +=STR0015		//"(C.CUSTO + FUNCAO)"
ElseIf nOrdem == 4		
	Titulo +=STR0034		//"(NOME)"
ElseIf nOrdem == 5		
	Titulo +=STR0035		//"(MATRICULA)"
ElseIf nOrdem == 6		
	Titulo +=STR0036		//"(FUNCAO)"
EndIf		
/*/

aCampos := {}
AADD(aCampos,{"FILIAL"   ,"C",02,0})
AADD(aCampos,{"MAT"      ,"C",06,0})
AADD(aCampos,{"CC"       ,"C",09,0})
AADD(aCampos,{"SALMES"   ,"N",TamSX3("RA_SALARIO")[1],2})
AADD(aCampos,{"SALHORA"  ,"N",TamSX3("RA_SALARIO")[1],2})
AADD(aCampos,{"CODFUNC"  ,"C",05,0}) //oRDER
AADD(aCampos,{"DESCFUN"  ,"C",30,0})
AADD(aCampos,{"NOME"     ,"C",30,0})
AADD(aCampos,{"ADMISSA"  ,"D",08,0})
AADD(aCampos,{"PERICULO" ,"N",TamSX3("RA_SALARIO")[1],2}) //rOSANGELA
AADD(aCampos,{"SITUACAO" ,"C",01,0})


cNomArqA:=CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomArqA, "TRA", if(.F. .Or. .F., !.F., NIL), .F. )
IndRegua("TRA",cNomArqA,"FILIAL+CC+DESCFUN+DTOS(ADMISSA)+NOME",,,) //"Selecionando Registros..."   ORDER

// Sempre na ordem de Centro de Custo + Matricula para totalizar
dbSelectArea( "SRA" )

lQuery	:=	.F.

#IFDEF TOP
	If TcSrvType() != "AS/400"
		lQuery	:=.T.
	Endif
#ENDIF	

If lQuery
	cQuery := "SELECT * "		
	cQuery += " FROM "+	RetSqlName("SRA")
	cQuery += " WHERE "
	If !lImpTFilEmp
		cQuery += " RA_FILIAL  between '" + cFilDe  + "' AND '" + cFilAte + "' AND"
		cQuery += " RA_MAT     between '" + cMatDe  + "' AND '" + cMatAte + "' AND"
		cQuery += " RA_NOME    between '" + cNomeDe + "' AND '" + cNomeAte+ "' AND"
		cQuery += " RA_CC      between '" + cCcDe   + "' AND '" + cCcate  + "' AND"
		cQuery+=  " RA_CODFUNC between '" + cFuncDe + "' AND '" + cFuncAte+ "' AND"
 	Endif
	cQuery += " RA_CATFUNC IN (" + Upper(cCatQuery) + ") AND" 
	cQuery += " RA_SITFOLH IN (" + Upper(cSitQuery) + ") AND" 
	cQuery += " D_E_L_E_T_ <> '*' "		
	cQuery   += " ORDER BY RA_FILIAL, RA_CC, RA_MAT"

	aStruSRA := SRA->(dbStruct())
	dbCloseArea("SRA")
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)
	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX 
Else
	dbSetOrder(2)					
	dbGoTop()
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

cFilialAnt := "!!" 
cFANT 	  := "!!"
cCANT 	  := Space(20)

TPAGINA	 := TPEREMP := TEMPRESA := TFILIAL := TCCTO := FL1 := 0
TEMPRESAF := TFILIALF := TCCTOF	:= 0
TCCPER := 0
While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Quebra de Filial 											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_FILIAL # cFilialAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) 			 .Or.;
			!fInfo(@aInfo,SRA->RA_FILIAL)
			dbSelectArea("SRA")
			dbSkip()
			If Eof()
				Exit
			Endif	
			Loop
		Endif
		dbSelectArea( "SRA" )
		cFilialAnt := SRA->RA_FILIAL
	EndIf

	If !lQuery
		IF !lImpTFilEmp // -- Se nao imprimir %ais Filial/Empresa Filtra os Parametros Selecionados
			If ( SRA->RA_FILIAL < cFilDe )	.Or. ( SRA->RA_FILIAL > cFilAte )	.Or.;
			   ( SRA->RA_NOME < cNomeDe )	.Or. ( SRA->RA_NOME > cNomeAte )	.Or.;
				( SRA->RA_MAT < cMatDe )	.Or. ( SRA->RA_MAT > cMatAte )		.Or.;
				(SRA->RA_CC < cCcDe) 		.Or. (SRA->RA_CC > cCcAte)			.Or.;
				(SRA->RA_CODFUNC < cFuncDe).Or. (SRA->RA_CODFUNC > cFuncAte)
				dbSkip()
				Loop			
			EndIf
	    EndIF
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa Situacao do Funcionario na Folha						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		EndIf
   Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSkip()
		Loop
	EndIf

	nSalario   := 0
	nSalMes	  := 0
	nSalDia	  := 0
	nSalHora   := 0

	//If nBase = 1		                                        // 1 composto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula Salario Incorporado Mes , Dia , Hora do Funcionario  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  //	fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)
//	Else
		fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,"A")      // 2 Base
	   //	nSalario := nSalario+IIf(SRA->RA_PERICUL <> "",((nSalario*30)/100),0)     //Rosangela
		If nQualSal == 1		// 1-Mes
			nSalMes := nSalario			
		Else						// 2-Hora
			nSalHora := Round(nSalario / SRA->RA_HRSMES,MsDecimais(1))
		EndIf			
  //	Endif	
   dbSelectArea( "SRA" )
   RecLock("TRA",.T.)
   Replace FILIAL    With SRA->RA_FILIAL
   Replace MAT       With SRA->RA_MAT  
   Replace CC        With SRA->RA_CC 
   Replace CODFUNC   With SRA->RA_CODFUNC
   Replace DESCFUN   With DESCFUN(TRA->CODFUNC,TRA->FILIAL)
   Replace ADMISSA   With SRA->RA_ADMISSA
   Replace NOME      With SRA->RA_NOME
   Replace SITUACAO  With SRA->RA_SITFOLH
   
   If nQualSal == 1
   	  Replace SALMES    With nSalMes         
	Else
      Replace SALHORA   With nSalHora    
	Endif	
    If nQualSal == 1
   	  Replace PERICULO    With IIF(SRA->RA_PERICUL <> 0,((nSalMes*30)/100),0)   //ROSANGELA      
	Else
      Replace PERICULO    With IIF(SRA->RA_PERICUL <> 0,((nSalHora*30)/100),0)  //ROSANGELA
	Endif	
    
	MsUnLock()
   
	If cFANT == "!!"
		cFANT := SRA->RA_FILIAL
		cCANT := substr(SRA->RA_CC+space(20),1,20)
	EndIf
	
	TEMPRESA  += If( nQualSal == 1 , nSalMes , nSalHora )
	TPEREMP   += IIF(SRA->RA_PERICUL <> 0,((If( nQualSal == 1 , nSalMes , nSalHora )*30)/100),0)  //Rosangela
	TEMPRESAF ++

	
	If SRA->RA_FILIAL = cFANT
		TFILIAL	+= If( nQualSal == 1 , nSalMes , nSalHora )
		TFILIALF ++
	Else
		AADD(aTFIL ,{cFANT ,TFILIAL})
		AADD(aTFILF,{cFANT ,TFILIALF})
		TFILIAL	:= If( nQualSal == 1 , nSalMes , nSalHora )
		TFILIALF := 1
	EndIf
			
	If SRA->RA_FILIAL + substr(SRA->RA_CC+space(20),1,20) = cFANT + cCANT
		//TCCTO  += If( nQualSal == 1 , nSalMes , nSalHora ) //rOSANGELA
		TCCTO  += If( nQualSal == 1 , nSalMes , nSalHora )+IIF(SRA->RA_PERICUL <> 0,((If( nQualSal == 1 , nSalMes , nSalHora )*30)/100),0)
//		xAUX += TCCTO
		TCCPER += IIF(SRA->RA_PERICUL <> 0,((If( nQualSal == 1 , nSalMes , nSalHora )*30)/100),0) //rOSANGELA
		TCCTOF ++
	Else
		AADD(aTCC ,{cFANT+cCANT,TCCTO,TCCPER})
		AADD(aTCCF,{cFANT+cCANT,TCCTOF })
		//TCCTO  := If( nQualSal == 1 , nSalMes , nSalHora )rosangela
		TCCTO  := If( nQualSal == 1 , nSalMes , nSalHora )+IIF(SRA->RA_PERICUL <> 0,((If( nQualSal == 1 , nSalMes , nSalHora )*30)/100),0)
//		xAUX += TCCTO
		TCCPER += IIF(SRA->RA_PERICUL <> 0,((If( nQualSal == 1 , nSalMes , nSalHora )*30)/100),0) //rOSANGELA
		TCCTOF := 1
	EndIf
		
	cCANT := substr(SRA->RA_CC+space(20),1,20)
	cFANT := SRA->RA_FILIAL
	dbSelectArea( "SRA" )
	dbSkip()
EndDo

If Eof() .And. TFILIAL > 0
	AADD(aTFIL , {cFANT ,TFILIAL})
	AADD(aTFILF, {cFANT ,TFILIALF})
	AADD(aTCC  , {cFANT + cCANT ,TCCTO,TCCPER}) //ROSANGELA
	AADD(aTCCF , {cFANT + cCANT ,TCCTOF})
EndIf

If lQuery
	dbSelectArea("SRA")
	dbCloseArea()
Endif	
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EMISSAO DO RELATORIO   								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If TFILIALF > 0
	dbSelectArea("TRA")
	dbGotop()
	If nOrdem == 1
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->MAT"
		cArqNtx := CriaTrab(Nil,.F.)
//		IndRegua("TRA",cArqNtx,cIndCond)
		IndRegua("TRA",cNomArqA,"FILIAL+CC+DESCFUN+DTOS(ADMISSA)+NOME",,,) //"Selecionando Registros..."   ORDER
//		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		dbSeek(cFilDe + cCcDe ,.T.)
	ElseIf nOrdem == 2
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->NOME"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe + cNomeDe,.T.)
   ElseIf nOrdem == 3
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->CODFUNC"
		cArqNtx := CriaTrab(Nil,.F.)
//		IndRegua("TRA",cArqNtx,cIndCond)
		IndRegua("TRA",cNomArqA,"FILIAL+CC+DESCFUN+DTOS(ADMISSA)+NOME",,,) //"Selecionando Registros..."   ORDER
		dbSeek(cFilDe + cCcDe,.T.)
	ElseIf nOrdem == 4
		cIndCond := "TRA->FILIAL + TRA->NOME"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cNomeDe,.T.)
	ElseIf nOrdem == 5
		cIndCond := "TRA->FILIAL + TRA->MAT"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cMatDe,.T.)
	ElseIf nOrdem == 6
		cIndCond := "TRA->FILIAL +TRA->CODFUNC"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cFuncDe,.T.)			
   EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Regua Processamento											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	cFANT := TRA->FILIAL
	cCANT := substr(TRA->CC+space(20),1,20)
    VTCCPER := 0		
	Tper    := 0   
	nlinha:=35  //Grafico
	//_fol+=1    //Grafico
    _cabec()
    //IF _fol = 1
       For w = 1 To Len(atcc)
          If aTCC[w,1] = cFANT + cCANT                  
             DET := "Centro de Custo: "+Substr(cCANT+Space(10),1,20)+Space(20)+Subs(DescCc(cCAnt,cFAnt),1,30)  //+" "+STR0018+Transform(aTCCF[w,2],"@E 999,999")+"  "+Transform(aTCC[w,2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
             nlinha+=60
             oPrint:Say  (nLinha,050,DET,oFont14)
             nlinha+=35
             oPrint:Say  (nLinha,000,replicate("_",300),oFont08)
             nlinha+=35
//             oPrint:Say  (nLinha,000,"Matricula  		Nome                             								Função               		             Admissão     				Salário  		          Adicional     Total",oFont13)
/*/
			oPrint:Say  (nLinha,50,"Matricula",oFont13)	                                                                 
            oPrint:Say  (nLinha,300,"Nome",oFont13)  
            oPrint:Say  (nLinha,1200,"Funcao",oFont13)  
            oPrint:Say  (nLinha,1820,"Admissao",oFont13)  
            oPrint:Say  (nLinha,2400,"Salário",oFont13)  
            oPrint:Say  (nLinha,2700,"Adicional",oFont13)           
            oPrint:Say  (nLinha,3000,"Salario+Adicional",oFont13)           
            nlinha+=35
            oPrint:Say  (nLinha,000,replicate("_",300),oFont08)			      			
/*/
	      End			                         
	  Next
    //End			  
    *-*
	While !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua Processamento								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua()
	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIf
		If ( TRA->FILIAL < cFilDe ) .Or. ( TRA->FILIAL > cFilAte ) .Or.;
		   ( TRA->NOME < cNomeDe )	.Or. ( TRA->NOME > cNomeAte )	 .Or.;
			( TRA->MAT < cMatDe ) .Or. ( TRA->MAT > cMatAte )	.Or.;
			(TRA->CC < cCcDe) 	.Or. (TRA->CC > cCcAte)	 .Or.;
			(TRA->CODFUNC < cFuncDe).Or. (TRA->CODFUNC > cFuncAte)
			dbSkip()
			Loop			
		EndIf
	   
		// Apenas por ordem de Centro de Custo
		If nOrdem==1 .Or. nOrdem ==2 .Or. nOrdem ==3
			IF substr(TRA->CC+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
				If !Empty(TOTCC) .or. !Empty(TOTCCF	)	
					//impr(Repli("_",132),"C")  grafico
					nlinha+=35
                    oPrint:Say  (nLinha,00,Replicate("_",300),oFont08)				
					For x=1 To Len(aTCC)
						If aTCC[X,1] = cFANT + cCANT 
							//DET := STR0017+Substr(cCANT+Space(20),1,20)+"_"+Subs(DescCc(cCAnt,cFAnt),1,20)+" "+STR0018+Transform(aTCCF[X,2],"@E 999,999")+"  "+Transform(aTCC[X,2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
							DET := "Total por C.C : "+Transform(aTCCF[X,2],"@E 999,999")+"  "+Transform(aTCC[X,2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
//							xTOTCC_GER = xTOTCC_GER + aTCCF[X,2]
							totsal := aTCC[X,2]-VTCCPER
							totsal_ad := aTCC[X,2]
							totcc_rel += aTCCF[X,2]
							IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
								For w=1 To Len(aTFIL)
									If aTFIL[W,1] = cFANT
										DET +=Space(02)+Transform(VTCCPER,cPict2) //Rosangela
										DET +=Space(02)+Transform((aTCC[X,2]/aTFIL[W,2])*100,"@E 999.999")
										//DET +=Space(02)+Transform((aTCC[X,2]/TEMPRESA)*100,"@E 999.999")
										VTCCPER := 0  
										Exit
									EndIf
								Next w
						    EndIF
						EndIf
					Next x
					//impr(DET,"C")
					nlinha+=35
                    oPrint:Say  (nLinha,050,substr(DET,1,15),oFont14)
                    oPrint:Say  (nLinha,1400,substr(DET,20,10),oFont15)
                    oPrint:Say  (nLinha,2230,Transform(totsal,"@E 99,999,999.99"),oFont15)
                    oPrint:Say  (nLinha,2650,substr(DET,50,10),oFont15)
                    oPrint:Say  (nLinha,2930,Transform(totsal_ad,"@E 99,999,999.99"),oFont15)
                    
					//impr(Repli("_",132),"C")
					nlinha+=35
                    oPrint:Say  (nLinha,00,Replicate("_",300),oFont08)									
					If lSalta .And. (TRA->FILIAL == cFANT)
						//impr(" ","P") //Observação		
					EndIf
				EndIf
				dbSelectArea( "TRA" )
			EndIf
		EndIf
			
		If Eof() .Or. TRA->FILIAL # cFANT
		   If !Empty(TOTCCF) .And. !Empty(TOTFIL) 		
				//impr(Repli("_",132),"C")
				nlinha+=35
                oPrint:Say  (nLinha,00,Repli("_",300),oFont08)									
				IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
					For x=1 To Len(aTFIL)
						IF aTFIL[X,1] = cFANT
							cNomeFilial:=Space(15)
							If fInfo(@aInfo,cFANT)
								cNomeFilial:=aInfo[1]
							Endif
//							DET := STR0017+ " - "+ Transform(xTOTCC_GER,"@E 999,999")
							DET += STR0019+cFANT+" - " + cNomeFilial+"  "+STR0020+Transform(TOTFILF,"@E 999,999")+"        "+Transform(TOTFIL,cPict1)	//"TOTAL DA FILIAL "###"                        QTDE......:"
							For w=1 To Len(aTFIL)
								If aTFIL[W,1] = cFANT
									DET +=Space(19)+Transform((aTFIL[W,2] / TEMPRESA)*100,"@E 999.999")
									Exit
								Endif
							Next w
						Endif
					Next x
				EndIF
				//impr(DET,"C")
				nlinha+=45
                oPrint:Say  (nLinha,00,DET,oFont10)									
				//impr(Repli("_",132),"C")                                          
				nlinha+=35
                oPrint:Say  (nLinha,00,Repli("_",300),oFont08)													
				//impr(" ","P") //Observação
			EndIf
			dbSelectArea( "TRA" )
		EndIf

		If nTipoRel == 1				// AnaliticoTransform( TRA->PERICULO+TRA->SALMES,"@E 999,999.99")
			
			DescMO := "   "   
			FBuscaSRJ(TRA->FILIAL,TRA->CODFUNC,@DescMO)
			DET :=""	                       
			DET := TRA->FILIAL+"  "+TRA->MAT + " "
			DET += SubStr(TRA->NOME,1,30)+" "+PadR(DTOC(TRA->ADMISSA),10)
			DET += " "+TRA->CODFUNC+"_"+DESCFUN(TRA->CODFUNC,TRA->FILIAL)+" "	
 			DET += DescMO +" "+Transform( If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA ) ,cPict2)+"  "				   
			DET += Transform( TRA->PERICULO,cPict2)+"   "	 //rosangela				   
			DET += Transform(TRA->SALMES+TRA->PERICULO,"@E 999,999.99")
			DET += TRA->SITUACAO
			For x:=1 To Len(aTCC)
				If aTCC[X,1] = TRA->FILIAL+substr(TRA->CC+space(20),1,20)
					//RET += Transform( (If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  )/ aTCC[X,2] )*100,"@E 999.999")+" " //ROSANGELA
					DET += Transform( ((If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  )+TRA->PERICULO) / aTCC[X,2] )*100,"@E 999.999")+" "
					TOTCC := aTCC[X,2]
					xCC_SAL = xCC_SAL + TRA->SALMES
					xCC_PERIC = xCC_PERIC + TRA->PERICULO
					TOTCCF:= aTCCF[X,2]
				EndIf
			Next x
		 	IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
				For x=1 To Len(aTFIL)
					If aTFIL[X,1] = TRA->FILIAL
						//DET += Transform( (If( nQualSal==1 , TRA->SALMES, TRA->SALHORA  ) / aTFIL[x,2] )*100,"@E 999.999")+"  "
						DET += Transform( ((If( nQualSal==1 , TRA->SALMES, TRA->SALHORA  )+TRA->PERICULO) / aTFIL[x,2] )*100,"@E 999.999")+"  " //rOSANGELA
					   	//DET += Transform( (If( nQualSal==1 , TRA->SALMES, TRA->SALHORA  ) / TEMPRESA )* 100,"@E 999.999")
                        //DET += Transform( TRA->PERICULO,cPict2)	 //rosangela				   
				        VTCCPER += TRA->PERICULO //rOSANGELA
				        Tper += TRA->PERICULO
				 EndIf
				Next x
			EndIF
			TPAGINA += If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  )
		    // Zona de impressão do cabeçalho do centro de custo
			//impr(DET,"C")
	    	
	    	IF substr(TRA->CC+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
		       //For w = 1 To Len(atcc)
			     // If aTCC[w,1] = cFANT + cCANT                  
	                 Centro:= "Centro de Custo: "+Substr(TRA->CC,1,20)+Space(20)+Subs(DescCc(TRA->CC,cFAnt),1,20)  //+" "+STR0018+Transform(aTCCF[w,2],"@E 999,999")+"  "+Transform(aTCC[w,2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
	                 //DET := "guz "+STR0017+Substr(TRA->CC,1,20)+"_"+Subs(DescCc(cCAnt,cFAnt),1,20)+" "+STR0018+Transform(aTCCF[w,2],"@E 999,999")+"  "+Transform(aTCC[w,2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
			         nlinha+=35
			         nlinha+=35
			         nlinha+=35
			         oPrint:Say  (nLinha,050,Centro,oFont14)
                     nlinha+=35
			         oPrint:Say  (nLinha,000,replicate("_",300),oFont08)
                     nlinha+=35
//                     oPrint:Say  (nLinha,000,"Matricula  Nome                             Função                            Admissão     Salário            Adicional     Total",oFont13)
					oPrint:Say  (nLinha,50,"Matrícula",oFont13)	                                                                 
		            oPrint:Say  (nLinha,300,"Nome",oFont13)  
		            oPrint:Say  (nLinha,1200,"Função",oFont13)  
		            oPrint:Say  (nLinha,1820,"Admissão",oFont13)
					oPrint:Say  (nLinha,2100,"Sit.",oFont13)
		            oPrint:Say  (nLinha,2400,"Salário",oFont13)  
		            oPrint:Say  (nLinha,2700,"Adicional",oFont13)           
		            oPrint:Say  (nLinha,3000,"Salário+Adicional",oFont13)           
	                nlinha+=35
                    oPrint:Say  (nLinha,000,replicate("_",300),oFont08)			      			
			     // End			                         
			   //Next
			End 
			nlinha+=35
            oPrint:Say  (nLinha,50,substr(DET,4,8),oFont12)
            oPrint:Say  (nLinha,300,substr(DET,12,30),oFont12)
            oPrint:Say  (nLinha,1200,substr(DET,60,20),oFont12)
            oPrint:Say  (nLinha,1800,substr(DET,42,10),oFont12)
			oPrint:Say  (nLinha,2100,TRA->SITUACAO,oFont12)            
            oPrint:Say  (nLinha,2300,Transform(TRA->SALMES,"@E 999,999.99"),oFont12)
            oPrint:Say  (nLinha,2650,Transform(TRA->PERICULO,"@E 999,999.99"),oFont12)           
            oPrint:Say  (nLinha,3000,Transform(TRA->SALMES+TRA->PERICULO,"@E 999,999.99"),oFont12)           
                       												
		EndIf			
		cFANT := TRA->FILIAL
		cCANT := substr(TRA->CC+space(20),1,20) 
		TCCPER := 0  //ROSANGELA
		For x:=1 To Len(aTCC)
			If aTCC[X,1] = TRA->FILIAL+substr(TRA->CC+space(20),1,20)
				TOTCC  := aTCC[X,2]
//				xTOTCC_GER = xTOTCC_GER + TOTCC
				TOTCCF := aTCCF[X,2] 
				TCCPER := aTCC[X,3] //rOSANGELA
			EndIf
		Next x
		
		For x=1 To Len(aTFIL)
			If aTFIL[X,1] = TRA->FILIAL
				TOTFIL := aTFIL[X,2]
				TOTFILF:= aTFILF[X,2]
			EndIf
		Next x
				
		dbSelectArea( "TRA" )
		dbSkip()
						
		if nlinha > 2000
		                 //GSS			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			              oPrint:EndPage()     // Finaliza a página
			              oPrint:StartPage()   // Inicia uma nova página
			              _CABEC()
		Endif

		
		
	EndDo

	If nOrdem ==1 .Or. nOrdem==2 .Or. nOrdem==3      // imprime linha detalhe analítica
		If !Empty(TOTCC) .And. !Empty(TOTCCF) .And. !Empty(TOTFIL) .And. !Empty(TOTFILF) .Or. ( Eof()  .And. !Empty(TOTCC) )
			//impr(Repli("_",132),"C")
			nlinha+=35
            oPrint:Say  (nLinha,000,Repli("_",300),oFont08)													
			DET := "Total por C.C : "+Transform(aTCCF[Ascan(atccf, {|X| X[1] == CFANT+CCANT}),2],"@E 999,999")+"  "+Transform(aTCC[Ascan(atccf, {|X| X[1] == CFANT+CCANT}),2]-VTCCPER,cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
			totcc_rel := totcc_rel + aTCCF[Ascan(atccf, {|X| X[1] == CFANT+CCANT}),2]
		     IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
  				DET +=Space(02)+Transform(VTCCPER,cPict2)  //ROSANGELA
  				DET +=Space(11)+Transform((TOTCC/TOTFIL)*100,"@E 999.999")
				//DET +=Space(02)+Transform((TOTCC/TEMPRESA)*100,"@E 999.999")  
				
				
		    EndIF
			//impr(DET,"C")
   			nlinha+=35
            oPrint:Say  (nLinha,050,substr(DET,1,15),oFont14)
            oPrint:Say  (nLinha,1400,substr(DET,20,10),oFont15)
            oPrint:Say  (nLinha,2120,Transform(aTCC[Ascan(atccf, {|X| X[1] == CFANT+CCANT}),2]-VTCCPER,cPict1),oFont15)
            oPrint:Say  (nLinha,2560,Transform(VTCCPER,cPict2),oFont15)
            oPrint:Say  (nLinha,2910,Transform(aTCC[Ascan(atccf, {|X| X[1] == CFANT+CCANT}),2],"@E 999,999,999.99"),oFont15)


		EndIf
	EndIf	

	//impr(Repli("_",132),"C")			
	nlinha+=35
    oPrint:Say  (nLinha,00,Repli("_",300),oFont08)									
				
	cNomeFilial:=Space(15)
	If fInfo(@aInfo,cFANT)
		cNomeFilial:=ainfo[1]
	EndIf
	IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
		DET := STR0037 + " - " + Space(40) + Transform(xCC_SAL,cPict1) + Space(2) + Transform(xCC_PERIC,cPict2)
		//impr(DET,"C")
		nlinha+=35
//       oPrint:Say  (nLinha,00,DET,oFont14)
        oPrint:Say  (nLinha,050,substr(DET,1,50),oFont14)
        oPrint:Say  (nLinha,1400,Transform(Totcc_rel, "@E 999,999")  ,oFont15)        
        oPrint:Say  (nLinha,1200,substr(DET,52,10),oFont14)
        oPrint:Say  (nLinha,2120,Transform(xCC_SAL,cPict1),oFont15)
        oPrint:Say  (nLinha,2560,Transform(xCC_PERIC,cPict2),oFont15)
        oPrint:Say  (nLinha,2910,Transform(xCC_SAL+xCC_PERIC,"@E 999,999,999.99"),oFont15)

       
		//impr(Repli("_",132),"C")
//		nlinha+=35
//        oPrint:Say  (nLinha,00,Repli("_",300),oFont08)													
		DET := STR0019+ cFANT + " - " + cNomeFilial+Space(29)+STR0020+Transform(TOTFILF,"@E 999,999")+"  "+Transform(TOTFIL,cPict1)	//"TOTAL DA FILIAL "###"QTDE.:"
		//DET +=Space(19)+Transform((TOTFIL / TEMPRESA)*100,"@E 999.999") rosangela
		DET +=Space(2)+Transform(TPEREMP,cPict2)                                        
		//impr(DET,"C")
		nlinha+=35
//        oPrint:Say  (nLinha,00,DET,oFont14)													
		//impr(Repli("_",132),"C")
//		nlinha+=35
//        oPrint:Say  (nLinha,00,Repli("_",300),oFont08)													
		//impr(Repli("_",132),"C")
		nlinha+=35
        oPrint:Say  (nLinha,00,Repli("_",300),oFont08)									
				
		DET := STR0025+" - " + Left(SM0->M0_NOMECOM,39) +Space(5)+ STR0026+Transform(TEMPRESAF , "@E 999,999")+"  "+;	//"TOTAL DA EMPRESA  "###"QTDE.:"
		Transform(TEMPRESA ,cPict1)+"  "+Transform(TPEREMP ,cPict2)
		//impr(DET,"C")
		nlinha+=35
//        oPrint:Say  (nLinha,00,DET,oFont14)													
        oPrint:Say  (nLinha,050,substr(DET,1,60),oFont14)
        oPrint:Say  (nLinha,1400,Transform(TEMPRESAF , "@E 999,999"),oFont15)
        oPrint:Say  (nLinha,2120,Transform(TEMPRESA ,cPict1),oFont15)
        oPrint:Say  (nLinha,2560,Transform(TPEREMP ,cPict2),oFont15)
        oPrint:Say  (nLinha,2910,Transform(TEMPRESA+TPEREMP ,"@E 999,999,999.99"),oFont15)
        

		//impr(Repli("_",132),"C")
		nlinha+=35
        oPrint:Say  (nLinha,00,Repli("_",300),oFont08)
   		nlinha+=35
        oPrint:Say  (nLinha,050,"SITUAÇÃO: ( ) Normal, (A)fastado, (F)érias, (T)ransferido)",oFont12)        
				
    EndIF
    impr(" ","F")	// Observação
	aTCC	:={}
	aTFIL	:={}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SRA")
dbSetOrder(1)
Set Filter To

dbSelectArea("TRA")
dbCloseArea()
fErase( cArqNtx + OrdBagExt() )

/*
If TFILIALF > 0
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Endif	
*/

//Grafico
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
//oprint:SetUp()
oPrint:End()




*--------------------------------------------------*
Static Function fBuscaSRJ( cFil , cCodigo , DescMO )
*--------------------------------------------------*
Local cAlias := Alias()

dbSelectArea( "SRJ" )
If ( cFil # Nil .And. cFilial == "  " ) .Or. cFil == Nil
	cFil := cFilial
Endif
If dbSeek( cFil + cCodigo )
	If Left(RJ_MAOBRA ,1 ) == "D"
		DescMO := STR0027		//"DIR"
	Elseif Left(RJ_MAOBRA ,1 ) == "I"
		DescMO := STR0028		//"IND"
	Else
		DescMO := "   "
	Endif
Else
	DescMO := "***"
Endif
	
dbSelectArea(cAlias)
Return(.T.)


STATIC FUNCTION _CABEC
_fol+=1
nlinha:=35
oPrint:Say  (nLinha,00,replicate("_",300),oFont08)
nlinha+=35
oPrint:Say  (nLinha,0010,"Agro Industrial Campo Lindo Ltda",oFont10)
oPrint:Say  (nLinha,3000,"Folha..:"+str(_fol),oFont10)
nlinha+=35
oPrint:SayBitmap(nLinha,000,"lgrl10.bmp",100,50)//300,204)//375,93 )
oPrint:Say  (nLinha,1050,titulo,oFont16)
oPrint:Say  (nLinha,3000,"DT.Ref.:"+dtoc(ddatabase),oFont10)
//nlinha+=35
//oPrint:Say  (nLinha,50,STR0009,oFont16)
//oPrint:Say  (nLinha,2100,"Emissao:"+dtoc(date()),oFont08)
nlinha+=70
oPrint:Say  (nLinha,000,replicate("_",300),oFont08)
//nlinha+=35
//oPrint:Say  (nLinha,000,"Matricula  Nome                             Função                            Admissão     Salário            Adicional     Total",oFont12)
//nlinha+=35
//oPrint:Say  (nLinha,000,STR0011,oFont08)
//nlinha+=35
//oPrint:Say  (nLinha,000,replicate("_",300),oFont08)
nlinha+=35
oPrint:Say  (nLinha,50,"Matrícula",oFont13)	                                                                 
oPrint:Say  (nLinha,300,"Nome",oFont13)  
oPrint:Say  (nLinha,1200,"Função",oFont13)  
oPrint:Say  (nLinha,1820,"Admissão",oFont13)
oPrint:Say  (nLinha,2100,"Sit.",oFont13)
oPrint:Say  (nLinha,2400,"Salário",oFont13)  
oPrint:Say  (nLinha,2700,"Adicional",oFont13)           
oPrint:Say  (nLinha,3000,"Salário+Adicional",oFont13)           
nlinha+=35
oPrint:Say  (nLinha,000,replicate("_",300),oFont08)
nlinha+=35
Return