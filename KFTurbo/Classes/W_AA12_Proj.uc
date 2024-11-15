class W_AA12_Proj extends AA12Bullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local float PreviousDamage;
    PreviousDamage = Damage;
    Super.ProcessTouch(Other, HitLocation);
    class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
     HeadShotDamageMult=1.640000
}
