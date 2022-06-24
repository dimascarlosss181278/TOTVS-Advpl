#Include 'Protheus.ch'

User Function CnabCEF()
//Conv: 288105
Local nSeq := GetMV('MV_CNABCEF')
nSeq := nSeq + 1 

MsgInfo("Cod. Sequencia: " + StrZero(nSeq,6),"Atenção")

PutMV('MV_CNABCEF',StrZero(nSeq,6))

Return (StrZero(nSeq,6))