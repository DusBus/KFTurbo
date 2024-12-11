class W_Magnum44_Fire extends Magnum44Fire;

function DoTrace(Vector Start, Rotator Direction)
{
	class'WeaponHelper'.static.PenetratingWeaponTrace(Start, Direction, KFWeapon(Weapon), self, 2, 0.9);
}

defaultproperties
{
     maxVerticalRecoilAngle=1250
     maxHorizontalRecoilAngle=250
     DamageType=Class'KFTurbo.W_Magnum44_DT'
     DamageMin=100
     DamageMax=120
     FireRate=0.150000
     Spread=0.008000
     MaxSpread=0.108000
     AmmoClass=class'W_Magnum44_Ammo'
}