//Killing Floor Turbo TurboCardClientModifierRepLink
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardClientModifierRepLink extends TurboClientModifierReplicationLink
    hidecategories(Advanced,Display,Events,Object,Sound);

var(Turbo) float MonsterHeadSizeModifier;
var(Turbo) float StalkerDistractionModifier;
var(Turbo) float GroundFrictionModifier, LastGroundFrictionModifier;

struct PhysicsVolumeEntry
{
    var PhysicsVolume Volume;
    var float OriginalGroundFriction;
};
var array<PhysicsVolumeEntry> PhysicsVolumeList;

//Where we will store bone scales.
enum EBoneScaleSlots
{
    Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten,
    Eleven, Twelve, Thirteen, Fourteen, Fifteen, Sixteen, Seventeen, Eighteen, Nineteen,
    SpecialL, SpecialR
};

replication
{
    reliable if(bNetDirty && Role == ROLE_Authority)
        StalkerDistractionModifier, MonsterHeadSizeModifier,
        GroundFrictionModifier;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    CollectAllPhysicsVolumes();
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    UpdatePhysicsVolumes();
}

simulated function PostNetReceive()
{
    Super.PostNetReceive();

    UpdatePhysicsVolumes();
}

simulated function CollectAllPhysicsVolumes()
{
	local PhysicsVolume Volume;
    LastGroundFrictionModifier = GroundFrictionModifier;

	foreach AllActors(class'PhysicsVolume', Volume)
	{
		PhysicsVolumeList.Length = PhysicsVolumeList.Length + 1;
        PhysicsVolumeList[PhysicsVolumeList.Length - 1].Volume = Volume;
        PhysicsVolumeList[PhysicsVolumeList.Length - 1].OriginalGroundFriction = Volume.GroundFriction;
        Volume.GroundFriction *= GroundFrictionModifier;
	}
}

simulated function UpdatePhysicsVolumes()
{
    local int Index;

    if (GroundFrictionModifier == LastGroundFrictionModifier)
    {
        return;
    }

    LastGroundFrictionModifier = GroundFrictionModifier;
    for (Index = PhysicsVolumeList.Length - 1; Index >= 0; Index--)
    {
        PhysicsVolumeList[Index].Volume.GroundFriction = PhysicsVolumeList[Index].OriginalGroundFriction * GroundFrictionModifier;
    }
}

simulated function ModifyMonster(KFMonster Monster) 
{
    if (Monster == None)
    {
        return;
    }

    Super.ModifyMonster(Monster);

    if (MonsterHeadSizeModifier != 1.f) 
    {
        ApplyHeadSizeModification(Monster);
    }

    if (P_Stalker(Monster) != None)
    {
        ModifyStalker(P_Stalker(Monster));
    }
}

simulated function ApplyHeadSizeModification(KFMonster Monster)
{
    local float ExtCollisionHeightScale, ExtCollisionRadiusScale;

    if (Monster.MyExtCollision.Role != ROLE_Authority && MonsterHeadSizeModifier > 1.f && Monster.MyExtCollision != None)
    {
        ExtCollisionHeightScale = ((MonsterHeadSizeModifier - 1.f) * 0.5f) + 1.f;
        ExtCollisionRadiusScale = ((MonsterHeadSizeModifier - 1.f) * 0.25f) + 1.f;
        Monster.MyExtCollision.SetCollisionSize(Monster.MyExtCollision.CollisionRadius * ExtCollisionRadiusScale, Monster.MyExtCollision.CollisionHeight * ExtCollisionHeightScale);
    }
}

simulated function ModifyStalker(P_Stalker Monster)
{
    if (StalkerDistractionModifier != 1.f)
    {
        Monster.SetBoneScale(EBoneScaleSlots.SpecialL, StalkerDistractionModifier, 'CHR_RibcageBoob_L');
        Monster.SetBoneScale(EBoneScaleSlots.SpecialR, StalkerDistractionModifier, 'CHR_RibcageBoob_R');
    }
}

defaultproperties
{
    bNetNotify=true

    MonsterHeadSizeModifier=1.f
    StalkerDistractionModifier=1.f

    GroundFrictionModifier=1.f
    LastGroundFrictionModifier=1.f
}