//Killing Floor Turbo TurboCardDeck_Good
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardDeck_Good extends TurboCardDeck;

function ActivateBonusCashKill(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyCashBonus(1.1f);
}

function ActivateFirerateIncrease(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponFireRate(1.05f);
}

function ActivateDiscountedGrenades(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyGrenadeTraderPriceMultiplier(0.1f);
}

function ActivateExplosiveDamage(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyExplosiveDamage(1.05f);
}

function ActivateExplosiveRange(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyExplosiveRadius(1.1f);
}

function ActivateFreeArmor(TurboCardReplicationInfo CGRI)
{
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'FreeArmorWaveEventHandler');
    class'FreeArmorWaveEventHandler'.static.OnWaveStarted(KFTurboGameType(CGRI.Level.Game), KFTurboGameType(CGRI.Level.Game).WaveNum);
}

function ActivateIncreaseSelectableCards(TurboCardReplicationInfo CGRI)
{
    CGRI.IncreaseSelectionCount();
}

function ActivateMaxAmmo(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponMaxAmmo(1.1f);
}

function ActivateReloadSpeed(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponReloadRate(1.05f);
}

function ActivateSlomoDamageBonus(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifySlomoDamage(1.1f);
}

function ActivateThorns(TurboCardReplicationInfo CGRI)
{
    CGRI.GrantThorns(1.1f);
}

function ActivateTraderDiscount(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyTraderPriceMultiplier(0.9f);
}

function ActivateTraderGrenadeDiscount(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyGrenadeTraderPriceMultiplier(0.5f);
}

function ActivateTrashHeadshotDamage(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyTrashHeadshotDamage(1.15f);
}

function ActivateFastAmmoRespawn(TurboCardReplicationInfo CGRI)
{
    local KFAmmoPickup AmmoPickup;

    if (CGRI == None)
    {
        return;
    }

    foreach CGRI.AllActors(class'KFAmmoPickup', AmmoPickup)
    {
        AmmoPickup.RespawnTime *= 0.333f;
    }
}

function ActivateMagazineAmmoIncrease(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponMagazineAmmo(1.05f);
}

function ActivateSpreadAndRecoilDecrease(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponSpreadAndRecoil(0.9f);
}

function ActivateMonsterDamageDecrease(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyZombieMeleeDamage(1.05f);
}

function ActivateMoveSpeedIncrease(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerSpeed(1.05f);
}

function ActivateSlowerWave(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWaveSpeed(0.95f);
}

function ActivateShorterWave(TurboCardReplicationInfo CGRI)
{
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'ShorterWavesWaveSizeModifier');
    class'ShorterWavesWaveSizeModifier'.static.OnWaveStarted(KFTurboGameType(CGRI.Level.Game), KFTurboGameType(CGRI.Level.Game).WaveNum);
}

function ActivateDauntless(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerLowHealthDamageBonus(1.1f);
}

