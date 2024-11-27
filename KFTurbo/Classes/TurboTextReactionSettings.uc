//Killing Floor Turbo TurboTextReactionSettings
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboTextReactionSettings extends TextReactionSettings;

struct TextSoundMap
{
    var string Text;
    var string SoundRef;
    var Sound Sound;
    var float CooldownTime;
};

var array<TextSoundMap> TextSoundList;

static final function PlayLocalSound(TurboPlayerController PlayerController, Sound Sound)
{
    if (PlayerController.Pawn == None)
    {
        PlayerController.PlayOwnedSound(Sound, SLOT_None, 200.f,,,,false);
    }
    else if (PlayerController.Pawn.Weapon == None)
    {
        PlayerController.Pawn.PlayOwnedSound(Sound, SLOT_None, 200.f,,,,false);
    }
    else
    {
        PlayerController.Pawn.Weapon.PlayOwnedSound(Sound, SLOT_None, 200.f,,,,false);
    }
}

simulated function ReceivedMessage(TurboPlayerController PlayerController, string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int Index;
    
    if (PlayerController == None)
    {
        return;
    }

    for (Index = TextSoundList.Length - 1; Index >= 0; Index--)
    {
        if (InStr(M, TextSoundList[Index].Text) > 0)
        { 
            if (TextSoundList[Index].Sound == None)
            {
                TextSoundList[Index].Sound = Sound(DynamicLoadObject(TextSoundList[Index].SoundRef, class'Sound', true));
                if (TextSoundList[Index].Sound == None)
                {
                    return;
                }
            }

            if (TextSoundList[Index].CooldownTime > PlayerController.Level.TimeSeconds)
            {
                return;
            }

            TextSoundList[Index].CooldownTime = PlayerController.Level.TimeSeconds + TextSoundList[Index].Sound.Duration + 0.5f;
            PlayLocalSound(PlayerController, TextSoundList[Index].Sound);
            return;
        }
    }
}

defaultproperties
{
    TextSoundList(0)=(Text=":goosecooked:",SoundRef="KFTurbo.UI.goosecooked")
    TextSoundList(1)=(Text=":plink:",SoundRef="KFTurbo.UI.plink")
    TextSoundList(2)=(Text=":nervous:",SoundRef="KFTurbo.UI.NervousTerran")
    TextSoundList(3)=(Text=":peasant:",SoundRef="KFTurbo.UI.Peasant")
}