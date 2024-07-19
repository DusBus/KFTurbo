class TurboBuyMenuSaleListBox extends SRBuyMenuSaleListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'TurboBuyMenuSaleList');
	Super(KFBuyMenuSaleListBox).InitComponent(MyController, MyOwner);
}

defaultproperties
{
}
