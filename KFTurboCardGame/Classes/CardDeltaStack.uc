//Killing Floor Turbo CardDeltaStack
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardDeltaStack extends Object
	instanced;

var array<CardDelta> DeltaList;
var int CachedDelta;

delegate OnDeltaChanged(CardDeltaStack ChangedDelta, float Modifier);

final function bool HasDeltaChanges()
{
    return DeltaList.Length != 0;
}

final function AddDeltaChange(CardDelta DeltaChange)
{
    if (DeltaChange == None)
    {
        return;
    }

    DeltaList.Length = DeltaList.Length + 1;
    DeltaList[DeltaList.Length - 1] = DeltaChange;
    UpdateDeltaChange();
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

    OnDeltaChanged(Self, CachedDelta);
}

defaultproperties
{
    CachedDelta = 0
}