#include <a_samp>
#include <F_AntiCheat>
#include <core>
#include <float>
#include <CPLoader>
#include <Seifader>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Colors
#define COLOR_BASIC 0xFFFF00AA
#define COLOR_RED 0xCC0000AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_1 0xFF2F00AA
#define COLOR_2 0xFF5100AA
#define COLOR_3 0xFF8400AA
#define COLOR_4 0xFFA600AA
#define COLOR_5 0xFFD900AA
#define COLOR_6 0xFFFB00AA
#define COLOR_7 0xD5FF00AA
#define COLOR_8 0xAAFF00AA
#define COLOR_9 0x7BFF00AA
#define COLOR_10 0x2BFF00AA
#define COLOR_11 0x00FF55AA
#define COLOR_12 0x00FF84AA
#define COLOR_13 0x00FFAAAA
#define COLOR_14 0x00FFD5AA
#define COLOR_15 0x00FFFFAA
#define COLOR_16 0x00D5FFAA
#define COLOR_17 0x00AAFFAA
#define COLOR_18 0x0080FFAA
#define COLOR_19 0x0055FFAA
#define COLOR_20 0x002BFFAA
#define COLOR_21 0x2A00FFAA
#define COLOR_22 0x5500FFAA
#define COLOR_23 0x8000FFAA
#define COLOR_24 0xAE00FFAA
#define COLOR_25 0xD500FFAA
#define COLOR_26 0xFF0044AA

//MaximumSpam
#define MAX_SPAM 6

/*#define SendFormatMessage(%1,%2,%3,%4)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%3),%4);SendClientMessage((%1),(%2),sendfstring);}while(FALSE)
stock SendFormatMessage(playerid,color,const sendfstring[]){
	SendClientMessage(playerid,color,sendfstring);
	return TRUE;
}

#define SendFormatMessageToAll(%1,%2,%3)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessageToAll((%1),sendfstring);}while(FALSE)
stock SendFormatMessageToAll(color,const sendfstring[]){
	SendClientMessageToAll(color,sendfstring);
	return TRUE;
}*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

forward AutoRepair(playerid);
forward DestroyNRG(playerid);
forward TuneCar();
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward GameModeExitFunc();
forward CountDown();
forward DynUpdateStart(playerid);
forward DynUpdateEnd(playerid);
forward unlock(playerid,vehicleid);
forward CheckGate();
forward MinSpam();
forward GodCarTimer(playerid);
forward Heal();
forward LVWZ();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Las Venturas DM Zone
new bool: LVWZTextShowed[MAX_PLAYERS];
new lvwz;

//Stupid Jumps
new stupidjump[7];
new stupidjumpsfound[MAX_PLAYERS];

//TuneCars
new Flash1;
new Sultan1;
new Sultan2;
new Elegy1;
new Elegy2;
new Uranus1;
new Uranus2;

//TextDraws
new Text:Textdraw0;

//Bomb
new Float: BombX[MAX_PLAYERS], Float: BombY[MAX_PLAYERS], Float: BombZ[MAX_PLAYERS], BombObject[MAX_PLAYERS], bool: BombArmed[MAX_PLAYERS];
forward BombTimer(playerid);

//PWNT pickup
new pwnt;

//TeleportMenu (pickup)
new Telemenu1;

//Information Icons: (pickups)
new Info[21];

//antibikefallof
new bool: AntiFalloff[MAX_PLAYERS];
new bool: InCar[MAX_PLAYERS];
new WhatCar[MAX_PLAYERS];

//personal nrg
new PVeh[MAX_PLAYERS];

//godmode vehicles
new GodCartimer;
new godcar[6];

//skin choose island
new bool: SkinChooseIslandObjectsShown[MAX_PLAYERS];
new SpawnIslandObject1;
new SpawnIslandObject2;
new SpawnIslandObject3;
new SpawnIslandObject4;
new SpawnIslandObject5;
new SpawnIslandObject6;
new SpawnIslandObject7;
new SpawnIslandObject8;
new SpawnIslandObject9;
new SpawnIslandObject10;
new SpawnIslandObject11;
new SpawnIslandObject12;
new SpawnIslandObject13;
new SpawnIslandObject14;
new SpawnIslandObject15;
new SpawnIslandObject16;
new SpawnIslandObject17;
new SpawnIslandObject18;
new SpawnIslandObject19;
new SpawnIslandObject20;
new SpawnIslandObject21;
new SpawnIslandObject22;
new SpawnIslandObject23;
new SpawnIslandObject24;
new SpawnIslandObject25;
new SpawnIslandObject26;
new SpawnIslandObject27;
new SpawnIslandObject28;
new SpawnIslandObject29;
new SpawnIslandObject30;
new SpawnIslandObject31;
new SpawnIslandObject32;
new SpawnIslandObject33;
new SpawnIslandObject34;
new SpawnIslandObject35;
new SpawnIslandObject36;

//Gates
new Checkgate;

//AdminCastle
new Gate1;
new bool: OpenGate1[MAX_PLAYERS];

//PinkAutos
new Gate2;
new bool: OpenGate2[MAX_PLAYERS];

//Cage
new Gate3, Gate4, Gate5, Gate6, Gate7; //(CageDamStunt)
new bool: OpenGateCage[MAX_PLAYERS];

//Other
new bool: NitroActive[MAX_PLAYERS];
new SpamStrings[MAX_PLAYERS];
new locked[MAX_PLAYERS][MAX_VEHICLES];
new vehid[MAX_PLAYERS];
new unlocktimer;
new DMZone[MAX_PLAYERS];
new spawnplace[MAX_PLAYERS];
new bool: spawnplacechosen[MAX_PLAYERS];
new bool: ReceiveInfo[MAX_PLAYERS];
new Count;
new bool: IsCountdownStarted;
new CountdownTimer;

//GangZones
new BuildingJumpGangZoneKicker;
new BuildingJumpGangZone;
new DragRaceGangZoneBlack;
new DragRaceGangZoneWhite1;
new DragRaceGangZoneWhite2;
new GlassMadnessGangZone1;
new GlassMadnessGangZone2;
new GlassMadnessGangZone3;
new AdminCastleGangZone1;
new AdminCastleGangZone2;

//Savep //Loadp
new Float:PosX[MAX_PLAYERS], Float:PosY[MAX_PLAYERS], Float:PosZ[MAX_PLAYERS], Float:PosA[MAX_PLAYERS], PosI[MAX_PLAYERS];

//Menus
new Menu: TruckStops;
new Menu: SpawnplaceMenu;
new Menu: Teleports;
new Menu: StuntZones1;
new Menu: StuntZones2;
new Menu: StuntZones3;
new Menu: DMZones;
new Menu: OtherZones1;
new Menu: OtherZones2;
new Menu: TuneGarages;
new Menu: TrainStations;

//VehicleNames
new vehName[][] = { "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier",
"Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
"Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
"News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster",
"Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover",
"Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune",
"Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car", "Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix",
"Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville", "Tiller", "Utility Trailer" };

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

main()
{
	print("Gamemodes");
	print("---------");
    print("  Loading gamemode 'SU.amx'...");
    print("   Loaded successful.");
	print("  Loaded 1 gamemode.");
	print(" ");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnGameModeInit()
{
    Seifader_OnInit();
    F_OnInit();

    SetDisabledWeapons(43,44,45);
    EnableStuntBonusForAll(0);

	SetTimer("MinSpam",20000,1);
    SetTimer("Heal", 1500, 1);

    SetGameModeText("未来世界1 测试版");
    UsePlayerPedAnims();

	SpawnplaceMenu = CreateMenu("SpawnPlace", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(SpawnplaceMenu, 0, "SF Airport");
    AddMenuItem(SpawnplaceMenu, 0, "DamStunt (home)");

	Teleports = CreateMenu("Teleports", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(Teleports, 0, "Stunt zones1");
    AddMenuItem(Teleports, 0, "Stunt zones2");
    AddMenuItem(Teleports, 0, "Stunt zones3");
    AddMenuItem(Teleports, 0, "DM zones");
    AddMenuItem(Teleports, 0, "Other zones1");
    AddMenuItem(Teleports, 0, "Other zones2");

	StuntZones1 = CreateMenu("StuntZones1", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(StuntZones1, 0, "Big Jump");
    AddMenuItem(StuntZones1, 0, "Big Jump 2");
    AddMenuItem(StuntZones1, 0, "Los Santos Tower");
    AddMenuItem(StuntZones1, 0, "Building Jump");
    AddMenuItem(StuntZones1, 0, "Mount Chilliad");
    AddMenuItem(StuntZones1, 0, "Way Of God - close -");
    AddMenuItem(StuntZones1, 0, "Wall Ride");
    AddMenuItem(StuntZones1, 0, "Wall Ride 2 - close -");
    AddMenuItem(StuntZones1, 0, "Las Vegas Airport");
    AddMenuItem(StuntZones1, 0, "Los Santos Airport - close -");
    AddMenuItem(StuntZones1, 0, "San Fierro Airport - close -");

	StuntZones2 = CreateMenu("StuntZones2", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(StuntZones2, 0, "Skate Park");
    AddMenuItem(StuntZones2, 0, "HalfPipe - close -");
    AddMenuItem(StuntZones2, 0, "Way To Air - close -");
    AddMenuItem(StuntZones2, 0, "Way To Death");
    AddMenuItem(StuntZones2, 0, "Stadium");
    AddMenuItem(StuntZones2, 0, "HopDeHop - close -");
    AddMenuItem(StuntZones2, 0, "Monster Crash");
    AddMenuItem(StuntZones2, 0, "FreeWay");
    AddMenuItem(StuntZones2, 0, "Way To Chilliad - close -");
    AddMenuItem(StuntZones2, 0, "Dead Jump");
    AddMenuItem(StuntZones2, 0, "BMX Parcour - close -");

	StuntZones3 = CreateMenu("StuntZones3", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(StuntZones3, 0, "Upside Down");
    AddMenuItem(StuntZones3, 0, "Way To Piramide - close -");
    AddMenuItem(StuntZones3, 0, "NRG Parcour - close -");
    AddMenuItem(StuntZones3, 0, "Roof Stunt - close -");
    AddMenuItem(StuntZones3, 0, "Aqua Park - close -");
    AddMenuItem(StuntZones3, 0, "RollerCoaster - close -");
    AddMenuItem(StuntZones3, 0, "Quad Parcour - close -");

	DMZones = CreateMenu("DMZones", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(DMZones, 0, "Bloodring Arena");
    AddMenuItem(DMZones, 0, "Air Battle");
    AddMenuItem(DMZones, 0, "Vehicle DM - close -");
    AddMenuItem(DMZones, 0, "Sniper");
    AddMenuItem(DMZones, 0, "SawnOFF");
    AddMenuItem(DMZones, 0, "SMG MP5");
    AddMenuItem(DMZones, 0, "Island DM - close -");
    AddMenuItem(DMZones, 0, "Derby");
    AddMenuItem(DMZones, 0, "RC War");
    AddMenuItem(DMZones, 0, "Watch RC War");

    TuneGarages = CreateMenu("TuneGarages", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(TuneGarages, 0, "Tune Garage 1");
    AddMenuItem(TuneGarages, 0, "Tune Garage 2");
    AddMenuItem(TuneGarages, 0, "Tune Garage 3");
    AddMenuItem(TuneGarages, 0, "Tune Garage 4");

	TrainStations = CreateMenu("TrainStations", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(TrainStations, 0, "LS Train Station");
    AddMenuItem(TrainStations, 0, "SF Train Station");
    AddMenuItem(TrainStations, 0, "LV Train Station 1");
    AddMenuItem(TrainStations, 0, "LV Train Station 2");

    TruckStops = CreateMenu("TruckStops", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(TruckStops,0,"LasVegas Truck Stop");
    AddMenuItem(TruckStops,0,"Chilliad Truck Stop");
    AddMenuItem(TruckStops,0,"Dam Truck Stop");

	OtherZones1 = CreateMenu("OtherZones1", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(OtherZones1, 0, "Tune Garages");
    AddMenuItem(OtherZones1, 0, "Train Stations");
    AddMenuItem(OtherZones1, 0, "Truck Stops");
    AddMenuItem(OtherZones1, 0, "AA");
    AddMenuItem(OtherZones1, 0, "Home");
    AddMenuItem(OtherZones1, 0, "Drag Race");
    AddMenuItem(OtherZones1, 0, "Karting");
    AddMenuItem(OtherZones1, 0, "Trampoline - close -");
    AddMenuItem(OtherZones1, 0, "Dirt");
    AddMenuItem(OtherZones1, 0, "AdminCastle");
    AddMenuItem(OtherZones1, 0, "PinkAutos");

	OtherZones2 = CreateMenu("OtherZones2", 1, 18.0, 102.0, 165.0, 165.0);
    AddMenuItem(OtherZones2, 0, "Drift");
    AddMenuItem(OtherZones2, 0, "Bounce - close -");
    AddMenuItem(OtherZones2, 0, "Car Sumo - close -");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    DragRaceGangZoneBlack = GangZoneCreate(-198.3580, -2301.9846, 1001.9586, -2284.6060);
    DragRaceGangZoneWhite1 = GangZoneCreate(1001.9586, -2301.9846, 1008.1840, -2284.6060);
    DragRaceGangZoneWhite2 = GangZoneCreate(-204.1360, -2301.9846, -198.3580, -2284.6060);
    BuildingJumpGangZone = GangZoneCreate(-2901.1870, -3117.6577, -2864.2527, -3074.6672);
    BuildingJumpGangZoneKicker = GangZoneCreate(-2887.2166, -3118.0154, -2878.3518, -3109.8782);
	AdminCastleGangZone1 = GangZoneCreate(-3748.2446, -325.8979, -3172.2207, 170.7440);
	AdminCastleGangZone2 = GangZoneCreate(-3747.2446, -324.8979, -3173.2207, 169.7440);
	GlassMadnessGangZone1 = GangZoneCreate(-35.2139, 1504.9364, -10.6830, 1546.7993);
	GlassMadnessGangZone2 = GangZoneCreate(11.3324, 1504.8782, 35.8336, 1546.6456);
	GlassMadnessGangZone3 = GangZoneCreate(-10.6830, 1523.0498, 11.3324, 1528.8363);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Gate1 = CreateObject(980, -2914.917969, -68.470116, 4.496734, 0.0000, 0.0000, 270.0000); //(admincastle)
	Gate2 = CreateObject(17951, -1643.2749, 1204.2693, 8.0269, 0.0000, 0.0000, 342.8113); //(pinkautos)
	//Cage
	CreateObject(3095, -423.699341, 2201.723145, 40.926292, 0.000000, 0.000000, 0.000000); //(Cage) D
	Gate3 = CreateObject(3095, -423.692413, 2201.705811, 59.923141, 179.5182, 0.0000, 90.2409); //(Cage) U
	Gate4 = CreateObject(3095, -423.686127, 2215.716309, 45.926369, 0.0000, 269.7591, 90.3447); //(Cage) N
	Gate5 = CreateObject(3095, -409.680603, 2201.730713, 45.926369, 0.0000, 269.7591, 0.0000); //(Cage) O
	Gate6 = CreateObject(3095, -423.685608, 2187.702881, 45.913692, 0.0000, 269.7591, 269.8631); //(Cage) Z
	Gate7 = CreateObject(3095, -437.683075, 2201.718506, 45.926338, 0.0000, 269.7591, 179.6223); //(Cage) W

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	AddPlayerClass(180,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(217,-468.3654,2208.0317,46.4776,115.0000,4,1,1,1,0,0);
	AddPlayerClass(211,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 28,-468.3654,2208.0317,46.4776,115.0000,4,1,1,1,0,0);
    AddPlayerClass(  0,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
    AddPlayerClass(202,-470.4734,2207.0278,46.6846,115.0000,4,1,0,0,0,0);
	AddPlayerClass(137,-467.6280,2208.3828,46.4052,115.0000,0,0,0,0,0,0);
	AddPlayerClass( 21,-468.3654,2208.0317,46.4776,115.0000,4,1,1,1,0,0);
	AddPlayerClass( 22,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 19,-467.6280,2208.3828,46.4052,115.0000,4,1,1,1,0,0);
	AddPlayerClass(181,-468.3654,2208.0317,46.4776,115.0000,4,1,41,50,0,0);
	AddPlayerClass(242,-469.4590,2207.5110,46.5850,115.0000,4,1,2,1,0,0);
	AddPlayerClass( 29,-470.4734,2207.0278,46.6846,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 61,-467.6280,2208.3828,46.4052,115.0000,0,0,0,0,0,0);
	AddPlayerClass(167,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(179,-469.4590,2207.5110,46.5850,115.0000,4,1,6,1,0,0);
	AddPlayerClass(204,-470.4734,2207.0278,46.6846,115.0000,4,1,8,1,0,0);
	AddPlayerClass( 80,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 81,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 23,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 99,-469.4590,2207.5110,46.5850,115.0000,0,0,0,0,0,0);
	AddPlayerClass(161,-470.4734,2207.0278,46.6846,115.0000,6,1,0,0,0,0);
	AddPlayerClass( 33,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass(163,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(164,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass(165,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(166,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(277,-470.4734,2207.0278,46.6846,115.0000,4,1,0,0,0,0);
	AddPlayerClass(280,-467.6280,2208.3828,46.4052,115.0000,4,1,3,1,0,0);
	AddPlayerClass(282,-468.3654,2208.0317,46.4776,115.0000,4,1,3,1,0,0);
	AddPlayerClass(283,-469.4590,2207.5110,46.5850,115.0000,4,1,3,1,0,0);
	AddPlayerClass(284,-470.4734,2207.0278,46.6846,115.0000,4,1,3,1,0,0);
	AddPlayerClass(285,-467.6280,2208.3828,46.4052,115.0000,4,1,3,1,0,0);
	AddPlayerClass(287,-468.3654,2208.0317,46.4776,115.0000,4,1,3,1,0,0);
	AddPlayerClass(100,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass(106,-470.4734,2207.0278,46.6846,115.0000,4,1,1,1,0,0);
	AddPlayerClass( 93,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass(233,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 41,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
    AddPlayerClass(178,-470.4734,2207.0278,46.6846,115.0000,4,1,11,1,0,0);
	AddPlayerClass(246,-467.6280,2208.3828,46.4052,115.0000,4,1,11,1,0,0);
    AddPlayerClass( 85,-469.4590,2207.5110,46.5850,115.0000,4,1,11,1,0,0);
    AddPlayerClass(192,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
    AddPlayerClass(193,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass(286,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 18,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
    AddPlayerClass( 26,-470.4734,2207.0278,46.6846,115.0000,4,1,0,0,0,0);
	AddPlayerClass(141,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass(189,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass( 70,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass(213,-467.6280,2208.3828,46.4052,115.0000,4,1,1,1,0,0);
	AddPlayerClass(206,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);
	AddPlayerClass(228,-469.4590,2207.5110,46.5850,115.0000,4,1,0,0,0,0);
	AddPlayerClass(240,-470.4734,2207.0278,46.6846,115.0000,4,1,0,0,0,0);
	AddPlayerClass(272,-467.6280,2208.3828,46.4052,115.0000,4,1,0,0,0,0);
	AddPlayerClass(269,-468.3654,2208.0317,46.4776,115.0000,4,1,0,0,0,0);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	CPS_AddCheckpoint(-3331.9456,-68.4954, 13.3000,3.0,35); //ACastle
	CPS_AddCheckpoint(-3364.0000,-69.7421,122.2000,3.0,25); //ACastle

	CPS_AddCheckpoint(1548.7977,-1364.6437,1873.6387,2.0,40); //LSTower
	CPS_AddCheckpoint(1573.0187,-1337.0237,16.4844,2.0,40); //LSTower

    //StuntRewards
	CPS_AddCheckpoint(-2230.9365,-3144.9285, 26.9574, 10, 100); //Buildingjump
	CPS_AddCheckpoint(-1631.9913, 2067.6938, 80.4229, 10, 100); //WayOfGod
	CPS_AddCheckpoint(3583.7134,-2831.2820,  5.9569, 10, 100); //Wallride2
	CPS_AddCheckpoint(-1001.5061, 2787.5010,270.1525, 10, 100); //WayToDeath
	CPS_AddCheckpoint(560.3680,-1736.2024,165.1810, 10, 100); //HopDeHop
	CPS_AddCheckpoint(-2104.7954, 1988.4512, 74.3328, 10, 100); //MonsterCrash
	CPS_AddCheckpoint(1289.2576, 1285.1971, 25.7736, 10, 100); //WayToPiramide
	CPS_AddCheckpoint(2917.0688,-1082.6384, 46.8261, 10, 100); //NRGParcour
	CPS_AddCheckpoint(-1732.1614,2011.5063,281.1830, 15, 100); //FreeWay
	CPS_AddCheckpoint(-2041.9523,416.9572,171.7764, 15, 100); //RoofStunt
	CPS_AddCheckpoint(1502.4039,-201.2229,109.0936, 15, 100); //UpsideDown
	CPS_AddCheckpoint(180.2094,-1809.4388,6.7371, 5, 100); //QuadParcour

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//InfoPickups
	Info[0] = CreatePickup(1239, 23,  3429.8765,-2981.0112,3.5090);
	Info[1] = CreatePickup(1239, 23,  335.5898,-1287.4230,54.3445);
	Info[2] = CreatePickup(1239, 23,  2935.6042,1277.9706,731.1594);
	Info[3] = CreatePickup(1239, 23,  2551.8306,-1408.7861,34.6484);
	Info[4] = CreatePickup(1239, 23,  -1938.1699,235.0074,34.3125);
	Info[5] = CreatePickup(1239, 23,  -2713.6941,214.5069,4.2688);
	Info[6] = CreatePickup(1239, 23,  2390.4780,1040.0917,10.8203);
	Info[7] = CreatePickup(1239, 23,  2649.0491,-2035.4257,13.5540);
	Info[8] = CreatePickup(1239, 23,  659.3933,1715.4761,7.1875);
	Info[9] = CreatePickup(1239, 23,  -1557.4404,-2736.0198,48.7435);
	Info[10] = CreatePickup(1239, 23,  -309.2794,1764.4392,43.6406);
	Info[11] = CreatePickup(1239, 23,  -471.6951,2198.6221,46.4031);
	Info[12] = CreatePickup(1239, 23,  2222.2078,324.1951,519.3140);
	Info[13] = CreatePickup(1239, 23,  -2909.0461,-76.0032,3.3680);
	Info[14] = CreatePickup(1239, 23,  -664.4253,2302.5837,136.1699);
	Info[15] = CreatePickup(1239, 23,  -678.8186,-3074.2754,705.6073);
	Info[16] = CreatePickup(1239, 23,  -473.3904,2208.1060,47.1292);
	Info[17] = CreatePickup(1239, 23,  -1133.2828,1022.6499,1358.9141);
	Info[18] = CreatePickup(1239, 23,  -1126.0514,1034.2153,1345.6892);
	Info[19] = CreatePickup(1239, 23,  -1127.2321,1038.5627,1345.7032);
	Info[20] = CreatePickup(1239, 23,  -482.6900,2218.7649,48.8604);

	//Telemenu1 (pickup)
	Telemenu1 = CreatePickup(1318, 2,  -459.2799,2186.8442,46.5418);
	pwnt = CreatePickup(1318, 2,  -423.699341, 2201.723145, 42.926292);

	//StupidJump pickups
	stupidjump[0] = CreatePickup(1276, 3,  541.9261,1557.4919,1.0000);
	stupidjump[1] = CreatePickup(1276, 3,  547.2913,2275.2310,34.8228);
	stupidjump[2] = CreatePickup(1276, 3,  -391.1560,2486.2866,41.2475);
	stupidjump[3] = CreatePickup(1276, 3,  -82.6590,1526.0188,16.7128);
	stupidjump[4] = CreatePickup(1276, 3,  77.1483,2459.5239,17.5412);
	stupidjump[5] = CreatePickup(1276, 3,  395.5041,2680.7537,59.1616);
	stupidjump[6] = CreatePickup(1276, 3,  706.5380,1590.1246,4.8696);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	CreateObject( 8171,-1055.467896,  464.439056, 10.195868,347.9679,90.2408, 134.0722); //Airport baan spawnpoint
	CreateObject( 8171, -987.041077,  505.720734,-22.445286,282.6508, 0.0000, 315.3093);  //Airport baan spawnpoint
	CreateObject(12814, 1271.888428,-1993.452637,495.079987,  0.0000, 0.0000,   0.0000); //BloodringArena spawnpoint
	CreateObject( 4585,-2882.761475,-3096.203369,-21.231087,  0.0000, 0.0000,   0.0000); //BuildingJump spawnpoint
//	CreateObject( 5112,  302.000000, 1544.449951,577.099976,  0.0000, 0.0000, 344.9991); //WayOfGod
//	CreateObject(18450, 2241.198730, -553.135132,359.050201,  0.0000, 0.0000, 264.6025); //WayToAir
//	CreateObject(18450, 2225.719238, -551.588623,358.962128,  0.0000, 0.0000, 264.6025); //WayToAir
//	CreateObject( 8171, 1283.905640, 4288.508789,107.692383,  0.0000, 0.0000,   0.0000); //HalfPipe
//	CreateObject( 4562, 2251.377900,  362.028900,517.144900,  0.0000, 0.0000, 268.0403); //Trampoline
	CreateObject( 3095, 2888.911600, 1029.213600, 11.920100,  0.0000, 0.0000,   0.0000); //Karting
	CreateObject( 3095, 2888.913800, 1038.107200, 11.920100,  0.0000, 0.0000,   0.0000); //Karting
	CreateObject( 3095, 2888.907000, 1047.096900, 11.922100,  0.0000, 0.0000,   0.0000); //Karting
	CreateObject(18450, 1029.493530, 2787.852295,1066.784424, 0.0000, 0.0000,   0.0000); //WayToDeath
	CreateObject(18450,-2383.949463, 2945.699219, 360.635925, 0.0000, 0.0000, 269.7591); //MonsterCrash
	CreateObject( 5112,-3243.146000,  -68.502000,  13.912000, 0.0000,-2.5780,   0.0000); //AdminCastle
	CreateObject( 5442,-3342.634000,  -68.508000,  12.644000, 0.0000,-4.2970,   0.0000); //AdminCastle
	CreateObject(16685,-3620.709000, -180.695000,   1.185000, 0.0000, 0.0000,-126.3370); //AdminCastle
	CreateObject( 4874,-3657.689000, -274.866000,   4.733000, 0.0000, 0.0000, 143.5260); //AdminCastle
	CreateObject(16771,-3706.578000, -218.817000,   7.715000, 0.0000, 0.0000,-126.3370); //AdminCastle
	CreateObject( 8419,-3360.156000,  -69.748000, 110.529000, 0.0000, 0.0000, 179.6220); //AdminCastle
	CreateObject( 9241,-3349.805000,  -46.445000, 123.935000, 0.0000, 0.0000,   0.0000); //AdminCastle
	CreateObject( 9241,-3350.004000,  -93.173000, 123.940000, 0.0000, 0.0000,   0.0000); //AdminCastle
	CreateObject(3851,   -12.600080, 1541.148804,  94.431061, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -12.596479, 1529.848267,  94.431427, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -12.606895, 1510.512329,  94.434296, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -24.516413, 1510.504517,  94.423111, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -33.372280, 1510.526733,  94.417885, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -33.368999, 1521.822754,  94.410744, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -24.501865, 1541.143677,  94.420128, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(3851,   -33.386833, 1541.134033,  94.410126, 0.000,269.8631,   0.0000); //GlassMadness
	CreateObject(17310, -2847.246338, 2185.518311, 798.000000,0.0000,180.3777,  0.0000); //FreeWay
	CreateObject(17310, -2847.329590, 2197.264404, 798.000000,0.0000,180.3777,  0.0000); //FreeWay
	CreateObject(17310, -2847.347656, 2201.005859, 799.250977,13.7510,180.3777, 0.0000); //FreeWay
//	CreateObject(18450, -3193.777588,-1210.862671,1397.179810,0.0000, 0.0000, 333.3575); //WayToChilliad
	CreateObject(18450,  -673.209045,-3053.225342, 704.263550,0.0000, 0.0000,  90.2409); //DeadJump
//	CreateObject(18450,  3458.541016,-2980.149170,   2.165215,0.0000, 0.0000,   0.0000); //WallRide
	CreateObject(18450,   355.043100,  -82.583000, 557.081600,0.0000, 0.0000,   0.0000); //UpsideDown
//	CreateObject(18450,  2929.756600, 1283.499800, 729.815700,0.0000, 0.0000,   0.0000); //WayToPiramide
	CreateObject(4726,   1544.695600,-1356.250600,1874.5605,  0.0000, 0.0000,   0.0000); //LSTower
//	CreateObject(18450,  1995.1489,    911.279100, 274.6017,  0.0000,354.8434,269.7591); //RollerCoaster
//	CreateObject(5706,   2974.3669,  -2723.2007,     4.0526,  0.0000, 0.0000,   0.0000); //Bounce
//	CreateObject(8417,  -2334.792480,4063.763875,  10.769835,0.0000, 0.0000,   0.0000); //CarSumo

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Hangar
	CreateVehicle(522,-1373.8726,-262.4546,13.7170,315.0000,13, 6,3); // NRG500
	CreateVehicle(522,-1371.9263,-264.3422,13.7163,315.0000, 1, 3,3); // NRG500
    CreateVehicle(522,-1369.9971,-266.2287,13.7170,315.0000, 1,79,3); // NRG500
    CreateVehicle(522,-1368.1353,-267.9540,13.7269,315.0000,86, 0,3); // NRG500
	CreateVehicle(522,-1366.1121,-269.9810,13.7188,315.0000,14,36,3); // NRG500
    CreateVehicle(522,-1364.3026,-271.8025,13.7186,315.0000,13, 6,3); // NRG500
    CreateVehicle(522,-1362.0038,-273.8415,13.7202,315.0000, 1, 3,3); // NRG500
	CreateVehicle(522,-1377.4534,-259.0116,13.7122,315.0000,13,6,3);  // NRG500
	CreateVehicle(522,-1379.3185,-257.0810,13.7131,315.0000,14,36,3); // NRG500
	CreateVehicle(522,-1381.5176,-254.9715,13.7222,315.0000, 1, 3,3); // NRG500
	CreateVehicle(522,-1383.3665,-253.0600,13.7134,315.0000,86, 0,3); // NRG500
	CreateVehicle(522,-1385.1018,-251.3301,13.7134,315.0000, 1, 3,3); // NRG500
	CreateVehicle(522,-1386.8523,-249.5515,13.7118,315.0000,13, 6,3); // NRG500
    CreateVehicle(444,-1392.4282,-243.9711,14.0000,225.0000, 1, 1,3); // MonsterA
	CreateVehicle(444,-1389.3508,-240.9302,14.0000,225.0000, 1, 1,3); // MonsterA
    CreateVehicle(471,-1351.8312,-273.2545,13.6289, 45.0000, 8, 8,3); // Quad
	CreateVehicle(471,-1349.5969,-271.1838,13.6297, 45.0000, 8, 8,3); // Quad
	CreateVehicle(471,-1351.8423,-268.9930,13.6299, 45.0000, 8, 8,3); // Quad
	CreateVehicle(471,-1354.2938,-270.6590,13.6287, 45.0000, 8, 8,3); // Quad
	CreateVehicle(481,-1348.1514,-269.1584,13.6641, 45.0000, 3, 3,3); // BMX
	CreateVehicle(481,-1346.5349,-267.5531,13.6636, 45.0000, 3, 3,3); // BMX
	CreateVehicle(481,-1344.8788,-265.9043,13.6638, 45.0000, 3, 3,3); // BMX
	CreateVehicle(571,-1340.6250,-261.9517,13.4319, 45.0000,79,79,3); // Kart
	CreateVehicle(571,-1342.4913,-260.0414,13.4289, 45.0000,79,79,3); // Kart
	CreateVehicle(571,-1341.3103,-258.8981,13.4279, 45.0000,79,79,3); // Kart
	CreateVehicle(571,-1339.4626,-260.8037,13.4290, 45.0000,79,79,3); // Kart
	CreateVehicle(411,-1338.0559,-257.1164,13.8755, 45.0000, 8, 8,3); // Infernus
	CreateVehicle(411,-1335.1530,-254.1786,13.7735, 45.0000, 8, 8,3); // Infernus
	CreateVehicle(411,-1332.4734,-251.4005,13.7734, 45.0000, 8, 8,3); // Infernus
	CreateVehicle(541,-1329.9636,-248.4910,13.7732, 45.0000, 1, 0,3); // Bullet
	CreateVehicle(541,-1327.0488,-245.8576,13.7740, 45.0000, 1, 0,3); // Bullet
	CreateVehicle(541,-1324.1519,-243.0222,13.7734, 45.0000, 1, 0,3); // Bullet
	CreateVehicle(451,-1386.3595,-237.5734,13.8755,225.0000,99,99,3); // Turismo
	CreateVehicle(451,-1383.9292,-234.7424,13.8542,225.0000,99,99,3); // Turismo
	CreateVehicle(451,-1381.0438,-231.5789,13.8549,225.0000,99,99,3); // Turismo
	CreateVehicle(451,-1378.6849,-228.1469,13.8549,225.0000,99,99,3); // Turismo
	CreateVehicle(531,-1375.4926,-226.2805,14.1011,225.0000,25,25,3); // tractor
	CreateVehicle(560,-1373.1289,-223.2703,13.8499,225.0000, 1, 1,3); // sultan
	CreateVehicle(522,-1371.6478,-220.2627,13.7178,225.0000,86, 0,3); // NRG500
	CreateVehicle(522,-1369.8684,-218.5093,13.7247,225.0000, 1, 3,3); // NRG500
	CreateVehicle(522,-1368.0232,-216.6941,13.7162,225.0000,13, 6,3); // NRG500
	CreateVehicle(522,-1366.4310,-215.0479,13.7184,225.0000,14,36,3); // NRG500
	CreateVehicle(522,-1364.7598,-213.3435,13.7183,225.0000, 1, 3,3); // NRG500

    //Airport
	CreateVehicle(447,-1423.7057,-266.4802,29.0000,225.2355,1,1,3); // Seaspar
	CreateVehicle(460,-1549.0000,-263.5101, 14.5000,27.5000,1,1,3); // Skimmer
	CreateVehicle(487,-1494.8989,-248.8462, 14.5000,35.2000,1,1,3); // Maverick
	CreateVehicle(487,-1443.1107,-520.0154,14.5000,209.3651,1,1,3); // Maverick
	CreateVehicle(513,-1383.7621,-483.0692,14.5000,207.5057,1,1,3); // Stuntplane
	CreateVehicle(513,-1361.0543,-467.7611,14.5000,198.3902,1,1,3); // Stuntplane
	CreateVehicle(513,-1586.2341,-568.6579,14.5000,209.0987,1,1,3); // Stuntplane
	CreateVehicle(513,-1203.8029, 178.8728,14.5000, 93.4516,1,1,3); // Stuntplane
	CreateVehicle(519,-1579.9270,-678.8997,14.5000,  3.3460,1,1,3); // Shamal
	CreateVehicle(519,-1656.5577,-400.4685,14.5000, 24.1464,1,1,3); // Shamal
	CreateVehicle(593,-1318.2959,-352.8320,14.5000,237.5523,1,1,3); // Dodo
	CreateVehicle(593,-1508.1389,-536.6498,14.5000,200.8066,1,1,3); // Dodo
	CreateVehicle(593,-1290.4484,-344.9474,14.5000,254.1266,1,1,3); // Dodo
	CreateVehicle(577,-1295.3870,-575.2518,15.0000,133.8013,1,1,3); // AT400
	CreateVehicle(485,-1374.8671,-524.8354,13.8336,296.5283,1,1,3); // baggage
	CreateVehicle(485,-1376.2766,-521.7865,13.8328,296.2556,1,1,3); // baggage
	CreateVehicle(485,-1378.0043,-518.6993,13.8298,296.1978,1,1,3); // baggage
	CreateVehicle(485,-1379.6494,-515.2647,13.8292,297.3530,1,1,3); // baggage
	CreateVehicle(608,-1329.5027,-502.5110,13.8328,116.9943,1,1,3); // TugStair
	CreateVehicle(608,-1331.3389,-499.1902,13.8296,116.0873,1,1,3); // TugStair
	CreateVehicle(608,-1332.7628,-496.3539,13.8303,116.3358,1,1,3); // TugStair
	CreateVehicle(608,-1334.5317,-492.3205,13.8328,116.6575,1,1,3); // TugStair
	CreateVehicle(606,-1386.4440,-500.6428,13.8356,294.6635,1,1,3); // BagBoxA
	CreateVehicle(606,-1384.0209,-505.0760,13.8300,297.4223,1,1,3); // BagBoxA

	//AA
	CreateVehicle(577, 363.1010,2497.9917, 16.2000,100.0000,1,1,3); // AT400
	CreateVehicle(447, 325.3195,2546.4934, 16.8000,180.0000,1,1,3); // Seasparrow
	CreateVehicle(520, 290.7801,2543.5718, 16.5000,180.0000,1,1,3); // Hydra
	CreateVehicle(608, 386.5729,2471.7349, 16.0711,270.0000,1,1,3); // TugStair
	CreateVehicle(608, 385.8385,2467.1509, 16.0714,270.0000,1,1,3); // TugStair
	CreateVehicle(485, 422.8667,2473.0918, 16.0636, 90.0000,1,1,3); // baggage
	CreateVehicle(513, 404.4107,2438.3262, 16.5000,  0.0000,1,1,3); // Stuntplane
	CreateVehicle(487, 365.4413,2537.5747, 16.2348,  0.0000,1,1,3); // Maverick

	//Way To Death
	CreateVehicle(541,1013.4863,2784.7273,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1014.1976,2791.1343,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1030.3352,2784.6333,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1030.1847,2791.1851,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1047.4824,2785.0417,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1047.5262,2790.8459,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1064.1064,2785.0645,1074.5000,90.0000,1,0,3); // Bullet
	CreateVehicle(541,1064.2322,2790.8184,1074.5000,90.0000,1,0,3); // Bullet

	//Drag Race
	CreateVehicle(451,1018.1115,-2328.1990,12.7970, 19.1895,1,1,3); // Turismo
	CreateVehicle(451,1021.9979,-2326.8132,12.7997, 15.1187,1,1,3); // Turismo
	CreateVehicle(451,1027.1621,-2325.0903,12.7985, 19.3656,1,1,3); // Turismo
	CreateVehicle(451,1032.7085,-2323.0239,12.8028, 16.1102,1,1,3); // Turismo
	CreateVehicle(451,1029.6615,-2312.4136,12.8002, 79.1068,1,1,3); // Turismo

	//Building Jump
	CreateVehicle(461,-2894.7683,-3075.1660,79.1897,179.6355,1,1,3); // PCJ600
	CreateVehicle(461,-2890.7756,-3075.2209,79.1926,178.7326,1,1,3); // PCJ600
	CreateVehicle(461,-2886.7505,-3075.2346,79.1981,179.1161,1,1,3); // PCJ600
	CreateVehicle(461,-2878.7661,-3075.2166,79.1902,178.5715,1,1,3); // PCJ600
	CreateVehicle(461,-2874.8423,-3075.2217,79.1994,179.9439,1,1,3); // PCJ600
	CreateVehicle(461,-2870.6865,-3075.2229,79.2002,179.9642,1,1,3); // PCJ600

	//Bloodring Arena
	CreateVehicle(504,1163.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger
	CreateVehicle(504,1168.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger
	CreateVehicle(504,1173.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger
	CreateVehicle(504,1178.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger
	CreateVehicle(504,1183.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger
	CreateVehicle(504,1188.0000,-2103.5000,496.5000,0.0000,1,1,3); // BloodringBanger

    //Big Jump 2
	CreateVehicle(522,-657.5523,2331.5034,138.5189,270.0000,13,6,3); // NRG500
	CreateVehicle(522,-658.4015,2328.8447,138.5689,270.0000,3,6,3); // NRG500
	CreateVehicle(522,-657.9895,2325.6064,138.5502,270.0000,6,6,3); // NRG500
	CreateVehicle(522,-658.6672,2323.1042,138.5911,270.0000,77,77,3); // NRG500
	CreateVehicle(522,-659.0502,2319.7278,138.6153,270.0000,25,25,3); // NRG500
/*
	//WayToAir
	CreateVehicle(411,2221.5554,-574.3084,364.0000,354.6293,6,6,3); // Infernus
	CreateVehicle(411,2223.6697,-551.7971,364.0000,354.6287,2,2,3); // Infernus
	CreateVehicle(411,2225.8477,-528.6207,364.0000,354.6281,77,77,3); // Infernus
	CreateVehicle(411,2240.9258,-576.2750,364.0000,354.4586,1,1,3); // Infernus
	CreateVehicle(411,2243.1394,-553.4680,364.0000,354.4578,7,7,3); // Infernus
	CreateVehicle(411,2245.3938,-530.2299,364.0000,354.4567,25,25,3); // Infernus

	//WayOfGod
	CreateVehicle(411,274.2221,1548.8229,583.0000,74.1029,75,1,3); //  Infernus
	CreateVehicle(411,274.1440,1554.3451,583.0000,74.0066,12,1,3); //  Infernus
	CreateVehicle(411,266.4133,1556.6409,583.0000,71.6876,64,1,3); //  Infernus
	CreateVehicle(411,257.9903,1558.8853,583.0000,70.2794,123,1,3); // Infernus
	CreateVehicle(411,264.8133,1551.0603,583.0000,72.2966,116,1,3); // Infernus
	CreateVehicle(411,256.4195,1554.1227,583.0000,78.0100,112,1,3); // Infernus
*/
	//Stadium
	new StadiumNRG500_1 = CreateVehicle(522,-1496.0048,1625.4183,1052.0997,268.6247,13,6,3); // NRG 500
	new StadiumNRG500_2 = CreateVehicle(522,-1495.7233,1622.6516,1052.1017,267.5627,13,6,3); // NRG 500
	new StadiumNRG500_3 = CreateVehicle(522,-1495.4155,1619.7268,1052.1012,270.7532,13,6,3); // NRG 500
	new StadiumNRG500_4 = CreateVehicle(522,-1495.6400,1616.9315,1052.0990,268.9297,13,6,3); // NRG 500
	new StadiumNRG500_5 = CreateVehicle(522,-1495.6876,1614.1799,1052.1058,269.9096,13,6,3); // NRG 500
	new StadiumNRG500_6 = CreateVehicle(522,-1495.4916,1611.3296,1052.1057,271.6064,13,6,3); // NRG 500
	LinkVehicleToInterior(StadiumNRG500_1,14);
	LinkVehicleToInterior(StadiumNRG500_2,14);
	LinkVehicleToInterior(StadiumNRG500_3,14);
	LinkVehicleToInterior(StadiumNRG500_4,14);
	LinkVehicleToInterior(StadiumNRG500_5,14);
	LinkVehicleToInterior(StadiumNRG500_6,14);
