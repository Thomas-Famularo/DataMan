--Thomas Famularo Database Management Final Project: Hearthstone Database

--Drop all tables to rebuild
Drop Table if Exists PlayerDecks;
Drop Table if Exists Games;
Drop Table if Exists Players;
Drop Table if Exists DeckCards;
Drop Table if Exists CardHeros;
Drop Table if Exists Decks;
Drop Table if Exists Heros;
Drop Table if Exists Minions;
Drop Table if Exists Spells;
Drop Table if Exists Weapons;
Drop Table if Exists Cards;
Drop Table if Exists Expansions;

--Droping Types
Drop Type if Exists ExpantionType cascade;
Drop type if exists AstrologicalYear Cascade;
drop type if exists Rarity cascade;
--Createing Enumerated Domains
Create type ExpantionType as Enum ('Adventure', 'Set');
Create type AstrologicalYear as Enum ('Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake', 'Horse', 'Sheep', 'Monkey', 'Rooster', 'Dog', 'Pig');
Create Type Rarity as Enum ('Legendary','Epic','Rare','Common'); 
--Create Expansions Table
create table Expansions(
	ExpansionID		int 			Not null,
	ExpantionName		char(50) 		not null,
	ReleaseDate		Date			NOT Null,
	ExpantionType		ExpantionType		not null,
	AstrologicalYear	AstrologicalYear	,
primary key(ExpansionID)
);
--Create Cards Table
create table Cards(
	CID			int 			Not null,
	ExpansionID		int 			Not null references Expansions(ExpansionID),
	ManaCost		Int			Not Null,
	CardName		char(40)		not null,
	CardText		Text			,
	CostDust		int			not null,
	Rarity			Rarity			NOT NULL,
primary key(CID)
);
--Create Minions Table
create table Minions(
	CID			INT			NOT NULL,
	Attack			INT			NOT NULL,
	Health			INT			NOT NULL,
primary key(CID)
);
--Create Spells Table
create table Spells(
	CID			int			NOT NULL references Cards(CID),
	ArtistFName		Char(20)		Not NUll,
	ArtistLName		Char(20)		NOT Null,
primary key(CID)
);
--Create Weapons Table
create table Weapons(
	CID			int			NOT NULL references Cards(CID),
	Attack			INT			NOT NULL,
	Durabality		INT			NOT NULL,
primary key(CID)
);
--Create Heros Table
create table Heros(
	HeroID			INT			NOT NULL,
	HeroName		Char(20)		NOT NULL,
	Power			text			NOT NULL,
primary key(HeroID)
);
--Create CardHeros Table
create table CardHeros(
	CID			int			NOT NULL references Cards(CID),
	HeroID			int			NOT NULL references Heros(HeroID),
primary key(CID, HeroID)
);
--Create Decks Table
create table Decks(
	DeckID			INT			NOT NULL,
	HeroID			int			NOT NULL references Heros(HeroID),
	DeckName		Char(20)		NOT NULL,
	CreateDate		Date			NOT Null,
primary key(DeckID)
);
--Create DeckCards Table
create table DeckCards(
	CID			int			NOT NULL references Cards(CID),
	DeckID			int			NOT NULL references Decks(DeckID),
	Quantity		INT			not null,
primary key(CID, DeckID)
);
--Create Players Table
create table Players(
	PID			int			NOT NULL,
	CreateDate		Date			NOT NULL,
	Email			Text			NOT NULL,
	BattleTag		Char(25)		NOT NULL,
	Pass			Char(30)		NOT NULL,
primary key(PID)
);
--Create Games Table
create table Games(
	GID			int			NOT NULL,
	DateTimeBegin		TIMESTAMP		NOT NULL,
	DateTimeEnd		TIMESTAMP		NOT NULL,
	NumberOfTurns		INT			NOT NULL,
	Winner			INT			NOT NULL references Players(PID),			
	Loser			INT			NOT NULL references Players(PID),
primary key(GID)
);
--Create PlayerDecks Table
create table PlayerDecks(
	GID			INT 			NOT NULL REFERENCES GAMES(GID),
	PID			INT			NOT NULL references Players(PID),
	DeckID			INT			NOT NULL REFERENCES Decks(DeckID),
	WentFirst		Boolean			not null,
primary key(GID, PID, DECKID)
);

Select * from Expansions;
Select * from Cards;
Select * from Minions;
Select * from Spells;
Select * from Weapons;
Select * from CardHeros;
Select * from Heros;
Select * from DeckCards;
Select * from Decks;
Select * from Players;
Select * from Games;
Select * from PlayerDecks;
-------------------------------------------------------------------------------------Stored Procedures for inserting-----------------------------------------------
--Stored Procedure to add a minion to the Database
Create or Replace Function insertMinion(INT, INT, INT, Char(40), TExt, INT, Rarity, INT, INT)
returns void
as
$$
Declare
-- _ used to indicate a variable
	_CID      	int   		:= $1;
	_ExpansionID	int 		:= $2;
	_ManaCost	Int		:= $3;
	_CardName	char(40)	:= $4;
	_CardText	Text		:= $5;
	_CostDust	int		:= $6;
	_Rarity		Rarity		:= $7;
	_Attack		INT		:= $8;
	_Health		INT		:= $9;
begin
	insert into Cards (CID, ExpansionID, ManaCost, CardName, CardText, CostDust, Rarity)
	values (_CID, _ExpansionID, _ManaCost, _CardName, _CardText, _CostDust, _Rarity);
	insert into Minions (CID, Health, Attack)
	values (_CID, _Health, _Attack);
end;
$$
language plpgsql;
--Stored Procedure to add a spell to the Database
Create or Replace Function insertSpell(INT, INT, INT, Char(40), TExt, INT, Rarity, Char(20), Char(20))
returns void
as
$$
Declare
-- _ used to indicate a variable
	_CID      	int   		:= $1;
	_ExpansionID	int 		:= $2;
	_ManaCost	Int		:= $3;
	_CardName	char(40)	:= $4;
	_CardText	Text		:= $5;
	_CostDust	int		:= $6;
	_Rarity		Rarity		:= $7;
	_ArtistFName	Char(20)	:= $8;
	_ArtistLName	Char(20)	:= $9;
