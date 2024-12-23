class W_Chainsaw_Fire extends ChainsawFire;

var int FireEffectCount;

function DoFireEffect()
{
	if (++FireEffectCount >= 10) { class'WeaponHelper'.static.OnWeaponFire(self); FireEffectCount = 0; }
	Super.DoFireEffect();
}

defaultproperties
{

}
