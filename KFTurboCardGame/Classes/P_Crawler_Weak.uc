class P_Crawler_Weak extends P_Crawler_STA;

simulated function PostBeginPlay()
{
     Super.PostBeginPlay();

     SetBoneScale(10, 0.66f, RootBone);
}

defaultproperties
{
     HealthMax=35.000000
     Health=35
     HeadHealth=25.000000
     HeadHeight=2.500000
     HeadScale=1.000000
     HeadRadius=5.500000
     PrePivot=(Z=-2.000000)
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}