const f32 attack_modifier = 1.25f;

void onTick( CBlob@ this )
{
    if (getGameTime() >= this.get_u32("AtkPotEnd") || this.hasTag("dead"))
    {
        this.getCurrentScript().runFlags |= Script::remove_after_this;
    }
	else
	{
		f32 getDamage(CBlob@ this, f32 damg)
		{
			return damg *= attack_modifier;
		}
	}
}