/*
	//HalfPipe
	CreateVehicle(522,1285.4266,4229.6968,112.0000,272.0000,3,6,3); // NRG 500
	CreateVehicle(522,1285.3983,4231.9326,112.0000,272.0000,3,3,3); // NRG 500
	CreateVehicle(522,1285.4292,4234.4971,112.0000,272.0000,8,8,3); // NRG 500
	CreateVehicle(522,1285.4915,4236.8501,112.0000,272.0000,77,77,3); // NRG 500
	CreateVehicle(522,1285.4518,4239.4712,112.0000,272.0000,25,25,3); // NRG 500
	CreateVehicle(522,1285.4493,4242.0010,112.0000,272.0000,75,75,3); // NRG 500
	CreateVehicle(522,1285.4293,4244.5508,112.0000,272.0000,6,75,3); // NRG 500
	CreateVehicle(522,1285.4148,4247.4243,112.0000,272.0000,3,6,3); // NRG 500
	CreateVehicle(411,1286.2906,4256.5249,111.5000,272.0000,2,2,3); // Infernus
	CreateVehicle(411,1286.1686,4265.9424,112.0000,272.0000,6,6,3); // Infernus
	CreateVehicle(411,1286.2936,4312.2324,112.0000,272.0000,3,3,3); // Infernus
	CreateVehicle(444,1285.1831,4275.1836,111.5000,272.0000,1,1,3); // MonsterA
	CreateVehicle(444,1285.7151,4284.8115,111.5000,272.0000,1,1,3); // MonsterA
	CreateVehicle(451,1286.2595,4293.8228,112.0000,272.0000,99,99,3); // Turismo
	CreateVehicle(451,1286.4182,4302.5430,112.0000,272.0000,99,99,3); // Turismo
	CreateVehicle(571,1285.3719,4320.1450,112.0000,272.0000,79,79,3); // Kart
	CreateVehicle(571,1285.2264,4322.9653,112.0000,272.0000,79,79,3); // Kart
	CreateVehicle(571,1289.1779,4322.8467,112.0000,272.0000,79,79,3); // Kart
	CreateVehicle(571,1289.9868,4320.0542,112.0000,272.0000,79,79,3); // Kart
	CreateVehicle(471,1285.0386,4328.7456,112.0000,272.0000,8,8,3); // Quad
	CreateVehicle(471,1285.3550,4331.5713,112.0000,272.0000,8,8,3); // Quad
	CreateVehicle(471,1285.6238,4334.5288,112.0000,272.0000,8,8,3); // Quad
*/
	//DamStunt
	CreateVehicle(522,-473.1689,2201.0247,46.3099,113.7809, 6, 6,3); // NRG500
	CreateVehicle(522,-474.8620,2202.2476,46.6067,120.3340, 1,25,3); // NRG500
	CreateVehicle(522,-476.5524,2204.0415,46.9294,121.7986, 6, 6,3); // NRG500
	CreateVehicle(522,-477.8897,2205.7019,47.1974,128.0953, 8, 8,3); // NRG500
	CreateVehicle(522,-479.3735,2206.9473,47.4695,131.8716, 3, 6,3); // NRG500
	CreateVehicle(522,-480.5000,2208.4629,47.6922,130.9934,75,75,3); // NRG500
	CreateVehicle(522,-482.0541,2210.1323,48.0020,127.7250, 3, 6,3); // NRG500
	CreateVehicle(522,-483.7692,2211.7053,48.3213,118.5749, 3, 3,3); // NRG500
	CreateVehicle(522,-485.6384,2213.2954,48.6635,121.7395, 8, 8,3); // NRG500
	CreateVehicle(522,-486.3483,2216.0369,48.8562,107.8466, 3, 8,3); // NRG500
	CreateVehicle(522,-486.4772,2218.5896,48.9447, 94.9922,75, 3,3); // NRG500
	//CreateVehicle(464,-468.4915,2182.9990,45.9073,145.1836,14,75,3); // Baron
	//CreateVehicle(464,-468.5396,2179.8352,45.9874,145.1836,14,75,3); // Baron
	CreateVehicle(564,-466.2542,2179.5547,45.9925,145.1836,0,0,3); // Tiger
	CreateVehicle(564,-465.6033,2182.1926,45.9538,146.3549,0,0,3); // Tiger
	CreateVehicle(501,-463.7964,2179.5083,46.4228,84.0878,14,75,3); // Goblin
	CreateVehicle(501,-463.5777,2182.7415,46.4174,82.7152,14,75,3); // Goblin
	CreateVehicle(465,-464.4675,2176.5454,46.5985,82.8555,14,75,3); // Raider
	CreateVehicle(441,-460.2057,2180.9658,46.2159,337.1051,82,54,3); // Bandit
	CreateVehicle(441,-460.5104,2178.9111,46.2564,337.4354,67,98,3); // Bandit
	CreateVehicle(594,-461.1044,2177.0090,46.4079,300.0304,0,0,3); // RCCam
	CreateVehicle(594,-461.5025,2175.5332,46.5022,300.0304,0,0,3); // RCCam
	CreateVehicle(606,-438.6306,2217.2607,42.3859,92.8172,1,1,3); // BagboxA
	CreateVehicle(606,-444.3248,2216.9851,42.3902,92.7406,1,1,3); // BagboxA
	CreateVehicle(485,-450.2059,2216.8816,41.9977,91.0538,1,73,3); // Baggage

	//Chilliad
	CreateVehicle(411,-2354.0881,-1637.2566,483.4302,297.4919,75,1,3); // Infernus
	CreateVehicle(411,-2355.4951,-1633.8690,483.4252,282.5932,123,1,3); // Infernus
	CreateVehicle(411,-2354.8496,-1630.1470,483.4121,263.5838,64,1,3); // Infernus
	CreateVehicle(411,-2354.0413,-1626.8356,483.4024,255.6960,12,1,3); // Infernus
	CreateVehicle(406,-2348.9104,-1614.6838,485.1739,253.9140,1,1,3); // Dumper
	CreateVehicle(444,-2348.2520,-1607.7555,484.0088,254.5864,32,66,3); // Monster
	CreateVehicle(522,-2349.6660,-1602.6708,483.1994,244.9188,6,25,3); // NRG500
	CreateVehicle(522,-2348.7610,-1600.9652,483.1856,242.9171,3,3,3); // NRG500
	CreateVehicle(522,-2348.0237,-1599.0815,483.1781,246.8820,3,8,3); // NRG500
	CreateVehicle(522,-2347.2673,-1597.3503,483.1740,246.3695,7,79,3); // NRG500
	CreateVehicle(487,-2337.0449,-1585.2484,483.7675,201.4765,26,57,3); // Maverick

	//Walride
	CreateVehicle(522,-809.7538,1809.6270,6.5708,185.5867,6,25,3); // NRG500
	CreateVehicle(522,-815.1681,1808.5840,6.5610,192.1262,39,106,3); // NRG500
	CreateVehicle(522,-808.5051,1809.9481,6.5397,184.9720,7,79,3); // NRG500
	CreateVehicle(522,-812.5004,1809.2064,6.5612,194.4276,36,105,3); // NRG500
	CreateVehicle(522,-814.1205,1809.7664,6.5713,194.9984,8,82,3); // NRG500
	CreateVehicle(522,-807.7274,1823.3240,6.5729,10.9335,6,25,3); // NRG500
	CreateVehicle(522,-811.3420,1823.2222,6.5638,3.3559,3,8,3); // NRG500
	CreateVehicle(447,-789.3624,1824.8783,0.8150,20.2568,75,2,3); // Seasparrow
/*
	//LSAirport
	CreateVehicle(522,2068.4314,-2638.0142,13.1177,90.3028,8,82,3); // NRG500
	CreateVehicle(522,2068.5266,-2640.4529,13.1150,91.5098,6,25,3); // NRG500
	CreateVehicle(522,2068.2844,-2643.1265,13.1151,89.2715,13,6,3); // NRG500
	CreateVehicle(522,2068.2537,-2646.2004,13.1189,90.8154,39,106,3); // NRG500
	CreateVehicle(522,2048.6492,-2646.4797,13.1151,268.8076,75,1,3); // NRG500
	CreateVehicle(522,2049.1641,-2644.0042,13.1217,269.5370,6,25,3); // NRG500
	CreateVehicle(522,2049.0542,-2641.7161,13.1150,270.3688,7,79,3); // NRG500
	CreateVehicle(522,2048.8953,-2639.6306,13.1176,267.9569,8,82,3); // NRG500
	CreateVehicle(522,2049.2090,-2637.1052,13.1164,269.5144,39,106,3); // NRG500
*/
	//SkatePark
	CreateVehicle(522,1926.0486,-1413.5530,13.1452,184.4530,51,118,3); // NRG500
	CreateVehicle(481,1918.6749,-1415.5945,13.0830,94.9541,14,1,3); // BMX
	CreateVehicle(522,1909.8756,-1414.8008,13.1451,182.6122,3,3,3); // NRG500
	CreateVehicle(481,1864.4189,-1404.8215,12.9928,94.9615,1,1,3); // BMX
	CreateVehicle(481,1864.2238,-1403.3655,12.9949,89.4963,6,6,3); // BMX
	CreateVehicle(481,1864.6633,-1401.9049,12.9937,87.5654,3,3,3); // BMX
	CreateVehicle(411,1866.3643,-1394.3004,13.2242,91.8053,106,1,3); // Infernus
	CreateVehicle(522,1923.1249,-1438.8029,13.1157,1.1435,6,25,3); // NRG500
	CreateVehicle(522,1920.9752,-1438.9794,13.1088,2.0674,7,79,3); // NRG500
	CreateVehicle(522,1919.0409,-1439.2275,13.1141,1.8678,8,82,3); // NRG500
	CreateVehicle(522,1917.2894,-1438.8982,13.1094,4.0703,36,105,3); // NRG500
	CreateVehicle(522,1915.3318,-1439.0115,13.1157,357.8111,39,106,3); // NRG500

	//AirBattle
	/*CreateVehicle(432,278.9016,1950.7509,17.6532,88.9054,43,0,3); // Hunter
	CreateVehicle(432,282.3510,1987.1381,17.6535,87.2516,43,0,3); // Hunter
	CreateVehicle(432,278.2103,2020.6830,17.6535,98.7492,43,0,3); // Hunter
	CreateVehicle(425,342.1974,1874.3889,18.3136,104.1868,34,0,3); // Hunter
	CreateVehicle(425,339.5558,1855.1088,18.5525,108.6887,43,0,3); // Hunter
	CreateVehicle(520,338.5540,1930.7616,18.7074,272.5084,0,0,3); // Hydra
	CreateVehicle(520,358.0111,1916.5072,18.6420,266.0934,0,0,3); // Hydra
	CreateVehicle(520,358.7953,1892.7484,18.3639,109.5348,0,0,3); // Hydra
	CreateVehicle(520,366.4059,1960.9697,18.3639,280.4560,0,0,3); // Hydra
	CreateVehicle(520,331.8059,1968.1923,18.3639,97.8575,0,0,3); // Hydra
	CreateVehicle(425,343.2718,1946.3412,18.2241,274.0224,43,0,3); // Hunter*/

	//Karting
	CreateVehicle(571,2891.0266,1031.9059,16.0000,359.7310,79,79,3); // Kart
	CreateVehicle(571,2891.0454,1035.9463,16.0000,359.7358,79,79,3); // Kart
	CreateVehicle(571,2891.0657,1040.3243,16.0000,359.7386,79,79,3); // Kart
	CreateVehicle(571,2891.0845,1044.4712,16.0000,359.7403,79,79,3); // Kart
	CreateVehicle(571,2891.1035,1048.4940,16.0000,359.7410,79,79,3); // Kart
	CreateVehicle(571,2886.6606,1032.0107,16.0000,359.7821,79,79,3); // Kart
	CreateVehicle(571,2886.6770,1036.2096,16.0000,359.7845,79,79,3); // Kart
	CreateVehicle(571,2886.6921,1040.2888,16.0000,359.7859,79,79,3); // Kart
	CreateVehicle(571,2886.7073,1044.4352,16.0000,359.7879,79,79,3); // Kart
	CreateVehicle(571,2886.7227,1048.4637,16.0000,359.7917,79,79,3); // Kart

	//LV Airport
	CreateVehicle(577,1584.8319,1192.0465,10.7274,181.7719,8,7,3); // AT400
	CreateVehicle(411,1319.1796,1278.6826,10.5474,0.2341,80,1,3); // Infernus
	CreateVehicle(513,1285.7657,1394.3384,11.3844,276.2746,21,36,3); // StuntPlane
	CreateVehicle(513,1284.2158,1409.6293,11.3650,270.3876,21,34,3); // StuntPlane
	CreateVehicle(487,1352.4438,1385.4857,10.9925,353.5326,29,42,3); // Maverick
	CreateVehicle(487,1432.8450,1382.2856,10.9990,205.8128,54,29,3); // Maverick
	CreateVehicle(487,1628.5409,1555.4915,10.9854,324.6620,54,29,3); // Maverick
	CreateVehicle(519,1337.0020,1498.3242,11.7387,237.3420,1,1,3); // Shamal

	//LV City
	CreateVehicle(522,2186.6301,2004.0399,10.3907,90.6423,6,25,3); // NRG500
	CreateVehicle(444,2186.0657,1983.3362,11.1916,89.8822,32,14,3); // Monster
	CreateVehicle(571,2187.9846,2000.2306,10.1041,89.7844,2,35,3); // Kart
	CreateVehicle(571,2187.3672,2009.0620,10.1043,92.1383,2,35,3); // Kart
	CreateVehicle(443,2154.6240,2064.2634,11.3063,0.1215,20,1,3); // Packer
	CreateVehicle(558,2103.8538,2052.9094,10.4507,270.6129,116,1,3); // Uranus
	CreateVehicle(560,2102.8926,2082.3550,10.5256,271.3061,9,39,3); // Sultan
	CreateVehicle(522,2103.4114,2095.5076,10.3840,268.1787,6,25,3); // NRG500
	CreateVehicle(598,2256.0154,2477.0156,10.5660,180.6221,0,1,3); // PoliceLV
	CreateVehicle(598,2273.5632,2460.6614,10.5671,1.7653,0,1,3); // PoliceLV
	CreateVehicle(598,2282.4707,2443.2561,10.5656,359.0438,0,1,3); // PoliceLV