begin
	insert into Cards (CID, ExpansionID, ManaCost, CardName, CardText, CostDust, Rarity)
	values (_CID, _ExpansionID, _ManaCost, _CardName, _CardText, _CostDust, _Rarity);
	insert into Spells (CID, ArtistFName, ArtistLName)
	values (_CID, _ArtistFName, _ArtistLName);
end;
$$
language plpgsql;
--Stored Procedure to add a weapon to the Database
Create or Replace Function insertWeapon(INT, INT, INT, Char(40), TExt, INT, Rarity, INT, INT)
returns void
as
$$
Declare
-- _ used to indicate a variable
	_CID      	int   		:= $1;
	_ExpansionID	int 		:= $2;
	_ManaCost	Int		:= $3;
	_CardName	char(40)	:= $4;
	_CardText	Text		:= $5;
	_CostDust	int		:= $6;
	_Rarity		Rarity		:= $7;
	_Attack		INT		:= $8;
	_Durabality	INT		:= $9;
begin
	insert into Cards (CID, ExpansionID, ManaCost, CardName, CardText, CostDust, Rarity)
	values (_CID, _ExpansionID, _ManaCost, _CardName, _CardText, _CostDust, _Rarity);
	insert into Weapons (CID, Attack, Durabality)
	values (_CID, _Attack, _Durabality);
end;
$$
language plpgsql;
--Stored Procedure to add a player to the Database
Create or Replace Function insertPlayer(int, Date, Text, Char(25), Char(30))
returns void
as
$$
Declare
-- _ used to indicate a variable
	_PID      	int   		:= $1;
	_CreateDate	Date		:= $2;
	_Emial		Text		:= $3;
	_BattleTag	Char(25)	:= $4;
	_Pass		Char(30)	:= $5;
begin
	insert into Players (PID, CreateDate, Emial, BattleTag, Pass)
	values (_PID, _CreateDate, _Emial, _BattleTag, _Pass);
end;
$$
language plpgsql;
-------------------------------------------------------------------------------------Inserting Data-----------------------------------------------
--Data for Expansions
insert into Expansions(ExpansionID,    ExpantionName, ReleaseDate, ExpantionType, AstrologicalYear)
                values(0,                  'Classic','2014-03-11',         'Set',             NULL),
                      (1,        'Goblins vs Gnomes','2014-12-08',         'Set',          'Horse'),
                      (2,       'Blackrock Mountain','2015-04-02',   'Adventure',          'Sheep'),
                      (3,     'The Grand Tournament','2015-08-24',    	   'Set',          'Sheep'),
                      (4,  'The League of Explorers','2015-11-12',   'Adventure',          'Sheep'),
                      (5, 'Whispers of the Old Gods','2016-04-26',    	   'Set',         'Monkey'),
                      (6,    'One Night in Karazhan','2016-08-11',   'Adventure',         'Monkey'),
                      (7,'Mean Streets of Gadgetzan','2016-12-02',    	   'Set',         'Monkey');
