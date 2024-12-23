class W_Benelli_Proj extends W_BaseShotgunBullet;

function PreBeginPlay()
{
    local W_Benelli_Fire WeaponFire;
    WeaponFire = W_Benelli_Fire(GetWeaponFire());

    if (WeaponFire != None)
    {
        FireModeHitRegisterCount = WeaponFire.FireEffectCount;
    }

    Super.PreBeginPlay();
}

function NotifyProjectileRegisterHit(bool bIsHeadshot, int DamageDealt)
{
    local W_Benelli_Fire WeaponFire;
    WeaponFire = W_Benelli_Fire(GetWeaponFire());

    if (WeaponFire == None)
    {
        return;
    }

    RegisterHit(WeaponFire.HitRegistryList, bIsHeadshot, DamageDealt);
}

defaultproperties
{
    PenDamageReduction=0.750000
    MyDamageType=Class'KFMod.DamTypeBenelli'
}
