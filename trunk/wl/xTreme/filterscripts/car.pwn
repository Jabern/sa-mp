/*
��л��ѡ����Cn_Shindo�Ľű�!
�����������޸Ļ���ʹ�øýű�.
��ϣ�����ܱ���������Ϣ,лл!
�����κ�Bug��������,�뷢�ʼ���cn.shindo@gmail.com
*/

#include <a_samp>

#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_QGREEN 0x3FE65CFF


//--------------���ò���-------------------

public BuyCarFee = 0;//�򳵷���
//public QuickBuyFee = 3000; //�����򳵷���(���õȴ�3��)
public CarStopInteriorId = 0; //ͣ��������
public CarRefreshTime = 60; //����ˢ�¼��,��λ:��
//public CountDown = 3; //�������͵�������ʱ��,��λ:��

//--------------ͣ��������-----------------

//ͣ����1

public Float:X1 = -2066.3811; //ͣ����1X����
public Float:Y1 = 443.9429;//ͣ����1Y����
public Float:Z1 = 139.8973;//ͣ����1Z����
public Use1 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����2

public Float:X2 = -2083.4443; //ͣ����2X����
public Float:Y2 = 420.9623;//ͣ����2Y����
public Float:Z2 = 118.1662;//ͣ����2Z����
public Use2 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����3

public Float:X3 = -2104.4148; //ͣ����3X����
public Float:Y3 = 406.3305;//ͣ����3Y����
public Float:Z3 = 92.3194;//ͣ����3Z����
public Use3 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����4

public Float:X4 = 1991.0281; //ͣ����4X����
public Float:Y4 = 1869.4927;//ͣ����4Y����
public Float:Z4 = 122.2102;//ͣ����4Z����
public Use4 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����5

public Float:X5 = 1931.0175; //ͣ����5X����
public Float:Y5 = 1916.2675;//ͣ����5Y����
public Float:Z5 = 122.1973;//ͣ����5Z����
public Use5 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����6

public Float:X6 = 1986.4561; //ͣ����6X����
public Float:Y6 = 1952.0420;//ͣ����6Y����
public Float:Z6 = 122.4386;//ͣ����6Z����
public Use6 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����7

public Float:X7 = 2245.6287; //ͣ����7X����
public Float:Y7 = 1156.8188;//ͣ����7Y����
public Float:Z7 = 79.7583;//ͣ����7Z����
public Use7 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����8

public Float:X8 = 2185.8357; //ͣ����8X����
public Float:Y8 = 1047.9462;//ͣ����8Y����
public Float:Z8 = 80.1690;//ͣ����8Z����
public Use8 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����9

public Float:X9 = 2262.1069; //ͣ����9X����
public Float:Y9 = 1012.7636;//ͣ����9Y����
public Float:Z9 = 79.7315;//ͣ����9Z����
public Use9 = 1; //��Ϊ0������,Ϊ1������ͣ����

//ͣ����10

public Float:X10 = 2313.7141; //ͣ����10X����
public Float:Y10 = 1117.9745;//ͣ����10Y����
public Float:Z10 = 79.7390;//ͣ����10Z����
public Use10 = 1; //��Ϊ0������,Ϊ1������ͣ����

//--------------����-----------------------

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

//-------------����------------------------

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
	//��������봴����������
	//��һ�������ǳ����ͺ�,�ڶ��������ĸ�������
	//��������ǽǶ�
	//������,���߸�����ɫ
	//�ڰ˸����ǳ���ˢ�¼��(��λ����)
	//�������е�CarRefreshTime������
	//С��ʾ:CarID[]�е�[]���������Ϊ������ID,������ǰ����ظ�!

//-------------ͣ����1����--------------------------
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

//-------------ͣ����2����--------------------------
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
	
//-------------ͣ����3����--------------------------
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
	
//-------------ͣ����4����--------------------------
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

