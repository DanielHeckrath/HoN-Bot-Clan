local _G = getfenv(0)

require('/bots/Libraries/LibHeroData/Classes/HeroInfo.class.lua');
require('/bots/Libraries/LibHeroData/Classes/AbilityInfo.class.lua');

local classes = _G.HoNBots.Classes;
local HeroInfo, AbilityInfo = classes.HeroInfo, classes.AbilityInfo;

-- HeroNameInGame
local hero = HeroInfo.Create('Hero_TYPENAME');
hero.Threat = 2;

do -- FirstAbilityNameInGame
	local abil = AbilityInfo.Create(3, 'Ability_TYPENAME4');
	abil.Threat = 0;
	abil.TargetType = 'Passive,Self,AutoCast,TargetUnit,TargetPosition,TargetVector,VectorEntity';
	abil.CastEffectType = 'Magic,Physical,SuperiorMagic,SuperiorPhysical';
	-- Below are all the possible properties, scroll further down for comments explaining all of them.
	-- Remove any properties that should stay default. Below values are NOT the default values, they're likely values to make copy pasting easier.
	-- (remove this comment block when copy-pasting)
	abil.VectorEntityTarget = 'Hero';
	abil.CanCastOnSelf = true;
	abil.CanCastOnFriendlies = true;
	abil.CanCastOnHostiles = true;
	abil.ChannelingState = 'State_Hero_Ability_SelfCast';
	abil.CanStun = true;
	abil.CanInterrupt = true;
	abil.CanInterruptMagicImmune = true;
	abil.CanSlow = true;
	abil.CanRoot = true;
	abil.CanDisarm = true;
	abil.CanTurnInvisible = true;
	abil.CanReveal = true;
	abil.CanDispositionSelf = true;
	abil.CanDispositionFriendlies = true;
	abil.CanDispositionHostiles = true;
	abil.StunDuration = 1000;
	abil.ShouldSpread = true;
	abil.ShouldInterrupt = true;
	abil.ShouldBreakFree = true;
	abil.ShouldPort = true;
	abil.ShouldAvoidDamage = true;
	abil.ShouldRemoveNullStone = true;
	abil.MagicDamage = { 120, 140, 160, 180 };
	abil.MagicDPS = { 4, 8, 16, 24 };
	abil.PhysicalDamage = { 210, 250, 300, 350 };
	abil.PhysicalDPS = { 5, 10, 15, 20 };
	abil.Buff = 'State_Name_Here_Buff';
	abil.BuffDuration = 2000;
	abil.Debuff = 'State_Name_Here_Debuff';
	abil.DebuffDuration = 2000;
	hero:AddAbility(abil);
end

do -- SecondAbilityName
	local abil = AbilityInfo.Create(1, 'Ability_TYPENAME2');
	abil.Threat = 0;
	abil.TargetType = 'Self';
	abil.CanCastOnSelf = true;
	abil.CanCastOnFriendlies = true;
	hero:AddAbility(abil);
end

do -- ThirdAbilityName
	local abil = AbilityInfo.Create(2, 'Ability_TYPENAME3');
	abil.Threat = 0; -- The threat for this ability is automatically calculated by the DPS threat
	abil.TargetType = 'Passive';
	abil.Buff = 'State_Arachna_Ability3';
	hero:AddAbility(abil);
end

do -- UltimateName
	local abil = AbilityInfo.Create(3, 'Ability_TYPENAME4');
	abil.Threat = 2;
	abil.TargetType = 'TargetUnit';
	abil.CastEffectType = 'Physical';
	abil.CanCastOnHostiles = true;
	abil.ShouldPort = true;
	abil.PhysicalDPS = { 75, 150, 225 }; -- total damage / 5 seconds
	abil.Debuff = 'State_Arachna_Ability4';
	abil.DebuffDuration = 5000; -- assume 5 seconds, may be longer
	hero:AddAbility(abil);
end

-- Because runfile doesn't return the return value of an executed file, we have to use this workaround:
_G.HoNBots = _G.HoNBots or {};
_G.HoNBots.LibHeroData = _G.HoNBots.LibHeroData or {};
_G.HoNBots.LibHeroData[hero:GetTypeName()] = hero;

-- It would be prettier if we could just get the return value from runfile;
return hero;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!REMOVE EVERYTHING FROM THIS LINE AND BELOW FROM ACTUAL HEROINFO FILES!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Don't copy the comments for the abilities, they should only exist in the AbilityInfo class and in this template.
-- You can always look at existing hero info files for examples.
-- The sum threat of a hero + abilities should generally always be 6. There are a few exceptions to this rule, such as Armadon (5 - increases per stack of spine burst), Behemoth (7 - only with ult) and Tempest (10 - only with ult).

-----------------------------------------------------------------------------------------------------------------------------------------
-- Required properties: these should be set in every ability instance.
-----------------------------------------------------------------------------------------------------------------------------------------

-- The threat of the ability. Only one value allowed. Only applied when the ability is off cooldown. For passive abilities add threat to the hero. Keep in mind that any abilities that increase the visual DPS of the hero will automatically increase threat too.
abil.Threat = 0;
-- The targeting type of the ability. Only one value allowed. May be used to automatically determine how an ability should be cast.
-- Passive (also for "Toggle Aura" abilities like SR's Withering Presence), Self (also for "Self Position" abilities like Keeper's Root), AutoCast, TargetUnit, TargetPosition, TargetVector, VectorEntity
abil.TargetType = '';

