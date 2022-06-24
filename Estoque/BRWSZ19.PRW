#include "Protheus.ch"
#include "FWMVCDEF.ch"

User Function BRWSZ9()
    Local aArea: GetNextAlias()
    Local oBrowseSZ9 //objeto que recebera o instancioamento da classe Fwrmbrowse

    oBrowseSZ9 := Fwrmbrowse():New()
    
    //passo como parametro a tabela que eu quero mostrar no Browse
    oBrowseSZ9: setAlias("SZ9")
    oBrowseSZ9: setDescription("Tela de Protheuszeiro SZ9")
    oBrowseSZ9: Activate();

    RestArea(aArea)
  

Return 
