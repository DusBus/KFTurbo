class W_Trenchgun_Proj extends TrenchgunBullet;

var int FireModeHitRegisterCount; //HitRegisterCount associated with this projectile.

final function Controller GetWeaponController()
{
    local Weapon OwnerWeapon;
    OwnerWeapon = Weapon(Owner);
    if (OwnerWeapon != None && OwnerWeapon.Instigator != None)
    {
        return OwnerWeapon.Instigator.Controller;
    }

    return None;
}

//We assume index 0.
final function BaseProjectileFire GetWeaponFire()
{
    local Weapon OwnerWeapon;
    OwnerWeapon = Weapon(Owner);
    if (OwnerWeapon != None)
    {
        return BaseProjectileFire(OwnerWeapon.GetFireMode(0));
    }

    return None;
}

final function RegisterHit(out array<W_BaseShotgunBullet.HitRegisterEntry> HitRegisterList, bool bIsHeadshot, int DamageDealt)
{
    local int Index;

    for (Index = HitRegisterList.Length - 1; Index >= 0; Index--)
    {
        if (HitRegisterList[Index].HitRegisterCount == FireModeHitRegisterCount)
        {
            HitRegisterList.Remove(Index, 1);
            class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(GetWeaponController(), GetWeaponFire(), bIsHeadshot, DamageDealt);
            continue;
        }

        //Cleanup hit registers that have expired.
        if (HitRegisterList[Index].Expiration < Level.TimeSeconds)
        {
            HitRegisterList.Remove(Index, 1);
        }
    }
}

function NotifyProjectileRegisterHit(bool bIsHeadshot, int DamageDealt)
{
    local W_Trenchgun_Fire WeaponFire;
    WeaponFire = W_Trenchgun_Fire(GetWeaponFire());

    if (WeaponFire == None)
    {
        return;
    }

    RegisterHit(WeaponFire.HitRegistryList, bIsHeadshot, DamageDealt);
}

function PreBeginPlay()
{
    local W_Trenchgun_Fire WeaponFire;
    WeaponFire = W_Trenchgun_Fire(GetWeaponFire());

    if (WeaponFire != None)
    {
        FireModeHitRegisterCount = WeaponFire.FireEffectCount;
    }

    Super.PreBeginPlay();
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
     local vector X;
     local Vector TempHitLocation, HitNormal;
     local array<int> HitPoints;
     local KFPawn HitPawn;

     local KFMonster Monster;
     local bool bIsHeadshot;
     local int DamageDealt;

     if (Other == None || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces)
     {
          return;
     }

     X = Vector(Rotation);

     if (ROBulletWhipAttachment(Other) != None)
     {
          if (!Other.Base.bDeleteMe)
          {
               Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

               if (Other == none || HitPoints.Length == 0)
               {
                    return;
               }

               HitPawn = KFPawn(Other);

               if (Role == ROLE_Authority && HitPawn != None && !HitPawn.bDeleteMe)
               {
                    HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, HitPoints);
               }
          }
     }
     else
     {
          Monster = KFMonster(Other);
          if (Monster == None)
          {
               Monster = KFMonster(Other.Base);
          }

          if (Monster != None)
          {
               bIsHeadshot = Monster.IsHeadShot(HitLocation, Normal(Velocity), 1.f);
               DamageDealt = Monster.Health;
          }

          //Just pass it through. It's likely a pawn or an extended z collision.
          Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);


          //If damage was applied and we're doing less than our default, assume it's a penetrated hit.
          if (Monster != None)
          {
               DamageDealt -= Monster.Health;

               if (Damage >= default.Damage && DamageDealt > 0)
               {
                    NotifyProjectileRegisterHit(bIsHeadshot, DamageDealt);
               }
          }
     }

     if (KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None)
     {
          PenDamageReduction = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.static.GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), default.PenDamageReduction);
     }
     else
     {
          PenDamageReduction = default.PenDamageReduction;
     }

     Damage *= PenDamageReduction;

     if ((Damage / default.Damage) <= (PenDamageReduction / MaxPenetrations))
     {
          Destroy();
     }

     Speed = VSize(Velocity);

     if (Speed < (default.Speed * 0.25f))
     {
          Destroy();
     }
}

defaultproperties
{
     PenDamageReduction=0.650000
     HeadShotDamageMult=1.000000

     Damage=18.000000
     MyDamageType=Class'W_Trenchgun_DT'
}