/*
	//HopDeHop
	CreateVehicle(522,315.8645,-1291.6205,53.9075,290.7808,39,106,3); // NRG500
	CreateVehicle(522,314.4276,-1288.9381,53.8972,293.7975,39,106,3); // NRG500
	CreateVehicle(522,312.9862,-1286.6045,53.9085,298.2156,39,106,3); // NRG500
	CreateVehicle(522,311.8107,-1284.4158,53.9069,295.3387,39,106,3); // NRG500
	CreateVehicle(522,338.8258,-1269.0780,53.9378,121.5282,39,106,3); // NRG500
	CreateVehicle(522,339.8040,-1271.2798,53.9270,116.7442,39,106,3); // NRG500
	CreateVehicle(522,341.4596,-1273.9778,53.9427,117.7584,39,106,3); // NRG500
	CreateVehicle(522,343.2038,-1275.7338,53.9432,122.4109,39,106,3); // NRG500
*/
	//Trains
	CreateVehicle(537,1695.2631,-1953.6426,14.8756,89.9202,1,1,3); // LSTrain
	CreateVehicle(537, 1466.8977, 2632.2500,12.1256,270.0000,1,1,3); // LVTrain1
	CreateVehicle(537, 2864.7500, 1254.7863,12.1256,180.0000,1,1,3); // LVTrain2
	CreateVehicle(537,-1942.9858,  165.1703,27.0006,356.8288,1,1,3); // SFSTrain

	//Trams
	CreateVehicle(449,-2006.5612,189.4531,27.5391,0.000,1,74,3); // Tram
	CreateVehicle(449,-1933.5723,141.4476,25.7109,180.000,1,74,3); // Tram
	CreateVehicle(449,-1576.0437,97.0551,4.2473,0.000,1,74,3); // Tram
	CreateVehicle(449,-1960.5421,-145.8998,25.7109,180.000,1,74,3); // Tram
	CreateVehicle(449,1696.3413,-1957.8750,13.9973,180.000,1,74,3); // Tram
	CreateVehicle(449,-1933.6611,132.8942,26.1223,358.6780,1,74,3); // Tram
	CreateVehicle(449,-1867.7717,-33.5000,15.8154,90.0000,1,74,3); // Tram
	CreateVehicle(449,-2006.5000,180.8433,27.9973,0.0000,1,74,3); // Tram
	CreateVehicle(449,-2003.7500,520.8181,35.4973,0.0000,1,74,3); // Tram
	CreateVehicle(449,-1736.2876,605.7067,25.1223,284.6910,1,74,3); // Tram
	CreateVehicle(449,-1583.8840,849.0000,7.8475,90.0000,1,74,3); // Tram
	CreateVehicle(449,-1754.4297,921.1250,25.1223,270.0000,1,74,3); // Tram
	CreateVehicle(449,-1711.9480,1325.1581,7.4973,44.9057,1,74,3); // Tram
	CreateVehicle(449,-2264.8750,883.4365,66.8983,180.0000,1,74,3); // Tram
	CreateVehicle(449,-2264.6904,527.5579,35.5895,180.4107,1,74,3); // Tram
	CreateVehicle(449,-2166.6150,-1.0740,35.6223,359.8728,1,74,3); // Tram
/*
	//Trampoline
	CreateVehicle(443,2278.0940,379.2718,519.7841,179.2645,20,1,3); // Packer
	CreateVehicle(443,2273.2175,379.4765,519.7869,178.6752,20,1,3); // Packer
	CreateVehicle(443,2283.1436,379.4739,519.7927,178.8362,20,1,3); // Packer
	CreateVehicle(444,2236.9375,373.4625,519.5295,178.0287,1,1,3); // Monster
	CreateVehicle(444,2231.9712,373.5803,519.5295,179.6803,1,1,3); // Monster
	CreateVehicle(444,2242.7927,373.6520,519.5274,180.2035,1,1,3); // Monster
	CreateVehicle(437,2195.1260,312.1414,519.5093,267.9720,1,1,3); // Coach
	CreateVehicle(437,2194.8672,319.5057,519.5078,268.6938,1,1,3); // Coach
	CreateVehicle(437,2194.1353,304.3190,519.5080,269.5218,1,1,3); // Coach
*/
	//MonsterCrash
	CreateVehicle(444,-2381.6616,2950.6799,362.3547,180.1227,1,1,3); // Monster
	CreateVehicle(444,-2381.6372,2939.5186,362.3547,180.1228,1,1,3); // Monster
	CreateVehicle(444,-2381.6123,2927.6519,362.3547,180.1228,1,1,3); // Monster
	CreateVehicle(444,-2381.5886,2916.4019,362.3547,180.1225,1,1,3); // Monster
	CreateVehicle(444,-2386.4470,2951.3674,362.3546,179.7106,1,1,3); // Monster
	CreateVehicle(444,-2386.5088,2939.0859,362.3547,179.7091,1,1,3); // Monster
	CreateVehicle(444,-2386.5664,2927.8965,362.3547,179.7215,1,1,3); // Monster
	CreateVehicle(444,-2386.6223,2916.2607,362.3547,179.7200,1,1,3); // Monster

	//AdminCastle
	CreateVehicle(493,-3287.7981,-151.4704,-0.1473,273.7014,36,13,3); // Jetmax
	CreateVehicle(493,-3286.8813,-131.2394,-0.1352,266.8988,36,13,3); // Jetmax
	CreateVehicle(493,-3286.7888,-119.7918,0.1130,272.7021,36,13,3); // Jetmax
	CreateVehicle(493,-3286.2300,-99.0608,0.4191,266.6347,36,13,3); // Jetmax
	CreateVehicle(425,-3350.1089,-46.7394,126.3349,90.4781,43,0,3); // Hunter
	CreateVehicle(425,-3350.3652,-93.2341,126.3385,89.5737,43,0,3); // Hunter
	CreateVehicle(520,-3711.6367,-203.8298,2.8843,236.0604,0,0,3); // Hydra
	CreateVehicle(520,-3722.2937,-218.6151,2.8839,231.7319,0,0,3); // Hydra
	CreateVehicle(519,-3662.0061,-246.8870,3.0824,322.3916,1,1,3); // Shamal
	CreateVehicle(519,-3643.6279,-222.7272,3.0825,322.4963,1,1,3); // Shamal
	CreateVehicle(447,-3282.4265,-80.8916,1.9117,274.2914,1,1,3); // Seasparrow
	CreateVehicle(460,-3283.3625,-165.7920,2.3586,273.6100,1,1,3); // Skimmer
	CreateVehicle(432,-3310.9585,-74.1981,16.0614,269.5563,43,0,3); // Rhino
	CreateVehicle(432,-3296.7517,-74.2760,17.1975,269.6861,43,0,3); // Rhino
	CreateVehicle(522,-3318.6326,-61.1852,15.0872,179.6868,13,6,3); // NRG500
	CreateVehicle(522,-3321.6199,-60.9766,14.8632,179.0790,6,25,3); // NRG500
	CreateVehicle(522,-3323.9604,-60.9572,14.6873,179.3463,3,8,3); // NRG500
	CreateVehicle(522,-3326.7183,-61.0062,14.4799,178.2079,1,0,3); // NRG500
	CreateVehicle(522,-3329.3931,-61.0525,14.2792,176.9660,7,79,3); // NRG500
	CreateVehicle(432,-3667.8296,-268.4891,2.1826,53.6342,43,0,3); // Rhino
	CreateVehicle(425,-3642.3650,-282.6970,5.7685,143.1146,43,0,3); // Hunter

	//AdminCastleGate
	CreateVehicle(522,-2902.8120,-79.3030,3.3534,21.3833,75,3,3); // NRG500
	CreateVehicle(522,-2905.1287,-80.6286,3.1711,27.8384,75,3,3); // NRG500
	CreateVehicle(522,-2907.2905,-82.0879,2.9999,31.5687,75,3,3); // NRG500

	//FreeWay
	CreateVehicle(568,-2843.1000,2182.5000,799.7175,178.9291,13,6,3); // Bandito
	CreateVehicle(568,-2843.1000,2189.0000,799.7418,181.5981,13,6,3); // Bandito
	CreateVehicle(568,-2843.1000,2196.0000,799.9264,180.9663,13,6,3); // Bandito
	CreateVehicle(568,-2851.0000,2182.5000,799.7468,178.3719,13,6,3); // Bandito
	CreateVehicle(568,-2851.0000,2189.0000,799.7274,178.9721,13,6,3); // Bandito
	CreateVehicle(568,-2851.0000,2196.0000,799.8974,176.6867,13,6,3); // Bandito
/*
	//WayToChilliad
    CreateVehicle(411,-3199.8826,-1202.9858,1405.2506,242.7174,1,1,3); // Infernus
    CreateVehicle(411,-3202.2986,-1210.9252,1405.2506,243.0204,3,8,3); // Infernus
    CreateVehicle(411,-3189.9031,-1208.5680,1405.2506,241.7725,6,3,3); // Infernus
    CreateVehicle(411,-3188.3411,-1218.2926,1405.2506,244.4769,13,6,3); // Infernus
    CreateVehicle(411,-3177.3259,-1214.9613,1405.2506,244.3414,7,79,3); // Infernus
    CreateVehicle(411,-3175.7876,-1224.1002,1405.2506,243.4216,8,8,3); // Infernus
    CreateVehicle(411,-3162.7371,-1222.1682,1405.2506,243.2443,6,25,3); // Infernus
    CreateVehicle(411,-3165.9685,-1228.9999,1405.2506,244.3066,75,2,3); // Infernus
*/
    //DeadJump
	CreateVehicle(411,-676.5190,-3069.8496,705.3344,0.2696,3,8,3); // Infernus
	CreateVehicle(411,-676.6273,-3046.7793,705.3344,0.2698,6,3,3); // Infernus
	CreateVehicle(411,-676.7310,-3024.7866,705.3344,0.2700,1,1,3); // Infernus
	CreateVehicle(411,-670.1886,-3025.2009,705.3344,0.1264,75,2,3); // Infernus
	CreateVehicle(411,-670.1414,-3046.5112,705.3344,0.1263,7,79,3); // Infernus
	CreateVehicle(411,-670.0908,-3069.5845,705.3344,0.1262,8,8,3); // Infernus

	//GoingDown
	CreateVehicle(411,-2511.9365,-730.1193,304.7742,325.7777,3,8,3); // Infernus
	CreateVehicle(411,-2517.4480,-727.2708,304.7742,326.6524,6,8,3); // Infernus
	CreateVehicle(411,-2501.7915,-726.1782,304.7818,56.8584,25,8,3); // Infernus
	CreateVehicle(411,-2498.4197,-720.8576,304.7780,56.4955,0,8,3); // Infernus
	CreateVehicle(411,-2494.7490,-715.4606,304.7742,56.3533,1,8,3); // Infernus
	CreateVehicle(411,-2519.4978,-698.9435,304.7741,236.5353,3,8,3); // Infernus

	//FallDown
	CreateVehicle(411,1984.8682,-1756.6892,1126.7583,347.0066,3,8,3); // Infernus
	CreateVehicle(411,1982.6176,-1750.5527,1126.7614,349.2014,6,8,3); // Infernus
	CreateVehicle(411,1991.3434,-1769.3378,1126.6842,329.5869,25,8,3); // Infernus
	CreateVehicle(411,2001.1511,-1772.9520,1126.5756,25.0400,0,8,3); // Infernus
	CreateVehicle(411,1992.9099,-1739.6536,1126.8110,345.7711,1,8,3); // Infernus
	CreateVehicle(411,1979.6844,-1741.5415,1126.7510,343.8767,3,8,3); // Infernus

	//Derby
	new DerbyBloodringBanger_1 = CreateVehicle(504,-1355.5416,936.6710,1036.1837,11.4329,1,1,3); // BloodringBanger
	new DerbyBloodringBanger_2 = CreateVehicle(504,-1350.6061,937.5493,1036.1947,12.4710,1,1,3); // BloodringBanger
	new DerbyBloodringBanger_3 = CreateVehicle(504,-1345.6512,938.5836,1036.2046,13.2675,1,1,3); // BloodringBanger
	new DerbyBloodringBanger_4 = CreateVehicle(504,-1340.6078,939.9857,1036.2150,17.2391,1,1,3); // BloodringBanger
	new DerbyBloodringBanger_5 = CreateVehicle(504,-1336.7312,941.1116,1036.2316,17.4418,1,1,3); // BloodringBanger
	new DerbyBloodringBanger_6 = CreateVehicle(504,-1331.5814,942.9241,1036.2539,20.6521,1,1,3); // BloodringBanger
    LinkVehicleToInterior(DerbyBloodringBanger_1,15);
    LinkVehicleToInterior(DerbyBloodringBanger_2,15);
    LinkVehicleToInterior(DerbyBloodringBanger_3,15);
    LinkVehicleToInterior(DerbyBloodringBanger_4,15);
    LinkVehicleToInterior(DerbyBloodringBanger_5,15);
    LinkVehicleToInterior(DerbyBloodringBanger_6,15);

    //Dirt
    new DirtBandito_1 = CreateVehicle(568,-1293.6066,-699.9584,1056.1979,32.9697,13,6,3); // Bandito
	new DirtBandito_2 = CreateVehicle(568,-1290.6547,-705.1854,1055.9683,25.9573,13,6,3); // Bandito
	new DirtBandito_3 = CreateVehicle(568,-1288.5525,-710.9236,1055.3217,13.2351,13,6,3); // Bandito
	new DirtBandito_4 = CreateVehicle(568,-1288.0195,-716.4835,1054.2349,1.8518,13,6,3); // Bandito
	new DirtBandito_5 = CreateVehicle(568,-1288.5397,-722.2761,1052.8531,350.2811,13,6,3); // Bandito
	new DirtBandito_6 = CreateVehicle(568,-1290.4360,-727.0573,1051.5167,336.0467,13,6,3); // Bandito
    LinkVehicleToInterior(DirtBandito_1,4);
    LinkVehicleToInterior(DirtBandito_2,4);
    LinkVehicleToInterior(DirtBandito_3,4);
    LinkVehicleToInterior(DirtBandito_4,4);
    LinkVehicleToInterior(DirtBandito_5,4);
    LinkVehicleToInterior(DirtBandito_6,4);

    //LSTower
    CreateVehicle(522,1542.9153,-1361.9492,1882.5000,0.2570,3,6,3); // NRG500
	CreateVehicle(522,1544.7842,-1361.9364,1882.5000,0.2723,13,6,3); // NRG500
	CreateVehicle(522,1546.7435,-1361.9312,1882.5000,0.1157,14,36,3); // NRG500
	CreateVehicle(471,1548.6028,-1362.0868,1882.5000,0.0529,8,8,3); // Quad
	CreateVehicle(481,1550.7400,-1362.1753,1882.5000,359.2753,3,3,3); // Bike
/*
	//BMX parcour
	CreateVehicle(481,1476.9919,-1338.6411,163.2708,0.2596,3,3,3); // BMX
	CreateVehicle(481,1477.0149,-1343.7705,163.2730,0.2592,3,3,3); // BMX
	CreateVehicle(481,1477.0446,-1350.3536,163.2730,0.2587,3,3,3); // BMX
	CreateVehicle(481,1477.0658,-1355.1390,163.2703,0.2586,3,3,3); // BMX
	CreateVehicle(481,1473.3104,-1339.4039,163.2732,1.1025,3,3,3); // BMX
	CreateVehicle(481,1473.3867,-1344.0424,163.2718,1.5603,3,3,3); // BMX
	CreateVehicle(481,1473.1559,-1350.3209,163.2709,357.5236,3,3,3); // BMX
	CreateVehicle(481,1472.9701,-1355.1122,163.2715,357.3077,3,3,3); // BMX

	//Wallride
	CreateVehicle(411,3436.8467,-2982.8782,3.2360,269.6635,3,8,3); // Infernus
	CreateVehicle(411,3448.6406,-2982.9480,3.2360,269.6636,8,8,3); // Infernus
	CreateVehicle(411,3460.4634,-2983.0173,3.2360,269.6636,25,8,3); // Infernus
	CreateVehicle(411,3436.3914,-2977.1589,3.2360,269.2260,1,8,3); // Infernus
	CreateVehicle(411,3448.2656,-2977.3193,3.2360,269.2261,6,8,3); // Infernus
	CreateVehicle(411,3459.6987,-2977.4734,3.2360,269.2262,0,8,3); // Infernus
*/
	//UpsideDown
	godcar[0] = CreateVehicle(411,361.7381,-80.0696,558.1525,269.7961,8,8,3); // Infernus
	godcar[1] = CreateVehicle(411,372.4498,-80.1074,558.1525,269.7960,3,8,3); // Infernus
	godcar[2] = CreateVehicle(411,383.7889,-80.1475,558.1524,269.7958,25,8,3); // Infernus
	godcar[3] = CreateVehicle(411,361.0311,-85.0374,558.1525,269.1889,3,8,3); // Infernus
	godcar[4] = CreateVehicle(411,373.0689,-85.2083,558.1524,269.1889,6,8,3); // Infernus
	godcar[5] = CreateVehicle(411,384.1176,-85.3655,558.1525,269.1888,0,8,3); // Infernus
/*
	//WayToPiramide
	CreateVehicle(411,2904.7983,1280.5787,730.8865,89.1978,8,8,3); // Infernus
	CreateVehicle(411,2916.9636,1280.4061,730.8862,89.2190,3,8,3); // Infernus
	CreateVehicle(411,2928.0603,1280.2548,730.8865,89.2190,25,8,3); // Infernus
	CreateVehicle(411,2904.8154,1286.7122,730.8865,89.1773,3,8,3); // Infernus
	CreateVehicle(411,2917.1157,1286.5358,730.8865,89.1772,6,8,3); // Infernus
	CreateVehicle(411,2928.4797,1286.3727,730.8865,89.1773,0,8,3); // Infernus

	//NRGParcour
	CreateVehicle(522,2547.8071,-1422.5461,34.2271,301.8492,75,3,3); // NRG500
	CreateVehicle(522,2547.6770,-1418.8695,34.2218,304.8332,25,8,3); // NRG500
	CreateVehicle(522,2547.6257,-1415.7194,34.2264,310.1420,3,3,3); // NRG500
	CreateVehicle(522,2556.7825,-1422.5698,34.2194,40.7899,3,8,3); // NRG500
	CreateVehicle(522,2556.7527,-1418.7662,34.2164,51.4718,6,25,3); // NRG500
	CreateVehicle(522,2556.8594,-1415.3621,34.2164,45.3183,7,79,3); // NRG500

	//VehicleDM
	CreateVehicle(549,2020.6902,-9.1175,4.3787,177.5271,75,39,3); // Tampa
	CreateVehicle(549,2015.5114,-9.1137,4.5761,177.3597,79,39,3); // Tampa
	CreateVehicle(549,2009.8499,-8.7168,4.8797,178.1080,84,36,3); // Tampa
	CreateVehicle(549,2004.3615,-8.9756,5.0198,185.4335,89,35,3); // Tampa
	CreateVehicle(549,1998.9812,-9.4923,4.8957,185.6522,91,35,3); // Tampa
	CreateVehicle(549,1993.6329,-10.2809,4.8639,186.1352,74,39,3); // Tampa
	CreateVehicle(549,1987.9531,-10.9310,5.0455,185.4410,72,39,3); // Tampa
	CreateVehicle(549,1982.0514,-11.8822,5.1414,188.1196,75,39,3); // Tampa
	CreateVehicle(549,1975.6677,-12.5671,4.6499,190.9174,79,39,3); // Tampa
	CreateVehicle(549,2026.2301,-9.2869,4.2389,176.3276,83,36,3); // Tampa
*/
    //Trucks Trailers Desert
	CreateVehicle(403,589.5732,1641.4329,8.0110,67.2445,63,78,3); // truck
	CreateVehicle(514,615.0411,1661.2557,8.0104,66.3040,42,76,3); // truck
	CreateVehicle(515,601.5678,1652.1042,8.0128,66.3440,54,77,3); // truck
	CreateVehicle(515,599.7117,1647.4720,8.0049,66.2765,11,76,3); // truck
	CreateVehicle(435,577.5303,1688.5854,8.0108,213.0995,62,77,3); // trailer
	CreateVehicle(450,570.0672,1681.6031,8.0109,211.7866,13,76,3); // trailer
	CreateVehicle(584,559.1253,1677.6910,8.0024,206.1914,24,77,3); // trailer
	CreateVehicle(591,564.7803,1650.4573,8.0143,301.0595,63,78,3); // trailer

	// Trucks Trailers between ls-sf
	CreateVehicle(403,-1530.0437,-2749.1221,49.5619,169.2255,42,76,3); // truck
	CreateVehicle(514,-1544.2373,-2742.8245,49.5714,171.1137,54,77,3); // truck
	CreateVehicle(515,-1539.6406,-2743.1909,49.5556,169.5909,39,78,3); // truck
	CreateVehicle(515,-1534.4974,-2747.0996,49.5616,168.5136,11,76,3); // truck
	CreateVehicle(515,-1525.1152,-2750.4939,49.5696,170.1318,62,77,3); // truck
	CreateVehicle(435,-1636.9539,-2689.7542,49.5800,139.7800,13,76,3); // trailer
	CreateVehicle(450,-1642.3376,-2686.2280,49.5660,145.2747,24,77,3); // trailer
	CreateVehicle(584,-1647.5023,-2683.5273,49.5872,149.4576,63,78,3); // trailer
	CreateVehicle(591,-1655.1350,-2679.0842,49.6174,147.8293,42,76,3); // trailer
	CreateVehicle(591,-1664.6355,-2679.3091,49.6397,144.4319,54,77,3); // trailer

	//Trucks Trailers Chilliad
	CreateVehicle(403,-312.7195,1747.0007,43.8187,90.2980,39,78,3); // truck
	CreateVehicle(514,-312.1573,1752.0322,43.7824,86.1870,11,76,3); // truck
	CreateVehicle(515,-312.0642,1758.1394,43.7929,88.3385,62,77,3); // truck
	CreateVehicle(515,-303.6572,1725.4978,43.9098,0.4617,39,78,3); // truck
	CreateVehicle(515,-293.9561,1726.9170,43.9183,6.3107,11,76,3); // truck
	CreateVehicle(435,-287.4422,1746.8706,43.9680,88.6359,13,76,3); // trailer
	CreateVehicle(450,-287.6318,1751.5023,44.0399,88.8039,24,77,3); // trailer
	CreateVehicle(584,-288.0557,1757.1816,43.9575,88.6184,63,78,3); // trailer
	CreateVehicle(591,-289.9828,1789.9430,43.8738,178.2693,42,76,3); // trailer
	CreateVehicle(591,-298.0738,1788.9760,43.8326,181.3430,54,77,3); // trailer

	//RC War
	new RCWarCar_1 = CreateVehicle(464,-1133.0215,1030.2168,1345.0315,271.6719,14,75,3); // Baron
	new RCWarCar_2 = CreateVehicle(464,-1133.2302,1027.8629,1345.0304,270.6061,14,75,3); // Baron
	new RCWarCar_3 = CreateVehicle(464,-1130.5699,1027.8213,1345.0131,272.9121,14,75,3); // Baron
	new RCWarCar_4 = CreateVehicle(464,-1130.4882,1030.2493,1345.0162,269.2135,14,75,3); // Baron
	new RCWarCar_5 = CreateVehicle(464,-1128.1396,1027.9340,1345.0026,270.3515,14,75,3); // Baron
	new RCWarCar_6 = CreateVehicle(464,-1128.1316,1030.2913,1345.0017,269.7841,14,75,3); // Baron
	new RCWarCar_7 = CreateVehicle(464,-1125.8781,1030.2914,1344.9885,270.9232,14,75,3); // Baron
	new RCWarCar_8 = CreateVehicle(464,-1125.8718,1027.9491,1344.9882,267.8098,14,75,3); // Baron
	new RCWarCar_9 = CreateVehicle(501,-1133.1169,1042.7013,1345.2675,273.8671,14,75,3); // Goblin
	new RCWarCar_10 = CreateVehicle(501,-1133.0339,1040.7697,1345.2501,272.7063,14,75,3); // Goblin
	new RCWarCar_11 = CreateVehicle(501,-1130.0284,1040.6913,1345.2063,271.9564,14,75,3); // Goblin
	new RCWarCar_12 = CreateVehicle(501,-1129.9369,1042.6572,1345.2371,274.4154,14,75,3); // Goblin
	new RCWarCar_13 = CreateVehicle(564,-1132.1053,1057.8380,1345.5826,269.6947,0,0,3); // Tiger
	new RCWarCar_14 = CreateVehicle(564,-1129.5297,1057.8292,1345.5835,269.8691,0,0,3); // Tiger
	new RCWarCar_15 = CreateVehicle(441,-1134.7843,1038.3818,1344.8730,226.6530,79,42,3); // Bandit
	new RCWarCar_16 = CreateVehicle(441,-1128.2644,1038.5522,1344.8311,224.6958,79,42,3); // Bandit
	new RCWarCar_17 = CreateVehicle(594,-1125.7714,1053.2950,1344.8958,165.9683,0,0,3); // RC Cam
	new RCWarCar_18 = CreateVehicle(594,-1125.9305,1052.1727,1344.8954,169.6070,0,0,3); // RC Cam
	new RCWarCar_19 = CreateVehicle(594,-1131.6476,1054.9731,1344.9418,198.3954,0,0,3); // RC Cam
	new RCWarCar_20 = CreateVehicle(564,-1136.3162,1019.0483,1358.0835,270.5313,0,0,3); // Tiger (watch rcwar)
	new RCWarCar_21 = CreateVehicle(564,-1130.9722,1019.0976,1358.0835,270.5307,0,0,3); // Tiger (watch rcwar)
	new RCWarCar_22 = CreateVehicle(564,-1126.4869,1019.1389,1358.0835,270.5305,0,0,3); // Tiger (watch rcwar)
	new RCWarCar_23 = CreateVehicle(564,-1122.3527,1019.1770,1358.0835,270.5303,0,0,3); // Tiger (watch rcwar)
	new RCWarCar_24 = CreateVehicle(564,-1117.7897,1019.2189,1358.0835,270.5296,0,0,3); // Tiger (watch rcwar)
	LinkVehicleToInterior(RCWarCar_1,10);
    LinkVehicleToInterior(RCWarCar_2,10);
    LinkVehicleToInterior(RCWarCar_3,10);
    LinkVehicleToInterior(RCWarCar_4,10);
    LinkVehicleToInterior(RCWarCar_5,10);
    LinkVehicleToInterior(RCWarCar_6,10);
    LinkVehicleToInterior(RCWarCar_7,10);
    LinkVehicleToInterior(RCWarCar_8,10);
    LinkVehicleToInterior(RCWarCar_9,10);
    LinkVehicleToInterior(RCWarCar_10,10);
    LinkVehicleToInterior(RCWarCar_11,10);
    LinkVehicleToInterior(RCWarCar_12,10);
    LinkVehicleToInterior(RCWarCar_13,10);
    LinkVehicleToInterior(RCWarCar_14,10);
    LinkVehicleToInterior(RCWarCar_15,10);
    LinkVehicleToInterior(RCWarCar_16,10);
    LinkVehicleToInterior(RCWarCar_17,10);
    LinkVehicleToInterior(RCWarCar_18,10);
    LinkVehicleToInterior(RCWarCar_19,10);
    LinkVehicleToInterior(RCWarCar_20,10);
    LinkVehicleToInterior(RCWarCar_21,10);
    LinkVehicleToInterior(RCWarCar_22,10);
    LinkVehicleToInterior(RCWarCar_23,10);
    LinkVehicleToInterior(RCWarCar_24,10);
