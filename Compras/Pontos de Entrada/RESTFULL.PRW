#INCLUDE "protheus.ch"
#INCLUDE "restful.ch"

WSRESTFUL helloword DESCRIPTION "Teste servico REST Campo Lindo!"
  WSMETHOD GET DESCRIPTION "Retornar a reposta REST Campo Lindo"
END WSRESTFUL

WSMETHOD GET WSSERVICE helloword
  ::setResponse('[{"Status":"Hello World"}]')
RETURN .T.