//-------------ͣ����5����--------------------------
	if (Use5 == 1)
	{
		//--------SULTAN------------
		CarID[62] = CreateVehicle(560,1895.1466,1916.5135,121.9108,5.6535,-1,-1,CarRefreshTime); //
		CarID[63] = CreateVehicle(560,1903.0109,1916.1439,121.9110,351.8618,-1,-1,CarRefreshTime); //
		CarID[64] = CreateVehicle(560,1914.0013,1915.8409,121.9110,354.7319,-1,-1,CarRefreshTime); //
		CarID[65] = CreateVehicle(560,1927.1047,1916.3605,121.9112,359.7362,-1,-1,CarRefreshTime); //
		CarID[66] = CreateVehicle(560,1937.5382,1915.4919,121.9107,6.8857,-1,-1,CarRefreshTime); //
	}
	
//-------------ͣ����6����--------------------------
	if (Use6 == 1)
	{
	    //-------Vortex------------
   		CarID[58] = CreateVehicle(539,1977.8157,1938.9248,122.3906,237.0581,-1,-1,CarRefreshTime); //
		CarID[59] = CreateVehicle(539,1982.9735,1948.8992,122.3907,243.3204,-1,-1,CarRefreshTime); //
		CarID[60] = CreateVehicle(539,1989.5475,1959.3615,122.3905,234.5709,-1,-1,CarRefreshTime); //
		CarID[61] = CreateVehicle(539,1997.2289,1973.0779,122.3906,246.5412,-1,-1,CarRefreshTime); //
		
	}
	
//-------------ͣ����7����--------------------------
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
	
//-------------ͣ����8����--------------------------
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

//-------------ͣ����9����--------------------------
	if (Use9 == 1)
	{
	    //------MONSTER-----------
		CarID[32] = CreateVehicle(557,2280.1125,1019.1058,79.2601,199.9350,-1,-1,CarRefreshTime); //
		CarID[33] = CreateVehicle(557,2270.6677,1014.3505,79.2603,202.8287,-1,-1,CarRefreshTime); //
		CarID[34] = CreateVehicle(557,2261.7317,1011.1100,79.2599,200.9348,-1,-1,CarRefreshTime); //
		CarID[35] = CreateVehicle(557,2252.6401,1007.7203,79.2604,196.4294,-1,-1,CarRefreshTime); //
		CarID[36] = CreateVehicle(557,2242.8733,1003.7222,79.2600,200.4519,-1,-1,CarRefreshTime); //
 	}