/*
	//RoofStunt
	CreateVehicle(522,-1777.0610,569.8040,234.4501,0.0000,75,3,3); // NRG500
	CreateVehicle(522,-1779.0438,569.7948,234.4603,0.0000,3,3,3); // NRG500
	CreateVehicle(522,-1781.1830,569.8126,234.4572,0.0000,3,8,3); // NRG500
	CreateVehicle(522,-1783.5983,569.7300,234.4579,0.0000,6,25,3); // NRG500
	CreateVehicle(522,-1786.0320,569.7380,234.4584,0.0000,7,79,3); // NRG500
	CreateVehicle(522,-1788.9299,569.7837,234.4672,0.0000,8,82,3); // NRG500
	CreateVehicle(522,-2061.3796,417.4252,172.2498,308.4095,51,118,3); // nrg1
	CreateVehicle(423,-2019.1400,408.0430,170.4153,318.9810,1,56,3); // mrwhoopee
*/
	//AquaPark
	CreateVehicle(493,253.6098,-1917.8197,-0.1049,180.9621,36,13,3); // Jetmax
	CreateVehicle(493,264.7177,-1917.2307,-0.1223,181.6459,36,13,3); // Jetmax
	CreateVehicle(493,275.6197,-1917.8173,-0.0792,180.5575,36,13,3); // Jetmax
	CreateVehicle(493,286.7505,-1917.6251,-0.1524,180.8557,36,13,3); // Jetmax

	//PinkAutos
	CreateVehicle(402,-1648.2094,1206.9729,20.9857,32.9559,183,183,3); // Buffalo
	CreateVehicle(409,-1677.8883,1208.4282,20.9552,191.8886,183,183,3); // Stretch
	CreateVehicle(411,-1665.9705,1223.5477,20.8814,276.1471,183,183,3); // Infernus
	CreateVehicle(415,-1668.4225,1207.0657,7.0249,328.7874,183,183,3); // Cheetah
	CreateVehicle(424,-1679.2052,1209.5154,13.4533,189.3708,183,183,3); // VF Injection
	CreateVehicle(429,-1666.5470,1216.3236,6.9322,266.6216,183,183,3); // Banshee
	CreateVehicle(439,-1666.0359,1222.8752,13.5741,298.0829,183,183,3); // Stallion
	CreateVehicle(451,-1647.1544,1208.6823,13.3807,44.0297,183,183,3); // Turismo
	CreateVehicle(457,-1672.5985,1203.9265,13.2989,307.6741,183,183,3); // Caddy
	CreateVehicle(463,-1655.4954,1213.1014,6.7903,252.1276,183,183,3); // Freeway
	CreateVehicle(471,-1663.7513,1217.0160,20.6376,221.1990,183,183,3); // Quad
	CreateVehicle(480,-1656.4436,1206.0363,20.9279,359.9778,183,183,3); // Comet
	CreateVehicle(481,-1664.5815,1203.8479,20.6710,293.3592,183,183,3); // BMX
	CreateVehicle(587,-1657.5812,1216.0446,13.2969,174.4137,183,183,3); // Bullet
	CreateVehicle(571,-1653.4127,1208.1293,12.9556,358.8818,183,183,3); // Kart

	/*//TheBigEar //改装车
	Uranus1 = CreateVehicle(558,-277.5457,1554.9353,74.9893,135.3808,1,1,5000000); // Uranus1
	Elegy1 = CreateVehicle(562,-292.2572,1570.3337,75.0179,134.0872,3,1,5000000); // Elegy1
	Sultan1 = CreateVehicle(560,-267.3997,1545.5481,75.0641,135.6898,3,3,5000000); // Sultan1
	Flash1 = CreateVehicle(565,-1955.0964,300.5177,40.6717,210.7124,3,3,5000000); // Flash1

	//WangCars
	Uranus2 = CreateVehicle(558,-1957.2041,302.9585,35.0991,209.5401,1,0,5000000); // Uranus2
	Elegy2 = CreateVehicle(562,-1953.7189,260.4280,35.1341,29.8439,1,0,5000000); // Elegy2
	Sultan2 = CreateVehicle(560,-1951.1063,261.3863,40.7554,62.4588,3,3,5000000); // Sultan2
*/
	TuneCar();
/*
	//RollerCoaster
	CreateVehicle(411,1997.8422,913.0474,275.5166,359.6921,3,3,3); // Infernus
	CreateVehicle(411,1992.4362,912.9705,275.5031,0.8426,123,1,3); // Infernus
	CreateVehicle(411,1997.8890,920.3556,274.8559,359.6958,6,8,3); // Infernus
	CreateVehicle(411,1992.3386,920.4049,274.8465,0.4298,1,1,3); // Infernus
	CreateVehicle(411,1997.9404,928.0737,274.1606,359.7232,14,75,3); // Infernus
	CreateVehicle(411,1992.2285,927.9800,274.1488,0.8424,0,0,3); // Infernus
*/
	//Hideout
	CreateVehicle(471,-1422.3180,-958.2870,200.4387,288.8148,8,8,3); // Quad
	CreateVehicle(522,-1430.6462,-951.4463,200.5453,249.7544,7,79,3); // NRG500
	CreateVehicle(568,-1438.6173,-957.9554,200.9465,341.9563,13,6,3); // Bandito
