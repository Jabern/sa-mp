/*x---------------------------------Important-------------------------------------x*/
//**INCLUDES**//
#include <a_samp>
#include <md5>
//**MISC**//

/*x---------------------------------Defining-------------------------------------x*/
//**COLORS*//
#define GREEN 		0x21DD00FF
#define RED 		0xE60000FF
#define ADMIN_RED 	0xFB0000FF
#define YELLOW 		0xFFFF00FF
#define YELLOWb 	0xFFD699FF
#define ORANGE 		0xF97804FF
#define LIGHTRED 	0xFF8080FF
#define LIGHTBLUE 	0x00C2ECFF
#define PURPLE 		0xB360FDFF
#define BLUE 		0x1229FAFF
#define LIGHTGREEN 	0x38FF06FF
#define DARKPINK	0xE100E1FF
#define DARKGREEN 	0x008040FF
#define AQUAGREEN	0x00CACAFB
#define NICESKY 	0x99FFFFAA
#define GREY 		0xCECECEFF
#define WHITE 		0xFFFFFFFF
//**MISC**//
//#define LOGIN_BEFORE_SPAWN      // If uncommented, players will have to login before spawning if their account exists. If commented, they can spawn without logging in.
//#define ENABLE_AUTO_LOGIN       // LEAVE IT COMMENTED(BUGGED) -- Allows you to auto-login when you connect if you had the same IP as previous login.
//**VARIABLES**//
enum Info
{
	AdminLevel,
	Password[128],
	Cash,
	Warns,
	Jail,
	Logged,
	Mute,
	WarnReason1[128],
	WarnReason2[128],
	WarnReason3[128],
	IP[20],
};
new ViewCommands[2][128] = // 2 = amount of commands to view
{
	{"/admins"},
	{"/count"}
};
new VehNames[212][] = {	// Vehicle Names - Betamaster
	{"Landstalker"},
	{"Bravura"},
	{"Buffalo"},
	{"Linerunner"},
	{"Perrenial"},
	{"Sentinel"},
	{"Dumper"},
	{"Firetruck"},
	{"Trashmaster"},
	{"Stretch"},
	{"Manana"},
	{"Infernus"},
	{"Voodoo"},
	{"Pony"},
	{"Mule"},
	{"Cheetah"},
	{"Ambulance"},
	{"Leviathan"},
	{"Moonbeam"},
	{"Esperanto"},
	{"Taxi"},
	{"Washington"},
	{"Bobcat"},
	{"Mr Whoopee"},
	{"BF Injection"},
	{"Hunter"},
	{"Premier"},
	{"Enforcer"},
	{"Securicar"},
	{"Banshee"},
	{"Predator"},
	{"Bus"},
	{"Rhino"},
	{"Barracks"},
	{"Hotknife"},
	{"Trailer 1"}, //artict1
	{"Previon"},
	{"Coach"},
	{"Cabbie"},
	{"Stallion"},
	{"Rumpo"},
	{"RC Bandit"},
	{"Romero"},
	{"Packer"},
	{"Monster"},
	{"Admiral"},
	{"Squalo"},
	{"Seasparrow"},
	{"Pizzaboy"},
	{"Tram"},
	{"Trailer 2"}, //artict2
	{"Turismo"},
	{"Speeder"},
	{"Reefer"},
	{"Tropic"},
	{"Flatbed"},
	{"Yankee"},
	{"Caddy"},
	{"Solair"},
	{"Berkley's RC Van"},
	{"Skimmer"},
	{"PCJ-600"},
	{"Faggio"},
	{"Freeway"},
	{"RC Baron"},
	{"RC Raider"},
	{"Glendale"},
	{"Oceanic"},
	{"Sanchez"},
	{"Sparrow"},
	{"Patriot"},
	{"Quad"},
	{"Coastguard"},
	{"Dinghy"},
	{"Hermes"},
	{"Sabre"},
	{"Rustler"},
	{"ZR-350"},
	{"Walton"},
	{"Regina"},
	{"Comet"},
	{"BMX"},
	{"Burrito"},
	{"Camper"},
	{"Marquis"},
	{"Baggage"},
	{"Dozer"},
	{"Maverick"},
	{"News Chopper"},
	{"Rancher"},
	{"FBI Rancher"},
	{"Virgo"},
	{"Greenwood"},
	{"Jetmax"},
	{"Hotring"},
	{"Sandking"},
	{"Blista Compact"},
	{"Police Maverick"},
	{"Boxville"},
	{"Benson"},
	{"Mesa"},
	{"RC Goblin"},
	{"Hotring Racer A"}, //hotrina
	{"Hotring Racer B"}, //hotrinb
	{"Bloodring Banger"},
	{"Rancher"},
	{"Super GT"},
	{"Elegant"},
	{"Journey"},
	{"Bike"},
	{"Mountain Bike"},
	{"Beagle"},
	{"Cropdust"},
	{"Stunt"},
	{"Tanker"}, //petro
	{"Roadtrain"},
	{"Nebula"},
	{"Majestic"},
	{"Buccaneer"},
	{"Shamal"},
	{"Hydra"},
	{"FCR-900"},
	{"NRG-500"},
	{"HPV1000"},
	{"Cement Truck"},
	{"Tow Truck"},
	{"Fortune"},
	{"Cadrona"},
	{"FBI Truck"},
	{"Willard"},
	{"Forklift"},
	{"Tractor"},
	{"Combine"},
	{"Feltzer"},
	{"Remington"},
	{"Slamvan"},
	{"Blade"},
	{"Freight"},
	{"Streak"},
	{"Vortex"},
	{"Vincent"},
	{"Bullet"},
	{"Clover"},
	{"Sadler"},
	{"Firetruck LA"}, //firela
	{"Hustler"},
	{"Intruder"},
	{"Primo"},
	{"Cargobob"},
	{"Tampa"},
	{"Sunrise"},
	{"Merit"},
	{"Utility"},
	{"Nevada"},
	{"Yosemite"},
	{"Windsor"},
	{"Monster A"}, //monstera
	{"Monster B"}, //monsterb
	{"Uranus"},
	{"Jester"},
	{"Sultan"},
	{"Stratum"},
	{"Elegy"},
	{"Raindance"},
	{"RC Tiger"},
	{"Flash"},
	{"Tahoma"},
	{"Savanna"},
	{"Bandito"},
	{"Freight Flat"}, //freiflat
	{"Streak Carriage"}, //streakc
	{"Kart"},
	{"Mower"},
	{"Duneride"},
	{"Sweeper"},
	{"Broadway"},
	{"Tornado"},
	{"AT-400"},
	{"DFT-30"},
	{"Huntley"},
	{"Stafford"},
	{"BF-400"},
	{"Newsvan"},
	{"Tug"},
	{"Trailer 3"}, //petrotr
	{"Emperor"},
	{"Wayfarer"},
	{"Euros"},
	{"Hotdog"},
	{"Club"},
	{"Freight Carriage"}, //freibox
	{"Trailer 3"}, //artict3
	{"Andromada"},
	{"Dodo"},
	{"RC Cam"},
	{"Launch"},
	{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},
	{"Police Ranger"},
	{"Picador"},
	{"S.W.A.T. Van"},
	{"Alpha"},
	{"Phoenix"},
	{"Glendale"},
	{"Sadler"},
	{"Luggage Trailer A"}, //bagboxa
	{"Luggage Trailer B"}, //bagboxb
	{"Stair Trailer"}, //tugstair
	{"Boxville"},
	{"Farm Plow"}, //farmtr1
	{"Utility Trailer"} //utiltr1
};

new WeapNames[][32] = {
	{"Unarmed (Fist)"}, // 0
	{"Brass Knuckles"}, // 1
	{"Golf Club"}, // 2
	{"Night Stick"}, // 3
	{"Knife"}, // 4
	{"Baseball Bat"}, // 5
	{"Shovel"}, // 6
	{"Pool Cue"}, // 7
	{"Katana"}, // 8
	{"Chainsaw"}, // 9
	{"Purple Dildo"}, // 10
	{"Big White Vibrator"}, // 11
	{"Medium White Vibrator"}, // 12
	{"Small White Vibrator"}, // 13
	{"Flowers"}, // 14
	{"Cane"}, // 15
	{"Grenade"}, // 16
	{"Teargas"}, // 17
	{"Molotov"}, // 18
	{" "}, // 19
	{" "}, // 20
	{" "}, // 21
	{"Colt 45"}, // 22
	{"Colt 45(Silenced)"}, // 23
	{"Deagle"}, // 24
	{"Normal Shotgun"}, // 25
	{"Sawnoff Shotgun"}, // 26
	{"Combat Shotgun"}, // 27
	{"Micro Uzi(Mac 10)"}, // 28
	{"SMG(MP5)"}, // 29
	{"AK47"}, // 30
	{"M4"}, // 31
	{"Tec9"}, // 32
	{"Country Rifle"}, // 33
	{"Sniper Rifle"}, // 34
	{"Rocket Launcher"}, // 35
	{"Heat-Seeking Rocket Launcher"}, // 36
	{"Flamethrower"}, // 37
	{"Minigun"}, // 38
	{"Satchel Charge"}, // 39
	{"Detonator"}, // 40
	{"Spray Can"}, // 41
	{"Fire Extinguisher"}, // 42
	{"Camera"}, // 43
	{"Night Vision Goggles"}, // 44
	{"Infrared Vision Goggles"}, // 45
	{"Parachute"}, // 46
	{"Fake Pistol"} // 47
};
new AccountInfo[MAX_PLAYERS][Info];
new SuperPunch[MAX_PLAYERS];
new ViewCmds[MAX_PLAYERS];
new Count = 999;
new Hide[MAX_PLAYERS];
new Drugs[MAX_PLAYERS];
new bool:PMBlock[MAX_PLAYERS];
new Nuke[MAX_PLAYERS];
new Missile[MAX_PLAYERS];


new SetVecPos_Cur;
new Float:SetVecPos[][4]={

	{2078.1274,2431.6028,49.1482,91.7132},{2094.7537,2430.6274,49.1482,80.4249},
	{2089.5876,2412.6272,49.1486,269.1313},{2074.3176,2413.3003,49.1485,270.7480},
	{2074.0732,2393.0762,49.1481,90.0920},{2092.6541,2393.0457,49.1478,91.9103},
	{2091.0618,2414.3972,44.8451,272.7036},{2073.4063,2413.8010,44.8440,271.7435},
	{2074.7388,2395.8623,44.8415,88.7058},{2091.6912,2395.4819,44.8431,86.9834},
	{2113.5142,2394.3521,44.8486,87.0345},{2078.8135,2429.7109,40.5468,85.7182},
	{2096.9619,2428.3333,40.5466,85.1598},{2110.4551,2427.1934,40.5477,83.1122},
	{2107.8711,2409.0808,40.5471,272.1830},{2090.6252,2408.7385,40.5478,270.8545},
	{2071.5884,2408.4536,40.5463,270.8531},{2074.6541,2394.4304,40.5501,90.0613},
	{2091.6848,2394.4495,40.5451,90.0656},{2109.4690,2394.4612,40.5491,90.1596},
	{2091.0796,2388.6875,36.2431,270.7075},{2072.8862,2390.7935,36.2469,268.4477},
	{2074.0098,2419.8130,36.2395,90.7831},{2091.9116,2420.0654,36.2388,90.8154},
	{2108.8657,2420.3020,36.2413,90.7898},{2107.5029,2404.9041,36.2422,92.0341},
	{2106.6597,2390.0281,36.2439,92.7230},{2073.6199,2423.3958,31.9453,267.5657},
	{2076.1350,2407.3550,31.9462,92.6575},{2073.8750,2390.4299,31.9500,91.2343},
	{2091.4099,2389.3689,31.9453,87.7511},{2089.3135,2407.0271,31.9453,269.4948},
	{2092.2261,2423.3921,31.9450,88.9500},{2107.9773,2423.2830,31.9449,89.1680},
	{2107.3242,2407.9753,31.9453,94.2083},{2108.2034,2389.8965,31.9493,269.8257},
	{2074.5288,2424.6848,27.6483,87.8828},{2092.5461,2424.2942,27.6486,90.1934},
	{2090.5134,2409.5649,27.6493,271.9428},{2073.8440,2409.0024,27.6486,271.9303},
	{2074.1138,2389.6919,27.6520,92.8467},{2091.4277,2389.5977,27.6484,91.3441},
	{2074.0596,2389.0361,23.3480,87.7623},{2073.3862,2407.9663,23.3438,266.0427},
	{2074.1448,2422.5510,23.3437,87.5704},{2092.5095,2423.4041,23.3439,89.7560},
	{2090.1086,2405.7466,23.3437,269.6876},{2092.5439,2390.0112,23.3443,89.8806},
	{2075.4336,2423.3127,19.0469,95.1437},{2074.7607,2408.1514,19.0467,95.2202},
	{2073.4958,2389.3804,19.0509,86.4162},{2091.9448,2390.1819,19.0469,92.3115},
	{2092.5020,2406.1599,19.0468,88.6654},{2093.8484,2422.3696,19.0470,87.5442},
	{2111.5979,2422.4287,19.0467,89.7594},{2110.9072,2406.7476,19.0467,87.6759},
	{2111.4929,2389.9307,19.0507,86.9692},{2075.0569,2407.0286,14.7424,91.3559},
	{2074.3064,2419.9102,14.7423,89.9810},{2073.7393,2390.8123,14.7462,88.7373},
	{2092.7141,2391.0815,14.7423,91.4021},{2091.4365,2406.7927,14.7419,92.8885},
	{2091.0662,2419.8613,14.7419,89.7395},{2110.0581,2421.1616,14.7420,88.1244},
	{2109.5039,2407.2722,14.7418,88.9258},{2109.2310,2395.4211,14.7432,88.3938}
};