--Data for Minions Table
select * from insertMinion(  4,           7,       10,'Kun the Forgotten King','Choose One - Gain 10 Armor; or Refresh your Mana Crystals.',1600,'Legendary',7,7);
select * from insertMinion(  5,           7,        9,'Krul the Unshackled','Battlecry: If your deck has no duplicates, summon all Demons from your hand.',1600,'Legendary',7,9);
select * from insertMinion(  6,           7,        9,'Mayor Noggenfogger','All targets are chosen randomly.',1600,'Legendary',5,4);
select * from insertMinion(  7,           7,        7,'Abyssal Enforcer','Battlecry: Deal 3 damage to all other characters.',40,'Common',6,6);
select * from insertMinion(  8,           7,        7,'Don Han Cho','Battlecry: Give a random minion in your hand +5/+5.',1600,'Legendary',5,6);
select * from insertMinion(  9,           7,        7,'Grimestreet Protector','Taunt Battlecry: Give adjacent minions Divine Shield.',100,'Rare',6,6);
select * from insertMinion(  10,          7,        7,'Inkmaster Solia','Battlecry: If your deck has no duplicates, the next spell you cast this turn costs (0).',1600,'Legendary',5,5);
select * from insertMinion(  11,          7,        7,'Jade Chieftain','Battlecry: Summon a{1} {0} Jade Golem. Give it Taunt. @Battlecry: Summon a Jade Golem. Give it Taunt.',40,'Common',5,5);
select * from insertMinion(  12,          7,        6,'Ancient of Blossoms','Taunt',40,'Common',3,8);
select * from insertMinion(  13,          7,        6,'Aya Blackpaw','Battlecry and Deathrattle: Summon a{1} {0} Jade Golem. @ Battlecry and Deathrattle: Summon a Jade Golem.',1600,'Legendary',5,3);
select * from insertMinion(  14,          7,        6,'Big-Time Racketeer','Battlecry: Summon a 6/6 Ogre.',40,'Common',1,1);
select * from insertMinion(  15,          7,        6,'Defias Cleaner','Battlecry: Silence a minion with Deathrattle.',400,'Epic',5,7);
select * from insertMinion(  16,          7,        6,'Fight Promoter','Battlecry: If you control a minion with 6 or more Health, draw two cards.',400,'Epic',4,4);
select * from insertMinion(  17,          7,        6,'Jade Behemoth','Taunt Battlecry: Summon a{1} {0} Jade Golem.@[x]Taunt Battlecry: Summon a Jade Golem.',40,'Common',3,6);
select * from insertMinion(  18,          7,        6,'Kabal Crystal Runner','Costs (2) less for each Secret youve played this game.',100,'Rare',5,5);
select * from insertMinion(  19,          7,        6,'Kabal Trafficker','At the end of your turn, add a random Demon to your hand.',400,'Epic',6,6);
select * from insertMinion(  20,          7,        6,'Leatherclad Hogleader','Battlecry: If your opponent has 6 or more cards in hand, gain Charge.',400,'Epic',6,6);
select * from insertMinion(  21,          7,        6,'Luckydo Buccaneer','Battlecry: If your weapon has at least 3 Attack, gain +4/+4.',400,'Epic',5,5);
select * from insertMinion(  22,          7,        6,'Madam Goya','Battlecry: Choose a friendly minion. Swap it with a minion in your deck.',1600,'Legendary',4,3);
select * from insertMinion(  23,          7,        6,'Wind-up Burglebot','Whenever this attacks a minion and survives, draw a card.',400,'Epic',5,5);
select * from insertMinion(  24,          7,        6,'Wrathion','Taunt. Battlecry: Draw cards until you draw one that isnt a Dragon.',1600,'Legendary',4,5);
select * from insertMinion(  25,          7,        5,'Alley Armorsmith','Taunt Whenever this minion deals damage, gain that much Armor.',100,'Rare',2,7);
select * from insertMinion(  26,          7,        5,'Bomb Squad','Battlecry: Deal 5 damage to an enemy minion. Deathrattle: Deal 5 damage to your hero.',100,'Rare',2,2);
select * from insertMinion(  27,          7,        5,'Burgly Bully','Whenever your opponent casts a spell, add a Coin to your hand.',400,'Epic',4,6);
select * from insertMinion(  28,          7,        5,'Cryomancer','Battlecry: Gain +2/+2 if an enemy is Frozen.',40,'Common',5,5);
select * from insertMinion(  29,          7,        5,'Doppelgangster','Battlecry: Summon 2 copies of this minion.',100,'Rare',2,2);
select * from insertMinion(  30,          7,        5,'Drakonid Operative','Battlecry: If youre holding a Dragon, Discover a card in your opponents deck.',100,'Rare',5,6);
select * from insertMinion(  31,          7,        5,'Finja, the Flying Star','Stealth Whenever this attacks and kills a minion, summon 2 Murlocs from your deck.',1600,'Legendary',2,4);
select * from insertMinion(  32,          7,        5,'Grimestreet Enforcer','At the end of your turn, give all minions in your hand +1/+1.',100,'Rare',4,4);
select * from insertMinion(  33,          7,        5,'Grook Fu Master','Windfury',40,'Common',3,5);
select * from insertMinion(  34,          7,        5,'Kabal Songstealer','Battlecry: Silence a minion.',40,'Common',5,5);
select * from insertMinion(  35,          7,        5,'Knuckles','After this attacks a minion, it also hits the enemy hero.',1600,'Legendary',3,7);
select * from insertMinion(  36,          7,        5,'Lotus Agents','Battlecry: Discover a Druid, Rogue, or Shaman card.',400,'Rare',5,3);
select * from insertMinion(  37,          7,        5,'Lotus Assassin','Stealth. Whenever this attacks and kills a minion, gain Stealth.',400,'Epic',5,5);
select * from insertMinion(  38,          7,        5,'Raza the Chained','Battlecry: If your deck has no duplicates, your Hero Power costs (0) this game.',1600,'Legendary',5,5);
select * from insertMinion(  39,          7,        5,'Red Mana Wyrm','Whenever you cast a spell, gain +2 Attack.',40,'Common',2,6);
select * from insertMinion(  40,          7,        5,'Second-Rate Bruiser','Taunt Costs (2) less if your opponent has at least three minions.',100,'Rare',4,6);
select * from insertMinion(  41,          7,        5,'Virmen Sensei','Battlecry: Give a friendly Beast +2/+2.',100,'Rare',4,5);
select * from insertMinion(  42,          7,        5,'White Eyes','Taunt Deathrattle: Shuffle "The Storm Guardian" into your deck.',1600,'Legendary',5,5);
select * from insertMinion(  43,          7,        4,'Backroom Bouncer','Whenever a friendly minion dies, gain +1 Attack.',100,'Rare',4,4);
select * from insertMinion(  44,          7,        4,'Crystalweaver','Battlecry: Give your Demons +1/+1.',40,'Common',5,4);
select * from insertMinion(  45,          7,        4,'Daring Reporter','Whenever your opponent draws a card, gain +1/+1.',40,'Common',3,3);
select * from insertMinion(  46,          7,        4,'Dispatch Kodo','Battlecry: Deal damage equal to this minions Attack.',100,'Rare',2,4);
select * from insertMinion(  47,          7,        4,'Genzo, the Shark','Whenever this attacks, both players draw until they have 3 cards.',1600,'Legendary',5,4);
select * from insertMinion(  48,          7,        4,'Grimy Gadgeteer','At the end of your turn, give a random minion in your hand +2/+2.',40,'Common',4,3);
select * from insertMinion(  49,          7,        4,'Jade Spirit','Battlecry: Summon a{1} {0} Jade Golem.@Battlecry: Summon a Jade Golem.',40,'Common',2,3);
select * from insertMinion(  50,          7,        4,'Kabal Chemist','Battlecry: Add a random Potion to your hand.',40,'Rare',3,3);
select * from insertMinion(  51,          7,        4,'Kazakus','Battlecry: If your deck has no duplicates, create a custom spell.',1600,'Legendary',3,3);
select * from insertMinion(  52,          7,        4,'Lotus Illusionist','After this minion attacks a hero, transform it into a random 6-Cost minion.',400,'Epic',3,5);
select * from insertMinion(  53,          7,        4,'Naga Corsair','Battlecry: Give your weapon +1 Attack.',40,'Common',5,5);
select * from insertMinion(  54,          7,        4,'Seadevil Stinger','Battlecry: The next Murloc you play this turn costs Health instead of Mana.',40,'Rare',4,2);
select * from insertMinion(  55,          7,        4,'Shadow Sensei','Battlecry: Give a Stealthed minion +2/+2.',40,'Rare',4,4);
select * from insertMinion(  56,          7,        4,'Tanaris Hogchopper','Battlecry: If your opponents hand is empty, gain Charge.',60,'Common',4,4);
select * from insertMinion(  57,          7,        4,'Worgen Greaser','',40,'Common',6,3);
select * from insertMinion(  58,          7,        3,'Auctionmaster Beardo','After you cast a spell, refresh your Hero Power.',1600,'Legendary',3,4);
select * from insertMinion(  59,          7,        3,'Backstreet Leper','Deathrattle: Deal 2 damage to the enemy hero.',40,'Common',3,1);
select * from insertMinion(  60,          7,        3,'Blubber Baron','Whenever you summon a Battlecry minion while this is in your hand, gain +1/+1.',400,'Epic',1,1);
select * from insertMinion(  61,          7,        3,'Celestial Dreamer','Battlecry: If a friendly minion has 5 or more Attack, gain +2/+2.',100,'Rare',3,3);
select * from insertMinion(  62,          7,        3,'Fel Orc Soulfiend','At the start of your turn, deal 2 damage to this minion.',400,'Epic',3,7);
select * from insertMinion(  63,          7,        3,'Grimestreet Pawnbroker','Battlecry: Give a random weapon in your hand +1/+1.',100,'Common',3,3);
select * from insertMinion(  64,          7,        3,'Grimestreet Smuggler','Battlecry: Give a random minion in your hand +1/+1.',40,'Common',2,4);
select * from insertMinion(  65,          7,        3,'Hired Gun','Taunt',40,'Common',4,3);
select * from insertMinion(  66,          7,        3,'Kabal Courier','Battlecry: Discover a Mage, Priest, or Warlock card.',200,'Rare',2,2);
select * from insertMinion(  67,          7,        3,'Kabal Talonpriest','Battlecry: Give a friendly minion +3 Health.',40,'Common',3,4);
select * from insertMinion(  68,          7,        3,'Manic Soulcaster','Battlecry: Choose a friendly minion. Shuffle a copy into your deck.',100,'Rare',3,4);
select * from insertMinion(  69,          7,        3,'Rat Pack','Deathrattle: Summon a number of 1/1 Rats equal to this minions Attack.',400,'Epic',2,2);
select * from insertMinion(  70,          7,        3,'Sergeant Sally','Deathrattle: Deal damage equal to this minions Attack to all enemy minions.',1600,'Legendary',1,1);
select * from insertMinion(  71,          7,        3,'Shadow Rager','Stealth',40,'Common',5,1);
select * from insertMinion(  72,          7,        3,'Shaku, the Collector','Stealth. Whenever this attacks, add a random card to your hand (from your opponents class).',1600,'Legendary',2,3);
select * from insertMinion(  73,          7,        3,'Shaky Zipgunner','Deathrattle: Give a random minion in your hand +2/+2.',40,'Common',3,3);
select * from insertMinion(  74,          7,        3,'Toxic Sewer Ooze','Battlecry: Remove 1 Durability from your opponents weapon.',40,'Common',4,3);
select * from insertMinion(  75,          7,        3,'Wickerflame Burnbristle','Divine Shield. Taunt. Damage dealt by this minion also heals your hero.',2000,'Legendary',2,2);
select * from insertMinion(  76,          7,        2,'Blowgill Sniper','Battlecry: Deal 1 damage.',40,'Common',2,1);
select * from insertMinion(  77,          7,        2,'Dirty Rat','Taunt Battlecry: Your opponent summons a random minion from their hand.',400,'Epic',2,6);
select * from insertMinion(  78,          7,        2,'Friendly Bartender','At the end of your turn, restore 1 Health to your hero.',60,'Common',2,3);
select * from insertMinion(  79,          7,        2,'Gadgetzan Ferryman','Combo: Return a friendly minion to your hand.',100,'Rare',2,3);
select * from insertMinion(  80,          7,        2,'Gadgetzan Socialite','Battlecry: Restore 2 Health.',40,'Common',2,2);
select * from insertMinion(  81,          7,        2,'Grimestreet Informant','Battlecry: Discover a Hunter, Paladin, or Warrior card.',300,'Epic',1,1);
select * from insertMinion(  82,          7,        2,'Grimestreet Outfitter','Battlecry: Give all minions in your hand +1/+1.',40,'Common',1,1);
select * from insertMinion(  83,          7,        2,'Hobart Grapplehammer','Battlecry: Give all weapons in your hand and deck +1 Attack.',1600,'Legendary',2,2);
select * from insertMinion(  84,          7,        2,'Jade Swarmer','Stealth Deathrattle: Summon a{1} {0} Jade Golem.@Stealth Deathrattle: Summon a Jade Golem.',40,'Common',1,1);
select * from insertMinion(  85,          7,        2,'Mana Geode','Whenever this minion is healed, summon a 2/2 Crystal.',500,'Epic',2,3);
select * from insertMinion(  86,          7,        2,'Trogg Beastrager','Battlecry: Give a random Beast in your hand +1/+1.',100,'Rare',3,2);
select * from insertMinion(  87,          7,        1,'Alleycat','Battlecry: Summon a 1/1 Cat.',100,'Rare',1,1);
select * from insertMinion(  88,          7,        1,'Grimscale Chum','Battlecry: Give a random Murloc in your hand +1/+1.',60,'Common',2,1);
select * from insertMinion(  89,          7,        1,'Kabal Lackey','Battlecry: The next Secret you play this turn costs (0).',40,'Common',2,1);
select * from insertMinion(  90,          7,        1,'Meanstreet Marshal','Deathrattle: If this minion has 2 or more Attack, draw a card.',500,'Epic',1,2);
select * from insertMinion(  91,          7,        1,'Mistress of Mixtures','Deathrattle: Restore 4 Health to both players.',40,'Common',2,2);
select * from insertMinion(  92,          7,        1,'Patches the Pirate','Charge After you play a Pirate, summon this minion from your deck.',1600,'Legendary',1,1);
select * from insertMinion(  93,          7,        1,'Small-Time Buccaneer','Has +2 Attack while you have a weapon equipped.',100,'Rare',1,2);
select * from insertMinion(  94,          7,        1,'Weasel Tunneler','Deathrattle: Shuffle this minion into your opponents deck.',300,'Epic',1,1);
--Data for Spells Table
select * from insertSpell (  95,          7,        7,'Greater Arcane Missiles','Shoot three missiles at random enemies that deal 3 damage each.',400,'Epic','Evgeniy','Zaqumyenny');
select * from insertSpell (  96,          7,        6,'Dragonfire Potion','Deal 5 damage to all minions except Dragons.',400,'Epic','Arthur','Bozonnet');
select * from insertSpell (  97,          7,        6,'Felfire Potion','Deal 5 damage to all characters.',200,'Rare',' Charlene','Scanff');
select * from insertSpell (  98,          7,        5,'Lunar Visions','Draw 2 cards. Minions drawn cost (2) less.',400,'Epic','Arthur','Bozonnet');
select * from insertSpell (  99,          7,        4,'Blastcrystal Potion','Destroy a minion and one of your Mana Crystals.',40,'Common','Zoltan','Boros');
select * from insertSpell ( 100,          7,        4,'Call in the Finishers','Call in the Finishers',60,'Common','Mike','Saas');
select * from insertSpell ( 101,          7,        4,'Greater Healing Potion','Restore 12 Health to a friendly character.',120,'Rare','Tyler','West');
select * from insertSpell ( 102,          7,        4,'Jade Lightning','Deal 4 damage. Summon a{1} {0} Jade Golem.@Deal 4 damage. Summon a Jade Golem.',60,'Common','Phil','Saunders');
select * from insertSpell ( 103,          7,        3,'Bloodfury Potion','Give a minion +3 Attack. If its a Demon, also give it +3 Health.',100,'Rare','Raven','Mimura');
select * from insertSpell ( 104,          7,        3,'Jade Blossom','Summon a{1} {0} Jade Golem. Gain an empty Mana Crystal.@Summon a Jade Golem. Gain an empty Mana Crystal.',40,'Common','Zoltan','Boros');
select * from insertSpell ( 105,          7,        3,'Pilfered Power','Gain an empty Mana Crystal for each friendly minion.',450,'Epic','Zolatan','Boros');
select * from insertSpell ( 106,          7,        3,'Potion of Polymorph','Secret: After your opponent plays a minion, transform it into a 1/1 Sheep.',120,'Rare','Authur','Bozonnet');
select * from insertSpell ( 107,          7,        3,'Small-Time Recruits','Draw three 1-Cost minions from your deck.',500,'Epic','Daren','Bader');
select * from insertSpell ( 108,          7,        3,'Volcanic Potion','Volcanic Potion',100,'Rare','Konstantin','Turovec');
select * from insertSpell ( 109,          7,        2,'Devolve','Transform all enemy minions into random ones that cost (1) less.',100,'Rare','Sean','McNally');
select * from insertSpell ( 110,          7,        2,'Hidden Cache','Secret: After your opponent plays a minion, give a random minion in your hand +2/+2.',100,'Rare','Dan','Scott');
select * from insertSpell ( 111,          7,        2,'Jade Shuriken','Deal 2 damage. Combo: Summon a{1} {0} Jade Golem.@Deal 2 damage. Combo: Summon a Jade Golem.',60,'Common','Izzy','Hoover');
select * from insertSpell ( 112,          7,        2,'Stolen Goods','Give a random Taunt minion in your hand +3/+3.',100,'Rare','Mark','Gibbons');
select * from insertSpell ( 113,          7,        1,'Finders Keepers','Discover a card with Overload. Overload: (1)',400,'Epic','Benjamin','Zhang');
select * from insertSpell ( 114,          7,        1,'I Know a Guy','Discover a Taunt minion.',40,'Common','Kan','Lui');
select * from insertSpell ( 115,          7,        1,'Jade Idol','Choose One - Summon a{1} {0} Jade Golem; or Shuffle 3 copies of this card into your deck.@Choose One - Summon a Jade Golem; or Shuffle 3 copies of this card into your deck.',120,'Rare','Matthew','Connor');
select * from insertSpell ( 116,          7,        1,'Mark of the Lotus','Give your minions +1/+1.',40,'Common','Wayne','Reynolds');
select * from insertSpell ( 117,          7,        1,'Pint-Size Potion','Give all enemy minions -3 Attack this turn only.',100,'Rare','Matt','Dixon');
select * from insertSpell ( 118,          7,        1,'Potion of Madness','Gain control of an enemy minion with 2 or less Attack until end of turn.',40,'Common','Arthur','Bozonnet');
select * from insertSpell ( 119,          7,        1,'Smugglers Crate','Give a random Beast in your hand +2/+2.',40,'Common','Grace','Liu');
select * from insertSpell ( 120,          7,        1,'Smugglers Run','Give all minions in your hand +1/+1.',40,'Common','Alex','Orlandelli');
select * from insertSpell ( 121,          7,        0,'Counterfeit Coin','Gain 1 Mana Crystal this turn only.',100,'Rare','Joe','Wilson');
--Data for Weapons Table
select * from insertWeapon(   1,          7,        5,'Piranha Launcher', 'After your hero attacks, summon a 1/1 Piranha.', 400, 'Epic', 2, 4);
select * from insertWeapon(   2,          7,        4,'Brass Knuckles', 'After your hero attacks, give a random minion in your hand +1/+1.', 400, 'Epic', 2, 3);
select * from insertWeapon(   3,          7,        3,'Jade Claws', 'Battlecry: Summon a{1} {0} Jade Golem. Overload: (1)@Battlecry: Summon a Jade Golem. Overload: (1)', 100, 'Rare', 2, 2);
--Data for Heros Table
insert into Heros(HeroID, HeroName,  Power)
           values(0,        'NONE', 'NONE'),
                 (1,       'Druid', '+1 Attack this turn. +1 Armor'),
                 (2,      'Hunter', 'Deal 2 damage to the nemy hero.'),
                 (3,        'Mage', 'Deal 1 damage.'),
                 (4,     'Paladin', 'Summon a 1/1 Silver Hand Recruit.'),
                 (5,      'Priest', 'Restore 2 Health.'),
                 (6,       'Rogue', 'Equip a 1/2 Dagger.'),
                 (7,      'Shaman', 'Summon a random Totem'),
                 (8,     'Warlock', 'Draw a card and take 2 damage.'),
                 (9,     'Warrior', 'Gain 2 Armor.');
