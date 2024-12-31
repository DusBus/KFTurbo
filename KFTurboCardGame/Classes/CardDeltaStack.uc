//Killing Floor Turbo CardDeltaStack
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardDeltaStack extends Object
	instanced;

var string DeltaStackID;

struct CardDeltaEntry
{
    var int Delta;
    var string ID;
};

var array<CardDeltaEntry> DeltaList;
var int CachedDelta;

delegate OnDeltaChanged(CardDeltaStack ChangedDelta, int Delta);

function float GetDelta()
{
    return CachedDelta;
}

final function bool HasDeltaChanges()
{
    return DeltaList.Length != 0;
}

final function AddDeltaChange(CardDeltaEntry DeltaChange)
{
    local int Index;
    if (DeltaChange.ID == "")
    {
        return;
    }

    log(DeltaStackID$": Applying delta"@DeltaChange.Delta@"from"@DeltaChange.ID@".", 'KFTurboCardGame');

    for (Index = DeltaList.Length - 1; Index >= 0; Index--)
    {
        if (DeltaList[Index].ID == DeltaChange.ID)
        {
            DeltaList[Index].Delta = DeltaChange.Delta;
            UpdateDeltaChange();
            return;
        }
    }

    DeltaList.Length = DeltaList.Length + 1;
    DeltaList[DeltaList.Length - 1] = DeltaChange;
    UpdateDeltaChange();
}

final function RemoveDelta(string ID)
{
    local int Index;
    for (Index = DeltaList.Length - 1; Index >= 0; Index--)
    {
        if (DeltaList[Index].ID == ID)
        {
            log(DeltaStackID$": Removing delta applied by"@ID@".", 'KFTurboCardGame');
            DeltaList.Remove(Index, 1);
            UpdateDeltaChange();
            return;
        }
    }
}

final function ClearDeltaChanges()
{
    DeltaList.Length = 0;
    UpdateDeltaChange();
}

final function UpdateDeltaChange()
{
    local int Index;
    CachedDelta = default.CachedDelta;
    for (Index = DeltaList.Length - 1; Index >= 0; Index--)
    {
        CachedDelta += DeltaList[Index].Delta;
    }

    log(DeltaStackID$": New delta value is"@CachedDelta@".", 'KFTurboCardGame');
    OnDeltaChanged(Self, CachedDelta);
}

defaultproperties
{
    CachedDelta = 0
}