/*
	//Quad Parcour
    CreateVehicle(471,167.7697,-1779.4790,3.5897,177.4954,3,6,3); // Quad
    CreateVehicle(471,169.3234,-1779.5200,3.5587,179.8252,3,6,3); // Quad
    CreateVehicle(471,170.8247,-1779.4702,3.5279,180.3918,3,6,3); // Quad
    CreateVehicle(471,172.3113,-1779.3582,3.4978,178.1304,3,6,3); // Quad

	//Bounce
	CreateVehicle(573,2962.9189,-2722.1758,9.2444,271.1053,1,1,3); // Dune
	CreateVehicle(573,2963.1804,-2727.3066,9.2444,271.8739,32,36,3); // Dune
	CreateVehicle(573,2973.5396,-2715.5276,9.2444,179.4737,32,42,3); // Dune
	CreateVehicle(573,2968.5759,-2715.5562,9.2444,180.5176,32,53,3); // Dune

	//CarSumo
	CreateVehicle(444,-2321.1121,4077.1799,12.1021,129.9671,32,36,3); // Monster
	CreateVehicle(444,-2320.9128,4067.0977,12.1021,128.1576,32,42,3); // Monster
	CreateVehicle(444,-2319.9124,4057.9626,12.1021,126.1516,32,53,3); // Monster
	CreateVehicle(444,-2346.8374,4076.7551,12.1021,224.3804,32,66,3); // Monster
	CreateVehicle(444,-2346.8440,4065.4429,12.1021,226.2487,32,14,3); // Monster
	CreateVehicle(444,-2347.0044,4056.6926,12.1021,230.8101,32,32,3); // Monster
	CreateVehicle(444,-2318.8455,4047.4314,12.1021,89.6349,32,36,3); // Monster
	CreateVehicle(444,-2348.1597,4046.9055,12.1021,269.3230,32,42,3); // Monster
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	AddStaticPickup( 356,2,-1691.5090,-622.8165 , 25.2852); //M4
	AddStaticPickup( 371,2,-1503.2556,-280.6740 ,  5.9636); //para
	AddStaticPickup(1242,2,-1395.8342,-388.3391 ,  5.9625); //Armour
	AddStaticPickup( 346,2,-1541.6980,-443.0907 ,  9.5150); //Pistol
	AddStaticPickup( 347,2,-1130.5966,-152.7168 , 14.1440); //Silenced Pistol
	AddStaticPickup( 346,2,-1093.7841,  20.4454 , 25.7975); //Pistol
	AddStaticPickup(1242,2,-1229.2015,  52.6138 , 17.6478); //Armour
	AddStaticPickup(1242,2,-1178.3361, 314.5787 , 24.4956); //Armour
	AddStaticPickup( 347,2,-1343.0063, 440.6138 ,  7.1875); //Silenced Pistol
	AddStaticPickup(1242,2,-1411.9882, 289.9836 ,  1.1774); //Armour
	AddStaticPickup( 352,2,-1731.1630, 264.5959 ,  7.1875); //Mac-10
	AddStaticPickup( 355,2,-1400.1371, 491.8791 ,  5.2717); //AK
	AddStaticPickup(1242,2,-1370.5365, 495.9445 ,  3.0444); //Armour
	AddStaticPickup(1242,2,-1290.0255, 512.4467 , 11.1953); //Armour
	AddStaticPickup( 356,2,-1478.1819,  45.6533 ,  6.0000); //M4
	AddStaticPickup( 355,2,-1333.7920,-161.6918 ,  6.0000); //AK
	AddStaticPickup( 371,2,-1393.4803,-372.5534 ,  6.0000); //para
	AddStaticPickup(1242,2,  414.9057, 2537.4790, 19.1484); // armour
	AddStaticPickup( 371,2,  423.3712, 2539.8440, 16.5090); // parachute
	AddStaticPickup( 352,2,  357.2047, 2433.9873, 17.1786); //Mac-10

	//ShipMadness
	AddStaticPickup(1242,2,-2457.2903,1529.6331,28.9464); //Armour
	AddStaticPickup(1242,2,-2424.7964,1534.7565, 2.1172); //Armour
	AddStaticPickup(1242,2,-2301.4358,1544.9629,18.7734); //Armour
	AddStaticPickup(1240,2,-2354.2424,1532.1775,23.1406); //Health
	AddStaticPickup(1240,2,-2422.2358,1547.9761,23.1406); //Health
	AddStaticPickup( 353,2,-2373.4268,1560.0848,31.8594); //SMG
	AddStaticPickup( 353,2,-2373.4268,1560.0848,31.8594); //SMG
	AddStaticPickup( 353,2,-2373.4268,1560.0848,31.8594); //SMG
	AddStaticPickup( 339,2,-2420.0786,1535.5396,31.8594); //Katana
	AddStaticPickup( 357,2,-2475.1589,1554.4774,33.2344); //Rifle
	AddStaticPickup( 341,2,-2370.0200,1533.6345,10.8209); //Chainsaw

	//MinigunMadness
	AddStaticPickup(1240,2,2631.7134,2728.0288,33.9783); //Health
	AddStaticPickup(1240,2,2672.4402,2767.8203,17.6896); //Health
	AddStaticPickup(1242,2,2645.3669,2696.2966,25.8222); //Armour
	AddStaticPickup(1242,2,2655.3223,2751.0715,19.3222); //Armour
	AddStaticPickup(1242,2,2607.1814,2802.0842,23.4219); //Armour
/*
	//IslandDM
	AddStaticPickup(1240,2,3738.0708,-1914.8334,-2.0512); //Health
	AddStaticPickup(1242,2,3683.6326,-1822.5408,30.3112); //Armour
	AddStaticPickup(1242,2,3829.9885,-1858.6766,25.4707); //Armour
	AddStaticPickup( 353,2,3661.4836,-1861.9702,26.6000); //SMG
	AddStaticPickup( 353,2,3661.4836,-1861.9702,26.6000); //SMG
	AddStaticPickup( 353,2,3661.4836,-1861.9702,26.6000); //SMG
	AddStaticPickup( 353,2,3840.8591,-1932.3560,16.5868); //SMG
	AddStaticPickup( 353,2,3840.8591,-1932.3560,16.5868); //SMG
	AddStaticPickup( 353,2,3840.8591,-1932.3560,16.5868); //SMG
	AddStaticPickup( 347,2,3819.7971,-1926.9595,13.3730); //Silenced 9mm
	AddStaticPickup( 347,2,3819.7971,-1926.9595,13.3730); //Silenced 9mm
	AddStaticPickup( 347,2,3819.7971,-1926.9595,13.3730); //Silenced 9mm
	AddStaticPickup( 347,2,3819.7971,-1926.9595,13.3730); //Silenced 9mm
	AddStaticPickup( 347,2,3819.7971,-1926.9595,13.3730); //Silenced 9mm
*/
	//AdminCastle
	AddStaticPickup(1240,2,-3373.9714,-60.8901,123.2556); //Health
	AddStaticPickup(1240,2,-3652.2251,-293.3300, 5.2009); //Health
	AddStaticPickup(1242,2,-3373.9248,-78.3355,123.2556); //Armour
	AddStaticPickup(1242,2,-3649.0417,-295.4399, 5.2009); //Armour
	AddStaticPickup( 359,2,-3338.4956,-57.7965,125.7631); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4956,-57.7965,125.7631); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4956,-57.7965,125.7631); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4956,-57.7965,125.7631); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4626,-81.9361,125.7681); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4626,-81.9361,125.7681); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4626,-81.9361,125.7681); //RocketLauncher
	AddStaticPickup( 359,2,-3338.4626,-81.9361,125.7681); //RocketLauncher
	AddStaticPickup( 359,2,-3332.5994,-82.2888, 11.3304); //RocketLauncher
	AddStaticPickup( 359,2,-3332.5994,-82.2888, 11.3304); //RocketLauncher
	AddStaticPickup( 359,2,-3332.5994,-82.2888, 11.3304); //RocketLauncher
	AddStaticPickup( 359,2,-3332.5994,-82.2888, 11.3304); //RocketLauncher
	AddStaticPickup( 359,2,-3694.3032,-261.1351, 5.1845); //RocketLauncher
	AddStaticPickup( 359,2,-3694.3032,-261.1351, 5.1845); //RocketLauncher
	AddStaticPickup( 359,2,-3694.3032,-261.1351, 5.1845); //RocketLauncher
	AddStaticPickup( 359,2,-3694.3032,-261.1351, 5.1845); //RocketLauncher
	AddStaticPickup( 360,2,-3336.1716,-69.2330,123.2556); //DoelZoekendeRocketLauncher
	AddStaticPickup( 360,2,-3336.1716,-69.2330,123.2556); //DoelZoekendeRocketLauncher
	AddStaticPickup( 360,2,-3336.1716,-69.2330,123.2556); //DoelZoekendeRocketLauncher
	AddStaticPickup( 360,2,-3336.1716,-69.2330,123.2556); //DoelZoekendeRocketLauncher
	AddStaticPickup( 362,2,-3331.8752,-76.1426, 14.5178); //Minigun
	AddStaticPickup( 362,2,-3608.9607,-202.6079, 2.1616); //Minigun
	AddStaticPickup( 356,2,-3332.0691,-61.0759, 14.5083); //M4
	AddStaticPickup(356,2,-3346.6980,-110.7655,123.2556); //M4
	AddStaticPickup( 353,2,-3298.6104,-163.3751, 2.2084); //SMG
	AddStaticPickup( 346,2,-3268.8552, -93.0790, 2.6945); //Pistol
	AddStaticPickup( 358,2,-3346.9978,-29.0000,123.2556); //Sniper
	AddStaticPickup( 344,2,-3373.7732,-69.7963,128.0510); //Molotov Cocktail
	AddStaticPickup( 344,2,-3373.7732,-69.7963,128.0510); //Molotov Cocktail
	AddStaticPickup(361,2,-3384.6118,-103.7552,123.2556); //Flamethrower
	AddStaticPickup(361,2,-3384.6118,-103.7552,123.2556); //Flamethrower
	AddStaticPickup(361,2,-3384.6118,-103.7552,123.2556); //Flamethrower
	AddStaticPickup(361,2,-3384.6118,-103.7552,123.2556); //Flamethrower
	AddStaticPickup(361,2,-3384.6118,-103.7552,123.2556); //Flamethrower
	AddStaticPickup( 371,2,-3384.2173,-36.2443,123.2556); //para
	AddStaticPickup( 370,2,-3349.7585,-78.0882,123.2556); //JetPack

	//Hideout
	AddStaticPickup(1240,2,-1431.1019,-960.7460,204.1925); //Health
	AddStaticPickup(1242,2,-1425.2542,-966.5264,200.8284); //Armour
	AddStaticPickup(350 ,2,-1429.6626,-966.2491,200.9092); //Sawnoff
    AddStaticPickup(353 ,2,-1431.9618,-966.3460,200.9513); //SMG
	AddStaticPickup(358 ,2,-1433.2585,-960.4415,204.1713); //Sniper
	AddStaticPickup(365 ,2,-1435.0411,-961.2493,201.0102); //Spraycan
	AddStaticPickup(361 ,2,-1430.6377,-958.7066,200.9308); //Flamethrower
	AddStaticPickup(359 ,2,-1434.3942,-963.4763,205.5079); //Rocketlauncher
	AddStaticPickup(348 ,2,-1429.1188,-961.2695,200.9017); //Desert eagle

    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnGameModeExit()
{
	Seifader_OnExit();

	GangZoneDestroy(DragRaceGangZoneBlack);
	GangZoneDestroy(DragRaceGangZoneWhite1);
	GangZoneDestroy(DragRaceGangZoneWhite2);
	GangZoneDestroy(BuildingJumpGangZone);
	GangZoneDestroy(BuildingJumpGangZoneKicker);
	GangZoneDestroy(AdminCastleGangZone1);
	GangZoneDestroy(AdminCastleGangZone2);
	GangZoneDestroy(GlassMadnessGangZone1);
	GangZoneDestroy(GlassMadnessGangZone2);
	GangZoneDestroy(GlassMadnessGangZone3);

	DestroyMenu(SpawnplaceMenu);
	DestroyMenu(Teleports);
	DestroyMenu(StuntZones1);
	DestroyMenu(StuntZones2);
	DestroyMenu(StuntZones3);
	DestroyMenu(DMZones);
	DestroyMenu(TuneGarages);
	DestroyMenu(TrainStations);
	DestroyMenu(TruckStops);
	DestroyMenu(OtherZones1);
	DestroyMenu(OtherZones2);

	CPS_RemoveCheckpoint(1);
	CPS_RemoveCheckpoint(2);
	CPS_RemoveCheckpoint(3);
	CPS_RemoveCheckpoint(4);
	CPS_RemoveCheckpoint(5);
	CPS_RemoveCheckpoint(6);
	CPS_RemoveCheckpoint(7);
	CPS_RemoveCheckpoint(8);
	CPS_RemoveCheckpoint(9);
	CPS_RemoveCheckpoint(10);
	CPS_RemoveCheckpoint(11);
	CPS_RemoveCheckpoint(12);
	CPS_RemoveCheckpoint(13);
	CPS_RemoveCheckpoint(14);
	CPS_RemoveCheckpoint(15);
	CPS_RemoveCheckpoint(16);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (x > minx && x < maxx && y > miny && y < maxy) return 1;
    return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IsPlayerInInvalidNosVehicle(playerid,vehicleid)
{
    #define MAX_INVALID_NOS_VEHICLES 29
    new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
		581,523,462,521,463,522,461,448,468,586,
		509,481,510,472,473,493,595,484,430,453,
		452,446,454,590,569,537,538,570,449
    };
    vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid))
    {
		for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
		{
	    	if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
	    	{
	        	return true;
	    	}
		}
    }
    return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public DynUpdateStart(playerid) //Shurty40
{
	TogglePlayerControllable(playerid, false);
	new string[255];
	format(string, sizeof(string), "~w~Objects~n~~r~Loading");
	GameTextForPlayer(playerid, string, 3000, 6);
	PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	if(GetPlayerPing(playerid) < 100) { SetTimerEx("DynUpdateEnd", 2000, 0,"e",playerid); }
	else if(GetPlayerPing(playerid) > 100) { SetTimerEx("DynUpdateEnd", 2000, 0,"e",playerid); }
	else if(GetPlayerPing(playerid) > 200) { SetTimerEx("DynUpdateEnd", 2200, 0,"e",playerid); }
	else if(GetPlayerPing(playerid) > 300) { SetTimerEx("DynUpdateEnd", 2700, 0,"e",playerid); }
	else if(GetPlayerPing(playerid) > 500) { SetTimerEx("DynUpdateEnd", 3000, 0,"e",playerid); }
	else { SetTimerEx("DynUpdateEnd", 2700, 0,"e",playerid); }
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public DynUpdateEnd(playerid) //Shurty40
{
	TogglePlayerControllable(playerid, true);
	new string[255];
	format(string, sizeof(string), "~w~Objects~n~~r~Loaded!");
	GameTextForPlayer(playerid, string, 3000, 6);
	PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if (pickupid == Info[0])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Try to reach the other side :P",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[1])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Try to land on your front wheel.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[2])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Don't drive in the middle of the road.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[3])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You may need to drive backwards sometimes.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[4])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can earn money at the end of difficult stunts (/stuntzones).",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[5])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can earn money at the end of difficult stunts (/stuntzones).",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[6])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can earn money at the end of difficult stunts (/stuntzones).",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[7])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can earn money at the end of difficult stunts (/stuntzones).",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[8])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Use /detach to detach a trailer from your truck.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[9])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Use /detach to detach a trailer from your truck.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[10])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Use /detach to detach a trailer from your truck.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[11])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~For a full list of al the commands,~n~use /Commands.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[12])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Take a heavy vehicle (bus, truck, monstertruck,...),~n~fall down and have fun :P",7000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[13])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Only administrators may enter the admincastle.~n~~r~Trying to enter as a non-admin is at your own risk.",7000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[14])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Get to the other side.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[15])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Have a nice ride to hell :D",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[16])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Use /Home to teleport back to this place.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[17])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Here you can watch rcwar from above.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[18])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~Try to kill the other players by using the rc planes (rc baron).~n~the other rc vehicles are just for fun.",7000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Info[19])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can also use /watchrcwar~n~to watch this from above.",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
	}
    if (pickupid == Info[20])
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~A carlot is at /SFAirport",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == Telemenu1)
    {
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You can enter this teleport menu by typing /Teleports",5000,3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
    }
    if (pickupid == pwnt)
    {
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid,"~g~Info:~n~~w~You just got ~r~pwnt~w~!",5000,3);
		SendClientMessage(playerid,COLOR_RED,"陷阱!!!你只剩下两个选择");
		SendClientMessage(playerid,COLOR_RED,"  - 选择 1: /kill 自我了结");
		SendClientMessage(playerid,COLOR_RED,"  - 选择 2: 选择选择 1");
    }
    if (pickupid == stupidjump[0])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[1])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[2])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[3])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[4])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[5])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
    if (pickupid == stupidjump[6])
    {
        new string[128];
        stupidjumpsfound[playerid] = stupidjumpsfound[playerid] + 1;
		if(stupidjumpsfound[playerid] == 7)
		{
        	format(string, sizeof(string),
			"~w~Stupid jumps found:~g~ %i/7~n~~n~~w~you found all the stupid jumps, and receved 100.000$ as reward!"
			, stupidjumpsfound[playerid]);
			F_GivePlayerMoney(playerid, 100000);
		}
		else
		{
        	format(string, sizeof(string), "~w~Stupid jumps found:~g~ %i/7", stupidjumpsfound[playerid]);
        }
 		GameTextForPlayer(playerid, string, 5000, 3);
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerText(playerid,text[])
{
	SpamStrings[playerid] ++;
	if(SpamStrings[playerid] >= MAX_SPAM)
	{
	    new PlayerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
		printf("(previous text of %s was blocked by antispam)", PlayerName);
		SendClientMessage(playerid,0xCC0000AA,"请节约资源,不要刷屏,20 后再发送吧");
		return 0;
	}
    new textstring[128];
    format(textstring, sizeof(textstring), "(%i) %s", playerid, text);//聊天
    SendPlayerMessageToAll(playerid, textstring);
    //SendFormatMessageToAll(GetPlayerColor(playerid),"    %s(%i): %s",ReturnPlayerName(playerid),playerid,text);
	return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public MinSpam() {
	for(new i = 0; i < MAX_PLAYERS; i ++) {
		if(SpamStrings[i] > 0) {
			SpamStrings[i] = 0;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//更改了以后有三处警告
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_SECONDARY_ATTACK )
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			new Float:x, Float:y, Float:z, vehicle;
			GetPlayerPos(playerid, x, y, z );
			GetVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);
			if(IsVehicleToy(vehicle))
			{
			    PutPlayerInVehicle(playerid, vehicle, 0);
			}
		}
		else
		{
			new vehicleID = GetPlayerVehicleID(playerid);
			if(IsVehicleToy(vehicleID))
			{
			    if(GetVehicleModel(vehicleID) != 449)
			    {
			        InCar[playerid] = false;
			    	new Float:x, Float:y, Float:z;
			   	 	GetPlayerPos(playerid, x, y, z);
		    		SetPlayerPos(playerid, x+0.5, y, z+1.0);
				}
			}
		}
	}
	if(newkeys == KEY_FIRE)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(!IsPlayerInInvalidNosVehicle(playerid, GetPlayerVehicleID(playerid)))
		 	{
		 	    if(NitroActive[playerid] == false)
		 	    {
	    			AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
		    		SendClientMessage(playerid,COLOR_BASIC,"NOS: 开启");
				    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
	    			NitroActive[playerid] = true;
				}
				else
				{
				    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		    		SendClientMessage(playerid,COLOR_BASIC,"NOS: 关闭");
				    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	    			NitroActive[playerid] = false;
				}
			}
			else
			{
		 	    SendClientMessage(playerid, COLOR_RED, "乘坐的交通工具不支持NOS");
			}
		}
	}
	if(newkeys == KEY_SUBMISSION)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(IsPlayerInArea(playerid, 1153.0000, 1307.5000, -2107.5000, -2003.5000) == 1)
        	{
        	    SendClientMessage(playerid,COLOR_RED,"车辆不能修复,因为你身处 /BloodringArena");
        	}
        	else
        	{
            	SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
            	SendClientMessage(playerid,COLOR_BASIC,"交通工具已修复完毕");
            	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        	}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GetVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh)
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i) > 0)
		{
			if(GetPlayerVehicleID(playerid) != i )
			{
	        	new Float:x, Float:y, Float:z;
	        	new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
				new Float:vDist = (x2*x2+y2*y2+z2*z2);
				if( vDist < dist)
				{
					veh = i;
					dist = vDist;
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IsVehicleToy( vehicleid )
{
    new model = GetVehicleModel(vehicleid),
	bool:result;
    switch(model)
    {
        case 435,441,449,450,464,465,569,570,501,564,584,590,591,594,606,607,610,611 : result = true;
        default : result = false;
    }

    return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerEnterCheckpoint(playerid)
{
	new cpid = CPS_GetPlayerCheckpoint(playerid);

	if (cpid == 1)
	{
	    InCar[playerid] = false;
		SetPlayerPos(playerid,-3362.3279,-75.2242,123.2506);
  		SetPlayerFacingAngle(playerid,314.4937);
		SetCameraBehindPlayer(playerid);
	}
	if (cpid == 2)
	{
	    InCar[playerid] = false;
		SetPlayerPos(playerid,-3329.1367,-76.0668,14.7320);
  		SetPlayerFacingAngle(playerid,297.2369);
		SetCameraBehindPlayer(playerid);
	}
	if (cpid == 3)
	{
	    InCar[playerid] = false;
		SetPlayerPos(playerid,1570.9198,-1334.3802,16.4844);
  		SetPlayerFacingAngle(playerid,328.4369);
		SetCameraBehindPlayer(playerid);
	}
	if (cpid == 4)
	{
	    InCar[playerid] = false;
		SetPlayerPos(playerid,1545.3409,-1366.1580,1880.9000);
  		SetPlayerFacingAngle(playerid,89.6141);
		SetCameraBehindPlayer(playerid);
	}
	if (cpid >= 5)
	{
		GameTextForPlayer(playerid,"~w~you earned ~r~$1000~w~.",1000,4);
		F_GivePlayerMoney(playerid, 1000);
		CPS_RemoveCheckpoint(cpid);
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:CurrentMenu = GetPlayerMenu(playerid);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == Teleports)
	{
    	switch(row)
    	{
        	case 0: //Stunt zones 1
        	{
            	ShowMenuForPlayer(StuntZones1, playerid);
			}
        	case 1: //Stunt zones 2
        	{
            	ShowMenuForPlayer(StuntZones2, playerid);
			}
        	case 2: //Stunt zones 3
        	{
            	ShowMenuForPlayer(StuntZones3, playerid);
			}
        	case 3: //DMZones
        	{
            	ShowMenuForPlayer(DMZones, playerid);
			}
        	case 4: //OtherZones1
        	{
				ShowMenuForPlayer(OtherZones1, playerid);
			}
        	case 5: //OtherZones2
        	{
				ShowMenuForPlayer(OtherZones2, playerid);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == StuntZones1)
	{
    	switch(row)
    	{
        	case 0: //BigJump
        	{
        	    NormalTele(playerid, "BigJump",		-594.1223,904.4135,432.5000,	135.0000,	-594.1223,904.4135,432.5000,	135.0000,	0);
			}
			case 1: //BigJump2
        	{
			    NormalTele(playerid, "BigJump2",	-639.9559,2328.1963,135.0000,	180.000,	-662.6028,2306.1809,136.0709,	90.0000,	0);
			}
			case 2: //LSTower
        	{
			    NormalTele(playerid, "LSTower",		1537.1813,-1364.6439,1882.5000,	341.3670,	1541.3605,-1363.4252,1882.5000,	0.0000,		0);
			}
			case 3: //BuildingJump
        	{
			    SpeceficTele(playerid, "BuildingJump",-2882.8174,-3074.8611,83.0000,   180.0000,   -2882.8174,-3074.8611,81.0000,   180.0000,   0,   461);
			}
			case 4: //Chilliad
        	{
				NormalTele(playerid, "Chilliad", -2338.1836, -1631.0298, 483.7010, 244.0000, -2334.8801, -1646.7010, 483.7031, 23.0000, 0);
			}
			case 5: //WayOfGod
        	{
        	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "WayOfGod", 239.2802, 1561.3365, 586.2000, 74.9583, 283.7652, 1541.8972, 585.7000, 61.3804, 0);
			}
			case 6: //Wall Ride
        	{
			    SpeceficTele(playerid, "Wallride",-803.5533,1833.4768,7.0000,   90.0000,   -803.5533,1833.4768,7.0000,   90.0000,   0,   522);
        	}
			case 7: //Wall Ride 2
        	{
        	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "Wallride2",3468.2820,-2980.2456,3.2360,   270.0000,   3428.8757,-2977.2693,3.50905,   250.0000,   0,   411);
        	}
        	case 8: //LVAirport
        	{
		  		OnlyPlayerTele(playerid, "LVAirport",   1299.8621,1378.2822,10.3751,   0.0000,   0);
        	}
			case 9: //LSAirport
        	{
			    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "LSAirport",   2058.7854,-2643.9578,13.5469,   0.0000,   2057.2808,-2648.0261,13.5469,   0.0000,   0);
			}
        	case 10: //SFAirport
        	{
			    NormalTele(playerid, "SFAirport",  -1373.3844,-258.4916,14.0000,   315.0000,   -1373.3844,-258.4916,14.0000,   315.0000,   0);
        	}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == StuntZones2)
	{
    	switch(row)
    	{
        	case 0: //Skate park
        	{
				OnlyPlayerTele(playerid, "SkatePark",   1920.3247,-1402.8632,13.5703,   0.0000,   0);
        	}
			case 1: //HalfPipe
        	{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "HalfPipe",   1296.5239,4289.1680,113.5000,   270.000,   1292.0472,4289.2334,112.0000,   270.0000,   0);
			}
			case 2: //WayToAir
			{
    			SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    /*DMZone[playerid] = 0;
	    		ResetPlayerWeapons(playerid);
				TogglePlayerControllable(playerid, 1);
				new WayToAir[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(2);
				GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					if (RandomSpawn == 0)
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),2225.6536,-584.7317,366.0000);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),353.000);
						SetCameraBehindPlayer(playerid);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
					}
					else if (RandomSpawn == 1)
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),2235.2749,-585.7139,366.0000);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),353.000);
						SetCameraBehindPlayer(playerid);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
					}
				}
				else
				{
					InCar[playerid] = false;
					SetPlayerPos(playerid,2230.0342,-588.9874,364.2000);
					SetPlayerFacingAngle(playerid,355.0000);
					SetCameraBehindPlayer(playerid);
				}
				SetPlayerInterior(playerid, 0);
				SendClientMessage(playerid, COLOR_BASIC, "You have been teleportated to -WayToAir-");
				format(WayToAir, sizeof(WayToAir), "%s has teleported to /WayToAir", playerName);
				for(new i=0; i<MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(ReceiveInfo[i] == true)
						{
							SendClientMessage(i, COLOR_GREY, WayToAir);
						}
					}
				}*/
			}
			case 3: //WayToDeath
        	{
	    		SpeceficTele(playerid, "WayToDeath",996.6433,2787.8489,1067.7532,   90.0000,   1065.7683,2781.0957,1070.5000,   55.0000,   0,   541);
			}
			case 4: //Stadium
			{
	    		NormalTele(playerid, "Stadium",   -1478.6078,1646.1399,1052.5313,   208.5000,   -1486.8704,1642.6029,1060.6719,   180.0000,   14);
			}
			case 5: //HopDeHop
        	{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "HopDeHop",331.9420,-1288.7561,53.9099,   207.0075,   330.0904,-1284.5708,54.3445,   208.7554,   0,   522);
			}
			case 6: //MonsterCrash
        	{
	    		SpeceficTele(playerid, "MonsterCrash",-2383.9839,2909.5325,362.3510,   180.0000,   -2379.1731,2956.5103,361.9797,   150.0000,   0,   444);
			}
			case 7: //FreeWay
        	{
	    		SpeceficTele(playerid, "FreeWay",-2847.1392,2185.9849,799.5908,   180.0000,   -2838.7273,2199.9253,801.7857,   145.0000,   0,   568);
			}
			case 8: //WayToChilliad
        	{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "WayToChilliad",  -3163.3479,-1226.1855,1398.5236,   243.4468,   -3217.4053,-1204.3394,1398.6516,   277.6004,   0);
		   	}
			case 9: //DeadJump
        	{
	    		NormalTele(playerid, "DeadJump",  -673.3708,-3024.7944,705.3344,   0.0000,   -678.4291,-3077.5681,705.6073,   336.8739,   0);
		   	}
			case 10: //BMX Parcour
        	{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "BMXParcour",1475.2362,-1333.6462,163.2656,   0.0000,   1473.0088,-1359.2314,163.7558,   341.8031,   0,   481);
		   	}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == StuntZones3)
	{
    	switch(row)
    	{

			case 0: //Upside Down
        	{
	    		SpeceficTele(playerid, "UpsideDown",391.1825,-82.5999,558.1525,   270.0000,   355.8427,-78.0696,558.4254,   244.6733,   0,   411);
			}
			case 1: //Way To Piramide
			{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "WayToPiramide",  2894.4275,1283.5056,730.8865,   90.0000,   2938.7502,1277.3365,731.3615,   66.0000,   0);
		   	}
			case 2: //NRG Parcour
			{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "NRGParcour",2555.1616,-1411.6984,34.2195,   23.5451,   2555.4250,-1424.5944,34.6545,   31.8932,   0,   522);
			}
			case 3: //RoofStunt
			{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "RoofStunt",-1775.5356,579.0707,234.8906,   94.5604,  -1773.7069,572.0452,234.8874,   74.1936,   0,   522);
			}
			case 4: //AquaPark
			{
		        OnlyPlayerTele(playerid, "AquaPark",   284.4926,-1863.2415,2.8927,   151.0337,   0);
				return 1;
			}
			case 5: //RollerCoaster
			{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "RollerCoaster",1995.2173,938.3616,273.2331,   359.9258,  1989.4508,914.0922,275.6952,   354.6008,   0,   411);
			}
			case 6: //Quad Parcour
			{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "QuadParcour",171.3088,-1790.5005,3.5084,   270.6771,  169.9782,-1794.1268,4.1376,   349.5647,   0,   471);
			}
			
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == TrainStations)
	{
    	switch(row)
    	{
        	case 0: //LS
        	{
				OnlyPlayerTele(playerid, "LSStation",   1734.6804,-1944.9839,13.5646,   126.6849,   0);
			}
        	case 1: //SF
        	{
				OnlyPlayerTele(playerid, "SFStation",   -1965.7423,161.1771,27.6875,   252.6458,   0);
			}
        	case 2: //LV1
        	{
				OnlyPlayerTele(playerid, "LVStation1",   1430.7799,2653.1604,11.3926,   204.4157,   0);
			}
        	case 3: //LV2
        	{
				OnlyPlayerTele(playerid, "LVStation2",   2848.7876,1293.9376,11.3906,   238.8593,   0);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == TuneGarages)
	{
    	switch(row)
    	{
        	case 0: //TuneGarage1
        	{
	    		NormalTele(playerid, "Tune1",   -1935.9851,231.7287,34.1563,   0.0000,   -1935.9851,231.7287,34.1563,   0.0000,   0);
			}
        	case 1: //TuneGarage2
        	{
	    		NormalTele(playerid, "Tune2",   -2709.7312,217.4238,4.1797,   90.0000,   -2709.7312,217.4238,4.1797,   90.0000,   0);
			}
        	case 2: //TuneGarage3
        	{
	    		NormalTele(playerid, "Tune3",   2386.8020,1036.3203,10.8203,   0.0000,   2386.8020,1036.3203,10.8203,   0.0000,   0);
			}
        	case 3: //TuneGarage4
        	{
	    		NormalTele(playerid, "Tune4",   2644.9768,-2030.9032,13.5540, 180.0000,  2644.9768,-2030.9032,13.5540,  180.0000, 0);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == DMZones)
	{
    	switch(row)
    	{
        	case 0: //BloodringArena
        	{
	    		SpeceficTele(playerid, "BloodringArena",1158.0044,-2103.5696,500.0000,   0.0000,   1160.5853,-2103.3530,497.0000,   0.0000,   0,   504);
			}
        	case 1: //Air Battle
        	{
				OnlyPlayerTele(playerid, "AirBattle",   290.8786,1920.0966,17.6406,   270.0000,   0);
        	}
        	case 2: //VehicleDM
        	{
	   			SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "VehicleDM",   2010.2626,-17.6970,8.0000,   196.7243,   2018.3121,-11.5412,4.4505,   170.0000,   0);
			}
        	case 3: //Minigun Madness
        	{
			    ResetPlayerWeapons(playerid);
			    TogglePlayerControllable(playerid, 1);
				new MinigunMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(6);
				GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
				DMZone[playerid] = 1;
				if (RandomSpawn == 0)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2632.5264,2832.3577,127.5781);
					SetPlayerFacingAngle(playerid, 247.9706);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2593.4360,2638.2803,114.0313);
					SetPlayerFacingAngle(playerid, 329.4380);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2718.2527,2773.7805,77.3594);
					SetPlayerFacingAngle(playerid, 46.8321);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2506.2986,2690.6221,77.8438);
					SetPlayerFacingAngle(playerid, 121.7195);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 4)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2618.1941,2720.9871,36.5386);
					SetPlayerFacingAngle(playerid, 196.2701);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 5)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 2593.4360,2638.2803,114.0313);
					SetPlayerFacingAngle(playerid, 255.2007);
					SetCameraBehindPlayer(playerid);
				}
				GivePlayerWeapon(playerid, 34, 1000);
				SetPlayerInterior(playerid, 0);
				SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 3");
				SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
				format(MinigunMadness, sizeof(MinigunMadness), "[新闻] %s 传送到 /dm 3", playerName);
				for(new i=0; i<MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(ReceiveInfo[i] == true)
						{
							SendClientMessage(i, COLOR_GREY, MinigunMadness);
						}
					}
				}
			}
        	case 4: //Ship Madness
        	{
			    ResetPlayerWeapons(playerid);
			    TogglePlayerControllable(playerid, 1);
				new ShipMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(9);
				GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
				DMZone[playerid] = 2;
				if (RandomSpawn == 0)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2473.3635,1552.3779,33.2273);
					SetPlayerFacingAngle(playerid, 162.4520);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2464.5215,1531.9247,17.3281);
					SetPlayerFacingAngle(playerid, 356.1172);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2460.7542,1551.8220,23.1406);
					SetPlayerFacingAngle(playerid, 179.0821);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2444.2595,1530.2435,20.2344);
					SetPlayerFacingAngle(playerid, 340.1136);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 4)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2401.1440,1532.8340,26.0469);
					SetPlayerFacingAngle(playerid, 17.7140);
					SetCameraBehindPlayer(playerid);
				}
    			if (RandomSpawn == 5)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2374.3948,1535.5518,26.0469);
					SetPlayerFacingAngle(playerid, 57.7976);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 6)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2359.6692,1561.0190,26.0469);
					SetPlayerFacingAngle(playerid, 162.1386);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 7)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2382.4871,1547.8801,10.8281);
					SetPlayerFacingAngle(playerid, 108.2448);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 8)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -2422.0405,1551.3163,7.9219);
					SetPlayerFacingAngle(playerid, 143.3385);
					SetCameraBehindPlayer(playerid);
				}
				GivePlayerWeapon(playerid, 4, 1);
				GivePlayerWeapon(playerid, 24, 47);
				GivePlayerWeapon(playerid, 26, 100);
				SetPlayerInterior(playerid, 0);
				SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 2");
				SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
				format(ShipMadness, sizeof(ShipMadness), "[新闻] %s 传送到 /dm 2", playerName);
				for(new i=0; i<MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(ReceiveInfo[i] == true)
						{
							SendClientMessage(i, COLOR_GREY, ShipMadness);
						}
					}
				}
			}
        	case 5: //Glass Madness
        	{
			    ResetPlayerWeapons(playerid);
			    TogglePlayerControllable(playerid, 1);
				new GlassMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(8);
				GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
				DMZone[playerid] = 3;
				if (RandomSpawn == 0)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -33.6020,1507.4240,95.4173);
					SetPlayerFacingAngle(playerid, 325.6300);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -12.6829,1507.4701,95.4341);
					SetPlayerFacingAngle(playerid, 40.2041);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -12.6831,1544.3137,95.4309);
					SetPlayerFacingAngle(playerid, 146.1118);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -32.7342,1543.9973,95.4126);
					SetPlayerFacingAngle(playerid, 220.0591);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 4)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -23.6215,1545.4828,95.4222);
					SetPlayerFacingAngle(playerid, 181.8555);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 5)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -11.9289,1525.8883,95.4330);
					SetPlayerFacingAngle(playerid, 89.4213);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 6)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -23.4273,1505.9843,95.4257);
					SetPlayerFacingAngle(playerid, 359.8071);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 7)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, -34.1823,1525.6079,95.4088);
					SetPlayerFacingAngle(playerid, 270.5063);
					SetCameraBehindPlayer(playerid);
				}
				GivePlayerWeapon(playerid, 29, 500);
				SetPlayerInterior(playerid, 0);
				SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 1");
				SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
				format(GlassMadness, sizeof(GlassMadness), "[新闻] %s 传送到 /dm 1", playerName);
				for(new i=0; i<MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(ReceiveInfo[i] == true)
						{
							SendClientMessage(i, COLOR_GREY, GlassMadness);
						}
					}
				}
			}
        	case 6: //Island DM
        	{
			    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    /*ResetPlayerWeapons(playerid);
			    TogglePlayerControllable(playerid, 1);
				new IslandDM[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(5);
				GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
				DMZone[playerid] = 4;
				if (RandomSpawn == 0)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 3767.7358,-1813.6943,19.8772);
					SetPlayerFacingAngle(playerid, 179.3254);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 3828.8596,-1906.2285,15.4382);
					SetPlayerFacingAngle(playerid, 52.7610);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 3803.5884,-1965.7352,13.8772);
					SetPlayerFacingAngle(playerid, 46.7841);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 3688.8562,-1957.8295,14.8801);
					SetPlayerFacingAngle(playerid, 331.2935);
					SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 4)
				{
    			    InCar[playerid] = false;
					SetPlayerPos(playerid, 3652.4124,-1876.3260,20.8859);
					SetPlayerFacingAngle(playerid, 222.2524);
					SetCameraBehindPlayer(playerid);
				}
				DynUpdateStart(playerid);
				GivePlayerWeapon(playerid, 4, 1);
				GivePlayerWeapon(playerid, 24, 47);
				GivePlayerWeapon(playerid, 26, 44);
				SetPlayerInterior(playerid, 0);
				SendClientMessage(playerid, COLOR_BASIC, "You have been teleportated to -Island DM-");
				SendClientMessage(playerid, COLOR_RED, "SHOOTING WITH WEAPONS OUTSIDE -ISLAND DM- WIL RESULT IN KICK OR BAN!!!");
				format(IslandDM, sizeof(IslandDM), "%s has teleported to /IslandDM", playerName);
				for(new i=0; i<MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(ReceiveInfo[i] == true)
						{
							SendClientMessage(i, COLOR_GREY, IslandDM);
						}
					}
				}*/
			}
        	case 7: //Derby
        	{
	    		NormalTele(playerid, "Derby",  -1441.9851,937.9876,1036.3468,   279.2885,   -1424.1138,930.0392,1036.4016,   354.8884,   15);
			}
        	case 8: //RC War
        	{
				OnlyPlayerTele(playerid, "RCWar",   -1130.8673,1034.7043,1345.7231,   243.5756,   10);
				DMZone[playerid] = 5;
			}
        	case 9: //Watch RC War
        	{
				OnlyPlayerTele(playerid, "WatchRCWar",   -1136.3916,1023.5286,1358.9141,   213.5151,   10);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == OtherZones1)
	{
    	switch(row)
    	{
        	case 0: //TuneGarages
        	{
        	    ShowMenuForPlayer(TuneGarages, playerid);
			}
        	case 1: //TrainStations
        	{
				ShowMenuForPlayer(TrainStations, playerid);
			}
        	case 2: //TruckStops
        	{
				ShowMenuForPlayer(TruckStops, playerid);
			}
        	case 3: //AA
        	{
	    		NormalTele(playerid, "AA",  402.8024,2534.6926,16.700,   150.000,   411.1637,2539.2366,16.5473,   90.0000,   0);
			}
        	case 4: //Home
        	{
	    		NormalTele(playerid, "Home",		-468.3654,2208.0317,46.4776,	115.0000,	-468.3654,2208.0317,46.4776,	115.0000,	0);
			}
        	case 5: //DragRace
        	{
	    		NormalTele(playerid, "DragRace",  1031.1125,-2297.4236,12.8004,   60.0000,   1031.1125,-2297.4236,12.8004,   60.0000,   0);
        	}
        	case 6: //Karting
        	{
	    		SpeceficTele(playerid, "Karting",2888.9099,1028.5667,17.0000,   0.0000,   2888.9377,1026.1427,13.4755,   0.0000,   0,   571);
			}
        	case 7: //Trampoline
        	{
	    		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "Trampoline",  2250.6528,338.8527,526.0000,   180.0000,   2217.9050,330.7018,523.0000,   240.0000,   0);
        	}
			case 8: //Dirt
        	{
	    		NormalTele(playerid, "Dirt",  -1299.6615,-700.7803,1056.2037,   31.1929,   -1295.2308,-694.4233,1056.4128,   55.7578,   4);
			}
			case 9: //AdminCastle
        	{
	   			NormalTele(playerid, "AdminCastle",  -2891.6179,-76.7571,4.0496,   69.4484,   -2899.2368,-76.9977,4.1619,   52.9987,   0);
		   	}
			case 10: //PinkAutos
        	{
	    		NormalTele(playerid, "PinkAutos",  -1623.2146,1227.1677,7.0391,   114.0600,   -1620.0802,1221.2664,7.1875,   107.4800,   0);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == OtherZones2)
	{
    	switch(row)
    	{
        	case 0: //Drift
        	{
				OnlyPlayerTele(playerid, "Drift",   -309.9550,1560.8075,75.3594,   250.5937,   0);
			}
        	case 1: //Bounce
        	{
				SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //NormalTele(playerid, "Bounce",  2973.1985,-2725.4814,9.2444,   209.1594,   2961.0505,-2715.2512,8.8731,   208.6876,   0);
			}
        	case 2: //CarSumo
        	{
				SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
			    //SpeceficTele(playerid, "CarSumo",-2333.3159,4050.5703,11.7308,   180.0000,  -2335.2354,4075.6289,11.7308,   180.0000,   0,   444);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == TruckStops)
	{
    	switch(row)
    	{
        	case 0: //LasVegas Truck Stop
        	{
				OnlyPlayerTele(playerid, "LVTruckStop",   661.4391,1718.3545,7.1875,   117.5748,   0);
			}
        	case 1: //Chilliad Truck Stop
        	{
				OnlyPlayerTele(playerid, "CTruckStop",   -1560.8802,-2735.1248,48.7435,   223.5058,   0);
        	}
        	case 2: //Dam Truck Stop
        	{
				OnlyPlayerTele(playerid, "DTruckStop",   -314.5585,1773.8600,43.6406,   192.1722,   0);
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(CurrentMenu == SpawnplaceMenu)
	{
    	switch(row)
    	{
        	case 0: //SFAirport
        	{
                spawnplace[playerid] = 1;
                spawnplacechosen[playerid] = true;
                TogglePlayerControllable(playerid, 1);
               	SendClientMessage(playerid, COLOR_BASIC, "出生点设置为 /SFAirport 下次复活在这里啦");
			}
        	case 1: //DamStunt
        	{
                spawnplace[playerid] = 2;
                spawnplacechosen[playerid] = true;
                TogglePlayerControllable(playerid, 1);
                SendClientMessage(playerid, COLOR_BASIC, "出生点设置为 /DamStunt 下次复活在这里啦");
			}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerExitedMenu(playerid)
{
	new Menu:CurrentMenu = GetPlayerMenu(playerid);
	if(Menu:CurrentMenu == SpawnplaceMenu)
	{
		TogglePlayerControllable(playerid, 1);
	}
	if(Menu:CurrentMenu == StuntZones1)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == StuntZones2)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == StuntZones3)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == DMZones)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == TuneGarages)
	{
		ShowMenuForPlayer(OtherZones1, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == TrainStations)
	{
		ShowMenuForPlayer(OtherZones1, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == TruckStops)
	{
		ShowMenuForPlayer(OtherZones1, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == OtherZones1)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == OtherZones2)
	{
		ShowMenuForPlayer(Teleports, playerid);
		TogglePlayerControllable(playerid, 0);
	}
	if(Menu:CurrentMenu == Teleports)
	{
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerEnterVehicle(playerid,vehicleid)
{
    vehid[playerid] = vehicleid;
    NitroActive[playerid] = false;
   	for(new i = 0; i < sizeof(godcar); i++)
	{
    	if(vehicleid == godcar[i])
		{
			GodCartimer = SetTimer("GodCarTimer",1000,1);
		}
	}
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerExitVehicle(playerid, vehicleid)
{
    InCar[playerid] = false;

   	for(new i = 0; i < sizeof(godcar); i++)
	{
		if(vehicleid == godcar[i])
		{
			KillTimer(GodCartimer);
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public GodCarTimer(playerid)
{
	SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerConnect(playerid)
{
	F_OnPlayerConnect(playerid);

	/*Textdraw0 = TextDrawCreate(3.000000,344.000000,"s a m p .  c o m . c n v1.0");
	TextDrawUseBox(Textdraw0,1);
	TextDrawBoxColor(Textdraw0,0x000000ff);
	TextDrawTextSize(Textdraw0,-1.000000,146.000000);
	TextDrawAlignment(Textdraw0,0);
	TextDrawBackgroundColor(Textdraw0,0x0000ff33);
	TextDrawFont(Textdraw0,3);
	TextDrawLetterSize(Textdraw0,0.299999,0.700000);
	TextDrawColor(Textdraw0,0xffffffff);
	TextDrawSetOutline(Textdraw0,1);
	TextDrawSetProportional(Textdraw0,1);
	TextDrawShowForPlayer(playerid, Text:Textdraw0);*/

    Checkgate = SetTimer("CheckGate", 1000, 1);
	lvwz = SetTimer("LVWZ", 1000, 1);

	SetPlayerMapIcon( playerid, 1, -3535.9673,-66.2674,2.1839, 5, 0); //Airport Admincastle
	SetPlayerMapIcon( playerid, 2, -3357.6938,-69.7644,123.2506, 19, 0); //Flag AdminCastle
	SetPlayerMapIcon( playerid, 3, -3284.2493,-125.4545,2.5392, 9, 0); //Boats AdminCastle
//	SetPlayerMapIcon( playerid, 4, 2869.8384,-1749.3060,11.0444, 37, 0); //Secret Stuntzone
	SetPlayerMapIcon( playerid, 5, 1002.3448,-2291.4976,14.0816, 53, 0); //DragRace
	SetPlayerMapIcon( playerid, 6, 200.6568,2503.0281,16.4844, 5, 0); //AA
	SetPlayerMapIcon( playerid, 7, -468.6863,2207.8826,46.5093, 56, 0); //SpawnPoint
	SetPlayerMapIcon( playerid, 8, 314.3689,1906.3972,17.6406, 5, 0); //Airbattle (Area51)
	SetPlayerMapIcon( playerid, 9, 610.0776,1698.3099,6.9922, 51, 0); //Truck Stop
	SetPlayerMapIcon( playerid, 10, -1597.0704,-2727.6892,48.5391, 51, 0); //Truck Stop
	SetPlayerMapIcon( playerid, 11, -327.0811,1768.1223,42.7596, 51, 0); //Truck Stop
	SetPlayerMapIcon( playerid, 12, 1734.6804,-1944.9839,13.564, 48, 0); //Train Station
	SetPlayerMapIcon( playerid, 13, -1961.2306,138.1871,27.6875, 48, 0); //Train Station
	SetPlayerMapIcon( playerid, 14, 1433.2821,2651.9473,11.3926, 48, 0); //Train Station
	SetPlayerMapIcon( playerid, 15, 2841.9917,1290.7056,11.3906, 48, 0); //Train Station
	SetPlayerMapIcon( playerid, 16, -1433.4529,-956.0518,200.9836, 19, 0); //Flag Hideout

    new pName[MAX_PLAYER_NAME];
    new string[128];
    GetPlayerName(playerid, pName, sizeof(pName));
    format(string, sizeof(string), "%s 进入服务器", pName);
    SendClientMessageToAll(COLOR_GREY, string);

	if(!strcmp("[ViP]Labrik",pName,true) || !strcmp("netzeek",pName,true) || !strcmp("[MT]Lavis",pName,true))
	{
	    new kstring[128];
	    format(kstring, sizeof(kstring), "%s 被反作弊系统踢出 (illegal name).", pName);
    	SendClientMessageToAll(COLOR_GREY, kstring);
    	print(kstring);
		Kick(playerid);
	}

    AllowPlayerTeleport(playerid, 0);

    BombArmed[playerid] = false;
	AntiFalloff[playerid] = false;
    DMZone[playerid] = 0;
    spawnplacechosen[playerid] = false;
    ReceiveInfo[playerid] = false;
    stupidjumpsfound[playerid] = 0;
    SetTimerEx("AutoRepair",100,true,"d",playerid);

	SendClientMessage(playerid,COLOR_1, "欢迎来到 未来世界, 按键盘 T 键,输入 /help 获取帮助信息!");
	SendClientMessage(playerid,COLOR_2, "管理员信箱:sa-mp@qq.com QQ讨论群:52631166");
	SendClientMessage(playerid,COLOR_3,"英文命令: /stunt /race /dm /tour /para /tune /veh /tele /menu /options /anim /weapon");
	SendClientMessage(playerid,COLOR_4,"拼音命令: /teji /saiche /jingji /lvyou /tiaosan /gaiche /jiaotong /chuansong /caidan /xuanxiang /dongzuo /wuqi");
	SendClientMessage(playerid,COLOR_5,"中文命令: /特技 /赛车 /竞技 /旅游 /跳伞 /改车 /交通 /传送 /菜单 /选项 /动作 /武器");
	SendClientMessage(playerid,COLOR_6, "最后更新: /dm");
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public CountDown()
{
    switch(Count)
    {
        case 5: { GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~r~ 5 ~b~-", 1100, 3); }
        case 4: { GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~r~ 4 ~b~-", 1100, 3); }
        case 3: { GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~r~ 3 ~b~-", 1100, 3); }
        case 2: { GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~r~ 2 ~b~-", 1100, 3); }
        case 1: { GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~r~ 1 ~b~-", 1100, 3); }
        case 0:
        {
        	GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~-~g~ go! ~b~-", 2000, 3);
         	KillTimer(CountdownTimer);
          	IsCountdownStarted = false;
		}
    }
    Count--;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerSpawn(playerid)
{
    PlayerPlaySound(playerid, 1184, -1370.2362,-256.3250,15.0000); //stop geluid
    SetPlayerHealth(playerid, 100);

	if(SkinChooseIslandObjectsShown[playerid] == true)
	{
		DestroyPlayerObject(playerid, SpawnIslandObject1);
		DestroyPlayerObject(playerid, SpawnIslandObject2);
		DestroyPlayerObject(playerid, SpawnIslandObject3);
		DestroyPlayerObject(playerid, SpawnIslandObject4);
		DestroyPlayerObject(playerid, SpawnIslandObject5);
		DestroyPlayerObject(playerid, SpawnIslandObject6);
		DestroyPlayerObject(playerid, SpawnIslandObject7);
		DestroyPlayerObject(playerid, SpawnIslandObject8);
		DestroyPlayerObject(playerid, SpawnIslandObject9);
		DestroyPlayerObject(playerid, SpawnIslandObject10);
		DestroyPlayerObject(playerid, SpawnIslandObject11);
		DestroyPlayerObject(playerid, SpawnIslandObject12);
		DestroyPlayerObject(playerid, SpawnIslandObject13);
		DestroyPlayerObject(playerid, SpawnIslandObject14);
		DestroyPlayerObject(playerid, SpawnIslandObject15);
		DestroyPlayerObject(playerid, SpawnIslandObject16);
		DestroyPlayerObject(playerid, SpawnIslandObject17);
		DestroyPlayerObject(playerid, SpawnIslandObject18);
		DestroyPlayerObject(playerid, SpawnIslandObject19);
		DestroyPlayerObject(playerid, SpawnIslandObject20);
		DestroyPlayerObject(playerid, SpawnIslandObject21);
		DestroyPlayerObject(playerid, SpawnIslandObject22);
		DestroyPlayerObject(playerid, SpawnIslandObject23);
		DestroyPlayerObject(playerid, SpawnIslandObject24);
		DestroyPlayerObject(playerid, SpawnIslandObject25);
		DestroyPlayerObject(playerid, SpawnIslandObject26);
		DestroyPlayerObject(playerid, SpawnIslandObject27);
		DestroyPlayerObject(playerid, SpawnIslandObject28);
		DestroyPlayerObject(playerid, SpawnIslandObject29);
		DestroyPlayerObject(playerid, SpawnIslandObject30);
		DestroyPlayerObject(playerid, SpawnIslandObject31);
		DestroyPlayerObject(playerid, SpawnIslandObject32);
		DestroyPlayerObject(playerid, SpawnIslandObject33);
		DestroyPlayerObject(playerid, SpawnIslandObject34);
		DestroyPlayerObject(playerid, SpawnIslandObject35);
		DestroyPlayerObject(playerid, SpawnIslandObject36);

		SkinChooseIslandObjectsShown[playerid] = false;
	}

    GangZoneShowForPlayer(playerid, DragRaceGangZoneBlack, 0x000000FF);
    GangZoneShowForPlayer(playerid, DragRaceGangZoneWhite1, 0xD7D7D7FF);
    GangZoneShowForPlayer(playerid, DragRaceGangZoneWhite2, 0xD7D7D7FF);
    GangZoneShowForPlayer(playerid, BuildingJumpGangZone, 0xD7D7D7FF);
    GangZoneShowForPlayer(playerid, BuildingJumpGangZoneKicker, 0x003C77FF);
    GangZoneShowForPlayer(playerid, AdminCastleGangZone1, 0x770000FF);
    GangZoneShowForPlayer(playerid, AdminCastleGangZone2, 0x6F89AAFF);
	GangZoneShowForPlayer(playerid, GlassMadnessGangZone1, 0x999999FF);
	GangZoneShowForPlayer(playerid, GlassMadnessGangZone2, 0x999999FF);
	GangZoneShowForPlayer(playerid, GlassMadnessGangZone3, 0x999999FF);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if(DMZone[playerid] >= 1)
	{

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(DMZone[playerid] == 1)
		{
		    new RandomSpawn = random(6);
			if (RandomSpawn == 0)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2595.3945,2758.7642,23.8222);
				SetPlayerFacingAngle(playerid, 247.9706);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 1)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2600.9648,2726.4263,23.8222);
				SetPlayerFacingAngle(playerid, 329.4380);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 2)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2639.5300,2729.5732,23.8222);
				SetPlayerFacingAngle(playerid, 46.8321);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 3)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2642.3181,2757.0920,23.8222);
				SetPlayerFacingAngle(playerid, 121.7195);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 4)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2649.0498,2780.8462,19.3222);
				SetPlayerFacingAngle(playerid, 196.2701);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 5)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 2607.4639,2732.1467,36.5386);
				SetPlayerFacingAngle(playerid, 255.2007);
				SetCameraBehindPlayer(playerid);
			}
			GivePlayerWeapon(playerid, 34, 1000);
			SetPlayerInterior(playerid, 0);
			SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
			SendClientMessage(playerid, COLOR_GREY, "/ExitDM 退出死亡竞技");
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(DMZone[playerid] == 2)
		{
	    	new RandomSpawn = random(9);
			if (RandomSpawn == 0)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2473.3635,1552.3779,33.2273);
				SetPlayerFacingAngle(playerid, 162.4520);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 1)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2464.5215,1531.9247,17.3281);
				SetPlayerFacingAngle(playerid, 356.1172);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 2)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2460.7542,1551.8220,23.1406);
				SetPlayerFacingAngle(playerid, 179.0821);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 3)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2444.2595,1530.2435,20.2344);
				SetPlayerFacingAngle(playerid, 340.1136);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 4)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2401.1440,1532.8340,26.0469);
				SetPlayerFacingAngle(playerid, 17.7140);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 5)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2374.3948,1535.5518,26.0469);
				SetPlayerFacingAngle(playerid, 57.7976);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 6)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2359.6692,1561.0190,26.0469);
				SetPlayerFacingAngle(playerid, 162.1386);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 7)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2382.4871,1547.8801,10.8281);
				SetPlayerFacingAngle(playerid, 108.2448);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 8)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -2422.0405,1551.3163,7.9219);
				SetPlayerFacingAngle(playerid, 143.3385);
				SetCameraBehindPlayer(playerid);
			}
			GivePlayerWeapon(playerid, 4, 1);
			GivePlayerWeapon(playerid, 24, 47);
			GivePlayerWeapon(playerid, 26, 100);
			SetPlayerInterior(playerid, 0);
			SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
			SendClientMessage(playerid, COLOR_GREY, "/ExitDM 退出死亡竞技");
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(DMZone[playerid] == 3)
		{
		    new RandomSpawn = random(8);
			if (RandomSpawn == 0)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -33.6020,1507.4240,95.4173);
				SetPlayerFacingAngle(playerid, 325.6300);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 1)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -12.6829,1507.4701,95.4341);
				SetPlayerFacingAngle(playerid, 40.2041);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 2)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -12.6831,1544.3137,95.4309);
				SetPlayerFacingAngle(playerid, 146.1118);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 3)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -32.7342,1543.9973,95.4126);
				SetPlayerFacingAngle(playerid, 220.0591);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 4)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -23.6215,1545.4828,95.4222);
				SetPlayerFacingAngle(playerid, 181.8555);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 5)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -11.9289,1525.8883,95.4330);
				SetPlayerFacingAngle(playerid, 89.4213);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 6)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -23.4273,1505.9843,95.4257);
				SetPlayerFacingAngle(playerid, 359.8071);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 7)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, -34.1823,1525.6079,95.4088);
				SetPlayerFacingAngle(playerid, 270.5063);
				SetCameraBehindPlayer(playerid);
			}
			GivePlayerWeapon(playerid, 29, 500);
			SetPlayerInterior(playerid, 0);
			SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
			SendClientMessage(playerid, COLOR_GREY, "/ExitDM 退出死亡竞技");
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* //Deleted
		if(DMZone[playerid] == 4)
		{
	    	new RandomSpawn = random(5);
			if (RandomSpawn == 0)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 3767.7358,-1813.6943,19.8772);
				SetPlayerFacingAngle(playerid, 179.3254);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 1)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 3828.8596,-1906.2285,15.4382);
				SetPlayerFacingAngle(playerid, 52.7610);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 2)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 3803.5884,-1965.7352,13.8772);
				SetPlayerFacingAngle(playerid, 46.7841);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 3)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 3688.8562,-1957.8295,14.8801);
				SetPlayerFacingAngle(playerid, 331.2935);
				SetCameraBehindPlayer(playerid);
			}
			if (RandomSpawn == 4)
			{
				InCar[playerid] = false;
				SetPlayerPos(playerid, 3652.4124,-1876.3260,20.8859);
				SetPlayerFacingAngle(playerid, 222.2524);
				SetCameraBehindPlayer(playerid);
			}
			DynUpdateStart(playerid);
			GivePlayerWeapon(playerid, 4, 1);
			GivePlayerWeapon(playerid, 24, 47);
			GivePlayerWeapon(playerid, 26, 44);
			SetPlayerInterior(playerid, 0);
			SendClientMessage(playerid, COLOR_RED, "SHOOTING WITH WEAPONS OUTSIDE -ISLAND DM- WIL RESULT IN KICK OR BAN!!!");
			SendClientMessage(playerid, COLOR_GREY, "Use /ExitDM to exit Island DM.");
		}
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(DMZone[playerid] == 5)
		{
			OnlyPlayerTele(playerid, "RCWar",   -1130.8673,1034.7043,1345.7231,   243.5756,   10);
			SendClientMessage(playerid, COLOR_GREY, "/ExitDM 退出死亡竞技");
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	else
	{

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(spawnplacechosen[playerid] == true)
		{
    		new RandomSpawn = random(4);
			if(spawnplace[playerid] == 1)
			{
				if (RandomSpawn == 0)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -1375.4424,-260.5453,14.1440);
		    		SetPlayerFacingAngle(playerid, 315.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -1374.8785,-260.0078,14.1440);
		    		SetPlayerFacingAngle(playerid, 315.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -1374.2201,-259.3802,14.1440);
		    		SetPlayerFacingAngle(playerid, 315.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -1373.6014,-258.7105,14.1440);
		    		SetPlayerFacingAngle(playerid, 315.0000);
		    		SetCameraBehindPlayer(playerid);
				}
			}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if(spawnplace[playerid] == 2)
			{
				if (RandomSpawn == 0)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -467.6280,2208.3828,46.4052);
		    		SetPlayerFacingAngle(playerid, 115.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 1)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -468.3654,2208.0317,46.4776);
		    		SetPlayerFacingAngle(playerid, 115.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 2)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -469.4590,2207.5110,46.5850);
		    		SetPlayerFacingAngle(playerid, 115.0000);
		    		SetCameraBehindPlayer(playerid);
				}
				if (RandomSpawn == 3)
				{
					InCar[playerid] = false;
		    		SetPlayerPos(playerid, -470.4734,2207.0278,46.6846);
		    		SetPlayerFacingAngle(playerid, 115.0000);
		    		SetCameraBehindPlayer(playerid);
				}
			}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerDisconnect(playerid, reason)
{
    Seifader_OnPlayerDisconnect(playerid);

	if( PVeh[playerid] > 0 )
	{
	    SetTimerEx("DestroyNRG",10000,0, "i", playerid);
		SetVehiclePos(PVeh[playerid], 0, 0, 0);
	}

    KillTimer(Checkgate);
	KillTimer(lvwz);
    TextDrawDestroy(Textdraw0);

	RemovePlayerMapIcon(playerid, 1);
	RemovePlayerMapIcon(playerid, 2);
	RemovePlayerMapIcon(playerid, 3);
	RemovePlayerMapIcon(playerid, 4);
	RemovePlayerMapIcon(playerid, 5);
	RemovePlayerMapIcon(playerid, 6);
	RemovePlayerMapIcon(playerid, 7);
	RemovePlayerMapIcon(playerid, 8);
	RemovePlayerMapIcon(playerid, 9);
	RemovePlayerMapIcon(playerid, 10);
	RemovePlayerMapIcon(playerid, 11);
	RemovePlayerMapIcon(playerid, 12);
	RemovePlayerMapIcon(playerid, 13);
	RemovePlayerMapIcon(playerid, 14);
	RemovePlayerMapIcon(playerid, 15);

    new PName[MAX_PLAYER_NAME];
    new String[128];
    GetPlayerName(playerid, PName, sizeof(PName));

    switch(reason)
    {
        case 0: format(String, sizeof(String), "%s 离开服务器. (掉线)", PName);
        case 1: format(String, sizeof(String), "%s 离开服务器.", PName);
        case 2: format(String, sizeof(String), "%s 离开服务器. (GM 踢出)", PName);
    }

    SendClientMessageToAll(COLOR_GREY, String);


	new i2;
	for(i2=0;i2<MAX_VEHICLES;i2++)
	{
		if (locked[playerid][i2] == 1)
		{
			new i;
			for(i=0;i<MAX_PLAYERS;i++)
				{
  					SetVehicleParamsForPlayer(i2,i, 0, 0);
				}
		}
		locked[playerid][i2] = 0;
	}
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SetupPlayerForClassSelection(playerid)
{
	InCar[playerid] = false;
    SetPlayerPos(playerid,3935.8965,-1096.5420,3.2836);
    SetPlayerFacingAngle(playerid, 166.8000);
    SetPlayerCameraPos(playerid,3934.8000,-1101.0745,3.6500);
    SetPlayerCameraLookAt(playerid,3935.2124,-1097.0251,3.6500);

	if(playerid == 0)
	{
		SetPlayerColor(playerid,0xFF0000AA);
	}
	if(playerid == 1)
	{
		SetPlayerColor(playerid,0xFF2F00AA);
	}
	if(playerid == 2)
	{
		SetPlayerColor(playerid,0xFF5100AA);
	}
	if(playerid == 3)
	{
		SetPlayerColor(playerid,0xFF8400AA);
	}
	if(playerid == 4)
	{
		SetPlayerColor(playerid,0xFFA600AA);
	}
	if(playerid == 5)
	{
		SetPlayerColor(playerid,0xFFD900AA);
	}
	if(playerid == 6)
	{
		SetPlayerColor(playerid,0xFFFB00AA);
	}
	if(playerid == 7)
	{
		SetPlayerColor(playerid,0xD5FF00AA);
	}
	if(playerid == 8)
	{
		SetPlayerColor(playerid,0xAAFF00AA);
	}
	if(playerid == 9)
	{
		SetPlayerColor(playerid,0x7BFF00AA);
	}
	if(playerid == 10)
	{
		SetPlayerColor(playerid,0x2BFF00AA);
	}
	if(playerid == 11)
	{
		SetPlayerColor(playerid,0x00FF55AA);
	}
	if(playerid == 12)
	{
		SetPlayerColor(playerid,0x00FF84AA);
	}
	if(playerid == 13)
	{
		SetPlayerColor(playerid,0x00FFAAAA);
	}
	if(playerid == 14)
	{
		SetPlayerColor(playerid,0x00FFD5AA);
	}
	if(playerid == 15)
	{
		SetPlayerColor(playerid,0x00FFFFAA);
	}
	if(playerid == 16)
	{
		SetPlayerColor(playerid,0x00D5FFAA);
	}
	if(playerid == 17)
	{
		SetPlayerColor(playerid,0x00AAFFAA);
	}
	if(playerid == 18)
	{
		SetPlayerColor(playerid,0x0080FFAA);
	}
	if(playerid == 19)
	{
		SetPlayerColor(playerid,0x0055FFAA);
	}
	if(playerid == 20)
	{
		SetPlayerColor(playerid,0x002BFFAA);
	}
	if(playerid == 21)
	{
		SetPlayerColor(playerid,0x2A00FFAA);
	}
	if(playerid == 22)
	{
		SetPlayerColor(playerid,0x5500FFAA);
	}
	if(playerid == 23)
	{
		SetPlayerColor(playerid,0x8000FFAA);
	}
	if(playerid == 24)
	{
		SetPlayerColor(playerid,0xAE00FFAA);
	}
	if(playerid == 25)
	{
		SetPlayerColor(playerid,0xD500FFAA);
	}
	if(playerid == 26)
	{
		SetPlayerColor(playerid,0xFF0044AA);
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerRequestClass(playerid, classid)
{
    PlayerPlaySound(playerid, 1183, -1370.2362,-256.3250,14.1440);
    SetupPlayerForClassSelection(playerid);

	if(SkinChooseIslandObjectsShown[playerid] == false)
	{
     	SkinChooseIslandObjectsShown[playerid] = true;
	    SpawnIslandObject1 = CreatePlayerObject(playerid, 898, 3932.645020, -1095.518799, -4.546414, 329.9197, 93.6786, 120.3212);
		SpawnIslandObject2 = CreatePlayerObject(playerid, 18340, 3920.361816, -1084.253662, 49.761078, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject3 = CreatePlayerObject(playerid, 619, 3905.655762, -1029.703735, 8.862635, 0.0000, 0.0000, 49.8473);
		SpawnIslandObject4 = CreatePlayerObject(playerid, 621, 3968.395508, -1049.294434, 8.024704, 14.6104, 343.6707, 0.0000);
		SpawnIslandObject5 = CreatePlayerObject(playerid, 623, 3894.461182, -1075.970459, 11.654289, 0.0000, 0.0000, 326.4820);
		SpawnIslandObject6 = CreatePlayerObject(playerid, 619, 3898.211426, -1051.448853, 9.554228, 0.0000, 0.0000, 119.4617);
		SpawnIslandObject7 = CreatePlayerObject(playerid, 619, 3917.147217, -1006.179199, 8.302782, 0.0000, 0.0000, 104.8513);
		SpawnIslandObject8 = CreatePlayerObject(playerid, 619, 3963.251221, -1043.517090, 7.108164, 0.0000, 0.0000, 323.9037);
		SpawnIslandObject9 = CreatePlayerObject(playerid, 621, 3971.131104, -1067.059204, 8.574343, 10.3132, 348.8273, 356.5623);
		SpawnIslandObject10 = CreatePlayerObject(playerid, 621, 3909.550293, -1016.259155, 8.425720, 14.6104, 10.3132, 313.5904);
		SpawnIslandObject11 = CreatePlayerObject(playerid, 619, 3935.947266, -993.894287, 3.131102, 0.0000, 19.7670, 10.3132);
		SpawnIslandObject12 = CreatePlayerObject(playerid, 623, 3944.891602, -1022.871216, 0.288973, 0.0000, 0.0000, 326.4820);
		SpawnIslandObject13 = CreatePlayerObject(playerid, 16133, 3884.537354, -1039.285522, 19.302271, 10.3132, 340.2330, 150.4015);
		SpawnIslandObject14 = CreatePlayerObject(playerid, 16133, 3916.850342, -987.972778, 10.578606, 10.3132, 340.2330, 98.8353);
		SpawnIslandObject15 = CreatePlayerObject(playerid, 16133, 3988.867188, -1064.423096, 12.378860, 355.7028, 355.7028, 347.1085);
		SpawnIslandObject16 = CreatePlayerObject(playerid, 16133, 3985.739746, -1019.214600, 9.379145, 356.5623, 350.5462, 340.2330);
		SpawnIslandObject17 = CreatePlayerObject(playerid, 6230, 3941.477295, -1008.290527, -7.787828, 0.0000, 0.0000, 353.1245);
		SpawnIslandObject18 = CreatePlayerObject(playerid, 11495, 3952.709961, -953.437744, 5.393352, 6.8755, 0.0000, 0.0000);
		SpawnIslandObject19 = CreatePlayerObject(playerid, 647, 3948.795654, -993.862671, 4.965949, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject20 = CreatePlayerObject(playerid, 647, 3947.602051, -979.635559, 5.998153, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject21 = CreatePlayerObject(playerid, 647, 3964.480469, -975.510559, 7.691695, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject22 = CreatePlayerObject(playerid, 647, 3966.208740, -986.594971, 7.181026, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject23 = CreatePlayerObject(playerid, 647, 3969.218506, -1036.770264, 10.744990, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject24 = CreatePlayerObject(playerid, 647, 3898.012939, -1058.910645, 13.254264, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject25 = CreatePlayerObject(playerid, 647, 3917.973877, -1014.377014, 8.132461, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject26 = CreatePlayerObject(playerid, 647, 3900.250000, -1039.894775, 12.266856, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject27 = CreatePlayerObject(playerid, 647, 3971.664063, -1050.290894, 11.993178, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject28 = CreatePlayerObject(playerid, 647, 3910.293945, -1008.784363, 11.523055, 0.0000, 0.0000, 0.0000);
		SpawnIslandObject29 = CreatePlayerObject(playerid, 621, 3941.803955, -975.435364, 3.726109, 14.6104, 0.8594, 25.7831);
		SpawnIslandObject30 = CreatePlayerObject(playerid, 621, 3966.490479, -977.003479, 3.367840, 14.6104, 12.0321, 0.0000);
		SpawnIslandObject31 = CreatePlayerObject(playerid, 1655, 3909.240967, -1043.196167, 6.256646, 2.5783, 30.0803, 349.6868);
		SpawnIslandObject32 = CreatePlayerObject(playerid, 2931, 3932.270752, -1035.791382, 0.229957, 0.0000, 0.0000, 282.6507);
		SpawnIslandObject33 = CreatePlayerObject(playerid, 13604, 3941.704834, -1016.693237, 3.157049, 0.0000, 0.0000, 354.8434);
		SpawnIslandObject34 = CreatePlayerObject(playerid, 13638, 3963.822021, -1054.860352, 9.098953, 0.8594, 337.6546, 0.0000);
		SpawnIslandObject35 = CreatePlayerObject(playerid, 13641, 3958.970459, -994.797852, 4.787591, 3.4377, 359.1406, 27.5020);
		SpawnIslandObject36 = CreatePlayerObject(playerid, 13647, 3912.631104, -1006.394836, 9.066553, 0.8594, 12.8916, 24.9237);
	}
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerDeath(playerid, killerid, reason)
{
    FadePlayerScreen(playerid, 0xFFFFFFCC, 6, 192);
 	GameTextForPlayer(playerid,"~w~LOL, YOU DIED",1000,1);
    SendDeathMessage(killerid, playerid, reason);
    GameTextForPlayer(killerid,"~r~You Murderer!",4000,3);
    if( DMZone[killerid] >= 1 )
    {
		F_GivePlayerMoney(killerid, 1000);
	}
    if( DMZone[killerid] == 0 )
    {
		F_GivePlayerMoney(killerid, -2000);
		SendClientMessage(killerid, COLOR_RED, "Please don't kill others outside deathmatch zones. (-2000$)");
	}
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public LVWZ() //Las Venturas War Zone
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInArea(i, -128.4566, 875.8406, 1272.888, 2767.656))
			{
                if(LVWZTextShowed[i] == false)
                {
					GameTextForPlayer(i, "~w~You entered~n~~r~Las Venturas War Zone", 3000, 3);
			    	LVWZTextShowed[i] = true;
				}
			}
			else
			{
			    LVWZTextShowed[i] = false;
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnVehicleSpawn(vehicleid)
{
	SetTimer("TuneCar",1000,0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public GameModeExitFunc()
{
    GameModeExit();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public TuneCar()
{
	AddVehicleComponent(Uranus1,1092);
	AddVehicleComponent(Uranus1,1088);
	AddVehicleComponent(Uranus1,1090);
	AddVehicleComponent(Uranus1,1094);
	AddVehicleComponent(Uranus1,1166);
	AddVehicleComponent(Uranus1,1168);
	AddVehicleComponent(Uranus1,1163);
	AddVehicleComponent(Uranus1,1010);
	ChangeVehiclePaintjob(Uranus1,2);

	AddVehicleComponent(Elegy1,1034);
	AddVehicleComponent(Elegy1,1036);
	AddVehicleComponent(Elegy1,1038);
	AddVehicleComponent(Elegy1,1040);
	AddVehicleComponent(Elegy1,1146);
	AddVehicleComponent(Elegy1,1149);
	AddVehicleComponent(Elegy1,1171);
	AddVehicleComponent(Elegy1,1010);
	ChangeVehiclePaintjob(Elegy1,1);

	AddVehicleComponent(Sultan1,1026);
	AddVehicleComponent(Sultan1,1027);
	AddVehicleComponent(Sultan1,1028);
	AddVehicleComponent(Sultan1,1033);
	AddVehicleComponent(Sultan1,1139);
	AddVehicleComponent(Sultan1,1141);
	AddVehicleComponent(Sultan1,1169);
	AddVehicleComponent(Sultan1,1010);
	ChangeVehiclePaintjob(Sultan1,2);

	AddVehicleComponent(Flash1,1046);
	AddVehicleComponent(Flash1,1047);
	AddVehicleComponent(Flash1,1051);
	AddVehicleComponent(Flash1,1049);
	AddVehicleComponent(Flash1,1053);
	AddVehicleComponent(Flash1,1150);
	AddVehicleComponent(Flash1,1153);
	AddVehicleComponent(Flash1,1010);
	ChangeVehiclePaintjob(Flash1,2);

	AddVehicleComponent(Uranus2,1092);
	AddVehicleComponent(Uranus2,1088);
	AddVehicleComponent(Uranus2,1090);
	AddVehicleComponent(Uranus2,1094);
	AddVehicleComponent(Uranus2,1166);
	AddVehicleComponent(Uranus2,1168);
	AddVehicleComponent(Uranus2,1163);
	AddVehicleComponent(Uranus2,1010);
	ChangeVehiclePaintjob(Uranus2,2);

	AddVehicleComponent(Elegy2,1034);
	AddVehicleComponent(Elegy2,1036);
	AddVehicleComponent(Elegy2,1038);
	AddVehicleComponent(Elegy2,1040);
	AddVehicleComponent(Elegy2,1146);
	AddVehicleComponent(Elegy2,1149);
	AddVehicleComponent(Elegy2,1171);
	AddVehicleComponent(Elegy2,1010);
	ChangeVehiclePaintjob(Elegy2,1);

	AddVehicleComponent(Sultan2,1026);
	AddVehicleComponent(Sultan2,1027);
	AddVehicleComponent(Sultan2,1028);
	AddVehicleComponent(Sultan2,1033);
	AddVehicleComponent(Sultan2,1139);
	AddVehicleComponent(Sultan2,1141);
	AddVehicleComponent(Sultan2,1169);
	AddVehicleComponent(Sultan2,1010);
	ChangeVehiclePaintjob(Sultan2,2);
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public unlock(playerid,vehicleid)
{
	new i;
	for(i=0;i<MAX_PLAYERS;i++)
	{
		SetVehicleParamsForPlayer(vehicleid,i, 0, 0);
	}
	locked[playerid][vehicleid] = 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public DestroyNRG(playerid)
{
		DestroyVehicle(PVeh[playerid]);
		PVeh[playerid] = 0;
		print("A PVeh has been destroyed !");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public CheckGate()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    //Gate1 (admincastle)
		if(PlayerToPoint(15.0, i,-2914.917969, -68.470116, 4.496734)&& OpenGate1[i] == false) //close --> open
		{
			OpenGate1[i] = true;
			MoveObject(Gate1, -2914.917969, -68.470116, 9.400000, 1.5);
		}
		else if(!PlayerToPoint(15.0, i,-2914.917969, -68.470116, 4.496734) && OpenGate1[i] == true) //open --> close
		{
		    OpenGate1[i] = false;
		  	MoveObject(Gate1, -2914.917969, -68.470116, 4.496734, 1.5);
		}
		//Gate2 (pinkautos)
		if(PlayerToPoint(5.0, i,-1643.2749, 1204.2693, 8.0269)&& OpenGate2[i] == false) //close --> open
		{
			OpenGate2[i] = true;
			MoveObject(Gate2, -1643.2852, 1204.2737, 10.8821, 1.5);
		}
		else if(!PlayerToPoint(5.0, i,-1643.2749, 1204.2693, 8.0269) && OpenGate2[i] == true) //open --> close
		{
		    OpenGate2[i] = false;
		  	MoveObject(Gate2, -1643.2749, 1204.2693, 8.0269, 1.5);
		}

		//Cage
		//Gate3 (Cage) U
		if(PlayerToPoint(5.0, i,-423.699341, 2201.723145, 40.926292)&& OpenGateCage[i] == false) //close --> open
		{
			OpenGateCage[i] = true;
		  	MoveObject(Gate3, -423.692413, 2201.705811, 50.923096, 10.0);
		  	MoveObject(Gate4, -423.686127, 2206.743164, 45.926369, 10.0);
		  	MoveObject(Gate5, -418.655365, 2201.730713, 45.926369, 10.0);
		  	MoveObject(Gate6, -423.685608, 2196.700928, 45.913692, 10.0);
		  	MoveObject(Gate7, -428.733124, 2201.718506, 45.926338, 10.0);
		}
		else if(!PlayerToPoint(5.0, i,-423.699341, 2201.723145, 40.926292) && OpenGateCage[i] == true) //open --> close
		{
		    OpenGateCage[i] = false;
			MoveObject(Gate3, -423.692413, 2201.705811, 59.923141, 1.5);
			MoveObject(Gate4, -423.686127, 2215.716309, 45.926369, 1.5);
			MoveObject(Gate5, -409.680603, 2201.730713, 45.926369, 1.5);
			MoveObject(Gate6, -423.685608, 2187.702881, 45.913692, 1.5);
			MoveObject(Gate7, -437.683075, 2201.718506, 45.926338, 1.5);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public BombTimer(playerid)
{
	CreateExplosion(BombX[playerid], BombY[playerid], BombZ[playerid], 11, 10);
	SendClientMessage(playerid, COLOR_GREY, "引爆成功");
	DestroyObject(BombObject[playerid]);
	BombArmed[playerid] = false;
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public Heal()
{
    new Float:Health;
    for(new i=0; i<MAX_PLAYERS; i++) if(IsPlayerConnected(i))
    {
        if(DMZone[i] == 0)
        {
			GetPlayerHealth(i,Health);
			if(!(Health == 100 || Health == 0)) SetPlayerHealth(i, Health +1);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(AntiFalloff[playerid] == true)
	{
		if(oldstate == PLAYER_STATE_DRIVER)
		{
			if(newstate == PLAYER_STATE_ONFOOT)
			{
				if(InCar[playerid] == true)
				{
					PutPlayerInVehicle(playerid, WhatCar[playerid], 0); //Driver
				}
			}
		}
		if(oldstate == PLAYER_STATE_PASSENGER)
		{
			if(newstate == PLAYER_STATE_ONFOOT)
			{
				if(InCar[playerid] == true)
				{
					PutPlayerInVehicle(playerid, WhatCar[playerid], 2); //Passanger
				}
			}
		}
		if(oldstate == PLAYER_STATE_ONFOOT)
		{
			if(newstate == PLAYER_STATE_DRIVER || PLAYER_STATE_PASSENGER)
			{
				InCar[playerid] = true;
				WhatCar[playerid] = GetPlayerVehicleID(playerid);
			}
		}
	}

	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		new str[80]; if (newstate == 2 || newstate == 3)
		{
 			format(str, sizeof(str), "~g~%s",vehName[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
 			GameTextForPlayer(playerid, str, 5000, 1);
		}
 	}
 	if(oldstate == PLAYER_STATE_DRIVER)
	{
		if (locked[playerid][vehid[playerid]] == 1)
			{
    			unlocktimer = SetTimerEx("unlock",300000,0,"ii",playerid,vehid[playerid]);
    			SendClientMessage(playerid,COLOR_GREY,"下车以后交通工具会继续锁 5 分钟");
				locked[playerid][vehid[playerid]] = 2;
    		}
	}
	if (newstate == PLAYER_STATE_DRIVER)
	{
	    if (locked[playerid][vehid[playerid]] == 2)
	    {
	        KillTimer(unlocktimer);
	        locked[playerid][vehid[playerid]] = 1;
	        new Float:pX, Float:pY, Float:pZ;
	        GetPlayerPos(playerid,pX,pY,pZ);
	        PlayerPlaySound(playerid,1056,pX,pY,pZ);
	        SendClientMessage(playerid,COLOR_GREY,"交通工具 已上锁");

	 	}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerCommandText(playerid, cmdtext[])
{

	if(strcmp(cmdtext, "/menu", true) == 0 || strcmp(cmdtext, "/caidan", true) == 0 || strcmp(cmdtext, "/菜单", true) == 0)
	{
	    ShowMenuForPlayer(Teleports, playerid);
	    TogglePlayerControllable(playerid, 0);
		return 1;
	}

	if(strcmp(cmdtext, "/spawn", true) == 0 || strcmp(cmdtext, "/chusheng", true) == 0 || strcmp(cmdtext, "/出生点", true) == 0)
	{
	    ShowMenuForPlayer(SpawnplaceMenu, playerid);
	    TogglePlayerControllable(playerid, 0);
		return 1;
	}

	if(strcmp(cmdtext, "/dm exit", true) == 0 || strcmp(cmdtext, "/jingji tuichu", true) == 0 || strcmp(cmdtext, "/竞技 退出", true) == 0)
	{
		if(DMZone[playerid] >= 1)
		{
			DMZone[playerid] = 0;
	    	SpawnPlayer(playerid);
			SetCameraBehindPlayer(playerid);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "必须参加死亡竞技才可以使用");
		}
		return 1;
	}

	if(strcmp(cmdtext, "/home", true) == 0)
	{
	    NormalTele(playerid, "Home",		-468.3654,2208.0317,46.4776,	115.0000,	-468.3654,2208.0317,46.4776,	115.0000,	0);
		return 1;
	}

	if(strcmp(cmdtext, "/bigjump 1", true) == 0 || strcmp(cmdtext, "/bj 1", true) == 0)
	{
	    NormalTele(playerid, "bj 1",		-594.1223,904.4135,432.5000,	135.0000,	-594.1223,904.4135,432.5000,	135.0000,	0);
		return 1;
	}

	if(strcmp(cmdtext, "/bigjump 2", true) == 0 || strcmp(cmdtext, "/bj 2", true) == 0)
	{
	    NormalTele(playerid, "bj 2",	-639.9559,2328.1963,135.0000,	180.000,	-662.6028,2306.1809,136.0709,	90.0000,	0);
		return 1;
	}

	if(strcmp(cmdtext, "/lstower", true) == 0 || strcmp(cmdtext, "/bj 3", true) == 0)
	{
	    NormalTele(playerid, "bj 3",		1537.1813,-1364.6439,1882.5000,	341.3670,	1541.3605,-1363.4252,1882.5000,	0.0000,		0);
		return 1;
	}

	if(strcmp(cmdtext, "/buildingjump", true) == 0 || strcmp(cmdtext, "/bj 4", true) == 0)
	{
	    SpeceficTele(playerid, "bj 4",-2882.8174,-3074.8611,83.0000,   180.0000,   -2882.8174,-3074.8611,81.0000,   180.0000,   0,   461);
		return 1;
	}

	if(strcmp(cmdtext, "/chilliad", true) == 0 || strcmp(cmdtext, "/bj 5", true) == 0)
	{
		NormalTele(playerid, "bj 5",	-2338.1836, -1631.0298, 483.7010,244.0000,	-2334.8801, -1646.7010, 483.7031, 23.0000, 0);
		return 1;
	}

	if(strcmp(cmdtext, "/wallride", true) == 0 || strcmp(cmdtext, "/bj 6", true) == 0)
	{
	    SpeceficTele(playerid, "bj 6",-803.5533,1833.4768,7.0000,   90.0000,   -803.5533,1833.4768,7.0000,   90.0000,   0,   522);
		return 1;
   	}
   	
   	if(strcmp(cmdtext, "/waytodeath", true) == 0 || strcmp(cmdtext, "/bj 7", true) == 0)
	{
	    SpeceficTele(playerid, "bj 7",996.6433,2787.8489,1067.7532,   90.0000,   1065.7683,2781.0957,1070.5000,   55.0000,   0,   541);
		return 1;
	}

	if(strcmp(cmdtext, "/monstercrash", true) == 0 || strcmp(cmdtext, "/bj 8", true) == 0)
	{
	    SpeceficTele(playerid, "bj 8",-2383.9839,2909.5325,362.3510,   180.0000,   -2379.1731,2956.5103,361.9797,   150.0000,   0,   444);
		return 1;
	}
	
	if(strcmp(cmdtext, "/freeway", true) == 0 || strcmp(cmdtext, "/bj 9", true) == 0)
	{
	    SpeceficTele(playerid, "bj 9",-2847.1392,2185.9849,799.5908,   180.0000,   -2838.7273,2199.9253,801.7857,   145.0000,   0,   568);
		return 1;
	}
	
	if(strcmp(cmdtext, "/upsidedown", true) == 0 || strcmp(cmdtext, "/bj 10", true) == 0)
	{
	    SpeceficTele(playerid, "bj 10",391.1825,-82.5999,558.1525,   270.0000,   355.8427,-78.0696,558.4254,   244.6733,   0,   411);
		return 1;
	}
	
	if(strcmp(cmdtext, "/deadjump", true) == 0 || strcmp(cmdtext, "/bj 11", true) == 0)
	{
	    NormalTele(playerid, "bj 11",  -673.3708,-3024.7944,705.3344,   0.0000,   -678.4291,-3077.5681,705.6073,   336.8739,   0);
		return 1;
   	}
	
	if(strcmp(cmdtext, "/wayofgod", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "WayOfGod", 239.2802, 1561.3365, 586.2000, 74.9583, 283.7652, 1541.8972, 585.7000, 61.3804, 0);
		return 1;
	}

	if(strcmp(cmdtext, "/skatepark", true) == 0)
	{
		OnlyPlayerTele(playerid, "SkatePark",   1920.3247,-1402.8632,13.5703,   0.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/halfpipe", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "HalfPipe",   1296.5239,4289.1680,113.5000,   270.000,   1292.0472,4289.2334,112.0000,   270.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/waytoair", true) == 0)
	{
    	SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		/*DMZone[playerid] = 0;
	    ResetPlayerWeapons(playerid);
		new WayToAir[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(2);
		GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if (RandomSpawn == 0)
			{
				SetVehiclePos(GetPlayerVehicleID(playerid),2225.6536,-584.7317,366.0000);
				SetVehicleZAngle(GetPlayerVehicleID(playerid),353.000);
				SetCameraBehindPlayer(playerid);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
			}
			else if (RandomSpawn == 1)
			{
				SetVehiclePos(GetPlayerVehicleID(playerid),2235.2749,-585.7139,366.0000);
				SetVehicleZAngle(GetPlayerVehicleID(playerid),353.000);
				SetCameraBehindPlayer(playerid);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
			}
		}
		else
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid,2230.0342,-588.9874,364.2000);
			SetPlayerFacingAngle(playerid,355.0000);
			SetCameraBehindPlayer(playerid);
		}
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_BASIC, "You have been teleportated to -WayToAir-");
		format(WayToAir, sizeof(WayToAir), "%s has teleported to /WayToAir", playerName);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(ReceiveInfo[i] == true)
				{
					SendClientMessage(i, COLOR_GREY, WayToAir);
				}
			}
		}*/
		return 1;
	}

	if(strcmp(cmdtext, "/stadium", true) == 0)
	{
	    NormalTele(playerid, "Stadium",   -1478.6078,1646.1399,1052.5313,   208.5000,   -1486.8704,1642.6029,1060.6719,   180.0000,   14);
		return 1;
	}

	if(strcmp(cmdtext, "/tune1", true) == 0 || strcmp(cmdtext, "/tune 1", true) == 0)
	{
	    NormalTele(playerid, "Tune1",   -1935.9851,231.7287,34.1563,   0.0000,   -1935.9851,231.7287,34.1563,   0.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/tune2", true) == 0 || strcmp(cmdtext, "/tune 2", true) == 0)
	{
	    NormalTele(playerid, "Tune2",   -2709.7312,217.4238,4.1797,   90.0000,   -2709.7312,217.4238,4.1797,   90.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/tune3", true) == 0 || strcmp(cmdtext, "/tune 3", true) == 0)
	{
	    NormalTele(playerid, "Tune3",   2386.8020,1036.3203,10.8203,   0.0000,   2386.8020,1036.3203,10.8203,   0.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/tune4", true) == 0 || strcmp(cmdtext, "/tune 4", true) == 0)
	{
	    NormalTele(playerid, "Tune4",   2644.9768,-2030.9032,13.5540,   180.0000,   2644.9768,-2030.9032,13.5540,   180.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/lsstation", true) == 0 || strcmp(cmdtext, "/ls", true) == 0)
	{
		OnlyPlayerTele(playerid, "LSStation",   1734.6804,-1944.9839,13.5646,   126.6849,   0);
		return 1;
	}
	if(strcmp(cmdtext, "/lvstation1", true) == 0 || strcmp(cmdtext, "/lv", true) == 0)
	{
		OnlyPlayerTele(playerid, "LVStation1",   1430.7799,2653.1604,11.3926,   204.4157,   0);
		return 1;
	}
	if(strcmp(cmdtext, "/lvstation2", true) == 0)
	{
		OnlyPlayerTele(playerid, "LVStation2",   2848.7876,1293.9376,11.3906,   238.8593,   0);
		return 1;
	}
	if(strcmp(cmdtext, "/sfstation", true) == 0 || strcmp(cmdtext, "/sf", true) == 0)
	{
		OnlyPlayerTele(playerid, "SFStation",   -1965.7423,161.1771,27.6875,   252.6458,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/bloodringarena", true) == 0)
	{
	    SpeceficTele(playerid, "BloodringArena",1158.0044,-2103.5696,500.0000,   0.0000,   1160.5853,-2103.3530,497.0000,   0.0000,   0,   504);
		return 1;
	}

	if(strcmp(cmdtext, "/dm 5", true) == 0 || strcmp(cmdtext, "/airbattle", true) == 0)
	{
		OnlyPlayerTele(playerid, "AirBattle",   290.8786,1920.0966,17.6406,   270.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/vehicledm", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "VehicleDM",   2010.2626,-17.6970,8.0000,   196.7243,   2018.3121,-11.5412,4.4505,   170.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/dm sniper", true) == 0 || strcmp(cmdtext, "/dm 3", true) == 0)
	{
	    ResetPlayerWeapons(playerid);
		new MinigunMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(6);
		GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
		DMZone[playerid] = 1;
		if (RandomSpawn == 0)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2595.3945,2758.7642,23.8222);
			SetPlayerFacingAngle(playerid, 247.9706);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 1)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2600.9648,2726.4263,23.8222);
			SetPlayerFacingAngle(playerid, 329.4380);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 2)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2639.5300,2729.5732,23.8222);
			SetPlayerFacingAngle(playerid, 46.8321);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 3)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2642.3181,2757.0920,23.8222);
			SetPlayerFacingAngle(playerid, 121.7195);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 4)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2649.0498,2780.8462,19.3222);
			SetPlayerFacingAngle(playerid, 196.2701);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 5)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 2607.4639,2732.1467,36.5386);
			SetPlayerFacingAngle(playerid, 255.2007);
			SetCameraBehindPlayer(playerid);
		}
		GivePlayerWeapon(playerid, 34, 1000);
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 3");
		SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
		format(MinigunMadness, sizeof(MinigunMadness), "[新闻] %s 传送到 /dm 3", playerName);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(ReceiveInfo[i] == true)
				{
					SendClientMessage(i, COLOR_GREY, MinigunMadness);
				}
			}
		}
		return 1;
	}

	if(strcmp(cmdtext, "/dm 2", true) == 0 || strcmp(cmdtext, "/shipmadness", true) == 0)
	{
	    ResetPlayerWeapons(playerid);
		new ShipMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(9);
		GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
		DMZone[playerid] = 2;
		if (RandomSpawn == 0)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2473.3635,1552.3779,33.2273);
			SetPlayerFacingAngle(playerid, 162.4520);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 1)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2464.5215,1531.9247,17.3281);
			SetPlayerFacingAngle(playerid, 356.1172);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 2)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2460.7542,1551.8220,23.1406);
			SetPlayerFacingAngle(playerid, 179.0821);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 3)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2444.2595,1530.2435,20.2344);
			SetPlayerFacingAngle(playerid, 340.1136);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 4)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2401.1440,1532.8340,26.0469);
			SetPlayerFacingAngle(playerid, 17.7140);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 5)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2374.3948,1535.5518,26.0469);
			SetPlayerFacingAngle(playerid, 57.7976);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 6)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2359.6692,1561.0190,26.0469);
			SetPlayerFacingAngle(playerid, 162.1386);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 7)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2382.4871,1547.8801,10.8281);
			SetPlayerFacingAngle(playerid, 108.2448);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 8)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -2422.0405,1551.3163,7.9219);
			SetPlayerFacingAngle(playerid, 143.3385);
			SetCameraBehindPlayer(playerid);
		}
		GivePlayerWeapon(playerid, 4, 1);
		GivePlayerWeapon(playerid, 24, 47);
		GivePlayerWeapon(playerid, 26, 100);
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 2");
		SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
		format(ShipMadness, sizeof(ShipMadness), "[新闻] %s 传送到 /dm 2", playerName);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(ReceiveInfo[i] == true)
				{
					SendClientMessage(i, COLOR_GREY, ShipMadness);
				}
			}
		}
		return 1;
	}

	if(strcmp(cmdtext, "/dm 1", true) == 0 || strcmp(cmdtext, "/glassmadness", true) == 0)
	{
		ResetPlayerWeapons(playerid);
		new GlassMadness[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(8);
		GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
		DMZone[playerid] = 3;
		if (RandomSpawn == 0)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -33.6020,1507.4240,95.4173);
			SetPlayerFacingAngle(playerid, 325.6300);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 1)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -12.6829,1507.4701,95.4341);
			SetPlayerFacingAngle(playerid, 40.2041);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 2)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -12.6831,1544.3137,95.4309);
			SetPlayerFacingAngle(playerid, 146.1118);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 3)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -32.7342,1543.9973,95.4126);
			SetPlayerFacingAngle(playerid, 220.0591);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 4)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -23.6215,1545.4828,95.4222);
			SetPlayerFacingAngle(playerid, 181.8555);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 5)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -11.9289,1525.8883,95.4330);
			SetPlayerFacingAngle(playerid, 89.4213);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 6)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -23.4273,1505.9843,95.4257);
			SetPlayerFacingAngle(playerid, 359.8071);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 7)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, -34.1823,1525.6079,95.4088);
			SetPlayerFacingAngle(playerid, 270.5063);
			SetCameraBehindPlayer(playerid);
		}
		GivePlayerWeapon(playerid, 29, 500);
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_BASIC, "你传送到 /dm 1");
		SendClientMessage(playerid, COLOR_RED, "宁虽败犹荣,勿胜之不武!!!");
		format(GlassMadness, sizeof(GlassMadness), "[新闻] %s 传送到 /dm 1", playerName);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(ReceiveInfo[i] == true)
				{
					SendClientMessage(i, COLOR_GREY, GlassMadness);
				}
			}
		}
		return 1;
	}

	if(strcmp(cmdtext, "/islanddm", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		/*ResetPlayerWeapons(playerid);
		new IslandDM[128], playerName[MAX_PLAYER_NAME], RandomSpawn = random(5);
		GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
		DMZone[playerid] = 4;
		if (RandomSpawn == 0)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 3767.7358,-1813.6943,19.8772);
			SetPlayerFacingAngle(playerid, 179.3254);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 1)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 3828.8596,-1906.2285,15.4382);
			SetPlayerFacingAngle(playerid, 52.7610);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 2)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 3803.5884,-1965.7352,13.8772);
			SetPlayerFacingAngle(playerid, 46.7841);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 3)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 3688.8562,-1957.8295,14.8801);
			SetPlayerFacingAngle(playerid, 331.2935);
			SetCameraBehindPlayer(playerid);
		}
		if (RandomSpawn == 4)
		{
			InCar[playerid] = false;
			SetPlayerPos(playerid, 3652.4124,-1876.3260,20.8859);
			SetPlayerFacingAngle(playerid, 222.2524);
			SetCameraBehindPlayer(playerid);
		}
		DynUpdateStart(playerid);
		GivePlayerWeapon(playerid, 4, 1);
		GivePlayerWeapon(playerid, 24, 47);
		GivePlayerWeapon(playerid, 26, 44);
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_BASIC, "You have been teleportated to -Island DM-");
		SendClientMessage(playerid, COLOR_RED, "SHOOTING WITH WEAPONS OUTSIDE -ISLAND DM- WIL RESULT IN KICK OR BAN!!!");
		format(IslandDM, sizeof(IslandDM), "%s has teleported to /IslandDM", playerName);
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(ReceiveInfo[i] == true)
				{
					SendClientMessage(i, COLOR_GREY, IslandDM);
				}
			}
		}*/
		return 1;
	}

	if(strcmp(cmdtext, "/rcwar", true) == 0)
	{
		OnlyPlayerTele(playerid, "RCWar",   -1130.8673,1034.7043,1345.7231,   243.5756,   10);
		DMZone[playerid] = 5;
		return 1;
	}

	if(strcmp(cmdtext, "/AA", true) == 0)
	{
	    NormalTele(playerid, "AA",  402.8024,2534.6926,16.700,   150.000,   411.1637,2539.2366,16.5473,   90.0000,   0);
		return 1;
	}
	
	if(strcmp(cmdtext, "/lsair", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "LSAirport",   2058.7854,-2643.9578,13.5469,   0.0000,   2057.2808,-2648.0261,13.5469,   0.0000,   0);
		return 1;
	}
	
	if(strcmp(cmdtext, "/lvair", true) == 0)
	{
		OnlyPlayerTele(playerid, "LVAirport",   1299.8621,1378.2822,10.3751,   0.0000,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/SFAir", true) == 0)
	{
	    NormalTele(playerid, "SFAirport",  -1373.3844,-258.4916,14.0000,   315.0000,   -1373.3844,-258.4916,14.0000,   315.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/dragrace", true) == 0)
	{
	    NormalTele(playerid, "DragRace",  1031.1125,-2297.4236,12.8004,   60.0000,   1031.1125,-2297.4236,12.8004,   60.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/karting", true) == 0)
	{
	    SpeceficTele(playerid, "Karting",2888.9099,1028.5667,17.0000,   0.0000,   2888.9377,1026.1427,13.4755,   0.0000,   0,   571);
		return 1;
	}

	if(strcmp(cmdtext, "/trampoline", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "Trampoline",  2250.6528,338.8527,526.0000,   180.0000,   2217.9050,330.7018,523.0000,   240.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/hopdehop", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "HopDeHop",331.9420,-1288.7561,53.9099,   207.0075,   330.0904,-1284.5708,54.3445,   208.7554,   0,   522);
		return 1;
	}

	if(strcmp(cmdtext, "/waytochilliad", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "WayToChilliad",  -3163.3479,-1226.1855,1398.5236,   243.4468,   -3217.4053,-1204.3394,1398.6516,   277.6004,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/admincastle", true) == 0)
	{
	    NormalTele(playerid, "AdminCastle",  -2891.6179,-76.7571,4.0496,   69.4484,   -2899.2368,-76.9977,4.1619,   52.9987,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/dm 4", true) == 0 || strcmp(cmdtext, "/derby", true) == 0)
	{
	    NormalTele(playerid, "Derby",  -1441.9851,937.9876,1036.3468,   279.2885,   -1424.1138,930.0392,1036.4016,   354.8884,   15);
		return 1;
	}

	if(strcmp(cmdtext, "/dirt", true) == 0)
	{
	    NormalTele(playerid, "Dirt",  -1299.6615,-700.7803,1056.2037,   31.1929,   -1295.2308,-694.4233,1056.4128,   55.7578,   4);
		return 1;
	}

	if(strcmp(cmdtext, "/bmxparcour", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "BMXParcour",1475.2362,-1333.6462,163.2656,   0.0000,   1473.0088,-1359.2314,163.7558,   341.8031,   0,   481);
		return 1;
	}

	if(strcmp(cmdtext, "/wallride2", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "Wallride2",3468.2820,-2980.2456,3.2360,   270.0000,   3428.8757,-2977.2693,3.50905,   250.0000,   0,   411);
		return 1;
	}

	if(strcmp(cmdtext, "/waytopiramide", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "WayToPiramide",  2894.4275,1283.5056,730.8865,   90.0000,   2938.7502,1277.3365,731.3615,   66.0000,   0);
		return 1;
   	}

	if(strcmp(cmdtext, "/nrgparcour", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "NRGParcour",2555.1616,-1411.6984,34.2195,   23.5451,   2555.4250,-1424.5944,34.6545,   31.8932,   0,   522);
		return 1;
	}

	if(strcmp(cmdtext, "/lvtruckstop", true) == 0)
	{
		OnlyPlayerTele(playerid, "LVTruckStop",   661.4391,1718.3545,7.1875,   117.5748,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/ctruckstop", true) == 0)
	{
		OnlyPlayerTele(playerid, "DTruckStop",   -1560.8802,-2735.1248,48.7435,   223.5058,   0);
		return 1;
    }

	if(strcmp(cmdtext, "/dtruckstop", true) == 0)
	{
		OnlyPlayerTele(playerid, "CTruckStop",   -314.5585,1773.8600,43.6406,   192.1722,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/watchrcwar", true) == 0)
	{
		OnlyPlayerTele(playerid, "WatchRCWar",   -1136.3916,1023.5286,1358.9141,   213.5151,   10);
		return 1;
	}

	if(strcmp(cmdtext, "/roofstunt", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "RoofStunt",-1775.5356,579.0707,234.8906,   94.5604,  -1773.7069,572.0452,234.8874,   74.1936,   0,   522);
		return 1;
	}

	if(strcmp(cmdtext, "/aquapark", true) == 0)
	{
        OnlyPlayerTele(playerid, "AquaPark", 284.4926, -1863.2415, 2.8927, 151.0337, 0);
		return 1;
	}

	if(strcmp(cmdtext, "/pinkautos", true) == 0)
	{
	    NormalTele(playerid, "PinkAutos",  -1623.2146,1227.1677,7.0391,   114.0600,   -1620.0802,1221.2664,7.1875,   107.4800,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/drift", true) == 0)
	{
	    OnlyPlayerTele(playerid, "Drift",   -309.9550,1560.8075,75.3594,   250.5937,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/rollercoaster", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "RollerCoaster",1995.2173,938.3616,273.2331,   359.9258,  1989.4508,914.0922,275.6952,   354.6008,   0,   411);
		return 1;
	}

	if(strcmp(cmdtext, "/quadparcour", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "QuadParcour",171.3088,-1790.5005,3.5084,   270.6771,  169.9782,-1794.1268,4.1376,   349.5647,   0,   471);
		return 1;
	}

	if(strcmp(cmdtext, "/bounce", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//NormalTele(playerid, "Bounce",  2973.1985,-2725.4814,9.2444,   209.1594,   2961.0505,-2715.2512,8.8731,   208.6876,   0);
		return 1;
	}

	if(strcmp(cmdtext, "/carsumo", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "开发中,建议与批评请发送到sa-mp@qq.com");
		//SpeceficTele(playerid, "CarSumo",-2333.3159,4050.5703,11.7308,   180.0000,  -2335.2354,4075.6289,11.7308,   180.0000,   0,   444);
		return 1;
	}

	if(strcmp(cmdtext, "/suicide", true) == 0 || strcmp(cmdtext, "/tongkuai", true) == 0)
	{
		SetPlayerHealth(playerid,0.0);
		SendClientMessage(playerid, COLOR_BASIC, "你刚自杀了!");
		return 1;
	}

	if(strcmp(cmdtext, "/kill", true) == 0)
	{
		InCar[playerid] = false;
		SendClientMessage(playerid, COLOR_BASIC, "享受吧!");
		SendClientMessage(playerid,COLOR_GREY,"/Suicide /TongKuai 快速自杀");
		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid,-1808.089722,560.162476,235.500000);
		SetPlayerFacingAngle(playerid,0.0000);
		SetCameraBehindPlayer(playerid);
    	SetPlayerInterior(playerid, 0);
    	GivePlayerWeapon(playerid,5,1);
    	GivePlayerWeapon(playerid,16,2);
    	DynUpdateStart(playerid);
    	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		return 1;
	}

	if(strcmp(cmdtext, "/buyhealth", true) == 0)
	{
	    if (GetPlayerMoney(playerid) > 1000)
	    {
			SetPlayerHealth(playerid,100);
			F_GivePlayerMoney(playerid, -1000);
			SendClientMessage(playerid,COLOR_BASIC,"现金不足 1.000$.");
    		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		}
		else
  		{
			SendClientMessage(playerid,COLOR_RED,"你压根就没钱!");
		}
		return 1;
	}

	if(strcmp(cmdtext, "/buyarmour", true) == 0)
	{
	    if (GetPlayerMoney(playerid) > 5000)
	    {
			SetPlayerArmour(playerid, 100);
			F_GivePlayerMoney(playerid, -5000);
			SendClientMessage(playerid,COLOR_BASIC,"现金不足 5.000$.");
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		}
		else
  		{
			SendClientMessage(playerid,COLOR_RED,"你压根就没钱!");
		}
		return 1;
	}

   	if(strcmp(cmdtext, "/angry") == 0)
   	{
		new name[MAX_PLAYER_NAME+1];
		new String[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(String, sizeof(String), "%s 现在很生气", name);
		SendClientMessageToAll(COLOR_GREY, String);
		return 1;
   	}

   	if(strcmp(cmdtext, "/happy") == 0)
   	{
		new name[MAX_PLAYER_NAME+1];
		new String[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(String, sizeof(String), "%s 现在很开心", name);
		SendClientMessageToAll(COLOR_GREY, String);
		return 1;
   	}

   	if(strcmp(cmdtext, "/back") == 0)
   	{
		new name[MAX_PLAYER_NAME+1];
		new String[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(String, sizeof(String), "%s 回来了", name);
		SendClientMessageToAll(COLOR_GREY, String);
		return 1;
   	}

   	if(strcmp(cmdtext, "/stoned") == 0)
   	{
		new name[MAX_PLAYER_NAME+1];
		new String[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(String, sizeof(String), "%s 爽歪歪中...", name);
		SendClientMessageToAll(COLOR_GREY, String);
		return 1;
   	}

	if(strcmp(cmdtext, "/fix", true) == 0)
	{
    	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    	{
			if(IsPlayerInArea(playerid, 1153.0000, 1307.5000, -2107.5000, -2003.5000) == 1)
        	{
        	    SendClientMessage(playerid,COLOR_RED,"车辆不能修复因为你身处 /BloodringArena.");
        	}
        	else
        	{
            	SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
            	SendClientMessage(playerid,COLOR_BASIC,"交通工具已成功修复");
            	SendClientMessage(playerid,COLOR_GREY,"提示: 按 2 键可直接修复");
            	SendClientMessage(playerid,COLOR_GREY,"        ( 快捷键更方便o(∩_∩)o...).");
            	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        	}
    	}
    	else
    	{
        	SendClientMessage(playerid, COLOR_RED, "(你没有交通工具可供修复).");
    	}
    	return 1;
	}

	if(strcmp(cmdtext, "/parachute", true) == 0 || strcmp(cmdtext, "/jls", true) == 0)
	{
		GivePlayerWeapon(playerid, 46, 1);
		SendClientMessage(playerid,COLOR_BASIC,"你有降落伞了");
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		return 1;
	}

	if(strcmp(cmdtext, "/flowers", true) == 0)
	{
		GivePlayerWeapon(playerid, 14, 1);
		SendClientMessage(playerid,COLOR_BASIC,"你有鲜花了");
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		return 1;
	}

	if(strcmp(cmdtext, "/nightvision", true) == 0)
	{
		GivePlayerWeapon(playerid, 44, 1);
		SendClientMessage(playerid,COLOR_BASIC,"你有夜视镜了");
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		return 1;
	}

	if(strcmp(cmdtext, "/infrared", true) == 0)
	{
		GivePlayerWeapon(playerid, 45, 1);
		SendClientMessage(playerid,COLOR_BASIC,"你有红外镜了");
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		return 1;
	}

	if(strcmp(cmdtext,"/nitro",true)==0)
	{
  		SendClientMessage(playerid,COLOR_BASIC,"点击鼠标左键激活nos,再次点击关闭");
		return 1;
	}

	if(strcmp(cmdtext,"/count",true)==0 || strcmp(cmdtext,"/countdown",true)==0 || strcmp(cmdtext,"/daoshu",true)==0 || strcmp(cmdtext,"/daojishi",true)==0)
	{
		if(IsCountdownStarted == false)
 		{
			Count = 5;
			CountdownTimer = SetTimer("CountDown", 1000, 1);
			IsCountdownStarted = true;
			SendClientMessage(playerid, COLOR_BASIC, "你发起倒计时!");
			new countstring[256];
			new PlayerName[MAX_PLAYER_NAME];
    		GetPlayerName(playerid,PlayerName, MAX_PLAYER_NAME);
			format(countstring, sizeof(countstring), "%s 发起倒计时,看最下方", PlayerName);
			SendClientMessageToAll(COLOR_GREY, countstring);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "A countdown is already started!");
  		}
  		return 1;
	}

    if(strcmp(cmdtext, "/info on", true) == 0)
    {
        if(ReceiveInfo[playerid] == false)
        {
            ReceiveInfo[playerid] = true;
            SendClientMessage(playerid, COLOR_BASIC, "现在开始你的传送点会发送给其他玩家");
            PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "已经开启!");
        }
        return 1;
    }

    if(strcmp(cmdtext, "/info off", true) == 0)
    {
        if(ReceiveInfo[playerid] == true)
        {
	        ReceiveInfo[playerid] = false;
	        SendClientMessage(playerid, COLOR_BASIC, "现在开始你的传送状态是保密的");
	        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "已经关闭");
        }
        return 1;
    }

	if (strcmp(cmdtext, "/flip", true)==0 || strcmp(cmdtext, "/f", true)==0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:PX, Float:PY, Float:PZ, Float:PA;
			GetPlayerPos(playerid, PX, PY, PZ);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), PA);
			SetVehiclePos(GetPlayerVehicleID(playerid), PX, PY, PZ+1);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), PA);
			SendClientMessage(playerid, COLOR_BASIC,"交通工具复位成功");
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED,"只有在交通工具里才能使用");
		}
		return 1;
	}

	if (strcmp(cmdtext, "/lock", true)==0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new State=GetPlayerState(playerid);
			if(State!=PLAYER_STATE_DRIVER)
			{
				SendClientMessage(playerid,COLOR_RED,"You can only lock the doors as the driver.");
				return 1;
			}
			new i;
			for(i=0;i<MAX_PLAYERS;i++)
			{
				if(i != playerid)
				{
					SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 1);
				}
			}
			SendClientMessage(playerid, COLOR_BASIC, "已经上锁了!");
	    	new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
			PlayerPlaySound(playerid, 1137,pX,pY,pZ);
			locked[playerid][GetPlayerVehicleID(playerid)] = 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "只有在交通工具里才能使用");
		}
		return 1;
	}

	if (strcmp(cmdtext, "/unlock", true)==0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new State=GetPlayerState(playerid);
			if(State!=PLAYER_STATE_DRIVER)
			{
				SendClientMessage(playerid,COLOR_RED,"You can only lock the doors as the driver.");
				return 1;
			}
			new i;
			for(i=0;i<MAX_PLAYERS;i++)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 0);
			}
			SendClientMessage(playerid, COLOR_BASIC, "已经解锁!");
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid, 1058,pX,pY,pZ);
			locked[playerid][GetPlayerVehicleID(playerid)] = 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "只有在交通工具里才能使用");
		}
		return 1;
	}
/*
	if (strcmp(cmdtext, "/teleon", true)==0)
	{
    	AllowPlayerTeleport( playerid, 1 );
    	SendClientMessage(playerid, COLOR_BASIC, "Now you can teleport by placing a pointer on your map.");
    	PlayerPlaySound(playerid, 1137   , 0.0, 0.0, 0.0);
		return 1;
	}

	if (strcmp(cmdtext, "/teleoff", true)==0)
	{
    	AllowPlayerTeleport( playerid, 0 );
    	SendClientMessage(playerid, COLOR_BASIC, "MapTeleport has been disabled.");
    	PlayerPlaySound(playerid, 1058  , 0.0, 0.0, 0.0);
		return 1;
	}
*/
    if (strcmp(cmdtext, "/savep", true)==0 || strcmp(cmdtext, "/s", true)==0)
    {
        GetPlayerPos(playerid, PosX[playerid], PosY[playerid], PosZ[playerid]);
        GetPlayerFacingAngle(playerid, PosA[playerid]);
		SendClientMessage(playerid, COLOR_BASIC, "传送点已经保存,使用 /loadp 读取");
        PosI[playerid] = (GetPlayerInterior(playerid));
        PlayerPlaySound(playerid, 1137   , 0.0, 0.0, 0.0);
		return 1;
    }

    if (strcmp(cmdtext, "/loadp", true)==0 || strcmp(cmdtext, "/l", true)==0)
    {
        if (!floatsqroot(PosX[playerid]+PosY[playerid]+PosZ[playerid]))
        {
            return SendClientMessage(playerid, COLOR_RED, "先用 /s 保存传送点,才能使用");
		}
		else
		{
			ResetPlayerWeapons(playerid);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
	            SetVehiclePos(GetPlayerVehicleID(playerid), PosX[playerid], PosY[playerid], PosZ[playerid]);
	            SetVehicleZAngle(GetPlayerVehicleID(playerid), PosA[playerid]);
	            SetCameraBehindPlayer(playerid);
	            LinkVehicleToInterior(GetPlayerVehicleID(playerid), PosI[playerid]);
	        }
	        else
	        {
				InCar[playerid] = false;
		        SetPlayerPos(playerid, PosX[playerid], PosY[playerid], PosZ[playerid]);
		        SetPlayerFacingAngle(playerid, PosA[playerid]);
				SetCameraBehindPlayer(playerid);
			}
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			SetPlayerInterior(playerid, PosI[playerid]);
			SendClientMessage(playerid, COLOR_BASIC, "返回之前的保存的传送点");
		}
		return 1;
    }

    if(strcmp(cmdtext, "/nametags on", true)==0)
	{
   	   	SendClientMessage(playerid, COLOR_BASIC, "名称和血条 开启显示");
    	PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
		for(new i = 0; i < MAX_PLAYERS; i ++)
		{
	    	ShowPlayerNameTagForPlayer(playerid, i, 1);
		}
		return 1;
	}

    if(strcmp(cmdtext, "/nametags off", true)==0)
	{
		SendClientMessage(playerid, COLOR_BASIC, "名称和血条 关闭显示");
    	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		for(new i = 0; i < MAX_PLAYERS; i ++)
		{
	    	ShowPlayerNameTagForPlayer(playerid, i, 0);
		}
		return 1;
	}

	if(strcmp(cmdtext, "/nrg", true)==0)
	{
		if( PVeh[playerid] > 0 )
		{
			if(GetPlayerVehicleID(playerid) !=  PVeh[playerid])
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					RemovePlayerFromVehicle(playerid);
				}
				new Float: X, Float: Y, Float: Z, Float: Ang, Name[30];
				GetPlayerPos(playerid, X, Y, Z);
				GetPlayerFacingAngle(playerid, Ang);
				GetPlayerName(playerid, Name, sizeof( Name ));
				PutPlayerInVehicle(playerid, PVeh[playerid], 0);
				SetVehiclePos(PVeh[playerid], X, Y, Z);
				SetVehicleZAngle(PVeh[playerid], Ang);
				SetVehicleHealth(PVeh[playerid],  1000.0);
				LinkVehicleToInterior(PVeh[playerid], GetPlayerInterior(playerid));
				SendClientMessage(playerid,COLOR_BASIC, "私人NRG召唤成功");
				PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			}
			else
			{
				SendClientMessage(playerid,COLOR_RED, "你已经召唤了一个nrg了");
			}
		}
		else
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				RemovePlayerFromVehicle(playerid);
			}
			new Float: X, Float: Y, Float: Z, Float: Ang, Name[30];
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, Ang);
			GetPlayerName(playerid, Name, sizeof( Name ));
			PVeh[playerid] = CreateVehicle(522, X, Y , Z, Ang, 75,3, 5000000);
			PutPlayerInVehicle(playerid, PVeh[playerid], 0);
			LinkVehicleToInterior(PVeh[playerid], GetPlayerInterior(playerid));
			printf("personal nrg created for %s.", Name);
			SendClientMessage(playerid,COLOR_BASIC, "NRG 召唤成功");
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			SetVehicleParamsForPlayer(PVeh[playerid], playerid, 0, 0);
			for(new i=0; i <= MAX_PLAYERS; i++)
			{
				if ( IsPlayerConnected(i) )
				{
					if ( i != playerid )
					{
						SetVehicleParamsForPlayer(PVeh[playerid], i, 0, 1);
					}
				}
			}
		}
		return 1;
	}

	if (strcmp("/detach", cmdtext, true) == 0)
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if (IsTrailerAttachedToVehicle(vehicleid))
			{
				AttachTrailerToVehicle(GetVehicleTrailer(vehicleid), vehicleid);
				DetachTrailerFromVehicle(vehicleid);
				SendClientMessage(playerid, COLOR_BASIC, "分离成功");
				PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
				return 1;
			}
			SendClientMessage(playerid, COLOR_RED, "没有什么可以分离");
			return 1;
		}
		SendClientMessage(playerid, COLOR_RED, "上拖车以后才能执行");
		return 1;
	}

	if (strcmp("/afon", cmdtext, true) == 0)
	{
		SendClientMessage(playerid, COLOR_BASIC, "现在开始不会从摩托上摔下来了");
		PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
		AntiFalloff[playerid] = true;
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			InCar[playerid] = true;
			WhatCar[playerid] = GetPlayerVehicleID(playerid);
		}
		return 1;
	}

	if (strcmp("/afoff", cmdtext, true) == 0)
	{
		SendClientMessage(playerid, COLOR_BASIC, "现在开始又会从摩托上掉下来啦");
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		AntiFalloff[playerid] = false;
		return 1;
	}

	if (strcmp(cmdtext, "/plant", true)==0)
	{
		if(BombArmed[playerid] == false)
		{
			GetPlayerPos(playerid, BombX[playerid], BombY[playerid], BombZ[playerid]);
			GetXYInFrontOfPlayer(playerid, BombX[playerid], BombY[playerid], 0.7);
			SendClientMessage(playerid, 0x0066FFAA, "炸弹成功安装 (10秒后爆炸).");
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
			BombObject[playerid] = CreateObject(1252, BombX[playerid], BombY[playerid], BombZ[playerid] - 0.8,270,0,0);
			SetTimerEx("BombTimer",10000,0, "d", playerid);
			BombArmed[playerid] = true;
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "一次只能安装一颗炸弹!");
	   	}
		return 1;
	}

    if(strcmp(cmdtext, "/help", true) == 0 || strcmp(cmdtext, "/bangzhu", true) == 0 || strcmp(cmdtext, "/帮助", true) == 0 || strcmp(cmdtext, "/commands", true) == 0 || strcmp(cmdtext, "/cmds", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"帮助索引:");
	    SendClientMessage(playerid,COLOR_2,"*******");
	    SendClientMessage(playerid,COLOR_3,"英文命令: /stunt /race /dm /tour /para /tune /veh /tele /menu /options /anim /weapon");
	    SendClientMessage(playerid,COLOR_4,"拼音命令: /teji /saiche /jingji /lvyou /tiaosan /gaiche /jiaotong /chuansong /caidan /xuanxiang /dongzuo /wuqi");
	    SendClientMessage(playerid,COLOR_5,"中文命令: /特技 /赛车 /竞技 /旅游 /跳伞 /改车 /交通 /传送 /菜单 /选项 /动作 /武器");
	    SendClientMessage(playerid,COLOR_6,"*******");
	    SendClientMessage(playerid,COLOR_7,"/help /bangzhu /帮助");
		return 1;
 	}

	if(strcmp(cmdtext, "/cvvg", true) == 0 || strcmp(cmdtext, "/cmd", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_BASIC,"玩家:       /Afk  /Back  /Kill  /Suicide  /BuyHealth  /BuyArmour /Stoned  /Happy  /Angry  /Me");
	    SendClientMessage(playerid,COLOR_BASIC,"交通:");
	    SendClientMessage(playerid,COLOR_BASIC,"其他:   /Spec[ID]  /Plant");
	    SendClientMessage(playerid,COLOR_BASIC,"   /Count");
		return 1;
	}

    if(strcmp(cmdtext, "/stunt", true) == 0 || strcmp(cmdtext, "/teji", true) == 0 || strcmp(cmdtext, "/特技", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"-  /bj 1 ~ bj 11 跳来跳去的特技");
	    SendClientMessage(playerid,COLOR_2,"-  /AquaPark 水上特技");
	    SendClientMessage(playerid,COLOR_3,"-  /LVAirport lv机场 /SFAirport sf机场");
	    SendClientMessage(playerid,COLOR_5,"-  /SkatePark ls自行车特技场");
	    SendClientMessage(playerid,COLOR_7,"-  /Stadium 室内nrg特技  ");
		return 1;
	}
	
	if(strcmp(cmdtext, "/race", true) == 0 || strcmp(cmdtext, "/saiche", true) == 0 || strcmp(cmdtext, "/赛车", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/Karting 卡丁车");
	    SendClientMessage(playerid,COLOR_1,"/Dirt 盗贼车室内赛车 /dragrace 跑车直线竞速");
		return 1;
	}
	

    if(strcmp(cmdtext, "/dm", true) == 0 || strcmp(cmdtext, "/jingji", true) == 0 || strcmp(cmdtext, "/竞技", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_BASIC," ");
	    SendClientMessage(playerid,COLOR_BASIC,"-  /dm 1 ~ /dm 5");
	    SendClientMessage(playerid,COLOR_BASIC,"-  /BloodringArena /RCWar /WatchRCWar /ExitDM");
	    //SendClientMessage(playerid,COLOR_BASIC,"-  /VehicleDM");
	    //SendClientMessage(playerid,COLOR_BASIC,"-  /IslandDM");
		return 1;
	}

    if(strcmp(cmdtext, "/tour", true) == 0 || strcmp(cmdtext, "/lvyou", true) == 0 || strcmp(cmdtext, "/旅游", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"-  /Home -  ");
	    SendClientMessage(playerid,COLOR_2,"-          -                  -  ");
	    SendClientMessage(playerid,COLOR_3,"-          -    -  ");
	    SendClientMessage(playerid,COLOR_4,"-          -  /LSStation     -  /AdminCastle");
	    SendClientMessage(playerid,COLOR_5,"-          -  /SFStation     -  /PinkAutos");
	    SendClientMessage(playerid,COLOR_6,"-  /AA               -  /LVStation1   -  /Drift");
	    SendClientMessage(playerid,COLOR_7,"-  /DragRace  -  /LVStation2");
		return 1;
	}
	if(strcmp(cmdtext, "/para", true) == 0 || strcmp(cmdtext, "/tiaosan", true) == 0 || strcmp(cmdtext, "/跳伞", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/Parachute");
		return 1;
	}
	if(strcmp(cmdtext, "/tune", true) == 0 || strcmp(cmdtext, "/gaiche", true) == 0 || strcmp(cmdtext, "/改车", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/Nitro /Tune1 /Tune2 /Tune3 /Tune4");
		return 1;
	}
	if(strcmp(cmdtext, "/veh", true) == 0 || strcmp(cmdtext, "/jiaotong", true) == 0 || strcmp(cmdtext, "/交通", true) == 0 || strcmp(cmdtext, "/car", true) == 0 || strcmp(cmdtext, "/che", true) == 0 || strcmp(cmdtext, "/车", true) == 0 || strcmp(cmdtext, "/air", true) == 0 || strcmp(cmdtext, "/feiji", true) == 0 || strcmp(cmdtext, "/飞机", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/Detach  /Fix(=RepairVehicle)    /Flip  /Lock  /Unlock  /Nrg /DTruckStop /CTruckStop");
		return 1;
	}
	if(strcmp(cmdtext, "/tele", true) == 0 || strcmp(cmdtext, "/chuansong", true) == 0 || strcmp(cmdtext, "/传送", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/maketele /SaveP (=SavePosition)  /LoadP");
		return 1;
	}
	if(strcmp(cmdtext, "/options", true) == 0 || strcmp(cmdtext, "/xuanxiang", true) == 0 || strcmp(cmdtext, "/选项", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/NametagsOn  /NametagsOff /InfoOn  /InfoOff");
		return 1;
	}
	if(strcmp(cmdtext, "/anim", true) == 0 || strcmp(cmdtext, "/dongzuo", true) == 0 || strcmp(cmdtext, "/动作", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/Animlist");
		return 1;
	}
	if(strcmp(cmdtext, "/weapon", true) == 0 || strcmp(cmdtext, "/wuqi", true) == 0 || strcmp(cmdtext, "/武器", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_1,"/NightVision   /InfraRed /Flowers");
		return 1;
	}

	return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock NormalTele(playerid, telename[], Float:Vx, Float:Vy, Float:Vz, Float:Va, Float:Px, Float:Py, Float:Pz, Float:Pa, interior)
{
    DMZone[playerid] = 0;
	ResetPlayerWeapons(playerid);
	TogglePlayerControllable(playerid, 1);
	new a[128], b[128], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),Vx,Vy,Vz);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),Va);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),interior);
	}
	else
	{
		InCar[playerid] = false;
		SetPlayerPos(playerid,Px,Py,Pz);
		SetPlayerFacingAngle(playerid,Pa);
	}
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, interior);
	format(a, sizeof(a), "[传送] 你传送到 /%s", telename);
	SendClientMessage(playerid, COLOR_BASIC, a);
	format(b, sizeof(b), "[新闻] %s 传送到 /%s", playerName, telename);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(ReceiveInfo[i] == true)
			{
 				SendClientMessage(i, COLOR_GREY, b);
			}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock SpeceficTele(playerid, telename[], Float:Vx, Float:Vy, Float:Vz, Float:Va, Float:Px, Float:Py, Float:Pz, Float:Pa, interior, Vmodel)
{
    DMZone[playerid] = 0;
	ResetPlayerWeapons(playerid);
	TogglePlayerControllable(playerid, 1);
	new a[128], b[128], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) == Vmodel)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),Vx,Vy,Vz);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),Va);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),interior);
	}
	else
	{
		InCar[playerid] = false;
		SetPlayerPos(playerid,Px,Py,Pz);
		SetPlayerFacingAngle(playerid,Pa);
	}
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, interior);
	format(a, sizeof(a), "[传送] 你传送到 /%s", telename);
	SendClientMessage(playerid, COLOR_BASIC, a);
	format(b, sizeof(b), "[新闻] %s 传送到 /%s", playerName, telename);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(ReceiveInfo[i] == true)
			{
				SendClientMessage(i, COLOR_GREY, b);
			}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock OnlyPlayerTele(playerid, telename[], Float:Px, Float:Py, Float:Pz, Float:Pa, interior)
{
    DMZone[playerid] = 0;
    ResetPlayerWeapons(playerid);
	TogglePlayerControllable(playerid, 1);
	new a[128], b[128], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

   	InCar[playerid] = false;
	SetPlayerPos(playerid,Px,Py,Pz);
	SetPlayerFacingAngle(playerid,Pa);

	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, interior);
	format(a, sizeof(a), "[传送] 你传送到 /%s", telename);
	SendClientMessage(playerid, COLOR_BASIC, a);
	format(b, sizeof(b), "[新闻] %s 传送到 /%s", playerName, telename);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(ReceiveInfo[i] == true)
			{
				SendClientMessage(i, COLOR_GREY, b);
			}
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
strtok(const string[], &index)
{
    new length = strlen(string);
    while ((index < length) && (string[index] <= ' '))
    {
        index++;
    }

    new offset = index;
    new result[20];
    while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
    {
        result[index - offset] = string[index];
        index++;
    }
    result[index - offset] = EOS;
    return result;
}
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerScreenFade(playerid, color, speed)
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerScreenColorFade(playerid, color, speed)
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public AutoRepair(playerid)
	{
 		if (IsPlayerInAnyVehicle(playerid))
    	{
        new Float:health;
		new vehicleid = GetPlayerVehicleID(playerid);
        GetVehicleHealth(vehicleid, health);
		if (health < 250)
        {
        SetVehicleHealth(vehicleid,1000);
		PlayerPlaySound(playerid,1186 ,0, 0, 0);
 		GameTextForPlayer(playerid,"~n~~n~~n~~n~~g~Vehicle Repaired!",1000,3);
		}
	}
}

