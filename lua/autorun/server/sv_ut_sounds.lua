function UTInitalize( ply )
	ply.LastKill = 0
	ply.LastLimbHit = HITGROUP_GEAR
	ply.Spree = 0
	ply.MultiKillSpree = 0
end

hook.Add( "PlayerSpawn", "UT Load Variables", UTInitalize )


function UTCheckDamage( victim, hitgroup, dmginfo )

	victim.LastLimbHit = hitgroup
	
	return dmginfo
end

hook.Add("ScalePlayerDamage","UT Damage",UTCheckDamage)



function UTSoundsDeath( victim, inflictor, attacker )

	UT_FirstBlood()

	UT_Humiliation(victim,attacker)
	
	if victim ~= attacker and attacker:IsPlayer() then
	
		UT_HeadShot(victim,attacker)
		UT_KillingSprees(victim,attacker)
		UT_MultiKill(victim,attacker)
	
	end

	victim.Spree = 0
	
end

hook.Add("PlayerDeath","UT Player Death",UTSoundsDeath)

function UT_MultiKill(victim,attacker)

	if attacker.LastKill + 5 > CurTime() then
		attacker.MultiKillSpree = attacker.MultiKillSpree + 1
		--UTMessage("KEEP GOING")
	else
		attacker.MultiKillSpree = 1
		--UTMessage("TOO LATE")
	end
		
	if attacker.MultiKillSpree == 2 then
		UTMessage( string.upper(attacker:Nick()) .. " GOT A DOUBLE KILL")
		UTSound("ut/doublekill.wav")
	elseif attacker.MultiKillSpree == 3 then
		UTMessage( string.upper(attacker:Nick()) .. " GOT A MULTI KILL")
		UTSound("ut/multikill.wav")
	elseif attacker.MultiKillSpree == 4 then
		UTMessage( string.upper(attacker:Nick()) .. " GOT AN ULTRA KILL")
		UTSound("ut/ultrakill.wav")
	elseif attacker.MultiKillSpree == 5 then
		UTMessage( string.upper(attacker:Nick()) .. " GOT A MEGAKILL")
		UTSound("ut/megakill.wav")
	elseif attacker.MultiKillSpree == 6 then
		UTMessage( string.upper(attacker:Nick()) .. " GOT A MONSTERKILL")
		UTSound("ut/monsterkill.wav")
	end
	
	
	
	
	

	attacker.LastKill = CurTime()


end


function UT_Humiliation(victim,attacker)
	if attacker == victim then
		UTMessage("HUMILIATION")
		victim.Spree = 0
	return end
end

function UT_FirstBlood()
	if firstblood then
		UTMessage("FIRST BLOOD")
		UTSound("ut/firstblood.wav")
		firstblood = false
	end
end

function UT_HeadShot(victim,attacker)
	if victim.LastLimbHit == HITGROUP_HEAD then
		--UTMessage("HEADSHOT")
		UTSound("ut/headshot.wav")
	end
end

function UT_KillingSprees(victim,attacker)
	if attacker:IsPlayer() then
	
		if attacker:Alive() then
			attacker.Spree = attacker.Spree + 1
			--UTMessage(string.upper(attacker:Nick()) .. " IS ON KILL " .. attacker.Spree )
		end
		
	end
	
	if attacker.Spree == 5 then
		UTMessage( string.upper(attacker:Nick()) .. " IS ON A KILLING SPREE")
		UTSound("ut/killingspree.wav")
	elseif attacker.Spree == 10 then
		UTMessage( string.upper(attacker:Nick()) .. " IS ON A RAMPAGE")
		UTSound("ut/rampage.wav")
	elseif attacker.Spree == 15 then
		UTMessage( string.upper(attacker:Nick()) .. " IS DOMINATING")
		UTSound("ut/dominating.wav")
	elseif attacker.Spree == 20 then
		UTMessage( string.upper(attacker:Nick()) .. " IS UNSTOPPABLE")
		UTSound("ut/unstoppable.wav")
	elseif attacker.Spree == 25 then
		UTMessage( string.upper(attacker:Nick()) .. " IS GODLIKE")
		UTSound("ut/godlike.wav")
	end
	
end

function UTSound(sound)
	for k,v in pairs(player.GetAll()) do 
		v:EmitSound(sound)
	end
end

function UTMessage(message)

	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTCENTER, message )
	end
	
end