-- The below value isn't really required: it should be filled if the casteffecttype in the ability.entity file for the abiltiy has been filled. If not then you can skip setting this property. (it's not listed as an optional property since it doesn't share those traits)
-- You can also provide a table with multiple values, e.g. Tundra's Piercing Shards which is both superior magic and superior physical would be { 'SuperiorMagic', 'SuperiorPhysical' }.
-- You should ignore any cast effect types not listed below (e.g. Push, Attack, Transfigure, etc.). If none of the below types are found then you can remove the entire property.
abil.CastEffectType = ''; -- Magic, Physical, SuperiorMagic, SuperiorPhysical 

-----------------------------------------------------------------------------------------------------------------------------------------
-- Optional properties
-- Most of these properties may also be tables containing different values per level, e.g. abil.CanStun = { false, false, false, true }
-----------------------------------------------------------------------------------------------------------------------------------------

-- If the TargetType is VectorEntity this should specify what kind of target is optimal (e.g. for Grinex this would be a table: { 'Hero', 'Cliff', 'Tree', 'Building' }, for Rally this is 'Hero').
-- Possible values: Hero, Cliff, Tree, Building or a combination of them. This does NOT hold different values per levels if a table is provided, but instead holds all possible targets.
abil.VectorEntityTarget = nil;

-- Whether the ability can only be cast on self. Things like Scout's Vanish or Accursed's ult count as such.
abil.CanCastOnSelf = true;
-- Whether the ability can be used on friendly heroes.
abil.CanCastOnFriendlies = true;
-- Whether the ability can be used on hostile heroes. Should not be used for auras such as Accursed's Sear.
abil.CanCastOnHostiles = true;

-- The state that is applied to the hero that is channeling this ability. Only required for abilities that need to be channeled. Not all abilities have a state applied to the hero channeling the ability.
abil.ChannelingState = 'State_Hero_Ability_SelfCast';

-- Whether the ability can stun.
abil.CanStun = true;
-- Whether the ability can interrupt anyone.
abil.CanInterrupt = true;
-- Wether the ability can interrupt someone that is magic immune (physical interrupt).
abil.CanInterruptMagicImmune = true;
-- Whether the ability can slow.
abil.CanSlow = true;
-- Whether the ability can root.
abil.CanRoot = true;
-- Whether the ability can disarm.
abil.CanDisarm = true;
-- Whether the ability can make a hero invisible.
abil.CanTurnInvisible = true;
-- Whether the ability would reveal invisible targets.
abil.CanReveal = true;
-- Whether the ability can change the position of your own hero. e.g. Andro swap, Magebane Blink, Chronos Time Leap, Pharaoh ult, DR ult
abil.CanDispositionSelf = true;
-- Whether the ability can change the position of a friendly hero. e.g. Andro swap, devo hook
abil.CanDispositionFriendlies = true;
-- Whether the ability can change the position of a hostile hero. e.g. Andro swap, devo hook, prisoner ball and chain
abil.CanDispositionHostiles = true;

-- The duration of a stun.
abil.StunDuration = 1000; -- MS

-- Whether the bot may want to spread (e.g. Ult from Tempest).
abil.ShouldSpread = true;
-- Whether the bot may want to try to interrupt this ability (e.g. Ult from Tempest).
-- If you need to think about this for longer then a second then this should generally be true.
abil.ShouldInterrupt = true;
-- Whether the bot may want to break free from an ability (e.g. Root from Keeper).
abil.ShouldBreakFree = true;
-- Whether the bot may want to port out (e.g. Ult from Arachna or Blood Hunter).
abil.ShouldPort = true;
-- Whether the bot should avoid damage (e.g. Cursed Ground).
abil.ShouldAvoidDamage = true;
-- Whether the bot should remove a target's null stone effect with this ability (e.g. Armadon's Snot (Q) or Deadwood's Uproot (W)).
abil.ShouldRemoveNullStone = true;

-- A negative value is considered a percentage.
-- Can also provide a function to calculate the damage (first parameter passed must be ability level, second must be the unit affected)
-- The amount of INSTANT magic damage this does.
abil.MagicDamage = 0;
-- The amount of magic damage PER SECOND this does.
abil.MagicDPS = 0;
-- The amount of INSTANT physical damage this does.
abil.PhysicalDamage = 0;
-- The amount of physical damage PER SECOND this does.
abil.PhysicalDPS = 0;

-- Buff/Debuff properties do NOT hold buffs per level, but instead all possible buffs. Some alts have different state names that do the exact same.
-- What buff the caster gains.
abil.Buff = 'State_Name_Here_Buff'; -- e.g. abil.Buff = 'State_Aluna_Ability4'
-- For how long the caster gains this buff.
abil.BuffDuration = 2000;
-- What debuff the target gets.
abil.Debuff = 'State_Name_Here_Debuff'; -- e.g. abil.Debuff = 'State_Andromeda_Ability2'
-- The duration of said debuff.
abil.DebuffDuration = 2000;

