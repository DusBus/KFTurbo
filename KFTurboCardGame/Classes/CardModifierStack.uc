//Killing Floor Turbo CardModifierStack
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardModifierStack extends Object
	instanced;

var array<CardModifier> ModifierList;
var float CachedModifier;

delegate OnModifierChanged(CardModifierStack ModifiedStack, float Modifier);

final function bool HasModifiers()
{
    return ModifierList.Length != 0;
}

final function AddModifier(CardModifier Modifier)
{
    if (Modifier == None)
    {
        return;
    }

    ModifierList.Length = ModifierList.Length + 1;
    ModifierList[ModifierList.Length - 1] = Modifier;
    UpdateModifier();
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

    OnModifierChanged(Self, CachedModifier);
}

defaultproperties
{
    CachedModifier = 1.f
}