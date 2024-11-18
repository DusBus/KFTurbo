//Killing Floor Turbo TurboTextReactionSettings
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboTextReactionSettings extends TextReactionSettings;

struct TextSoundMap
{
    var string Text;
    var string SoundRef;
    var Sound Sound;
};

var array<TextSoundMap> TextSoundList;

simulated function ReceivedMessage(TurboPlayerController PlayerController, string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int Index;
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

            PlayerController.PlayOwnedSound(TextSoundList[Index].Sound, SLOT_Talk, 200.f);
            return;
        }
    }
}

defaultproperties
{
    TextSoundList(0)=(Text=":goosecooked:",SoundRef="KFTurbo.UI.goosecooked")
}