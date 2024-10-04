class TurboChatInteraction extends Engine.Interaction;

simulated function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{
	if (Action == IST_Press && Key == IK_Tab && ViewportOwner != None && ViewportOwner.Console != None && ViewportOwner.Console.bTyping)
	{
		TryChatAutoComplete();
	}

	return false;
}

simulated function bool KeyType( out EInputKey Key, optional string Unicode )
{
	if (Key == IK_Tab && ViewportOwner != None && ViewportOwner.Console != None && ViewportOwner.Console.bTyping)
	{
		TryChatAutoComplete();
	}

	return false;
}

simulated function TryChatAutoComplete()
{
	local int LastColonIndex;
	local string EmoteText;
	local array<string> HintList;
	if (ViewportOwner.Console.TypedStrPos < Len(ViewportOwner.Console.TypedStr))
	{
		return;
	}

	if (!class'TurboHUDKillingFloor'.static.CheckEmotePrompt(ViewportOwner.Console.TypedStr, LastColonIndex))
	{
		return;
	}

	EmoteText = Mid(ViewportOwner.Console.TypedStr, LastColonIndex);

	if (!class'TurboHUDKillingFloor'.static.GetHintList(EmoteText, TurboHUDKillingFloor(ViewportOwner.Actor.myHUD).SmileyMsgs, HintList))
	{
		return;
	}
	
	EmoteText = HintList[HintList.Length - 1];
	ViewportOwner.Console.TypedStr = Left(ViewportOwner.Console.TypedStr, LastColonIndex) $ EmoteText;
	ViewportOwner.Console.TypedStrPos = Len(ViewportOwner.Console.TypedStr);
}

defaultproperties
{
	bActive=true
}