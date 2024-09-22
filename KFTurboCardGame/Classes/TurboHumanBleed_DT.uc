//Killing Floor Turbo TurboHumanBleed_DT
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboHumanBleed_DT extends ZombieMeleeDamage;

defaultproperties
{
    bArmorStops=false
    bCheckForHeadShots=false
    HeadShotDamageMult=1.f
     
    HUDDamageTex=None
    HUDUberDamageTex=None
    HUDTime=0.f
     
    DeathString="%o bled to death."
    FemaleSuicide="%o bled to death."
    MaleSuicide="%o bled to death."
}
