class W_Syringe_Weap extends KFMod.Syringe;

defaultproperties
{
    bCanThrow=false

	FireModeClass(0)=Class'KFTurbo.W_Syringe_Fire'
	FireModeClass(1)=Class'KFTurbo.W_Syringe_Fire_Alt'
	
	PickupClass=Class'KFTurbo.W_Syringe_Pickup'
}