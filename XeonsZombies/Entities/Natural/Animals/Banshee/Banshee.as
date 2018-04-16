﻿

#include "BansheeScreech.as";

#include "CreatureCommon.as";
#include "Knocked.as";

const s32 TIME_TO_EXPLODE = 5 * 30;

const int COINS_ON_DEATH = 5;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("player", 0.8f, true, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("stone_door", 1.0f);
		infos.push_back(i);
	}
	{
		TargetInfo i("wooden_door", 0.9f);
		infos.push_back(i);
	}
	{
		TargetInfo i("building", 0.5f, true);
		infos.push_back(i);
	}

	this.set("target infos", infos);

	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);

    this.getSprite().PlaySound("BansheeSpawn.ogg");

    this.getSprite().SetEmitSound("BansheeFly.ogg");
    this.getSprite().SetEmitSoundPaused(false);
	this.getShape().SetRotationsAllowed(false);

	this.getBrain().server_SetActive(true);

	this.set_f32("gib health", 0.0f);
    this.Tag("flesh");

	// explosiveness
	this.set_f32("explosive_radius", 128.0f);
	this.set_f32("explosive_damage", 10.0f);
	this.set_string("custom_explosion_sound", "Entities/Items/Explosives/KegExplosion.ogg");
	this.set_f32("map_damage_radius", 96.0f);
	this.set_f32("map_damage_ratio", 0.4f);
	this.set_bool("map_damage_raycast", true);
	this.set_bool("explosive_teamkill", true);
	//

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CBlob@ this)
{
	if (this.hasTag("enraged"))
	{
		if(!this.exists("exploding"))
		{
			this.Tag("exploding");
		    this.set_s32("explosion_timer", getGameTime() + TIME_TO_EXPLODE);

            Screech(this);
		}

		if (getNet().isServer())
		{
        	s32 timer = this.get_s32("explosion_timer") - getGameTime();
       	 	if (timer <= 0)
        	{
            	// boom
                this.server_SetHealth(-1.0f);
                this.server_Die();
            }
		}
		else
		{
            this.SetLight( true );
            this.SetLightRadius(this.get_f32("explosive_radius") * 0.5f);
            this.SetLightColor( SColor(255, 211, 121, 224) );

            if (XORRandom(128) == 0)
            {
            	Screech(this);
            }
		}
	}
	else if (getGameTime() % SCREECH_INTERVAL == 0) // banshee screeching
	{
		Screech(this);
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if (damage >= 0.0f)
	{
	    this.getSprite().PlaySound( "/ZombieHit" );
    }

	return damage;
}

void onRender(CSprite@ this)
{
	if((getLocalPlayer().getUsername() == "0DarkShadow0" || getLocalPlayer().getUsername() == "xTheSwiftOnex" || getLocalPlayer().getUsername() == "XeonFaux") && getRules().get_bool("target lines"))
	{
		CBlob@ blob = this.getBlob();
		CBlob@ target = blob.getBrain().getTarget();

		if (target !is null)
		{
			Vec2f mypos = getDriver().getScreenPosFromWorldPos(blob.getPosition());
			Vec2f targetpos = getDriver().getScreenPosFromWorldPos(target.getPosition());
			GUI::DrawArrow2D( mypos,targetpos , SColor(0xffdd2212) );
		}
	}
}