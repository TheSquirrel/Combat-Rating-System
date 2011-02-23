-- Using Elo's Rating System...
-- How do we rank players?
-- When a player kills another player, we work out their expected score.
-- There are no ties in war so the real score can only be 0 (Loss) or 1 (Win).
-- TheSquirrel

local ArchiveRatings = {}
local CurrentRatings = {}

function FindKiller (VictimCharacter)
	local tag = VictimCharacter.Humanoid:FindFirstChild("creator")
	if (tag) then
		return tag.Value
	end
end

function PlayerDied (Player, Character)

	local Killer = FindKiller(Character)
	
	if (not Killer) then
		return -- No killer, probably a suicide. Not my place to rate suicides.
	end
	
	local KillerRating = CurrentRatings[Killer] or ArchiveRatings[Killer]
	if (not KillerRating) then
		return -- Weird. Can't find the the killer's rating. Just don't do amything.
	end
	
	local VictimRating = CurrentRatings[Player] or ArchiveRatings[Player]
	if (not VictimRating) then
		return -- Weird. Can't find the victim's rating. Just don't do anything.
	end
	
	KillerRating, VictimRating = Elo.Calculate(KillerRating, VictimRating, 1, 0) -- Killer won, victim lost. 1, 0.
	
	if (ArchiveRatings[Killer]) then
		ArchiveRatings[Killer] = KillerRating
	else
		CurrentRatings[Killer] = KillerRating
	end
	
	if (ArchiveRatings[Victim]) then
		ArchiveRatings[Victim] = VictimRating
	else
		ArchiveRatings[Victim] = VictimRating
	end
	
end


game.Players.PlayerAdded:connect(function (Player)
	Player.CharacterAdded:connect(function (Character)
		Character.Humanoid.Died:connect(function ()
			PlayerDied (Player, Character)
		end)
	end)
	repeat wait() until Player.DataReady
	local Rating = Player:LoadNumber("TheSquirrelRating")
	if (not Rating) then
		local Rating = 1400
		Player:SaveNumber("TheSquirrelRating", Rating)
	end
	CurrentRatings[Player] = Rating
end)

game.Players.PlayerRemoving:connect(function (Player)
	local Rating = CurrentRatings[Player]
	Player:SaveNumber("TheSquirrelRating", Rating)
	ArchiveRatings[Player] = Rating
	CurrentRatings[Player] = nil
end)

