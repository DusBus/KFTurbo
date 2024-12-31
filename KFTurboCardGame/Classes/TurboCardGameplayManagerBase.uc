//Killing Floor Turbo TurboCardGameplayManagerBase
//Handles all modifications, deltas and flags that Card Game is applying.
//Responsible for setting these values elsewhere/spinning up actors to handle the actual gameplay changes.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardGameplayManagerBase extends Engine.Info;

var KFTurboCardGameMut CardGaneMutator;
var KFTurboGameType TurboGameType;
var TurboCardReplicationInfo CardReplicationInfo;
var TurboCardGameModifierRepLink CardGameModifier;
var TurboCardClientModifierRepLink CardClientModifier;
var CardGameRules CardGameRules;

var array<CardModifierStack> CardModifierList;
var array<CardDeltaStack> CardDeltaList;
var array<CardFlag> CardFlagList;

function PostBeginPlay()
{
    local CardDeltaStack CardDelta;
    local CardModifierStack CardStack;
    local CardFlag CardFlag;
    local int Count;

    Super.PostBeginPlay();

    TurboGameType = KFTurboGameType(Level.Game);
    CardGaneMutator = KFTurboCardGameMut(Owner);

    if (CardGaneMutator == None)
    {
        return;
    }

    CardReplicationInfo = CardGaneMutator.TurboCardReplicationInfo;
    CardGameModifier = CardGaneMutator.TurboCardGameModifier;
    CardClientModifier = CardGaneMutator.TurboCardClientModifier;
    CardGameRules = CardGaneMutator.CardGameRules;

    log("Collecting all modifiers, deltas and flags...", 'KFTurboCardGame');
    StopWatch(false);
    Count = 0;
    CardModifierList.Length = 80;
    foreach AllObjects(class'CardModifierStack', CardStack)
    {
        //This filters out CDO instances.
        if (CardStack.Outer == None || CardStack.Outer.IsA('Class'))
        {
            continue;
        }

        CardModifierList[Count] = CardStack;
        Count++;
    }
    CardModifierList.Length = Count;

    Count = 0;
    CardDeltaList.Length = 80;
    foreach AllObjects(class'CardDeltaStack', CardDelta)
    {
        if (CardDelta.Outer == None || CardDelta.Outer.IsA('Class'))
        {
            continue;
        }

        CardDeltaList[Count] = CardDelta;
        Count++;
    }
    CardDeltaList.Length = Count;
    
    Count = 0;
    CardFlagList.Length = 80;
    foreach AllObjects(class'CardFlag', CardFlag)
    {
        if (CardFlag.Outer == None || CardFlag.Outer.IsA('Class'))
        {
            continue;
        }

        CardFlagList[Count] = CardFlag;
        Count++;
    }
    CardFlagList.Length = Count;
    StopWatch(true);
    log("... collection of"@CardModifierList.Length@"modifiers,"@CardDeltaList.Length@"deltas and"@CardFlagList.Length@"flags complete!", 'KFTurboCardGame');
}

defaultproperties
{

}