#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EditTxt                                                     ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para adicionar uma linha de informacao dentro de um  ���
���          �arquivo texto.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EditTxt(_cArq,_cInfo) //_cArq: Nome do arquivo ja com extensao //_cInfo: Informacao a ser gravada

Local _nHdl

If File(_cArq)
   _nHdl = fopen(_cArq,1)
Else
   _nHdl = fcreate(_cArq,0)
Endif
fseek (_nHdl,0,2)  // Encontra final do arquivo
fwrite(_nHdl,_cInfo+chr(13)+chr(10))
fclose(_nHdl)

Return(.T.)