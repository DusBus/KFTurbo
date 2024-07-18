class TurboGUIBuyMenu extends SRGUIBuyMenu;

function InitTabs()
{
	local SRKFTab_BuyMenu B;

	B = SRKFTab_BuyMenu(c_Tabs.AddTab(PanelCaption[0], string(class'TurboTab_BuyMenu'),, PanelHint[0]));
	c_Tabs.AddTab(PanelCaption[1], string(class'TurboTab_Perks'),, PanelHint[1]);

	SRBuyMenuFilter(BuyMenuFilter).SaleListBox = SRBuyMenuSaleList(B.SaleSelect.List);
}

defaultproperties
{
}