--Data for CardHeros Table
insert into CardHeros(CID, HeroID)
	       Values(  1,2),
	             (  2,9),
	             (  3,7),
	             (  4,1),
	             (  5,8),
	             (  6,0),
	             (  7,8),
	             (  8,4),
	             (  8,2),
	             (  8,9),
	             (  9,4),
	             ( 10,3),
	             ( 11,7),
	             ( 12,0),
	             ( 13,1),
	             ( 13,6),
	             ( 13,7),
	             ( 14,0),
	             ( 15,0),
	             ( 16,0),
	             ( 17,1),
	             ( 18,3),
	             ( 19,8),
	             ( 20,0),
	             ( 21,6),
	             ( 22,0),
	             ( 23,0),
	             ( 24,0),
	             ( 25,9),
	             ( 26,0),
	             ( 27,0),
	             ( 28,3),
	             ( 29,0),
	             ( 30,5),
	             ( 31,0),
	             ( 32,4),
	             ( 33,0),
	             ( 34,5),
	             ( 35,2),
	             ( 36,6),
	             ( 37,6),
	             ( 38,5),
	             ( 39,0),
	             ( 40,0),
	             ( 41,1),
	             ( 42,7),
	             ( 43,0),
	             ( 44,8),
	             ( 45,0),
	             ( 46,2),
	             ( 47,0),
	             ( 48,9),
	             ( 49,1),
	             ( 49,6),
	             ( 49,7),
	             ( 50,8),
	             ( 50,5),
	             ( 50,3),
	             ( 51,8),
	             ( 51,5),
	             ( 51,3),
	             ( 52,0),
	             ( 53,0),
	             ( 54,8),
	             ( 55,6),
	             ( 56,0),
	             ( 57,0),
	             ( 58,0),
	             ( 59,0),
	             ( 60,0),
	             ( 61,4),
	             ( 62,0),
	             ( 63,4),
	             ( 64,9),
	             ( 65,0),
	             ( 66,3),
	             ( 66,5),
	             ( 66,8),
	             ( 67,5),
	             ( 68,6),
	             ( 69,2),
	             ( 70,0),
	             ( 71,6),
	             ( 72,6),
	             ( 73,2),
	             ( 74,0),
	             ( 75,4),
	             ( 76,0),
	             ( 77,0),
	             ( 78,0),
	             ( 79,6),
	             ( 80,2),
	             ( 81,4),
	             ( 81,9),
	             ( 81,2),
	             ( 82,4),
	             ( 83,9),
	             ( 84,6),
	             ( 85,5),
	             ( 86,2),
	             ( 87,2),
	             ( 88,4),
	             ( 89,3),
	             ( 90,4),
	             ( 91,4),
	             ( 92,0),
	             ( 93,0),
	             ( 94,0),
	             ( 95,3),
	             ( 96,5),
	             ( 97,8),
	             ( 98,1),
	             ( 99,8),
	             (100,7),
	             (101,5),
	             (102,7),
	             (103,8),
	             (104,1),
	             (105,1),
	             (106,3),
	             (107,4),
	             (108,3),
	             (109,7),
	             (110,2),
	             (111,6),
	             (112,9),
	             (113,7),
	             (114,9),
	             (115,1),
	             (116,5),
	             (117,5),
	             (118,2),
	             (119,2),
	             (120,4),
	             (121,0);	             
