-- Rating players using the Elo Rating System for Chess Players
-- This script does all the Math stuff. Nothing here uses the Roblox API but allows for restrictions placed upon the standard API by Roblox.
-- TheSquirrel

--                1
-- Ea = -----------------------
--         1+10^((Rb-Ra)/400)
-- 
--                1
-- Eb = -----------------------
--         1+10^((Ra-Rb)/400)
-- 
-- Ra = Ra + K (Sa - Ea)
-- 
-- Rb = Rb + K(Sb - Eb)
-- 
-- 0 <= Score <= 1 
-- Normally 1 for a win, 0 for a loss or 0.5 for a draw.

local Elo = {}

function Elo.ExpectedScores (RatA, RatB)
	return 1 / (1 + 10 ^ ((RatB - RatA) / 400)), 1 / (1 + 10 ^ ((RatA - RatB) / 400))
end

function Elo.UpdateRating (Rat, Score, ExpScore)
	local K = 16
	
	if (Rat < 2100) then 		K = 32
	elseif (Rat < 2400) then 	K = 24
	else 						K = 16 end
	
	return math.floor(Rat + K * (Score - ExpScore))
end

function Elo.NewRating ()
	return 1400
end

function Elo.Calculate (RatA, RatB, ScoreA, ScoreB) -- Does the work. Just input the old ratings and the score. 1 for win, 0 for loss, 0.5 for draw.
	local ExpA, ExpB = Elo.ExpectedScores(RatA, RatB)
	return Elo.UpdateRating(RatA, ScoreA, ExpA), Elo.UpdateRating(RatB, ScoreB, ExpB)
end
