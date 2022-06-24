//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Desc:  Criação do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
User Function zMVCMd3()
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
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'SN1')
	Local oStFilho 		:= FWFormStruct(1, 'SN4')
	Local aSB1Rel		:= {}

	oModel := MPFormModel():New('zMVCMd3M')
	oModel:AddFields('SN1MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('SN4DETAIL','SN1MASTER',oStFilho)

	aAdd(aSB1Rel, {'N4_FILIAL',	'N1_FILIAL'} )
	aAdd(aSB1Rel, {'N4_CBASE',	'N1_CBASE'})
	aAdd(aSB1Rel, {'N4_ITEM',	'N1_ITEM'})
	oModel:SetRelation('SN4DETAIL', aSB1Rel, SN4->(IndexKey(1)))
	oModel:SetPrimaryKey({})

	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('SN1MASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('SN4DETAIL'):SetDescription('Modelo Produtos')
Return oModel

Static Function ViewDef()
	Local oView		:= FWFormView():New()
	Local oModel	:= FWLoadModel('zMVCMd3')
	Local oStPai	:= FWFormStruct(2, 'SN1')
	Local oStFilho	:= FWFormStruct(2, 'SN4')

	oView:SetModel(oModel)

	oView:AddField('VIEW_SN1',oStPai,'SN1MASTER')
	oView:AddGrid('VIEW_SN4',oStFilho,'SN4DETAIL')

	oView:CreateHorizontalBox('CABEC',20)
	oView:CreateHorizontalBox('GRID',80)

	oView:SetOwnerView('VIEW_SN1','CABEC')
	oView:SetOwnerView('VIEW_SN4','GRID')

	oView:EnableTitleView('VIEW_SN1','Ativos')
	oView:EnableTitleView('VIEW_SN4','Movimentos')

Return oView