--Data for Decks Table
insert into Decks(DeckID, HeroID,            DeckName,  CreateDate)
           values(1,           2,    'Band of Beasts','2016-11-02'),
                 (2,           4,   'The Mean Market','2016-11-12'),
                 (3,           6,'Gadgetzan Dockside','2016-11-22'),
                 (4,           8,   'Demons of Kabal','2016-12-02');
--Data for DeckCards Table
insert into DeckCards(DeckID,    CID, Quantity)
                values(     1,      1,        2),
		      (     1,      8,        2),
		      (     1,     46,        2),
		      (     1,     69,        2),
		      (     1,     80,        2),
		      (     1,     81,        2),
		      (     1,     86,        2),
		      (     1,    110,        2),
		      (     1,    118,        2),
		      (     1,    119,        2),
		      (     1,      6,        2),
		      (     1,     74,        2),
		      (     1,     78,        2),
		      (     1,     33,        2),
		      (     1,    121,        2),
		      (     2,      8,        2),
		      (     2,      9,        2),
		      (     2,     32,        2),
		      (     2,     63,        2),
		      (     2,     82,        2),
		      (     2,     90,        2),
		      (     2,     91,        2),
		      (     2,    107,        2),
		      (     2,    120,        2),
		      (     2,     31,        2),
		      (     2,     33,        1),
		      (     2,     39,        2),
		      (     2,     40,        2),
		      (     2,     43,        1),
		      (     2,     45,        2),
		      (     2,     94,        2),
		      (     3,     13,        2),
		      (     3,     21,        2),
		      (     3,     49,        2),
		      (     3,     55,        2),
		      (     3,    111,        2),
		      (     3,     84,        2),
		      (     3,     92,        2),
		      (     3,     93,        2),
		      (     3,     94,        2),
		      (     3,     77,        2),
		      (     3,     62,        2),
		      (     3,     59,        2),
		      (     3,     45,        2),
		      (     3,      6,        2),
		      (     3,     33,        2),
		      (     4,      5,        1),
		      (     4,      7,        1),
		      (     4,     19,        1),
		      (     4,     44,        1),
		      (     4,     50,        1),
		      (     4,     51,        1),
		      (     4,     54,        1),
		      (     4,     66,        1),
		      (     4,     97,        1),
		      (     4,     99,        1),
		      (     4,    103,        1),
		      (     4,      6,        1),
		      (     4,     14,        1),
		      (     4,     16,        1),
		      (     4,     22,        1),
		      (     4,     24,        1),
		      (     4,     27,        1),
		      (     4,     31,        1),
		      (     4,     39,        1),
		      (     4,     40,        1),
		      (     4,     47,        1),
		      (     4,     53,        1),
		      (     4,     57,        1),
		      (     4,     59,        1),
		      (     4,     70,        1),
		      (     4,     74,        1),
		      (     4,     78,        1),
		      (     4,     92,        1),
		      (     4,     93,        1),
		      (     4,     94,        1);
