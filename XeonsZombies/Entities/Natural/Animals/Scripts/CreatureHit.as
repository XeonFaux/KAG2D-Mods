#include "MakeScroll.as";
// Flesh hit

f32 getGibHealth(CBlob@ this)
{
	if (this.exists("gib health"))
	{
		return this.get_f32("gib health");
	}

	return 0.0f;
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	this.Damage(damage, hitterBlob);
	// Gib if health below gibHealth
	f32 gibHealth = getGibHealth(this);

	//printf("ON HIT " + damage + " he " + this.getHealth() + " g " + gibHealth );
	// blob server_Die()() and then gib


	//printf("gibHealth " + gibHealth + " health " + this.getHealth() );
	if (this.getHealth() <= gibHealth)
	{
		if (this.hasTag("boss"))
		{
			int r = XORRandom(10);
			if(r<10 && getRules().get_bool("scrolls_spawn"))
			{
				if(r == 0)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "carnage" );
				else
				if(r == 1)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "midas" );				
				else
				if(r == 2)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "tame" );				
				else
				if(r == 3)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "necro" );	
				else
				if(r == 4)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "stone" );
				else
				if(r == 5)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "light" );
				else
				if(r == 6)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "bison" );
				else
				if(r == 7)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "healing" );	
				else
				if(r == 8)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "drought" );
				else
				if(r == 9)
					server_MakePredefinedScroll( hitterBlob.getPosition() + Vec2f(0,-3.0f), "fish" );
			}
		}
	    server_DropCoins(this.getPosition() + Vec2f(0, -3.0f), this.get_u16("coins on death"));

		this.getSprite().Gib();
		this.server_Die();
	}

	return 0.0f; //done, we've used all the damage
}
