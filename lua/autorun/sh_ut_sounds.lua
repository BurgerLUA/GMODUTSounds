AddCSLuaFile()

if SERVER then

	function UTInitalize( ply )
	
		ply.LastKill = 0
		ply.LastLimbHit = HITGROUP_GEAR
		ply.Spree = 0
		ply.MultiKillSpree = 0
		
		ply.XTAlpha = 0
		ply.HTAlpha = 0
		ply.KTAlpha = 0
		ply.STAlpha = 0
		ply.MTAlpha = 0
		
	end
	hook.Add( "PlayerSpawn", "UT Load Variables", UTInitalize )


	function UTCheckDamage( victim, hitgroup, dmginfo )
	
		victim.LastLimbHit = hitgroup
		
		return dmginfo
	end
	hook.Add("ScalePlayerDamage","UT Damage",UTCheckDamage)



	function UTSoundsDeath( victim, inflictor, attacker )
	
		UT_Humiliation(victim,attacker)
		
		if victim ~= attacker and attacker:IsPlayer() then
			UT_PlainKill(victim,attacker)
			UT_FirstBlood(victim,attacker)
			UT_HeadShot(victim,attacker)
			UT_KillingSprees(victim,attacker)
			UT_MultiKill(victim,attacker)
			UT_CheckComboBreaker(victim,attacker)
		end

		victim.Spree = 0
		
	end

	hook.Add("PlayerDeath","UT Player Death",UTSoundsDeath)
	
	function UT_PlainKill(victim,attacker)
		attacker:SetNWString("KTText",attacker:Nick() .. " killed " .. victim:Nick())
		attacker:SetNWEntity("KTEnt",attacker)
		attacker:SetNWEntity("KTEnt2",victim)
		attacker.KTAlpha = 255
		
		victim:SetNWString("KTText",attacker:Nick() .. " killed " .. victim:Nick())
		victim:SetNWEntity("KTEnt",attacker)
		victim:SetNWEntity("KTEnt2",victim)
		victim.KTAlpha = 255
	end

	
	function UT_MultiKill(victim,attacker)
	
		

		if attacker.LastKill + 5 > CurTime() then
			attacker.MultiKillSpree = attacker.MultiKillSpree + 1
		else
			attacker.MultiKillSpree = 1
		end
			
		if attacker.MultiKillSpree == 2 then
			attacker:SetNWString("MTText","Double Kill!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/doublekill.wav")]])
		elseif attacker.MultiKillSpree == 3 then
			attacker:SetNWString("MTText","Multi Kill!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/multikill.wav")]])
		elseif attacker.MultiKillSpree == 4 then
			attacker:SetNWString("MTText","Ultra Kill!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/ultrakill.wav")]])
		elseif attacker.MultiKillSpree == 5 then
			attacker:SetNWString("MTText","M O N S T E R  K I L L !!!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/monsterkill.wav")]])
		elseif attacker.MultiKillSpree == 6 then
			attacker:SetNWString("MTText","Ludicrous Kill!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/ludicrouskill.wav")	]])
		elseif attacker.MultiKillSpree > 6 then
			attacker:SetNWString("MTText","HOLY SHIT!")
			attacker:SetNWEntity("MTEnt",attacker)
			attacker.MTAlpha = 255
			attacker:SendLua([[LocalPlayer():EmitSound("ut/holyshit.wav")]])
		end
		
		attacker.LastKill = CurTime()
		
	end

	function UT_Humiliation(victim,attacker)
		if attacker == victim then
			--UTMessage("HUMILIATION")
			--victim.Spree = 0
		return end
	end

	function UT_FirstBlood(victim,attacker)
		if firstblood then
			
			for k,v in pairs(player.GetAll()) do
				v:SetNWString("XTText",attacker:Nick() .. " drew first blood!")	
				v:SetNWEntity("XTEnt",attacker)
				v.XTAlpha = 255
			end
			
			attacker:SendLua([[LocalPlayer():EmitSound("ut/firstblood.wav")]])

			firstblood = false
		end
	end
	
	function UT_CheckComboBreaker(victim,attacker)
		if victim.Spree >= 5 then
		
			for k,v in pairs(player.GetAll()) do
				v:SetNWString("XTText",victim:Nick() .. "'s killing spree was ended by " .. attacker:Nick())
				v:SetNWEntity("XTEnt",attacker)
				v:SetNWEntity("XTEnt2",victim)
				v.XTAlpha = 255
			end
		
		
		end
	
	end
	
	
	
	

	function UT_HeadShot(victim,attacker)
	
		
	
		if victim.LastLimbHit == HITGROUP_HEAD then
			--UTMessage("HEADSHOT")
			
			attacker:SetNWString("HTText","Head Shot!!!")
			attacker:SetNWEntity("HTEnt",attacker)
			attacker.HTAlpha = 255
			

			attacker:SendLua([[LocalPlayer():EmitSound("ut/headshot.wav")]])
			
			
		end
	end

	function UT_KillingSprees(victim,attacker)
		
		
		
		if attacker:IsPlayer() then
			if attacker:Alive() then
				attacker.Spree = attacker.Spree + 1
			end
		end
		
		for k,v in pairs(player.GetAll()) do
		
			if attacker.Spree == 5 then
				v:SetNWString("STText",attacker:Nick() .. " is on a killing spree!")
				v:SetNWEntity("STEnt",attacker)
				v.STAlpha = 255
				
				if v == attacker then
					v:SendLua([[LocalPlayer():EmitSound("ut/killingspree.wav")]])
				end
				
			elseif attacker.Spree == 10 then
				v:SetNWString("STText",attacker:Nick() .. " is on a rampage!")
				v:SetNWEntity("STEnt",attacker)
				v.STAlpha = 255
				
				if v == attacker then
					v:SendLua([[LocalPlayer():EmitSound("ut/rampage.wav")]])
				end
				
				
			elseif attacker.Spree == 15 then
				v:SetNWString("STText",attacker:Nick() .. " is dominating!")
				v:SetNWEntity("STEnt",attacker)
				v.STAlpha = 255
				
				if v == attacker then
					v:SendLua([[LocalPlayer():EmitSound("ut/dominating.wav")]])
				end
				
				
			elseif attacker.Spree == 20 then
				v:SetNWString("STText",attacker:Nick() .. " is unstoppable!")
				v:SetNWEntity("STEnt",attacker)
				v.STAlpha = 255
				
				if v == attacker then
					v:SendLua([[LocalPlayer():EmitSound("ut/unstoppable.wav")]])
				end
				
				
			elseif attacker.Spree == 25 then
				v:SetNWString("STText",attacker:Nick() .. " is GODLIKE!!!")
				v:SetNWEntity("STEnt",attacker)
				v.STAlpha = 255
				
				if v == attacker then
					v:SendLua([[LocalPlayer():EmitSound("ut/godlike.wav")]])
				end
				
			end
		
		end
		
	end

	function UTSound(entity,sound)
		--for k,v in pairs(player.GetAll()) do 
			--entity:SendLua([[LocalPlayer():EmitSound(sound)]])
		--end
	end
	
	function UTAlphaThink()
	
		for k,v in pairs(player.GetAll()) do
		
			v.XTAlpha = math.max(v.XTAlpha - 1,0)
			v.HTAlpha = math.max(v.HTAlpha - 1,0)
			v.KTAlpha = math.max(v.KTAlpha - 1,0)
			v.STAlpha = math.max(v.STAlpha - 1,0)
			v.MTAlpha = math.max(v.MTAlpha - 1,0)
			
			v:SetNWInt("XTAlpha",v.XTAlpha)
			v:SetNWInt("HTAlpha",v.HTAlpha)
			v:SetNWInt("KTAlpha",v.KTAlpha)
			v:SetNWInt("STAlpha",v.STAlpha)
			v:SetNWInt("MTAlpha",v.MTAlpha)
		
		end
		
	end
	
	hook.Add("Think","UT Alpha Think",UTAlphaThink)
	
	
	
	
	
