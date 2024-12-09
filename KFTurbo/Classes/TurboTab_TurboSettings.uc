class TurboTab_TurboSettings extends SRTab_Base;

var automated GUISectionBackground LeftSection, RightSection;
var automated GUIButton DesiredRankButton;
var automated moCheckbox MerchantReplacementCheckBox;
var Color PerkLabelTextColor;
var localized string TierOptionList[8];

var bool bHasInitialized;
var array< class<TurboVeterancyTypes> > VeterancyClassList;
var array< GUIComboBox > VeterancyTierComboBoxList;

function ShowPanel(bool bShow)
{
	Super.ShowPanel(bShow);

	if (!bShow)
	{
        return;
	}

    if (!bHasInitialized)
    {
        if (!IsVeterancyTierPreferenceReady())
        {
            DesiredRankButton.DisableMe();
            return;
        }
        
        DesiredRankButton.EnableMe();
        InitializePage();
        bHasInitialized = true;
        return;
    }

    UpdatePage();
}

function bool IsVeterancyTierPreferenceReady()
{
    local TurboPlayerController PlayerController;
	local ClientPerkRepLink CPRL;
	local TurboRepLink TRL;

    PlayerController = TurboPlayerController(PlayerOwner());

    if (PlayerController.TurboInteraction == None || !PlayerController.TurboInteraction.bHasInitializedPerkTierPreference)
    {
        return false;
    }

    CPRL = PlayerController.GetClientPerkRepLink();

    if (CPRL == None || !CPRL.bRepCompleted)
    {
        return false;
    }

    TRL = PlayerController.GetTurboRepLink();

    if (TRL == None)
    {
        return false;
    }
    
    return true;
}

function InitializePage()
{
    local TurboPlayerController PlayerController;
    local ClientPerkRepLink CPRL;
    local TurboRepLink TRL;
    local int Index, ComboIndex;
    local float GUITop;
    local GUILabel Label;
    local GUIComboBox ComboBox;

    PlayerController = TurboPlayerController(PlayerOwner());
    CPRL = PlayerController.GetClientPerkRepLink();
    TRL = PlayerController.GetTurboRepLink();

    VeterancyClassList.Length = CPRL.CachePerks.Length;
    VeterancyTierComboBoxList.Length = VeterancyClassList.Length;
    GUITop = LeftSection.WinTop + 0.03f;

    for (Index = 0; Index < VeterancyClassList.Length; Index++)
    {
        VeterancyClassList[Index] = class<TurboVeterancyTypes>(CPRL.CachePerks[Index].PerkClass);
        Label = GUILabel(AddComponent(string(class'GUILabel')));
        Label.Caption = VeterancyClassList[Index].default.VeterancyName;
        Label.bBoundToParent = true;
        Label.bScaleToParent = true;
        Label.TextColor = PerkLabelTextColor;
        Label.WinTop = GUITop;
        Label.WinLeft = 0.04f;
        Label.WinHeight = 0.04f;
        Label.WinWidth = 0.16f;
        GUITop += 0.04f;

        ComboBox = GUIComboBox(AddComponent(string(class'GUIComboBox')));
        VeterancyTierComboBoxList[Index] = ComboBox;
        ComboBox.bBoundToParent = true;
        ComboBox.bScaleToParent = true;
        ComboBox.WinTop = GUITop;
        ComboBox.WinLeft = 0.04f;
        ComboBox.WinHeight = 0.04f;
        ComboBox.WinWidth = 0.16f;
        GUITop += 0.06f;

        for (ComboIndex = 0; ComboIndex < ArrayCount(TierOptionList); ComboIndex++)
        {
            ComboBox.AddItem(TierOptionList[ComboIndex]);
        }

        ComboBox.SetIndex(TRL.GetVeterancyTierPreference(VeterancyClassList[Index]));
    }

    RightSection.ManageComponent(MerchantReplacementCheckBox);
    MerchantReplacementCheckBox.Checked(class'TurboInteraction'.static.UseMerchantReplacement(PlayerController));
}

function UpdatePage()
{
    local TurboRepLink TRL;
    local int Index;

    TRL = TurboPlayerController(PlayerOwner()).GetTurboRepLink();
    for (Index = 0; Index < VeterancyClassList.Length; Index++)
    {
        VeterancyTierComboBoxList[Index].SetIndex(TRL.GetVeterancyTierPreference(VeterancyClassList[Index]));
    }
}

function bool ApplyDesiredRank(GUIComponent Sender)
{
	local TurboInteraction TurboInteraction;
    local int Index;

    TurboInteraction = TurboPlayerController(PlayerOwner()).TurboInteraction;

    if (TurboInteraction == None)
    {
        return true;
    }

    for (Index = 0; Index < VeterancyClassList.Length; Index++)
    {
        TurboInteraction.SetVeterancyTierPreference(VeterancyClassList[Index], VeterancyTierComboBoxList[Index].GetIndex());
    }

    return true;
}

function OnMerchantReplacementChanged(GUIComponent Sender)
{
	local TurboInteraction TurboInteraction;

    TurboInteraction = TurboPlayerController(PlayerOwner()).TurboInteraction;

    if (TurboInteraction == None)
    {
        return;
    }

    TurboInteraction.SetUseMerchantReplacement(MerchantReplacementCheckBox.IsChecked());
}

defaultproperties
{
    bHasInitialized = false

    PerkLabelTextColor=(R=255,G=255,B=255,A=255)

    TierOptionList(0)="0 (Red)"
    TierOptionList(1)="1 (Green)"
    TierOptionList(2)="2 (Blue)"
    TierOptionList(3)="3 (Pink)"
    TierOptionList(4)="4 (Purple)"
    TierOptionList(5)="5 (Gold)"
    TierOptionList(6)="6 (Platinum)"
    TierOptionList(7)="7 (Shining)"

    Begin Object Class=GUISectionBackground Name=BGLeftSection
        bFillClient=True
        Caption="Neon Weapon Tier Limit"
        WinTop=0.012063
        WinLeft=0.019240
        WinWidth=0.3
        WinHeight=0.796032
        OnPreDraw=BGLeftSection.InternalPreDraw
    End Object
    LeftSection=GUISectionBackground'BGLeftSection'

    Begin Object Class=GUISectionBackground Name=BGRightSection
        bFillClient=True
        Caption="Turbo Settings"
        WinTop=0.012063
        WinLeft=0.68076
        WinWidth=0.3
        WinHeight=0.796032
        OnPreDraw=BGRightSection.InternalPreDraw
    End Object
    RightSection=GUISectionBackground'BGRightSection'

    Begin Object Class=GUIButton Name=ApplyDesiredRankButton
        Caption="Apply"
        TabOrder=50
        WinTop=0.740000
        WinLeft=0.04
        WinWidth=0.100000
        WinHeight=0.050000
        OnClick=ApplyDesiredRank
        OnKeyEvent=ApplyDesiredRankButton.InternalOnKeyEvent
    End Object
    DesiredRankButton=GUIButton'ApplyDesiredRankButton'

    Begin Object Class=moCheckBox Name=MerchantReplacement
        Caption="Use Merchant"
        OnCreateComponent=MerchantReplacement.InternalOnCreateComponent
        Hint="Replaces default Trader with Merchant."
        TabOrder=51
        OnChange=TurboTab_TurboSettings.OnMerchantReplacementChanged
    End Object
    MerchantReplacementCheckBox=moCheckBox'MerchantReplacement'
}
