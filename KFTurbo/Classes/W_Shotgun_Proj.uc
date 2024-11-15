class W_Shotgun_Proj extends ShotgunBullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
     local float PreviousDamage;
     PreviousDamage = Damage;
     Super.ProcessTouch(Other, HitLocation);
     class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
     Damage=31.000000
}
