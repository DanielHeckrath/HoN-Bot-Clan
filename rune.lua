local _G = getfenv(0)
local object = _G.object

local core, eventsLib, behaviorLib, metadata, skills = object.core, object.eventsLib, object.behaviorLib, object.metadata, object.skills

local print, ipairs, pairs, string, table, next, type, tinsert, tremove, tsort, format, tostring, tonumber, strfind, strsub
	= _G.print, _G.ipairs, _G.pairs, _G.string, _G.table, _G.next, _G.type, _G.table.insert, _G.table.remove, _G.table.sort, _G.string.format, _G.tostring, _G.tonumber, _G.string.find, _G.string.sub
local ceil, floor, pi, tan, atan, atan2, abs, cos, sin, acos, max, random
	= _G.math.ceil, _G.math.floor, _G.math.pi, _G.math.tan, _G.math.atan, _G.math.atan2, _G.math.abs, _G.math.cos, _G.math.sin, _G.math.acos, _G.math.max, _G.math.random

local BotEcho, VerboseLog, BotLog = core.BotEcho, core.VerboseLog, core.BotLog
local Clamp = core.Clamp

object.runelib = {}
local runelib = object.runelib

local nextSpawnCheck = 120000 --2min mark
local nextCheck = 120000

local RUNE_UNIT_MASK = core.UNIT_MASK_POWERUP + core.UNIT_MASK_ALIVE


--todo add types expect "gereatter" and "lesser" rune so bot can go for better rune if it have vision
local runes = {
	{location = Vector3.Create(5824, 9728), unit=nil, picked = true},
	{location = Vector3.Create(11136, 5376), unit=nil, picked = true}
}

local runeNames = {"Powerup_Damage", "Powerup_Illusion", "Powerup_Stealth", "Powerup_Refresh", "Powerup_Regen", "Powerup_MoveSpeed", "Powerup_Super"}

function object:runeLibOnthinkOverride(tGameVariables)
	self:runeLibOnthinkOld(tGameVariables)-- old think

	time = HoN.GetMatchTime()
	if time and time > nextSpawnCheck then
		nextSpawnCheck = nextSpawnCheck + 120000
		for _,rune in pairs(runes) do
			--something spawned
			rune.picked = false
			rune.unit = nil
		end
		runelib.checkRunes()
	end
	if time and time > nextCheck then
		nextCheck = nextCheck + 1000
		runelib.checkRunes()
	end

end
object.runeLibOnthinkOld = object.onthink
object.onthink 	= object.runeLibOnthinkOverride

function runelib.checkRunes()
	for _,rune in pairs(runes) do
		if HoN.CanSeePosition(rune.location) then
			units = HoN.GetUnitsInRadius(rune.location, 50, RUNE_UNIT_MASK)
			local runeFound = false
			for _,unit in pairs(units) do
				if table.contains(runeNames, unit:GetTypeName()) then
					runeFound = true
					rune.unit = unit
					break
				end
			end
			if not runeFound then
				rune.unit = nil
				rune.picked = true
			end
		end
	end
end

function runelib.GetNearestRune(pos, certain)
	--we want to be sure there is rune
	certain = certain or false

	local mypos = core.unitSelf:GetPosition()

	local nearestRune = nil
	local shortestDistanceSQ = 99999999
	for _,rune in pairs(runes) do
		if not certain or rune.unit ~= nil then
			local distance = Vector3.Distance2DSq(rune.location, mypos)
			if not rune.picked and distance < shortestDistanceSQ then
				nearestRune = rune
				shortestDistanceSQ = distance
			end
		end
	end
	return nearestRune
end

function runelib.pickRune(botBrain, rune)
	if rune == nil or rune.location == nil or rune.picked then
		return false
	end
	if not HoN.CanSeePosition(rune.location) or rune.unit == nil then
		return behaviorLib.MoveExecute(botBrain, rune.location)
	else
		return core.OrderTouch(botBrain, core.unitSelf, rune.unit)
	end
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end