//**FORWARDS**//
forward SendClientMessageToAdmins(color,string[],alevel);
forward OnPlayerRegister(playerid,password[]);
forward OnPlayerLogin(playerid,password[]);
forward OnPlayerUpdateAccount(playerid);
forward BanLog(string[]);
forward KickLog(string[]);
forward VehicleLog(string[]);
forward CountDown();



forward GetPlayerAdminLevel(playerid);

public GetPlayerAdminLevel(playerid){
	if(IsPlayerConnected(playerid)){
		new
			tmpval;
		tmpval = AccountInfo[playerid][AdminLevel];
		return tmpval;
	}
	return false;
}
/*x---------------------------------CallBacks-------------------------------------x*/
stock strtok(const string[], &index,seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[128];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}

	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))
	{
		index++;
	}
	return result;
}
stock IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	if (string[i] > '9' || string[i] < '0')
    return 0;
	return 1;
}

ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21)
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID;
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos]))
	{
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
				userid = INVALID_PLAYER_ID;
			else return userid;
		}
	}
	new len = strlen(text[pos]);
	new count = 0;
	new pname[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, pname, sizeof (pname));
			if (strcmp(pname, text[pos], true, len) == 0)
			{
				if (len == strlen(pname)) return i;
				else
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count) SendClientMessage(playerid, YELLOW, "There are multiple users, enter full playername.");
			else SendClientMessage(playerid, RED, "Playername not found.");
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid;
}
stock GetFileString(string[])
{
	new result[128];
	result[0] = 0;
    if (strfind(string, ":", true) == -1) return result;
    new id = strfind(string, ":", true);
    strmid(result, string, 0, id, 128);
    return result;
}

stock GetFileValue(string[])
{
	new val[128];
	val[0] = 0;
	if (strfind(string , ":", true) == -1) return val;
	new id = strfind(string, ":", true);
	strmid(val, string, id+2, strlen(string), 128);
	return val;
}

public VehicleLog(string[])
{
	new entry[128];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("vehiclespawn.log", io_append);
	if (hFile)
	{
		fwrite(hFile, entry);
		fclose(hFile);
	}
}

public KickLog(string[])
{
	new entry[128];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("kick.log", io_append);
	if (hFile)
	{
		fwrite(hFile, entry);
		fclose(hFile);
	}
}

public BanLog(string[])
{
	new entry[128];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("ban.log", io_append);
	if (hFile)
	{
		fwrite(hFile, entry);
		fclose(hFile);
	}
}
public SendClientMessageToAdmins(color,string[],alevel)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (AccountInfo[i][AdminLevel] >= alevel)
			{
				SendClientMessage(i, color, string);
				printf("%s", string);
			}
		}
	}
	return 1;
}
public OnPlayerRegister(playerid, password[])
{
	if(IsPlayerConnected(playerid))
	{
	    new name[MAX_PLAYER_NAME], str[128], ip[15];
	    GetPlayerName(playerid, name, sizeof name);
	    GetPlayerIp(playerid, ip, sizeof ip);
	    format(str, sizeof str, "/sAccounts/%s.seifadmin", name);
	    new File:account = fopen(str, io_write);
	    if (account)
		{
  			strmid(AccountInfo[playerid][Password], password, 0, strlen(password), 255);
		   	AccountInfo[playerid][Cash] = GetPlayerMoney(playerid);
			new file[128];
			{
				format(file, sizeof file, "Password: %s\n\r", AccountInfo[playerid][Password]);
				{	fwrite(account, file); }
				format(file, sizeof file, "AdminLevel: %d\n\r",AccountInfo[playerid][AdminLevel]);
				{	fwrite(account, file); }
				format(file, sizeof file, "Cash: %d\n\r", AccountInfo[playerid][Cash]);
				{	fwrite(account, file); }
				format(file, sizeof file, "Warnings: %d\n\r",AccountInfo[playerid][Warns]);
				{	fwrite(account, file); }
				format(file, sizeof file, "WarnReason1: %s\n\r",AccountInfo[playerid][WarnReason1]);
				{	fwrite(account, file); }
				format(file, sizeof file, "WarnReason2: %s\n\r",AccountInfo[playerid][WarnReason2]);
				{	fwrite(account, file); }
				format(file, sizeof file, "WarnReason3: %s\n\r",AccountInfo[playerid][WarnReason3]);
				{	fwrite(account, file); }
				format(file, sizeof file, "IPAddress: %s\n\r",ip);
				{	fwrite(account, file); }
			}
			fclose(account);
			SendClientMessage(playerid, GREEN, "|- Account successfully registered. You can now login ( /login [password] ) -|");
		}
	}
	return 1;
}

public OnPlayerUpdateAccount(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(AccountInfo[playerid][Logged] == 1)
		{
			new name[MAX_PLAYER_NAME], str[128];
		    GetPlayerName(playerid, name, sizeof name);
		    format(str, sizeof str, "/sAccounts/%s.seifadmin", name);
		    new File:account = fopen(str, io_write);
		    if (account)
   			{
			   	AccountInfo[playerid][Cash] = GetPlayerMoney(playerid);
				new file[128];
				{
					format(file, sizeof file, "Password: %s\n\r", AccountInfo[playerid][Password]);
					{	fwrite(account, file); }
					format(file, sizeof file, "AdminLevel: %d\n\r",AccountInfo[playerid][AdminLevel]);
					{	fwrite(account, file); }
					format(file, sizeof file, "Cash: %d\n\r", AccountInfo[playerid][Cash]);
					{	fwrite(account, file); }
					format(file, sizeof file, "Warnings: %d\n\r",AccountInfo[playerid][Warns]);
					{	fwrite(account, file); }
					format(file, sizeof file, "WarnReason1: %s\n\r",AccountInfo[playerid][WarnReason1]);
					{	fwrite(account, file); }
					format(file, sizeof file, "WarnReason2: %s\n\r",AccountInfo[playerid][WarnReason2]);
					{	fwrite(account, file); }
					format(file, sizeof file, "WarnReason3: %s\n\r",AccountInfo[playerid][WarnReason3]);
					{	fwrite(account, file); }
					format(file, sizeof file, "IPAddress: %s\n\r",AccountInfo[playerid][IP]);
					{	fwrite(account, file); }
				}
				fclose(account);
			}
		}
	}
	return 1;
}

public OnPlayerLogin(playerid, password[])
{
    new name[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, name, sizeof name);
	format(str, sizeof str, "/sAccounts/%s.seifadmin", name);
	new File:account = fopen(str, io_read);
	if (account)
	{
	    new pass[256];
	    new passres[128], value[128];
	    fread(account, pass, sizeof pass);
	    passres = GetFileString(pass);
	    if (!strcmp("Password", passres))
		{
			value = GetFileValue(pass);
			strmid(AccountInfo[playerid][Password], value, 0, strlen(value)-1, 128);
		}
		if (!strcmp(AccountInfo[playerid][Password], password, true))
		{
		    while (fread(account, pass, 256))
			{
				passres = GetFileString(pass);
				if (strfind(passres, "AdminLevel") != -1)
				{
					value = GetFileValue(pass);
					AccountInfo[playerid][AdminLevel] = strval(value);
				}
				if (strfind(passres, "Cash") != -1)
				{
					value = GetFileValue(pass);
					AccountInfo[playerid][Cash] = strval(value);
				}
                if (strfind(passres, "Warnings") != -1)
				{
					value = GetFileValue(pass);
					AccountInfo[playerid][Warns] = strval(value);
				}
				if (strfind(passres, "WarnReason1") != -1)
				{
					value = GetFileValue(pass);
					strmid(AccountInfo[playerid][WarnReason1], value, 0, strlen(value)-1, 128);
				}
				if (strfind(passres, "WarnReason2") != -1)
				{
					value = GetFileValue(pass);
					strmid(AccountInfo[playerid][WarnReason2], value, 0, strlen(value)-1, 128);
				}
				if (strfind(passres, "WarnReason3") != -1)
				{
					value = GetFileValue(pass);
					strmid(AccountInfo[playerid][WarnReason3], value, 0, strlen(value)-1, 128);
				}
			}
   			fclose(account);
            AccountInfo[playerid][Logged] = 1;
		}
		else
		{
			SendClientMessage(playerid, RED, "Incorrect Password.");
	        fclose(account);
	        return 1;
		}
		GivePlayerMoney(playerid, AccountInfo[playerid][Cash]);
		format(str, sizeof str, "|- �ɹ���¼, %s -|", name);
		SendClientMessage(playerid, GREEN, str);
		printf("%s has logged in", name);
  		if (AccountInfo[playerid][AdminLevel] > 0)
		{
        	format(str, sizeof str, "|- GM Ȩ��: %d -|", AccountInfo[playerid][AdminLevel]);
			SendClientMessage(playerid, LIGHTGREEN, str);
			ViewCmds[playerid] = 0;
		}
	}
	return 1;
}

public OnFilterScriptInit()
{
	print("<|-----------------------------------------|>");
	print(" |  .: [  - SeifAdmin Script by Seif -  ] :.  |");
	print("<|-----------------------------------------|>");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	#if defined LOGIN_BEFORE_SPAWN
		new string[128];
		new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid,sendername,24);
		format(string,128,"/sAccounts/%s.seifadmin",sendername);
		if (fexist(string) && AccountInfo[playerid][Logged] == 0)
		{
		    //SendClientMessage(playerid,RED,"Your account is registered. You must first login in order to spawn.");
		    SendClientMessage(playerid,RED,"����һ�����ɷ���������Ҫע��/��¼,Ҳ��������Ǯ/����������");
		    return 0;
		}
	#endif
	return 1;
}

