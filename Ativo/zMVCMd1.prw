//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Desc:  Criação do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
User Function zMVCMd1()
	Local aArea   := GetArea()
	Local oBrowse := FWMBrowse():New()

	oBrowse:SetAlias("SN1")
	oBrowse:SetDescription("Grp.Produtos (Mod.3)")
	oBrowse:AddLegend("SN1->N1_BAIXA == cTod('  /  /  ')", "BLUE" , "Ativo")
	oBrowse:AddLegend("SN1->N1_BAIXA != cTod('  /  /  ')", "YELLOW", "Baixado")
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'SN1')
	Local oStFilho 		:= FWFormStruct(1, 'SN3')
	Local aSB1Rel		:= {}

	oModel := MPFormModel():New('zMVCMd1M')
	oModel:AddFields('SN1MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('SN3DETAIL','SN1MASTER',oStFilho)

	aAdd(aSB1Rel, {'N3_FILIAL',	'N1_FILIAL'} )
	aAdd(aSB1Rel, {'N3_CBASE',	'N1_CBASE'})
	aAdd(aSB1Rel, {'N3_ITEM',	'N1_ITEM'})
	oModel:SetRelation('SN3DETAIL', aSB1Rel, SN3->(IndexKey(1)))
	//oModel:GetModel('SN3DETAIL'):SetUniqueLine({" "})
	oModel:SetPrimaryKey({})

	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('SN1MASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('SN3DETAIL'):SetDescription('Modelo Produtos')
Return oModel

Static Function ViewDef()
	Local oView		:= FWFormView():New()
	Local oModel	:= FWLoadModel('zMVCMd1')
	Local oStPai	:= FWFormStruct(2, 'SN1')
	Local oStFilho	:= FWFormStruct(2, 'SN3')

	oView:SetModel(oModel)

	oView:AddField('VIEW_SN1',oStPai,'SN1MASTER')
	oView:AddGrid('VIEW_SN3',oStFilho,'SN3DETAIL')

	oView:CreateHorizontalBox('CABEC',20)
	oView:CreateHorizontalBox('GRID',80)

	oView:SetOwnerView('VIEW_SN1','CABEC')
	oView:SetOwnerView('VIEW_SN3','GRID')

	oView:EnableTitleView('VIEW_SN1','Ativos')
	oView:EnableTitleView('VIEW_SN3','Movimentos')

Return oView