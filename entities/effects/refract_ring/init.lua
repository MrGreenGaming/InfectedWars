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

local matRefraction	= Material( "refract_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Refract = 0
	
	self.Size = 32
	
	self.Entity:SetRenderBounds( Vector()*-512, Vector()*512 )
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	self.Refract = self.Refract + 3.0 * FrameTime()
	self.Size = 512 * self.Refract^(0.4)
	
	if ( self.Refract >= 2 ) then return false end
	
	return true
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	local MySelf = LocalPlayer()
	if ( self.Entity:GetPos():Distance( MySelf:GetPos() ) > 1200 ) then
		return
	end
	
	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + (EyePos()-self.Entity:GetPos()):GetNormal() * Distance * (self.Refract^(0.3)) * 0.8

	matRefraction:SetMaterialFloat( "$refractamount", self.Refract * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )

end