defaultproperties
{
    Begin Object Name=BonusCashKill Class=TurboCard_Good
        CardName(0)="Reward Inflation"
        CardDescriptionList(0)="All players receive"
        CardDescriptionList(1)="10% extra cash"
        CardDescriptionList(2)="from kills."
        OnActivateCard=ActivateBonusCashKill
    End Object
    DeckCardObjectList(0)=TurboCard'BonusCashKill'

    Begin Object Name=FirerateIncrease Class=TurboCard_Good
        CardName(0)="Trigger Finger"
        CardDescriptionList(0)="Increases"
        CardDescriptionList(1)="firerate of all"
        CardDescriptionList(2)="weapons by 5%."
        OnActivateCard=ActivateFirerateIncrease
    End Object
    DeckCardObjectList(1)=TurboCard'FirerateIncrease'

    Begin Object Name=ExplosiveDamage Class=TurboCard_Good
        CardName(0)="Higher Explosives"
        CardDescriptionList(0)="Explosives deal"
        CardDescriptionList(1)="5% more damage."
        OnActivateCard=ActivateExplosiveDamage
    End Object
    DeckCardObjectList(2)=TurboCard'ExplosiveDamage'

    Begin Object Name=ExplosiveRange Class=TurboCard_Good
        CardName(0)="Wider Explosives"
        CardDescriptionList(0)="Explosives have"
        CardDescriptionList(1)="10% larger range."
        OnActivateCard=ActivateExplosiveRange
    End Object
    DeckCardObjectList(3)=TurboCard'ExplosiveRange'

    Begin Object Name=FreeArmor Class=TurboCard_Good
        CardName(0)="Free Armor"
        CardDescriptionList(0)="All players"
        CardDescriptionList(1)="receive free"
        CardDescriptionList(2)="armor each wave."
        OnActivateCard=ActivateFreeArmor
    End Object
    DeckCardObjectList(4)=TurboCard'FreeArmor'

    Begin Object Name=MaxAmmo Class=TurboCard_Good
        CardName(0)="Deeper Bullet"
        CardName(1)="Pockets"
        CardDescriptionList(0)="Increase max"
        CardDescriptionList(1)="ammo for all"
        CardDescriptionList(2)="weapons by 10%."
        OnActivateCard=ActivateMaxAmmo
    End Object
    DeckCardObjectList(5)=TurboCard'MaxAmmo'

    Begin Object Name=ReloadSpeed Class=TurboCard_Good
        CardName(0)="Basic Hand"
        CardName(1)="Stretches"
        CardDescriptionList(0)="Increases reload"
        CardDescriptionList(1)="speed of all"
        CardDescriptionList(2)="weapons by 5%."
        OnActivateCard=ActivateReloadSpeed
    End Object
    DeckCardObjectList(6)=TurboCard'ReloadSpeed'

    Begin Object Name=SlomoDamageBonus Class=TurboCard_Good
        CardName(0)="Slow Motion"
        CardName(1)="Expertise"
        CardDescriptionList(0)="Deal 10% more"
        CardDescriptionList(1)="damage during"
        CardDescriptionList(2)="zed time."
        OnActivateCard=ActivateSlomoDamageBonus
    End Object
    DeckCardObjectList(7)=TurboCard'SlomoDamageBonus'

    Begin Object Name=Thorns Class=TurboCard_Good
        CardName(0)="Thorns"
        CardDescriptionList(0)="Relfect 10% of"
        CardDescriptionList(1)="received damage"
        CardDescriptionList(2)="back onto zeds."
        OnActivateCard=ActivateThorns
    End Object
    DeckCardObjectList(8)=TurboCard'Thorns'

    Begin Object Name=TraderDiscount Class=TurboCard_Good
        CardName(0)="Slight Discount"
        CardDescriptionList(0)="All ammo and"
        CardDescriptionList(1)="weapons receive"
        CardDescriptionList(2)="a 10% discount."
        OnActivateCard=ActivateTraderDiscount
    End Object
    DeckCardObjectList(9)=TurboCard'TraderDiscount'

    Begin Object Name=TraderGrenadeDiscount Class=TurboCard_Good
        CardName(0)="Grenade"
        CardName(1)="Clearance"
        CardDescriptionList(0)="Grenades receive"
        CardDescriptionList(1)="a 50% discount"
        CardDescriptionList(2)="at the trader."
        OnActivateCard=ActivateTraderGrenadeDiscount
    End Object
    DeckCardObjectList(10)=TurboCard'TraderGrenadeDiscount'

    Begin Object Name=TrashHeadshotDamage Class=TurboCard_Good
        CardName(0)="Trash Heads"
        CardDescriptionList(0)="Increases headshot"
        CardDescriptionList(1)="damage on non-elite"
        CardDescriptionList(2)="wave zeds by 15%."
        OnActivateCard=ActivateTrashHeadshotDamage
    End Object
    DeckCardObjectList(11)=TurboCard'TrashHeadshotDamage'

    Begin Object Name=FastAmmoRespawn Class=TurboCard_Good
        CardName(0)="Fast Ammo"
        CardName(1)="Respawn"
        CardDescriptionList(0)="Ammo pickups"
        CardDescriptionList(1)="respawn 200%"
        CardDescriptionList(2)="faster."
        OnActivateCard=ActivateFastAmmoRespawn
    End Object
    DeckCardObjectList(12)=TurboCard'FastAmmoRespawn'

    Begin Object Name=MagazineAmmoIncrease Class=TurboCard_Good
        CardName(0)="Stuffed"
        CardName(1)="Magazine"
        CardDescriptionList(0)="Increases weapon"
        CardDescriptionList(1)="magazine size by 5%."
        OnActivateCard=ActivateMagazineAmmoIncrease
    End Object
    DeckCardObjectList(13)=TurboCard'MagazineAmmoIncrease'

    Begin Object Name=SpreadAndRecoilDecrease Class=TurboCard_Good
        CardName(0)="Improved"
        CardName(1)="Focus"
        CardDescriptionList(0)="Decreases weapon"
        CardDescriptionList(1)="spread and"
        CardDescriptionList(2)="recoil by 10%."
        OnActivateCard=ActivateSpreadAndRecoilDecrease
    End Object
    DeckCardObjectList(14)=TurboCard'SpreadAndRecoilDecrease'

    Begin Object Name=MonsterDamageDecrease Class=TurboCard_Good
        CardName(0)="Thicker Skin"
        CardDescriptionList(0)="Decreases melee"
        CardDescriptionList(1)="damage taken from"
        CardDescriptionList(2)="monsters by 5%."
        OnActivateCard=ActivateMonsterDamageDecrease
    End Object
    DeckCardObjectList(15)=TurboCard'MonsterDamageDecrease'

    Begin Object Name=MoveSpeedIncrease Class=TurboCard_Good
        CardName(0)="Cardio Enjoyer"
        CardDescriptionList(0)="Increases player"
        CardDescriptionList(1)="move speed by 5%."
        OnActivateCard=ActivateMoveSpeedIncrease
    End Object
    DeckCardObjectList(16)=TurboCard'MoveSpeedIncrease'

    Begin Object Name=SlowerWave Class=TurboCard_Good
        CardName(0)="Relaxed Pace"
        CardDescriptionList(0)="Decreases wave"
        CardDescriptionList(1)="spawn rate by 5%."
        OnActivateCard=ActivateSlowerWave
    End Object
    DeckCardObjectList(17)=TurboCard'SlowerWave'

    Begin Object Name=ShorterWave Class=TurboCard_Good
        CardName(0)="Skimmed Waves"
        CardDescriptionList(0)="Decreases wave"
        CardDescriptionList(1)="size by 5%."
        OnActivateCard=ActivateShorterWave
    End Object
    DeckCardObjectList(18)=TurboCard'ShorterWave'

    Begin Object Name=Dauntless Class=TurboCard_Good
        CardName(0)="Dauntless"
        CardDescriptionList(0)="When below 50%"
        CardDescriptionList(1)="health players"
        CardDescriptionList(2)="deal 10% more"
        CardDescriptionList(3)="damage."
        OnActivateCard=ActivateDauntless
    End Object
    DeckCardObjectList(19)=TurboCard'Dauntless'
}