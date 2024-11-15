class W_SPShotgun_Proj extends SPShotgunBullet;

var array<Pawn> HitPawnList;

event PreBeginPlay()
{
	Super.PreBeginPlay();

	class'WeaponHelper'.static.NotifyPostProjectileSpawned(self);
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	local float PreviousDamage;
	if (class'WeaponHelper'.static.AlreadyHitPawn(Other, HitPawnList))
	{
		return;
	}

	PreviousDamage = Damage;
	Super.ProcessTouch(Other, HitLocation);
	class'WeaponHelper'.static.OnShotgunProjectileHit(Self, Other, PreviousDamage);
}

defaultproperties
{
     MaxSpeed=2500.000000
     Damage=25.000000
}
