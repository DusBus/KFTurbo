class W_Frag_Weap extends Frag;

struct MeshDefinition
{
    var Mesh WeaponMesh;
    var int ArmUVIndex;
    var class<InventoryAttachment> AttachmentClass;
    //Potentially add material list here... kinda sucks if that's what's necessary though.
};

var class<Projectile> LastThrownGrenadeClass;
var class<KFSpeciesType> LastSpeciesTypeClass;
var MeshDefinition CurrentGrenadeDefinition;

var MeshDefinition DefaultGrenadeDefinition;
var MeshDefinition FirebugGrenadeDefinition;
var MeshDefinition BerserkerGrenadeDefinition;
var MeshDefinition MedicGrenadeDefinition;

simulated event StartThrow()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        PerformMeshUpdate();
    }

    Super.StartThrow();
}

//Updates grenade mesh and material.
simulated function PerformMeshUpdate()
{
    local Pawn Pawn;

    Pawn = Pawn(Owner);

    if (Pawn == None || !Pawn.IsLocallyControlled())
    {
        return;
    }

    if (!UpdateMeshDefinition())
    {
        UpdateSleeveTexture();
        return;
    }
    UpdateWeaponMesh();
    UpdateSleeveTexture();
}

simulated function bool UpdateMeshDefinition()
{
    local class<Projectile> NewDesiredProjectileClass;
    NewDesiredProjectileClass = FragFireFix(FireMode[0]).GetDesiredProjectileClass();
    if (LastThrownGrenadeClass == NewDesiredProjectileClass)
    {
        return false;
    }

    LastThrownGrenadeClass = NewDesiredProjectileClass;

    //Doesn't make any sense but handle it anyways.
    if (NewDesiredProjectileClass == None)
    {
        CurrentGrenadeDefinition = DefaultGrenadeDefinition;
        return true;
    }

    switch (NewDesiredProjectileClass)
    {
        case class'KFMod.Nade':
        case class'KFMod.FlameNade':
        case class'KFMod.MedicNade':
        case class'KFTurbo.V_Berserker_Grenade':
            CurrentGrenadeDefinition = DefaultGrenadeDefinition;
            break;
    }
    return true;
}

simulated function UpdateWeaponMesh()
{
    Skins.Length = 0; //Clear list.
    LinkMesh(CurrentGrenadeDefinition.WeaponMesh, true);
    //TODO: We don't have a nice way to figure out what the original mesh's materials were.
    //For now non-sleeve UVs will show null material.
}

simulated function UpdateSleeveTexture()
{
    local class<KFSpeciesType> NewSpeciesTypeClass;
 
    if (xPawn(Owner) == None)
    {
        return;
    }
 
    NewSpeciesTypeClass = class<KFSpeciesType>(xPawn(Owner).Species);
    if (LastSpeciesTypeClass == NewSpeciesTypeClass)
    {
        return;
    }

    LastSpeciesTypeClass = NewSpeciesTypeClass;

    if (CurrentGrenadeDefinition.ArmUVIndex != -1)
    {
        Skins[CurrentGrenadeDefinition.ArmUVIndex] = NewSpeciesTypeClass.static.GetSleeveTexture();
    }
}

defaultproperties
{
    LastThrownGrenadeClass = None
    LastSpeciesTypeClass = None
    DefaultGrenadeDefinition=(WeaponMesh=SkeletalMesh'KF_Weapons_Trip.Frag_Trip',ArmUVIndex=1,AttachmentClass=Class'KFMod.FragAttachment')

    //Might as well incorporate the frag fix while we're here.
    FireModeClass(0)=Class'FragFireFix'

    AttachmentClass=Class'KFMod.FragAttachment'
    Mesh=SkeletalMesh'KF_Weapons_Trip.Frag_Trip'
}
