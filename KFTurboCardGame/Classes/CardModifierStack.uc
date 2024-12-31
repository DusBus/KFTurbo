//Killing Floor Turbo CardModifierStack
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardModifierStack extends Object
	instanced;

var string ModifierStackID;

struct CardModifierEntry
{
    var float Modifier;
    var string ID;
};

var protected array<CardModifierEntry> ModifierList;
var protected float CachedModifier;

delegate OnModifierChanged(CardModifierStack ModifiedStack, float Modifier);

function float GetModifier()
{
    return CachedModifier;
}

final function bool HasModifiers()
{
    return ModifierList.Length != 0;
}

final function AddModifier(CardModifierEntry Modifier)
{
    local int Index;

    if (Modifier.ID == "")
    {
        return;
    }

    log(ModifierStackID$": Applying modifier"@Modifier.Modifier@"from"@Modifier.ID@".", 'KFTurboCardGame');

    for (Index = ModifierList.Length - 1; Index >= 0; Index--)
    {
        if (ModifierList[Index].ID == Modifier.ID)
        {
            ModifierList[Index].Modifier = Modifier.Modifier;
            UpdateModifier();
            return;
        }
    }

    ModifierList.Length = ModifierList.Length + 1;
    ModifierList[ModifierList.Length - 1] = Modifier;
    UpdateModifier();
}

final function RemoveModifier(string ID)
{
    local int Index;
    for (Index = ModifierList.Length - 1; Index >= 0; Index--)
    {
        if (ModifierList[Index].ID == ID)
        {
            log(ModifierStackID$": Removing modifier applied by"@ID@".", 'KFTurboCardGame');
            ModifierList.Remove(Index, 1);
            UpdateModifier();
            return;
        }
    }
}

final function ClearModifiers()
{
    ModifierList.Length = 0;
    UpdateModifier();
}

final function UpdateModifier()
{
    local int Index;
    CachedModifier = default.CachedModifier;
    for (Index = ModifierList.Length - 1; Index >= 0; Index--)
    {
        CachedModifier *= ModifierList[Index].Modifier;
    }

    log(ModifierStackID$": New modifier value is"@CachedModifier@".", 'KFTurboCardGame');
    OnModifierChanged(Self, CachedModifier);
}

defaultproperties
{
    CachedModifier = 1.f
}