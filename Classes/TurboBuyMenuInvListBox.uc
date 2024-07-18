class TurboBuyMenuInvListBox extends SRKFBuyMenuInvListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'TurboBuyMenuInvList');
	Super(KFBuyMenuInvListBox).InitComponent(MyController,MyOwner);
}

defaultproperties
{
}
