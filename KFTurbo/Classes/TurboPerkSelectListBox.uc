class TurboPerkSelectListBox extends SRPerkSelectListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'TurboPerkSelectList');
	Super(KFPerkSelectListBox).InitComponent(MyController,MyOwner);
}

defaultproperties
{
}
