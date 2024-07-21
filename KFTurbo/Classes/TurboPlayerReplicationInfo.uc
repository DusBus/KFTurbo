class TurboPlayerReplicationInfo extends LinkedReplicationInfo;

var KFPlayerReplicationInfo OwningReplicationInfo;

struct MarkedActorInfo
{
    var Vector Location;

    var class<Actor> ActorClass;
    var class<Object> DataClass;
    var Object DataObject;

    var float MarkTime;
    var float MarkDuration;
};

var Actor MarkedActor;
var MarkedActorInfo MarkInfo;

enum EMarkColor{
	Invalid,
	Red,
	Green,
	Blue,
	Yellow,
	Purple,
    Cyan,
    Orange,
    Pink,
    Lime,
    White,
    Grey,
    Black
};

var EMarkColor MarkerColor;
var array<Color> MarkerColorList;

var class<Actor> LastReceivedActorClass;
var float LastReceivedMarkTime;

var String MarkDisplayString;
var float WorldZOffset;

var localized String PickupStringLeft;
var localized String PickupStringRight;

var localized String MonsterStringLeft;
var localized String MonsterStringRight;

var localized String PlayerStringLeft;
var localized String PlayerStringRight;

replication
{
    reliable if( bNetInitial && ROLE == ROLE_Authority)
        OwningReplicationInfo;
	reliable if( Role==ROLE_Authority )
		MarkedActor, MarkInfo, MarkerColor;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Disable('Tick');
}

simulated function PostNetReceive()
{
    Super.PostNetReceive();

    if (HasMarkUpdate())
    {
        OnReceivedMark();
    }
}

function UpdateMarkerColor(EMarkColor Color)
{
    MarkerColor = Color;
}

static function Color GetMarkerColor(EMarkColor Color)
{
    return default.MarkerColorList[Color];
}

function MarkActor(Actor Target)
{
    if (Target == None)
    {
        return;
    }
    
    if (!CanMarkActor(Target))
    {
        return;
    }

    if (MarkedActor == Target)
    {
        MarkInfo.MarkTime = Level.TimeSeconds;
        return;
    }

    ClearMarkedActor();

    MarkedActor = Target;
    MarkInfo.Location = Target.Location;

    MarkInfo.ActorClass = Target.Class;
    MarkInfo.DataClass = GetRelevantDataClass(Target);
    MarkInfo.DataObject = GetRelevantDataObject(Target);

    MarkInfo.MarkTime = Level.TimeSeconds;
    MarkInfo.MarkDuration = GetMarkDuration(Target);

    Enable('Tick');

    NetUpdateTime = Level.TimeSeconds - 2.f;

    if (Level.NetMode != NM_DedicatedServer)
    {
        PostNetReceive();
    }
}

function ClearMarkedActor()
{
    MarkedActor = None;
    MarkInfo.ActorClass = None;
    MarkInfo.DataClass = None;
    MarkInfo.MarkTime = -1;
    MarkInfo.MarkDuration = -1;

    MarkDisplayString = "";
    WorldZOffset = 0;

    Disable('Tick');
    
    NetUpdateTime = Level.TimeSeconds - 2.f;
}

function bool CanMarkActor(Actor TargetActor)
{
    if (TargetActor == None)
    {
        return false;
    }

    if (Pickup(TargetActor) != None)
    {
        return Pickup(TargetActor).InventoryType != None || Vest(TargetActor) != None;
    }

    if (Pawn(TargetActor) != None)
    {
        return Pawn(TargetActor).Health > 0;
    }

    return false;
}

function class<Object> GetRelevantDataClass(Actor TargetActor)
{
    if (Pickup(TargetActor) != None && Pickup(TargetActor).InventoryType != None)
    {
        return Pickup(TargetActor).InventoryType;
    }

    return TargetActor.Class;
}

function Object GetRelevantDataObject(Actor TargetActor)
{
    if (Pawn(TargetActor) != None && Pawn(TargetActor).PlayerReplicationInfo != None)
    {
        return Pawn(TargetActor).PlayerReplicationInfo;
    }

    return None;
}

function float GetMarkDuration(Actor TargetActor)
{
    return 5.f;
}

function bool HasMarkData()
{
    if (MarkedActor == None)
    {
        return false;
    }

    return true;
}

function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    if (!CanMarkActor(MarkedActor))
    {
        ClearMarkedActor();
        return;
    }
    
    MarkInfo.Location = MarkedActor.Location;
}

simulated function bool HasMarkUpdate()
{
    if (MarkInfo.ActorClass == LastReceivedActorClass && MarkInfo.MarkTime == LastReceivedMarkTime)
    {
        return false;
    }

    return true;
}

simulated function OnReceivedMark()
{
    if (MarkInfo.MarkTime == -1.f)
    {
        ClearMarkedActor();
    }

    MarkDisplayString = GenerateDisplayString();
    WorldZOffset = GetWorldZOffset();
}