--Data for Players Table
Insert into players(PID, CreateDate,                            Email,        BattleTag, Pass)
	     Values(0,  '2014-03-11',   'HearthstoneSux@Blizzard.com',       'HSB#1100','JUSTKIDDING'),
	           (1,  '2014-04-11',               'Oxbow@Drakes.ru',   'OxbowRU#1283','WhatTimeIsIt'),
	           (2,  '2014-05-11',           'Idontcare@yahoo.com',   'Care#1235412','Idont'),
	           (3,  '2014-06-11',                'What@isthis.kr',   'What#9269423','isthis'),
	           (4,  '2014-07-11','JohnDefalcoIsTheWorst@mail.com',   'JohnSUX#1234','ihatehim'),
	           (5,  '2014-08-11',               'Scott@gmail.com',   'Scott#000000','DragonBallz'),
	           (6,  '2014-09-11',            'alan@labouseur.com',       'Alan#007','Idontknow'),
	           (7,  '2014-10-11',        'alan@3NFconsulting.com',      'NF3#12343','18651894'),
	           (8,  '2014-11-11',     'alan.labouseur@marist.edu',   'Marist#13132','489498658'),
	           (9,  '2014-12-11',          'ThomasF152@yahoo.com','nPPredator#1100','Nicetry');
--Data for Games Table
Insert into Games(GID,        DateTimeBegin,          DateTimeEnd, NumberOfTurns, Winner, Loser)
	   Values(  0,'2016-12-07 00:00:00','2016-12-07 00:10:00',            13,      1,     2),
	         (  1,'2016-12-07 01:00:00','2016-12-07 01:10:00',            22,      2,     7),
	         (  2,'2016-12-07 02:00:00','2016-12-07 02:10:00',             6,      3,     5),
	         (  3,'2016-12-07 03:00:00','2016-12-07 03:10:00',            45,      4,     4),
	         (  4,'2016-12-07 04:00:00','2016-12-07 04:10:00',            17,      5,     2),
	         (  5,'2016-12-07 05:00:00','2016-12-07 05:10:00',            23,      6,     1),
	         (  6,'2016-12-07 06:00:00','2016-12-07 06:10:00',             9,      7,     6),
	         (  7,'2016-12-07 07:00:00','2016-12-07 07:10:00',            27,      8,     7),
	         (  8,'2016-12-07 08:00:00','2016-12-07 08:10:00',            33,      9,     8),
	         (  9,'2016-12-07 09:00:00','2016-12-07 09:10:00',            14,      9,     1),
	         ( 10,'2016-12-07 10:00:00','2016-12-07 10:10:00',            15,      1,     3),
	         ( 11,'2016-12-07 11:00:00','2016-12-07 11:10:00',            16,      2,     4),
	         ( 12,'2016-12-07 12:00:00','2016-12-07 12:10:00',            22,      3,     5),
	         ( 13,'2016-12-07 13:00:00','2016-12-07 13:10:00',            23,      4,     6),
	         ( 14,'2016-12-07 14:00:00','2016-12-07 14:10:00',            24,      5,     7),
	         ( 15,'2016-12-07 15:00:00','2016-12-07 15:10:00',            37,      9,     8),
	         ( 16,'2016-12-07 16:00:00','2016-12-07 16:10:00',            38,      6,     4),
	         ( 17,'2016-12-07 17:00:00','2016-12-07 17:10:00',            39,      7,     3),
	         ( 18,'2016-12-07 18:00:00','2016-12-07 18:10:00',            44,      8,     4),
	         ( 19,'2016-12-07 19:00:00','2016-12-07 19:10:00',            12,      1,     5),
	         ( 20,'2016-12-07 20:00:00','2016-12-07 20:10:00',             5,      3,     6),
	         ( 21,'2016-12-07 21:00:00','2016-12-07 21:10:00',             1,      9,     1),
	         ( 22,'2016-12-07 22:00:00','2016-12-07 22:10:00',            22,      6,     2),
	         ( 23,'2016-12-07 23:00:00','2016-12-07 23:10:00',            24,      9,     3);