//-------------ͣ����10����--------------------------
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
	//--------------����ű���Ϣ----------------------
	print("\n--------------------------------------");
	printf(" �򳵷��� = %d",BuyCarFee);
	//printf(" �����򳵷��� = %d", QuickBuyFee);
	printf(" ͣ�������� = %d",CarStopInteriorId);
	printf(" ����ˢ�¼�� = %d ��",CarRefreshTime);
	print(" ͣ�������� = 10");
	printf(" ����ͣ�������� = %d",GetParkInUse());
	//printf(" ������ = %d",GetVehicles());
	print("--------------------------------------");
	print(" 1��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X1,Y1,Z1);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use1);
	print("--------------------------------------");
	print(" 2��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X2,Y2,Z2);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use2);
	print("--------------------------------------");
	print(" 3��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X3,Y3,Z3);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use3);
	print("--------------------------------------");
	print(" 4��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X4,Y4,Z4);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use4);
	print("--------------------------------------");
	print(" 5��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X5,Y5,Z5);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use5);
	print("--------------------------------------");
	print(" 6��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X6,Y6,Z6);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use6);
	print("--------------------------------------");
	print(" 7��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X7,Y7,Z7);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use7);
	print("--------------------------------------");
	print(" 8��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X8,Y8,Z8);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use8);
	print("--------------------------------------");
	print(" 9��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X9,Y9,Z9);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use9);
	print("--------------------------------------");
	print(" 10��ͣ��������:");
	printf(" X=%f,Y=%f,Z=%f",X10,Y10,Z10);
	printf(" �Ƿ�����:%d [����Ϊ1,������Ϊ0]",Use10);
	print("--------------------------------------");
	
	//--------------���س���------------------------
	AddCar();
	
	//--------------���������Ϣ--------------------
	print(" ��ϵͳ׼������!");
	print(" ����:Cn_Shindo");
	print(" �����κ�Bug��������,�뷢�ʼ���cn.shindo@gmail.com");
	print(" ��л[ITC]RR_LXD�ṩͣ��������ͳ�������!");
	print(" ��лvvg�ṩ�뷨.");
	printf(" �汾:%d.%d", FirstVersion, SecondVersion);
	print("--------------------------------------\n");

	//--------------��ʾ�����ϵͳ����--------------------
	SendClientMessageToAll(COLOR_LIGHTBLUE, " ��������������ϵͳ,����/ch�鿴��ϵͳ����.");
	
	return 1;
}

public OnFilterScriptExit()
{
    //DestroyMenu(QuickBuy);
    DelCar();
	print("\n--------------------------------------");
	print(" ��ϵͳ�˳�,������ɾ��!");
	print(" ����:Cn_Shindo");
	print(" �����κ�Bug��������,�뷢�ʼ���cn.shindo@gmail.com");
	print(" ��л[ITC]RR_LXD�ṩͣ��������ͳ�������!");
	print(" ��лvvg�ṩ�뷨.");
	printf(" �汾:%d.%d", FirstVersion, SecondVersion);
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid,COLOR_LIGHTBLUE, " ��������������ϵͳ,����/ch�鿴��ϵͳ����.");
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
	
    //-------------------��ϵͳ����----------------------------
	if (strcmp("/ch", cmdtext, true, 10) == 0 || strcmp("/chehelp", cmdtext, true, 10) == 0 || strcmp("/carhelp", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," ��ϵͳ����:");
		SendClientMessage(playerid,COLOR_YELLOW," /car /che - ͣ�����б�");
		SendClientMessage(playerid,COLOR_YELLOW," /vabout - ������ϵͳ");
		//SendClientMessage(playerid,COLOR_YELLOW," /vgo - ���͵�����һ�����Ա�");
		format(str,sizeof(str)," ÿ���򳵶�Ҫ�۷�$%d.", BuyCarFee);
		SendClientMessage(playerid,COLOR_QGREEN,str);
		//format(str,sizeof(str)," ÿ������Ҫ�ȴ�%d�봫�͵������.", CountDown);
		//SendClientMessage(playerid,COLOR_QGREEN," ʹ��/vgo������ȫ���!");
		//format(str,sizeof(str)," ����������˿����򳵹���,������ȴ�%d�복���͵������,��Ҫ�۷�$%d.", CountDown,QuickBuyFee);
		//SendClientMessage(playerid,COLOR_QGREEN,str);
		format(str,sizeof(str)," ����ˢ�¼��Ϊ%d��.", CarRefreshTime);
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
			SendClientMessage(playerid,COLOR_GREEN," ����ʧ��,������.");
 		} else {
 			GetVehiclePos(vehicleid,GX[playerid],GY[playerid],GZ[playerid]);
			SetPlayerPos(playerid,GX[playerid],GY[playerid],GZ[playerid]+2);
 			format(str,sizeof(str)," ���Ѵ��͵�һ�����Ա�(����ID:%d,ģ��ID:%d,��������:%s)",vehicleid,GetVehicleModel(vehicleid),GetVehicleName(vehicleid));
 			SendClientMessage(playerid,COLOR_GREEN,str);
 			vehicleid = 0;
 		}
		return 1;
	}*/
	
	//------------------������ϵͳ-----------------------------
	if (IsPlayerAdmin(playerid))
	{

	    //---------------����Ա����--------------------------
		if (strcmp("/vadmin", cmdtext, true, 10) == 0)
		{
		    SendClientMessage(playerid,COLOR_GREEN," ������ϵͳ:");
		    SendClientMessage(playerid,COLOR_YELLOW," /vinfo - ϵͳ������Ϣ.");
		    SendClientMessage(playerid,COLOR_YELLOW," /vcm - �����򳵷���.");
		    //SendClientMessage(playerid,COLOR_YELLOW," /vqm - ���Ŀ����򳵷���.");
		    SendClientMessage(playerid,COLOR_YELLOW," /vct - ���ĳ���ˢ�¼��.");
		    //SendClientMessage(playerid,COLOR_YELLOW," /vcwt - ���ĳ������͵������߼��.");
			return 1;
		}

		//---------------ϵͳ������Ϣ--------------------------
		if (strcmp("/vinfo", cmdtext, true, 10) == 0)
		{
		    new str[256];
		    SendClientMessage(playerid,COLOR_GREEN," ϵͳ������Ϣ:");
		    format(str,sizeof(str)," �򳵷��� = $%d", BuyCarFee);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    format(str,sizeof(str)," ͣ�������� = %d", CarStopInteriorId);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    format(str,sizeof(str)," ����ˢ�¼�� = %d��", CarRefreshTime);
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    SendClientMessage(playerid,COLOR_YELLOW," ͣ�������� = 10");
		    format(str,sizeof(str)," ͣ������������ = %d", GetParkInUse());
		    SendClientMessage(playerid,COLOR_YELLOW, str);
		    return 1;
		}

		//---------------�����򳵷���--------------------------
		if(strcmp(cmd, "/vcm", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
   				SendClientMessage(playerid, COLOR_GREEN, " �����򳵷���:");
				SendClientMessage(playerid, COLOR_QGREEN, " �÷�: /vcm [���]");
				SendClientMessage(playerid, COLOR_QGREEN, " ˵��: �����򳵷���.");
				return 1;
			}
			new NewBuyCarFee = strval(tmp);
			if (NewBuyCarFee >= 0)
			{
				BuyCarFee = NewBuyCarFee;
				format(str,sizeof(str)," �򳵷��ø��ĳɹ�,�·���Ϊ$%d.", BuyCarFee);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " �򳵷��ò��ܵ���$0!");
		    return 1;
		}
		
		/* //---------------���Ŀ����򳵷���--------------------------
		if (strcmp("/vqm", cmdtext, true, 10) == 0)
		{
			new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_GREEN, " ���Ŀ����򳵷���:");
				SendClientMessage(playerid, COLOR_QGREEN, " �÷�: /vqm [���]");
				SendClientMessage(playerid, COLOR_QGREEN, " ˵��: ���Ŀ����򳵷���.");
				return 1;
			}
			new NewQuickBuyFee = strval(tmp);
			if (NewQuickBuyFee >= 0)
			{
				QuickBuyFee = NewQuickBuyFee;
				format(str,sizeof(str)," �����򳵷��ø��ĳɹ�,�·���Ϊ$%d..", QuickBuyFee);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " �����򳵷��ò��ܵ���$0!");
		    return 1;
		} */

		/* //---------------���ĳ������͵������߼��--------------------------
		if(strcmp(cmd, "/vcwt", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
   				SendClientMessage(playerid, COLOR_GREEN, " ���ĳ������͵������߼��:");
				SendClientMessage(playerid, COLOR_QGREEN, " �÷�: /vcwt [ʱ��]");
				SendClientMessage(playerid, COLOR_QGREEN, " ˵��: ���ĳ������͵������߼��,��λ:��.");
				return 1;
			}
			new NewCount = strval(tmp);
			if (NewCount >= 0)
			{
				CountDown = NewCount;
				format(str,sizeof(str)," �������͵������߼�����ĳɹ�,��ʱ��Ϊ$%d.", CountDown);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " �������͵������߼���������0��!");
		    return 1;
		}*/

		//---------------���ĳ���ˢ��ʱ��--------------------------
		if(strcmp(cmd, "/vct", true) == 0)
		{
		    new str[256];
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_GREEN, " ���ĳ���ˢ��ʱ��:");
				SendClientMessage(playerid, COLOR_QGREEN, " �÷�: /vcct [ʱ��]");
				SendClientMessage(playerid, COLOR_QGREEN, " ˵��: ���ĳ���ˢ��ʱ��(��λΪ��).");
				return 1;
			}
			new NewCarRefreshTime = strval(tmp);
			if (NewCarRefreshTime > 0)
			{
				CarRefreshTime = NewCarRefreshTime;
				DelCar();
				AddCar();
				format(str,sizeof(str)," ����ˢ��ʱ����ĳɹ�,�¼��Ϊ%d��.", CarRefreshTime);
				SendClientMessage(playerid, COLOR_QGREEN, str);
			}
			else SendClientMessage(playerid, COLOR_GREEN, " ����ˢ��ʱ��������0��!");
		    return 1;
		}
	}
	
	//------------------������ϵͳ-----------------------------
	if (strcmp("/vabout", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," ������ϵͳ:");
		SendClientMessage(playerid,COLOR_YELLOW," ����:Cn_Shindo");
		SendClientMessage(playerid,COLOR_YELLOW," ����&ͣ��������:[ITC]RR_LXD");
		SendClientMessage(playerid,COLOR_YELLOW," �߻�:vvg");
		format(str,sizeof(str)," �汾:%d.%d", FirstVersion, SecondVersion);
		SendClientMessage(playerid,COLOR_YELLOW,str);
		return 1;
	}

	//-------------------ͣ�����б�------------------------------
	if (strcmp("/carpark", cmdtext, true, 10) == 0 || strcmp("/tingchechang", cmdtext, true, 10) == 0 || strcmp("/cp", cmdtext, true, 10) == 0 || strcmp("/tcc", cmdtext, true, 10) == 0 || strcmp("/tingche", cmdtext, true, 10) == 0)
	{
	    new str[256];
		SendClientMessage(playerid,COLOR_GREEN," ͣ�����б�:");
		format(str,sizeof(str)," 1��ͣ����:/inf �Ƿ���:%d ����:Infernus     | 2��ͣ����:/bul �Ƿ���:%d ����:Bullet", Use1, Use2);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 3��ͣ����:/tur �Ƿ���:%d ����:Turismo    | 4��ͣ����:/nrg �Ƿ���:%d ����:NRG500", Use3, Use4);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 5��ͣ����:/sul �Ƿ���:%d ����:Sultan        | 6��ͣ����:/vor �Ƿ���:%d ����:Vortex", Use5, Use6);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 7��ͣ����:/ele �Ƿ���:%d ����:Elegy          | 8��ͣ����:/mnb �Ƿ���:%d ����:Mountain Bike", Use7, Use8);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		format(str,sizeof(str)," 9��ͣ����:/mon �Ƿ���:%d ����:Monster | 10��ͣ����:/hot �Ƿ���:%d ����:Hotring", Use9, Use10);
		SendClientMessage(playerid,COLOR_YELLOW, str);
		SendClientMessage(playerid,COLOR_QGREEN, " �Ƿ����е�ֵΪ1����,Ϊ0��ر�.");
		return 1;
	}
	
	//-------------------ͣ����1�����----------------------------
	if (strcmp("/411", cmdtext, true, 10) == 0 || strcmp("/inf", cmdtext, true, 10) == 0) //ͣ����1������
	{
	    new str[256];
		if (Use1 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����1��ͣ����,����:Infernus.");
                		format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����2�����----------------------------
	if (strcmp("/541", cmdtext, true, 10) == 0 || strcmp("/bul", cmdtext, true, 10) == 0) //ͣ����2������
	{
	    new str[256];
		if (Use2 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����2��ͣ����,����:Bullet.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����3�����----------------------------
	if (strcmp("/451", cmdtext, true, 10) == 0 || strcmp("/tur", cmdtext, true, 10) == 0) //ͣ����3������
	{
	    new str[256];
		if (Use3 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����3��ͣ����,����:Turismo.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����4�����----------------------------
	if (strcmp("/522", cmdtext, true, 10) == 0 || strcmp("/nrg", cmdtext, true, 10) == 0) //ͣ����4������
	{
	    new str[256];
		if (Use4 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����4��ͣ����,����:NRG500.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����5�����----------------------------
	if (strcmp("/560", cmdtext, true, 10) == 0 || strcmp("/sul", cmdtext, true, 10) == 0) //ͣ����5������
	{
	    new str[256];
		if (Use5 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����5��ͣ����,����:Sultan.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����6�����----------------------------
	if (strcmp("/539", cmdtext, true, 10) == 0 || strcmp("/vor", cmdtext, true, 10) == 0) //ͣ����6������
	{
	    new str[256];
		if (Use6 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����6��ͣ����,����:Vortex.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����7�����----------------------------
	if (strcmp("/562", cmdtext, true, 10) == 0 || strcmp("/ele", cmdtext, true, 10) == 0) //ͣ����7������
	{
	    new str[256];
		if (Use7 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����7��ͣ����,����:Elegy.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
					    SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����8�����----------------------------
	if (strcmp("/510", cmdtext, true, 10) == 0 || strcmp("/mnb", cmdtext, true, 10) == 0) //ͣ����8������
	{
	    new str[256];
		if (Use8 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����8��ͣ����,����:Mountain Bike.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����9�����----------------------------
	if (strcmp("/557", cmdtext, true, 10) == 0 || strcmp("/mon", cmdtext, true, 10) == 0) //ͣ����9������
	{
	    new str[256];
		if (Use9 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����9��ͣ����,����:Monster.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
		}
		return 1;
	}
	
	//-------------------ͣ����10�����----------------------------
	if (strcmp("/494", cmdtext, true, 10) == 0 || strcmp("/hot", cmdtext, true, 10) == 0) //ͣ����10������
	{
	    new str[256];
		if (Use10 == 1)
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
		    	SendClientMessage(playerid,COLOR_GREEN," �Ǻ�,���Ѿ��ڳ�����,����?");
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
                		SendClientMessage(playerid,COLOR_QGREEN, " ��ӭ����10��ͣ����,����:Hotring.");
						format(str,sizeof(str)," ���û�г���,��ȴ�%d��ĳ���ˢ��,��������/vout�뿪ͣ����.", CarRefreshTime);
						SendClientMessage(playerid,COLOR_QGREEN, str);
					} else {
			    		SendClientMessage(playerid,COLOR_GREEN, " �Ǻ�,Ǯ����������?");
					}
			}
		} else {
		    SendClientMessage(playerid,COLOR_GREEN," ��ͣ����δ����!");
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
			SendClientMessage(playerid,COLOR_QGREEN, " ���Ѿ��뿪ͣ������.");
		} else {
		    SendClientMessage(playerid,COLOR_GREEN, " �㲻��ͣ����,��ô�뿪ͣ������?");
		}
  		return 1;
		}

	if (PlayerInCarStop[playerid] == 1)
	{
		SendClientMessage(playerid,COLOR_GREEN, " �����공��������������.");
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
			format(str,sizeof(str)," �򳵳ɹ�,�۷�$%d", BuyCarFee);
			SendClientMessage(playerid,COLOR_QGREEN, str);
			VX[playerid] = 0;
			VY[playerid] = 0;
			VZ[playerid] = 0;
			//if (IsPlayerQuickBuy[playerid] == 0)
			//{
			//format(str,sizeof(str)," ��ȴ��������͵������(%d��).", CountDown);
			//SendClientMessage(playerid,COLOR_GREEN, str);
				//format(str,sizeof(str)," ����δ���ÿ����򳵹���,���øù�������ȴ�%d��(/vqb)", CountDown);
				//SendClientMessage(playerid,COLOR_GREEN, str);
				//ObjPre(playerid,GetPlayerVehicleID(playerid));
			//} else if(IsPlayerQuickBuy[playerid] == 1)
			//{
                //SendClientMessage(playerid,COLOR_GREEN, " �������˿����򳵹���,�������ϴ��͵������.");
                //GameTextForPlayer(playerid,"~g~Car ~y~Is~b~ Here", 5000, 6);
                //LinkVehicleToInterior(GetPlayerVehicleID(playerid),PlayerInteriorId[playerid]);
                //SetVehiclePos(GetPlayerVehicleID(playerid),VX[playerid],VY[playerid],VZ[playerid]);
                //GivePlayerMoney(playerid, -BuyCarFee);
                //GivePlayerMoney(playerid, -QuickBuyFee);
                //format(str,sizeof(str)," �򳵳ɹ�,�۷�$%d(���տ����򳵷���$%d)", BuyCarFee,QuickBuyFee);
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
	format(str,sizeof(str)," �򳵳ɹ�,�۷�$%d", BuyCarFee);
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
