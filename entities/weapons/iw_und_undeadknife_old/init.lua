--[[-----------------------------------------------------------------------------
 * Infected Wars, an open source Garry's Mod game-mode.
 *
 * Infected Wars is the work of multiple authors,
 * a full list can be found in CONTRIBUTORS.md.
 * For more information, visit https://github.com/JarnoVgr/InfectedWars
 *
 * Infected Wars is free software: you can redistribute it and/or modify
 * it under the terms of the MIT License.
 *
 * A full copy of the MIT License can be found in LICENSE.txt.
 -----------------------------------------------------------------------------]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self.Weapon:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	self.Owner:LagCompensation(true)
	
	local trace = self.Owner:TraceLine(62)
	local ent = nil

	if trace.HitNonWorld then
		ent = trace.Entity
	end

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			self.Owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			self.Owner:EmitSound("weapons/knife/knife_hitwall1.wav")
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	end

	if ent and ent:IsValid() then
	    ent:TakeDamage(self.Primary.Damage, self.Owner)
	end

	if self.Alternate then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	end
	self.Alternate = not self.Alternate

	self.Owner:EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
end
