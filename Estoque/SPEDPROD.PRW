#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function SPEDPROD()
Local _aGetArea := GetArea()
//Local cAlias := paramixb[1]
Local aProd := {}
Local aTipo := {}

AADD(aTipo,{"ME","00"}) //MERCADORIA PARA REVENDA
AADD(aTipo,{"MP","01"}) //MATERIA PRIMA
AADD(aTipo,{"EM","02"}) //EMBALAGEM
AADD(aTipo,{"PP","03"}) //PRODUTO EM PROCESSO
AADD(aTipo,{"PA","04"}) //PRODUTO ACABADO
AADD(aTipo,{"SP","05"}) //SUBPRODUTO
AADD(aTipo,{"PI","06"}) //PRODUTO INTERMEDIARIO
AADD(aTipo,{"MC","07"}) //MATERIAL DE USO E CONSUMO
AADD(aTipo,{"AI","08"}) //ATIVO IMOBILIZADO
AADD(aTipo,{"MO","09"}) //SERVICOS
AADD(aTipo,{"ES","10"}) //EQUIPAMENTOS DE SEGURAN�A

/*
_cQuery1 := " SELECT * "
_cQuery1 += " FROM "+RetSqlName("SB1")+" SB1 (NOLOCK) "
_cQuery1 += " WHERE B1_COD = '" + SFT->FT_PRODUTO + "'"
_cQuery1 += " AND D_E_L_E_T_ <> '*'"
TCQUERY _cQuery1 NEW ALIAS "QRY"
dbSelectArea("QRY")
QRY->(DBGOTOP())
*/

_cQuery1 := " SELECT * "
_cQuery1 += " FROM DB2ADMIN." + RetSqlName("SB1") + " SB1 "
_cQuery1 += " WHERE B1_FILIAL = '" + SFT->FT_FILIAL + "'"
_cQuery1 += " AND B1_COD = '" + SFT->FT_PRODUTO + "'"
_cQuery1 += " AND D_E_L_E_T_ = ' '"
TCQUERY _cQuery1 NEW ALIAS "QRY"
dbSelectArea("QRY")
QRY->(DBGOTOP())

// Padrao Tipo 01
cTipo := '01'
nAchou := Ascan(aTipo,{|x| x[1] == AllTrim(QRY->B1_TIPO)}) // Localiza TIpo Produto no Vetor aTipo e Pega o Codigo Correto
If !Empty(nAchou) // Se achar o tipo na lista do Vetor aTipo entao Substitui a Variavel cTipo
cTipo := aTipo[nAchou,2]
Endif

IF !QRY->(EOF())
aadd(aProd,QRY->B1_COD) // C�digo do Produto
aadd(aProd,QRY->B1_DESC) // Descri��o do produto
aadd(aProd,QRY->B1_CODBAR) // C�digo de barras
aadd(aProd,QRY->B1_CODANT) // C�digo Anterior
aadd(aProd,QRY->B1_UM) // Unidade de medida
aadd(aProd,cTipo) // Tipo do Item (Tipo SPED)
aadd(aProd,QRY->B1_POSIPI) // C�digo de NCM
aadd(aProd,QRY->B1_EX_NCM) // Exce��o da NCM
aadd(aProd,SubStr(QRY->B1_POSIPI,1,2)) // C�digo do g�nero do item
aadd(aProd,QRY->B1_CODISS) // C�digo de ISS
aadd(aProd,QRY->B1_PICM) // Al�quota de ICMS
ENDIF

DbCloseArea("QRY")


RestArea(_aGetArea)
Return(aProd)