end

if CLIENT then

	surface.CreateFont( "UnrealTournamentTextSmall", {
		font = "Arial", 
		size = 36, 
		weight = 500, 
		blursize = 0, 
		scanlines = 0, 
		antialias = true, 
		underline = false, 
		italic = false, 
		strikeout = false, 
		symbol = false, 
		rotary = false, 
		shadow = false, 
		additive = false, 
		outline = false, 
	} )
	
	surface.CreateFont( "UnrealTournamentTextMedium", {
		font = "Arial", 
		size = 45, 
		weight = 500, 
		blursize = 0, 
		scanlines = 0, 
		antialias = true, 
		underline = false, 
		italic = false, 
		strikeout = false, 
		symbol = false, 
		rotary = false, 
		shadow = false, 
		additive = false, 
		outline = false, 
	} )
	
	surface.CreateFont( "UnrealTournamentTextLarge", {
		font = "Arial", 
		size = 50, 
		weight = 500, 
		blursize = 0, 
		scanlines = 0, 
		antialias = true, 
		underline = false, 
		italic = false, 
		strikeout = false, 
		symbol = false, 
		rotary = false, 
		shadow = false, 
		additive = false, 
		outline = false, 
	} )
	
	


	function UTRecieve()
	
		

		local XTText = LocalPlayer():GetNWString("XTText","Burger has ended Burger's Spree")
		local XTAlpha = LocalPlayer():GetNWFloat("XTAlpha",255)
		local XTEnt = LocalPlayer():GetNWEntity("XTEnt",LocalPlayer())
		
	
		local HTText
		local HTAlpha
		local HTEnt = LocalPlayer():GetNWEntity("HTEnt",LocalPlayer())
		
		if HTEnt == LocalPlayer() then
			--print("headshot")
			HTText = LocalPlayer():GetNWString("HTText","Headshot!!!")
			HTAlpha = LocalPlayer():GetNWFloat("HTAlpha",255)
			--print(HTAlpha)
		end

		
		local KTText = ""
		local KTAlpha
		local KTEnt = LocalPlayer():GetNWEntity("KTEnt",LocalPlayer())
		local KTEnt2 = LocalPlayer():GetNWEntity("KTEnt2",Entity(0))

		if KTEnt == LocalPlayer() or KTEnt2 == LocalPlayer() then
		
			KTAlpha = LocalPlayer():GetNWFloat("KTAlpha",255)
		
			if KTEnt == LocalPlayer() then -- You Killed Someone
				KTR = 0
				KTB = 255
				KTText = "You killed " .. KTEnt2:Nick()
			elseif KTEnt2 == LocalPlayer() then -- You Died"
				KTR = 255
				KTB = 0
				KTText = "You were killed by " .. KTEnt:Nick() .. "!!!"
			end
			
		end

		local STText = LocalPlayer():GetNWString("STText","Burger is on a killing spree!")
		local STAlpha = LocalPlayer():GetNWFloat("STAlpha",255)
		
		local MTText = ""
		local MTAlpha
		local MTEnt = LocalPlayer():GetNWEntity("MTEnt",LocalPlayer())
		
		if MTEnt == LocalPlayer() then
			MTText = LocalPlayer():GetNWString("MTText","M O N S T E R  K I L L !!!")
			MTAlpha = LocalPlayer():GetNWFloat("MTAlpha",255)
		end
		
		--print(KTAlpha)
		
		--if XTAlpha ~= 0 or HTAlpha == 250 or KTAlpha == 250 or STAlpha == 250 or MTAlpha == 250 then
			--print("Playing Sound...")
			--LocalPlayer():EmitSound(LocalPlayer():GetNWString("UTSound","ut/firstblood.wav"))
		--end
		
		
		

		local XTColor = Color(0,0,255,XTAlpha)
		local HTColor = Color(255,0,0,HTAlpha)
		local KTColor = Color(KTR,0,KTB,KTAlpha)
		local STColor = Color(255,0,0,STAlpha)
		local MTColor = Color(255,0,0,MTAlpha)
		
		

		local BaseY =  ScrH() * 0.15
		
		--Spreed End Text
		draw.DrawText( XTText , "UnrealTournamentTextSmall", ScrW() * 0.5, BaseY  - 72, XTColor, TEXT_ALIGN_CENTER )
		--Headshot Text
		draw.DrawText( HTText , "UnrealTournamentTextSmall", ScrW() * 0.5, BaseY  - 36, HTColor, TEXT_ALIGN_CENTER )
		--Killing Text
		draw.DrawText( KTText , "UnrealTournamentTextSmall", ScrW() * 0.5, BaseY, KTColor, TEXT_ALIGN_CENTER )
		-- Spree Text
		draw.DrawText( STText, "UnrealTournamentTextSmall", ScrW() * 0.5,BaseY + 36, STColor, TEXT_ALIGN_CENTER )
		-- Multi Text
		draw.DrawText( MTText, "UnrealTournamentTextLarge", ScrW() * 0.5, BaseY + 100, MTColor , TEXT_ALIGN_CENTER )
		
		
	end
		
	hook.Add("HUDPaint","UT Messages",UTRecieve)
end






