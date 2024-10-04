class TurboTab_ServerNews extends ServerPerks.SRTab_ServerNews;

var array<string> NewsText;
var bool bHasInitialized;

//Skip loading from a webpage for now.
function Timer()
{
    local string Text;
    local string ParsedText;
    local int Index;

    if (bHasInitialized)
    {
        return;
    }

    bHasInitialized = true;

    for (Index = 0; Index < NewsText.Length; Index++)
    {
        ParsedText = Repl(NewsText[Index], "%dq", "\"");
        ParsedText = Repl(ParsedText, "%sq", "\'");
        Text $= ParsedText;
    }

	SetNewsText(Text);
}

defaultproperties
{   
    Begin Object Class=TurboGUIHTMLTextBox Name=TurboHTMLInfoText
        LaunchKFURL=TurboTab_ServerNews.SwitchPage
        WinTop=0.052000
        WinLeft=0.030000
        WinWidth=0.945000
        WinHeight=0.760000
        bBoundToParent=True
        bScaleToParent=True
        bNeverFocus=True
        OnDraw=TurboHTMLInfoText.RenderHTMLText
        OnClick=TurboHTMLInfoText.LaunchURL
    End Object
    HTMLText=TurboGUIHTMLTextBox'TurboHTMLInfoText'

    bHasInitialized=false
    NewsText(0)="<BODY LINK=#f44336 ALINK=#cc0000>"
    NewsText(1)="<TITLE>Information</TITLE><TAB X=20><FONT SIZE=-8 COLOR=grey>KILLING FLOOR TURBO<br>"
    NewsText(2)="<TAB X=40><FONT SIZE=-6 COLOR=grey>Welcome to Killing Floor Turbo!<br>"
    NewsText(3)="<FONT SIZE=-4 COLOR=grey><br>KFTurbo is a balance overhaul mod for Killing Floor that also includes a few QoL improvements.<br>"
    NewsText(4)="Try KFTurbo challenge modes! KFTurbo Card Game, KFTurbo Randomizer and KFTurbo+!<br>"
    NewsText(5)="Text chat has emote autocomplete! Type %dq:%dq to start!<br>"
    NewsText(6)="More information about the mod can be found on the github <A HREF=%dqhttp://github.com/KFPilot/KFTurbo%dq>here</A> <FONT SIZE=-4 COLOR=grey>.<br><br>"
    NewsText(7)="<br><br><br><br><br><br><br><br><br><br><br><br><br><br><FONT SIZE=-4 COLOR=grey>Number one. That%sqs terror.<br>Number two. That%sqs terror."
    NewsText(8)="</BODY>"
}