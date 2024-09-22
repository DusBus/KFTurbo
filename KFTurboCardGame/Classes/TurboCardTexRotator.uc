//Killing Floor Turbo TurboCardTexRotator
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardTexRotator extends Engine.TexRotator;

//Initialize with specified amplitude multiplier and phase phase.
function Initialize(Material NewMaterial, float OscillationMultiplier, TurboHUDOverlay.Vector2D OscillationPhaseOffset)
{
    OscillationRate.Pitch = default.OscillationRate.Pitch * (1.f / OscillationMultiplier);
    OscillationRate.Yaw = default.OscillationRate.Yaw * (1.f / OscillationMultiplier);

    OscillationAmplitude.Pitch = default.OscillationAmplitude.Pitch * Abs(OscillationMultiplier);
    OscillationAmplitude.Yaw = default.OscillationAmplitude.Yaw * Abs(OscillationMultiplier);

    OscillationPhase.Pitch = OscillationPhaseOffset.X;
    OscillationPhase.Yaw = OscillationPhaseOffset.Y;

    Material = NewMaterial;
}

//Called when released to pool.
function Reset()
{
    Super.Reset();
    Material = None;
}

defaultproperties
{
    TexRotationType = TR_OscillatingRotation;

    UOffset=256.f
    VOffset=512.f

    OscillationRate=(Pitch=7000,Yaw=6000)
    OscillationAmplitude=(Pitch=80,Yaw=80)
}