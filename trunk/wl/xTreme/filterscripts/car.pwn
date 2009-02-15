/*
感谢您选择了Cn_Shindo的脚本!
您可以随意修改或者使用该脚本.
但希望您能保留作者信息,谢谢!
若有任何Bug或者问题,请发邮件到cn.shindo@gmail.com
*/

#include <a_samp>

#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_QGREEN 0x3FE65CFF


//--------------配置部分-------------------

public BuyCarFee = 0;//买车费用
//public QuickBuyFee = 3000; //快速买车费用(不用等待3秒)
public CarStopInteriorId = 0; //停车场场景
public CarRefreshTime = 60; //车辆刷新间隔,单位:秒
//public CountDown = 3; //车辆传送到玩家身边时间,单位:秒

//--------------停车场部分-----------------

//停车场1

public Float:X1 = -2066.3811; //停车场1X坐标
public Float:Y1 = 443.9429;//停车场1Y坐标
public Float:Z1 = 139.8973;//停车场1Z坐标
public Use1 = 1; //若为0则不启用,为1则启用停车场

//停车场2

public Float:X2 = -2083.4443; //停车场2X坐标
public Float:Y2 = 420.9623;//停车场2Y坐标
public Float:Z2 = 118.1662;//停车场2Z坐标
public Use2 = 1; //若为0则不启用,为1则启用停车场

//停车场3

public Float:X3 = -2104.4148; //停车场3X坐标
public Float:Y3 = 406.3305;//停车场3Y坐标
public Float:Z3 = 92.3194;//停车场3Z坐标
public Use3 = 1; //若为0则不启用,为1则启用停车场

//停车场4

public Float:X4 = 1991.0281; //停车场4X坐标
public Float:Y4 = 1869.4927;//停车场4Y坐标
public Float:Z4 = 122.2102;//停车场4Z坐标
public Use4 = 1; //若为0则不启用,为1则启用停车场

//停车场5

public Float:X5 = 1931.0175; //停车场5X坐标
public Float:Y5 = 1916.2675;//停车场5Y坐标
public Float:Z5 = 122.1973;//停车场5Z坐标
public Use5 = 1; //若为0则不启用,为1则启用停车场

//停车场6

public Float:X6 = 1986.4561; //停车场6X坐标
public Float:Y6 = 1952.0420;//停车场6Y坐标
public Float:Z6 = 122.4386;//停车场6Z坐标
public Use6 = 1; //若为0则不启用,为1则启用停车场

//停车场7

public Float:X7 = 2245.6287; //停车场7X坐标
public Float:Y7 = 1156.8188;//停车场7Y坐标
public Float:Z7 = 79.7583;//停车场7Z坐标
public Use7 = 1; //若为0则不启用,为1则启用停车场

//停车场8

public Float:X8 = 2185.8357; //停车场8X坐标
public Float:Y8 = 1047.9462;//停车场8Y坐标
public Float:Z8 = 80.1690;//停车场8Z坐标
public Use8 = 1; //若为0则不启用,为1则启用停车场

//停车场9

public Float:X9 = 2262.1069; //停车场9X坐标
public Float:Y9 = 1012.7636;//停车场9Y坐标
public Float:Z9 = 79.7315;//停车场9Z坐标
public Use9 = 1; //若为0则不启用,为1则启用停车场

//停车场10

public Float:X10 = 2313.7141; //停车场10X坐标
public Float:Y10 = 1117.9745;//停车场10Y坐标
public Float:Z10 = 79.7390;//停车场10Z坐标
public Use10 = 1; //若为0则不启用,为1则启用停车场

//--------------杂项-----------------------

new PlayerInCarStop[MAX_PLAYERS];
new PlayerInteriorId[MAX_PLAYERS];
new CarID[MAX_VEHICLES];
new Float:PlayerFacingAngle[MAX_PLAYERS];
//new Menu:QuickBuy;
//new IsPlayerQuickBuy[MAX_PLAYERS];
new Float:VX[MAX_PLAYERS],Float:VY[MAX_PLAYERS],Float:VZ[MAX_PLAYERS];
//new Float:GX[MAX_PLAYERS],Float:GY[MAX_PLAYERS],Float:GZ[MAX_PLAYERS];
public FirstVersion = 1;
public SecondVersion = 5;
/*new VehicleName[][] = {
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster Truck",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "Berkley's RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR-350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "Police Maverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring Racer",
   "Hotring Racer",
   "Bloodring Banger",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement Truck",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster Truck",
   "Monster Truck",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car (LSPD)",
   "Police Car (SFPD)",
   "Police Car (LVPD)",
   "Police Ranger",
   "Picador",
   "S.W.A.T. Van",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer",
   "Luggage Trailer",
   "Stair Trailer",
   "Boxville",
   "Farm Plow",
   "Utility Trailer"
};*/

//-------------过程------------------------

forward AddCar();
forward DelCar();
//forward RefreshMenuHeader(playerid,Menu:menu,text[]);
//forward AddMenu();
forward RefreshInfo();
forward GetParkInUse();
//forward GetVehicles();
//forward ObjPre(playerid,vehicleid);
//forward ObjPreEnd(playerid,vehicleid);

