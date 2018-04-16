const f32 damage_reduction = 0.6f;

void onTick( CBlob@ this )
{
    if (getGameTime() >= this.get_u32("DefPotEnd") || this.hasTag("dead"))
    {
        this.getCurrentScript().runFlags |= Script::remove_after_this;
    }
}

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	f32 currentHealth = this.getHealth();
	if (currentHealth < oldHealth)
	{
		this.server_Heal((oldHealth - currentHealth ) * damage_reduction);
    }
}