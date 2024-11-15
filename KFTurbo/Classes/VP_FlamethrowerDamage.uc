//Represents a user's vanilla stat value for this progress type.
class VP_FlamethrowerDamage extends SRCustomProgressInt;

//Hook into killing crawlers as a Firebug here and provide bonus EXP.
function NotifyPlayerKill( Pawn Killed, class<DamageType> damageType )
{
     if (RepLink == None ||  RepLink.StatObject == None || RepLink.OwnerPRI == None || RepLink.OwnerPRI.ClientVeteranSkill != class'V_Firebug')
     {
          return;
     }

     if (P_Crawler(Killed) == None)
     {
          return;
     }

     RepLink.StatObject.AddFlameThrowerDamage(Killed.HealthMax * 0.5f); //Bonus flamethrower damage.
}

defaultproperties
{
     ProgressName="Steam Flamethrower Damage"
}
