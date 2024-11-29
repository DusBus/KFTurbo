class TurboBuyMenuInvListBox extends SRKFBuyMenuInvListBox;

delegate OnInvItemClicked(GUIBuyable SelectedInvItem);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'TurboBuyMenuInvList');
	Super(KFBuyMenuInvListBox).InitComponent(MyController,MyOwner);

	if (TurboBuyMenuInvList(List) != None)
	{
		TurboBuyMenuInvList(List).OnInvItemClicked = ReceivedListInvItemClick;
	}
}

function GUIBuyable GetSelectedBuyable()
{
	if (List.Index < 0 || List.Index >= List.MyBuyables.Length)
	{	
		return None;
	}

	return List.MyBuyables[List.Index];
}

function ReceivedListInvItemClick(GUIBuyable SelectedInvItem)
{
	OnInvItemClicked(SelectedInvItem);
}

defaultproperties
{
}
