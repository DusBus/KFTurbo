//Killing Floor Turbo TurboCardDeck
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardDeck extends Object;

var array< TurboCard > DeckCardObjectList;

function InitializeDeck()
{
    local int Index;

    for (Index = 0; Index < DeckCardObjectList.Length; Index++)
    {
        DeckCardObjectList[Index].DeckClass = Class;
        DeckCardObjectList[Index].CardIndex = Index;
    }
}

static function TurboCard GetCardFromReference(TurboCardReplicationInfo.CardReference Reference)
{
    if (Reference.Deck != default.Class || Reference.CardIndex < 0 || Reference.CardIndex >= default.DeckCardObjectList.Length)
    {
        return None;
    }

    return default.DeckCardObjectList[Reference.CardIndex];
}

function TurboCard PopRandomCardObject()
{
    local TurboCard Card;
    local int Index;
    Index = Rand(DeckCardObjectList.Length);
    Card = DeckCardObjectList[Index];
    DeckCardObjectList.Remove(Index, 1);
    return Card;
}

defaultproperties
{
    
}