--Data for PlayerDecks Table
Insert into PlayerDecks( GID,PID,DeckID,WentFirst)
	         Values(   0,  1,     1,     TRUE),
                       (   0,  2,     2,    False),
                       (   1,  2,     2,     TRUE),
                       (   1,  7,     3,    False),
                       (   2,  3,     4,     TRUE),
                       (   2,  5,     4,    False),
                       (   3,  4,     3,     TRUE),
                       (   3,  4,     4,    False),
                       (   4,  2,     1,     TRUE),
                       (   4,  5,     3,    False),
                       (   5,  6,     2,     TRUE),
                       (   5,  1,     4,    False),
                       (   6,  7,     4,     TRUE),
                       (   6,  6,     1,    False),
                       (   7,  8,     1,     TRUE),
                       (   7,  7,     2,    False),
                       (   8,  9,     4,     TRUE),
                       (   8,  8,     3,    False),
                       (   9,  9,     4,     TRUE),
                       (   9,  1,     1,    False),
                       (  10,  1,     2,     TRUE),
                       (  10,  3,     1,    False),
                       (  11,  2,     4,     TRUE),
                       (  11,  4,     3,    False),
                       (  12,  3,     2,     TRUE),
                       (  12,  5,     1,    False),
                       (  13,  4,     4,     TRUE),
                       (  13,  6,     4,    False),
                       (  14,  7,     1,     TRUE),
                       (  14,  5,     3,    False),
                       (  15,  9,     1,     TRUE),
                       (  15,  8,     2,    False),
                       (  16,  4,     3,     TRUE),
                       (  16,  6,     1,    False),
                       (  17,  7,     4,     TRUE),
                       (  17,  3,     1,    False),
                       (  18,  8,     3,     TRUE),
                       (  18,  4,     2,    False),
                       (  19,  1,     4,     TRUE),
                       (  19,  5,     1,    False),
                       (  20,  3,     4,     TRUE),
                       (  20,  6,     3,    False),
                       (  21,  1,     2,     TRUE),
                       (  21,  9,     4,    False),
                       (  22,  6,     4,     TRUE),
                       (  22,  2,     3,    False),
	               (  23,  9,     1,     TRUE),
                       (  23,  3,     2,    False);