/*public AddMenu()
{
	QuickBuy = CreateMenu("Now:Off", 1, 50.0, 180.0, 200.0, 200.0);
	SetMenuColumnHeader(QuickBuy,0,"Now: Off");
	AddMenuItem(QuickBuy, 0, "On");
	AddMenuItem(QuickBuy, 0, "Off");
	return 1;
}*/

/*minrand(min, max)
{
 	return (max - min) + min;
}*/

stock GetVehicleName(vehicleid)
{
        new vn[50];
        format(vn,sizeof(vn),"%s",VehicleName[GetVehicleModel(vehicleid)-400]);
        return vn;
}

public GetParkInUse()
{
	new ParkInUse = 0;
	if (Use1 == 1) ParkInUse++;
	if (Use2 == 1) ParkInUse++;
	if (Use3 == 1) ParkInUse++;
	if (Use4 == 1) ParkInUse++;
	if (Use5 == 1) ParkInUse++;
	if (Use6 == 1) ParkInUse++;
	if (Use7 == 1) ParkInUse++;
	if (Use8 == 1) ParkInUse++;
	if (Use9 == 1) ParkInUse++;
	if (Use10 == 1) ParkInUse++;
	return ParkInUse;
}

/*public RefreshMenuHeader(playerid,Menu:menu,text[])
{
	SetMenuColumnHeader(menu,0,text);
	ShowMenuForPlayer(menu,playerid);
}*/

public DelCar()
{
	for (new i=0;i<MAX_VEHICLES;i++)
	{
		if(strlen(CarID[i])) DestroyVehicle(CarID[i]);
	}
}

