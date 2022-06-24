#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RELSIMP     � Autor � Thiago Henrique   � Data �  04/12/14 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio para conferencia do arquivo texto gerado para o  ���
���          � I-SIMP ANP.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Usina Campo Lindo                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RELSIMP


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Conferencia do arquivo I-SIMP"
Local cPict         := ""
Local titulo        := "Relatorio de Conferencia do arquivo I-SIMP"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := "Linha      Operacao "+SPAC(45)+"Produto"+SPAC(13)+"UM"+space(5)+"Quantidade        Quant.(Kg)      Documento        Emissao"
Local imprime       := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RELSIMP" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg 		:= "EXPSIMP   "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELSIMP" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

pergunte(cPerg,.F.)

Cabec1        := "Arquivo: "+MV_PAR03+SPAC(26)+"Per�odo: "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/12/14   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nTamFile, nTamLin, cBuffer, nBtLidos


//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

Private nHdl    := fOpen(MV_PAR03,68)

Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+MV_PAR03+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif


nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 33+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

nTamLin  := 242+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto


ProcRegua(nTamFile) // Numero de registros a processar

While nBtLidos >= nTamLin

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
   
   IncProc()


    _cNSEQ := Substr(cBuffer,01,10)
    _cCODINST := Substr(cBuffer,11,10)
    _cMREF := Substr(cBuffer,21,06)
    _cCODOPER := Substr(cBuffer,27,07)
    _cINSTCLI := Substr(cBuffer,42,07)
    _cDESCOPER := POSICIONE("SZF",1,xFilial("SZF")+_cCODOPER,"ZF_DESC")
    
    IF(Substr(cBuffer,48,09)='810102004')
    	_cProduto := Substr(cBuffer,48,09)+"-"+'ANIDRO  C'+' L '
    ElseIf(Substr(cBuffer,48,09)='810102001')
    	_cProduto := Substr(cBuffer,48,09)+"-"+'ANIDRO   '+' L '
    ElseIf (Substr(cBuffer,48,09)='810101001')
    	_cProduto := Substr(cBuffer,48,09)+"-"+'HIDRATADO'+' L '
    ElseIf (Substr(cBuffer,48,09)='140201001')
    	_cProduto := Substr(cBuffer,48,09)+"-"+'CANA     '+' KG'
    EndIf
    //_cProduto := Substr(cBuffer,48,09)+"-"+IIF(Substr(cBuffer,48,09)='810102001','ANIDRO   ', 'HIDRATADO')//POSICIONE("SB1",1,xFilial("SB1")+Substr(cBuffer,48,09),"B1_DESC")
    _cQtd := TRANSFORM(VAL(Substr(cBuffer,57,15)),"@E 99,999,999")
    _cQtdKg := TRANSFORM(VAL(Substr(cBuffer,72,15)),"@E 99,999,999")
    _cDoc := Substr(cBuffer,224,09)
    _cData := Substr(cBuffer,154,02)+'/'+Substr(cBuffer,156,02)+'/'+Substr(cBuffer,158,04)
   

    @nLin,00 PSAY _cNSEQ+" "+_cCODOPER+"-"+_cDESCOPER+"      "+_cProduto+"        "+_cQtd+"      "+_cQtdKg+"      "+_cDoc+"        "+_cData


   	nLin := nLin + 1 // Avanca a linha de impressao

    //���������������������������������������������������������������������Ŀ
    //� Leitura da proxima linha do arquivo texto.                          �
    //�����������������������������������������������������������������������

    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto

EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
