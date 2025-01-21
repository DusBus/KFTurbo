class W_Dual9MM_Fire extends DualiesFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(Self);
    Super.DoFireEffect();
}

function DoTrace(Vector Start, Rotator Direction)
{
	class'WeaponHelper'.static.PenetratingWeaponTrace(Start, Direction, KFWeapon(Weapon), self, 0, 0.0);
}

defaultproperties
{
    
}
