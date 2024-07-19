class W_Magnum44_bigiron_Weap extends W_Magnum44_Weap;

simulated function PostBeginPlay()
{
     Super.PostBeginPlay();
     SetBoneScale(2, 2.0f, 'Revolver');
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurboRandomizer.W_Magnum44_bigiron_Fire'
     Weight=5.000000
     InventoryGroup=4
     ItemName="The Biggest Iron"
     PickupClass=Class'KFTurboRandomizer.W_Magnum44_bigiron_Pickup'
     AttachmentClass=Class'KFTurboRandomizer.W_Magnum44_bigiron_Attachment'
}