class W_KSG_Proj extends KSGBullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
     local float PreviousDamage;
     PreviousDamage = Damage;
     Super.ProcessTouch(Other, HitLocation);
     class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
     Damage=20.000000
}