public OnPlayerConnect(playerid)
{
    AccountInfo[playerid][Jail] = 0;
    AccountInfo[playerid][AdminLevel] = 0;
    AccountInfo[playerid][Warns] = 0;
    AccountInfo[playerid][Logged] = 0;
    AccountInfo[playerid][Mute] = 0;
    format(AccountInfo[playerid][Password], 128, " ");
    format(AccountInfo[playerid][WarnReason1], 128, "NONE");
    format(AccountInfo[playerid][WarnReason2], 128, "NONE");
    format(AccountInfo[playerid][WarnReason3], 128, "NONE");
    Drugs[playerid] = 0;
    Hide[playerid] = 0;
    SuperPunch[playerid] = 0;
    ViewCmds[playerid] = 0;
    PMBlock[playerid] = false;
    new string[128];
    new ip[20];
    new sendername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, sendername, sizeof(sendername));
    GetPlayerIp(playerid, ip, sizeof ip);
    strmid(AccountInfo[playerid][IP], ip, 0, strlen(ip), 128);
	format(string, sizeof(string), "/sAccounts/%s.seifadmin", sendername);
	//if (!fexist(string)) return SendClientMessage(playerid,WHITE,"SERVER: Your account isn't registered. Please register ( /register [password] )");
	if (!fexist(string)) return SendClientMessage(playerid,WHITE,"��ʾ:������ Shift ȷ�������ɫ,���ҡ���������л���ɫ");
	#if defined ENABLE_AUTO_LOGIN
	{
		new File:user = fopen(string, io_read);
		if (user)
		{
		    new pass[128];
		    new passres[128], value[128];
		    new loop = 1;
		    WHILE:
		    while (fread(user, pass))
		    {
		        printf("line: %s", pass);
		        strmid(passres, GetFileString(pass), 0, strlen(GetFileString(pass)), 128);
			    if (loop == 1)
			    {
			        if (!strcmp("IPAddress", passres)) printf("IP; %s", GetFileValue(pass));
				    if (!strcmp("Password", passres))
					{
						value = GetFileValue(pass);
						strmid(AccountInfo[playerid][Password], value, 0, strlen(value)-1, 128);
						loop = 2;
						goto WHILE;
					}
				}
				else if (loop == 2)
				{
				    if (!strcmp("IPAddress", passres))
					{
						printf("%s", passres);
						strmid(passres, value, 0, strlen(value)-1, 20);
						printf("file-ip: %s | player-ip: %s", GetFileValue(pass), AccountInfo[playerid][IP]);
						if (!strcmp(AccountInfo[playerid][IP], passres, true))
						{
						    SendClientMessage(playerid, YELLOW, "|- Auto Login -|");
						    fclose(user);
						    OnPlayerLogin(playerid, AccountInfo[playerid][Password]);
						    return 1;
						}
						else
						{
						    if (fexist(string))
							{
								//SendClientMessage(playerid, WHITE, "SERVER: That account is registered.");
								//SendClientMessage(playerid, ORANGE, "Please login to retrieve your account stats ( /login [password] )");
								SendClientMessage(playerid, WHITE, "��ʾ:������ Shift ȷ�������ɫ,���ҡ���������л���ɫ.");
								SendClientMessage(playerid, ORANGE, "����һ�����ɷ���������Ҫע��/��¼,Ҳ��������Ǯ/����������");
							}
							fclose(user);
						}
					}
				}
			}
			fclose(user);
		}
	}
	#else
	{
		if (fexist(string))
		{
			//SendClientMessage(playerid, WHITE, "SERVER: That account is registered.");
			//SendClientMessage(playerid, ORANGE, "Please login to retrieve your account stats ( /login [password] )");
			SendClientMessage(playerid, WHITE, "��ʾ:������ Shift ȷ�������ɫ,���ҡ���������л�.");
			SendClientMessage(playerid, ORANGE, "����һ�����ɷ���������Ҫע���¼,Ҳ��������Ǯ/����������");
		}
	}
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	OnPlayerUpdateAccount(playerid);
	AccountInfo[playerid][Jail] = 0;
    AccountInfo[playerid][AdminLevel] = 0;
    AccountInfo[playerid][Warns] = 0;
    AccountInfo[playerid][Logged] = 0;
    AccountInfo[playerid][Mute] = 0;
    Drugs[playerid] = 0;
    Hide[playerid] = 0;
    SuperPunch[playerid] = 0;
    ViewCmds[playerid] = 0;
    strmid(AccountInfo[playerid][IP], " ", 0, strlen(" "), 20);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	Drugs[playerid] = 0;
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if (AccountInfo[playerid][Mute] == 1)
	{
	    SendClientMessage(playerid, RED, "�ѱ�����,����ϵGM���.�鿴��ǰ����GM����:/gms /admins");
	    return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128];
	new tmp[128];
	new idx;
	new giveplayername[MAX_PLAYER_NAME];
	new sendername[MAX_PLAYER_NAME];
	new string[128];
	cmd = strtok(cmdtext,idx);
	
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
	    if (IsPlayerConnected(i))
	    {
	        if (AccountInfo[i][AdminLevel] > 0 && ViewCmds[i] == 1)
	        {
	            for(new v = 0; v < sizeof(ViewCommands); v++) if (!strcmp(cmdtext, ViewCommands[v], true))
	            {
	                GetPlayerName(playerid, sendername, sizeof sendername);
	                format(tmp, 128, "[��־] %s(%d): %s", sendername, playerid, cmdtext);
	                SendClientMessage(i, PURPLE, tmp);
	            }
	        }
	    }
	}
	
	/*[ADMINS]*/