public AddCar()
{
	//在下面加入创建车辆命令
	//第一个数字是车辆型号,第二个至第四个是坐标
	//第五个数是角度
	//第六个,第七个是颜色
	//第八个数是车辆刷新间隔(单位是秒)
	//改配置中的CarRefreshTime就行了
	//小提示:CarID[]中的[]里面的数字为车辆的ID,请勿与前面的重复!

//-------------停车场1车辆--------------------------
	if (Use1 == 1)
	{
		//-------INF------------
		CarID[1] = CreateVehicle(411,-2023.3679,443.2020,139.4082,180.6708,-1,-1,CarRefreshTime); //
		CarID[2] = CreateVehicle(411,-2031.7183,442.7450,139.4081,181.3802,-1,-1,CarRefreshTime); //
		CarID[3] = CreateVehicle(411,-2041.4769,443.3117,139.4080,179.7685,-1,-1,CarRefreshTime); //
		CarID[4] = CreateVehicle(411,-2049.6348,445.2310,139.4070,174.4575,-1,-1,CarRefreshTime); //
		CarID[5] = CreateVehicle(411,-2063.3774,445.1520,139.4082,135.3246,-1,-1,CarRefreshTime); //
		CarID[6] = CreateVehicle(411,-2066.3511,456.3026,139.4081,83.0646,-1,-1,CarRefreshTime); //
		CarID[7] = CreateVehicle(411,-2064.3560,463.4996,139.4077,90.3597,-1,-1,CarRefreshTime); //
		CarID[8] = CreateVehicle(411,-2064.1201,475.4834,139.4072,88.0853,-1,-1,CarRefreshTime); //
		CarID[9] = CreateVehicle(411,-2064.9792,487.6715,139.4073,87.0816,-1,-1,CarRefreshTime); //
	}

//-------------停车场2车辆--------------------------
	if (Use2 == 1)
	{
	    //---------BULLET-------
	    CarID[10] = CreateVehicle(541,-2044.4076,424.9601,115.7504,182.5551,-1,-1,CarRefreshTime); //
		CarID[11] = CreateVehicle(541,-2055.6680,423.4566,115.7515,183.9361,-1,-1,CarRefreshTime); //
		CarID[12] = CreateVehicle(541,-2069.0039,424.5894,115.7499,173.4368,-1,-1,CarRefreshTime); //
		CarID[13] = CreateVehicle(541,-2083.9590,424.7081,115.7508,142.7147,-1,-1,CarRefreshTime); //
		CarID[14] = CreateVehicle(541,-2086.5698,442.6363,115.7514,87.1959,-1,-1,CarRefreshTime); //
		CarID[15] = CreateVehicle(541,-2086.6809,455.0259,115.7515,91.6963,-1,-1,CarRefreshTime); //
		CarID[16] = CreateVehicle(541,-2089.3735,469.0998,115.7491,84.0162,-1,-1,CarRefreshTime); //
	}
	
//-------------停车场3车辆--------------------------
	if (Use3 == 1)
	{
		//--------TUR-----------
		CarID[17] = CreateVehicle(451,-2064.4517,406.5650,91.8483,184.9359,-1,-1,CarRefreshTime); //
		CarID[18] = CreateVehicle(451,-2077.5417,407.4767,91.8448,180.8136,-1,-1,CarRefreshTime); //
		CarID[19] = CreateVehicle(451,-2093.4321,404.9995,91.8500,183.2664,-1,-1,CarRefreshTime); //
		CarID[20] = CreateVehicle(451,-2106.9216,404.0398,91.8484,124.8895,-1,-1,CarRefreshTime); //
		CarID[21] = CreateVehicle(451,-2107.8838,419.3275,91.8490,82.3823,-1,-1,CarRefreshTime); //
		CarID[22] = CreateVehicle(451,-2107.6172,429.4395,91.8490,88.7357,-1,-1,CarRefreshTime); //
		CarID[23] = CreateVehicle(451,-2105.7739,439.5391,91.8488,84.0115,-1,-1,CarRefreshTime); //
	}
	
//-------------停车场4车辆--------------------------
	if (Use4 == 1)
	{
		//--------NRG----------
		CarID[49] = CreateVehicle(522,2001.6465,1852.9514,121.6223,305.3362,-1,-1,CarRefreshTime); //
		CarID[50] = CreateVehicle(522,1999.8517,1857.4407,121.6244,308.7264,-1,-1,CarRefreshTime); //
		CarID[51] = CreateVehicle(522,1996.8184,1862.0209,121.6179,298.0822,-1,-1,CarRefreshTime); //
		CarID[52] = CreateVehicle(522,1992.3093,1866.6787,121.6212,292.6625,-1,-1,CarRefreshTime); //
		CarID[53] = CreateVehicle(522,1990.5724,1871.0073,121.6177,293.9677,-1,-1,CarRefreshTime); //
		CarID[54] = CreateVehicle(522,1987.7444,1875.4229,121.6230,292.8213,-1,-1,CarRefreshTime); //
		CarID[55] = CreateVehicle(522,1983.8726,1882.5448,121.6226,293.8338,-1,-1,CarRefreshTime); //
		CarID[56] = CreateVehicle(522,1979.7172,1888.2673,121.6234,296.9427,-1,-1,CarRefreshTime); //
		CarID[57] = CreateVehicle(522,1977.9707,1894.6245,121.6229,304.3346,-1,-1,CarRefreshTime); //
	}

//-------------停车场5车辆--------------------------
	if (Use5 == 1)
	{
		//--------SULTAN------------
		CarID[62] = CreateVehicle(560,1895.1466,1916.5135,121.9108,5.6535,-1,-1,CarRefreshTime); //
		CarID[63] = CreateVehicle(560,1903.0109,1916.1439,121.9110,351.8618,-1,-1,CarRefreshTime); //
		CarID[64] = CreateVehicle(560,1914.0013,1915.8409,121.9110,354.7319,-1,-1,CarRefreshTime); //
		CarID[65] = CreateVehicle(560,1927.1047,1916.3605,121.9112,359.7362,-1,-1,CarRefreshTime); //
		CarID[66] = CreateVehicle(560,1937.5382,1915.4919,121.9107,6.8857,-1,-1,CarRefreshTime); //
	}
	
//-------------停车场6车辆--------------------------
	if (Use6 == 1)
	{
	    //-------Vortex------------
   		CarID[58] = CreateVehicle(539,1977.8157,1938.9248,122.3906,237.0581,-1,-1,CarRefreshTime); //
		CarID[59] = CreateVehicle(539,1982.9735,1948.8992,122.3907,243.3204,-1,-1,CarRefreshTime); //
		CarID[60] = CreateVehicle(539,1989.5475,1959.3615,122.3905,234.5709,-1,-1,CarRefreshTime); //
		CarID[61] = CreateVehicle(539,1997.2289,1973.0779,122.3906,246.5412,-1,-1,CarRefreshTime); //
		
	}
	
//-------------停车场7车辆--------------------------
	if (Use7 == 1)
	{
		//-----ELEGY----------
		CarID[42] = CreateVehicle(562,2271.7019,1165.2423,79.2137,201.2611,-1,-1,CarRefreshTime); //
		CarID[43] = CreateVehicle(562,2264.4856,1162.8420,79.2145,201.1627,-1,-1,CarRefreshTime); //
		CarID[44] = CreateVehicle(562,2255.7925,1159.7284,79.2132,200.9742,-1,-1,CarRefreshTime); //
		CarID[45] = CreateVehicle(562,2244.2278,1157.3784,79.2151,197.8872,-1,-1,CarRefreshTime); //
		CarID[46] = CreateVehicle(562,2233.6257,1152.2908,79.2133,199.4051,-1,-1,CarRefreshTime); //
		CarID[47] = CreateVehicle(562,2224.1057,1150.2841,79.2128,196.6564,-1,-1,CarRefreshTime); //
		CarID[48] = CreateVehicle(562,2212.7083,1145.7296,79.2134,201.7736,-1,-1,CarRefreshTime); //
	}
	
//-------------停车场8车辆--------------------------
	if (Use8 == 1)
	{
		//--------MOUNTAIN BIKE------
	    CarID[24] = CreateVehicle(510,2198.1382,1017.5801,79.1251,115.4067,-1,-1,CarRefreshTime); //
		CarID[25] = CreateVehicle(510,2195.4189,1023.9861,79.1284,104.7608,-1,-1,CarRefreshTime); //
		CarID[26] = CreateVehicle(510,2191.8613,1032.4982,79.1193,118.9956,-1,-1,CarRefreshTime); //
		CarID[27] = CreateVehicle(510,2189.6526,1039.1798,79.1135,109.6487,-1,-1,CarRefreshTime); //
		CarID[28] = CreateVehicle(510,2185.6831,1049.5298,79.0232,110.3411,-1,-1,CarRefreshTime); //
		CarID[29] = CreateVehicle(510,2181.1436,1060.0232,79.1266,106.6066,-1,-1,CarRefreshTime); //
		CarID[30] = CreateVehicle(510,2179.5620,1066.8831,79.1216,113.0486,-1,-1,CarRefreshTime); //
		CarID[31] = CreateVehicle(510,2176.1013,1075.7761,79.1264,110.8687,-1,-1,CarRefreshTime); //
	}

//-------------停车场9车辆--------------------------
	if (Use9 == 1)
	{
	    //------MONSTER-----------
		CarID[32] = CreateVehicle(557,2280.1125,1019.1058,79.2601,199.9350,-1,-1,CarRefreshTime); //
		CarID[33] = CreateVehicle(557,2270.6677,1014.3505,79.2603,202.8287,-1,-1,CarRefreshTime); //
		CarID[34] = CreateVehicle(557,2261.7317,1011.1100,79.2599,200.9348,-1,-1,CarRefreshTime); //
		CarID[35] = CreateVehicle(557,2252.6401,1007.7203,79.2604,196.4294,-1,-1,CarRefreshTime); //
		CarID[36] = CreateVehicle(557,2242.8733,1003.7222,79.2600,200.4519,-1,-1,CarRefreshTime); //
 	}

//-------------停车场10车辆--------------------------
	if (Use10 == 1)
	{
	    //-----HOTRING-----------
		CarID[37] = CreateVehicle(494,2321.1985,1104.2446,78.9147,107.1026,-1,-1,CarRefreshTime); //
		CarID[38] = CreateVehicle(494,2319.1550,1109.8325,78.9148,98.1850,-1,-1,CarRefreshTime); //
		CarID[39] = CreateVehicle(494,2317.6594,1116.8315,78.9143,112.7485,-1,-1,CarRefreshTime); //
		CarID[40] = CreateVehicle(494,2314.4438,1125.9196,78.9139,100.3746,-1,-1,CarRefreshTime); //
		CarID[41] = CreateVehicle(494,2310.5586,1137.0227,78.9144,102.8883,-1,-1,CarRefreshTime); //
	}
}

