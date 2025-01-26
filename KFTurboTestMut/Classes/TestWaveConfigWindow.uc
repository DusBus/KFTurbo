class TestWaveConfigWindow extends FloatingWindow;

var automated GUISectionBackground Container;
var automated moComboBox WaveNumber, PlayerCount;
var automated GUIButton Apply;

var TestLaneWaveManager Manager;

function Update(TestLaneWaveManager NewManager)
{
    Manager = NewManager;
    WaveNumber.SetIndex(Manager.WaveNumber);
    PlayerCount.SetIndex(Manager.PlayerCount - 1);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int Index;
	Super.Initcomponent(MyController, MyOwner);

    for (Index = 1; Index <= 7; Index++)
    {
        WaveNumber.AddItem(string(Index));
    }
    for (Index = 1; Index <= 6; Index++)
    {
        PlayerCount.AddItem(string(Index));
    }

    Container.ManageComponent(WaveNumber);
    Container.ManageComponent(PlayerCount);
    Container.ManageComponent(Apply);
}

function bool ApplySettings(GUIComponent Sender)
{
    local KFTTPlayerController TestPlayerController;
    TestPlayerController = KFTTPlayerController(PlayerOwner());

    if (TestPlayerController != None)
    {
        TestPlayerController.ServerApplyWaveControlSettings(Manager, WaveNumber.GetIndex(), PlayerCount.GetIndex() + 1);
    }

    return true;
}

function bool NoDraw(Canvas Canvas)
{
    return true;
}

defaultproperties
{
    WindowName="Wave Settings"
    bResizeWidthAllowed=False
    bResizeHeightAllowed=False
    bMoveAllowed=false
    DefaultTop=0.2
    DefaultLeft=0.2
    DefaultWidth=0.6
    DefaultHeight=0.6
    bRequire640x480=True
    bPersistent=True
    bAllowedAsLast=True
    WinTop=0.2
    WinLeft=0.2
    WinWidth=0.6
    WinHeight=0.6

    Begin Object Class=GUIHeader Name=WaveConfigTitleBar
        bUseTextHeight=True
        WinHeight=0.05
        RenderWeight=0.100000
        bBoundToParent=True
        bScaleToParent=True
        bAcceptsInput=True
        bNeverFocus=False
        ScalingType=SCALE_X
        OnMousePressed=TestWaveConfigWindow.FloatingMousePressed
        OnMouseRelease=TestWaveConfigWindow.FloatingMouseRelease
    End Object
    t_WindowTitle=GUIHeader'WaveConfigTitleBar'

    Begin Object Class=GUISectionBackground Name=WaveConfigContainer
        ImageColor=(R=0,G=0,B=0,A=0)
        WinTop=0.05
        WinHeight=0.950000
        bBoundToParent=True
        bScaleToParent=True
        OnPreDraw=WaveConfigContainer.InternalPreDraw
        OnDraw=NoDraw
    End Object
    Container=GUISectionBackground'WaveConfigContainer'

    Begin Object Class=moComboBox Name=WaveNumberComboBox
        bReadOnly=True
        Caption="Wave Number"
        OnCreateComponent=WaveNumberComboBox.InternalOnCreateComponent
        Hint="Select the wave number from Turbo+ you'd like to simulate."
        TabOrder=1
    End Object
    WaveNumber=moComboBox'WaveNumberComboBox'

    Begin Object Class=moComboBox Name=PlayerCountComboBox
        bReadOnly=True
        Caption="Player Count"
        OnCreateComponent=PlayerCountComboBox.InternalOnCreateComponent
        Hint="Select the player count you'd like to simulate."
        TabOrder=2
    End Object
    PlayerCount=moComboBox'PlayerCountComboBox'

    Begin Object Class=GUIButton Name=ApplyButton
        Caption="Apply"
        TabOrder=3
        OnClick=TestWaveConfigWindow.ApplySettings
        OnKeyEvent=ApplyButton.InternalOnKeyEvent
    End Object
    Apply=GUIButton'ApplyButton'
}