-------------------------------------------------------------------------------------   Views    -----------------------------------------------
--The names and quantity of cards in a deck 2
Create or replace view cardsInDeck2 as
Select CardName, Quantity
  From DeckCards inner join Decks on DeckCards.DeckID = Decks.DeckID
                 Inner join Cards on DeckCards.CID = Cards.CID
 Where DeckCards.DeckID = 2;
 Select *
   from cardsInDeck2;
--The total dust cost to create all decks
Create or replace view totalDustCost as
  Select DeckName, Sum(costDust)
    From DeckCards inner join Decks on DeckCards.DeckID = Decks.DeckID
                   Inner join Cards on DeckCards.CID = Cards.CID
group by (DeckName);
Select *
  from totalDustCost;
--How many times each player played each deck
Create or replace view countPlayerUseDeck as
  Select Battletag, DeckName, Count(*)
    From PlayerDecks inner join Players on PlayerDecks.PID = Players.PID
                     Inner join Decks ON PlayerDecks.DeckID = Decks.DeckID
group by (DeckName, Battletag)
Order by Battletag DEsC;          
Select *
  from countPlayerUseDeck;
--View both the card and minion table
Create or replace view cardAndMinion as
  Select Cards.CID, ExpansionID, ManaCost, CardName, CardText, costdust, rarity, attack, health
    From Cards inner join Minions on Cards.CID = Minions.CID
Order by Cards.CID DEsC;          
Select *
  from cardAndMinion;
--View both the card and spell table
Create or replace view cardAndSpell as
  Select Cards.CID, ExpansionID, ManaCost, CardName, CardText, costdust, rarity, ArtistFName, ArtistLName
    From Cards inner join Spells on Cards.CID = Spells.CID
Order by Cards.CID DEsC;          
Select *
  from cardAndSpell;
--View both the card and weapon table
Create or replace view cardAndWeapon as
  Select Cards.CID, ExpansionID, ManaCost, CardName, CardText, costdust, rarity, attack, durabality
    From Cards inner join Weapons on Cards.CID = Weapons.CID
Order by Cards.CID DEsC;          
Select *
  from cardAndWeapon;
-------------------------------------------------------------------------------------Stored Procedures-----------------------------------------------
Create or Replace Function CardsInDeck(int, refcursor)
returns refcursor
as
$$
Declare
	InputID      	int   		:= $1;
	resultset 	refcursor	:= $2;
begin
	open resultset for
	Select CardName, Quantity
          From DeckCards inner join Decks on DeckCards.DeckID = Decks.DeckID
                         Inner join Cards on DeckCards.CID = Cards.CID
         Where DeckCards.DeckID = InputID;
        return resultset;
end;
$$
language plpgsql;

select CardsInDeck(1, 'results');
Fetch all from results;      
-------------------------------------------------------------------------------------Triggers-----------------------------------------------
--Trigger to set the maximum number of cards in a deck to 30
Create or Replace Function maxCardsInDeck()
returns Trigger
as
$$
Declare
	counter		int;
begin
	Select count(*) into counter
	  from DeckCards
	 Where deckID = NEW.deckID;
	IF (counter < 30)
		THEN
		--All good. Do nothing. There is no problem here.
	ELSE
		Raise Exception 'A Deck cannot have more then 30 cards';
	END IF;
	Return new;
end;
$$
language plpgsql;

Drop trigger if exists maximumCards on DeckCards;
Create Trigger maximumCards
	before Insert
	On DeckCards
	for Each ROW
	execute procedure maxCardsInDeck();
------------------------------------------------------------------------------------ Security --------------------------------------------------8
--Create Roles
CREATE ROLE Player;
CREATE ROLE Developer;
create role Admin;
--Player
REVOKE ALL PRIVILEGES ON DeckCards FROM Player;
REVOKE ALL PRIVILEGES ON Heros FROM Player;
REVOKE ALL PRIVILEGES ON CardHeros FROM Player;
REVOKE ALL PRIVILEGES ON Cards FROM Player;
REVOKE ALL PRIVILEGES ON Games FROM Player;
REVOKE ALL PRIVILEGES ON Minions FROM Player;
REVOKE ALL PRIVILEGES ON Weapons FROM Player;
REVOKE ALL PRIVILEGES ON Spells FROM Player;
REVOKE ALL PRIVILEGES ON Expansions FROM Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON Players TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON PlayerDecks TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON Decks TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON DeckCards TO Player;
--Developer
REVOKE ALL PRIVILEGES ON Players FROM Developer;
REVOKE ALL PRIVILEGES ON PlayerDecks FROM Developer;
REVOKE ALL PRIVILEGES ON Decks FROM Developer;
REVOKE ALL PRIVILEGES ON DeckCards FROM Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON DeckCards TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Heros TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Cards TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Games TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Minions TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Weapons TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Spells TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Expansions TO Developer;
--Admin
GRANT SELECT, INSERT, UPDATE, DELETE ON DeckCards TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Heros TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Cards TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Games TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Minions TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Weapons TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Spells TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Expansions TO Developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON Players TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON PlayerDecks TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON Decks TO Player;
GRANT SELECT, INSERT, UPDATE, DELETE ON DeckCards TO Player;