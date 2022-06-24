//Ajustar


USER FUNCTION GP410DES	
_nSALBAS := SRA->RA_SALARIO		// salario base
_nSALLIQ:=POSICIONE("SRC",1,xFilial("SRC")+SRA->RA_MAT+"726","RC_VALOR")
_bEntra := IF((SRA->RA_GERCNAB<>"N"),.T.,.F.)
			   //.AND. (_nSALLIQ>=MV_PAR37 .AND. _nSALLIQ<=MV_PAR38) ;
			  // .AND. (SRA->RA_GERCNAB<>"N"),.T.,.F.)	
			   //.AND. (_nSALBAS>=MV_PAR39 .AND. _nSALBAS<=MV_PAR40),.T.,.F.)				 
//_bEntra := .T.				 
RETURN _bEntra

