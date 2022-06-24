#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Programa  ? CADSL2791  Autor ?HENRIQUE TOFANELLI       Data ? 06/12/10 ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ???
???Descricao ? Cadastro de Parametros do Salario da cat. rural            ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CADSL2791()


private lMsErroAuto := .F.
Private cCadastro := "Parametros do Salário da Cat. Rural"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Incluir"    , "u_fIncluir",0,3},;
{"Alterar"    , "u_fAltera",0,4},;
{"Excluir"    , "u_DelCondo",0,5,3},;
{"Visualizar" , "AxVisual",0,5} }


Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ6"

dbSelectArea("SZ6")
dbSetOrder(1)

//Realiza Filtro de Segurança

aCores := {}

aIndSZ6   := {}
cFilSZ6   := ""

cFilSZ3   := If(Empty(cFilSZ6),".T.",cFilSZ6)

cCondicao := "Z6_FILIAL=='"+xFilial("SZ6")+"'


bFiltraBrw := {|| FilBrowse("SZ6",@aIndSZ6,@cCondicao) }
Eval(bFiltraBrw)


dbSelectArea(cString)
//----- limpeza dos deletados
//cQry2:=" DELETE FROM "+RetSqlName("SZN")+"    " +;
//" WHERE  D_E_L_E_T_='*'           "
//TcSqlExec(cQry2)
//-----
//_SIT := "" //"ALLTRIM(SZN->ZN_ORDEM)=='001'"
//_SIT := "ALLTRIM(SZN->ZN_STATUS)=='L1'"

//mBrowse(6, 1, 22, 75, cString,,@_SIT,,,, aCores)
mBrowse(6, 1, 22, 75, cString,,,,,, aCores)

Return


User Function fIncluir(cAlias, nReg, nOpc)


Local nOpcao := 0

//IF SELECT("SZ6") > 0

//MSGBOX("Opção Indisponível. Já Existe parametro Cadastrado. Utilize Botão Alterar ! ","INCLUSÃO DE PARAMETROS 2791","ALERT")
//RETURN()

//Endif


nOpcao := AxInclui("SZ6")

if nOpcao == 1  //vaga incluida
	//if !empty(SZN->ZN_NIVELIB)   // Alltrim(getmv("MV_EMAILRH")) <> ""
	
	PUTMV("MV_SAL2791",SZ6->Z6_SAL2791)
	PUTMV("MV_DIA2791",SZ6->Z6_DIA2791)
	
					RECLOCK("SZ6",.F.)
					SZ6->Z6_DTINCLU  := DDATABASE
					MSUNLOCK("SZ6")
	
	
	//endif
endif
Return


User Function fAltera()

Local _Recno   := Recno()
Local _Order   := IndexOrd()

AxAltera("SZ6",Recno(),3)

//PUTMV("MV_SAL2791",SZ6->Z6_SAL2791)
//PUTMV("MV_DIA2791",SZ6->Z6_DIA2791)

					RECLOCK("SZ6",.F.)
					SZ6->Z6_DTALTER    := DDATABASE
					SZ6->Z6_USERALT    := SUBST(CUSUARIO,7,15)
					MSUNLOCK("SZ6")

Return


User Function DelCondo()

MsgStop("Registro não pode ser excluida !")


Return








