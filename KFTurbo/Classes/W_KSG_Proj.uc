class W_KSG_Proj extends W_BaseShotgunBullet;

function PreBeginPlay()
{
    local W_KSG_Fire WeaponFire;
    WeaponFire = W_KSG_Fire(GetWeaponFire());

    if (WeaponFire != None)
    {
        FireModeHitRegisterCount = WeaponFire.FireEffectCount;
    }

    Super.PreBeginPlay();
}

function NotifyProjectileRegisterHit(TurboPlayerEventHandler.MonsterHitData HitData)
{
    local W_KSG_Fire WeaponFire;
    WeaponFire = W_KSG_Fire(GetWeaponFire());

    if (WeaponFire == None)
    {
        return;
    }

    RegisterHit(WeaponFire.HitRegistryList, HitData);
}

defaultproperties
{
     PenDamageReduction=0.750000
     
     Damage=20.000000
     MyDamageType=Class'KFMod.DamTypeKSGShotgun'
}
