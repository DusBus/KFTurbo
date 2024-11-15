class W_BoomStick_Proj extends BoomStickBullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local float PreviousDamage;
    PreviousDamage = Damage;
    Super.ProcessTouch(Other, HitLocation);
    class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
    MyDamageType=Class'W_BoomStick_DT'
}
