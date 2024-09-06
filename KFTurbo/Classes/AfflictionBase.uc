//Killing Floor Turbo AfflictionBase
//Base class for afflictions. Not replicated. Instanced per zed.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class AfflictionBase extends Object
	instanced
	abstract;

var KFMonster OwningMonster;
var float CachedMovementSpeedModifier;

simulated function Initialize(KFMonster Monster)
{
	OwningMonster = Monster;
}

simulated function OnDeath()
{
	OwningMonster = None;
}

simulated function PreTick(float DeltaTime)
{

}

simulated function Tick(float DeltaTime)
{

}

simulated function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, int HitIndex)
{

}

simulated final function float GetMovementSpeedModifier()
{
	return CachedMovementSpeedModifier;
}

defaultproperties
{
	CachedMovementSpeedModifier=1.f
}