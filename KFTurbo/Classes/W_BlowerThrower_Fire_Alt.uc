class W_BlowerThrower_Fire_Alt extends BlowerThrowerAltFire;

function DoFireEffect()
{
	class'WeaponHelper'.static.OnWeaponFire(self);
	Super.DoFireEffect();
}

defaultproperties
{

}
