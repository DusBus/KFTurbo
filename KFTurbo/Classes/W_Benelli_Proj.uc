class W_Benelli_Proj extends BenelliBullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local float PreviousDamage;
    PreviousDamage = Damage;
    Super.ProcessTouch(Other, HitLocation);
    class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
     PenDamageReduction=0.750000
}