simulated function String GenerateDisplayString()
{
    if (Pickup(MarkedActor) != None || class<Pickup>(MarkInfo.ActorClass) != None)
    {
        return GeneratePickupDisplayString(Pickup(MarkedActor), class<Pickup>(MarkInfo.ActorClass));
    }

    if (KFMonster(MarkedActor) != None || class<KFMonster>(MarkInfo.ActorClass) != None)
    {
        return GenerateMonsterDisplayString(KFMonster(MarkedActor), class<KFMonster>(MarkInfo.ActorClass));
    }

    if (KFHumanPawn(MarkedActor) != None || class<KFHumanPawn>(MarkInfo.ActorClass) != None)
    {
        if (KFPlayerReplicationInfo(MarkInfo.DataObject) != None)
        {
            return KFPlayerReplicationInfo(MarkInfo.DataObject).PlayerName;
        }
    }

    return "";
}

simulated function String GeneratePickupDisplayString(Pickup PickupActor, class<Pickup> PickupClass)
{
    //Leverage localized values.
    if (PickupActor != None)
    {
        if (Vest(MarkedActor) != None)
        {
            return PickupStringLeft$class'BuyableVest'.default.ItemName$PickupStringRight; //This text is "Combat armour".
        }
        else if (KFAmmoPickup(MarkedActor) != None)
        {
            return PickupStringLeft$GUILabel(class'GUIInvHeaderTabPanel'.default.Controls[1]).Caption$PickupStringRight; //This text is "ammo".
        }
    
        return PickupStringLeft$Pickup(MarkedActor).InventoryType.default.ItemName$PickupStringRight;
    }

    if (class<Vest>(PickupClass) != None)
    {
        return PickupStringLeft$class'BuyableVest'.default.ItemName$PickupStringRight; //This text is "Combat armour".
    }
    else if (class<KFAmmoPickup>(PickupClass) != None)
    {
        return PickupStringLeft$GUILabel(class'GUIInvHeaderTabPanel'.default.Controls[1]).Caption$PickupStringRight; //This text is "ammo".
    }

    return PickupStringLeft$class<Inventory>(MarkInfo.DataClass).default.ItemName$PickupStringRight;
}

simulated function String GenerateMonsterDisplayString(KFMonster Monster, class<KFMonster> MonsterClass)
{
    if (Monster != None)
    {
        return MonsterStringLeft$Caps(Monster.MenuName)$MonsterStringRight;
    }
    
    return MonsterStringLeft$Caps(MonsterClass.default.MenuName)$MonsterStringRight;
}

simulated function float GetWorldZOffset()
{
    if (KFMonster(MarkedActor) != None || class<KFMonster>(MarkInfo.ActorClass) != None)
    {
        return GetMonsterZOffset(KFMonster(MarkedActor), class<KFMonster>(MarkInfo.ActorClass));
    }

    if (MarkedActor != None)
    {
        return MarkedActor.CollisionHeight;
    }

    if (MarkInfo.ActorClass != None)
    {
        return MarkInfo.ActorClass.default.CollisionHeight;
    }

    return 0.f;
}

simulated function float GetMonsterZOffset(KFMonster Monster, class<KFMonster> MonsterClass)
{
    if (Monster != None)
    {
        return Monster.CollisionRadius + Monster.ColHeight + (Monster.ColOffset.Z * 0.5f);
    }
    else if (MonsterClass != None)
    {
        return MonsterClass.default.CollisionRadius + MonsterClass.default.ColHeight + (MonsterClass.default.ColOffset.Z * 0.5f);
    }
    else
    {
        return 0.f;
    }
}

static function TurboPlayerReplicationInfo GetTurboPRI(PlayerReplicationInfo PRI)
{
    local LinkedReplicationInfo LRI;
    local TurboPlayerReplicationInfo TPRI;

    if (PRI == None)
    {
        return None;
    }

    for (LRI = PRI.CustomReplicationInfo; LRI != None; LRI = LRI.NextReplicationInfo)
    {
        if (TurboPlayerReplicationInfo(LRI) != None)
        {
            return TurboPlayerReplicationInfo(LRI);
        }
    }

    foreach PRI.DynamicActors(class'TurboPlayerReplicationInfo', TPRI)
    {
        if (TPRI.OwningReplicationInfo == PRI)
        {
            return TPRI;
        }
    }

    return None;
}

defaultproperties
{
    bAlwaysRelevant=true
    bNetNotify=true

    MonsterStringLeft="["
    MonsterStringRight="]"

    PickupStringLeft=""
    PickupStringRight=""

    MarkerColorList(0)=(R=255,G=255,B=255,A=255) //Invalid
    MarkerColorList(1)=(R=255,G=0,B=0,A=255) //Red
    MarkerColorList(2)=(R=0,G=255,B=0,A=255) //Green
    MarkerColorList(3)=(R=0,G=0,B=255,A=255) //Blue
    MarkerColorList(4)=(R=255,G=255,B=0,A=255) //Yellow
    MarkerColorList(5)=(R=100,G=0,B=200,A=255) //Purple
    MarkerColorList(6)=(R=0,G=255,B=255,A=255) //Cyan
    MarkerColorList(7)=(R=255,G=128,B=0,A=255) //Orange
    MarkerColorList(8)=(R=255,G=0,B=255,A=255) //Pink
    MarkerColorList(9)=(R=50,G=255,B=100,A=255) //Lime
    MarkerColorList(10)=(R=255,G=255,B=255,A=255) //White
    MarkerColorList(11)=(R=128,G=128,B=128,A=255) //Grey
    MarkerColorList(12)=(R=0,G=0,B=0,A=255) //Black
}