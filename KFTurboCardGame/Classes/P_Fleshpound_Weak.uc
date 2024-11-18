class P_Fleshpound_Weak extends P_Fleshpound_STA;

simulated function PostBeginPlay()
{
     Super.PostBeginPlay();

     SetBoneScale(10, 0.66f, RootBone);
}

defaultproperties
{
     ColOffset=(Z=40.000000)
     ColRadius=30.000000
     ColHeight=10.000000
     CollisionRadius=30.000000  
     CollisionHeight=40.000000
     MeleeRange=42.000000
     HeadHealth=350.000000
     HealthMax=750.000000
     Health=750
     HeadHeight=2.200000
     HeadScale=1.100000
     HeadRadius=5.500000
     PrePivot=(Z=-16.000000)
     MeleeDamage=17
}