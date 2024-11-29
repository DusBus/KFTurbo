class TurboBuyMenuSaleListBox extends SRBuyMenuSaleListBox;

delegate OnSaleItemClicked(TurboGUIBuyable SelectedSaleItem);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'TurboBuyMenuSaleList');
	Super(KFBuyMenuSaleListBox).InitComponent(MyController, MyOwner);

	if (TurboBuyMenuSaleList(List) != None)
	{
		TurboBuyMenuSaleList(List).OnSaleItemClicked = ReceivedListSaleItemClick;
	}
}

function ReceivedListSaleItemClick(TurboGUIBuyable SelectedSaleItem)
{
	OnSaleItemClicked(SelectedSaleItem);
}

defaultproperties
{
}
