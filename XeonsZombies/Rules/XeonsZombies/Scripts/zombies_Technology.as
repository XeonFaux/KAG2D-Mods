#include "ShopCommon.as"
#include "TechsCommon.as"
#include "ScrollCommon.as"

#include "MakeScroll.as"
#include "MiniIconsInc.as"
void SetupScrolls(CRules@ this)
{
	SetupScrollIcons( this );

	// clear old
	// assign new

	ScrollSet _all, _super, _medium, _crappy;
	this.set( "all scrolls", _all );
	this.set( "crappy scrolls", _crappy );
	this.set( "medium scrolls", _medium );
	this.set( "super scrolls", _super );

	// we have to get ready pointers cause copying dictionary doesn't work

	ScrollSet@ all = getScrollSet( "all scrolls" );
	ScrollSet@ super = getScrollSet( "super scrolls" );
	ScrollSet@ crappy = getScrollSet( "crappy scrolls" );
	ScrollSet@ medium = getScrollSet( "medium scrolls" );

	const f32 m = 1.0f;
	const f32 t = 0.23f; //multiply research time


	//						EXPLANATION

	// def.level is the horizontal positioning (X) on the research tree
	// def.tier is the vertical positioning (Y) on the research tree
	// these are used mearily for rendering the tree

	// level 4 - super

	//TODO balloon

	{
		ScrollDef def;
		def.name = "Scroll of Taming";
		def.scrollFrame = FactoryFrame::magic_drought;
		def.scripts.push_back( "ScrollTaming.as" );
		all.scrolls.set( "tame", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of the Necromancer";
		def.scrollFrame = FactoryFrame::magic_drought;
		def.scripts.push_back( "ScrollNecro.as" );
		all.scrolls.set( "necro", def );
	}

	{
		ScrollDef def;
		def.name = "Scroll of Carnage";
		def.scrollFrame = FactoryFrame::magic_gib;
		def.scripts.push_back( "ScrollCarnage.as" );
		all.scrolls.set( "carnage", def );
	}

	{
		ScrollDef def;
		def.name = "Scroll of Midas";
		def.scrollFrame = FactoryFrame::magic_midas;
		def.scripts.push_back( "ScrollMidas.as" );
		all.scrolls.set( "midas", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Bison";
		def.scrollFrame = FactoryFrame::magic_drought;
		def.scripts.push_back( "ScrollBison.as" );
		all.scrolls.set( "bison", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Drought";
		def.scrollFrame = FactoryFrame::magic_drought;
		def.scripts.push_back( "ScrollDrought.as" );
		all.scrolls.set( "drought", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Healing";
		def.scrollFrame = FactoryFrame::magic_gib;
		def.scripts.push_back( "ScrollHealing.as" );
		all.scrolls.set( "healing", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Light";
		def.scrollFrame = FactoryFrame::magic_midas;
		def.scripts.push_back( "ScrollLight.as" );
		all.scrolls.set( "light", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Stone";
		def.scrollFrame = FactoryFrame::magic_midas;
		def.scripts.push_back( "ScrollStone.as" );
		all.scrolls.set( "stone", def );
	}
	{
		ScrollDef def;
		def.name = "Scroll of Fish Transformation";
		def.scrollFrame = FactoryFrame::magic_midas;
		def.scripts.push_back( "ScrollFishTransform.as" );
		all.scrolls.set( "fish", def );
	}

//	copyFrom( all.scrolls, "carnage", super.scrolls );
//	copyFrom( all.scrolls, "midas", super.scrolls );
//	copyFrom( all.scrolls, "drought", super.scrolls );

	//build the name arrays
	all.names = all.scrolls.getKeys();
	crappy.names = crappy.scrolls.getKeys();
	medium.names = medium.scrolls.getKeys();
	super.names = super.scrolls.getKeys();
}

void SetupScrollIcons( CRules@ this )
{
	for(uint i = 0; i < FactoryFrame::count; i++)
	{
		  AddIconToken( "$scroll"+i+"$", "Scroll.png", Vec2f(16,16), i );
	}
}