/*	if(!strcmp(cmd, "/shanche", true)){
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid)){
			if(GetPlayerVehicleID(playerid) && GetPlayerState(playerid)==PLAYER_STATE_DRIVER){
				new
					Float:ftmp[3];
				GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
				SetVehiclePos(GetPlayerVehicleID(playerid),SetVecPos[SetVecPos_Cur][0],SetVecPos[SetVecPos_Cur][1],SetVecPos[SetVecPos_Cur][2]);
				GetVehicleZAngle(GetPlayerVehicleID(playerid),SetVecPos[SetVecPos_Cur][3]);
				if(SetVecPos_Cur++ >= sizeof(SetVecPos))SetVecPos_Cur=0;
				SetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
				return true;
			}else{
				SendClientMessage(playerid, ORANGE, " ����: /shanche �ƶ������õĳ���");
				return true;
			}
		}else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return true;
	}*/
	if(strcmp(cmd, "/makeadmin", true) == 0 || strcmp(cmd, "/setlevel", true) == 0) // Make player an admin
	{
		if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /makeadmin [playerid] [level 1-5]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Player will be an admin depending on the given level.");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp, playerid);
			tmp = strtok(cmdtext, idx);
			new level = strval(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    if (level >= 0)
			    {
					GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					printf("ADMIN: %s made %s a level %d admin.", sendername, giveplayername, level);
					format(string, sizeof(string), "[֪ͨ] ��ϲ! ���ѳ�Ϊ [Ȩ��:%d]GM, ��ӭ���������������. ����������: /ah, %s", level, sendername);
					SendClientMessage(giveplayerid, LIGHTBLUE, string);
					format(string, sizeof(string), "|- ����Ա %s ���� %s Ϊ GM. [Ȩ��: %d],����Ҵ�Ϊ�ල -|", sendername,giveplayername,level);
					SendClientMessageToAdmins(ADMIN_RED, string, 1);
					AccountInfo[giveplayerid][AdminLevel] = level;
					format(string, sizeof(string), "[֪ͨ] ������ %s Ϊ [Ȩ��:%d] GM", giveplayername,AccountInfo[giveplayerid][AdminLevel]);
					SendClientMessage(playerid, LIGHTBLUE, string);
				}
				else return SendClientMessage(playerid, RED, "You can't go below level 0!");
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%i is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/gmx", true) == 0 || strcmp(cmd, "/restart", true) == 0) // Reboot the server
	{
		if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid)) return GameModeExit();
		else return SendClientMessage(playerid, RED, "You are not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
	}
	
	if(strcmp(cmd, "/kickall", true) == 0) // Kick everyone except the one who does this
	{
		new reason[128];
		if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
		{
			GetPlayerName(playerid, sendername, sizeof(sendername));
			reason = bigstrtok(cmdtext, idx);
			if(!strlen(reason))
			{
				SendClientMessage(playerid, ORANGE, "����: /kickall [ԭ��]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will kick all the players.");
				return 1;
			}
			printf("ADMIN: Admin %s kicked everyone. Reason: %s", sendername, reason);
			format(string, sizeof(string), "-| GM %s kicked everyone. [ԭ��: %s ] |-", sendername,reason);
			SendClientMessageToAll(ADMIN_RED, string);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if (i != playerid)
			    {
					Kick(i);
					KickLog(string);
				}
			}
		}
		else SendClientMessage(playerid, RED, "You are not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/nuke", true) == 0 || strcmp(cmd, "/explode", true) == 0 || strcmp(cmd, "/qgb", true) == 0) // Nuke a player (explode)
	{
		if (AccountInfo[playerid][AdminLevel] >= 3)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /nuke [playerid]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Player will explode.");
				return 1;
			}
			new Float:X,Float:Y,Float:Z;
			new giveplayerid = ReturnUser(tmp, playerid);
		   	if(IsPlayerConnected(giveplayerid))
		   	{
   				GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
	    		GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayerPos(giveplayerid, X,Y,Z);
    			CreateExplosion(X,Y,Z,2,3.0);
				SetPlayerHealth(giveplayerid, 0.0);
				format(string, sizeof(string), "-| GM %s �� %s ���: ������! |-",sendername,giveplayername);
				SendClientMessageToAdmins(ADMIN_RED, string,1);
			}
			else if (!IsPlayerConnected(giveplayerid))
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
   		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/setscore", true) == 0) // Set player a score
	{
		if (IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 3)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /setscore [playerid] [score]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will set a specified player's score");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /score [playerid] [score]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will set a specified player's score");
				return 1;
			}
			new score = strval(tmp);
	   		if(IsPlayerConnected(giveplayerid))
	   		{
				GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerScore(giveplayerid);
				SetPlayerScore(giveplayerid, score);
				format(string, sizeof(string), "You have changed %s's score number to %d.",giveplayername, score);
				SendClientMessage(playerid, GREEN, string);
			}
			else if (!IsPlayerConnected(giveplayerid))
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
   		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/angle", true) == 0) // Shows your current angle + sets it
	{
		if (IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 4)
		{
			new Float:angle;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /angle [angle degree]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will change your current angle.");
				GetPlayerFacingAngle(playerid,angle);
				format(string, sizeof(string), "HELP: Your current angle is %f", angle);
				SendClientMessage(playerid, ORANGE, string);
				return 1;
			}
			angle = floatstr(tmp);
			if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				SetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
				format(string, sizeof(string), "You have changed your angle degree to %f" ,angle);
				SendClientMessage(playerid, GREEN, string);
			}
			else
			{
				SetPlayerFacingAngle(playerid,angle);
				format(string, sizeof(string), "You have changed your angle degree to %f",angle);
				SendClientMessage(playerid, GREEN, string);
			}
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
 	}
 	
 	if(strcmp(cmd, "/rangeban", true) == 0) // Range-bans a player with the amount of ranges entered.
	{
		if (AccountInfo[playerid][AdminLevel] >= 5)
		{
		    tmp = strtok(cmdtext,idx);
			if (!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /rangeban [playername/id] [ranges(2 max)]");
		    new ip[20],ban[128];
		    new giveplayerid = ReturnUser(tmp);
		    if (IsPlayerConnected(giveplayerid))
		    {
		        tmp = strtok(cmdtext,idx);
				if (!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /rangeban [playername/id] [RANGES(2 max)]");
				new ranges = strval(tmp);
				if (ranges < 0 || ranges > 2) return SendClientMessage(playerid, RED, "Minimum ranges: 0 | Maximum ranges: 2");
				if (ranges == 0)
				{
				    Ban(giveplayerid);
				}
			   	GetPlayerName(giveplayerid, giveplayername, sizeof giveplayername);
		       	GetPlayerIp(giveplayerid, ip, sizeof ip);
		       	new count = 1;
		       	for(new i = strlen(ip); i > 0; i--)
		       	{
		       	    if (ip[i] == '.')
		       	    {
		       	        if (count == ranges)
		       	        {
		       	            format(ban, sizeof ban, "banip %s", ip);
			       	        SendRconCommand(ban);
			       	        break;
		       	        }
		       	        else count++;
		       	    }
		       	    else ip[i] = '*';
		       	}
				format(ban, sizeof ban, "%s has been banned with the ip '%s'", giveplayername, ip);
		        SendClientMessage(playerid, GREEN, ban);
		    }
		    else
		    {
				format(string, sizeof(string), "%i is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
		    }
		}
		else SendClientMessage(playerid, RED, "You're not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/ip", true) == 0) // Look at the player's IP address
	{
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /ip [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: View a player's IP.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(IsPlayerConnected(giveplayerid))
			{
				new sstring[256];
				new ip[20];
				GetPlayerIp(giveplayerid, ip, sizeof ip);
				GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				format(sstring, sizeof(sstring), "-| %s's IP: %s |-", giveplayername,ip);
				SendClientMessage(playerid,LIGHTBLUE, sstring);
			}
			else
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/ban", true) == 0 || strcmp(cmd, "/buzaijian", true) == 0 || strcmp(cmd, "/xiaoshi", true) == 0) // Bans a player from the server
	{
		new reason[128];
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /ban [playername/id] [ԭ��]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will BAN the specified player.");
				return 1;
	  		}
	  		
			new giveplayerid = ReturnUser(tmp);
			
			if (AccountInfo[giveplayerid][AdminLevel] > AccountInfo[playerid][AdminLevel])
			{
			    format(string, sizeof(string), "-| [%i]%s tried to ban you! |-",playerid,sendername);
				SendClientMessage(giveplayerid, ADMIN_RED,string);
				SendClientMessage(playerid, ADMIN_RED, "You are not allowed to ban an admin with a higher level than you!");
			}
			
			else if (giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				reason = bigstrtok(cmdtext, idx);
				if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /ban [playername/id] [ԭ��]");
				new ip[20];
				printf("ADMIN: Admin %s banned %s. Reason: %s", sendername, giveplayername, reason);
				format(string, sizeof(string), "-| GM %s ��ɱ %s. [ԭ��: %s ] |-", sendername, giveplayername, reason);
				SendClientMessageToAll(ADMIN_RED, string);
				GetPlayerIp(giveplayerid, ip, sizeof ip);
				format(string, sizeof(string), "-| IP: %s |-", ip);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
				AccountInfo[giveplayerid][AdminLevel] = 0; // Resets the banned player's admin level for security reasons
				format(reason, sizeof reason, "[%s]%s", sendername, reason);
				BanEx(giveplayerid, reason);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/kick", true) == 0 || strcmp(cmd, "/gun", true) == 0 || strcmp(cmd, "/zaijian", true) == 0) // Kicks the player from the server
	{
		new reason[128];
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /kick [playername/id] [ԭ��]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will kick the specified player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				reason = bigstrtok(cmdtext, idx);
				if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /kick [playername/id] [ԭ��]");
				printf("ADMIN: Admin %s kicked %s. Reason: %s", sendername, giveplayername, reason);
				format(string, sizeof(string), "-| GM %s �߳� %s. [ԭ��: %s ] |-", sendername, giveplayername, reason);
				SendClientMessageToAll(ADMIN_RED, string);
				Kick(giveplayerid);
				KickLog(string);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/mute", true) == 0 || strcmp(cmd, "/jinyan", true) == 0) // Mutes the player from talking in the chat box
	{
		new reason[128];
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /mute [playername/id] [ԭ��]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will mute the specified player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);

			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if (AccountInfo[giveplayerid][Mute] == 0)
				{
				    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					reason = bigstrtok(cmdtext, idx);
					if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /mute [playername/id] [ԭ��]");
					printf("ADMIN: Admin %s muted %s. Reason: %s", sendername, giveplayername, reason);
					format(string, sizeof(string), "-| GM %s �� %s �����װ�˸����� [ԭ��: %s ]|-", sendername,giveplayername,reason);
					SendClientMessageToAll(ADMIN_RED, string);
					AccountInfo[giveplayerid][Mute] = 1;
				}
				else if (AccountInfo[giveplayerid][Mute] == 1) SendClientMessage(playerid, RED, "Player is already muted!");
			}

			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/unmute", true) == 0 || strcmp(cmd, "/jiejin", true) == 0) // Unmutes a muted player
	{
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /unmute [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will unmute the specified player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);

			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if (AccountInfo[giveplayerid][Mute] == 1)
				{
				    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "-| GM %s �� %s ����ϵ������������� |-", sendername,giveplayername);
					SendClientMessageToAll(ADMIN_RED, string);
					AccountInfo[giveplayerid][Mute] = 0;
				}
				else if (AccountInfo[giveplayerid][Mute] == 0) SendClientMessage(playerid, RED, "Player isn't muted.");
			}

			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/drugs", true) == 0 || strcmp(cmd, "/godmode", true) == 0 || strcmp(cmd, "/wudi", true) == 0) // Will make the player invinsible until death
	{
	 	if (AccountInfo[playerid][AdminLevel] > 3 || IsPlayerAdmin(playerid))
	 	{
	    	SetPlayerHealth(playerid,999999999); // max HP
	    	Drugs[playerid] = 1;
	    	SendClientMessage(playerid, GREEN, "You are now high on drugs...");
	 	}
	 	else SendClientMessage(playerid, RED, "Drugs are bad for you!");
		return 1;
	}
	
	if(strcmp(cmd, "/freeze", true) == 0 || strcmp(cmd, "/hbz", true) == 0) // Freezes the player. Prevents him from moving
	{
		new reason[128];
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /freeze [playername/id] [ԭ��]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will freeze the specified player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				reason = bigstrtok(cmdtext, idx);
				if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /freeze [playername/id] [ԭ��]");
				format(string, sizeof(string), "-| GM %s �� %s ���: ������ [ԭ��: %s ] |-", sendername, giveplayername, reason);
	   			SendClientMessageToAdmins(ADMIN_RED, string, 1);
				TogglePlayerControllable(giveplayerid, false);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	if(strcmp(cmd, "/unfreeze", true) == 0 || strcmp(cmd, "/jiedong", true) == 0) // Unfreezes the player
	{
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /unfreeze [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will unfreeze the specified player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "-| GM %s �� %s ���: ������ |-", sendername,giveplayername);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
				TogglePlayerControllable(giveplayerid, true);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/setname", true) == 0) // Changes a player's name
	{
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /setname [playername/id] [newname]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will change the player's current name. ");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /setname [playername/id] [newname]");
				format(string, sizeof(string), "-| GM %s ������ %s. [���ǳ�: %s ] |-", sendername, giveplayername, tmp);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
				SetPlayerName(giveplayerid, tmp);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/givecash", true) == 0 || strcmp(cmd, "/jiangli", true) == 0) // Gives some cash to the player
	{
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /givecash [playername/id] [cash]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will give the player some cash. ");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				tmp = strtok(cmdtext, idx);
				new cash = strval(tmp);
				if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /givecash [playername/id] [cash]");
				format(string, sizeof(string), "-| GM %s ���� %s $%d |-", sendername,giveplayername,cash);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
				GivePlayerMoney(giveplayerid, cash);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/akill", true) == 0 || strcmp(cmd, "/qusi", true) == 0 || strcmp(cmd, "/shasi", true) == 0) // If an admin, it kills the player you want. If not, suicide.
	{
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /akill [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will kill the specified player.");
				return 1;
			}
			
			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "-| GM %s ������ %s ������ |-", sendername,giveplayername);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
				SetPlayerHealth(giveplayerid, 0.0);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else
	 	{
	 	    SendClientMessage(playerid, RED, "You have committed suicide.");
	 	    SetPlayerHealth(playerid,0.0);
	  	}
		return 1;
	}
	
	if(strcmp(cmd, "/goto", true) == 0) // Teleports to a player
	{
		new Float:pX,Float:pY,Float:pZ;
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /goto [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will teleport to the specified player.");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			    {
			    	GetPlayerPos(giveplayerid,pX,pY,pZ);
			    	SetVehiclePos(GetPlayerVehicleID(playerid),pX,pY,pZ+2);
		  		}
		  		else
		  		{
			    	GetPlayerPos(giveplayerid,pX,pY,pZ);
			    	SetPlayerPos(playerid,pX,pY,pZ+2);
			    }
			    SetPlayerInterior(playerid,GetPlayerInterior(giveplayerid));
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/get", true) == 0 || strcmp(cmd, "/gethere", true) == 0) // Teleports the player to your position
	{
		new Float:pX,Float:pY,Float:pZ;
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /get [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will teleport the specified player to you.");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    if (GetPlayerState(giveplayerid) == PLAYER_STATE_DRIVER)
			    {
			    	GetPlayerPos(playerid,pX,pY,pZ);
			    	SetVehiclePos(GetPlayerVehicleID(giveplayerid),pX,pY,pZ+2);
		  		}
		  		else
		  		{
			    	GetPlayerPos(playerid,pX,pY,pZ);
			    	SetPlayerPos(giveplayerid,pX,pY,pZ+2);
			    }
			    SetPlayerInterior(giveplayerid,GetPlayerInterior(playerid));
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/teleport", true) == 0 || strcmp(cmd, "/atele", true) == 0 || strcmp(cmd, "/achuansong", true) == 0) // Teleports the player to the other player
	{
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /teleport [playername/id] [targetname/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will teleport the player to the target.");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /teleport [playername/id] [targetname/id]");
				new targetid = ReturnUser(tmp, playerid);
				if (targetid == INVALID_PLAYER_ID) return 1;
			    new Float:tX,Float:tY,Float:tZ;
			    if (GetPlayerState(giveplayerid) == PLAYER_STATE_DRIVER)
			    {
			    	GetPlayerPos(targetid,tX,tY,tZ);
			    	SetVehiclePos(GetPlayerVehicleID(giveplayerid),tX,tY,tZ+2);
		  		}
		  		else
		  		{
			    	GetPlayerPos(targetid,tX,tY,tZ);
			    	SetPlayerPos(giveplayerid,tX,tY,tZ+2);
			    }
			    SetPlayerInterior(giveplayerid,GetPlayerInterior(targetid));
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(!strcmp(cmdtext, "/;", true, 2)) // Admin chat
	{
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
		    if(!strlen(cmdtext[2])) return SendClientMessage(playerid, ORANGE, "����: //<text>"), SendClientMessage(playerid, ORANGE, "HELP: Example: //Hi");
			GetPlayerName(playerid, sendername, sizeof(sendername));
		    format(string, sizeof(string), "GM %s[%i]: %s" ,sendername,playerid, cmdtext[2]);
	  		SendClientMessageToAdmins(YELLOW, string, 1);
			return 1;
		}
		else return SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
	}

	if(strcmp(cmd, "/slap", true) == 0 || strcmp(cmd, "/zhaochou", true) == 0 || strcmp(cmd, "/qianbian", true) == 0  || strcmp(cmd, "/da", true) == 0) // Slap a player
	{
		new Float:pX,Float:pY,Float:pZ;
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /slap [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will slap the specified player");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
			    GetPlayerPos(giveplayerid,pX,pY,pZ);
			    SetPlayerPos(giveplayerid,pX,pY,pZ+5);
				format(string, sizeof(string), "-| GM %s ���� %s(%d) ������Ϸ���� |-",sendername, giveplayername,giveplayerid);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/bslap", true) == 0 || strcmp(cmd, "/henchou", true) == 0 || strcmp(cmd, "/kuanngban", true) == 0) // Slap a player 2 times higher than /slap
	{
		new Float:pX,Float:pY,Float:pZ;
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /bslap [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will double slap the specified player");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
			    GetPlayerPos(giveplayerid,pX,pY,pZ);
			    SetPlayerPos(giveplayerid,pX,pY,pZ+10);
				format(string, sizeof(string), "-| GM %s �ݺݵĳ�� %s |-",sendername, giveplayername);
				SendClientMessageToAdmins(ADMIN_RED, string, 1);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/disarm", true) == 0 || strcmp(cmd, "/moshou", true) == 0) // Reset the player's weapons
	{
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /disarm [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will disarm the player.");
				return 1;
			}

			new giveplayerid = ReturnUser(tmp);
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
			    ResetPlayerWeapons(giveplayerid);
				format(string, sizeof(string), "-| GM %s û�� %s �������� |-",sendername, giveplayername);
				SendClientMessageToAdmins(ADMIN_RED,string,1);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/say", true) == 0 || strcmp(cmd, "/xuanbu", true) == 0) // Publicly says an admin message. Exact same as RCON's 'say' but in a red color.
	{
	    if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
    	{
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new result[128];
			result = bigstrtok(cmdtext, idx);
			if(!strlen(result))
			{
				SendClientMessage(playerid, ORANGE, "����: /say [message]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will broadcast an admin message.�q�ɨr�����ᣩ�q�ɨr");
				return 1;
			}
			format(string, sizeof(string), "* GM����: %s", result);
			SendClientMessageToAll(LIGHTRED, string);
			printf("%s", string);
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/bc", true) == 0 || strcmp(cmd, "/broadcast", true) == 0) // Displays a screen message
	{
	    if (AccountInfo[playerid][AdminLevel] >= 4 || IsPlayerAdmin(playerid))
    	{
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new result[128];
			result = bigstrtok(cmdtext, idx);
			if(!strlen(result))
			{
				SendClientMessage(playerid, ORANGE, "����: /bc [message] [time in seconds(if non entered, 5 seconds will be the time by default)]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will broadcast a screen message");
				return 1;
			}
			new time;
			tmp = strtok(cmdtext, idx);
			if (!strlen(tmp)) time = 5;
			else time = strval(tmp);
			format(string, sizeof(string), "~w~%s", result);
			GameTextForAll(string, time*1000, 4);
			printf("%s", string);
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/veh", true) == 0 || strcmp(cmd, "/zhaohuan", true) == 0 || strcmp(cmd, "/shuache", true) == 0) // Spawn a vehicle. Name supported too.
	{
 		if (AccountInfo[playerid][AdminLevel] >= 4 || IsPlayerAdmin(playerid))
 		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /veh [modelname/id] [color1] [color2]");
				return 1;
			}
			new car = GetVehicleModelIDFromName(tmp);
			if (car == -1)
			{
			    car = strval(tmp);
				if(car < 400 || car > 611) return SendClientMessage(playerid, RED, "Vehicle ID can't be below 400 nor above 611 !");
			}
			
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /veh [modelname/id] [color1] [color2]");
				return 1;
			}
			new color1 = strval(tmp);

			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /veh [modelname/id] [color1] [color2]");
				return 1;
			}
			new color2 = strval(tmp);

			new Float:X,Float:Y,Float:Z,Float:A;
			GetPlayerPos(playerid, X,Y,Z);
			GetPlayerFacingAngle(playerid, A);
			X += (5 * floatsin(-A, degrees));
			Y += (5 * floatcos(-A, degrees));
			new carid = CreateVehicle(car, X,Y,Z, 0.0, color1, color2, 600000000);
			format(string, sizeof(string), "Vehicle %s(%d) spawned.", VehNames[GetVehicleModel(carid)-400], carid);
			SendClientMessage(playerid, GREEN, string);
			GetPlayerName(playerid,sendername,sizeof(sendername));
			format(string, sizeof(string), "-| GM %s �ٻ��� %s(%d) |-", sendername, VehNames[GetVehicleModel(carid)-400], carid);
			SendClientMessageToAdmins(ADMIN_RED, string, 1);
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/pweapons", true) == 0 || strcmp(cmd, "/shawuqi", true) == 0) // Checks a player's weapons
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 1)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /pweapons [playerid/name]");
				return 1;
			}
			new giveplayerid = ReturnUser(tmp);
			if (giveplayerid != INVALID_PLAYER_ID)
			{
				new bullets[12];
				new weapons[12];
				new weapname[12][20];
				for(new i = 0; i < 12; i++)
				{
				    GetPlayerWeaponData(giveplayerid, i+1, weapons[i], bullets[i]);
				    GetWeaponName(weapons[i], weapname[i], 20);
				}
	    		GetPlayerName(giveplayerid, giveplayername, sizeof(giveplayername));
	    		format(string,sizeof(string),"        |-        %s ӵ�е�����        -|",giveplayername);
	    		SendClientMessage(playerid,LIGHTGREEN,string);
				format(string, sizeof(string),"%s(0) - %s(%d) - %s(%d) - %s(%d) - %s(%d) - %s(%d)",weapname[0],weapname[1],bullets[1],weapname[2],bullets[2],weapname[3],bullets[3],weapname[4],bullets[4],weapname[5],bullets[5]);
				SendClientMessage(playerid,YELLOW,string);
				format(string,sizeof(string),"%s(%d) - %s(%d) - %s(%d) - %s(0) - %s(0) - %s(0)",weapname[6],bullets[6],weapname[7],bullets[7],weapname[8],bullets[8],weapname[9],weapname[10],weapname[11]);
				SendClientMessage(playerid,YELLOW,string);
			}
			else SendClientMessage(playerid, RED, "Player is not active.");
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if(strcmp(cmd, "/sethp", true) == 0) // Sets a player's health
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 3)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /sethp [playerid/name] [health]");
				return 1;
			}
			new targetid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			new Float:hp = floatstr(tmp);
			if (targetid != INVALID_PLAYER_ID)
			{
				if (!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /sethp [playerid/name] [health]");
				SetPlayerHealth(targetid,hp);
				if (hp < 1) Drugs[targetid] = 0;
				GetPlayerName(playerid, sendername, sizeof(sendername));
	    		GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
	    		format(string,sizeof(string),"|- GM %s �޸� %s(%d) ������ֵ. [HP: %.2f] -|",sendername,giveplayername,giveplayerid,hp);
	    		SendClientMessageToAdmins(ADMIN_RED, string, 1);
			}
			else SendClientMessage(playerid, RED, "Player is not active.");
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
 		return 1;
	}
	
	if (strcmp(cmd, "/logout", true) == 0 || strcmp(cmd, "/tuichu", true) == 0) // Logs off the admin
	{
		if(AccountInfo[playerid][Logged] == 1)
		{
		    if(AccountInfo[playerid][AdminLevel] >= 1)
			{
		    	OnPlayerUpdateAccount(playerid);
		   		AccountInfo[playerid][Logged] = 0;
		    	AccountInfo[playerid][AdminLevel] = 0;
				SendClientMessage(playerid, GREEN, "�ɹ��˳�.");
			}
			else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		}
		else return SendClientMessage(playerid, RED, "You're not logged in! ( /login [password] )");
		return 1;
	}
	
	if(strcmp(cmd, "/warn", true) == 0 || strcmp(cmd, "/jinggao", true) == 0) // Warns a player. 3 warnings = auto-ban
	{
		if (AccountInfo[playerid][AdminLevel] >= 2)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /warn [playername/id] [ԭ��]");
			new targetid = ReturnUser(tmp);
		   	if(IsPlayerConnected(targetid))
			{
   				if(targetid != INVALID_PLAYER_ID)
       			{
					new reason[128];
					reason = bigstrtok(cmdtext, idx);
					if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /warn [playername/id] [ԭ��]");
					new sstring[128];
					GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					AccountInfo[targetid][Warns] += 1;
					format(string, sizeof(string), "GM %s ������ ԭ��: %s", sendername, reason);
					SendClientMessage(targetid, ADMIN_RED, string);
					format(string, sizeof(string), "-| GM %s ���� %s(%d). [ԭ��: %s ] |-", sendername,giveplayername,giveplayerid, reason);
					SendClientMessageToAdmins(ADMIN_RED,string,1);
					format(string, sizeof(string), "-| %s ���������: %d |-",giveplayername, AccountInfo[targetid][Warns]);
					SendClientMessageToAdmins(ADMIN_RED,string,1);
					if (AccountInfo[targetid][Warns] == 1) strmid(AccountInfo[targetid][WarnReason1], reason, 0, strlen(reason), 128);
					else if (AccountInfo[targetid][Warns] == 2) strmid(AccountInfo[targetid][WarnReason2], reason, 0, strlen(reason), 128);
					else if (AccountInfo[targetid][Warns] == 3) strmid(AccountInfo[targetid][WarnReason3], reason, 0, strlen(reason), 128);
					SendClientMessage(targetid, RED, "3 �ξ�����Ч = Auto-Ban!");
					if(AccountInfo[targetid][Warns] >= 3)
					{
					    new ip[128];
						format(string, sizeof(string), "-| GM %s ��ɱ %s. [ԭ��: 3 �ξ���...] |-", sendername,giveplayername);
						BanLog(string);
						SendClientMessageToAll(ADMIN_RED, string);
						for(new i = 0; i < 3; i++)
						{
						    if (i == 0) format(string, sizeof (string), "-| ԭ��: #%d: %s |-", i+1, AccountInfo[targetid][WarnReason1]);
						    else if (i == 1) format(string, sizeof (string), "-| ԭ��: #%d: %s |-", i+1, AccountInfo[targetid][WarnReason2]);
						    else if (i == 2) format(string, sizeof (string), "-| ԭ��: #%d: %s |-", i+1, AccountInfo[targetid][WarnReason3]);
						    SendClientMessageToAll(ADMIN_RED, string);
						}
						GetPlayerIp(targetid,ip,128);
						format(sstring, sizeof(sstring), "-| IP: %s |-", ip);
						SendClientMessageToAdmins(ADMIN_RED, sstring,1);
						AccountInfo[targetid][AdminLevel]= 0;
						AccountInfo[targetid][Warns] = 0;
						format(AccountInfo[targetid][WarnReason1], 128, "NONE");
    					format(AccountInfo[targetid][WarnReason2], 128, "NONE");
    					format(AccountInfo[targetid][WarnReason3], 128, "NONE");
						Ban(giveplayerid);
						return 1;
					}
				}
				else
				{
					format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, RED, string);
				}
			}
			else
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/pstats", true) == 0 || strcmp(cmd, "/zhuangtai", true) == 0) // Views the player's stats
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 1)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /pstats [playername/id]");
			new targetid = ReturnUser(tmp);
			if (targetid != INVALID_PLAYER_ID)
			{
				new Float:health,Float:armor;
				GetPlayerHealth(targetid,health);
				GetPlayerArmour(targetid,armor);
	    		GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
				format(string, sizeof(string), "%s: ����: '%.2f' - ��Ǯ: '$%d' - �������: '%d' - ����: '%.2f'",giveplayername, health,GetPlayerMoney(targetid),AccountInfo[targetid][Warns],armor);
				SendClientMessage(playerid,PURPLE,string);
				if(AccountInfo[giveplayerid][Logged] == 1) SendClientMessage(playerid, PURPLE, "�Ƿ��¼: Yes");
				else if(AccountInfo[giveplayerid][Logged] == 0) SendClientMessage(playerid, PURPLE, "Logged In: No");
				SendClientMessage(playerid,YELLOW,"��ʾ:ʹ�� /pweapons [playername/id] �鿴�������");
			}
			else SendClientMessage(playerid, RED, "Player is not active.");
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if(strcmp(cmd, "/fuck", true) == 0 || strcmp(cmd, "/cao", true) == 0) // Sends a player in the air and explodes
	{
		new Float:pX,Float:pY,Float:pZ;
		new Float:X,Float:Y,Float:Z;
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /fuck [playerid]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will fuck up a player.");
				return 1;
			}

			new targetid = ReturnUser(tmp);
			if(targetid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
			    GetPlayerPos(targetid,pX,pY,pZ);
			    CreateExplosion(X,Y,Z+50,2,5.0);
			    SetPlayerPos(targetid,pX,pY,pZ+50);
				format(string, sizeof(string), "-| GM %s �� %s(%d) ������,���������! |-",sendername, giveplayername,giveplayerid);
				SendClientMessageToAdmins(ADMIN_RED,string,1);
				SendClientMessage(targetid, RED, "�q�ɨr�����ᣩ�q�ɨr");
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/giveweapon", true) == 0 || strcmp(cmd, "/geiwuqi", true) == 0) // Gives a weapon to a player
	{
	    if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /giveweapon [playername/id] [weaponid] [ammo]");
				return 1;
			}
			new gun;
			new ammo;
			new targetid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			gun = strval(tmp);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /giveweapon [playername/id] [weaponid] [ammo]");
			tmp = strtok(cmdtext, idx);
			ammo = strval(tmp);
   			if(targetid != INVALID_PLAYER_ID)
		 	{
		 	    new weap[50];
   				GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
				GivePlayerWeapon(targetid, gun, ammo);
				GetWeaponName(gun, weap, sizeof weap);
				format(string, sizeof(string), "-| GM %s �ó�(%s) �͸� %s |-",sendername, weap, giveplayername);
				SendClientMessageToAdmins(ADMIN_RED,string,1);
			}
			else if(targetid == INVALID_PLAYER_ID)
		    {
				format(string, sizeof(string), "%d is not an active player.", targetid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	if(strcmp(cmd, "/crash", true) == 0 || strcmp(cmd, "/ffcz", true) == 0) // Crashes a player's client
	{
	 	if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /crash [playername/id]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will crash a player.");
				return 1;
			}
			new Float:X,Float:Y,Float:Z;
			new targetid = ReturnUser(tmp);
		    if(IsPlayerConnected(targetid))
		    {
      			GetPlayerPos(giveplayerid,X,Y,Z);
	    		new objectcrash = CreatePlayerObject(targetid,666666,X,Y,Z,0,0,0); // double-devil has spoken
				SendClientMessage(playerid,GREEN, "Player successfuly crashed.");
				DestroyPlayerObject(targetid, objectcrash);
			}
			else if (!IsPlayerConnected(giveplayerid))
			{
				format(string, sizeof(string), "%d is not an active player.", targetid);
				SendClientMessage(playerid, RED, string);
			}
	   	}
		else SendClientMessage(playerid, RED, "You're not a lead admin.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/setwarn", true) == 0) // Sets the player's warnings
	{
		if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /setwarn [playername/id] [warning]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will set a certain player's warning.");
				return 1;
			}
	  		new targetid = ReturnUser(tmp);
			if(targetid != INVALID_PLAYER_ID)
			{
			    GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				tmp = strtok(cmdtext, idx);
				new warnings = strval(tmp);
				if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /setwarn [playername/id] [warning]");
				AccountInfo[targetid][Warns] = warnings;
				format(string, sizeof(string), "Admin %s changed your warnings to %d", sendername, warnings);
				SendClientMessage(targetid, GREEN, string);
				SendClientMessage(targetid, RED, "3 Warnings = Auto-Ban! Ask an admin to check how many warnings you have");
				format(string, sizeof(string), "-| GM %s changed %s's warnings. [Warnings: %d ] |-",sendername,giveplayername, AccountInfo[giveplayerid][Warns]);
				SendClientMessageToAdmins(ADMIN_RED,string,1);
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/an", true) == 0 || strcmp(cmd, "/announce", true) == 0 || strcmp(cmd, "/tongzhi", true) == 0 || strcmp(cmd, "/gonggao", true) == 0) // Broadcasts an 'announcement' message.
	{
	    if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
    	{
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new result[128];
			result = bigstrtok(cmdtext, idx);
			if(!strlen(result))
			{
				SendClientMessage(playerid, ORANGE, "����: /(an)nounce [message]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will broadcast an announcement.");
				return 1;
			}
			format(string, sizeof(string), "-| %s |-", result);
			SendClientMessageToAll(AQUAGREEN, string);
			printf("Announcement by %s: %s", sendername, string);
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/superpunch", true) == 0) // Triggers an explosion when you use the punch key
	{
	    if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
	    {
	        tmp = strtok(cmdtext,idx);
	        if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /superpunch [on/off]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will give you the power of Super Punch. When pressing 'PUNCH' button, you will explode but will live.");
			}
	        else if(strcmp(tmp,"on",true) == 0)
	        {
				SuperPunch[playerid] = 1;
				SendClientMessage(playerid,GREEN,"You are now blessed with SUPER PUNCH! Go knock someone out.");
			}
			else if(strcmp(tmp,"off",true) == 0)
			{
				SuperPunch[playerid] = 0;
				SendClientMessage(playerid,GREEN,"Your super punch is now disabled.");
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if (strcmp(cmd, "/superpunchp", true) == 0) // Gives the Super Punch ability to a player
	{
		new tmp2[128];
	    if (AccountInfo[playerid][AdminLevel] > 5 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext,idx);
		    if(!strlen(tmp))
			{
				SendClientMessage(playerid,ORANGE,"����: /superpunchp [playername/id] [on/off]");
				SendClientMessage(playerid,ORANGE,"FUNCTION: Will give the player the power of SuperPunch.");
			}
			new targetid = ReturnUser(tmp);
			if(targetid != INVALID_PLAYER_ID)
			{
			    tmp2 = strtok(cmdtext,idx);
			    if(strcmp(tmp2,"on",true) == 0)
			    {
			   	 	GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
					SuperPunch[targetid] = 1;
					format(string, sizeof(string), "Admin %s blessed you with the power of Super Punch !", sendername);
					SendClientMessage(targetid,GREEN,string);
					format(string, sizeof(string), "-| GM %s blessed %s with the power of Super Punch |-", sendername,giveplayername);
					SendClientMessageToAdmins(ADMIN_RED,string,1);
				}
				else if(strcmp(tmp2,"off",true) == 0)
				{
				    format(string, sizeof(string), "Admin %s removed your Super Punch power.", sendername);
					SendClientMessage(targetid,RED,string);
					SuperPunch[targetid] = 0;
				}
			}
			else if(giveplayerid == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%d is not an active player.", giveplayerid);
				SendClientMessage(playerid,RED,string);
			}
		}
		else SendClientMessage(playerid,RED,"You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/viewcmds", true) == 0) // Views unknown commands and commands mentioned in 'ViewCommands' variable entered by players
	{
	    if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
	    {
	        tmp = strtok(cmdtext,idx);
	        if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /viewcmds [on/off]");
				SendClientMessage(playerid, ORANGE, "FUNCTION: Will see the players typing some commands and wrong commands.");
			}
	        else if(strcmp(tmp,"on",true) == 0)
	        {
				ViewCmds[playerid] = 1;
				SendClientMessage(playerid,GREEN,"You can know view players typing some commands and wrong commands.");
			}
			else if(strcmp(tmp,"off",true) == 0)
			{
				ViewCmds[playerid] = 0;
				SendClientMessage(playerid,GREEN,"You can no longer view players typing some commands and wrong commands.");
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/jail", true) == 0 || strcmp(cmd, "/jianyu", true) == 0) // Jails a player
	{
		if (AccountInfo[playerid][AdminLevel] >= 1)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /jail [playername/id] [ԭ��]");
				return 1;
			}
			new targetid = ReturnUser(tmp);
			if(IsPlayerConnected(targetid))
			{
				if(targetid != INVALID_PLAYER_ID)
				{
					if(AccountInfo[giveplayerid][Jail] == 0)
					{
						GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new reason[128];
						reason = bigstrtok(cmdtext, idx);
						if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /jail [playername/id] [ԭ��]");
						format(string, sizeof(string), "%s �����ͽ�����.[ԭ��: %s]", sendername, reason);
						SendClientMessage(targetid, ADMIN_RED, string);
						format(string, sizeof(string), "-| GM %s �� %s(%d) �ͽ����� [ԭ��: %s] |-",sendername,giveplayername,giveplayerid, reason);
						SendClientMessageToAll(ADMIN_RED,string);
						AccountInfo[targetid][Jail] = 1;
						OnPlayerJailed(targetid);
						return 1;
					}
					else SendClientMessage(playerid, RED, "Player is already jailed!");
				}
				else
				{
					format(string, sizeof(string), "%d is not an active player.", targetid);
					SendClientMessage(playerid, RED, string);
				}
			}
			else
			{
				format(string, sizeof(string), "%d is not an active player.", targetid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/unjail", true) == 0 || strcmp(cmd, "/chuyu", true) == 0 || strcmp(cmd, "/baoshi", true) == 0 || strcmp(cmd, "/shifang", true) == 0) // Unjails a player
	{
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, ORANGE, "����: /unjail [playername/id]");
				return 1;
			}

			new targetid = ReturnUser(tmp);
			if(targetid != INVALID_PLAYER_ID)
			{
				if(AccountInfo[giveplayerid][Jail] == 1)
				{
					GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "-| GM %s �� %s(%d) �Ӽ����ͷ� |-",sendername, giveplayername,giveplayerid);
					SendClientMessageToAll(ADMIN_RED,string);
					AccountInfo[targetid][Jail] = 0;
					OnPlayerUnjailed(targetid);
				}
				else SendClientMessage(playerid, RED, "Player is not jailed!");
			}
			else
			{
				format(string, sizeof(string), "%d is not an active player.", targetid);
				SendClientMessage(playerid, RED, string);
			}
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/gotoveh", true) == 0) // Teleports to a vehicle's position
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, ORANGE, "����: /gotoveh [vehicleid]");
			return 1;
		}
		new car = strval(tmp);
		if (AccountInfo[playerid][AdminLevel] >= 4)
		{
		    new Float:vx,Float:vy,Float:vz;
		    GetVehiclePos(car,vx,vy,vz);
		    if (GetPlayerState(playerid) == 2)
		    	SetVehiclePos(GetPlayerVehicleID(playerid),vx,vy+2,vz);
		    else
		        SetPlayerPos(playerid,vx,vy,vz+1);
		    SetPlayerInterior(playerid,0);
		    format(string,256,"You have teleported to vehicle id %d(%s)",car, VehNames[GetVehicleModel(car)-400]);
		    SendClientMessage(playerid,GREEN,string);
		}
		else SendClientMessage(playerid,RED,"You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	    return 1;
	}
	if(!strcmp(cmdtext, "/aclearchat", true)) // Clears the chatbox for everyone
	{
	    if(AccountInfo[playerid][AdminLevel] >= 4 || IsPlayerAdmin(playerid))
	    {
	        for(new chat = 0; chat <= 50; chat++) SendClientMessageToAll(GREEN, " ");
			GetPlayerName(playerid, sendername, 20);
			format(string, 256, "-| GM %s cleared the chat |-", sendername);
			SendClientMessageToAll(ADMIN_RED, string);
			return 1;
		}
		else SendClientMessage(playerid, RED, "You are not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	if(strcmp(cmd, "/hide", true) == 0 || strcmp(cmd, "/yinsheng", true) == 0 || strcmp(cmd, "/yinxing", true) == 0) // Hides you from the admin list
	{
		if (AccountInfo[playerid][AdminLevel] >= 4)
		{
		   Hide[playerid] = 1;
		   SendClientMessage(playerid,GREEN,"|- You're now hidden from the admin list -|");
		}
		return 1;
	}
	if(strcmp(cmd, "/unhide", true) == 0 || strcmp(cmd, "/xianshen", true) == 0 || strcmp(cmd, "/xianxing", true) == 0)
	{
		if (AccountInfo[playerid][AdminLevel] >= 4) // Unhides you from the admin list
		{
		    if (Hide[playerid] != 1) return SendClientMessage(playerid,RED,"You're not hidden in the admin list!");
		   	Hide[playerid] = 0;
		   	SendClientMessage(playerid,GREEN,"|- You're now visible in the admin list -|");
		}
		return 1;
	}
	
	if(strcmp(cmd, "/virtual", true) == 0 || strcmp(cmd, "/kongjian", true) == 0 || strcmp(cmd, "/changjing", true) == 0 || strcmp(cmd, "/yiciyuan", true) == 0 || strcmp(cmd, "/xq", true) == 0) // Sets the player's virtual world
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 3)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /virtual [playerid/name] [virtual world (0-255)]");
			new targetid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			new v = strval(tmp);
			if (targetid != INVALID_PLAYER_ID)
			{
				if (!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /virtual [playerid/name] [virtual world (0-255)]");
				SetPlayerVirtualWorld(targetid,v);
				GetPlayerName(playerid, sendername, sizeof(sendername));
	    		GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
	    		format(string,sizeof(string),"|- GM %s �� %s(%d) �� %d ������ -|",sendername,giveplayername,giveplayerid,v);
	    		SendClientMessageToAdmins(ADMIN_RED,string,1);
			}
			else SendClientMessage(playerid, RED, "Player is not active.");
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if(strcmp(cmd,"/acount", true) == 0) // Starts a count down
	{
	    tmp = strtok(cmdtext, idx);
	    new count = strval(tmp);
	    if (!strlen(tmp)) count = 5;
		if (AccountInfo[playerid][AdminLevel] < 1) return SendClientMessage(playerid,RED,"You're not an admin.�q�ɨr�����ᣩ�q�ɨr");
		if (Count > 0) return SendClientMessage(playerid, RED, "Countdown is already in progress.");
		GetPlayerName(playerid, sendername, sizeof(sendername));
	   	format(string,sizeof(string),"|- GM %s started a countdown from %d -|", sendername, count);
		SendClientMessageToAll(LIGHTGREEN, string);
		Count = count;
		CountDown();
		return 1;
	}
	
	if(strcmp(cmd, "/view", true) == 0 || strcmp(cmd, "/chakan", true) == 0) // Spectates a player
	{
		if (AccountInfo[playerid][AdminLevel] < 2) return SendClientMessage(playerid,RED,"You're not an admin!�q�ɨr�����ᣩ�q�ɨr");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
	 		SendClientMessage(playerid, ORANGE, "|__________________________________|");
			SendClientMessage(playerid, ORANGE, "USAGE: /view [playerid]");
			SendClientMessage(playerid, ORANGE, "FUNCTION: Will spectate a player.");
			SendClientMessage(playerid, ORANGE, "HELP: /view off to stop spectating");
			SendClientMessage(playerid, ORANGE, "|__________________________________|");
			return 1;
		}
		new targetid = ReturnUser(tmp);
		if (giveplayerid != INVALID_PLAYER_ID)
		{
		    if (AccountInfo[playerid][AdminLevel] < 1) return SendClientMessage(playerid,RED,"You're not an admin!�q�ɨr�����ᣩ�q�ɨr");
		    TogglePlayerSpectating(playerid, 1);
		    SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(targetid));
		    SetPlayerInterior(playerid,GetPlayerInterior(targetid));
			if (IsPlayerInAnyVehicle(targetid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
			else PlayerSpectatePlayer(playerid, targetid);
			SendClientMessage(playerid, ORANGE, "��ʾ: '/view off' �رռ�����");
		}
		else if(strcmp(tmp, "off", true) == 0)
		{
		    TogglePlayerSpectating(playerid, 0);
	     	SetPlayerVirtualWorld(playerid,0);
		}
		else
		{
	        format(string, sizeof(string), "%d is not an active player.", giveplayerid);
			SendClientMessage(playerid, RED, string);
		}
		return 1;
	}
	
	if(strcmp(cmd, "/blockpm", true) == 0) // Blocks PMs
	{
		if (AccountInfo[playerid][AdminLevel] >= 5)
		{
			if (PMBlock[playerid] == true)
			{
			    PMBlock[playerid] = false;
			    SendClientMessage(playerid, GREEN, "|- Private messages BLOCKED -|");
			    return 1;
			}
			if (PMBlock[playerid] == false)
			{
			    PMBlock[playerid] = true;
			    SendClientMessage(playerid, GREEN, "|- Private messages UNBLOCKED -|");
			    return 1;
			}
		}
		else return SendClientMessage(playerid, RED, "You're not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
	}
	
	if(!strcmp(cmd, "/seifocalypse", true)) // Launches explosion(s) in front of the player(it follow the previous explosion so it goes straight) as many times has he wants
	{
	    if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
	    {
		    tmp = strtok(cmdtext, idx);
		    if (!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /seifocalypse [explosions]");
		    new Float:X,Float:Y,Float:Z,Float:A;
		    GetPlayerPos(playerid, X,Y,Z);
		    GetPlayerFacingAngle(playerid, A);
			Nuke[playerid] = 1;
			SetTimerEx("NukeBlast", 200, 0, "ddffff",playerid, strval(tmp), X, Y, Z, A);
		}
		else return SendClientMessage(playerid, RED, "You're not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
	    return 1;
	}
	
	if(!strcmp(cmd, "/missile", true) || !strcmp(cmd, "/daodan", true)) // Spawns a missile 50 Z higher than player's and drops it to the ground, toggling a huge explosion
	{
	    if (AccountInfo[playerid][AdminLevel] >= 4 || IsPlayerAdmin(playerid))
	    {
			if (IsValidObject(Missile[playerid])) return SendClientMessage(playerid, RED, "You already dropped a missile that's currently in progress of exploding");
		    new Float:X,Float:Y,Float:Z;
		    GetPlayerPos(playerid, X,Y,Z);
			Missile[playerid] = CreateObject(3786, X, Y, Z+50, 357.6293, 272.3375, 6.8755);
			MoveObject(Missile[playerid], X, Y, Z, 20.0);
		}
		else return SendClientMessage(playerid, RED, "You're not a lead admin!�q�ɨr�����ᣩ�q�ɨr");
	    return 1;
	}
	
	if (!strcmp(cmd, "/push", true) || !strcmp(cmd, "/houtui", true)) // Pushes a player back. Player gets pushed back in motions
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 2)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /push [playername/id]");
			new targetid = ReturnUser(tmp);
			if (targetid != INVALID_PLAYER_ID)
			{
			    PushPlayer(targetid, 20, true);
				GetPlayerName(playerid, sendername, sizeof(sendername));
	    		GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
	    		format(string,sizeof(string),"|- GM %s �� %s ˵:����վ -|", sendername, giveplayername);
	    		SendClientMessageToAdmins(ADMIN_RED, string, 1);
			}
			else SendClientMessage(playerid, RED, "Player is not active.");
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if (!strcmp(cmd, "/setgravity", true)) // Changes gravity
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 5)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /pussetgravity [gravity float]");
			new Float:gravity = floatstr(tmp);
		    SetGravity(gravity);
			GetPlayerName(playerid, sendername, sizeof(sendername));
    		format(string,sizeof(string),"|- GM %s has changed gravity [ Gravity: %.4f ] -|", sendername, gravity);
    		SendClientMessageToAll(ADMIN_RED, string);
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if (!strcmp(cmd, "/settime", true)) // Changes time
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 4)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /settime [time(0-23)]");
			new time = strval(tmp);
			if (time < 0 || time > 23) return SendClientMessage(playerid, RED, "Time can only be from 0 to 23!");
		    SetWorldTime(time);
			GetPlayerName(playerid, sendername, sizeof(sendername));
    		format(string,sizeof(string),"|- GM %s has changed time [ Hour: %d ] -|", sendername, time);
    		SendClientMessageToAll(ADMIN_RED, string);
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if (!strcmp(cmd, "/setweather", true) || !strcmp(cmd, "/tianqi", true)) // Changes time
	{
		if(IsPlayerAdmin(playerid) || AccountInfo[playerid][AdminLevel] >= 4)
		{
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /setweather [weather id]");
			new weather = strval(tmp);
		    SetWeather(weather);
			GetPlayerName(playerid, sendername, sizeof(sendername));
    		format(string,sizeof(string),"|- GM %s �޸�����Ϊ: %d -|", sendername, weather);
    		SendClientMessageToAdmins(ADMIN_RED, string, 1);
		}
		else SendClientMessage(playerid, RED, "You're not an admin with the required level.�q�ɨr�����ᣩ�q�ɨr");
	  	return 1;
	}
	
	if(strcmp(cmd, "/report", true) == 0 || strcmp(cmd, "/jb", true) == 0 || strcmp(cmd, "/jubao", true) == 0 || strcmp(cmd, "/jvbao", true) == 0) ///report Available for everyone: reports a player to the admins
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, ORANGE, "����: /report [playername/id] [ԭ��]");
			SendClientMessage(playerid, ORANGE, "[˵��]: ��Ϣ�ᷢ�͸���������GM");
			return 1;
	 	}
		new targetid = ReturnUser(tmp);
		if(targetid != INVALID_PLAYER_ID)
		{
		    GetPlayerName(targetid, giveplayername, sizeof(giveplayername));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new reason[128];
			reason = bigstrtok(cmdtext, idx);
			if(!strlen(reason)) return SendClientMessage(playerid, ORANGE, "����: /report [playerid] [ԭ��]");
			format(string, sizeof(string), "|- %s(%d) �ٱ� %s(%d) [ ԭ��: %s ]", sendername,playerid,giveplayername,giveplayerid,reason);
			SendClientMessageToAdmins(ADMIN_RED, string,1);
			format(string, sizeof(string), "[GM] лл��Э������������. �������ڵ��� '%s' ,�뾲�����", giveplayername);
			SendClientMessage(playerid, GREEN, string);
		}

		else if(giveplayerid == INVALID_PLAYER_ID)
		{
			format(string, sizeof(string), "%d ��Ҳ�����.", giveplayerid);
			SendClientMessage(playerid, RED, string);
		}
		return 1;
	}
	
	if(strcmp(cmd, "/ah", true) == 0 || strcmp(cmd, "/ahelp", true) == 0 || strcmp(cmd, "/acommands", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, YELLOWb, "��������: /aregister /login /changepassword /logout");
		    SendClientMessage(playerid, YELLOWb, "Ȩ�� 1+: /ah1 [ʵϰGM/VIP]");
		    SendClientMessage(playerid, YELLOWb, "Ȩ�� 2+: /ah2 [��ҹ���/�������]");
		    SendClientMessage(playerid, YELLOWb, "Ȩ�� 3+: /ah3 [������Թ���]");
		    SendClientMessage(playerid, YELLOWb, "Ȩ�� 4+: /ah4 [���������Թ���]");
		    SendClientMessage(playerid, YELLOWb, "Ȩ��(5): /ah5 [����Ա/����֧��]");
		    SendClientMessage(playerid, YELLOWb, "GM����Ƶ��: //   ʵ��: //hello");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if(strcmp(cmd, "/ah1", true) == 0 || strcmp(cmd, "/ahelp1", true) == 0 || strcmp(cmd, "/acommands1", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, YELLOWb, "���״̬: /pstats /zhuangtai ӵ������: /pweapons /shawuqi û������: /disarm ");
		    SendClientMessage(playerid, YELLOWb, "��: /slap /da /qianbian /zhaochou /moshou ����: /(un)jail /jianyu /chuyu /baoshi");
		    SendClientMessage(playerid, YELLOWb, "���͵�������: /goto ����ҵ����: /get /gethere");
		    SendClientMessage(playerid, YELLOWb, "GM����Ƶ��: //   ʵ��: //hello");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/ah2", true) == 0 || strcmp(cmd, "/ahelp2", true) == 0 || strcmp(cmd, "/acommands2", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 2 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, YELLOWb, "IP��ַ: /ip ������: /view");
		    SendClientMessage(playerid, YELLOWb, "����: /(un)freeze /hbz /jiedong ����: /(un)mute /jinyan /jiejin");
		    SendClientMessage(playerid, YELLOWb, "3�ξ���ban: /warn /jinggao �߳�: /kick /gun /zaijian ��������: /akill ˤ��: /fuck /cao");
		    SendClientMessage(playerid, YELLOWb, "����: /push /houtui");
		    SendClientMessage(playerid, YELLOWb, "����: /say /xuanbu GM����Ƶ��: //   ʵ��: //hello");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/ah3", true) == 0 || strcmp(cmd, "/ahelp3", true) == 0 || strcmp(cmd, "/acommands3", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 3 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, YELLOWb, "�ݺݵĴ�: /bslap /henchou /kuangban ��������: /akill /qusi /shasi");
		    SendClientMessage(playerid, YELLOWb, "������: /nuke /explode /qgb ��ɱ: /ban /buzaijian /xiaoshi");
		    SendClientMessage(playerid, YELLOWb, "���Ԫ�ռ�: /virtual /yiciyuan /kongjian /changjing �޵�: /drugs /godmode /wudi");
		    SendClientMessage(playerid, YELLOWb, "����HP: /sethp ����: /atele /teleport /achuansong �����ǳ�: /setname ���û���: /setscore");
		    SendClientMessage(playerid, YELLOWb, "������Ǯ: /givecash /jiangli ��������: /giveweapon /geiwuqi");
		    SendClientMessage(playerid, YELLOWb, "����: /an /announce /gonggao GM����Ƶ��: //   ʵ��: //hello");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/ah4", true) == 0 || strcmp(cmd, "/ahelp4", true) == 0 || strcmp(cmd, "/acommands4", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 4 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, YELLOWb, "�ָ��Ƕ�: /angle");
		    SendClientMessage(playerid, YELLOWb, "����: /missile /daodan");
		    SendClientMessage(playerid, YELLOWb, "ˢ��: /veh /zhaohuan /shuache ���͵���ͨ����:/gotoveh");
		    SendClientMessage(playerid, YELLOWb, "����ʱ��: /settime ��������: /setweather");
		    SendClientMessage(playerid, YELLOWb, "�رս�����Ϣ: /bc /broadcast �������: /aclearchat");
		    SendClientMessage(playerid, YELLOWb, "����:/hide /yinsheng /yinxing ȡ������: /unhide /xianshen /xianxing");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}
	
	if(strcmp(cmd, "/ah5", true) == 0 || strcmp(cmd, "/ahelp5", true) == 0 || strcmp(cmd, "/acommands5", true) == 0) // List of admin commands
	{
		if (AccountInfo[playerid][AdminLevel] >= 5 || IsPlayerAdmin(playerid))
		{
		    SendClientMessage(playerid, YELLOW, "             |- GM�����嵥 (����ʹ�ò������õ�����) -|");
		    SendClientMessage(playerid, ORANGE, "Ȩ�� 1+: /(un)freeze /(un)mute /say /slap /warn /kick /akill /goto /get /ip /pweapons /view /changepassword");
		    SendClientMessage(playerid, ORANGE, "Ȩ�� 2+: /setscore /givecash /pstats /angle /setname /logout /demolish /virtual");
		    SendClientMessage(playerid, ORANGE, "Ȩ�� 3+: /nuke /ban /viewcmds /disarm /giveweapon /gotoveh /(un)jail /sethp /push /settime");
		    SendClientMessage(playerid, ORANGE, "Ȩ�� 4+: /fuck /bc /setwarn /announce /aclearchat /bslap /(un)hide /rangeban /teleport /setgravity /setweather");
		    SendClientMessage(playerid, ORANGE, "Ȩ��(5): /gmx /makeadmin /kickall /crash /blockpm /seifocalypse /missile");
		    SendClientMessage(playerid, YELLOWb, "/rangeban /setwarn /superpunch /superpunchp /viewcmds /setgravity");
		    SendClientMessage(playerid, YELLOWb, "�Ƿ�����: /crash /ffcz");
		    SendClientMessage(playerid, ORANGE, "GM����Ƶ��: //   ʵ��: //hello");
		}
		else SendClientMessage(playerid, RED, "You are not an admin!�q�ɨr�����ᣩ�q�ɨr");
		return 1;
	}

	if (strcmp(cmd, "/admins", true) == 0 || strcmp(cmd, "/gms", true) == 0 || strcmp(cmd, "/guanliyuan", true) == 0) // Admin list if they're online
	{
	    new count = 0;
		SendClientMessage(playerid, GREEN, "                            [��ǰ����GM]");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if (IsPlayerConnected(i))
	  		{
  				if(AccountInfo[i][AdminLevel] >= 1 && AccountInfo[i][AdminLevel] <= 5 && Hide[i] == 0)
	    		{
					GetPlayerName(i, sendername, sizeof(sendername));
					format(string, 128, " Ȩ��: %d / [%i]%s", AccountInfo[i][AdminLevel],i,sendername);
					SendClientMessage(playerid, LIGHTGREEN, string);
					count++;
				}
			}
		}
		if (count == 0) SendClientMessage(playerid,RED,"���ֲ���,��ǰʱ���û��GM����.��Ϊ�������Ĺ����һ������?����ϵsa-mp@qq.com");
		SendClientMessage(playerid, GREEN, "[____________________________________]");
		return 1;
	}

	if (strcmp(cmd, "/aregister", true) == 0 || strcmp(cmd, "/zhuce", true) == 0) // Registers an account
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(AccountInfo[playerid][Logged] == 1)
			{
				SendClientMessage(playerid, RED, "    [����]�Ѿ���¼��");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			format(string, sizeof(string), "/sAccounts/%s.seifadmin", sendername);
			new File: hFile = fopen(string, io_read);
			if (hFile)
			{
				SendClientMessage(playerid, RED, "That name is already taken. Please reconnect using a different username.");
				fclose(hFile);
				return 1;
			}
	        new tmppass[128];
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /register [password]");
			strmid(tmppass, tmp, 0, strlen(cmdtext), 255);
			OnPlayerRegister(playerid, MD5_Hash(tmppass));
		}
		return 1;
	}
	
	if (strcmp(cmd, "/login", true) == 0 || strcmp(cmd, "/denglu", true) == 0) // Logins
	{
 		new tmppass[128];
		if(AccountInfo[playerid][Logged] == 1) return SendClientMessage(playerid, RED, "    [����]�Ѿ���¼��");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /login [password]");
		new plname[MAX_PLAYER_NAME];
   		GetPlayerName(playerid, plname, sizeof(plname));
		format(string, sizeof(string), "/sAccounts/%s.seifadmin", plname);
		//if(!fexist(string)) return SendClientMessage(playerid, RED, "That account isn't registered! Please register: /register [password]");
		if(!fexist(string)) return SendClientMessage(playerid, RED, "����һ�����ɷ���������Ҫע��/��¼,Ҳ��������Ǯ/����������");
		strmid(tmppass, tmp, 0, strlen(cmdtext), 255);
		OnPlayerLogin(playerid, MD5_Hash(tmppass));
		return 1;
	}
	
	if (!strcmp(cmd, "/changepassword", true)) // Changes your password
	{
		if (!AccountInfo[playerid][Logged]) return SendClientMessage(playerid, RED, "You're not logged in.");
		if (AccountInfo[playerid][AdminLevel] >= 1)
		{
			new oldpass[128];
			oldpass = strtok(cmdtext, idx);
			if(!strlen(oldpass)) return SendClientMessage(playerid, ORANGE, "����: /changepassword [CURRENT PASSWORD] [new password]");
			if (strcmp(MD5_Hash(oldpass), AccountInfo[playerid][Password], true)) return SendClientMessage(playerid, RED, "Invalid password.");
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendClientMessage(playerid, ORANGE, "����: /changepassword [current password] [NEW PASSWORD]");
			format(oldpass, 128, "|- You've changed your password to '%s' -|", tmp);
	       	SendClientMessage(playerid, LIGHTGREEN, oldpass);
	       	strmid(AccountInfo[playerid][Password], MD5_Hash(tmp), 0, strlen(MD5_Hash(tmp)), 128);
       	}
       	return 1;
   }
   
 /*���������������������������� [WRONG COMMAND] ���������������������������*/
	else
	{
	    for(new i = 0; i < GetMaxPlayers(); i++)
		{
		    if (IsPlayerConnected(i))
		    {
		        if (AccountInfo[i][AdminLevel] > 0 && ViewCmds[i] == 1)
		        {
          			GetPlayerName(playerid, sendername, sizeof sendername);
		            format(tmp, 128, "    [����]%s(%d): %s", sendername, playerid, cmdtext);
		            SendClientMessage(i, PURPLE, tmp);
		        }
		    }
		}
		return 0;
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (SuperPunch[playerid] == 1)
	{
	    if (GetPlayerState(playerid) != 2)
	    {
	    	if (newkeys & KEY_FIRE && Drugs[playerid] == 0)
	    	{
	    	    new Float:X,Float:Y,Float:Z,Float:Health;
 	        	GetPlayerHealth(playerid,Health);
	    	    if (GetPlayerWeapon(playerid) == 0)
	    	    {
	    	        GetPlayerPos(playerid,X,Y,Z);
	    	        CreateExplosion(X,Y,Z,7,7.0);
	    	        SetPlayerHealth(playerid,Health);
	     	   }
	  	  	}
	  	  	else if (newkeys & KEY_FIRE && Drugs[playerid] == 1)
	    	{
	    	    new Float:X,Float:Y,Float:Z;
	    	    if (GetPlayerWeapon(playerid) == 0)
	    	    {
	    	        SetPlayerHealth(playerid,999999999);
	    	        GetPlayerPos(playerid,X,Y,Z);
	    	        CreateExplosion(X,Y,Z,7,7.0);
	    	        SetPlayerHealth(playerid,999999999);
	     	   }
	  	  	}
	    }
	}
}

OnPlayerJailed(playerid)
{
	SetPlayerInterior(playerid, 6);
	SetPlayerPos(playerid, 264.3700,77.5700,1001.0391);
	SetPlayerFacingAngle(playerid, 272.6900);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

OnPlayerUnjailed(playerid)
{
	SetPlayerInterior(playerid, 6);
	SetPlayerPos(playerid,	266.9272,78.6098,1001.0391);
	SetPlayerFacingAngle(playerid, 266.9169);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

public CountDown()
{
	if (Count > 0)
	{
	    new str[5];
	    format(str, sizeof str, "~w~%d", Count);
	    GameTextForAll(str,2500,3);
		Count--;
		SetTimer("CountDown",1000,0);
	}
	else
	{
		GameTextForAll("~g~~h~Go ~w~!!",2500,3);
		Count = 999;
	}
	return 1;
}

public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	if (PMBlock[recieverid] == true) return SendClientMessage(playerid, RED, "That admin has blocked private messages"), 0;
	return 1;
}

forward NukeBlast(playerid, times, Float:X,Float:Y,Float:Z,Float:A);
public  NukeBlast(playerid, times, Float:X,Float:Y,Float:Z,Float:A)
{
	if (Nuke[playerid] == times+1) return 1;
	//printf("Nukeblast %d",Nuke[playerid]);
	new Float:x,Float:y;
    x = X + ((10*Nuke[playerid]) * floatsin(-A+5, degrees));
	y = Y + ((10*Nuke[playerid]) * floatcos(-A+5, degrees));
	CreateExplosion(x, y, Z, 3, 3.0);
	Nuke[playerid]++;
	SetTimerEx("NukeBlast", 200, 0, "ddffff",playerid, times, X, Y, Z, A);
	return 1;
}

public OnObjectMoved(objectid)
{
	for(new i; i < MAX_PLAYERS; i++) if (objectid == Missile[i])
	{
	    new Float:X,Float:Y,Float:Z,Float:x,Float:y,Float:z;
	    GetObjectPos(objectid, X, Y, Z);
	    GetObjectPos(objectid, x, y, z);
	    DestroyObject(objectid);
	    CreateExplosion(X, Y, Z, 7, 5);
     	//front
	    X += (5.0 * floatsin(0, degrees));
		Y += (5.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (3.0 * floatsin(0+45, degrees));
		Y += (3.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (3.0 * floatsin(0-45, degrees));
		Y += (3.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//right-left
		X += (5.0 * floatcos(0, degrees));
		Y += (5.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//back
		X -= (5.0 * floatcos(0, degrees));
		Y -= (5.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		X -= (5.0 * floatsin(0, degrees));
		Y -= (5.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (3.0 * floatsin(0+45, degrees));
		Y -= (3.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (3.0 * floatsin(0-45, degrees));
		Y -= (3.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		SetTimerEx("MissileExplosion", 700, 0, "fffd", x, y, z, 3);
	    break;
	}
}

forward MissileExplosion(Float:X, Float:Y, Float:Z, times);
public  MissileExplosion(Float:X, Float:Y, Float:Z, times)
{
	new Float:x = X;
	new Float:y = Y;
	new Float:z = Z;
	if (times == 3)
	{
	    //front
	    X += (10.0 * floatsin(0, degrees));
		Y += (10.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (6.0 * floatsin(0+45, degrees));
		Y += (6.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (6.0 * floatsin(0-45, degrees));
		Y += (6.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//right-left
		X += (10.0 * floatcos(0, degrees));
		Y += (10.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//back
		X -= (10.0 * floatcos(0, degrees));
		Y -= (10.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		X -= (10.0 * floatsin(0, degrees));
		Y -= (10.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (6.0 * floatsin(0+45, degrees));
		Y -= (6.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (6.0 * floatsin(0-45, degrees));
		Y -= (6.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	}
	else if (times == 2)
	{
	    //front
	    X += (15.0 * floatsin(0, degrees));
		Y += (15.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (9.0 * floatsin(0+45, degrees));
		Y += (9.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (9.0 * floatsin(0-45, degrees));
		Y += (9.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//right-left
		X += (15.0 * floatcos(0, degrees));
		Y += (15.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//back
		X -= (15.0 * floatcos(0, degrees));
		Y -= (15.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		X -= (15.0 * floatsin(0, degrees));
		Y -= (15.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (9.0 * floatsin(0+45, degrees));
		Y -= (9.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (9.0 * floatsin(0-45, degrees));
		Y -= (9.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	}
	else if (times == 1)
	{
	    //front
	    X += (20.0 * floatsin(0, degrees));
		Y += (20.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (12.0 * floatsin(0+45, degrees));
		Y += (12.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X += (12.0 * floatsin(0-45, degrees));
		Y += (12.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//right-left
		X += (20.0 * floatcos(0, degrees));
		Y += (20.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		//back
		X -= (20.0 * floatcos(0, degrees));
		Y -= (20.0 * floatsin(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
		X -= (20.0 * floatsin(0, degrees));
		Y -= (20.0 * floatcos(0, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (12.0 * floatsin(0+45, degrees));
		Y -= (12.0 * floatcos(0+45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	    X -= (12.0 * floatsin(0-45, degrees));
		Y -= (12.0 * floatcos(0-45, degrees));
		CreateExplosion(X, Y, Z, 7, 5);
	}
	
	if (times > 0) SetTimerEx("MissileExplosion", 700, 0, "fffd", x, y, z, times-1);
}

forward PushPlayer(playerid, distance, zup);
public  PushPlayer(playerid, distance, zup)
{
	new Float:X,Float:Y,Float:Z,Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	if (zup == 1) SetPlayerPos(playerid, X, Y, Z+5);
	GetPlayerPos(playerid, X, Y, Z);
	X -= (2.0 * floatsin(-A, degrees));
	Y -= (2.0 * floatcos(-A, degrees));
	SetPlayerPos(playerid, X, Y, Z);
	if (distance > 0) SetTimerEx("PushPlayer", 100, 0, "ddd", playerid, distance-1, 0);
}

stock GetVehicleModelIDFromName(vehname[])
{
	for(new i = 0; i < 211; i++)
	{
		if (strfind(VehNames[i], vehname, true) != -1) return i + 400;
	}
	return -1;
}

stock GetWeaponModelIDFromName(weapname[])
{
    for(new i = 0; i < 48; i++)
	{
        if (i == 19 || i == 20 || i == 21) continue;
		if (strfind(WeapNames[i], weapname, true) != -1) return i;
	}
	return -1;
}

stock bigstrtok(const string[], &idx)
{
    new length = strlen(string);
	while ((idx < length) && (string[idx] <= ' '))
	{
		idx++;
	}
	new offset = idx;
	new result[128];
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	{
		result[idx - offset] = string[idx];
		idx++;
	}
	result[idx - offset] = EOS;
	return result;
}