/*public GetVehicles()
{
	new Vehicles = 0;
    for (new i=0;i<MAX_VEHICLES;i++)
	{
		if(strlen(CarID[i])) Vehicles++;
	}
	return Vehicles;
}*/

public OnFilterScriptInit()
{
	//--------------输出脚本信息----------------------
	print("\n--------------------------------------");
	printf(" 买车费用 = %d",BuyCarFee);
	//printf(" 快速买车费用 = %d", QuickBuyFee);
	printf(" 停车场场景 = %d",CarStopInteriorId);
	printf(" 车辆刷新间隔 = %d 秒",CarRefreshTime);
	print(" 停车场数量 = 10");
	printf(" 启用停车场数量 = %d",GetParkInUse());
	//printf(" 车辆数 = %d",GetVehicles());
	print("--------------------------------------");
	print(" 1号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X1,Y1,Z1);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use1);
	print("--------------------------------------");
	print(" 2号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X2,Y2,Z2);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use2);
	print("--------------------------------------");
	print(" 3号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X3,Y3,Z3);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use3);
	print("--------------------------------------");
	print(" 4号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X4,Y4,Z4);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use4);
	print("--------------------------------------");
	print(" 5号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X5,Y5,Z5);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use5);
	print("--------------------------------------");
	print(" 6号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X6,Y6,Z6);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use6);
	print("--------------------------------------");
	print(" 7号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X7,Y7,Z7);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use7);
	print("--------------------------------------");
	print(" 8号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X8,Y8,Z8);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use8);
	print("--------------------------------------");
	print(" 9号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X9,Y9,Z9);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use9);
	print("--------------------------------------");
	print(" 10号停车场坐标:");
	printf(" X=%f,Y=%f,Z=%f",X10,Y10,Z10);
	printf(" 是否启用:%d [启用为1,不启用为0]",Use10);
	print("--------------------------------------");
	
	//--------------加载车辆------------------------
	AddCar();
	
	//--------------输出作者信息--------------------
	print(" 买车系统准备就绪!");
	print(" 作者:Cn_Shindo");
	print(" 若有任何Bug或者问题,请发邮件到cn.shindo@gmail.com");
	print(" 感谢[ITC]RR_LXD提供停车场坐标和车辆坐标!");
	print(" 感谢vvg提供想法.");
	printf(" 版本:%d.%d", FirstVersion, SecondVersion);
	print("--------------------------------------\n");

	//--------------提示玩家买车系统开启--------------------
	SendClientMessageToAll(COLOR_LIGHTBLUE, " 服务器启用了买车系统,输入/ch查看买车系统帮助.");
	
	return 1;
}

public OnFilterScriptExit()
{
    //DestroyMenu(QuickBuy);
    DelCar();
	print("\n--------------------------------------");
	print(" 买车系统退出,车辆已删除!");
	print(" 作者:Cn_Shindo");
	print(" 若有任何Bug或者问题,请发邮件到cn.shindo@gmail.com");
	print(" 感谢[ITC]RR_LXD提供停车场坐标和车辆坐标!");
	print(" 感谢vvg提供想法.");
	printf(" 版本:%d.%d", FirstVersion, SecondVersion);
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid,COLOR_LIGHTBLUE, " 服务器启用了买车系统,输入/ch查看买车系统帮助.");
	PlayerInCarStop[playerid] = 0;
	PlayerFacingAngle[playerid] = 0;
	VX[playerid] = 0;
	VY[playerid] = 0;
	VZ[playerid] = 0;
	//GX[playerid] = 0;
	//GY[playerid] = 0;
	//GZ[playerid] = 0;
	PlayerInteriorId[playerid] = 0;
	//IsPlayerQuickBuy[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	PlayerInCarStop[playerid] = 0;
	PlayerFacingAngle[playerid] = 0;
	VX[playerid] = 0;
	VY[playerid] = 0;
	VZ[playerid] = 0;
	//GX[playerid] = 0;
	//GY[playerid] = 0;
	//GZ[playerid] = 0;
	PlayerInteriorId[playerid] = 0;
	//IsPlayerQuickBuy[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	PlayerInCarStop[playerid] = 0;
	PlayerFacingAngle[playerid] = 0;
	VX[playerid] = 0;
	VY[playerid] = 0;
	VZ[playerid] = 0;
	//GX[playerid] = 0;
	//GY[playerid] = 0;
	//GZ[playerid] = 0;
	PlayerInteriorId[playerid] = 0;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	PlayerInCarStop[playerid] = 0;
	PlayerFacingAngle[playerid] = 0;
	VX[playerid] = 0;
	VY[playerid] = 0;
	VZ[playerid] = 0;
	//GX[playerid] = 0;
	//GY[playerid] = 0;
	//GZ[playerid] = 0;
	PlayerInteriorId[playerid] = 0;
	return 1;
}

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

public OnPlayerCommandText(playerid, cmdtext[])
{
	new tmp[128];
	new cmd[128];
	new idx;
	cmd = strtok(cmdtext,idx);
	
    //-------------------买车系统帮助----------------------------
	if (strcmp("/ch", cmdtext, true, 10) == 0 || strcmp("/chehelp", cmdtext, true, 10) == 0 || strcmp("/carhelp", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," 买车系统帮助:");
		SendClientMessage(playerid,COLOR_YELLOW," /car /che - 停车场列表");
		SendClientMessage(playerid,COLOR_YELLOW," /vabout - 关于买车系统");
		//SendClientMessage(playerid,COLOR_YELLOW," /vgo - 传送到任意一辆车旁边");
		format(str,sizeof(str)," 每次买车都要扣费$%d.", BuyCarFee);
		SendClientMessage(playerid,COLOR_QGREEN,str);
		//format(str,sizeof(str)," 每次买车需要等待%d秒传送到您身边.", CountDown);
		//SendClientMessage(playerid,COLOR_QGREEN," 使用/vgo命令完全免费!");
		//format(str,sizeof(str)," 如果你启用了快速买车功能,将不会等待%d秒车传送到你身边,但要扣费$%d.", CountDown,QuickBuyFee);
		//SendClientMessage(playerid,COLOR_QGREEN,str);
		format(str,sizeof(str)," 车辆刷新间隔为%d秒.", CarRefreshTime);
		SendClientMessage(playerid,COLOR_QGREEN,str);
		return 1;
	}
	
	/*if (strcmp("/vgo", cmdtext, true, 10) == 0)
	{
		new str[256];
	    new vehicleid = minrand(1, MAX_VEHICLES);
	    new Float:health;
	    GetVehicleHealth(vehicleid,health);
		if (health <= 0)
		{
			vehicleid = 0;
			SendClientMessage(playerid,COLOR_GREEN," 传送失败,请重试.");
 		} else {
 			GetVehiclePos(vehicleid,GX[playerid],GY[playerid],GZ[playerid]);
			SetPlayerPos(playerid,GX[playerid],GY[playerid],GZ[playerid]+2);
 			format(str,sizeof(str)," 你已传送到一辆车旁边(车辆ID:%d,模型ID:%d,车辆名称:%s)",vehicleid,GetVehicleModel(vehicleid),GetVehicleName(vehicleid));
 			SendClientMessage(playerid,COLOR_GREEN,str);
 			vehicleid = 0;
 		}
		return 1;
	}*/
	
	//------------------管理买车系统-----------------------------
	if (IsPlayerAdmin(playerid))
	{

	    //---------------管理员帮助--------------------------
		if (strcmp("/vadmin", cmdtext, true, 10) == 0)
		{
		    SendClientMessage(playerid,COLOR_GREEN," 管理买车系统:");
		    SendClientMessage(playerid,COLOR_YELLOW," /vinfo - 系统运行信息.");
		    SendClientMessage(playerid,COLOR_YELLOW," /vcm - 更改买车费用.");
		    //SendClientMessage(playerid,COLOR_YELLOW," /vqm - 更改快速买车费用.");
		    SendClientMessage(playerid,COLOR_YELLOW," /vct - 更改车辆刷新间隔.");
		    //SendClientMessage(playerid,COLOR_YELLOW," /vcwt - 更改车辆传送到玩家身边间隔.");
			return 1;
		}

		//---------------系统运行信息--------------------------
		if (strcmp("/vinfo", cmdtext, true, 10) == 0)
		{
		    new str[256];
		    SendClientMessage(playerid,COLOR_GREEN," 系统运行信息:");
		    format(str,sizeof(str)," 买车费用 = $%d", BuyCarFee);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    format(str,sizeof(str)," 停车场场景 = %d", CarStopInteriorId);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    format(str,sizeof(str)," 车辆刷新间隔 = %d秒", CarRefreshTime);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    SendClientMessage(playerid,COLOR_YELLOW," 停车场数量 = 10");
		    format(str,sizeof(str)," 停车场启用数量 = %d", GetParkInUse());
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    return 1;
		}

		//---------------更改买车费用--------------------------
		if(strcmp(cmd, "/vcm", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
   				SendClientMessage(playerid, COLOR_GREEN, " 更改买车费用:");
				SendClientMessage(playerid, COLOR_QGREEN, " 用法: /vcm [金额]");
				SendClientMessage(playerid, COLOR_QGREEN, " 说明: 更改买车费用.");
				return 1;
			}
			new NewBuyCarFee = strval(tmp);
			if (NewBuyCarFee >= 0)
			{
				BuyCarFee = NewBuyCarFee;
				format(str,sizeof(str)," 买车费用更改成功,新费用为$%d.", BuyCarFee);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " 买车费用不能低于$0!");
		    return 1;
		}
		
		/* //---------------更改快速买车费用--------------------------
		if (strcmp("/vqm", cmdtext, true, 10) == 0)
		{
			new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_GREEN, " 更改快速买车费用:");
				SendClientMessage(playerid, COLOR_QGREEN, " 用法: /vqm [金额]");
				SendClientMessage(playerid, COLOR_QGREEN, " 说明: 更改快速买车费用.");
				return 1;
			}
			new NewQuickBuyFee = strval(tmp);
			if (NewQuickBuyFee >= 0)
			{
				QuickBuyFee = NewQuickBuyFee;
				format(str,sizeof(str)," 快速买车费用更改成功,新费用为$%d..", QuickBuyFee);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " 快速买车费用不能低于$0!");
		    return 1;
		} */

		/* //---------------更改车辆传送到玩家身边间隔--------------------------
		if(strcmp(cmd, "/vcwt", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
   				SendClientMessage(playerid, COLOR_GREEN, " 更改车辆传送到玩家身边间隔:");
				SendClientMessage(playerid, COLOR_QGREEN, " 用法: /vcwt [时间]");
				SendClientMessage(playerid, COLOR_QGREEN, " 说明: 更改车辆传送到玩家身边间隔,单位:秒.");
				return 1;
			}
			new NewCount = strval(tmp);
			if (NewCount >= 0)
			{
				CountDown = NewCount;
				format(str,sizeof(str)," 车辆传送到玩家身边间隔更改成功,新时间为$%d.", CountDown);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " 车辆传送到玩家身边间隔必须高于0秒!");
		    return 1;
		}*/

		//---------------更改车辆刷新时间--------------------------
		if(strcmp(cmd, "/vct", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_GREEN, " 更改车辆刷新时间:");
				SendClientMessage(playerid, COLOR_QGREEN, " 用法: /vcct [时间]");
				SendClientMessage(playerid, COLOR_QGREEN, " 说明: 更改车辆刷新时间(单位为秒).");
				return 1;
			}
			new NewCarRefreshTime = strval(tmp);
			if (NewCarRefreshTime > 0)
			{
				CarRefreshTime = NewCarRefreshTime;
				DelCar();
				AddCar();
				format(str,sizeof(str)," 车辆刷新时间更改成功,新间隔为%d秒.", CarRefreshTime);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " 车辆刷新时间必须高于0秒!");
		    return 1;
		}
	}
	
	//------------------关于买车系统-----------------------------
	if (strcmp("/vabout", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," 关于买车系统:");
		SendClientMessage(playerid,COLOR_YELLOW," 作者:Cn_Shindo");
		SendClientMessage(playerid,COLOR_YELLOW," 车辆&停车场坐标:[ITC]RR_LXD");
		SendClientMessage(playerid,COLOR_YELLOW," 策划:vvg");
		format(str,sizeof(str)," 版本:%d.%d", FirstVersion, SecondVersion);
		SendClientMessage(playerid,COLOR_YELLOW,str);
		return 1;
	}

	//-------------------停车场列表------------------------------
	if (strcmp("/carpark", cmdtext, true, 10) == 0 || strcmp("/tingchechang", cmdtext, true, 10) == 0 || strcmp("/cp", cmdtext, true, 10) == 0 || strcmp("/tcc", cmdtext, true, 10) == 0 || strcmp("/tingche", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," 停车场列表:");
		format(str,sizeof(str)," 1号停车场:/inf 是否开启:%d 车辆:Infernus     | 2号停车场:/bul 是否开启:%d 车辆:Bullet", Use1, Use2);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 3号停车场:/tur 是否开启:%d 车辆:Turismo    | 4号停车场:/nrg 是否开启:%d 车辆:NRG500", Use3, Use4);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 5号停车场:/sul 是否开启:%d 车辆:Sultan        | 6号停车场:/vor 是否开启:%d 车辆:Vortex", Use5, Use6);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 7号停车场:/ele 是否开启:%d 车辆:Elegy          | 8号停车场:/mnb 是否开启:%d 车辆:Mountain Bike", Use7, Use8);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 9号停车场:/mon 是否开启:%d 车辆:Monster | 10号停车场:/hot 是否开启:%d 车辆:Hotring", Use9, Use10);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		SendClientMessage(playerid,COLOR_QGREEN, " 是否开启中的值为1则开启,为0则关闭.");
		return 1;
	}
	
	//-------------------停车场1命令部分----------------------------
	if (strcmp("/411", cmdtext, true, 10) == 0 || strcmp("/inf", cmdtext, true, 10) == 0) //停车场1的命令
	{
	    new str[256];
		if (Use1 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X1,Y1,Z1);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到1号停车场,车辆:Infernus.");
                		format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场2命令部分----------------------------
	if (strcmp("/541", cmdtext, true, 10) == 0 || strcmp("/bul", cmdtext, true, 10) == 0) //停车场2的命令
	{
	    new str[256];
		if (Use2 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X2,Y2,Z2);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到2号停车场,车辆:Bullet.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场3命令部分----------------------------
	if (strcmp("/451", cmdtext, true, 10) == 0 || strcmp("/tur", cmdtext, true, 10) == 0) //停车场3的命令
	{
	    new str[256];
		if (Use3 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X3,Y3,Z3);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到3号停车场,车辆:Turismo.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场4命令部分----------------------------
	if (strcmp("/522", cmdtext, true, 10) == 0 || strcmp("/nrg", cmdtext, true, 10) == 0) //停车场4的命令
	{
	    new str[256];
		if (Use4 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X4,Y4,Z4);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到4号停车场,车辆:NRG500.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场5命令部分----------------------------
	if (strcmp("/560", cmdtext, true, 10) == 0 || strcmp("/sul", cmdtext, true, 10) == 0) //停车场5的命令
	{
	    new str[256];
		if (Use5 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X5,Y5,Z5);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到5号停车场,车辆:Sultan.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场6命令部分----------------------------
	if (strcmp("/539", cmdtext, true, 10) == 0 || strcmp("/vor", cmdtext, true, 10) == 0) //停车场6的命令
	{
	    new str[256];
		if (Use6 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X6,Y6,Z6);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到6号停车场,车辆:Vortex.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场7命令部分----------------------------
	if (strcmp("/562", cmdtext, true, 10) == 0 || strcmp("/ele", cmdtext, true, 10) == 0) //停车场7的命令
	{
	    new str[256];
		if (Use7 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X7,Y7,Z7);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到7号停车场,车辆:Elegy.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
					    SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场8命令部分----------------------------
	if (strcmp("/510", cmdtext, true, 10) == 0 || strcmp("/mnb", cmdtext, true, 10) == 0) //停车场8的命令
	{
	    new str[256];
		if (Use8 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X8,Y8,Z8);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到8号停车场,车辆:Mountain Bike.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场9命令部分----------------------------
	if (strcmp("/557", cmdtext, true, 10) == 0 || strcmp("/mon", cmdtext, true, 10) == 0) //停车场9的命令
	{
	    new str[256];
		if (Use9 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X9,Y9,Z9);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到9号停车场,车辆:Monster.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
	//-------------------停车场10命令部分----------------------------
	if (strcmp("/494", cmdtext, true, 10) == 0 || strcmp("/hot", cmdtext, true, 10) == 0) //停车场10的命令
	{
	    new str[256];
		if (Use10 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," 呵呵,你已经在车上了,还买车?");
			} else {
					new PlayerMoney;
					PlayerMoney = GetPlayerMoney(playerid);
					if (PlayerMoney >= BuyCarFee)
					{
			    		if (PlayerInCarStop[playerid] == 0)
						{
						    PlayerInteriorId[playerid] = GetPlayerInterior(playerid);
							GetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
						}
						PlayerInCarStop[playerid] = 1;
						GetPlayerFacingAngle(playerid, PlayerFacingAngle[playerid]);
						SetPlayerInterior(playerid,CarStopInteriorId);
						SetPlayerPos(playerid,X10,Y10,Z10);
                		SendClientMessage(playerid,COLOR_QGREEN, " 欢迎来到10号停车场,车辆:Hotring.");
						format(str,sizeof(str)," 如果没有车了,请等待%d秒的车辆刷新,或者输入/vout离开停车场.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " 呵呵,钱不够还想买车?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," 该停车场未开启!");
		}
		return 1;
	}
	
 	if (strcmp("/vout", cmdtext, true, 10) == 0)
	{
		if (PlayerInCarStop[playerid] == 1)
		{
			PlayerInCarStop[playerid] = 0;
			SetPlayerInterior(playerid,PlayerInteriorId[playerid]);
			SetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
			SendClientMessage(playerid,COLOR_QGREEN, " 你已经离开停车场了.");
		} else {
		    SendClientMessage(playerid,COLOR_GREEN, " 你不在停车场,怎么离开停车场哪?");
		}
  		return 1;
		}

	if (PlayerInCarStop[playerid] == 1)
	{
		SendClientMessage(playerid,COLOR_GREEN, " 请买完车再输入其他命令.");
		return 1;
	} else {
		return 0;
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    new str[256];
	if(newstate == 2)
	{
		if (PlayerInCarStop[playerid] == 1)
		{
 			PlayerInCarStop[playerid] = 0;
 			SetCameraBehindPlayer(playerid);
 			LinkVehicleToInterior(GetPlayerVehicleID(playerid),PlayerInteriorId[playerid]);
    		SetVehiclePos(GetPlayerVehicleID(playerid), VX[playerid], VY[playerid], VZ[playerid]+6);
        	SetVehicleZAngle(GetPlayerVehicleID(playerid), PlayerFacingAngle[playerid]);
     	   	GameTextForPlayer(playerid,"~g~Car ~y~Is~b~ Here", 5000, 6);
			GivePlayerMoney(playerid, -BuyCarFee);
			format(str,sizeof(str)," 买车成功,扣费$%d", BuyCarFee);
			SendClientMessage(playerid,COLOR_QGREEN, str);
			VX[playerid] = 0;
			VY[playerid] = 0;
			VZ[playerid] = 0;
			//if (IsPlayerQuickBuy[playerid] == 0)
			//{
			//format(str,sizeof(str)," 请等待车辆传送到您身边(%d秒).", CountDown);
			//SendClientMessage(playerid,COLOR_GREEN, str);
				//format(str,sizeof(str)," 你尚未启用快速买车功能,启用该功能无需等待%d秒(/vqb)", CountDown);
				//SendClientMessage(playerid,COLOR_GREEN, str);
				//ObjPre(playerid,GetPlayerVehicleID(playerid));
			//} else if(IsPlayerQuickBuy[playerid] == 1)
			//{
                //SendClientMessage(playerid,COLOR_GREEN, " 你启用了快速买车功能,车辆马上传送到你身边.");
                //GameTextForPlayer(playerid,"~g~Car ~y~Is~b~ Here", 5000, 6);
                //LinkVehicleToInterior(GetPlayerVehicleID(playerid),PlayerInteriorId[playerid]);
                //SetVehiclePos(GetPlayerVehicleID(playerid),VX[playerid],VY[playerid],VZ[playerid]);
                //GivePlayerMoney(playerid, -BuyCarFee);
                //GivePlayerMoney(playerid, -QuickBuyFee);
                //format(str,sizeof(str)," 买车成功,扣费$%d(加收快速买车费用$%d)", BuyCarFee,QuickBuyFee);
				//SendClientMessage(playerid,COLOR_QGREEN, str);
               	//VX[playerid] = 0;
				//VY[playerid] = 0;
				//VZ[playerid] = 0;
			//}
		}
	}
	return 1;
}

/*public ObjPre(playerid,vehicleid)
{
 	RemovePlayerFromVehicle(playerid);
  	SetPlayerPos(playerid,VX[playerid],VY[playerid],VZ[playerid]);
	SetPlayerInterior(playerid,PlayerInteriorId[playerid]);
	GameTextForPlayer(playerid,"~g~Please ~y~Wait ~b~For ~w~Car", 5000, 6);
	SetTimerEx("ObjPreEnd",CountDown * 1000,0,"ii",playerid,vehicleid);
	return 1;
}

public ObjPreEnd(playerid,vehicleid)
{
	new str[256];
    GameTextForPlayer(playerid,"~g~Car ~y~Is~b~ Here", 5000, 6);
	LinkVehicleToInterior(vehicleid,PlayerInteriorId[playerid]);
	SetVehiclePos(vehicleid,VX[playerid],VY[playerid],VZ[playerid]);
	PutPlayerInVehicle(playerid,vehicleid,0);
	GivePlayerMoney(playerid, -BuyCarFee);
	format(str,sizeof(str)," 买车成功,扣费$%d", BuyCarFee);
	SendClientMessage(playerid,COLOR_QGREEN, str);
	VX[playerid] = 0;
	VY[playerid] = 0;
	VZ[playerid] = 0;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:current;
    current = GetPlayerMenu(playerid);
    if(current == QuickBuy)
    {
        switch(row)
        {
            case 0:
			{
				IsPlayerQuickBuy[playerid] = 1;
				RefreshMenuHeader(playerid,QuickBuy,"Now:On");
            }
            case 1:
			{
				IsPlayerQuickBuy[playerid] = 0;
				RefreshMenuHeader(playerid,QuickBuy,"Now:Off");
            }
        }
    }
    return 1;
}

public OnPlayerExitedMenu(playerid)
{
    TogglePlayerControllable(playerid,1);
	return 1;
}*/
