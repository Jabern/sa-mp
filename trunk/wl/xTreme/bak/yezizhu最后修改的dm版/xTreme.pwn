//=============[Includes]===============
#include       <a_samp>
#include       <Sinclude>
#include       <dudb>
#pragma tabsize 0 // (Un)Mark this if you want PAWNO to ignore/recognize indentation.
#pragma unused ret_memcpy
//=============[DEFINES]================
//colors
forward Menu_DestroyVehicle(playerid);
forward Sync_pScore();
//#define MAX_STRING                (128)
new const bool:FALSE=false;
new	const bool:TRUE=true;

#define SendFormatMessage(%1,%2,%3,%4)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%3),%4);SendClientMessage((%1),(%2),sendfstring);}while(FALSE)
stock SendFormatMessage(playerid,color,const sendfstring[]){
	SendClientMessage(playerid,color,sendfstring);
	return TRUE;
}

#define SendFormatMessageToAll(%1,%2,%3)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessageToAll((%1),sendfstring);}while(FALSE)
stock SendFormatMessageToAll(color,const sendfstring[]){
	SendClientMessageToAll(color,sendfstring);
	return TRUE;
}



#define COLOR_SYSTEM              0xEFEFF7AA
#define COLOR_BLUE                0x0000FFAA
#define COLOR_GREY                0xAFAFAFAA
#define COLOR_GREEN               0x33AA33AA
#define COLOR_YELLOW              0xFFFF00AA
#define COLOR_WHITE               0xFFFFFFAA
#define COLOR_PURPLE              0x9900FFAA
#define COLOR_BROWN               0x993300AA
#define COLOR_ORANGE              0xFF9933AA
#define COLOR_CYAN                0x99FFFFAA
#define COLOR_TAN                 0xFFFFCCAA
#define COLOR_PINK                0xFF66FFAA
#define COLOR_KHAKI               0x999900AA
#define COLOR_LIME                0x99FF00AA
#define COLOR_BLACK               0x000000AA
#define COLOR_TURQ                0x00A3C0AA
#define COLOR_LIGHTBLUE           0x00BFFFAA
#define COLOR_GREENISHGOLD        0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN      0x0FFDD349
#define COLOR_NEUTRALBLUE         0xABCDEF01
#define COLOR_LIGHTCYAN           0xAAFFCC33
#define COLOR_LEMON               0xDDDD2357
#define COLOR_AQUA                0x7CFC00AA
#define COLOR_WHITEYELLOW         0xFFE87DAA
#define COLOR_BLUEAQUA            0x7E60FFAA
#define COLOR_DBLUE               0x2641FEAA
#define COLOR_GREENYELLOWWHITE    0xCBFF45AA
#define COLOR_DARKBLUE            0x15005EAA
#define COLOR_RED                 0xAA3333AA
#define COLOR_ULTRARED            0xFF0606FF
#define COLOR_WARNING             0xFB0000FF
#define COLOR_VIOLET              0xFFFF6FFF
#define COLOR_HD                  0xFF0000FF
#define COLOR_BD                  0xFFFF00FF
#define COLOR_FT                  0x00BFFFAA

//Others
#define ACOLOR1                   0
#define ACOLOR2                   3
#define VEHI_SELECT               true
#define VEHI_SEL_STAT             2
#define COLOR_NONE                0x00000000
#define MAX_ACTIVE_MODELS         65
#define KEY_EXIT_VEHICLE	      16
#define RC_BANDIT                 441
#define RC_BARON                  464
#define RC_GOBLIN                 501
#define RC_RAIDER                 465
#define D_TRAM                    449
#define RC_TANK                   564
#define RC_CAM                    594
#define time1                     1000000*60 //this is 60s the 1 minute minimum gap time
#define time2                     1 // this is the 0.001 smax addon time
#define Driver                    0
#define Passanger                 2
#define GIVECASH_DELAY            5000 // Time in ms between /givemoney commands.
#define MAX_GANGS 			      32
#define MAX_GANG_MEMBERS	      50
#define MAX_GANG_NAME             16
#define FORBIDDENNAMES            23





#define dcmd(%1,%2,%3)            if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1







#define DM_NONE 0
#define DM_TANK 1
#define DM_DILDO 2
#define DM_SMG 3
#define DM_RING 4 
#define DM_BOX 5
#define DM_AK 6 
#define DM_TENNIS 7
#define DM_SNIPER 8 
#define DM_FARM 9 
#define DM_TOWN 10
#define DM_KATANA 11 
#define DM_ROCKET 12
#define DM_BEACH 13

stock DM_pPlayeing(playerid){
	return CallRemoteFunction("_DM_pPlaying","i",playerid);
}

new pDMPosition[MAX_PLAYERS];
new Float:TankSpawn[6][3]={
	{2898.8169,1191.3827,14.7920},
	{2871.2649,1127.4198,10.8984},
	{2879.4031,1084.2681,10.8984},
	{2807.6021,1057.3262,11.3822},
	{2742.2949,1038.8385,10.0888},
	{2746.6272,1077.3306,9.3730}
};
new Float:BeachSpawn[9][3]={
	{188.8920,-1820.3704,9.5812},
	{174.3068,-1820.4084,9.5812},
	{181.2758,-1847.7517,11.3934},
	{170.6266,-1871.8796,6.0702},
	{200.6462,-1873.0670,6.2773},
	{195.5655,-1838.2958,6.2480},
	{206.8016,-1834.9736,23.8591},
	{209.3127,-1841.9830,3.7733},
	{214.8515,-1836.8142,3.7733}
};

new Float:DildoSpawn[6][3]={
	{-296.2812,2353.5630,111.8781},
	{-253.2802,2395.7151,109.4530},
	{-236.3325,2344.9761,109.3460},
	{-257.4752,2300.9011,111.0198},
	{-256.5311,2242.4114,109.5284},
	{-283.2921,2158.4519,112.8597}
};

new Float:SmgSpawn[4][3]={
	{411.0656,2457.7861,16.5000},
	{403.4297,2450.9331,16.5000},
	{397.5336,2456.8210,16.5000},
	{404.4581,2462.7363,16.5000}
};

new Float:RingSpawn[12][3]={
	{-1375.1572,81.3671,1030.8583},
	{-1425.6069,81.3748,1031.0248},
	{-1425.5117,130.3406,1030.8612},
	{-1377.1482,131.6383,1030.8396},
	{-1389.7239,120.2507,1033.6550},
	{-1391.8505,92.0921,1032.2576},
	{-1417.0343,89.5161,1032.4113},
	{-1404.2382,103.9564,1028.3153},
	{-1397.7993,103.2550,1028.9082},
	{-1396.8927,110.5163,1029.0212},
	{-1406.5074,110.5755,1029.1345},
	{-1401.5345,107.3403,1032.2734}
};

new Float:BoxSpawn[6][3]={
	{-1134.6344,1095.8658,1345.8103},
	{-1130.5745,1057.8763,1346.4141},
	{-1132.5066,1029.0795,1345.7352},
	{-973.2579,1023.6563,1345.0514},
	{-973.9857,1061.0121,1345.6749},
	{-975.8455,1090.0555,1344.9695}
};

new Float:AKSpawn[6][3]={
	{2837.3955,-2530.0833,17.9315},
	{2838.3994,-2446.8374,19.9220},
	{2841.5725,-2366.0278,31.0039},
	{2837.5439,-2333.4243,12.0445},
	{2841.5322,-2487.8589,12.0939},
	{2839.6719,-2407.7000,12.0820}
};

new Float:TennisSpawn[9][3]={
	{1165.4285,1350.9569,14.5703},
	{1172.2274,1226.3521,10.8125},
	{1153.5819,1210.6592,10.8203},
	{1113.4912,1206.9467,10.8203},
	{1128.2482,1238.5885,10.8203},
	{1134.2065,1268.2513,10.8203},
	{1135.7072,1279.0529,10.8203},
	{1142.5901,1285.3944,10.8203},
	{1149.9984,1242.6460,10.8203}
};

new Float:SniperSpawn[5][3]={
	{2632.5264,2832.3577,127.5781},
	{2593.4360,2638.2803,114.0313},
	{2718.2527,2773.7805,77.3594},
	{2506.2986,2690.6221,77.8438},
	{2618.1941,2720.9871,36.5386}
};

new Float:FarmSpawn[10][3]={
	{1070.2064,-366.2670,73.9922},
	{1098.8563,-361.2262,73.9922},
	{1107.6542,-357.6500,76.8047},
	{1100.3849,-356.9119,78.8672},
	{1081.6755,-345.3865,74.7047},
	{1069.8237,-345.1387,73.9922},
	{1051.6864,-288.3278,73.9931},
	{1041.0513,-287.5736,73.9931},
	{1040.1722,-310.2809,73.9931},
	{1048.8325,-313.6826,73.9931}
};

new Float:TownSpawn[9][3]={
	{1324.6998,286.3105,20.0452},
	{1326.6914,292.5583,20.0452},
	{1347.9879,288.3841,19.5615},
	{1342.5603,278.4607,19.5615},
	{1329.4904,249.6020,19.5615},
	{1328.2214,266.4492,25.5507},
	{1308.8549,272.7297,19.5547},
	{1301.1141,256.9669,19.5547},
	{1318.9702,292.2422,19.5547}
};
new Float:RocketSpawn[7][3]={
	{-780.8633,2097.0891,75.5084},
	{-781.3229,2140.3694,75.6247},
	{-651.2750,2145.8420,75.6496},
	{-651.3060,2102.4539,75.5843},
	{-606.7103,1923.9940,112.4918},
	{-796.8158,2257.8013,58.9766},
	{-806.7089,2257.2471,70.1676}
};
new Float:KatanaSpawn[5][3]={
	
	{1587.8431,2385.3740,22.8204},
	{1586.3121,2397.0823,22.8204},
	{1598.1488,2386.1401,22.8204},
	{1609.6450,2396.9197,22.8204},
	{1621.1388,2388.4104,22.8204}
};
	

new IllegalNames[FORBIDDENNAMES][] =
{
   "com1", "com2", "com3", "com4", "com5", "com6", "com7", "com8", "com9",
   "lpt1", "lpt2", "lpt3", "lpt4", "lpt5", "lpt6", "lpt7", "lpt8", "lpt9",
   "nul", "clock$", "aux", "prn", "con"
};

/*Float:GetRampDistance(playerid)
{
	new ping = GetPlayerPing(playerid), Float:dist;
	dist = floatpower(ping, 0.25);
	dist = dist*4.0;
	dist = dist+5.0;
	return dist;
}*/

/*Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	else GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}*/

forward AutoRepair(playerid);
forward CountDown();
forward Update(playerid);
forward MoneyUpdate(playerid);
forward StopPMTimer(playerid);
forward PlayingTime();
forward WarningMessages();
forward TipMessages();
forward FunMessages();
forward AddObjects();
forward AddMenus();
forward AddSkins();
//forward AddPickups();
forward AddOthers();
forward ReactionTest();
forward ReactionWin(playerid);
forward SetBack();
forward SetRandomWeather();
//forward SetPlayerDMSpawn4(playerid); //Sniper  DM
//forward SetPlayerDMSpawn2(playerid); // Rocket DM
//forward SetPlayerDMSpawn5(playerid); // Katana DM
//forward SetPlayerDMSpawn(playerid); //Dildo DM
///forward SetPlayerDMSpawn8(playerid); //Tank  DM
//forward SetPlayerDMSpawn7(playerid); //Tennis  DM
//forward SetPlayerDMSpawn6(playerid); //AK47 DM
//forward SetPlayerDMSpawn3(playerid); //SMG DM
//forward TuneCar();
forward PlayerLeaveGang(playerid);
forward CheckName(playerid);
//forward DeleteRamp(playerid);
//forward Float:GetRampDistance(playerid);
//forward Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);
//forward Keys();
forward DynUpdateStart(playerid); // freezes a player for some seconds
forward DynUpdateEnd(playerid); // unfreeze function

//Menus
//new Menu:vmenu;
//new Menu:TunedVehicles;

//Others
enum CURVEHICLE
{
    bool:spawn,
	vmodel,
	vInt
};
new WarningRandMessages[][] =
{
	"[注意] [XK_F]911 傻到作弊杀人被GM抓住 [13/01/09 | 17:04:38]",
	"[注意] 请不要安装不熟悉的MOD,这可能会导致不能玩SA-MP",
	"[注意] 服务器允许使用辅助软件，但是请不要使用他来杀人或者打扰别人",
	"[注意] 偷车是允许的,所以请不要抱怨!",
	"[注意] 请不要做一个让人讨厌的玩家! 这将导致被GM禁止进入服务器!",
	"[注意] 请尽量找合适的位置停车",
	"[注意] 请不要在游戏中出现自大猖狂情况,很2!",
	"[注意] 请不要在DM之外的地点杀戳,尤其是特技区域",
	"[注意] GM处事原则就是玩家行为是否影响其他玩家",
	"[注意] 比赛都是自动启用的,所以请勿询问管理员及其玩家!",
	"[注意] 只会用外挂锁血/杀人/刷枪的MJJ!!!真没技术含量╭∩╮（︶︿︶）╭∩╮",
	"[注意] 加入QQ群与其他玩家交流,群号是:22288828 此号码是真的一。一!!!",
	"[注意] GM不在线,被外挂玩家恶意打扰怎么办?也装个外挂吧 o(∩_∩)o...哈哈！！！",
	"[注意] 传送的时候如果不在交通工具里，就可以预载入OBJ!",
	"[注意] 打架时考虑ping的存在,往敌人运动前方开枪命中率就大大增加",
	"[注意] GM滥用职权?请抓图发送到sa-mp@qq.com投诉",
	"[注意] 承认自己是男人的就别在PK/DM的时候锁血/刷武器/杀队友!"
};

new TipRandMessages[][] =
{
    "[广播] 记住/help /bangzhu命令能解决所有难题",
    "[广播] 周围没有车时试试这些命令吧 /v /vv /car /che /tur /inf",
    "[广播] 碰到危险时,再也不用跳车了,因为服务器里面的车会自动修复",
	//"[广播] 跳板默认是关闭的,使用 /rampon 开启 /rampoff 关闭",
	"[广播] 需要传送的话,就试试 /t /tele /teles /chuansong /shunyi",
	"[广播] 试试更短的自杀命令吧 /k 换人用 /h",
	"[广播] 还在用f4 /kill换角色吗?落伍啦!!试试/skinme /skins /huanren /huanfu",
	"[广播] 给我一个降落伞吧 /jls /para 跳伞到 /dive /BASEJUMP [1-9] /ts [1-9]",
	"[广播] 车技不错 来玩玩 /bj [1-14] /goingdown /drop /uj ...更多见/tele 传送命令",
	"[广播] /lvyou /ly 旅游命令列表",
	"[广播] 我的车破破烂烂,怎么办? /fullfix /xiuche",
	"[广播] 使用外挂绝对不能做的:DM 杀人/锁血,特技赛车 撞人/抢车,刷夜视镜/飞行器",
	"[广播] 翻车了?不着急,试试 /f",
	"[广播] /s /l 保存 读取真是好命令啊!",
	"[广播] 作弊玩家不可怕,就怕流氓有文化.有点文化也没啥,骂完之后道歉撒"
};

new FunRandMessages[][] =
{
	"[学习] 笑古笑今笑东笑西笑来笑去笑自己原无知无识",
	"[学习] 小胜凭智，大胜凭德。",
	"[学习] 勇敢并非心中没有恐惧，而是战胜了恐惧。",
	"[学习] 要想把握现在，就得了解过去。",
	"[学习] 每个人都可以为和平撑起一片天空。",
	"[学习] 这只是一个游戏，但我会尽我最大的努力。",
	"[学习] 胜利不是全部；但它是唯一的结果。",
	"[学习] 要享受幸福的时间是“现在”，要享受幸福的地方在“这里”。",
    "[学习] 人生的伟大目标，不是知识而是行动。",
    "[学习] 健康是最重要的财产，朋友是第二个财富。兄弟是上天赐予的好朋友。",
    "[学习] 不要跟别人比较生活，而是要享受自己的生活。",
	"[学习] 为了多了解，一定要多读书。",
	"[学习] 年轻时忽略学习的人，会丧失过去，也没有未来。",
	"[学习] 人绝对不是自己想象中的，那么幸福或者那么不幸。",
	"[学习] 话多与很会讲话是两回事。",
	"[学习] 一个失去诚实的人，再没有可以失去的东西了。",
	"[学习] 尊敬父母的孝行很容易做到，但是爱父母的孝行却很困难。",
	"[学习] 快乐的人创造快乐的世界。",
	"[学习] 人生的目的是要不断的往前迈进。",
	"[学习] 登高必自卑。",
	"[学习] 往者不追，来者不拒。",
	"[学习] 无心则视若无睹，充耳未闻。 ",
	"[学习] 责人不如责己",
	"[学习] 知则知，不知则不知，是说话的根本。",
	"[学习] 没有财产的人，没有心机。",
	"[学习] 两个人一起合作 ，比分散的十个人好。",
	"[学习] 友情之花要细心呵护。",
	"[学习] 不要嘲笑别人，谁能保证自己能永远幸福。"
};


enum weather_info
{
	randomweather_id,
	randomweather_text[255]
};

//Random Spawns
enum espawn
{
	Float:ex,
	Float:ey,
	Float:ez,
	interior,
	emsg[128]
}

new spawns[][espawn] = {
	//Syntax: {x, y, z, interior, message}
	{409.2281,2573.1426,16.3672, 0, ">> 出生在 /aa 大型特技场"},
	//{-1027.9192,468.8041,14.5469, 0, ">> 出生在 /carsumo 碰碰车 ,输入 /che /car /feiji 召唤交通工具"},
	//{1884.2949,-1463.4733,192.9261, 0, ">> 出生在 /zhanjian 未来战舰,输入 /che /car /feiji 召唤交通工具"},
	//{-2261.1379,2290.6130,4.8202, 0, ">> 出生在 /navy 大型特技场"},
	//{5676.9941,-4618.9248,-15.2854, 10, ">> 出生在 /hdcs 海底城市废墟,输入 /che /car /feiji 召唤交通工具"}
	//{-973.5212,1074.4470,1344.9958, 10, ">> 出生在 /smgdm 离开这里请输入/outdm"}
	{1384.4961,-2442.0063,13.5547, 0, ">> 出生在 /ls"},
	{1318.9706,1266.0952,10.8203, 0, ">> 出生在 /lv"},
	{-1642.7762,-197.9458,14.1484, 0, ">> 出生在 /sf"},
	{1465.8499,2864.9333,10.8247, 0, ">> 出生在 /旅游"},
	{2874.8264,-768.6284,10.8359, 0, ">> 出生在 /nrgocm"}
};

////////////////////////
new gangMembers[MAX_GANGS][MAX_GANG_MEMBERS];
new gangNames[MAX_GANGS][MAX_GANG_NAME];
new gangInfo[MAX_GANGS][3]; //0-created,1-members,2-color
new playerGang[MAX_PLAYERS];
new gangInvite[MAX_PLAYERS];
///////////////////////
//new ramped[MAX_PLAYERS];
//new noramp[MAX_PLAYERS];
//new jumped[MAX_PLAYERS] = {-1, ...};
//new Pressedkey[MAX_PLAYERS] = {false, ...};
new Text:lbt;
new Text:lbb;
new bounty[MAX_PLAYERS];
new Connects[MAX_PLAYERS];
new Disconnects[MAX_PLAYERS];
new Crashs[MAX_PLAYERS];
new Kicks[MAX_PLAYERS];
new Spawns[MAX_PLAYERS];
new Deaths[MAX_PLAYERS];
new Kills[MAX_PLAYERS];
new SendedMess[MAX_PLAYERS];
new SendedPM[MAX_PLAYERS];
new UsedCMD[MAX_PLAYERS];
new VehicleEnters[MAX_PLAYERS];
new VehicleExits[MAX_PLAYERS];
new VehicleDestroys[MAX_PLAYERS];
new PickUpedPickups[MAX_PLAYERS];
new StateChanges[MAX_PLAYERS];
new PlayingMinutes[MAX_PLAYERS];
new PlayingHours[MAX_PLAYERS];
new ConnectTimer;
//new airport1para;
//new airport2para;
//new airport3para;
//new airport4para;
//new jump;
//new andrompara1;
//new andrompara2;
//new andrompara3;
//new andrompara4;
//new andrompara5;
//new andrompara6;
//new andrompara7;
//new andrompara8;
//new andrompara9;
//new andrompara10;
//new Sultan1;
//new Sultan2;
//new Elegy1;
//new Elegy2;
//new Uranus1;
//new Uranus2;
new reactionstr[9];
new reactioninprog;
new reactionwinnerid;
new bool:ReactionTest_;
//new reactiongap;
//new PlayerVehI[MAX_PLAYERS];
new Timers[MAX_PLAYERS];
enum SavePosENUM { Float:sX, Float:sY, Float:sZ, Float:sA, SavedPos };
new SavePos[MAX_PLAYERS][SavePosENUM];
new Count = 5;
//new Text:Textdraw0;
//new Text:Textdraw1;
new TDHS[MAX_PLAYERS];
new SBAD[MAX_PLAYERS];
new CountText[5][5]=
{
   "~r~1",
   "~y~2",
   "~b~3",
   "~g~4",
   "~p~5"
};

new VehicleNames[][] =
{
   "Landstalker","Bravura","Buffalo","Linerunner","Perrenial","Sentinel","Dumper",
   "Firetruck","Trashmaster","Stretch","Manana","Infernus","Voodoo","Pony","Mule",
   "Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington",
   "Bobcat","Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar",
   "Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon",
   "Coach","Cabbie","Stallion","Rumpo","RC Bandit","Romero","Packer","Monster",
   "Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
   "Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer",
   "PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic","Sanchez",
   "Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR-350",
   "Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer",
   "Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood","Jetmax",
   "Hotring","Sandking","Blista Compact","Police Maverick","Boxvillde","Benson",
   "Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger",
   "Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle",
   "Cropduster","Stunt","Tanker","Roadtrain","Nebula","Majestic","Buccaneer",
   "Shamal","Hydra","FCR-900","~r~N~y~R~b~G~w~-~p~500","HPV1000","Cement Truck",
   "Tow Truck","Fortune","Cadrona","FBI Truck","Willard","Forrklift", "Tractor",
   "Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex",
   "Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo",
   "Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor"
   ,"Monster","Monster","Uranus","Jester","Sultan","Stratum","Elegy","Raindance",
   "RC Tiger",   "Flash",   "Tahoma",   "Savanna",   "Bandito",   "Freight Flat",
   "Streak Carriage","Kart","Mower","Dune","Sweeper","Broadway","Tornado","AT-400",
   "DFT-30","Huntley","Stafford","BF-400","News Van","Tug","Trailer","Emperor",
   "Wayfarer","Euros","Hotdog","Club","Freight Box","Trailer","Andromada","Dodo",
   "RC Cam","Launch","Police Car","Police Car","Police Car","Police Ranger",
   "Picador","S.W.A.T","Alpha","Phoenix","Glendale","Sadler","Luggage","Luggage",
   "Stairs","Boxville","Tiller","Utility Trailer"
};

new RandomWeatherIDs[][weather_info] =
{
	{0,"Blue Sky"},
	{1,"Blue Sky 2"},
	{2,"Blue Sky 3"},
	{3,"Blue Sky 4"},
//	{4,"Blue Sky 5"},
//	{5,"Blue Sky 6"},
//	{6,"Blue Sky 7"},
	{9,"Blue Sky 8"},
	{10,"Blue Sky 9"},
//	{11,"Heatwave"},
	{17,"Heatwave 2"},
	{18,"Heatwave 3"},
//	{12,"Dull "},
	{13,"Dull 2"},
	{14,"Dull 3"},
	{15,"Dull 4"},
//	{16,"Dull & Rainy"},
//	{19,"Sandstorm"},
//	{20,"Smog"},
//	{23,"Pale Orange"},
//	{24,"Pale Orange 2"},
//	{25,"Pale Orange 3"},
//	{26,"Pale Orange 4"},
//	{27,"Fresh Blue "},
//	{28,"Fresh Blue 2"},
//	{29,"Fresh Blue 3"},
//	{30,"Smog"},
//	{31,"Smog 2"},
//	{32,"Smog 3"},
//	{33,"Dark 4"},
//	{35,"Dull Brown"},
	{36,"Bright & Foggy"},
//	{37,"Bright & Foggy 2"},
//	{38,"Bright & Foggy 3"},
	{39,"Very Bright"},
	{40,"Blue & Cloudy"}
//	{41,"Blue & Cloudy 2"},
//	{42,"Blue & Cloudy 3"},
//	{700,"Weed Effect"}
};

new playerColors[200] = {
0xFF8080FF,0xFFFF80FF,0x80FF80FF,0x00FF80FF,0x80FFFFFF,0xFF0080FF,0xFF80C0FF,0xFF80FFFF,0x80FF00FF,0x00FF40FF,0x00FFFFFF,
0x8080C0FF,0xFF00FFFF,0xFF8040FF,0x8080FFFF,0xC0C0C0FF,0x55D1EFFF,0x9AE12EFF,0x78BA91FF,0xE79D35FF,0xC17878FF,0xA87AADFF,
0xFF8080FF,0xFFFF80FF,0x80FF80FF,0x00FF80FF,0x80FFFFFF,0xFF0080FF,0xFF80C0FF,0xFF80FFFF,0x80FF00FF,0x00FF40FF,0x00FFFFFF,
0x8080C0FF,0xFF00FFFF,0xFF8040FF,0x8080FFFF,0xC0C0C0FF,0x55D1EFFF,0x9AE12EFF,0x78BA91FF,0xE79D35FF,0xC17878FF,0xA87AADFF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,0x4B8987FF,
0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,
0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,
0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,
0x9F945CFF,0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0x3FE65CFF,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,0xEE82EEFF,0xFFD720FF,
0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,
0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,
0x275222FF,0xF09F5BFF,0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,0x4B8987FF,
0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,
0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,
0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,
0x9F945CFF,0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0x3FE65CFF
};


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
main()
{
  print("[GM]> ..::[ Xtreme ]::.. Loaded!");

}

//------------------------------------------------------------------------------
public TipMessages()
{
        SendClientMessageToAll(COLOR_LIGHTBLUE, TipRandMessages[random(sizeof(TipRandMessages))]);
        return 1;
}
public WarningMessages()
{
        SendClientMessageToAll(COLOR_ULTRARED, WarningRandMessages[random(sizeof(WarningRandMessages))]);
        return 1;
}
public FunMessages()
{
        SendClientMessageToAll(COLOR_PURPLE, FunRandMessages[random(sizeof(FunRandMessages))]);
		return 1;
}
//------------------------------------------------------------------------------

stock sscanf(string[], format[], {Float,_}:...){
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs();
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if (ch >= '0' && ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return 1;
					}
				}
				while ((ch = string[stringPos]) && ch != ' ');
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					ch,
					num = 0;
				while ((ch = string[stringPos++]))
				{
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						case ' ':
						{
							break;
						}
						default:
						{
							return 1;
						}
					}
				}
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				new tmp[25];
				strmid(tmp, string, stringPos, stringPos+sizeof(tmp)-2);
				setarg(paramPos, 0, _:floatstr(tmp));
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != ' ')
					{
						setarg(paramPos, i++, ch);
					}
					if (!i) return 1;
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != ' ')
		{
			stringPos++;
		}
		while (string[stringPos] == ' ')
		{
			stringPos++;
		}
		paramPos++;
	}
	while (format[formatPos] == 'z') formatPos++;
	return format[formatPos];
}

dcmd_afk(playerid, params[]){
	TogglePlayerControllable(playerid, 0);
	new name[18], reason[MAX_STRING], string[MAX_STRING];
	reason = "";//reason not given
	sscanf(params, "s", reason);
	GetPlayerName(playerid,name,18);
	format(string, sizeof(string), "[暂停] %s(%d) 暂时离开 (原因: %s)", name, playerid, reason);
	SendClientMessageToAll(COLOR_YELLOW,string);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]){
	if(DM_pPlayeing(playerid)){
	    SendClientMessage(playerid,COLOR_YELLOW,"[DM]在DM里不允许使用任何命令");
	    return true;
	}
	dcmd(afk, 3, cmdtext);
	UsedCMD[playerid] += 1;
	new string[MAX_STRING];
    new cmd[MAX_STRING];
	new idx;
	new tmp[MAX_STRING];
	new giveplayerid, moneys;
	new playermoney;
	new giveplayer[MAX_PLAYER_NAME];
	new sendername[MAX_PLAYER_NAME];
	cmd = strtok(cmdtext, idx);
//------------------------------------------------------------------------------
if(!strcmp(cmdtext,"/help",true) || !strcmp(cmdtext, "/帮助",true))
{
	SendFormatMessage(playerid, COLOR_HD, "致谢");
	SendClientMessage(playerid, COLOR_BD, "    感谢: /3q /tks /thanks");
	SendFormatMessage(playerid, COLOR_HD, "帮助");
	SendClientMessage(playerid, COLOR_BD, "    SA-MP 帮助: /samp 命令帮助: /cmd");
	SendClientMessage(playerid, COLOR_BD, "    我的: /my 和GM联系: /gm");
	SendClientMessage(playerid, COLOR_BD, "    买车: /car 传送: /tele 跳伞: /tiaosan");
	SendClientMessage(playerid, COLOR_BD, "    旅游: /tiaosan 赛车: /race 特技: /stunt ");
	SendClientMessage(playerid, COLOR_BD, "    动作: /anim DM: /dm ");
	return 1;
}
//------------------------------------------------------------------------------
if(!strcmp(cmdtext,"/samp",true) || !strcmp(cmdtext,"/sa-mp",true))
{
	SendFormatMessage(playerid, COLOR_HD, "参数设置");
	SendClientMessage(playerid, COLOR_BD, "    /stuntbonus");
	SendFormatMessage(playerid, COLOR_HD, "新版下载");
	SendClientMessage(playerid, COLOR_BD, "    http://sa-mp.com.cn/client/");
//	SendFormatMessage(playerid, COLOR_HD, "/textdraw");
//	SendClientMessage(playerid, COLOR_BD, "    特效字.第一次执行关闭,第二次执行恢复.");
	SendFormatMessage(playerid, COLOR_HD, "/stuntbonus");
	SendClientMessage(playerid, COLOR_BD, "    特技奖励.同上.");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/commands", true) || !strcmp(cmdtext, "/cmds", true) || !strcmp(cmdtext, "/cmd", true) || !strcmp(cmdtext, "/命令", true) || !strcmp(cmdtext, "/帮助 命令", true))
{
	SendFormatMessage(playerid, COLOR_HD, "常用命令");
	SendFormatMessage(playerid, COLOR_BD, "    /jetpack /count /helpme /afk /back /me /sp /lp /lbon /lboff");
	SendFormatMessage(playerid, COLOR_HD, "/jetpack /fxq /feixingqi");
	SendClientMessage(playerid, COLOR_BD, "    召唤出飞行器.请不要配合 tec9 uzi 搭配使用哦");
	SendFormatMessage(playerid, COLOR_HD, "/count /djs /daojishi /daoshu /racecount");
	SendClientMessage(playerid, COLOR_BD, "    倒计时5秒.请不要用它持续刷屏哦");
	SendClientMessage(playerid, COLOR_FT, "← /help                → /help cmd 1 /帮助 命令 1");
	return 1;
}
if (!strcmp(cmdtext, "/help cmd 1", true) || !strcmp(cmdtext, "/帮助 命令 1", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/helpme");
	SendClientMessage(playerid, COLOR_BD, "    解决bug");
	SendFormatMessage(playerid, COLOR_HD, "/afk");
	SendClientMessage(playerid, COLOR_BD, "    暂时离开.使用后冻结行动,并无敌.使用/back恢复");
	SendFormatMessage(playerid, COLOR_HD, "/back /huilai");
	SendClientMessage(playerid, COLOR_BD, "    恢复正常状态并通知.和/afk配套使用");
	SendFormatMessage(playerid, COLOR_HD, "/me");
	SendClientMessage(playerid, COLOR_BD, "    自言自语");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /help cmd 2 /帮助 命令 2");
	return 1;
}
if (!strcmp(cmdtext, "/help cmd 2", true) || !strcmp(cmdtext, "/帮助 命令 2", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/sp /s");
	SendClientMessage(playerid, COLOR_BD, "    保存位置,使用/lp传送回来");
	SendFormatMessage(playerid, COLOR_HD, "/lp /l");
	SendClientMessage(playerid, COLOR_BD, "    和/sp配套使用");
	SendFormatMessage(playerid, COLOR_HD, "/lbon");
	SendClientMessage(playerid, COLOR_BD, "    开启上下黑幕");
	SendFormatMessage(playerid, COLOR_HD, "/lboff");
	SendClientMessage(playerid, COLOR_BD, "    关闭上下黑幕");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/gm", true) || !strcmp(cmdtext, "/管理员", true) || !strcmp(cmdtext, "/help gm", true) || !strcmp(cmdtext, "/帮助 管理员", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /gms /report");
	SendFormatMessage(playerid, COLOR_HD, "/gms /admins /guanliyuan");
	SendClientMessage(playerid, COLOR_BD, "    查看在线GM");
	SendFormatMessage(playerid, COLOR_HD, "/jubao /jb /report");
	SendClientMessage(playerid, COLOR_BD, "    像GM举报违规玩家");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/my", true) || !strcmp(cmdtext, "/控制面板", true) || !strcmp(cmdtext, "/帮助 控制面板", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /mystats /kill /givemoney /hitman /bounty /bounties");
	SendClientMessage(playerid, COLOR_BD, "    /class /skin /skins");
	SendFormatMessage(playerid, COLOR_HD, "/mystats /wode");
	SendClientMessage(playerid, COLOR_BD, "    显示上线期间的玩家数据清单");
	SendFormatMessage(playerid, COLOR_HD, "/kill /k");
	SendClientMessage(playerid, COLOR_BD, "    自杀");
	SendFormatMessage(playerid, COLOR_HD, "/givemoney /geiqian /songqian");
	SendClientMessage(playerid, COLOR_BD, "    给其他玩家金钱");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /my help 1 /帮助 控制面板 1");
	return 1;
}
if (!strcmp(cmdtext, "/my help 1", true) || !strcmp(cmdtext, "/帮助 控制面板 1", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/hitman /shashou /gandiao");
	SendClientMessage(playerid, COLOR_BD, "    悬赏缉杀");
	SendFormatMessage(playerid, COLOR_HD, "/bounty /shangjin /xuanshang");
	SendClientMessage(playerid, COLOR_BD, "    查询目标赏金");
	SendFormatMessage(playerid, COLOR_HD, "/bounties /shangjinbang /xuanshangbang");
	SendClientMessage(playerid, COLOR_BD, "    通缉赏金排行榜");
	SendFormatMessage(playerid, COLOR_HD, "/class /huanren");
	SendClientMessage(playerid, COLOR_BD, "    自杀式切换角色");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /my help 2 /帮助 控制面板 2");
	return 1;
}
if (!strcmp(cmdtext, "/my3", true) || !strcmp(cmdtext, "/帮助 控制面板 2", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/skin /skinme");
	SendClientMessage(playerid, COLOR_BD, "    扣钱指定id切换角色");
	SendFormatMessage(playerid, COLOR_HD, "/skins /huanfu");
	SendClientMessage(playerid, COLOR_BD, "    列表引导切换角色");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/parachute", true) || !strcmp(cmdtext, "/tiaosan", true) || !strcmp(cmdtext, "/跳伞", true) || !strcmp(cmdtext, "/帮助 跳伞", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /dive /basejump1 ~ /basejump9");
	SendFormatMessage(playerid, COLOR_HD, "/jls /para");
	SendClientMessage(playerid, COLOR_BD, "    随时随地获得降落伞");
	SendFormatMessage(playerid, COLOR_HD, "/dive /ydts");
	SendClientMessage(playerid, COLOR_BD, "    原地高空跳伞");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /help parachute 1 /帮助 跳伞 1");
	return 1;
}
if (!strcmp(cmdtext, "/help parachute 1", true) || !strcmp(cmdtext, "/帮助 跳伞 1", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/basejump 1 ~ /basejump 9 /ts 1 ~ /ts 9");
	SendClientMessage(playerid, COLOR_BD, "    高楼跳伞");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/race", true) || !strcmp(cmdtext, "/saiche", true) || !strcmp(cmdtext, "/赛车", true) || !strcmp(cmdtext, "/帮助 赛车", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /join /ready /idrace /thrace /nrgocm /drift1 ~ /drift5");
	SendFormatMessage(playerid, COLOR_HD, "/join");
	SendClientMessage(playerid, COLOR_BD, "    加入赛车");
	SendFormatMessage(playerid, COLOR_HD, "/ready");
	SendClientMessage(playerid, COLOR_BD, "    准备完毕.和/join配套使用");
	SendFormatMessage(playerid, COLOR_HD, "/idrace");
	SendClientMessage(playerid, COLOR_BD, "    赛车场");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /race help 1 /帮助 赛车 1");
	return 1;
}
if (!strcmp(cmdtext, "/race help 1", true) || !strcmp(cmdtext, "/帮助 赛车 1", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/thrace");
	SendClientMessage(playerid, COLOR_BD, "    赛车场");
	SendFormatMessage(playerid, COLOR_HD, "/nrgocm");
	SendClientMessage(playerid, COLOR_BD, "    摩托赛车场");
	SendFormatMessage(playerid, COLOR_HD, "/drift 1 ~ /drift 5 /piaoyi 1 ~ /piaoyi 5");
	SendClientMessage(playerid, COLOR_BD, "    飘移地点");
	SendFormatMessage(playerid, COLOR_HD, "/qiuming");
	SendClientMessage(playerid, COLOR_BD, "    秋名山MOD顶端");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/stunt", true) || !strcmp(cmdtext, "/teji", true) || !strcmp(cmdtext, "/特技", true) || !strcmp(cmdtext, "/帮助 特技", true))
{
	SendFormatMessage(playerid, COLOR_HD, "小型特技");
	SendClientMessage(playerid, COLOR_BD, "    /st1 ~ /st22 /drop1 ~ /drop4");
	SendFormatMessage(playerid, COLOR_HD, "超级跳跃");
	SendClientMessage(playerid, COLOR_BD, "    /bj 1 ~ /bj 14 /mj /mj2 /dj /uj /aj");
	SendFormatMessage(playerid, COLOR_HD, "大型特技");
	SendClientMessage(playerid, COLOR_BD, "    /aa /lsair /lvair /sfair /goingdown /drop /chilliad /grovest /navy /halfpipe /partyland");
	SendFormatMessage(playerid, COLOR_HD, "跑酷和2轮");
	SendClientMessage(playerid, COLOR_BD, "    /parkour1 ~ /parkour6 /bikepark /bikec");
	SendClientMessage(playerid, COLOR_FT, "← /help /bangzhu                ");
	return 1;
}
//------------------------------------------------------------------------------
	if(!strcmp(cmdtext,"/anim",true) || !strcmp(cmdtext,"/dongzuo",true) || !strcmp(cmdtext,"/动作",true) || !strcmp(cmdtext,"/帮助 动作",true))
	{
        SendFormatMessage(playerid, COLOR_HD, "动作");
		SendClientMessage(playerid, COLOR_BD, "    跳舞: /dance /animlist /animhelp /animhelp2 /animhelp3");
		SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /anim2");
		return 1;
	}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/dm", true) || !strcmp(cmdtext, "/pk", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /dm 1 ~ /dm 11 /akdm /beachdm /boxdm /huodm /carsumo /smgdm /ringdm");
	SendClientMessage(playerid, COLOR_BD, "    /sniperdm /tennisdm /farmdm /towndm /katanadm");
	SendFormatMessage(playerid, COLOR_HD, "/outdm /tuichudm");
	SendClientMessage(playerid, COLOR_BD, "    退出DM.不退出死亡始终在DM出生");
	SendFormatMessage(playerid, COLOR_HD, "/akdm");
	SendClientMessage(playerid, COLOR_BD, "    使用AK47在货轮上战斗");
	SendFormatMessage(playerid, COLOR_HD, "请不要使用作弊器,公平战斗,维护自尊");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /dm help 1 /dm bz 1");
	return 1;
}
if (!strcmp(cmdtext, "/dm help 1", true) || !strcmp(cmdtext, "/dm bz 1", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/beachdm");
	SendClientMessage(playerid, COLOR_BD, "    沙滩战场,武器为tec9/sawnoff");
	SendFormatMessage(playerid, COLOR_HD, "/boxdm /quanji");
	SendClientMessage(playerid, COLOR_BD, "    徒手肉搏");
	SendFormatMessage(playerid, COLOR_HD, "/dildodm /jjdm");
	SendClientMessage(playerid, COLOR_BD, "    使用xx互相PK");
	SendFormatMessage(playerid, COLOR_HD, "/monstedm");
	SendClientMessage(playerid, COLOR_BD, "    使用大轿车,把对方撞到油桶上");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /dm help 2 /dm bz 2");
	return 1;
}
if (!strcmp(cmdtext, "/dm help 2", true) || !strcmp(cmdtext, "/dm bz 2", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/carsumo");
	SendClientMessage(playerid, COLOR_BD, "    同/monstedm差不多,只是场景不同");
	SendFormatMessage(playerid, COLOR_HD, "/smgdm");
	SendClientMessage(playerid, COLOR_BD, "    使用smg战斗");
	SendFormatMessage(playerid, COLOR_HD, "/ringdm");
	SendClientMessage(playerid, COLOR_BD, "    电锯惊魂,声音就是悦耳");
	SendFormatMessage(playerid, COLOR_HD, "/sniperdm /jujidm");
	SendClientMessage(playerid, COLOR_BD, "    生死狙击.请不要攻击出生在一起的队友哦");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /dm help 3 /dm bz 3");
	return 1;
}
if (!strcmp(cmdtext, "/dm help 3", true) || !strcmp(cmdtext, "/dm bz 3", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/tennisdm");
	SendClientMessage(playerid, COLOR_BD, "    网球DM,其实就是互相扔手雷 o(∩_∩)o...");
	SendFormatMessage(playerid, COLOR_HD, "/farmdm");
	SendClientMessage(playerid, COLOR_BD, "    战场背景为农场");
	SendFormatMessage(playerid, COLOR_HD, "/towndm");
	SendClientMessage(playerid, COLOR_BD, "    城镇DM");
	SendFormatMessage(playerid, COLOR_HD, "/katanadm");
	SendClientMessage(playerid, COLOR_BD, "    武士刀DM");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /dm help 4 /dm bz 4");
	return 1;
}
if (!strcmp(cmdtext, "/dm help 4", true) || !strcmp(cmdtext, "/dm bz 4", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/rockedm /rpg");
	SendClientMessage(playerid, COLOR_BD, "    火箭筒DM,尽情的发泄吧");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/car", true) || !strcmp(cmdtext, "/che", true) || !strcmp(cmdtext, "/车", true) || !strcmp(cmdtext, "/交通工具", true))
{
	SendFormatMessage(playerid, COLOR_HD, "全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /carpark /v /vv /trans /arch /loco /bombshop /fix /fullfix /flip");
	SendClientMessage(playerid, COLOR_BD, "    /lock /unlock /cardive /vm  /carcolor /pimpedcars");
	SendClientMessage(playerid, COLOR_BD, "    /inf /bul /tur /sul /vor /ele /mnb /mon /hot /nrg");
	SendClientMessage(playerid, COLOR_BD, "    /411 /541 /451 /560 /539 /562 /510 /444 /556 /557 /502 /522");
	SendFormatMessage(playerid, COLOR_HD, "/carpark /cp /tcc /tingche /tingchechang");
	SendClientMessage(playerid, COLOR_BD, "    免费停车场.总共10个,每个不同,可以直接输入ID或者名称缩写购买");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /car help 1 /che bz 1");
	return 1;
}
if (!strcmp(cmdtext, "/help car 2", true) || !strcmp(cmdtext, "/che bz 2", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/fix");
	SendClientMessage(playerid, COLOR_BD, "    设置车血为:99999999");
	SendFormatMessage(playerid, COLOR_HD, "/fullfix");
	SendClientMessage(playerid, COLOR_BD, "    传送到修车厂,再传送回来");
	SendFormatMessage(playerid, COLOR_HD, "/filp /f");
	SendClientMessage(playerid, COLOR_BD, "    复位车辆.翻车或者卡在obj中时使用");
	SendFormatMessage(playerid, COLOR_HD, "/lock");
	SendClientMessage(playerid, COLOR_BD, "    锁车.防止抢车和G键上车,使用/unlock 解锁");
	SendFormatMessage(playerid, COLOR_HD, "/unlock");
	SendClientMessage(playerid, COLOR_BD, "    解锁,配合/lock使用");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /car help 3 /che bz 3");
	return 1;
}
if (!strcmp(cmdtext, "/car help 3", true) || !strcmp(cmdtext, "/che bz 3", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/cardive");
	SendClientMessage(playerid, COLOR_BD, "    原地身高n米");
	SendFormatMessage(playerid, COLOR_HD, "/vm");
	SendClientMessage(playerid, COLOR_BD, "    驾驶员聊天频道.所有在交通工具的玩家都能看到");
//	SendFormatMessage(playerid, COLOR_HD, "/modnrg");
//	SendClientMessage(playerid, COLOR_BD, "    超级版NRG");
	SendFormatMessage(playerid, COLOR_HD, "/carcolor");
	SendClientMessage(playerid, COLOR_BD, "    修改汽车颜色");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /car help 4 /che bz 4");
	return 1;
}
if (!strcmp(cmdtext, "/car help 4", true) || !strcmp(cmdtext, "/che bz 4", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/pimpedcars");
	SendClientMessage(playerid, COLOR_BD, "    拉皮条车");
	SendFormatMessage(playerid, COLOR_HD, "/inf /411");
	SendClientMessage(playerid, COLOR_BD, "    Infernus (411) 跑车,速度最快");
	SendFormatMessage(playerid, COLOR_HD, "/bul /541");
	SendClientMessage(playerid, COLOR_BD, "    Bullet (541) 跑车,马力十足");
	SendFormatMessage(playerid, COLOR_HD, "/tur /451");
	SendClientMessage(playerid, COLOR_BD, "    Turismo (451) 跑车,容易飘移");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /car help 5 /che bz 5");
	return 1;
}
if (!strcmp(cmdtext, "/car help 5", true) || !strcmp(cmdtext, "/che bz 5", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/sul /560");
	SendClientMessage(playerid, COLOR_BD, "    Sultan (560)");
	SendFormatMessage(playerid, COLOR_HD, "/vor /539");
	SendClientMessage(playerid, COLOR_BD, "    Vortex (539) 气垫船");
	SendFormatMessage(playerid, COLOR_HD, "/ele /562");
	SendClientMessage(playerid, COLOR_BD, "    Elegy (562)");
	SendFormatMessage(playerid, COLOR_HD, "/mnb /510");
	SendClientMessage(playerid, COLOR_BD, "    Mtbike (510) 自行车");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /car help 6 /che bz 6");
	return 1;
}
if (!strcmp(cmdtext, "/car help 7", true) || !strcmp(cmdtext, "/che bz 6", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/mon /444 /556 /557");
	SendClientMessage(playerid, COLOR_BD, "    Monster (444) 越野车");
	SendFormatMessage(playerid, COLOR_HD, "/hot /502");
	SendClientMessage(playerid, COLOR_BD, "    Hotrina (502) 赛车");
	SendFormatMessage(playerid, COLOR_HD, "/nrg /522");
	SendClientMessage(playerid, COLOR_BD, "    NRG500 (522) 摩托车");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
if (!strcmp(cmdtext, "/help gaiche", true) || !strcmp(cmdtext, "/帮助 改车", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/trans");
	SendClientMessage(playerid, COLOR_BD, "    普通车修改");
	SendFormatMessage(playerid, COLOR_HD, "/arch");
	SendClientMessage(playerid, COLOR_BD, "    高级车修改");
	SendFormatMessage(playerid, COLOR_HD, "/loco");
	SendClientMessage(playerid, COLOR_BD, "    底盘车修改");
	SendFormatMessage(playerid, COLOR_HD, "/bombshop");
	SendClientMessage(playerid, COLOR_BD, "    给车装一颗炸弹");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助");
	return 1;
}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext,"/3q",true)==0 || strcmp(cmdtext,"/3ks",true)==0 || strcmp(cmdtext,"/tks",true)==0 || strcmp(cmdtext,"/thanks",true)==0)
	{
		SendFormatMessage(playerid, COLOR_HD, "制作群");
		SendFormatMessage(playerid, COLOR_BD,"    Rafay,Zh3r0,vvg,yezizhu,Cn_Shindo,Sean.X,MK124");
		SendFormatMessage(playerid, COLOR_HD, "GM");
		SendFormatMessage(playerid, COLOR_BD,"    LXD,JL3517,TaiZi,KTS,CHY,luck,Devil_ggggg");
		SendFormatMessage(playerid, COLOR_HD, "玩家");
		SendFormatMessage(playerid, COLOR_BD,"owen,Leon,TaiZi,Heise,TY,Ak47,hand,TCWTQS...");
		SendFormatMessage(playerid, COLOR_HD, "网站");
		SendFormatMessage(playerid, COLOR_HD, "========= 网站 =========");
        SendFormatMessage(playerid, COLOR_BD,"    sa-mp.com.cn gtaip.com gtabbs.com gta.qq.topzj.com");
        SendClientMessage(playerid, COLOR_FT, "← /help /帮助");
		return 1;
	}
//------------------------------------------------------------------------------
if (!strcmp(cmdtext, "/t", true) || !strcmp(cmdtext, "/tele", true) || !strcmp(cmdtext, "/teles", true) || !strcmp(cmdtext, "/teleports", true) || !strcmp(cmdtext, "/chuansong", true) || !strcmp(cmdtext, "/shunyi", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/vmake /maketele /chuansongtianjia /cstj");
	SendClientMessage(playerid, COLOR_BD, "    创建属于自己的传送命令,发现好的地点,可以制作一个传送命令,邀请大家一起来玩");
	SendClientMessage(playerid, COLOR_BD, "    创建的传送命令,以 // 开头,例如 /vmake lxd 就制作了一个 //lxd 的传送命令");
	SendClientMessage(playerid, COLOR_BD, "    传送命令不存在覆盖的关系,只会继承第一个创建的坐标位置");
	SendFormatMessage(playerid, COLOR_HD, "更多的传送命令");
	SendClientMessage(playerid, COLOR_BD, "    /dm /race /stunt /tiaosan");
	SendClientMessage(playerid, COLOR_FT, "← /help /帮助                ");
	return 1;
}
//------------------------------------------------------------------------------
	if (!strcmp(cmdtext, "/tour", true) || !strcmp(cmdtext, "/lvyou", true) || !strcmp(cmdtext, "/ly", true) || !strcmp(cmdtext, "/travel", true))
	{
        SendFormatMessage(playerid, COLOR_HD, "旅游");
		SendClientMessage(playerid, COLOR_BD, "    /airport ~ /airport3 /area69 /ball /basejump /beach2 /bigjump /bowl /bridge /bridge2");
		SendClientMessage(playerid, COLOR_BD, "    /cafe /cardealer /carpalace /cg /crooked /crooked /cc /dam");
		SendClientMessage(playerid, COLOR_BD, "    /derby /drag /dunes /eggs /eggs2 /field /forest");
		SendClientMessage(playerid, COLOR_BD, "    /graveyard /golf /golf2 /gym /hazzard /hippy /hobo /hoop /hotel");
		SendClientMessage(playerid, COLOR_BD, "    /inn /kanada /keep /keep2 /lc /zyc /leap /leap2 /mafia1 /military /motel /movieset");
		SendClientMessage(playerid, COLOR_BD, "    /pj /pier /pimp /pool /pool2 /police /rbed /ridge /rockman /quarry /sb");
		SendClientMessage(playerid, COLOR_BD, "    /skatepark /sv /5towers /tie /tree /tree2 /tunnel /andy /buns /fcs /hqrb /adminhq /srs /water");
		SendClientMessage(playerid, COLOR_BD, "    /seif /frank /tools /4dragon");
		SendClientMessage(playerid, COLOR_FT, "← /help /帮助                → /tour2");
		return 1;
	}

//------------------------------------------------------------------------------
/*if (!strcmp(cmdtext, "/ramp", true) || !strcmp(cmdtext, "/tiaoban", true))
{
	SendFormatMessage(playerid, COLOR_HD, "/全部命令");
	SendClientMessage(playerid, COLOR_BD, "    /rampon /rampoff");
	SendFormatMessage(playerid, COLOR_HD, "/rampon /tiaobankai");
	SendClientMessage(playerid, COLOR_BD, "    开启跳板");
	SendFormatMessage(playerid, COLOR_HD, "/rampoff /tiaobanguan");
	SendClientMessage(playerid, COLOR_BD, "    关闭跳板");
	SendClientMessage(playerid, COLOR_FT, "← /help /bangzhu                ");
	return 1;
}
	if (strcmp(cmdtext, "/rampoff",true)==0 || strcmp(cmdtext, "/tiaobankai",true)==0)
	{
		ramped[playerid] = 1;
		noramp[playerid] = 1;
		SendFormatMessage(playerid, COLOR_RED, "[跳板] 您关闭使用跳板!");
		SendFormatMessage(playerid, COLOR_GREEN, "[帮助] 输入 /rampon 开启使用跳板!");
		return 1;
	}
	if (strcmp(cmdtext, "/rampon",true)==0 || strcmp(cmdtext, "/tiaobanguan",true)==0)
	{
		ramped[playerid] = 0;
		noramp[playerid] = 0;
		SendFormatMessage(playerid, COLOR_GREEN, "[跳板] 您开启使用跳板!");
		SendFormatMessage(playerid, COLOR_RED, "[帮助] 输入 /rampoff 关闭使用跳板!");
		return 1;
	}*/
//------------------------------------------------------------------------------
	if(strcmp("/mystats",cmdtext,true,10)==0 || strcmp("/wode",cmdtext,true,10)==0)
	{
		if(IsPlayerConnected(playerid))
		{
			new Float:pX,Float:pY,Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			SendFormatMessage(playerid,0x00A300AA," |玩家| 名称:[%s] 连接游戏次数:[%d] 退出游戏次数:[%d] 出错:[%d] 被踢/被封:[%d]",ReturnPlayerName(playerid),Connects,Disconnects,Crashs,Kicks);
			SendFormatMessage(playerid,0x00A300AA," |玩家| 出生次数:[%d] 死亡次数:[%d] 杀人数:[%d]",Spawns,Deaths,Kills);
			SendFormatMessage(playerid,0x00A300AA," |内容| 发送信息次数:[%d] 使用PM密语次数:[%d] 使用命令次数:[%d]",SendedMess,SendedPM,UsedCMD);
			SendFormatMessage(playerid,0x00A300AA," |车辆| 进入:[%d] 退出:[%d] 销毁:[%d]",VehicleEnters,VehicleExits,VehicleDestroys);
			SendFormatMessage(playerid,0x00A300AA," |时间| 玩家在线分钟:[%d] 玩家在线小时:[%d]",PlayingMinutes,PlayingHours);
			SendFormatMessage(playerid,0x00A300AA," |其它| 捡取物品:[%d] 更换状态:[%d] 金钱:[%d]",PickUpedPickups,StateChanges,GetPlayerMoney(playerid));
			SendFormatMessage(playerid,0x00A300AA," |位置| 坐标 X:[%d] 坐标 Y:[%d] 坐标 Z:[%d]",pX,pY,pZ);

	   }
       return 1;
	}
//------------------------------------------------------------------------------
        if (!strcmp(cmdtext, "/para", true) || !strcmp(cmdtext, "/jls", true))
        {
        GivePlayerWeapon(playerid, 46, 1);
        return 1;
        }
		if(strcmp(cmdtext, "/dive", true) == 0 || strcmp(cmdtext, "/ydts", true) == 0)
		{
		SkydivePlayer(playerid,500);
		GameTextForPlayer(playerid,"Here we go",2000,5);
		return 1;
		}
//------------------------------------------------------------------------------
        if(strcmp(cmd,"/cardive",true)==0 || strcmp(cmd,"/carts",true)==0)
		{
  		new carid = GetPlayerVehicleID(playerid);
  		Cardive(carid, 500);
		return 1;
		}
//------------------------------------------------------------------------------
		if (strcmp(cmdtext, "/jetpack", true) == 0 || strcmp(cmdtext, "/fxq", true) == 0 || strcmp(cmdtext, "/feixingqi", true) == 0)
		{
		SetPlayerSpecialAction(playerid, 2);
		return 1;
		}
//------------------------------------------------------------------------------
		if (strcmp("/lbon", cmdtext, true, 10) == 0)
		{
			TextDrawShowForPlayer(playerid,lbt);
			TextDrawShowForPlayer(playerid,lbb);
			return 1;
		}

		if (strcmp("/lboff", cmdtext, true, 10) == 0)
		{
			TextDrawHideForPlayer(playerid,lbt);
			TextDrawHideForPlayer(playerid,lbb);
			return 1;
		}
//------------------------------------------------------------------------------
        if (strcmp(cmdtext, "/stuntbonus", true)==0)
        {
            if ( SBAD[playerid] == 0 )
            {
               SBAD[playerid] = 1;
               EnableStuntBonusForPlayer(playerid, true);
			   SendFormatMessage(playerid, COLOR_ULTRARED, "[SA-MP] 特技奖励 已开启, 再次输入 /stuntbonus 关闭");
			   GameTextForPlayer(playerid, "~y~stunt bonus ~g~~h~Enabled",1200,5);
			   }else{
			   SBAD[playerid] = 0;
			   EnableStuntBonusForPlayer(playerid, false);
			   SendFormatMessage(playerid, COLOR_ULTRARED, "[SA-MP] 特技奖励 已关闭, 再次输入 /stuntbonus 开启");
			   GameTextForPlayer(playerid, "~y~Stunt bonus ~r~~h~Disabled",1200,5);
               return 1;
            }
			return 1;
        }
//------------------------------------------------------------------------------
        if (strcmp(cmdtext, "/kill", true)==0 || strcmp(cmdtext, "/zisha", true)==0 || strcmp(cmdtext, "/k", true)==0)
        {
        SetPlayerHealth(playerid, 0.00);
        return 1;
        }
//------------------------------------------------------------------------------
        if (!strcmp(cmdtext, "/racecount", true) || !strcmp(cmdtext, "/count", true) || !strcmp(cmdtext, "/daoshu", true) || !strcmp(cmdtext, "/djs", true) || !strcmp(cmdtext, "/daojishi", true))
		{
        if(Count >= 5)
		{
	    SendClientMessageToAll(COLOR_GREEN, "[成功] 倒计时开始");
	    CountDown();
	    return 1;
	    }else{
	    SendFormatMessage(playerid, COLOR_YELLOW, "[错误] 抱歉, 倒计时已经开启....");
        return 1;
		}
		}
//------------------------------------------------------------------------------
  		if (!strcmp(cmdtext, "/explodeme", true) || !strcmp(cmdtext, "/bombme", true) | !strcmp(cmdtext, "/zibao", true))
		{
		new PlayerMoney[MAX_PLAYERS];
		PlayerMoney[playerid] = GetPlayerMoney(playerid);
		if (PlayerMoney[playerid] <= 200000){ //0是钱数
		SendFormatMessage(playerid, COLOR_ULTRARED,"[错误] 没钱,怎么炸飞自己?");
		} else {
		ResetPlayerMoney(playerid);
	    new Float:X, Float:Y, Float:Z;
	    GetPlayerPos(playerid, X, Y, Z);
	    CreateExplosion(X,Y,Z-3,7,100);
	    CreateExplosion(X,Y,Z-3,7,100);
        CreateExplosion(X,Y,Z-3,7,100);
        CreateExplosion(X,Y,Z-3,7,100);
        SendFormatMessage(playerid, COLOR_ULTRARED, "[LOL]> 您把自己炸飞了....");
        //SetPlayerHealth(playerid, 1000.0);
        GameTextForPlayer(playerid, "~r~BOO00OOOOM~b~!!!!!!!",1200,5);
        return 1;
		}
		}
//------------------------------------------------------------------------------
        if (!strcmp(cmdtext, "/fullfix", true) || !strcmp(cmdtext, "/respray", true) || !strcmp(cmdtext, "/xiuche", true))
        {
		if (GetPlayerMoney(playerid) >= 500)
		{
            if(IsPlayerInAnyVehicle(playerid))
		    {
               new carid = GetPlayerVehicleID(playerid);
               ResprayCar(carid);
               GivePlayerMoney(playerid,-500);
            }
            else
		    {
		       SendFormatMessage(playerid, COLOR_ULTRARED,"[错误] 没有在汽车上.");
		       return 1;
            }
            }
         else
         {
		 SendFormatMessage(playerid, COLOR_ULTRARED, "[错误] 没有足够的金钱! 为您的汽车从新喷漆需要$500");
		 return 1;
		 }
        return 1;
		}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
	if(strcmp(cmd, "/vm", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    new length = strlen(cmdtext);
	    while ((idx < length) && (cmdtext[idx] <= ' '))
	    {
	        idx++;
	    }
	    new offset = idx;
	    new result[64];
	    while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	    {
	        result[idx - offset] = cmdtext[idx];
	        idx++;
	    }
	    result[idx - offset] = EOS;
	    if(!strlen(result))
	    {
	        SendFormatMessage(playerid, COLOR_RED, "[介绍] /vm [内容]");
	        return 1;
	    }
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        format(string, sizeof(string), "        [交频](%s): %s", sendername, result);
	        for(new i = 0; i < MAX_PLAYERS; i ++)
	        {
	            if(IsPlayerConnected(i))
	            {
                 	if(IsPlayerInVehicle(i, GetPlayerVehicleID(playerid)))
	                {
	                    SendClientMessage(i,COLOR_GREEN, string);
	                }
	            }
	        }
	        return 1;
	    }
	    else
	    {
	        SendFormatMessage(playerid, COLOR_RED, "[错误] 您必须在汽车上!");
	        return 1;
	    }
	}
//------------------------------------------------------------------------------
        if(strcmp(cmdtext, "/class",true)==0 || strcmp(cmdtext, "/huanren",true)==0 || strcmp(cmdtext, "/h",true)==0)
		{
		ForceClassSelection(playerid);
		SendFormatMessage(playerid, COLOR_ULTRARED,"[人物] 您重新更换了人物");
		SetPlayerHealth(playerid, 0.00);
		return 1;
		}
//------------------------------------------------------------------------------
    	if(strcmp(cmd, "/carcolor", true) == 0)
		{
    	new color1, color2;
    	tmp = strtok(cmdtext, idx);
    	if(!strlen(tmp)){
			SendFormatMessage(playerid, COLOR_YELLOW, "[介绍] /carcolor [颜色编号1] [颜色编号2]");
			return true;
		}
    	color1 = strval(tmp);
    	tmp = strtok(cmdtext, idx);
    	if(!strlen(tmp)){
			SendFormatMessage(playerid, COLOR_YELLOW, "[介绍] /carcolor [颜色编号1] [颜色编号2]");
			return true;
		}
    	color2 = strval(tmp);
   	 	ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
    	return 1;
	}
//------------------------------------------------------------------------------
		if(strcmp(cmd, "/up", true) == 0 || strcmp(cmd, "/helpme", true) == 0 || strcmp(cmd, "/bangwo", true) == 0)
		{
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerPos(playerid, X, Y, Z+5);
			return 1;
		}
//------------------------------------------------------------------------------
	if(strcmp(cmd,"/getid",true) == 0 || strcmp(cmd, "/id", true) == 0) // Lucifer
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendFormatMessage(playerid,COLOR_RED,"[介绍] /getid [部分玩家名称]");
			return 1;
		}
		//format(string,sizeof(string)," 搜索: \"%s\": ",tmp);
		SendFormatMessage(playerid,COLOR_RED,"[搜索] \"%s\": ",tmp);
		new found=0;
		for(new i=0; i <= MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
		  		new foundname[MAX_PLAYER_NAME];
		  		GetPlayerName(i, foundname, MAX_PLAYER_NAME);
				new namelen = strlen(foundname);
				new bool:searched=false;
		    	for(new pos=0; pos <= namelen; pos++)
				{
					if(searched != true)
					{
						if(strfind(foundname,tmp,true) == pos)
						{
			                found++;
							//format(string,sizeof(string),"%d. %s (ID %d)",found,foundname,i);
							SendFormatMessage(playerid, COLOR_GREEN ,"%d. %s (ID %d)",found,foundname,i);
							searched = true;
						}
					}
				}
			}
		}
		return 1;
	}
//------------------------------------------------------------------------------
		if(strcmp(cmdtext,"/fix",true)==0)
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		    new ID = GetPlayerVehicleID(playerid);
		    SetVehicleHealth(ID,99999999.99999999);
            }
            else
            {
		    SendFormatMessage(playerid, COLOR_ULTRARED, "[错误] 必须在汽车上.");
		    return 1;
            }
			return 1;
			}
//------------------------------------------------------------------------------
		if(strcmp(cmdtext, "/flip",true)==0 || strcmp(cmdtext, "/f",true)==0)
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		    new carid = GetPlayerVehicleID(playerid);
		    FlipCar(carid);
		    }
	        else
		    {
		    SendFormatMessage(playerid, COLOR_ULTRARED, "[错误] 必须在车上.");
		    return 1;
		    }
			return 1;
			}
//------------------------------------------------------------------------------
		if (strcmp(cmdtext, "/lock", true)==0)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				new State=GetPlayerState(playerid);
				if(State!=PLAYER_STATE_DRIVER)
				{
					SendFormatMessage(playerid,0xFFFF00AA,"[错误] 必须是司机才能锁门.");
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
				SendFormatMessage(playerid, 0xFFFF00AA, "[成功] 汽车已锁!");
		    	new Float:pX, Float:pY, Float:pZ;
				GetPlayerPos(playerid,pX,pY,pZ);
				PlayerPlaySound(playerid,1056,pX,pY,pZ);
			}
			else
			{
				SendFormatMessage(playerid, 0xFFFF00AA, "[错误] 必须在车上!");
			}
			return 1;
			}

//------------------------------------------------------------------------------
		if (strcmp(cmdtext, "/unlock", true)==0)
		{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new State=GetPlayerState(playerid);
			if(State!=PLAYER_STATE_DRIVER)
			{
				SendFormatMessage(playerid,0xFFFF00AA,"[错误] 必须是司机才能打开车门.");
				return 1;
			}
			new i;
			for(i=0;i<MAX_PLAYERS;i++)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 0);
			}
			SendFormatMessage(playerid, 0xFFFF00AA, "[成功] 车子已解锁!");
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1057,pX,pY,pZ);
		}
		else
		{
			SendFormatMessage(playerid, 0xFFFF00AA, "[错误] 必须在车上!");
		}
		return 1;
		}
//------------------------------------------------------------------------------
		if (strcmp(cmdtext, "/back", true)==0 || strcmp(cmdtext, "/huilai", true)==0)
		{
  		TogglePlayerControllable(playerid, 1);
		new name[18];
		GetPlayerName(playerid,name,18);
		format(string, sizeof(string), "[AFK] %s(%d) 归来!",name,playerid);
		SendClientMessageToAll(COLOR_YELLOW,string);
  		return 1;
         }
//------------------------------------------------------------------------------
        if(!strcmp(cmd, "/dance", true) || !strcmp(cmd, "/dans", true) || !strcmp(cmd, "/tiaowu", true))
	      {
	      tmp = strtok(cmdtext, idx);
	      new id = strval(tmp);
	      if(!strlen(tmp))
		  {
	 	  SendFormatMessage(playerid, COLOR_ORANGE,"[介绍] /dance [编号: 1-4]");
 		  return 1;
		  }
		  switch(id)
          {
          case 1:
		  {
		  SetPlayerSpecialAction(playerid,5);
		  GameTextForPlayer(playerid, "~r~.........................",1400,5);
		  }
		  case 2:
		  {
		  SetPlayerSpecialAction(playerid,6);
		  GameTextForPlayer(playerid, "~r~.........................",1400,5);
		  }
		  case 3:
		  {
		  SetPlayerSpecialAction(playerid,7);
		  GameTextForPlayer(playerid, "~r~.........................",1400,5);
		  }
		  case 4:
		  {
		  SetPlayerSpecialAction(playerid,8);
		  GameTextForPlayer(playerid, "~r~.........................",1400,5);
		  }
		  }
		  return 1;
		  }
//------------------------------------------------------------------------------
        if(!strcmp(cmd, "/me",true) || !strcmp(cmd, "/mymessage",true))
		{
        new dir[MAX_STRING];
        dir = strtok(cmdtext, idx);
        strmid(tmp, cmdtext, 4, strlen(cmdtext));
        if(!strlen(dir))
		{
        SendFormatMessage(playerid,COLOR_PINK,"[介绍] /me [内容]");
        return 1;
        }
        dir = strtok(cmdtext, idx);
        GetPlayerName(playerid, sendername, sizeof(sendername));
        format(string, sizeof(string), "==> %s %s", sendername, tmp);
        SendClientMessageToAll(COLOR_VIOLET,string);
        print(string);
        return 1;
        }

        if(strcmp(cmdtext,"/nos",true)==0)
		{
			if(IsPlayerInInvalidNosVehicle(playerid,GetPlayerVehicleID(playerid)))
			{
				SendFormatMessage(playerid,COLOR_WHITE,"[错误] 不能在这个交通工具上安装氮气加速系统.");
				return 1;
			}
			if(IsPlayerInAnyVehicle(playerid))
			{
				if(GetPlayerState(playerid) == 2)
				{
					new vid = GetPlayerVehicleID(playerid);
					AddVehicleComponent(vid, 1010);
					Timers[playerid] = SetTimerEx("Update", 20000, true, "i", playerid);
					SendFormatMessage(playerid,COLOR_WHITE,"[成功] 您的车当前已安装无限加速器.");
					return 1;
				} else {
					SendFormatMessage(playerid,COLOR_WHITE,"[错误] 您必须是司机才能给您的车辆安装氮气加速系统.");
					return 1;
				}
			} else {
				SendFormatMessage(playerid,COLOR_WHITE,"[错误] 您必须在车里才能使用这个命令.");
				return 1;
			}
		}
//------------------------------------------------------------------------------
        if(!strcmp(cmdtext, "/保存",true) || !strcmp(cmdtext,"/sp",true) || !strcmp(cmdtext,"/s",true))
		{
		if (IsPlayerInAnyVehicle(playerid))
		{
        GetVehiclePos(GetPlayerVehicleID(playerid), SavePos[playerid][sX], SavePos[playerid][sY], SavePos[playerid][sZ]);
        GetVehicleZAngle(GetPlayerVehicleID(playerid), SavePos[playerid][sA]);
		}else {
        GetPlayerPos(playerid, SavePos[playerid][sX], SavePos[playerid][sY], SavePos[playerid][sZ]);
        GetPlayerFacingAngle(playerid, SavePos[playerid][sA]);
		}SavePos[playerid][SavedPos] = 1;
        SendFormatMessage(playerid, COLOR_WHITE,"[成功] 当前坐标已保存, 输入 /lp 返回该坐标.");
		return true;
		}

//------------------------------------------------------------------------------
        if(!strcmp(cmdtext, "/lp",true) || !strcmp(cmdtext,"/读取",true) || !strcmp(cmdtext,"/l",true))
        {
        SetCameraBehindPlayer(playerid);
        if (SavePos[playerid][SavedPos] == 0){
			SendFormatMessage(playerid, COLOR_WHITE, "[介绍] 先输入 /sp 才能使用 /lp");
			return true;
		}
        if (IsPlayerInAnyVehicle(playerid))
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), SavePos[playerid][sX], SavePos[playerid][sY], SavePos[playerid][sZ]);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), SavePos[playerid][sA]);
		}else{
			SetPlayerPos(playerid, SavePos[playerid][sX], SavePos[playerid][sY], SavePos[playerid][sZ]);
			SetPlayerFacingAngle(playerid, SavePos[playerid][sA]);
		}
		ResetPlayerWeapons(playerid);
		SendFormatMessage(playerid, COLOR_WHITE, "[成功] 已传送至 /sp 处");
		return true;
		}
//------------------------------------------------------------------------------
	    if (strcmp(cmd, "/skinme", true) == 0 || strcmp(cmd, "/skin", true) == 0)
		{
		new skin[MAX_STRING];
		skin = strtok(cmdtext, idx);
		if (GetPlayerMoney(playerid) >= 9000)
		{
		if (!strlen(skin)) {
	 	SendFormatMessage(playerid, COLOR_ULTRARED, "[介绍] /skin [Skinid]");
	 	return 1;
		}
		new newskin = strval(skin);
		if ((newskin < 0) || (newskin > 299) || IsInvalidSkin(newskin)) {
		SendFormatMessage(playerid, COLOR_ULTRARED, "[错误]: 无效的人物ID");
		return 1;
		}
		SetPlayerSkin(playerid, newskin);
		GivePlayerMoney(playerid,-9000);
		//format(string, 128, " [成功]: 您的人物ID已更换为 %d, 花费 9000$", newskin);
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "[成功] 您的人物ID已更换为 %d, 花费 9000$", newskin);
		}
		else
        {
		SendFormatMessage(playerid, COLOR_ULTRARED, "[错误] 您没有那么多钱!您需要 9000$");
		return 1;
		}
		return 1;
	}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
	//------------------- /gang

	if(strcmp(cmd, "/gang", true) == 0)
	{
	    SendFormatMessage(playerid, COLOR_GREEN,"帮派帮助:");
		SendFormatMessage(playerid, COLOR_YELLOW,"/gang create [名称]---创建帮派名称");
		SendFormatMessage(playerid, COLOR_YELLOW,"/gang join ---加入帮派");
		SendFormatMessage(playerid, COLOR_YELLOW,"/gang invite [玩家ID] ---邀请玩家加入帮派");
		SendFormatMessage(playerid, COLOR_YELLOW,"/gang quit ---退出当前帮派");
		SendFormatMessage(playerid, COLOR_YELLOW,"/ganginfo [号码] (没有号码显示您的帮派的信息)");
		SendFormatMessage(playerid, COLOR_YELLOW,"! (输入内容可以帮派聊天)");
	    new gangcmd, gangnum;
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendFormatMessage(playerid, COLOR_WHITE, "[介绍] /gang [create/join/invite/quit] [名称/编号]");
			return 1;
		}
		giveplayerid = strval(tmp);

		if(strcmp(tmp, "create", true)==0)
		    gangcmd = 1;
		else if(strcmp(tmp, "invite", true)==0)
		    gangcmd = 2;
		else if(strcmp(tmp, "join", true)==0)
		    gangcmd = 3;
		else if(strcmp(tmp, "quit", true)==0)
		    gangcmd = 4;

		tmp = strtok(cmdtext, idx);
		if(gangcmd < 3 && !strlen(tmp)) {
		    if(gangcmd==0)
				SendFormatMessage(playerid, COLOR_WHITE, "[] 介绍/gang [create/join/invite/quit] [名称/编号]");
			else if(gangcmd==1)
				SendFormatMessage(playerid, COLOR_WHITE, "[介绍] /gang [create] [名称]");
			else if(gangcmd==2)
				SendFormatMessage(playerid, COLOR_WHITE, "[介绍] /gang [invite] [玩家ID]");
			return 1;
		}

		//Create Gang//
		if(gangcmd==1) {
		    if(playerGang[playerid]>0) {
				SendFormatMessage(playerid, COLOR_RED, "[成功] 已经加入一个帮派了!");
				return 1;
		    }

			for(new i = 1; i < MAX_GANGS; i++) {
				if(gangInfo[i][0]==0) {
				    //name gang
					format(gangNames[i], MAX_GANG_NAME, "%s", tmp);
					//Gang exists
					gangInfo[i][0]=1;
					//There is one member
					gangInfo[i][1]=1;
					//Gang color is player's color
					gangInfo[i][2]=playerColors[playerid];

					//Player is the first gang member
					gangMembers[i][0] = playerid;
					//format(string, sizeof(string)," 您创建了帮派 '%s' (id: %d)", gangNames[i], i);
					SendFormatMessage(playerid, COLOR_GREEN, "[成功] 您创建了帮派 '%s' (id: %d)", gangNames[i], i);
					playerGang[playerid]=i;

					return 1;
				}
			}

			return 1;

		//Join Gang//
		} else if (gangcmd==3) {
	 		gangnum = gangInvite[playerid];

		    if(playerGang[playerid]>0) {
				SendFormatMessage(playerid, COLOR_RED, "[错误] 已经加入一个帮派了");
				return 1;
		    }
	 		if(gangInvite[playerid]==0) {
				SendFormatMessage(playerid, COLOR_RED, "[错误] 没有被邀请参加帮派.");
				return 1;
			}
			if(gangInfo[gangnum][0]==0) {
				SendFormatMessage(playerid, COLOR_RED, "[错误] 这个帮派不存在!");
				return 1;
			}

			if(gangInfo[gangnum][1] < MAX_GANG_MEMBERS) {
			    new i = gangInfo[gangnum][1];

				gangInvite[playerid]=0;

				gangMembers[gangnum][i] = playerid;

			    GetPlayerName(playerid, sendername, MAX_PLAYER_NAME);
				for(new j = 0; j < gangInfo[gangnum][1]; j++) {
					//format(string, sizeof(string)," %s 加入了您的帮派.", sendername);
					SendFormatMessage(gangMembers[gangnum][j], COLOR_ORANGE, "[帮派] %s 加入了您的帮派.", sendername);
				}

				gangInfo[gangnum][1]++;
				playerGang[playerid] = gangnum;

				SetPlayerColor(playerid,gangInfo[gangnum][2]);

				//format(string, sizeof(string)," 您参加了帮派 '%s' (id: %d)", gangNames[gangnum], gangnum);
				SendFormatMessage(playerid, COLOR_GREEN, "[帮派] 您参加了帮派 '%s' (id: %d)", gangNames[gangnum], gangnum);

				return 1;
			}

			SendFormatMessage(playerid, COLOR_RED, "[错误] 这个帮派已经满员.");
			return 1;

		//Invite to Gang//
		} else if (gangcmd==2) {
	 		giveplayerid = strval(tmp);
			if(playerGang[playerid]==0) {
				SendFormatMessage(playerid, COLOR_RED, "[错误] 您没有加入任何一个帮派");
				return 1;
			}
//			if(gangMembers[playerGang[playerid]][0]!=playerid) {
//				SendClientMessage(playerid, COLOR_RED, "You need to be the gang leader to send an invite.");
//				return 1;
//			}

			if(IsPlayerConnected(giveplayerid)) {
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));

				//format(string, sizeof(string)," 您邀请了 %s 加入帮派", giveplayer);
				SendFormatMessage(playerid, COLOR_GREEN, "[帮派] 您邀请了 %s 加入帮派", giveplayer);
				//format(string, sizeof(string)," 您被邀请加入帮派 %s , 操作人 '%s' (id: %d)", sendername, gangNames[playerGang[playerid]],playerGang[playerid]);
				SendFormatMessage(giveplayerid, COLOR_GREEN, "[帮派] 您被邀请加入帮派 %s , 操作人 '%s' (id: %d)", sendername, gangNames[playerGang[playerid]],playerGang[playerid]);

				gangInvite[giveplayerid]=playerGang[playerid];

			} else
				SendFormatMessage(playerid, COLOR_RED, "[错误] 这个玩家不存在!");

		//Leave Gang//
		} else if (gangcmd==4) {
		    PlayerLeaveGang(playerid);
		}

		return 1;
	}
	  //GANG INFO//
	if(strcmp(cmd, "/ganginfo", true) == 0) {
	    new gangnum;
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp) && playerGang[playerid]==0) {
			SendFormatMessage(playerid, COLOR_WHITE, "[介绍] /ganginfo [编号]");
			return 1;
		} else if (!strlen(tmp))
			gangnum = playerGang[playerid];
		else
			gangnum = strval(tmp);

		if(gangInfo[gangnum][0]==0) {
			SendFormatMessage(playerid, COLOR_RED, "[错误] 这个帮派不存在!");
			return 1;
		}

		//format(string, sizeof(string)," '%s' 帮派成员 (id: %d)", gangNames[gangnum], gangnum);
		SendFormatMessage(playerid, COLOR_GREEN, "[帮派] '%s' 帮派成员 (id: %d)", gangNames[gangnum], gangnum);

		for(new i = 0; i < gangInfo[gangnum][1]; i++) {
			GetPlayerName(gangMembers[gangnum][i], giveplayer, sizeof(giveplayer));
			//format(string, sizeof(string),"%s (%d)", giveplayer, gangMembers[gangnum][i]);
			SendFormatMessage(playerid, COLOR_YELLOW, "[帮派] %s (%d)", giveplayer, gangMembers[gangnum][i]);
		}

		return 1;
	}
       //[GANGS]//
	if(strcmp(cmd, "/gangs", true) == 0)
	{
		new x;

		SendFormatMessage(playerid, COLOR_GREEN, "[帮派] 当前帮派:");
	    for(new i=0; i < MAX_GANGS; i++) {
			if(gangInfo[i][0]==1) {
				format(string, sizeof(string), "%s%s(%d) - %d 成员", string,gangNames[i],i,gangInfo[i][1]);

				x++;
				if(x > 2) {
				    SendClientMessage(playerid, COLOR_YELLOW, string);
				    x = 0;
					format(string, sizeof(string), "");
				} else {
					format(string, sizeof(string), "%s, ", string);
				}
			}
		}

		if(x <= 2 && x > 0) {
			string[strlen(string)-2] = '.';
		    SendClientMessage(playerid, COLOR_YELLOW, string);
		}

		return 1;
	}
//------------------------------------------------------------------------------
	if(strcmp(cmd, "/hitman", true) == 0 || strcmp(cmd, "/shashou", true) == 0 || strcmp(cmd, "/gandiao", true) == 0)
	{
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "[介绍] /hitman [玩家id] [金钱数量]");
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "[介绍] /hitman [玩家id] [金钱数量]");
			return 1;
		}
 		moneys = strval(tmp);

	    if(moneys > GetPlayerMoney(playerid)) {
			SendClientMessage(playerid, COLOR_RED, "[错误] 没有那么多钱!");
			return 1;
	    }
	    if(moneys < 1) {
			SendClientMessage(playerid, COLOR_YELLOW, "Hey what are you trying to pull here.");
			return 1;
		}
		if(IsPlayerConnected(giveplayerid)==0) {
			SendClientMessage(playerid, COLOR_RED, "[错误] 这个玩家不在线.");
			return 1;
		}

		bounty[giveplayerid]+=moneys;
		GivePlayerMoney(playerid, 0-moneys);

		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));


		format(string, sizeof(string), "[悬赏] %s 悬赏 $%d 缉杀 %s (总奖金: $%d).", sendername, moneys, giveplayer, bounty[giveplayerid]);
		SendClientMessageToAll(COLOR_ORANGE, string);

		format(string, sizeof(string), "[悬赏] 我们收到 来自 %s(%d) 的 $%d 缉杀你", sendername, playerid, moneys);
		SendClientMessage(giveplayerid, COLOR_RED, string);

		return 1;
	}
//------------------------------------------------------------------------------
	if(strcmp(cmd, "/bounty", true) == 0 || strcmp(cmd, "/xuanshang", true) == 0 || strcmp(cmd, "/shangjin", true) == 0)
		{
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "[介绍] /bounty [玩家id]");
			return 1;
		}
		giveplayerid = strval(tmp);

		if(IsPlayerConnected(giveplayerid)) {
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), "[悬赏] 查询结果: %s(%d) 有人出 $%d 悬赏他的头.", giveplayer,giveplayerid,bounty[giveplayerid]);
			SendClientMessage(playerid, COLOR_YELLOW, string);
		} else {
			SendClientMessage(playerid, COLOR_RED, "[错误] 没有这个玩家!");
		}

		return 1;
	}
//------------------------------------------------------------------------------
	if(strcmp(cmd, "/bounties", true) == 0 || strcmp(cmd, "/shangjinbang", true) == 0 || strcmp(cmd, "/xuanshangbang", true) == 0)
	{
		new x;

		SendClientMessage(playerid, COLOR_GREEN, "[悬赏] 目前的奖金:");
	    for(new i=0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && bounty[i] > 0) {
				GetPlayerName(i, giveplayer, sizeof(giveplayer));
				format(string, sizeof(string), "%s%s(%d): $%d", string,giveplayer,i,bounty[i]);

				x++;
				if(x > 3) {
				    SendClientMessage(playerid, COLOR_YELLOW, string);
				    x = 0;
					format(string, sizeof(string), "");
				} else {
					format(string, sizeof(string), "%s, ", string);
				}
			}
		}

		if(x <= 3 && x > 0) {
			string[strlen(string)-2] = '.';
		    SendClientMessage(playerid, COLOR_YELLOW, string);
		}

		return 1;
	}
//------------------------------------------------------------------------------
	if(strcmp(cmd, "/givemoney", true) == 0 || strcmp(cmd, "/geiqian", true) == 0 || strcmp(cmd, "/songqian", true) == 0)
	{
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "[介绍] /givemoney [玩家id] [金钱数量]");
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "[介绍] /givemoney [玩家id] [金钱数量]");
			return 1;
		}
 		moneys = strval(tmp);

		//printf("givecash_command: %d %d",giveplayerid,moneys);


		if (IsPlayerConnected(giveplayerid)) {
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			playermoney = GetPlayerMoney(playerid);
			if (moneys > 0 && playermoney >= moneys) {
				GivePlayerMoney(playerid, (0 - moneys));
				GivePlayerMoney(giveplayerid, moneys);
				format(string, sizeof(string), "[现金] 您给了 %s (id: %d), $%d.", giveplayer,giveplayerid, moneys);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "[现金] 您得到了 $%d, 来自玩家 %s (id: %d).", moneys, sendername, playerid);
				SendClientMessage(giveplayerid, COLOR_YELLOW, string);
				printf( "%s(玩家id:%d) 拿出了 %d 给 %s(玩家id:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);
			}
			else {
				SendClientMessage(playerid, COLOR_YELLOW, "[错误] 无效的交易数量.");
			}
		}
		else {
				format(string, sizeof(string), "[错误] %d 不是在线玩家.", giveplayerid);
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
		return 1;
	}
	
	if(strcmp(cmdtext, "/piss", true) == 0 || strcmp(cmdtext, "/xiaobian", true) == 0 || strcmp(cmdtext, "/小便", true) == 0 || strcmp(cmdtext, "/尿尿", true) == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
		SendClientMessage(playerid,COLOR_YELLOW,"[错误]在车里怎么能小便捏!");
		}
		else
		{
		SendClientMessage(playerid,COLOR_YELLOW,"OMG.. 好爽好舒畅...");
		SetPlayerSpecialAction(playerid, 68);
		return 1;
	}
}
//===========================[SKIN-COMMANDS]====================================
		if(strcmp(cmdtext, "/skins", true) == 0 || strcmp(cmdtext, "/huanfu", true) == 0)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE,"=====] 人物ID [=====");
			SendClientMessage(playerid, COLOR_YELLOW,"警察: /cop 搞笑: /fun 帮派: 帮派: /gangskin 妓女: /bitch 武士: /Karate");
  			SendClientMessage(playerid, COLOR_YELLOW,"胖子: /fat 特种兵: /boxer 大款: /rich 穷人: /poor 猫王: /elvis");
			SendClientMessage(playerid, COLOR_YELLOW,"特殊职业: /special /country 特工: /agent 裸男: /beach");
  			SendClientMessage(playerid, COLOR_YELLOW,"司机: /pilot 医生: /medic 救火员: /fire 美女: /lady cj的女朋友们: /cjgirl");
			return 1;
		}
		if(strcmp(cmdtext, "/gangskin", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE,"=====] 帮派 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /groove /ballas /vagos");
			SendClientMessage(playerid, COLOR_YELLOW," /varrios /nang /rifa ");
			return 1;
		}
		if(strcmp(cmdtext, "/cop", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 警察 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /cop 1 /cop 2 /cop 3 /cop 4  /cop 5 /cop 6 /cop 7");
			SendClientMessage(playerid, COLOR_YELLOW," /cop 8 /cop 9");
			return 1;
		}
		if(strcmp(cmdtext, "/fun", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 搞笑 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /fun 1 /fun 2 /fun 3");
			return 1;
		}
		if(strcmp(cmdtext, "/grove", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 格罗夫家族 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /grove 1 /grove 2 /grove 3");
			return 1;
			}
		if(strcmp(cmdtext, "/ballas", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 巴拉斯 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /ballas 1 /ballas 2 /ballas 3");
			return 1;
			}
		if(strcmp(cmdtext, "/vagos", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 黄帮 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /vagos 1 /vagos 2 /vagos 3");
			return 1;
			}
		if(strcmp(cmdtext, "/varrios", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] Varrios [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /varrios 1 /varrios 2 /varrios 3");
			return 1;
			}
		if(strcmp(cmdtext, "/nang", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE,"=====] Nang [=====");
			SendClientMessage(playerid, COLOR_YELLOW,"/nang 1 /nang 2 /nang 3");
			return 1;
			}
		if(strcmp(cmdtext, "/rifa", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] Rifa [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /rifa 1 /rifa 2 /rifa 3");
			return 1;
			}

		if(strcmp(cmdtext, "/bitch", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 妓女 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /bitch 1 /bitch 2 /bitch 3 /bitch 4 /bitch 5 /bitch 6 /bitch 7 /bitch 8 /bitch 9 /bitch 10");
			return 1;
		}
		if(strcmp(cmdtext, "/karate", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 武士 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /karate 1 /karate 2");
			return 1;
		}
		if(strcmp(cmdtext, "/boxer", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 特种兵 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /boxer 1 /boxer 2");
			return 1;
		}
		if(strcmp(cmdtext, "/rich", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 大款 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /rich 1 /rich 2");
			return 1;
		}
		if(strcmp(cmdtext, "/poor", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 穷人 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /poor 1 /poor 2 /poor 3 /poor 4 /poor 5 /poor 6 /poor 7 /poor 8 ");
			return 1;
		}
		if(strcmp(cmdtext, "/special", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 特价商品 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /special 1 /special 2 /special 3 /special 4 /special 5");
			return 1;
		}
		if(strcmp(cmdtext, "/country", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 乡村 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /country 1 /country 2 /country 3 /country 4 /country 5 /country 6");
			return 1;
		}
		if(strcmp(cmdtext, "/agent", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] Agent [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /agent 1 /agent 2 /agent 3 /agent 4");
			return 1;
		}
		if(strcmp(cmdtext, "/elvis", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE,"=====] 猫王 [=====");
			SendClientMessage(playerid, COLOR_YELLOW,"/elvis 1 /elvis 2 /elvis 3");
			return 1;
		}
		if(strcmp(cmdtext, "/beach", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 海滩 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /beach 1 /beach 2");
			return 1;
		}
		if(strcmp(cmdtext, "/pilot", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 驾驶员 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /pilot 1 /pilot 2 /pilot 3");
			return 1;
		}
		if(strcmp(cmdtext, "/medic", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 医生 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /medic 1 /medic 2 /medic 3");
			return 1;
		}
		if(strcmp(cmdtext, "/fire", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 火力 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /fire 1 /fire 2 /fire 3");
			return 1;
		}
		if(strcmp(cmdtext, "/fat", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 胖子 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /fat 1 /fat 2 /fat 3 /fat 4");
			return 1;
		}
		if(strcmp(cmdtext, "/lady", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] 女士[=====");
			SendClientMessage(playerid, COLOR_YELLOW," /lady 1 /lady 2 /lady 3 /lady 4 /lady 5");
			return 1;
		}
		if(strcmp(cmdtext, "/cjgirls", true) == 0) {
			SendClientMessage(playerid, COLOR_LIGHTBLUE," =====] CJ的女朋友们 [=====");
			SendClientMessage(playerid, COLOR_YELLOW," /cjgirl 1 /cjgirl 2 /cjgirl 3 /cjgirl 4 /cjgirl 5 /cjgirl 6");
			return 1;
	}
//==============================================================================
		//--------------------------------------------/cop
		if(strcmp(cmdtext, "/cop 1", true) == 0) {
			SetPlayerSkin(playerid,280);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 2", true) == 0) {
			SetPlayerSkin(playerid,281);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 3", true) == 0) {
			SetPlayerSkin(playerid,282);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 4", true) == 0) {
			SetPlayerSkin(playerid,283);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 5", true) == 0) {
			SetPlayerSkin(playerid,284);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 6", true) == 0) {
			SetPlayerSkin(playerid,285);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 7", true) == 0) {
			SetPlayerSkin(playerid,286);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 8", true) == 0) {
			SetPlayerSkin(playerid,287);
			return 1;
			}
		if(strcmp(cmdtext, "/cop 9", true) == 0) {
			SetPlayerSkin(playerid,246);
			return 1;
			}
		//--------------------------------------------/fun
		if(strcmp(cmdtext, "/fun 1", true) == 0) {
			SetPlayerSkin(playerid,264);
			return 1;
			}
		if(strcmp(cmdtext, "/fun 2", true) == 0) {
			SetPlayerSkin(playerid,167);
			return 1;
			}
		if(strcmp(cmdtext, "/fun 3", true) == 0) {
			SetPlayerSkin(playerid,205);
			return 1;
			}
		//--------------------------------------------/grove
		if(strcmp(cmdtext, "/grove 1", true) == 0) {
			SetPlayerSkin(playerid,105);
			return 1;
				}
		if(strcmp(cmdtext, "/grove 2", true) == 0) {
			SetPlayerSkin(playerid,106);
			return 1;
				}
		if(strcmp(cmdtext, "/grove 3", true) == 0) {
			SetPlayerSkin(playerid,107);
			return 1;
				}
		//--------------------------------------------/ballas
		if(strcmp(cmdtext, "/ballas 1", true) == 0) {
			SetPlayerSkin(playerid,102);
			return 1;
				}
		if(strcmp(cmdtext, "/ballas 2", true) == 0) {
			SetPlayerSkin(playerid,103);
			return 1;
				}
		if(strcmp(cmdtext, "/ballas 3", true) == 0) {
			SetPlayerSkin(playerid,104);
			return 1;
				}
		//--------------------------------------------/vagos
		if(strcmp(cmdtext, "/vagos 1", true) == 0) {
			SetPlayerSkin(playerid,108);
			return 1;
				}
		if(strcmp(cmdtext, "/vagos 2", true) == 0) {
			SetPlayerSkin(playerid,109);
			return 1;
				}
		if(strcmp(cmdtext, "/vagos 3", true) == 0) {
			SetPlayerSkin(playerid,110);
			return 1;
				}
		//--------------------------------------------/varrios
		if(strcmp(cmdtext, "/varrios 1", true) == 0) {
			SetPlayerSkin(playerid,173);
			return 1;
				}
		if(strcmp(cmdtext, "/varrios 2", true) == 0) {
			SetPlayerSkin(playerid,174);
			return 1;
				}
		if(strcmp(cmdtext, "/varrios 3", true) == 0) {
			SetPlayerSkin(playerid,175);
			return 1;
				}
		//--------------------------------------------/nang
		if(strcmp(cmdtext, "/nang 1", true) == 0) {
			SetPlayerSkin(playerid,121);
			return 1;
				}
		if(strcmp(cmdtext, "/nang 2", true) == 0) {
			SetPlayerSkin(playerid,122);
			return 1;
				}
		if(strcmp(cmdtext, "/nang 3", true) == 0) {
			SetPlayerSkin(playerid,123);
			return 1;
				}
		//--------------------------------------------/rifa
		if(strcmp(cmdtext, "/rifa 1", true) == 0) {
			SetPlayerSkin(playerid,114);
			return 1;
				}
		if(strcmp(cmdtext, "/rifa 2", true) == 0) {
			SetPlayerSkin(playerid,115);
			return 1;
				}
		if(strcmp(cmdtext, "/rifa 3", true) == 0) {
			SetPlayerSkin(playerid,116);
			return 1;
				}
		//--------------------------------------------/bitch
		if(strcmp(cmdtext, "/bitch 1", true) == 0) {
			SetPlayerSkin(playerid,1);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 2", true) == 0) {
			SetPlayerSkin(playerid,85);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 3", true) == 0) {
			SetPlayerSkin(playerid,178);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 4", true) == 0) {
			SetPlayerSkin(playerid,87);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 5", true) == 0) {
			SetPlayerSkin(playerid,157);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 6", true) == 0) {
			SetPlayerSkin(playerid,75);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 7", true) == 0) {
			SetPlayerSkin(playerid,MAX_STRING);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 8", true) == 0) {
			SetPlayerSkin(playerid,257);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 9", true) == 0) {
			SetPlayerSkin(playerid,63);
			return 1;
				}
		if(strcmp(cmdtext, "/bitch 10", true) == 0) {
			SetPlayerSkin(playerid,64);
			return 1;
				}
		//--------------------------------------------/karate
		if(strcmp(cmdtext, "/karate 1", true) == 0) {
			SetPlayerSkin(playerid,203);
			return 1;
				}
		if(strcmp(cmdtext, "/karate 2", true) == 0) {
			SetPlayerSkin(playerid,204);
			return 1;
				}
		//--------------------------------------------/boxer
		if(strcmp(cmdtext, "/boxer 1", true) == 0) {
			SetPlayerSkin(playerid,80);
			return 1;
				}
		if(strcmp(cmdtext, "/boxer 2", true) == 0) {
			SetPlayerSkin(playerid,81);
			return 1;
				}
		//--------------------------------------------/rich
		if(strcmp(cmdtext, "/rich 1", true) == 0) {
			SetPlayerSkin(playerid,249);
			return 1;
				}
		if(strcmp(cmdtext, "/rich 2", true) == 0) {
			SetPlayerSkin(playerid,296);
			return 1;
				}
		//--------------------------------------------/poor
		if(strcmp(cmdtext, "/poor 1", true) == 0) {
			SetPlayerSkin(playerid,212);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 2", true) == 0) {
			SetPlayerSkin(playerid,78);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 3", true) == 0) {
			SetPlayerSkin(playerid,79);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 4", true) == 0) {
			SetPlayerSkin(playerid,230);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 5", true) == 0) {
			SetPlayerSkin(playerid,239);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 6", true) == 0) {
			SetPlayerSkin(playerid,213);
			return 1;
				}
		if(strcmp(cmdtext, "/poor 7", true) == 0) {
			SetPlayerSkin(playerid,137);
			return 1;
				}
		//--------------------------------------------/elvis
		if(strcmp(cmdtext, "/elvis 1", true) == 0) {
			SetPlayerSkin(playerid,82);
			return 1;
				}
		if(strcmp(cmdtext, "/elvis 2", true) == 0) {
			SetPlayerSkin(playerid,83);
			return 1;
				}
		if(strcmp(cmdtext, "/elvis 3", true) == 0) {
			SetPlayerSkin(playerid,84);
			return 1;
				}
		//--------------------------------------------/special
		if(strcmp(cmdtext, "/special 1", true) == 0) {
			SetPlayerSkin(playerid,145);
			return 1;
				}
		if(strcmp(cmdtext, "/special 2", true) == 0) {
			SetPlayerSkin(playerid,146);
			return 1;
				}
		if(strcmp(cmdtext, "/special 3", true) == 0) {
			SetPlayerSkin(playerid,152);
			return 1;
				}
		if(strcmp(cmdtext, "/special 4", true) == 0) {
			SetPlayerSkin(playerid,260);
			return 1;
				}
		if(strcmp(cmdtext, "/special 5", true) == 0) {
			SetPlayerSkin(playerid,179);
			return 1;
				}
		//--------------------------------------------/contry
		if(strcmp(cmdtext, "/country 1", true) == 0) {
			SetPlayerSkin(playerid,157);
			return 1;
				}
		if(strcmp(cmdtext, "/country 2", true) == 0) {
			SetPlayerSkin(playerid,158);
			return 1;
				}
		if(strcmp(cmdtext, "/country 3", true) == 0) {
			SetPlayerSkin(playerid,159);
			return 1;
				}
		if(strcmp(cmdtext, "/country 4", true) == 0) {
			SetPlayerSkin(playerid,160);
			return 1;
				}
		if(strcmp(cmdtext, "/country 5", true) == 0) {
			SetPlayerSkin(playerid,161);
			return 1;
				}
		if(strcmp(cmdtext, "/country 6", true) == 0) {
			SetPlayerSkin(playerid,162);
			return 1;
				}
		//--------------------------------------------/agent
		if(strcmp(cmdtext, "/agent 1", true) == 0) {
			SetPlayerSkin(playerid,163);
			return 1;
				}
		if(strcmp(cmdtext, "/agent 2", true) == 0) {
			SetPlayerSkin(playerid,164);
			return 1;
				}
		if(strcmp(cmdtext, "/agent 3", true) == 0) {
			SetPlayerSkin(playerid,165);
			return 1;
				}
		if(strcmp(cmdtext, "/agent 4", true) == 0) {
			SetPlayerSkin(playerid,166);
			return 1;
				}
		//--------------------------------------------/beach
		if(strcmp(cmdtext, "/beach 1", true) == 0) {
			SetPlayerSkin(playerid,97);
			return 1;
				}
		if(strcmp(cmdtext, "/beach 2", true) == 0) {
			SetPlayerSkin(playerid,154);
			return 1;
				}
		//--------------------------------------------/pilot
		if(strcmp(cmdtext, "/pilot 1", true) == 0) {
			SetPlayerSkin(playerid,255);
			return 1;
				}
		if(strcmp(cmdtext, "/pilot 2", true) == 0) {
			SetPlayerSkin(playerid,61);
			return 1;
				}
		if(strcmp(cmdtext, "/pilot 3", true) == 0) {
			SetPlayerSkin(playerid,253);
			return 1;
				}
		//--------------------------------------------/midic
		if(strcmp(cmdtext, "/medic 1", true) == 0) {
			SetPlayerSkin(playerid,274);
			return 1;
				}
		if(strcmp(cmdtext, "/medic 2", true) == 0) {
			SetPlayerSkin(playerid,275);
			return 1;
				}
		if(strcmp(cmdtext, "/medic 2", true) == 0) {
			SetPlayerSkin(playerid,276);
			return 1;
				}
		//--------------------------------------------/fire
		if(strcmp(cmdtext, "/fire 1", true) == 0) {
			SetPlayerSkin(playerid,277);
			return 1;
				}
		if(strcmp(cmdtext, "/fire 2", true) == 0) {
			SetPlayerSkin(playerid,278);
			return 1;
				}
		if(strcmp(cmdtext, "/fire 3", true) == 0) {
			SetPlayerSkin(playerid,279);
			return 1;
				}
		//--------------------------------------------/lady
		if(strcmp(cmdtext, "/lady 1", true) == 0) {
			SetPlayerSkin(playerid,92);
			return 1;
				}
		if(strcmp(cmdtext, "/lady 2", true) == 0) {
			SetPlayerSkin(playerid,93);
			return 1;
				}
		if(strcmp(cmdtext, "/lady 3", true) == 0) {
			SetPlayerSkin(playerid,138);
			return 1;
				}
		if(strcmp(cmdtext, "/lady 4", true) == 0) {
			SetPlayerSkin(playerid,139);
			return 1;
				}
		if(strcmp(cmdtext, "/lady 5", true) == 0) {
			SetPlayerSkin(playerid,140);
			return 1;
				}
		//--------------------------------------------/fat
		if(strcmp(cmdtext, "/fat 1", true) == 0) {
			SetPlayerSkin(playerid,258);
			return 1;
				}
		if(strcmp(cmdtext, "/fat 2", true) == 0) {
			SetPlayerSkin(playerid,259);
			return 1;
				}
		if(strcmp(cmdtext, "/fat 3", true) == 0) {
			SetPlayerSkin(playerid,241);
			return 1;
				}
		if(strcmp(cmdtext, "/fat 4", true) == 0) {
			SetPlayerSkin(playerid,242);
			return 1;
				}
		//--------------------------------------------/cjgirls
  		if(strcmp(cmdtext, "/cjgirl 1", true) == 0) {
			SetPlayerSkin(playerid,190);
			return 1;
				}
  		if(strcmp(cmdtext, "/cjgirl 2", true) == 0) {
			SetPlayerSkin(playerid,191);
			return 1;
				}
    	if(strcmp(cmdtext, "/cjgirl 3", true) == 0) {
			SetPlayerSkin(playerid,192);
			return 1;
				}
       	if(strcmp(cmdtext, "/cjgirl 4", true) == 0) {
			SetPlayerSkin(playerid,193);
			return 1;
				}
		if(strcmp(cmdtext, "/cjgirl 5", true) == 0) {
			SetPlayerSkin(playerid,194);
			return 1;
				}
   		if(strcmp(cmdtext, "/cjgirl 6", true) == 0) {
			SetPlayerSkin(playerid,195);
			return 1;
				}
//--------------------------------------------/vvg
if(strcmp(cmdtext, "/cj", true) == 0 || strcmp(cmdtext, "/skin grove 0", true) == 0)
{
	SetPlayerSkin(playerid,0);
	return 1;
}
if(strcmp(cmdtext, "/fam1", true) == 0 || strcmp(cmdtext, "/skin grove 1", true) == 0)
{
	SetPlayerSkin(playerid,105);
	return 1;
}
if(strcmp(cmdtext, "/fam2", true) == 0 || strcmp(cmdtext, "/skin grvoe 2", true) == 0)
{
	SetPlayerSkin(playerid,106);
	return 1;
}
if(strcmp(cmdtext, "/fam3", true) == 0 || strcmp(cmdtext, "/skin grove 3", true) == 0)
{
	SetPlayerSkin(playerid,107);
	return 1;
}
if(strcmp(cmdtext, "/ballas1", true) == 0 || strcmp(cmdtext, "/skin ballas 1", true) == 0)
{
	SetPlayerSkin(playerid,102);
	return 1;
}
if(strcmp(cmdtext, "/ballas2", true) == 0 || strcmp(cmdtext, "/skin ballas 2", true) == 0)
{
	SetPlayerSkin(playerid,103);
	return 1;
}
if(strcmp(cmdtext, "/ballas3", true) == 0 || strcmp(cmdtext, "/skin ballas 3", true) == 0)
{
	SetPlayerSkin(playerid,104);
	return 1;
}
if(strcmp(cmdtext, "/vla1", true) == 0 || strcmp(cmdtext, "/skin vla 1", true) == 0)
{
	SetPlayerSkin(playerid,114);
	return 1;
}
if(strcmp(cmdtext, "/vla2", true) == 0 || strcmp(cmdtext, "/skin vla 2", true) == 0)
{
	SetPlayerSkin(playerid,115);
	return 1;
}
if(strcmp(cmdtext, "/vla3", true) == 0 || strcmp(cmdtext, "/skin vla 3", true) == 0)
{
	SetPlayerSkin(playerid,116);
	return 1;
}
if(strcmp(cmdtext, "/lsv1", true) == 0 || strcmp(cmdtext, "/skin lsv 1", true) == 0)
{
	SetPlayerSkin(playerid,108);
	return 1;
}
if(strcmp(cmdtext, "/lsv2", true) == 0 || strcmp(cmdtext, "/skin lsv 2", true) == 0)
{
	SetPlayerSkin(playerid,109);
	return 1;
}
if(strcmp(cmdtext, "/lsv3", true) == 0 || strcmp(cmdtext, "/skin lsv 3", true) == 0)
{
	SetPlayerSkin(playerid,110);
	return 1;
}
if(strcmp(cmdtext, "/dnb1", true) == 0 || strcmp(cmdtext, "/skin dnb 1", true) == 0)
{
	SetPlayerSkin(playerid,121);
	return 1;
}
if(strcmp(cmdtext, "/dnb2", true) == 0 || strcmp(cmdtext, "/skin dnb 2", true) == 0)
{
	SetPlayerSkin(playerid,122);
	return 1;
}
if(strcmp(cmdtext, "/dnb3", true) == 0 || strcmp(cmdtext, "/skin dnb 3", true) == 0)
{
	SetPlayerSkin(playerid,123);
	return 1;
}
if(strcmp(cmdtext, "/sfr1", true) == 0 || strcmp(cmdtext, "/skin sfr 1", true) == 0)
{
	SetPlayerSkin(playerid,173);
	return 1;
}
if(strcmp(cmdtext, "/sfr2", true) == 0 || strcmp(cmdtext, "/skin sfr 2", true) == 0)
{
	SetPlayerSkin(playerid,174);
	return 1;
}
if(strcmp(cmdtext, "/sfr3", true) == 0 || strcmp(cmdtext, "/skin sfr 3", true) == 0)
{
	SetPlayerSkin(playerid,175);
	return 1;
}
if(strcmp(cmdtext, "/triada", true) == 0 || strcmp(cmdtext, "/skin triad 1", true) == 0)
{
	SetPlayerSkin(playerid,117);
	return 1;
}
if(strcmp(cmdtext, "/triadb", true) == 0 || strcmp(cmdtext, "/skin triad 2", true) == 0)
{
	SetPlayerSkin(playerid,118);
	return 1;
}
if(strcmp(cmdtext, "/triboss", true) == 0 || strcmp(cmdtext, "/skin triad 3", true) == 0)
{
	SetPlayerSkin(playerid,120);
	return 1;
}
if(strcmp(cmdtext, "/wmycr", true) == 0 || strcmp(cmdtext, "/skin biker 1", true) == 0)
{
	SetPlayerSkin(playerid,100);
	return 1;
}
if(strcmp(cmdtext, "/bikera", true) == 0 || strcmp(cmdtext, "/skin biker 2", true) == 0)
{
	SetPlayerSkin(playerid,247);
	return 1;
}
if(strcmp(cmdtext, "/bikerb", true) == 0 || strcmp(cmdtext, "/skin biker 3", true) == 0)
{
	SetPlayerSkin(playerid,248);
	return 1;
}
if(strcmp(cmdtext, "/bikdrug", true) == 0 || strcmp(cmdtext, "/skin biker 4", true) == 0)
{
	SetPlayerSkin(playerid,254);
	return 1;
}
if(strcmp(cmdtext, "/maffa", true) == 0 || strcmp(cmdtext, "/skin mafia 1", true) == 0)
{
	SetPlayerSkin(playerid,111);
	return 1;
}
if(strcmp(cmdtext, "/maffb", true) == 0 || strcmp(cmdtext, "/skin mafia 2", true) == 0)
{
	SetPlayerSkin(playerid,112);
	return 1;
}
if(strcmp(cmdtext, "/mafboss", true) == 0 || strcmp(cmdtext, "/skin mafia 3", true) == 0)
{
	SetPlayerSkin(playerid,113);
	return 1;
}
if(strcmp(cmdtext, "/vmaff1", true) == 0 || strcmp(cmdtext, "/skin mafia 4", true) == 0)
{
	SetPlayerSkin(playerid,124);
	return 1;
}
if(strcmp(cmdtext, "/vmaff2", true) == 0 || strcmp(cmdtext, "/skin mafia 5", true) == 0)
{
	SetPlayerSkin(playerid,125);
	return 1;
}
if(strcmp(cmdtext, "/vmaff3", true) == 0 || strcmp(cmdtext, "/skin mafia 6", true) == 0)
{
	SetPlayerSkin(playerid,126);
	return 1;
}
if(strcmp(cmdtext, "/vmaff4", true) == 0 || strcmp(cmdtext, "/skin mafia 7", true) == 0)
{
	SetPlayerSkin(playerid,127);
	return 1;
}
if(strcmp(cmdtext, "/bmyboun", true) == 0 || strcmp(cmdtext, "/skin agent 1", true) == 0)
{
	SetPlayerSkin(playerid,163);
	return 1;
}
if(strcmp(cmdtext, "/wmyboun", true) == 0 || strcmp(cmdtext, "/skin agent 2", true) == 0)
{
	SetPlayerSkin(playerid,164);
	return 1;
}
if(strcmp(cmdtext, "/wmomib", true) == 0 || strcmp(cmdtext, "/skin agent 3", true) == 0)
{
	SetPlayerSkin(playerid,165);
	return 1;
}
if(strcmp(cmdtext, "/bmymib", true) == 0 || strcmp(cmdtext, "/skin agent 4", true) == 0)
{
	SetPlayerSkin(playerid,166);
	return 1;
}
if(strcmp(cmdtext, "/laemt1", true) == 0 || strcmp(cmdtext, "/skin medic 1", true) == 0)
{
	SetPlayerSkin(playerid,274);
	return 1;
}
if(strcmp(cmdtext, "/lvemt1", true) == 0 || strcmp(cmdtext, "/skin medic 2", true) == 0)
{
	SetPlayerSkin(playerid,275);
	return 1;
}
if(strcmp(cmdtext, "/sfemt1", true) == 0 || strcmp(cmdtext, "/skin medic 3", true) == 0)
{
	SetPlayerSkin(playerid,276);
	return 1;
}
if(strcmp(cmdtext, "/lafd1", true) == 0 || strcmp(cmdtext, "/skin fire 1", true) == 0)
{
	SetPlayerSkin(playerid,277);
	return 1;
}
if(strcmp(cmdtext, "/lvfd1", true) == 0 || strcmp(cmdtext, "/skin fire 2", true) == 0)
{
	SetPlayerSkin(playerid,278);
	return 1;
}
if(strcmp(cmdtext, "/sffd1", true) == 0 || strcmp(cmdtext, "/skin fire 3", true) == 0)
{
	SetPlayerSkin(playerid,279);
	return 1;
}
if(strcmp(cmdtext, "/lapd1", true) == 0 || strcmp(cmdtext, "/skin cop 1", true) == 0)
{
	SetPlayerSkin(playerid,280);
	return 1;
}
if(strcmp(cmdtext, "/sfpd1", true) == 0 || strcmp(cmdtext, "/skin cop 2", true) == 0)
{
	SetPlayerSkin(playerid,281);
	return 1;
}
if(strcmp(cmdtext, "/lvpd1", true) == 0 || strcmp(cmdtext, "/skin cop 3", true) == 0)
{
	SetPlayerSkin(playerid,282);
	return 1;
}
if(strcmp(cmdtext, "/csher", true) == 0 || strcmp(cmdtext, "/skin cop 4", true) == 0)
{
	SetPlayerSkin(playerid,283);
	return 1;
}
if(strcmp(cmdtext, "/dsher", true) == 0 || strcmp(cmdtext, "/skin cop 5", true) == 0)
{
	SetPlayerSkin(playerid,288);
	return 1;
}
if(strcmp(cmdtext, "/lapdm1", true) == 0 || strcmp(cmdtext, "/skin cop 6", true) == 0)
{
	SetPlayerSkin(playerid,284);
	return 1;
}
if(strcmp(cmdtext, "/swat", true) == 0 || strcmp(cmdtext, "/skin cop 7", true) == 0)
{
	SetPlayerSkin(playerid,285);
	return 1;
}
if(strcmp(cmdtext, "/fbi", true) == 0 || strcmp(cmdtext, "/skin cop 8", true) == 0)
{
	SetPlayerSkin(playerid,286);
	return 1;
}
if(strcmp(cmdtext, "/army", true) == 0 || strcmp(cmdtext, "/skin cop 9", true) == 0)
{
	SetPlayerSkin(playerid,287);
	return 1;
}
if(strcmp(cmdtext, "/gangrl3", true) == 0 || strcmp(cmdtext, "/skin cj 1", true) == 0)
{
	SetPlayerSkin(playerid,195);
	return 1;
}
if(strcmp(cmdtext, "/copgrl3", true) == 0 || strcmp(cmdtext, "/skin cj 2", true) == 0)
{
	SetPlayerSkin(playerid,190);
	return 1;
}
if(strcmp(cmdtext, "/gungrl3", true) == 0 || strcmp(cmdtext, "/skin cj 3", true) == 0)
{
	SetPlayerSkin(playerid,191);
	return 1;
}
if(strcmp(cmdtext, "/mecgrl3", true) == 0 || strcmp(cmdtext, "/skin cj 4", true) == 0)
{
	SetPlayerSkin(playerid,192);
	return 1;
}
if(strcmp(cmdtext, "/nurgrl3", true) == 0 || strcmp(cmdtext, "/skin cj 5", true) == 0)
{
	SetPlayerSkin(playerid,193);
	return 1;
}
if(strcmp(cmdtext, "/crogrl3", true) == 0 || strcmp(cmdtext, "/skin cj 6", true) == 0)
{
	SetPlayerSkin(playerid,194);
	return 1;
}
if(strcmp(cmdtext, "/wfybe", true) == 0 || strcmp(cmdtext, "/skin beach 1", true) == 0)
{
	SetPlayerSkin(playerid,138);
	return 1;
}
if(strcmp(cmdtext, "/bfybe", true) == 0 || strcmp(cmdtext, "/skin beach 2", true) == 0)
{
	SetPlayerSkin(playerid,139);
	return 1;
}
if(strcmp(cmdtext, "/hfybe", true) == 0 || strcmp(cmdtext, "/skin beach 3", true) == 0)
{
	SetPlayerSkin(playerid,140);
	return 1;
}
if(strcmp(cmdtext, "/wfycrk", true) == 0 || strcmp(cmdtext, "/skin beach 4", true) == 0)
{
	SetPlayerSkin(playerid,145);
	return 1;
}
if(strcmp(cmdtext, "/hmycm", true) == 0 || strcmp(cmdtext, "/skin beach 5", true) == 0)
{
	SetPlayerSkin(playerid,146);
	return 1;
}
if(strcmp(cmdtext, "/wmybe", true) == 0 || strcmp(cmdtext, "/skin beach 6", true) == 0)
{
	SetPlayerSkin(playerid,154);
	return 1;
}
if(strcmp(cmdtext, "/wfylg", true) == 0 || strcmp(cmdtext, "/skin beach 7", true) == 0)
{
	SetPlayerSkin(playerid,251);
	return 1;
}
if(strcmp(cmdtext, "/wfyro", true) == 0 || strcmp(cmdtext, "/skin beach 8", true) == 0)
{
	SetPlayerSkin(playerid,92);
	return 1;
}
if(strcmp(cmdtext, "/wmylg", true) == 0 || strcmp(cmdtext, "/skin beach 9", true) == 0)
{
	SetPlayerSkin(playerid,97);
	return 1;
}
if(strcmp(cmdtext, "/hmybe", true) == 0 || strcmp(cmdtext, "/skin beach 10", true) == 0)
{
	SetPlayerSkin(playerid,45);
	return 1;
}
if(strcmp(cmdtext, "/bmybe", true) == 0 || strcmp(cmdtext, "/skin beach 11", true) == 0)
{
	SetPlayerSkin(playerid,18);
	return 1;
}
if(strcmp(cmdtext, "/dnmylc", true) == 0 || strcmp(cmdtext, "/skin farm 1", true) == 0)
{
	SetPlayerSkin(playerid,128);
	return 1;
}
if(strcmp(cmdtext, "/dnfolc1", true) == 0 || strcmp(cmdtext, "/skin farm 2", true) == 0)
{
	SetPlayerSkin(playerid,129);
	return 1;
}
if(strcmp(cmdtext, "/dnfolc2", true) == 0 || strcmp(cmdtext, "/skin farm 3", true) == 0)
{
	SetPlayerSkin(playerid,130);
	return 1;
}
if(strcmp(cmdtext, "/dnfylc", true) == 0 || strcmp(cmdtext, "/skin farm 4", true) == 0)
{
	SetPlayerSkin(playerid,131);
	return 1;
}
if(strcmp(cmdtext, "/dnmolc1", true) == 0 || strcmp(cmdtext, "/skin farm 5", true) == 0)
{
	SetPlayerSkin(playerid,132);
	return 1;
}
if(strcmp(cmdtext, "/dnmolc2", true) == 0 || strcmp(cmdtext, "/skin farm 6", true) == 0)
{
	SetPlayerSkin(playerid,133);
	return 1;
}
if(strcmp(cmdtext, "/cwfyhb", true) == 0 || strcmp(cmdtext, "/skin farm 7", true) == 0)
{
	SetPlayerSkin(playerid,157);
	return 1;
}
if(strcmp(cmdtext, "/cwmofr", true) == 0 || strcmp(cmdtext, "/skin farm 8", true) == 0)
{
	SetPlayerSkin(playerid,158);
	return 1;
}
if(strcmp(cmdtext, "/cwmohb1", true) == 0 || strcmp(cmdtext, "/skin farm 9", true) == 0)
{
	SetPlayerSkin(playerid,159);
	return 1;
}
if(strcmp(cmdtext, "/cwmohb2", true) == 0 || strcmp(cmdtext, "/skin farm 10", true) == 0)
{
	SetPlayerSkin(playerid,160);
	return 1;
}
if(strcmp(cmdtext, "/cwfofr", true) == 0 || strcmp(cmdtext, "/skin farm 11", true) == 0)
{
	SetPlayerSkin(playerid,196);
	return 1;
}
if(strcmp(cmdtext, "/cwfohb", true) == 0 || strcmp(cmdtext, "/skin farm 12", true) == 0)
{
	SetPlayerSkin(playerid,197);
	return 1;
}
if(strcmp(cmdtext, "/cwfyfr1", true) == 0 || strcmp(cmdtext, "/skin farm 13", true) == 0)
{
	SetPlayerSkin(playerid,198);
	return 1;
}
if(strcmp(cmdtext, "/cwfyfr2", true) == 0 || strcmp(cmdtext, "/skin farm 14", true) == 0)
{
	SetPlayerSkin(playerid,199);
	return 1;
}
if(strcmp(cmdtext, "/cwmyfr", true) == 0 || strcmp(cmdtext, "/skin farm 15", true) == 0)
{
	SetPlayerSkin(playerid,161);
	return 1;
}
if(strcmp(cmdtext, "/cwmyhb1", true) == 0 || strcmp(cmdtext, "/skin farm 16", true) == 0)
{
	SetPlayerSkin(playerid,162);
	return 1;
}
if(strcmp(cmdtext, "/cwmyhb2", true) == 0 || strcmp(cmdtext, "/skin farm 17", true) == 0)
{
	SetPlayerSkin(playerid,200);
	return 1;
}
if(strcmp(cmdtext, "/dwfylc2", true) == 0 || strcmp(cmdtext, "/skin farm 18", true) == 0)
{
	SetPlayerSkin(playerid,201);
	return 1;
}
if(strcmp(cmdtext, "/dwmylc2", true) == 0 || strcmp(cmdtext, "/skin farm 19", true) == 0)
{
	SetPlayerSkin(playerid,202);
	return 1;
}
if(strcmp(cmdtext, "/dwfolc", true) == 0 || strcmp(cmdtext, "/skin farm 20", true) == 0)
{
	SetPlayerSkin(playerid,31);
	return 1;
}
if(strcmp(cmdtext, "/dwmolc1", true) == 0 || strcmp(cmdtext, "/skin farm 21", true) == 0)
{
	SetPlayerSkin(playerid,32);
	return 1;
}
if(strcmp(cmdtext, "/dwmolc2", true) == 0 || strcmp(cmdtext, "/skin farm 22", true) == 0)
{
	SetPlayerSkin(playerid,33);
	return 1;
}
if(strcmp(cmdtext, "/dwmylc1", true) == 0 || strcmp(cmdtext, "/skin farm 23", true) == 0)
{
	SetPlayerSkin(playerid,34);
	return 1;
}
if(strcmp(cmdtext, "/wfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 1", true) == 0)
{
	SetPlayerSkin(playerid,152);
	return 1;
}
if(strcmp(cmdtext, "/wfysex", true) == 0 || strcmp(cmdtext, "/skin bitch 2", true) == 0)
{
	SetPlayerSkin(playerid,178);
	return 1;
}
if(strcmp(cmdtext, "/shfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 3", true) == 0)
{
	SetPlayerSkin(playerid,237);
	return 1;
}
if(strcmp(cmdtext, "/sbfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 4", true) == 0)
{
	SetPlayerSkin(playerid,238);
	return 1;
}
if(strcmp(cmdtext, "/sfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 5", true) == 0)
{
	SetPlayerSkin(playerid,243);
	return 1;
}
if(strcmp(cmdtext, "/vbfyst2", true) == 0 || strcmp(cmdtext, "/skin bitch 6", true) == 0)
{
	SetPlayerSkin(playerid,244);
	return 1;
}
if(strcmp(cmdtext, "/vhfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 7", true) == 0)
{
	SetPlayerSkin(playerid,207);
	return 1;
}
if(strcmp(cmdtext, "/vbfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 8", true) == 0)
{
	SetPlayerSkin(playerid,245);
	return 1;
}
if(strcmp(cmdtext, "/vhfyst3", true) == 0 || strcmp(cmdtext, "/skin bitch 9", true) == 0)
{
	SetPlayerSkin(playerid,246);
	return 1;
}
if(strcmp(cmdtext, "/vwfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 10", true) == 0)
{
	SetPlayerSkin(playerid,85);
	return 1;
}
if(strcmp(cmdtext, "/sbfystr", true) == 0 || strcmp(cmdtext, "/skin bitch 11", true) == 0)
{
	SetPlayerSkin(playerid,256);
	return 1;
}
if(strcmp(cmdtext, "/swfystr", true) == 0 || strcmp(cmdtext, "/skin bitch 12", true) == 0)
{
	SetPlayerSkin(playerid,257);
	return 1;
}
if(strcmp(cmdtext, "/hfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 13", true) == 0)
{
	SetPlayerSkin(playerid,64);
	return 1;
}
if(strcmp(cmdtext, "/bfypro", true) == 0 || strcmp(cmdtext, "/skin bitch 14", true) == 0)
{
	SetPlayerSkin(playerid,63);
	return 1;
}
if(strcmp(cmdtext, "/vwfyst1", true) == 0 || strcmp(cmdtext, "/skin bitch 15", true) == 0)
{
	SetPlayerSkin(playerid,87);
	return 1;
}
if(strcmp(cmdtext, "/wfyjg", true) == 0 || strcmp(cmdtext, "/skin bitch 16", true) == 0)
{
	SetPlayerSkin(playerid,90);
	return 1;
}
if(strcmp(cmdtext, "/heck1", true) == 0 || strcmp(cmdtext, "/skin sport 1", true) == 0)
{
	SetPlayerSkin(playerid,258);
	return 1;
}
if(strcmp(cmdtext, "/heck2", true) == 0 || strcmp(cmdtext, "/skin sport 2", true) == 0)
{
	SetPlayerSkin(playerid,259);
	return 1;
}
if(strcmp(cmdtext, "/wmybp", true) == 0 || strcmp(cmdtext, "/skin sport 3", true) == 0)
{
	SetPlayerSkin(playerid,26);
	return 1;
}
if(strcmp(cmdtext, "/bmymoun", true) == 0 || strcmp(cmdtext, "/skin sport 4", true) == 0)
{
	SetPlayerSkin(playerid,51);
	return 1;
}
if(strcmp(cmdtext, "/wmymoun", true) == 0 || strcmp(cmdtext, "/skin sport 5", true) == 0)
{
	SetPlayerSkin(playerid,52);
	return 1;
}
if(strcmp(cmdtext, "/vbmybox", true) == 0 || strcmp(cmdtext, "/skin sport 6", true) == 0)
{
	SetPlayerSkin(playerid,80);
	return 1;
}
if(strcmp(cmdtext, "/vwmybox", true) == 0 || strcmp(cmdtext, "/skin sport 7", true) == 0)
{
	SetPlayerSkin(playerid,81);
	return 1;
}
if(strcmp(cmdtext, "/wmybmx", true) == 0 || strcmp(cmdtext, "/skin sport 8", true) == 0)
{
	SetPlayerSkin(playerid,23);
	return 1;
}
if(strcmp(cmdtext, "/wmyjg", true) == 0 || strcmp(cmdtext, "/skin sport 9", true) == 0)
{
	SetPlayerSkin(playerid,96);
	return 1;
}
if(strcmp(cmdtext, "/wmyro", true) == 0 || strcmp(cmdtext, "/skin sport 10", true) == 0)
{
	SetPlayerSkin(playerid,99);
	return 1;
}
if(strcmp(cmdtext, "/vbfycrp", true) == 0 || strcmp(cmdtext, "/skin profession 1", true) == 0)
{
	SetPlayerSkin(playerid,11);
	return 1;
}
if(strcmp(cmdtext, "/sofybu", true) == 0 || strcmp(cmdtext, "/skin profession 2", true) == 0)
{
	SetPlayerSkin(playerid,141);
	return 1;
}
if(strcmp(cmdtext, "/wmybu", true) == 0 || strcmp(cmdtext, "/skin profession 3", true) == 0)
{
	SetPlayerSkin(playerid,147);
	return 1;
}
if(strcmp(cmdtext, "/bfybu", true) == 0 || strcmp(cmdtext, "/skin profession 4", true) == 0)
{
	SetPlayerSkin(playerid,148);
	return 1;
}
if(strcmp(cmdtext, "/wfybu", true) == 0 || strcmp(cmdtext, "/skin profession 5", true) == 0)
{
	SetPlayerSkin(playerid,150);
	return 1;
}
if(strcmp(cmdtext, "/wmyconb", true) == 0 || strcmp(cmdtext, "/skin profession 6", true) == 0)
{
	SetPlayerSkin(playerid,153);
	return 1;
}
if(strcmp(cmdtext, "/wmybell", true) == 0 || strcmp(cmdtext, "/skin profession 7", true) == 0)
{
	SetPlayerSkin(playerid,167);
	return 1;
}
if(strcmp(cmdtext, "/wmoprea", true) == 0 || strcmp(cmdtext, "/skin profession 8", true) == 0)
{
	SetPlayerSkin(playerid,68);
	return 1;
}
if(strcmp(cmdtext, "/vwmybjd", true) == 0 || strcmp(cmdtext, "/skin profession 9", true) == 0)
{
	SetPlayerSkin(playerid,171);
	return 1;
}
if(strcmp(cmdtext, "/bmybar", true) == 0 || strcmp(cmdtext, "/skin profession 10", true) == 0)
{
	SetPlayerSkin(playerid,176);
	return 1;
}
if(strcmp(cmdtext, "/wmybar", true) == 0 || strcmp(cmdtext, "/skin profession 11", true) == 0)
{
	SetPlayerSkin(playerid,177);
	return 1;
}
if(strcmp(cmdtext, "/vwfycrp", true) == 0 || strcmp(cmdtext, "/skin profession 12", true) == 0)
{
	SetPlayerSkin(playerid,172);
	return 1;
}
if(strcmp(cmdtext, "/wmyammo", true) == 0 || strcmp(cmdtext, "/skin profession 13", true) == 0)
{
	SetPlayerSkin(playerid,179);
	return 1;
}
if(strcmp(cmdtext, "/somybu", true) == 0 || strcmp(cmdtext, "/skin profession 14", true) == 0)
{
	SetPlayerSkin(playerid,187);
	return 1;
}
if(strcmp(cmdtext, "/wmyva", true) == 0 || strcmp(cmdtext, "/skin profession 15", true) == 0)
{
	SetPlayerSkin(playerid,189);
	return 1;
}
if(strcmp(cmdtext, "/omykara", true) == 0 || strcmp(cmdtext, "/skin profession 16", true) == 0)
{
	SetPlayerSkin(playerid,203);
	return 1;
}
if(strcmp(cmdtext, "/wmykara", true) == 0 || strcmp(cmdtext, "/skin profession 17", true) == 0)
{
	SetPlayerSkin(playerid,204);
	return 1;
}
if(strcmp(cmdtext, "/wmypizz", true) == 0 || strcmp(cmdtext, "/skin profession 18", true) == 0)
{
	SetPlayerSkin(playerid,155);
	return 1;
}
if(strcmp(cmdtext, "/wfyburg", true) == 0 || strcmp(cmdtext, "/skin profession 19", true) == 0)
{
	SetPlayerSkin(playerid,205);
	return 1;
}
if(strcmp(cmdtext, "/omonood", true) == 0 || strcmp(cmdtext, "/skin profession 20", true) == 0)
{
	SetPlayerSkin(playerid,209);
	return 1;
}
if(strcmp(cmdtext, "/wmyclot", true) == 0 || strcmp(cmdtext, "/skin profession 21", true) == 0)
{
	SetPlayerSkin(playerid,217);
	return 1;
}
if(strcmp(cmdtext, "/wfyclot", true) == 0 || strcmp(cmdtext, "/skin profession 22", true) == 0)
{
	SetPlayerSkin(playerid,211);
	return 1;
}
if(strcmp(cmdtext, "/sbfyri", true) == 0 || strcmp(cmdtext, "/skin profession 23", true) == 0)
{
	SetPlayerSkin(playerid,219);
	return 1;
}
if(strcmp(cmdtext, "/bmycon", true) == 0 || strcmp(cmdtext, "/skin profession 24", true) == 0)
{
	SetPlayerSkin(playerid, 260);
	return 1;
}
if(strcmp(cmdtext, "/bmyap", true) == 0 || strcmp(cmdtext, "/skin profession 25", true) == 0)
{
	SetPlayerSkin(playerid,16);
	return 1;
}
if(strcmp(cmdtext, "/wmycon", true) == 0 || strcmp(cmdtext, "/skin profession 26", true) == 0)
{
	SetPlayerSkin(playerid,27);
	return 1;
}
if(strcmp(cmdtext, "/wmoice", true) == 0 || strcmp(cmdtext, "/skin profession 27", true) == 0)
{
	SetPlayerSkin(playerid,264);
	return 1;
}
if(strcmp(cmdtext, "/wmosci", true) == 0 || strcmp(cmdtext, "/skin profession 28", true) == 0)
{
	SetPlayerSkin(playerid,70);
	return 1;
}
if(strcmp(cmdtext, "/sbmotr2", true) == 0 || strcmp(cmdtext, "/skin other 1", true) == 0)
{
	SetPlayerSkin(playerid,134);
	return 1;
}
if(strcmp(cmdtext, "/swmotr2", true) == 0 || strcmp(cmdtext, "/skin other 2", true) == 0)
{
	SetPlayerSkin(playerid,135);
	return 1;
}
if(strcmp(cmdtext, "/swmotr3", true) == 0 || strcmp(cmdtext, "/skin other 3", true) == 0)
{
	SetPlayerSkin(playerid,137);
	return 1;
}
if(strcmp(cmdtext, "/vwmycr", true) == 0 || strcmp(cmdtext, "/skin other 4", true) == 0)
{
	SetPlayerSkin(playerid,181);
	return 1;
}
if(strcmp(cmdtext, "/vwmotr2", true) == 0 || strcmp(cmdtext, "/skin other 5", true) == 0)
{
	SetPlayerSkin(playerid,213);
	return 1;
}
if(strcmp(cmdtext, "/vwmotr1", true) == 0 || strcmp(cmdtext, "/skin other 6", true) == 0)
{
	SetPlayerSkin(playerid,212);
	return 1;
}
if(strcmp(cmdtext, "/sofori", true) == 0 || strcmp(cmdtext, "/skin other 7", true) == 0)
{
	SetPlayerSkin(playerid,224);
	return 1;
}
if(strcmp(cmdtext, "/swmotr5", true) == 0 || strcmp(cmdtext, "/skin other 8", true) == 0)
{
	SetPlayerSkin(playerid,230);
	return 1;
}
if(strcmp(cmdtext, "/swmotr4", true) == 0 || strcmp(cmdtext, "/skin other 9", true) == 0)
{
	SetPlayerSkin(playerid,239);
	return 1;
}
if(strcmp(cmdtext, "/bmypimp", true) == 0 || strcmp(cmdtext, "/skin other 10", true) == 0)
{
	SetPlayerSkin(playerid,249);
	return 1;
}
if(strcmp(cmdtext, "/smyst", true) == 0 || strcmp(cmdtext, "/skin other 11", true) == 0)
{
	SetPlayerSkin(playerid,241);
	return 1;
}
if(strcmp(cmdtext, "/smyst2", true) == 0 || strcmp(cmdtext, "/skin other 12", true) == 0)
{
	SetPlayerSkin(playerid,242);
	return 1;
}
if(strcmp(cmdtext, "/wmyva2", true) == 0 || strcmp(cmdtext, "/skin other 13", true) == 0)
{
	SetPlayerSkin(playerid,252);
	return 1;
}
if(strcmp(cmdtext, "/bmosec", true) == 0 || strcmp(cmdtext, "/skin other 14", true) == 0)
{
	SetPlayerSkin(playerid,253);
	return 1;
}
if(strcmp(cmdtext, "/wmych", true) == 0 || strcmp(cmdtext, "/skin other 15", true) == 0)
{
	SetPlayerSkin(playerid,255);
	return 1;
}
if(strcmp(cmdtext, "/wmydrug", true) == 0 || strcmp(cmdtext, "/skin other 16", true) == 0)
{
	SetPlayerSkin(playerid,29);
	return 1;
}
if(strcmp(cmdtext, "/hmydrug", true) == 0 || strcmp(cmdtext, "/skin other 17", true) == 0)
{
	SetPlayerSkin(playerid,30);
	return 1;
}
if(strcmp(cmdtext, "/omokung", true) == 0 || strcmp(cmdtext, "/skin other 18", true) == 0)
{
	SetPlayerSkin(playerid,49);
	return 1;
}
if(strcmp(cmdtext, "/wmymech", true) == 0 || strcmp(cmdtext, "/skin other 19", true) == 0)
{
	SetPlayerSkin(playerid,50);
	return 1;
}
if(strcmp(cmdtext, "/omori", true) == 0 || strcmp(cmdtext, "/skin other 20", true) == 0)
{
	SetPlayerSkin(playerid,57);
	return 1;
}
if(strcmp(cmdtext, "/wmyplt", true) == 0 || strcmp(cmdtext, "/skin other 21", true) == 0)
{
	SetPlayerSkin(playerid,61);
	return 1;
}
if(strcmp(cmdtext, "/wmopj", true) == 0 || strcmp(cmdtext, "/skin other 22", true) == 0)
{
	SetPlayerSkin(playerid,62);
	return 1;
}
if(strcmp(cmdtext, "/bmypol1", true) == 0 || strcmp(cmdtext, "/skin other 23", true) == 0)
{
	SetPlayerSkin(playerid,66);
	return 1;
}
if(strcmp(cmdtext, "/swmyhp2", true) == 0 || strcmp(cmdtext, "/skin other 24", true) == 0)
{
	SetPlayerSkin(playerid,73);
	return 1;
}
if(strcmp(cmdtext, "/swmyhp2", true) == 0 || strcmp(cmdtext, "/skin other 25", true) == 0)
{
	SetPlayerSkin(playerid,77);
	return 1;
}
if(strcmp(cmdtext, "/wmotr1", true) == 0 || strcmp(cmdtext, "/skin other 26", true) == 0)
{
	SetPlayerSkin(playerid,78);
	return 1;
}
if(strcmp(cmdtext, "/bmotr1", true) == 0 || strcmp(cmdtext, "/skin other 27", true) == 0)
{
	SetPlayerSkin(playerid,78);
	return 1;
}
if(strcmp(cmdtext, "/vhmyelv", true) == 0 || strcmp(cmdtext, "/skin other 28", true) == 0)
{
	SetPlayerSkin(playerid,82);
	return 1;
}
if(strcmp(cmdtext, "/vbmyelv", true) == 0 || strcmp(cmdtext, "/skin other 29", true) == 0)
{
	SetPlayerSkin(playerid,83);
	return 1;
}
if(strcmp(cmdtext, "/vimyelv", true) == 0 || strcmp(cmdtext, "/skin other 30", true) == 0)
{
	SetPlayerSkin(playerid,84);
	return 1;
}
//=============================[BIG JUMPS]======================================
		if(strcmp(cmdtext, "/bj 1", true) == 0 || strcmp(cmdtext, "/bigjump 1", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	 			SetVehiclePos(GetPlayerVehicleID(playerid),2374.837,-1244.705,679.845);
			}
	        else
	        {
			    SetPlayerPos(playerid,2374.837,-1244.705,679.845);
				DynUpdateStart(playerid); // Avoid falling through object's

	  		}
			GameTextForPlayer(playerid, "bigjump 1",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj1 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 2", true) == 0 || strcmp(cmdtext, "/bigjump 2", true) == 0)
	    {
	    	TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	   			SetVehiclePos(GetPlayerVehicleID(playerid),2317.633,985.240,478.162);
	   	  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	        	LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	       		SetPlayerPos(playerid,2317.633,985.240,478.162);
       			DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "bigjump 2",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 2 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 3", true) == 0 || strcmp(cmdtext, "/bigjump 3", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),736.114,-170.768,732.878);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,736.114,-170.768,732.878);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
	 		GameTextForPlayer(playerid, "bigjump 3",1500,3);
		  	SetPlayerInterior(playerid, 0);
		  	ResetPlayerWeapons(playerid);
		  	SendClientMessage(playerid, COLOR_BD, "[传送] /bj 3 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 4", true) == 0 || strcmp(cmdtext, "/bigjump 4", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	        	SetVehiclePos(GetPlayerVehicleID(playerid),-1475.362,357.814,702.730);
	      	  	SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	          	LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				SetPlayerPos(playerid,-1475.362,357.814,702.730);
				DynUpdateStart(playerid); // Avoid falling through object's
	        }
	 		GameTextForPlayer(playerid, "bigjump 4",1500,3);
	 		SetPlayerInterior(playerid, 0);
	 		ResetPlayerWeapons(playerid);
	 		SendClientMessage(playerid, COLOR_BD, "[传送] /bj 4 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 5", true) == 0 || strcmp(cmdtext, "/bigjump 5", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1531.933,-1466.393,411.443);
		   	  	SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	   			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,1531.933,-1466.393,411.443);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "bigjump 5",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 5 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 6", true) == 0 || strcmp(cmdtext, "/bigjump 6", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2356.779541, -402.803222, 256.627258);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	   			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,2356.779541, -402.803222, 256.627258);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "bigjump 6",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 6 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 7", true) == 0 || strcmp(cmdtext, "/bigjump 7", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	 			SetVehiclePos(GetPlayerVehicleID(playerid),1994.139648, -2697.224853, 4002.686523);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	    		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,1994.139648, -2697.224853, 4002.686523);
        		DynUpdateStart(playerid); // Avoid falling through object's
	 		}
	  		GameTextForPlayer(playerid, "bigjump 7",1500,3);
		  	SetPlayerInterior(playerid, 0);
		  	ResetPlayerWeapons(playerid);
		  	SendClientMessage(playerid, COLOR_BD, "[传送] /bj 7 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/mj", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	 			SetVehiclePos(GetPlayerVehicleID(playerid),-398.150268, 1967.237915, 140.446701);
	 	  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 294.793975);
	      		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,-398.150268, 1967.237915, 140.446701);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
	 		GameTextForPlayer(playerid, "Multi-Jump!",1500,3);
		  	SetPlayerInterior(playerid, 0);
		  	ResetPlayerWeapons(playerid);
		  	SendClientMessage(playerid, COLOR_BD, "[传送] /mj 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/mj2", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	 			SetVehiclePos(GetPlayerVehicleID(playerid),-2117.119873, 844.559509, 406.680450);
	 	  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 175.820251);
	      		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,-2117.119873, 844.559509, 406.680450);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
	 		GameTextForPlayer(playerid, "Multi-Jump 2!",1500,3);
		  	SetPlayerInterior(playerid, 0);
		  	ResetPlayerWeapons(playerid);
		  	SendClientMessage(playerid, COLOR_BD, "[传送] /mj2 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/dj", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),264.339630, 5254.377441, 1009.047424);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 182.040237);
	    		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
         		SetPlayerPos(playerid,264.339630, 5254.377441, 1009.047424);
       			DynUpdateStart(playerid); // Avoid falling through object's

	        }
			GameTextForPlayer(playerid, "Drag Race",1500,3);
	 		TogglePlayerControllable(playerid, 1);
	  		SetPlayerInterior(playerid, 0);
	  		ResetPlayerWeapons(playerid);
	  		SendClientMessage(playerid, COLOR_BD, "[传送] /dj 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/uj", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),529.838378, 1340.934448, 586.680969);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 349.096099);
	     		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,529.838378, 1340.934448, 586.680969);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Ultimate Jump!",1500,3);
			SetPlayerInterior(playerid, 0);
	 		ResetPlayerWeapons(playerid);
	 		SendClientMessage(playerid, COLOR_BD, "[传送] /uj 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 8", true) == 0 || strcmp(cmdtext, "/bigjump 8", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1564.982056, -1272.263306, 703.560303);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	     		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,1564.982056, -1272.263306, 703.560303);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "bigjump 8",1500,3);
	 		SetPlayerInterior(playerid, 0);
	  		ResetPlayerWeapons(playerid);
	  		SendClientMessage(playerid, COLOR_BD, "[传送] /bj 8 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 9", true) == 0 || strcmp(cmdtext, "/bigjump 9", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-2506.1192, -701.3572, 282.2589);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 89.0);
	     		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				SetPlayerPos(playerid,-2506.1192, -701.3572, 282.2589);
				DynUpdateStart(playerid); // Avoid falling through object's
	  		}
			GameTextForPlayer(playerid, "bigjump 9",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 9 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 10", true) == 0 || strcmp(cmdtext, "/bigjump 10", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2760.7883, -1709.8051, 403.7497);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 89.0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,2760.7883, -1709.8051, 403.7497);
	        	DynUpdateStart(playerid); // Avoid falling through object's
			}
	 		GameTextForPlayer(playerid, "bigjump 10",1500,3);
			SetPlayerInterior(playerid, 0);
	 		ResetPlayerWeapons(playerid);
	 		SendClientMessage(playerid, COLOR_BD, "[传送] /bj 10 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 11", true) == 0 || strcmp(cmdtext, "/bigjump 11", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-1746.004150, 792.116943, 526.915283 );
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	     		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,-1746.004150, 792.116943, 526.915283);
				DynUpdateStart(playerid); // Avoid falling through object's
		    }
			GameTextForPlayer(playerid, "bigjump 11",1500,3);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 11 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 12", true) == 0 || strcmp(cmdtext, "/bigjump 12", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),300.215271, -1611.764038, 116.421875);
		  		SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid,300.215271, -1611.764038, 116.421875);
			}
			GameTextForPlayer(playerid, "bigjump 12",1500,3);
	 		SetPlayerInterior(playerid, 0);
	  		ResetPlayerWeapons(playerid);
	  		SendClientMessage(playerid, COLOR_BD, "[传送] /bj12 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/bj 13", true) == 0 || strcmp(cmdtext, "/bigjump 13", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	      		SetVehiclePos(GetPlayerVehicleID(playerid),1210.362671, 2532.845215, 306.509338);
	     	  	SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	         	LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	  			SetPlayerPos(playerid,1210.362671, 2532.845215, 306.509338);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "bigjump 13",1500,3);
			TogglePlayerControllable(playerid, 1);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 13 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }

	    if(strcmp(cmdtext, "/bj 14", true) == 0 || strcmp(cmdtext, "/bigjump 14", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2057.453125, 2435.582275, 166.992157);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,2057.453125, 2435.582275, 166.992157);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "bigjump 14",1500,3);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /bj 14 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/aj", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),859.973937, 2489.414550, 574.378967);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 293.391296);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,859.973937, 2489.414550, 574.378967);
	 			DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "OLDAIRPORT JUMP!",1500,3);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /aj 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/goingdown", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2027.654053, -1382.776978, 4235.146484);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,2027.654053, -1382.776978, 4235.146484);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "OMG, GOING DOWN!!!",1500,3);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /goingdown 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/drop", true) == 0 || strcmp(cmdtext, "/drop1", true) == 0)
	    {
	        TogglePlayerControllable(playerid, true);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),295.368804, 6793.837890, 4884.251953);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 178.929916);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,295.368804, 6793.837890, 4884.251953);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "CRAZY DROP!!!!",1500,3);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /drop 传送成功");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
//=======================[DEATH MATCHES]========================================
		if (strcmp(cmdtext, "/outdm", true)==0 || strcmp(cmdtext, "/tuichudm", true)==0 || strcmp(cmdtext, "/suiji", true)==0 || strcmp(cmdtext, "/chusheng", true)==0)
		{
			pDMPosition[playerid]=DM_NONE;
			new r = random(sizeof(spawns));
			SetPlayerPos(playerid, spawns[r][ex], spawns[r][ey], spawns[r][ez]);
			SetPlayerInterior(playerid, spawns[r][interior]);
			SendClientMessage(playerid, COLOR_WHITE, spawns[r][emsg]);
			ResetPlayerWeapons(playerid);
			DynUpdateStart(playerid); // Avoid falling through object's
			return 1;
		}
		if (strcmp(cmdtext, "/dm 1",true)==0 || strcmp(cmdtext, "/akDM",true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(AKSpawn));
			SetPlayerPos(playerid, AKSpawn[r][0], AKSpawn[r][1], AKSpawn[r][2]);
			GivePlayerWeapon(playerid, 30, 550);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			DynUpdateStart(playerid); // Avoid falling through object's
			SetPlayerInterior(playerid, 0);
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了Ak47死亡竞技 , 输入 /akDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 1", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_AK;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 2",true)==0 || strcmp(cmdtext, "/sniperDM",true)==0 || strcmp(cmdtext, "/jujidm",true)==0 || strcmp(cmdtext, "/zujidm",true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(SniperSpawn));
			SetPlayerPos(playerid, SniperSpawn[r][0], SniperSpawn[r][1], SniperSpawn[r][2]);
			GivePlayerWeapon(playerid, 34, 50);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			SetPlayerInterior(playerid, 0);
			DynUpdateStart(playerid); // Avoid falling through object's
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了狙击死亡竞技 , 输入 /sniperDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 2", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			SendClientMessage(playerid, COLOR_BD, "[注意] 请不要攻击出生在一起的队友哦.男子汉不是这样战斗的");
			pDMPosition[playerid]=DM_SNIPER;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 3",true)==0 || strcmp(cmdtext, "/townDM",true)==0)
		{
			new var13[25];
			SetPlayerInterior(playerid, 0);
			new r = random(sizeof(TownSpawn));
			SetPlayerPos(playerid, TownSpawn[r][0], TownSpawn[r][1], TownSpawn[r][2]);
			DynUpdateStart(playerid); // Avoid falling through object's
			ResetPlayerWeapons(playerid);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 25.0);
			GivePlayerWeapon(playerid, 34, 50);
			GivePlayerWeapon(playerid, 22, 300);
			GivePlayerWeapon(playerid, 26, 300);
			GivePlayerWeapon(playerid, 16, 5);
			GivePlayerWeapon(playerid, 4, 1);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			GetPlayerName(playerid, var13, 25);
			new var15[MAX_STRING];
			format(var15, MAX_STRING, "[DM] %s(%d): /dm 3", var13);
			//format(string, sizeof(string), " %s(%d):/townDM", name,playerid);
			SendClientMessageToAll(0xCCFFDD56, var15);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_TOWN;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 4", true)==0 || strcmp(cmdtext, "/beachDM", true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(BeachSpawn));
			SetPlayerPos(playerid, BeachSpawn[r][0], BeachSpawn[r][1], BeachSpawn[r][2]);
			DynUpdateStart(playerid); // Avoid falling through object's
			SetPlayerFacingAngle(playerid, 264.918304);
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid,name,18);
   			//format(string, sizeof(string), " %s 去了海滩死亡竞技! \"/beachdm\" 参加!!",name);
            format(string, sizeof(string), "[DM] %s(%d): /dm 4", name,playerid);
			SendClientMessageToAll(COLOR_YELLOW,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			SetPlayerInterior(playerid, 0);
			GivePlayerWeapon(playerid, 26, 300);
			GivePlayerWeapon(playerid, 32, 3000);
			//GivePlayerWeapon(playerid, 30, 9000);
			//GivePlayerWeapon(playerid, 32, 9000);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			pDMPosition[playerid]=DM_BEACH;
			return 1;
   		}
   		if (strcmp(cmdtext, "/dm 5",true)==0 || strcmp(cmdtext, "/ringDM",true)==0)
		{
			new name[MAX_PLAYER_NAME+1];

			SetPlayerInterior(playerid, 1);
			new r = random(sizeof(RingSpawn));
			SetPlayerPos(playerid, RingSpawn[r][0], RingSpawn[r][1], RingSpawn[r][2]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 9, 1);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			DynUpdateStart(playerid); // Avoid falling through object's
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了电锯死亡竞技 , 输入 /ringDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 5", name,playerid);
			SendClientMessage(playerid, COLOR_YELLOW, "[DM] 输入 /kill 能随时退出");
			SendClientMessage(playerid, COLOR_YELLOW, "[DM] 不要停止了您的电锯!");
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_RING;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 6",true)==0 || strcmp(cmdtext, "/farmDM",true)==0)
		{
			new var13[25];
			SetPlayerInterior(playerid, 0);
			new r = random(sizeof(FarmSpawn));
			SetPlayerPos(playerid, FarmSpawn[r][0], FarmSpawn[r][1], FarmSpawn[r][2]);
			DynUpdateStart(playerid); // Avoid falling through object's
			ResetPlayerWeapons(playerid);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			GivePlayerWeapon(playerid, 33, 50);
			GivePlayerWeapon(playerid, 22, 300);
			GivePlayerWeapon(playerid, 16, 2);
			GivePlayerWeapon(playerid, 4, 1);
			GetPlayerName(playerid, var13, 25);
			new var15[MAX_STRING];
   			format(var15, MAX_STRING, "[DM] %s(%d): /dm 6", var13);
   			//format(string, sizeof(string), " %s(%d):/farmDM", name,playerid);
			SendClientMessageToAll(0xCCFFDD56, var15);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_FARM;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 7",true)==0 || strcmp(cmdtext, "/smgDM",true)==0)
		{
			new name[MAX_PLAYER_NAME+1];
			SetPlayerInterior(playerid,10);
			new r = random(sizeof(BoxSpawn));
			SetPlayerPos(playerid, BoxSpawn[r][0], BoxSpawn[r][1], BoxSpawn[r][2]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid,29,1000);
			GivePlayerWeapon(playerid, 16, 2);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			DynUpdateStart(playerid); // Avoid falling through object's
			GetPlayerName(playerid, name, sizeof(name));
			format(string, sizeof(string), "[DM] %s(%d): /dm 7", name,playerid);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			SendClientMessageToAll(0xCCFFDD56,string);
			pDMPosition[playerid]=DM_BOX;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 8",true)==0 || strcmp(cmdtext, "/katanaDM",true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(KatanaSpawn));
			SetPlayerPos(playerid, KatanaSpawn[r][0], KatanaSpawn[r][1], KatanaSpawn[r][2]);
			GivePlayerWeapon(playerid, 8, 1);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			SetPlayerInterior(playerid, 0);
			DynUpdateStart(playerid); // Avoid falling through object's
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了卡塔纳死亡竞技 , 输入 /katanaDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 8", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_KATANA;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 9",true)==0 || strcmp(cmdtext, "/huoDM",true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(DildoSpawn));
			SetPlayerPos(playerid, DildoSpawn[r][0], DildoSpawn[r][1], DildoSpawn[r][2]);
			GivePlayerWeapon(playerid, 37, 1000);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			DynUpdateStart(playerid); // Avoid falling through object's
			SetPlayerInterior(playerid, 0);
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了阳具死亡竞技 , 输入 /dildoDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 9", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_DILDO;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 10",true)==0 || strcmp(cmdtext, "/boxDM",true)==0 || strcmp(cmdtext, "/quanjiDM",true)==0)
		{
		    SetPlayerInterior(playerid,10);
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(SmgSpawn));
			SetPlayerPos(playerid, SmgSpawn[r][0], SmgSpawn[r][1], SmgSpawn[r][2]);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			DynUpdateStart(playerid); // Avoid falling through object's
			SetPlayerInterior(playerid, 0);
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了SMG死亡竞技 , 输入 /smgDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /dm 10", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			SendFormatMessage(playerid, COLOR_BD, "[名人] xiaofei_cj 是这里的拳皇﹃_﹃");
			pDMPosition[playerid]=DM_SMG;
			return 1;
		}
		if (strcmp(cmdtext, "/dm 11", true)==0 || strcmp(cmdtext, "/rpgDM", true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(TankSpawn));
			SetPlayerPos(playerid, TankSpawn[r][0], TankSpawn[r][1], TankSpawn[r][2]);
			DynUpdateStart(playerid); // Avoid falling through object's
			SetPlayerFacingAngle(playerid, 270.248168);
			SetPlayerArmour(playerid, 80.0);
			SetPlayerHealth(playerid, 80.0);
			GivePlayerWeapon(playerid, 35, 20);
  			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid,name,18);
   			//format(string, sizeof(string), " %s 去了大脚车死亡竞技! \"/monstedm\" 参加!!",name);
   			format(string, sizeof(string), "[DM] %s(%d): /dm 11", name,playerid);
			SendClientMessageToAll(COLOR_YELLOW,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			SetPlayerInterior(playerid, 0);
			pDMPosition[playerid]=DM_TANK;
			return 1;
   		}
		if (strcmp(cmdtext, "/sumoDMvvg",true)==0)
		{
			new name[MAX_PLAYER_NAME+1];

			SetPlayerInterior(playerid,16);
			SetPlayerPos(playerid,-1401.0670,1265.3706,1039.8672);
			ResetPlayerWeapons(playerid);
			DynUpdateStart(playerid); // Avoid falling through object's
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string)," %s 去了撞车死亡竞技 , 输入 /sumoDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /sumoDM", name,playerid);
			SendClientMessage(playerid, COLOR_YELLOW, " !! 需要汽车 !!");
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			return 1;
		}
		if (strcmp(cmdtext, "/rocketDMvvg",true)==0)
		{
			ResetPlayerWeapons(playerid);
			new r = random(sizeof(RocketSpawn));
			SetPlayerPos(playerid, RocketSpawn[r][0], RocketSpawn[r][1], RocketSpawn[r][2]);
			GivePlayerWeapon(playerid, 36, 50);
			SetPlayerInterior(playerid, 0);
			DynUpdateStart(playerid); // Avoid falling through object's
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了RPG死亡竞技 , 输入 /rocketDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /rocketDM", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_ROCKET;
			return 1;
		}
		
		if (strcmp(cmdtext, "/tankDM2vvg",true)==0)
		{
			new name[MAX_PLAYER_NAME+1];

			SetPlayerInterior(playerid,10);
			ResetPlayerWeapons(playerid);
			//SetPlayerDMSpawn8(playerid);
			DynUpdateStart(playerid); // Avoid falling through object's
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了RC坦克死亡竞技 , 输入 /tankDM2 参加", name);
			format(string, sizeof(string), "[DM] %s(%d):/tankDM2", name,playerid);
			SendClientMessage(playerid, COLOR_YELLOW, " 遥控一辆坦克 按下 开火键 射击 击毁其他玩家");
			SendClientMessage(playerid, COLOR_YELLOW, "输入 /kill 能随时离开");
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			return 1;
		}
		if (strcmp(cmdtext, "/tennisDMvvg",true)==0)
		{
			ResetPlayerWeapons(playerid);

			new r = random(sizeof(TennisSpawn));
			SetPlayerPos(playerid, TennisSpawn[r][0], TennisSpawn[r][1], TennisSpawn[r][2]);
			GivePlayerWeapon(playerid, 16, 100);
			SetPlayerInterior(playerid, 0);
			DynUpdateStart(playerid); // Avoid falling through object's
			new name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid, name, sizeof(name));
			//format(string, sizeof(string), " %s 去了网球竞技 , 输入 /tennisDM 参加", name);
			format(string, sizeof(string), "[DM] %s(%d): /tennisDM", name,playerid);
			SendClientMessageToAll(0xCCFFDD56,string);
			SendClientMessage(playerid, COLOR_HD, "[DM] 退出DM: /outdm /tuichudm 更多DM见: /dm");
			pDMPosition[playerid]=DM_TENNIS;
			return 1;
		}
//===========================[STUNT PARKS]======================================
	    if(strcmp(cmdtext, "/lsair", true) == 0 || strcmp(cmdtext, "/ls", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1384.4961,-2442.0063,13.5547);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
		    	SetPlayerPos(playerid,1384.4961,-2442.0063,13.5547);
	        }
			GameTextForPlayer(playerid, "LS Airport!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/lvair", true) == 0 || strcmp(cmdtext, "/lv", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1282.6499,1267.8385,10.8203);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
	        	SetPlayerPos(playerid,1282.6499,1267.8385,10.8203);
	        }
			GameTextForPlayer(playerid, "LV Airport!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/sfair", true) == 0 || strcmp(cmdtext, "/sf", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-1645.2598,-201.1026,13.9188);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid,-1645.2598,-201.1026,13.9188);
	        }
			GameTextForPlayer(playerid, "SF Airport!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/aa", true) == 0 || strcmp(cmdtext, "/shamo", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),401.1484,2528.9482,16.5785);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid,401.1484,2528.9482,16.5785);
	        }
			GameTextForPlayer(playerid, "OLD Airport!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/chilliad", true) == 0 || strcmp(cmdtext, "/qiannian", true) == 0 || strcmp(cmdtext, "/qn", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-2245.3813,-1715.3920,480.3623);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 294.793975);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,-2245.3813,-1715.3920,480.3623);
        		DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Mount. Chilliad!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/grovest", true) == 0 || strcmp(cmdtext, "/grovestunt", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2485.032226, -1660.381469, 13.335947);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 67.055839);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid,2485.032226, -1660.381469, 13.335947);
				DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Groove ST!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
//------------------------------------------------------------------------------
//=======================[RACES]================================================
	    if(strcmp(cmdtext, "/idrace", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-647.708,2003.114,3.148);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.020889);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, -647.708,2003.114,3.148);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Insane Deadly Race!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/thrace", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),393.931,-2290.440,34.768);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.020889);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 393.931,-2290.440,34.768);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Town Hard Race!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/nrgocm", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2879.080,-768.508,15.519);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.020889);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, 2879.080,-768.508,15.519);
	        }
			GameTextForPlayer(playerid, "NRG Obstacle Course Madness!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			SendClientMessage(playerid, COLOR_BD, "[传送] /nrgocm 传送成功 这关需要运用狂按  的加速技巧哦");
	 		SendClientMessage(playerid, COLOR_FT, "[广告] 精彩过关视频下载:http://sa-mp.com.cn/files/LXD/");
			return 1;
	    }
	    if(strcmp(cmdtext, "/navy", true) == 0 || strcmp(cmdtext, "/pyz", true) == 0 || strcmp(cmdtext, "/dt", true) == 0 || strcmp(cmdtext, "/piaoyizhen", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-2274.8542,2356.2576,4.5880);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 271);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, -2261.1379,2290.6130,4.8202);
	        }
			GameTextForPlayer(playerid, "Welcome to Navy Docks!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
//------------------------------------------------------------------------------
//========================[OTHERS]==============================================
	    if(strcmp(cmdtext, "/halfpipe", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2852.071044, -1981.494506, 10.939374);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 223.120193);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2852.071044, -1981.494506, 10.939374);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Half Pipe!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/parkour", true) == 0 || strcmp(cmdtext, "/parkour 1", true) == 0 || strcmp(cmdtext, "/paoku 1", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1673.669311, -1343.364990, 158.476562);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.560180);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 1673.669311, -1343.364990, 158.476562);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Parkour!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/parkour 2", true) == 0 || strcmp(cmdtext, "/parkour 2", true) == 0 || strcmp(cmdtext, "/paoku 2", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),3945.4060,697.1454,35.5047);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.560180);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 3945.4060,697.1454,35.5047);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Parkour!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/bikepark", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),1866.433715, -1385.198242, 13.500531);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.875457);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, 1866.433715, -1385.198242, 13.500531);
	        }
			GameTextForPlayer(playerid, "Bike Park!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/carsumo", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),-1045.790893, 461.134429, 14.546875);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 303.595245);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, -1045.790893, 461.134429, 14.546875);
	        }
			GameTextForPlayer(playerid, "Car Sumo!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/4dragon", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid),2031.513427, 1009.574890, 10.820312);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 99.252632);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2031.513427, 1009.574890, 10.820312);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "4 Dragons!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/bikec", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), -1017.230895, 931.694030, 42.257812);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 143.379348);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, -1017.230895, 931.694030, 42.257812);
	        }
			GameTextForPlayer(playerid, "Bike Challenge!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }

	    if(strcmp(cmdtext, "/partyland", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), -1107.2866,-1191.4698,129.2188);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 81.020889);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
				DynUpdateStart(playerid); // Avoid falling through object's
				SetPlayerPos(playerid, -1107.2866,-1191.4698,129.2188);
	        }
			GameTextForPlayer(playerid, "Party Land!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/andromadavvgafs", true) == 0)
	    {
	        {
	        	SetPlayerPos(playerid, 315.85617, 1024.496459, 1949.797363);
				DynUpdateStart(playerid); // Avoid falling through object's
			}
			GameTextForPlayer(playerid, "Andromada Jumping!",1500,3);
	 		SetPlayerInterior(playerid, 9);
			TogglePlayerControllable(playerid, 1);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
//============================[BASE JUMPS]======================================
		if(strcmp(cmdtext, "/basejump 1",true)==0 || strcmp(cmdtext, "/ts 1",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,-1791.0409,567.7134,332.8019);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 2",true)==0 || strcmp(cmdtext, "/ts 2",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,1452.4982,-1072.8849,213.3828);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 3",true)==0 || strcmp(cmdtext, "/ts 3",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,1481.1073,-1790.5154,156.7533);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 4",true)==0 || strcmp(cmdtext, "/ts 4",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerPos(playerid,-1753.6823,885.5562,295.8750);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 5",true)==0 || strcmp(cmdtext, "/ts 5",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,-1278.9236,976.3959,139.2734);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 6",true)==0 || strcmp(cmdtext, "/ts 6",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,1966.3888,1912.6749,130.9375);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 7",true)==0 || strcmp(cmdtext, "/ts 7",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,2054.8530,2428.6870,165.6172);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 8",true)==0 || strcmp(cmdtext, "/ts 8",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,-2873.0127,2718.6343,275.6272);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}

		if(strcmp(cmdtext, "/basejump 9",true) == 0 || strcmp(cmdtext, "/ts 9",true)==0)
			{
				GivePlayerWeapon(playerid, 46, 1);
				SendClientMessage(playerid, 0x33AA33AA,"[跳伞] 准备跳伞...");
				SetPlayerInterior(playerid,0);
				SetPlayerPos(playerid,-2662.3618,1934.1034,225.757);
				GameTextForPlayer(playerid,"Have a Nice Jump",2500,3);
				return 1;
			}
//--------------------------------------------Stunt1
if(strcmp(cmdtext,"/st1",true)==0)
{
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2000.9987,-1964.1296,16.4661);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2000.9987,-1964.1296,16.4661);
SetVehicleZAngle(cartype,90.9997);}
else{
SetPlayerPos(playerid,2000.9987,-1964.1296,16.4661);}
GameTextForPlayer(playerid,"stuntzone 1!",2500,3);}
return 1;}
//--------------------------------------------Stunt2
if(strcmp(cmdtext,"/st2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2194.4121,-1894.8616,13.4990);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2194.4121,-1894.8616,13.4990);
SetVehicleZAngle(cartype,358.3977);}
else{
SetPlayerPos(playerid,2194.4121,-1894.8616,13.4990);}
GameTextForPlayer(playerid,"stuntzone 2",2500,3);}
return 1;}
//--------------------------------------------Stunt3
if(strcmp(cmdtext,"/st3",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2277.7007,-1409.9031,23.6778);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2277.7007,-1409.9031,23.6778);
SetVehicleZAngle(cartype,358.8591);}
else{
SetPlayerPos(playerid,2277.7007,-1409.9031,23.6778);}
GameTextForPlayer(playerid,"stuntzone 3",2500,3);}
return 1;}
//--------------------------------------------Stunt4
if(strcmp(cmdtext,"/st4",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2461.6616,-2643.2488,13.2853);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2461.6616,-2643.2488,13.2853);
SetVehicleZAngle(cartype,1.2267);}
else{
SetPlayerPos(playerid,2461.6616,-2643.2488,13.2853);}
GameTextForPlayer(playerid,"stuntzone 4",2500,3);}
return 1;}
//--------------------------------------------Stunt5
if(strcmp(cmdtext,"/st5",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,978.0306,-1270.7661,14.8376);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,978.0306,-1270.7661,14.8376);
SetVehicleZAngle(cartype,272.4298);}
else{
SetPlayerPos(playerid,978.0306,-1270.7661,14.8376);}
GameTextForPlayer(playerid,"stuntzone 5",2500,3);}
return 1;}
//--------------------------------------------Stunt6
if(strcmp(cmdtext,"/st6",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2730.2471,-1177.6521,69.1803);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2730.2471,-1177.6521,69.1803);
SetVehicleZAngle(cartype,270.4014);}
else{
SetPlayerPos(playerid,2730.2471,-1177.6521,69.1803);}
GameTextForPlayer(playerid,"stuntzone 6",2500,3);}
return 1;}
//--------------------------------------------Stunt7
if(strcmp(cmdtext,"/st7",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1617.9954,-1152.7574,56.7357);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1617.9954,-1152.7574,56.7357);
SetVehicleZAngle(cartype,352.1332);}
else{
SetPlayerPos(playerid,1617.9954,-1152.7574,56.7357);}
GameTextForPlayer(playerid,"stuntzone 7",2500,3);}
return 1;}
//--------------------------------------------Stunt8
if(strcmp(cmdtext,"/st8",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1685.1398,-924.0175,61.9844);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1685.1398,-924.0175,61.9844);
SetVehicleZAngle(cartype,171.1566);}
else{
SetPlayerPos(playerid,1685.1398,-924.0175,61.9844);}
GameTextForPlayer(playerid,"stuntzone 8",2500,3);}
return 1;}
//--------------------------------------------Stunt9
if(strcmp(cmdtext,"/st9",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,991.6937,-1215.7056,16.6194);}
else if(IsPlayerInVehicle(playerid,cartype) == 1)
{SetVehiclePos(cartype,991.6937,-1215.7056,16.6194);
SetVehicleZAngle(cartype,180.7928);}
else{
SetPlayerPos(playerid,991.6937,-1215.7056,16.6194);}
GameTextForPlayer(playerid,"stuntzone 9",2500,3);}
return 1;}
//--------------------------------------------Stunt10
if(strcmp(cmdtext,"/st10",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2005.1991,110.7437,29.4132);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2005.1991,110.7437,29.4132);
SetVehicleZAngle(cartype,263.2134);}
else{
SetPlayerPos(playerid,2005.1991,110.7437,29.4132);}
GameTextForPlayer(playerid,"stuntzone 10",2500,3);}
return 1;}
//--------------------------------------------Stunt11
if(strcmp(cmdtext,"/st11",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,640.4705,-476.7880,15.9588);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,640.4705,-476.7880,15.9588);
SetVehicleZAngle(cartype,177.2227);}
else{
SetPlayerPos(playerid,640.4705,-476.7880,15.9588);}
GameTextForPlayer(playerid,"stuntzone 11",2500,3);}
return 1;}
//--------------------------------------------Stunt12
if(strcmp(cmdtext,"/st12",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,41.0698,-209.7342,1.2393);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,41.0698,-209.7342,1.2393);
SetVehicleZAngle(cartype,235.6772);}
else{
SetPlayerPos(playerid,41.0698,-209.7342,1.2393);}
GameTextForPlayer(playerid,"stuntzone 12",2500,3);}
return 1;}
//--------------------------------------------Stunt13
if(strcmp(cmdtext,"/st13",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-84.9075,-20.2157,2.8875);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-84.9075,-20.2157,2.8875);
SetVehicleZAngle(cartype,340.9908);}
else{
SetPlayerPos(playerid,-84.9075,-20.2157,2.8875);}
GameTextForPlayer(playerid,"stuntzone 13",2500,3);}
return 1;}
//--------------------------------------------Stunt14
if(strcmp(cmdtext,"/st14",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-55.8228,7.6347,2.8901);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-55.8228,7.6347,2.8901);
SetVehicleZAngle(cartype,340.2266);}
else{
SetPlayerPos(playerid,-55.8228,7.6347,2.8901);}
GameTextForPlayer(playerid,"stuntzone 14",2500,3);}
return 1;}
//--------------------------------------------Stunt15
if(strcmp(cmdtext,"/st15",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2612.9600,1110.9343,55.8057);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2612.9600,1110.9343,55.8057);
SetVehicleZAngle(cartype,332.2554);}
else{
SetPlayerPos(playerid,-2612.9600,1110.9343,55.8057);}
GameTextForPlayer(playerid,"stuntzone 15",2500,3);}
return 1;}
//--------------------------------------------Stunt16
if(strcmp(cmdtext,"/st16",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2141.0120,-193.7642,35.0928);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2141.0120,-193.7642,35.0928);
SetVehicleZAngle(cartype,3.0810);}
else{
SetPlayerPos(playerid,-2141.0120,-193.7642,35.0928);}
GameTextForPlayer(playerid,"stuntzone 16",2500,3);}
return 1;}
//--------------------------------------------Stunt17
if(strcmp(cmdtext,"/st17",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1794.4094,1107.3928,44.8676);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1794.4094,1107.3928,44.8676);
SetVehicleZAngle(cartype,0.6520);}
else{
SetPlayerPos(playerid,-1794.4094,1107.3928,44.8676);}
GameTextForPlayer(playerid,"stuntzone 17",2500,3);}
return 1;}
//--------------------------------------------Stunt18
if(strcmp(cmdtext,"/st18",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2239.0266,1096.5077,79.6237);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2239.0266,1096.5077,79.6237);
SetVehicleZAngle(cartype,89.6385);}
else{
SetPlayerPos(playerid,-2239.0266,1096.5077,79.6237);}
GameTextForPlayer(playerid,"stuntzone 18",2500,3);}
return 1;}
//--------------------------------------------Stunt19
if(strcmp(cmdtext,"/st19",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2470.9924,722.8769,34.7882);}
else if(IsPlayerInVehicle(playerid,cartype) == 1)
{SetVehiclePos(cartype,-2470.9924,722.8769,34.7882);
SetVehicleZAngle(cartype,271.0016);}
else{
SetPlayerPos(playerid,-2470.9924,722.8769,34.7882);}
GameTextForPlayer(playerid,"stuntzone 19",2500,3);}
return 1;}
//--------------------------------------------Stunt20
if(strcmp(cmdtext,"/st20",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1651.0833,-202.3230,13.9221);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1651.0833,-202.3230,13.9221);
SetVehicleZAngle(cartype,44.1140);}
else{
SetPlayerPos(playerid,-1651.0833,-202.3230,13.9221);}
GameTextForPlayer(playerid,"stuntzone 20",2500,3);}
return 1;}
//--------------------------------------------Stunt21
if(strcmp(cmdtext,"/st21",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2332.0823,-2146.4771,13.5469);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2332.0823,-2146.4771,13.5469);
SetVehicleZAngle(cartype,191.3607);}
else{
SetPlayerPos(playerid,2332.0823,-2146.4771,13.5469);}
GameTextForPlayer(playerid,"stuntzone 21",2500,3);}
return 1;}
//--------------------------------------------Stunt22
if(strcmp(cmdtext,"/st22",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,341.8842,1022.9160,28.1525);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,341.8842,1022.9160,28.1525);
SetVehicleZAngle(cartype,358.0639);}
else{
SetPlayerPos(playerid,341.8842,1022.9160,28.1525);}
GameTextForPlayer(playerid,"stuntzone 22",2500,3);}
return 1;}
//---------------------------------------------parkour2
if(strcmp(cmdtext,"/parkour 3",true)==0 || strcmp(cmdtext,"/paoku 3",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,2604.8313,-1197.7937,66.2844);
GameTextForPlayer(playerid,"Nice area for it!",2500,3);}
return 1;}
//-------------------------------------------parkour3
if(strcmp(cmdtext,"/parkour 4",true)==0 || strcmp(cmdtext,"/paoku 4",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,1980.7704,-967.2654,46.8333);
GameTextForPlayer(playerid,"Saint[UK]'s row pt2",2500,3);}
return 1;}
//-------------------------------------------parkour4
if(strcmp(cmdtext,"/parkour 5",true)==0 || strcmp(cmdtext,"/paoku 5",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,2198.0002,-1978.2675,13.5524);
GameTextForPlayer(playerid,"Saint[UK]'s row pt3",2500,3);}
return 1;}
//-------------------------------------------parkour5
if(strcmp(cmdtext,"/parkour 6",true)==0 || strcmp(cmdtext,"/paoku 6",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,1786.9689,-1365.3862,15.7578);
GameTextForPlayer(playerid,"Saint[UK]'s row pt4",2500,3);}
return 1;}
//--------------------------------------------Weld
if(strcmp(cmdtext,"/weld",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2006.1238,2293.5125,10.4784);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2006.1238,2293.5125,10.4784);
SetVehicleZAngle(cartype,1.3401);}
else{
SetPlayerPos(playerid,2006.1238,2293.5125,10.4784);}
GameTextForPlayer(playerid,"Welcome to weld shop",2500,3);}
return 1;}
//--------------------------------------------TELEPORT Airport
if(strcmp(cmdtext,"/airport",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1282.6499,1267.8385,10.8203);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1282.6499,1267.8385,10.8203);
SetVehicleZAngle(cartype,324.4201);}
else{
SetPlayerPos(playerid,1282.6499,1267.8385,10.8203);}
GameTextForPlayer(playerid,"Welcome to LV Airport!",2500,3);}
return 1;}
//--------------------------------------------AIRPORT2
if(strcmp(cmdtext,"/airport2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1527.3297,-2455.9033,13.5547);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1527.3297,-2455.9033,13.5547);
SetVehicleZAngle(cartype,266.0000);}
else{
SetPlayerPos(playerid,1527.3297,-2455.9033,13.5547);}
GameTextForPlayer(playerid,"Welcome to LS Airport!",2500,3);}
return 1;}
//--------------------------------------------AIRPORT3
if(strcmp(cmdtext,"/airport3",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1645.2598,-201.1026,13.9188);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1645.2598,-201.1026,13.9188);
SetVehicleZAngle(cartype,43.8785);}
else{
SetPlayerPos(playerid,-1645.2598,-201.1026,13.9188);}
GameTextForPlayer(playerid,"Welcome to SF Airport!",2500,3);}
return 1;}
//-------------------------------------------plane
if(strcmp(cmdtext,"/plane",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-25.3183,2502.1665,16.2578);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-25.3183,2502.1665,16.2578);
SetVehicleZAngle(cartype,89.9987);}
else{
SetPlayerPos(playerid,-25.3183,2502.1665,16.2578);}
GameTextForPlayer(playerid,"BFP!!!",2500,3);}
return 1;}
//--------------------------------------------area69
if(strcmp(cmdtext,"/area69",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,216.0368,1911.4246,17.6406);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,216.0368,1911.4246,17.6406);
SetVehicleZAngle(cartype,90.0000);}
else{
SetPlayerPos(playerid,216.0368,1911.4246,17.6406);}
GameTextForPlayer(playerid,"Welcome to Area69",2500,3);}
return 1;}
//-------------------------------------------ball
if(strcmp(cmdtext,"/ball",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,-2080.5713,296.4200,69.7873);
GameTextForPlayer(playerid,"Oh Ball's!!!",2500,3);}
return 1;}
//---------------------------------------Base Jump!!!
if(strcmp(cmdtext,"/basejump",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1544.2968,-1354.2650,329.4727);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1544.2968,-1354.2650,329.4727);
SetVehicleZAngle(cartype,0.4678);}
else{
SetPlayerPos(playerid,1544.2968,-1354.2650,329.4727);}
GameTextForPlayer(playerid,"Welcome to Base Jump",2500,3);}
return 1;}
//------------------------------------------------Beach
if(strcmp(cmdtext,"/beach2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2941.4392,440.1520,3.0172);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2941.4392,440.1520,3.0172);
SetVehicleZAngle(cartype,179.0032);}
else{
SetPlayerPos(playerid,-2941.4392,440.1520,3.0172);}
GameTextForPlayer(playerid,"Welcome to the Beach",2500,3);}
return 1;}
//--------------------------------------------Bigjump
if(strcmp(cmdtext,"/bigjump",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-669.7441,2306.3635,135.4752);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-669.7441,2306.3635,135.4752);
SetVehicleZAngle(cartype,88.4296);}
else{
SetPlayerPos(playerid,-669.7441,2306.3635,135.4752);}
GameTextForPlayer(playerid,"Launch off the big jump!",2500,3);}
return 1;}
//--------------------------------------------BIG BOWL
if(strcmp(cmdtext,"/bowl",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1611.2828,164.6952,3.5547);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1611.2828,164.6952,3.5547);
SetVehicleZAngle(cartype,152.0583);}
else{
SetPlayerPos(playerid,-1611.2828,164.6952,3.5547);}
GameTextForPlayer(playerid,"big bowl!!",2500,3);}
return 1;}
//---------------------------------------------bridge
if(strcmp(cmdtext,"/bridge",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1519.8152,676.1623,139.2734);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1519.8152,676.1623,139.2734);
SetVehicleZAngle(cartype,316.0252);}
else{
SetPlayerPos(playerid,-1519.8152,676.1623,139.2734);}
GameTextForPlayer(playerid,"Can you make it up here by yourself?",2500,3);}
return 1;}
//---------------------------------------------bridge2
if(strcmp(cmdtext,"/bridge2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1128.3569,849.8029,84.0078);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1128.3569,849.8029,84.0078);
SetVehicleZAngle(cartype,125.6566);}
else{
SetPlayerPos(playerid,-1128.3569,849.8029,84.0078);}
GameTextForPlayer(playerid,"OMFG!!! Watch your balance",2500,3);}
return 1;}
//-----------------------------------------------cafe
if(strcmp(cmdtext,"/cafe",true)==0){
SetPlayerInterior(playerid,1);{
SetPlayerPos(playerid,-781.8113,489.3232,1376.1953);
GameTextForPlayer(playerid,"Punch up at Marco's Bistro!!!",2500,3);}
return 1;}
//--------------------------------------------cardealer
if(strcmp(cmdtext,"/cardealer",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1974.2872,270.7369,35.1719);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1974.2872,270.7369,35.1719);
SetVehicleZAngle(cartype,359.7314);}
else{
SetPlayerPos(playerid,-1974.2872,270.7369,35.1719);}
GameTextForPlayer(playerid,"Welcome to Car Dealer",2500,3);}
return 1;}
//--------------------------------------------carpalace
if(strcmp(cmdtext,"/carpalace",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1643.3248,1218.8916,7.0391);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1643.3248,1218.8916,7.0391);
SetVehicleZAngle(cartype,222.0000);}
else{
SetPlayerPos(playerid,-1643.3248,1218.8916,7.0391);}
GameTextForPlayer(playerid,"car palace!",2500,3);}
return 1;}
//--------------------------------------------cg
if(strcmp(cmdtext,"/cg",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-69.3315,-1132.8688,1.0781);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-69.3315,-1132.8688,1.0781);
SetVehicleZAngle(cartype,66.8035);}
else{
SetPlayerPos(playerid,-69.3315,-1132.8688,1.0781);}
GameTextForPlayer(playerid,"C and G Hut",2500,3);}
return 1;}
//--------------------------------------------Crooked
if(strcmp(cmdtext,"/crooked",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2129.1333,917.3199,79.8624);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2129.1333,917.3199,79.8624);
SetVehicleZAngle(cartype,267.2490);}
else{
SetPlayerPos(playerid,-2129.1333,917.3199,79.8624);}
GameTextForPlayer(playerid,"Welcome to Crooked Street",2500,3);}
return 1;}
//--------------------------------------------dam
if(strcmp(cmdtext,"/dam",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-762.0638,2063.2610,60.1875);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-762.0638,2063.2610,60.1875);
SetVehicleZAngle(cartype,91.6373);}
else{
SetPlayerPos(playerid,-762.0638,2063.2610,60.1875);}
GameTextForPlayer(playerid,"Dam Busters!",2500,3);}
return 1;}
//--------------------------------------------DERBY
if(strcmp(cmdtext,"/derby",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1383.4088,2184.9304,11.0234);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1383.4088,2184.9304,11.0234);
SetVehicleZAngle(cartype,132.3792);}
else{
SetPlayerPos(playerid,1383.4088,2184.9304,11.0234);}
GameTextForPlayer(playerid,"demolition derby!",2500,3);}
return 1;}
//--------------------------------------------drag
if(strcmp(cmdtext,"/drag",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1651.5035,-1931.4216,24.0100);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1651.5035,-1931.4216,24.0100);
SetVehicleZAngle(cartype,16.0901);}
else{
SetPlayerPos(playerid,1651.5035,-1931.4216,24.0100);}
GameTextForPlayer(playerid,"Verrry long Drag point!",2500,3);}
return 1;}
//-----------------------------------------------drop2
if(strcmp(cmdtext,"/drop2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2695.4519,-1047.8087,78.4216);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2695.4519,-1047.8087,78.4216);
SetVehicleZAngle(cartype,270.5289);}
else{
SetPlayerPos(playerid,2695.4519,-1047.8087,78.4216);}
GameTextForPlayer(playerid,"Welcome to Drop 1!",2500,3);}
return 1;}
//-----------------------------------------------drop3
if(strcmp(cmdtext,"/drop3",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2722.8638,-1202.3391,77.7174);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2722.8638,-1202.3391,77.7174);
SetVehicleZAngle(cartype,179.8688);}
else{
SetPlayerPos(playerid,2722.8638,-1202.3391,77.7174);}
GameTextForPlayer(playerid,"Welcome to Drop 2!",2500,3);}
return 1;}
//----------------------------------------------drop4
if(strcmp(cmdtext,"/drop4",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2642.6606,-1124.0916,76.1217);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2642.6606,-1124.0916,76.1217);
SetVehicleZAngle(cartype,178.9054);}
else{
SetPlayerPos(playerid,2642.6606,-1124.0916,76.1217);}
GameTextForPlayer(playerid,"Welcome to Drop 3!",2500,3);}
return 1;}
//-----------------------------------------------drop5
if(strcmp(cmdtext,"/drop5",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2261.1274,1008.3160,92.8595);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2261.1274,1008.3160,92.8595);
SetVehicleZAngle(cartype,180.6477);}
else{
SetPlayerPos(playerid,-2261.1274,1008.3160,92.8595);}
GameTextForPlayer(playerid,"Welcome to SF drag",2500,3);}
return 1;}
//--------------------------------------------dunes
if(strcmp(cmdtext,"/dunes",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2666.3081,-2418.3198,3.0000);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2666.3081,-2418.3198,3.0000);
SetVehicleZAngle(cartype,287.0157);}
else{
SetPlayerPos(playerid,-2666.3081,-2418.3198,3.0000);}
GameTextForPlayer(playerid,"beach dunes!!",2500,3);}
return 1;}
//--------------------------------------------eggs
if(strcmp(cmdtext,"/eggs",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,-2681.6519,1594.9670,217.2739);
GameTextForPlayer(playerid,"Go Away!!!",2500,3);}
return 1;}
//--------------------------------------------eggs2
if(strcmp(cmdtext,"/eggs2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2681.6519,1594.9670,217.2739);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2681.6519,1594.9670,217.2739);
SetVehicleZAngle(cartype,270.0253);}
else{
SetPlayerPos(playerid,-2681.6519,1594.9670,217.2739);}
GameTextForPlayer(playerid,"Go Away!!!",2500,3);}
return 1;}
//------------------------------------------field!!!
if(strcmp(cmdtext,"/field",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1139.9530,-1008.8403,129.2188);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1139.9530,-1008.8403,129.2188);
SetVehicleZAngle(cartype,180.0000);}
else{
SetPlayerPos(playerid,-1139.9530,-1008.8403,129.2188);}
GameTextForPlayer(playerid,"Drift Field!",2500,3);}
return 1;}
//--------------------------------------------Forest
if(strcmp(cmdtext,"/forest",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-496.4475,-188.3409,78.2797);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-496.4475,-188.3409,78.2797);
SetVehicleZAngle(cartype,268.9961);}
else{
SetPlayerPos(playerid,-496.4475,-188.3409,78.2797);}
GameTextForPlayer(playerid,"the forest",2500,3);}
return 1;}
//--------------------------------------------Graveyard
if(strcmp(cmdtext,"/graveyard",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-330.6945,2221.7065,42.4897);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-330.6945,2221.7065,42.4897);
SetVehicleZAngle(cartype,110.9196);}
else{
SetPlayerPos(playerid,-330.6945,2221.7065,42.4897);}
GameTextForPlayer(playerid,"graveyard r.i.p.",2500,3);}
return 1;}
//--------------------------------------------golf
if(strcmp(cmdtext,"/golf",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2277.4480,-386.9685,67.4771);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2277.4480,-386.9685,67.4771);
SetVehicleZAngle(cartype,120.4444);}
else{
SetPlayerPos(playerid,-2277.4480,-386.9685,67.4771);}
GameTextForPlayer(playerid,"Tee-off!",2500,3);}
return 1;}
//--------------------------------------------golf2
if(strcmp(cmdtext,"/golf2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1437.8885,2833.1636,10.8203);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1437.8885,2833.1636,10.8203);
SetVehicleZAngle(cartype,136.4890);}
else{
SetPlayerPos(playerid,1437.8885,2833.1636,10.8203);}
GameTextForPlayer(playerid,"Tee-off 2!",2500,3);}
return 1;}
//--------------------------------------------gym
if(strcmp(cmdtext,"/gym",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,2228.0334,-1723.2167,13.5531);
GameTextForPlayer(playerid,"Get in Shape lard ass!",2500,3);}
return 1;}
//--------------------------------------------hAZZARD
if(strcmp(cmdtext,"/hazzard",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2218.7546,91.4701,26.4844);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2218.7546,91.4701,26.4844);
SetVehicleZAngle(cartype,62.0806);}
else{
SetPlayerPos(playerid,2218.7546,91.4701,26.4844);}
GameTextForPlayer(playerid,"hazzard county",2500,3);}
return 1;}
//--------------------------------------------HIPPY
if(strcmp(cmdtext,"/hippy",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1097.5809,-1648.8492,76.3672);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1097.5809,-1648.8492,76.3672);
SetVehicleZAngle(cartype,265.0000);}
else{
SetPlayerPos(playerid,-1097.5809,-1648.8492,76.3672);}
GameTextForPlayer(playerid,"hippy pad!",2500,3);}
return 1;}
//-----------------hoboville
if(strcmp(cmdtext,"/hobo",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1308.3987,2506.6489,87.0420);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1308.3987,2506.6489,87.0420);
SetVehicleZAngle(cartype,15.5094);}
else{
SetPlayerPos(playerid,-1308.3987,2506.6489,87.0420);}
GameTextForPlayer(playerid,"hoboville!",2500,3);}
return 1;}
//--------------------------------------------hoop
if(strcmp(cmdtext,"/hoop",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2034.3971,1029.8380,10.5945);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2034.3971,1029.8380,10.5945);
SetVehicleZAngle(cartype,164.8500);}
else{
SetPlayerPos(playerid,2034.3971,1029.8380,10.5945);}
GameTextForPlayer(playerid,"loop da loop!",2500,3);}
return 1;}
//-----------------hotel
if(strcmp(cmdtext,"/hotel",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2758.1851,-281.7936,7.0391);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2758.1851,-281.7936,7.0391);
SetVehicleZAngle(cartype,46.2260);}
else{
SetPlayerPos(playerid,-2758.1851,-281.7936,7.0391);}
GameTextForPlayer(playerid,"the no tell hotel",2500,3);}
return 1;}
//--------------------------------------------inn
if(strcmp(cmdtext,"/inn",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2036.8822,1932.5518,12.1310);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2036.8822,1932.5518,12.1310);
SetVehicleZAngle(cartype,182.0129);}
else{
SetPlayerPos(playerid,2036.8822,1932.5518,12.1310);}
GameTextForPlayer(playerid,"holiday inn!",2500,3);}
return 1;}
//--------------------------------------Kanada's Drift Point
if(strcmp(cmdtext,"/kanada",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1467.0079,1847.0300,32.8336);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1467.0079,1847.0300,32.8336);
SetVehicleZAngle(cartype,95.1723);}
else{
SetPlayerPos(playerid,-1467.0079,1847.0300,32.8336);}
GameTextForPlayer(playerid,"Welcome to Kanada's Drift point!",2500,3);}
return 1;}
//--------------------------------------------keep on foot
if(strcmp(cmdtext,"/keep",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,-2015.3188,2269.7856,18.2150);
GameTextForPlayer(playerid,"Deathmatch Zone!!!",2500,3);}
return 1;}
//---------------------------------------keep2 in vehicle
if(strcmp(cmdtext,"/keep2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2015.3188,2269.7856,18.2150);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2015.3188,2269.7856,18.2150);
SetVehicleZAngle(cartype,60.9372);}
else{
SetPlayerPos(playerid,-2015.3188,2269.7856,18.2150);}
GameTextForPlayer(playerid,"Bring a vehicle to the fight!",2500,3);}
return 1;}
//-------------------------------------------------lc zyc
if(strcmp(cmdtext,"/lc",true)==0 || strcmp(cmdtext,"/zyc",true)==0 || strcmp(cmdtext,"/ziyoucheng",true)==0)
{
SetPlayerInterior(playerid,1);{
SetPlayerPos(playerid,-748.33,488.33,1372.33);
GameTextForPlayer(playerid,"Welcome to Liberty City!",2500,3);}
return 1;}
//-----------------------------------------------leap
if(strcmp(cmdtext,"/leap",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,1960.2781,1595.4114,75.7188);
GameTextForPlayer(playerid,"Leap of faith!!!",2500,3);}
return 1;}
//----------------------------------------------leap2
if(strcmp(cmdtext,"/leap2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1960.2781,1595.4114,75.7188);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1960.2781,1595.4114,75.7188);
SetVehicleZAngle(cartype,221.0863);}
else{
SetPlayerPos(playerid,1960.2781,1595.4114,75.7188);}
GameTextForPlayer(playerid,"Bring a vehicle to Leap of faith!!!",2500,3);}
return 1;}
//-------------------------------------------polejump
if(strcmp(cmdtext,"/pj",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,-383.9648,-494.4330,54.5625);
GameTextForPlayer(playerid,"Run and jump!!!",2500,3);}
return 1;}
//-----------------MAFIA1
if(strcmp(cmdtext,"/mafia1",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1149.0634,-2036.9148,69.0078);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1149.0634,-2036.9148,69.0078);
SetVehicleZAngle(cartype,269.5194);}
else{
SetPlayerPos(playerid,1149.0634,-2036.9148,69.0078);}
GameTextForPlayer(playerid,"mafia hideout",2500,3);}
return 1;}
//-----------------military
if(strcmp(cmdtext,"/military",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2743.7339,-2405.9058,13.4507);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2743.7339,-2405.9058,13.4507);
SetVehicleZAngle(cartype,87.4943);}
else{
SetPlayerPos(playerid,2743.7339,-2405.9058,13.4507);}
GameTextForPlayer(playerid,"welcome home soldier",2500,3);}
return 1;}
//--------------------------------------------motel
if(strcmp(cmdtext,"/motel",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2220.3696,-1140.6147,25.7969);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2220.3696,-1140.6147,25.7969);
SetVehicleZAngle(cartype,347.9058);}
else{
SetPlayerPos(playerid,2220.3696,-1140.6147,25.7969);}
GameTextForPlayer(playerid,"down low motel!",2500,3);}
return 1;}
//--------------------------------------------MOVIESET
if(strcmp(cmdtext,"/movieset",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,886.0962,-1217.8142,16.9766);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,886.0962,-1217.8142,16.9766);
SetVehicleZAngle(cartype,262.9998);}
else{
SetPlayerPos(playerid,886.0962,-1217.8142,16.9766);}
GameTextForPlayer(playerid,"movie set!",2500,3);}
return 1;}
//------------------------------------------------pier
if(strcmp(cmdtext,"/pier",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,383.6013,-2051.0151,7.8359);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,383.6013,-2051.0151,7.8359);
SetVehicleZAngle(cartype,42.4790);}
else{
SetPlayerPos(playerid,383.6013,-2051.0151,7.8359);}
GameTextForPlayer(playerid,"Welcome to Beach Pier!!",2500,3);}
return 1;}
//--------------------------------------------Pimp
if(strcmp(cmdtext,"/pimp",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,786.1298,-509.4973,16.8773);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,786.1298,-509.4973,16.8773);
SetVehicleZAngle(cartype,177.6599);}
else{
SetPlayerPos(playerid,786.1298,-509.4973,16.8773);}
GameTextForPlayer(playerid,"Welcome Home Pimp!",2500,3);}
return 1;}
//----------------------------------------------pool
if(strcmp(cmdtext,"/pool",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,2596.2161,2371.7339,47.4453);
GameTextForPlayer(playerid,"Jump for it!!!",2500,3);}
return 1;}
//------------------------------------------------pool2
if(strcmp(cmdtext,"/pool2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2596.2161,2371.7339,47.4453);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2596.2161,2371.7339,47.4453);
SetVehicleZAngle(cartype,49.3613);}
else{
SetPlayerPos(playerid,2596.2161,2371.7339,47.4453);}
GameTextForPlayer(playerid,"Jump for it!!!",2500,3);}
return 1;}
//--------------------------------------------police
if(strcmp(cmdtext,"/police",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2280.1506,2452.0774,10.8203);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2280.1506,2452.0774,10.8203);
SetVehicleZAngle(cartype,89.3546);}
else{
SetPlayerPos(playerid,2280.1506,2452.0774,10.8203);}
GameTextForPlayer(playerid,"Welcome to Police Station",2500,3);}
return 1;}
//--------------------------------------------RIVERBED
if(strcmp(cmdtext,"/rbed",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2584.1023,-1662.4365,2.0494);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2584.1023,-1662.4365,2.0494);
SetVehicleZAngle(cartype,179.9969);}
else{
SetPlayerPos(playerid,2584.1023,-1662.4365,2.0494);}
GameTextForPlayer(playerid,"Welcome to Da RiverBed",2500,3);}
return 1;}
//-----------------------------------------------Ridge
if(strcmp(cmdtext,"/ridge",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2869.6301,2678.7876,285.1329);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2869.6301,2678.7876,285.1329);
SetVehicleZAngle(cartype,267.7324);}
else{
SetPlayerPos(playerid,-2869.6301,2678.7876,285.1329);}
GameTextForPlayer(playerid,"Welcome to Ridge Jump!!",2500,3);}
return 1;}
//--------------------------------------------Rockman
if(strcmp(cmdtext,"/rockman",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1889.6552,-1644.8467,21.7500);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1889.6552,-1644.8467,21.7500);
SetVehicleZAngle(cartype,212.5083);}
else{
SetPlayerPos(playerid,-1889.6552,-1644.8467,21.7500);}
GameTextForPlayer(playerid,"Welcome to Rock Quarry",2500,3);}
return 1;}
//--------------------------------------------Quarry
if(strcmp(cmdtext,"/quarry",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,637.3473,871.5872,-42.9609);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,637.3473,871.5872,-42.9609);
SetVehicleZAngle(cartype,123.0766);}
else{
SetPlayerPos(playerid,637.3473,871.5872,-42.9609);}
GameTextForPlayer(playerid,"Welcome to the Rock Quarry",2500,3);}
return 1;}
//-------------------------------------------sb
if(strcmp(cmdtext,"/sb",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,2327.2976,566.4564,7.7813);
GameTextForPlayer(playerid,"docked jetmax's!!!",2500,3);}
return 1;}
//--------------------------------------------SKATE PARK
if(strcmp(cmdtext,"/skatepark",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1880.9452,-1394.7611,13.1246);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1880.9452,-1394.7611,13.1246);
SetVehicleZAngle(cartype,304.2583);}
else{
SetPlayerPos(playerid,1880.9452,-1394.7611,13.1246);}
GameTextForPlayer(playerid,"Skatepark!",2500,3);}
return 1;}
//-------------------------SV
if(strcmp(cmdtext,"/sv",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2261.1379,2290.6130,4.8202);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2261.1379,2290.6130,4.8202);
SetVehicleZAngle(cartype,360.0000);}
else{
SetPlayerPos(playerid,-2261.1379,2290.6130,4.8202);}
GameTextForPlayer(playerid,"Welcome to SV",2500,3);}
return 1;}
//--------------------------------------------5towers
if(strcmp(cmdtext,"/5towers",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1649.2350,-1677.8900,21.4301);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1649.2350,-1677.8900,21.4301);
SetVehicleZAngle(cartype,178.9641);}
else{
SetPlayerPos(playerid,1649.2350,-1677.8900,21.4301);}
GameTextForPlayer(playerid,"Welcome to 5 Towers",2500,3);}
return 1;}
//------------------------------------------Tierra Robada
if(strcmp(cmdtext,"/tie",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-533.4955,2592.4180,53.4154);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-533.4955,2592.4180,53.4154);
SetVehicleZAngle(cartype,270.4511);}
else{
SetPlayerPos(playerid,-533.4955,2592.4180,53.4154);}
GameTextForPlayer(playerid,"Welcome to Tierra Robada!",2500,3);}
return 1;}
//----------------------------------------------tree
if(strcmp(cmdtext,"/tree",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,-733.3952,-1916.3763,79.8056);
GameTextForPlayer(playerid,"Deathmatch Zone!!!",2500,3);}
return 1;}
//--------------------------------------------tree2
if(strcmp(cmdtext,"/tree2",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-733.3952,-1916.3763,79.8056);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-733.3952,-1916.3763,79.8056);
SetVehicleZAngle(cartype,194.3837);}
else{
SetPlayerPos(playerid,-733.3952,-1916.3763,79.8056);}
GameTextForPlayer(playerid,"Bring a vehicle to the fight!",2500,3);}
return 1;}
//----------------------------------------------Tunnel
if(strcmp(cmdtext,"/tunnel",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1409.2642,-1328.0328,8.5632);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1409.2642,-1328.0328,8.5632);
SetVehicleZAngle(cartype,180.3060);}
else{
SetPlayerPos(playerid,1409.2642,-1328.0328,8.5632);}
GameTextForPlayer(playerid,"Welcome to the Tunnel",2500,3);}
return 1;}
//---------------------------------------andrew's place
if(strcmp(cmdtext,"/andy",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-377.0659,-1441.3119,25.7032);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-377.0659,-1441.3119,25.7032);
SetVehicleZAngle(cartype,0.3985);}
else{
SetPlayerPos(playerid,-377.0659,-1441.3119,25.7032);}
GameTextForPlayer(playerid,"Welcome to Andrew's place!",2500,3);}
return 1;}
//-------------------------------------------bunny
if(strcmp(cmdtext,"/buns",true)==0){
SetPlayerInterior(playerid,0);{
SetPlayerPos(playerid,1276.0300,2522.3987,10.8203);
GameTextForPlayer(playerid,"House of bunnyjump",2500,3);}
return 1;}
//--------------------------------------------fcs
if(strcmp(cmdtext,"/fcs",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2442.6572,1548.5519,20.2344);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2442.6572,1548.5519,20.2344);
SetVehicleZAngle(cartype,182.0000);}
else{
SetPlayerPos(playerid,-2442.6572,1548.5519,20.2344);}
GameTextForPlayer(playerid,"Welcome to the love boat",2500,3);}
return 1;}
//--------------------------------------------rb hq
if(strcmp(cmdtext,"/hqrb",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1281.1615,-831.0143,83.1406);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1281.1615,-831.0143,83.1406);
SetVehicleZAngle(cartype,359.9999);}
else{
SetPlayerPos(playerid,1281.1615,-831.0143,83.1406);}
GameTextForPlayer(playerid,"Ruff Boyz HQ",2500,3);}
return 1;}
//----------------------------------------admin's rooftop
if(strcmp(cmdtext,"/adminhq",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1975.9822,1916.4415,130.9345);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1975.9822,1916.4415,130.9345);
SetVehicleZAngle(cartype,355.5803);}
else{
SetPlayerPos(playerid,1975.9822,1916.4415,130.9345);}
GameTextForPlayer(playerid,"Welcome to admin's rooftop",2500,3);}
return 1;}
//--------------------------------------------srs
if(strcmp(cmdtext,"/srs",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-1429.2487,-952.5726,200.9666);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-1429.2487,-952.5726,200.9666);
SetVehicleZAngle(cartype,260.3735);}
else{
SetPlayerPos(playerid,-1429.2487,-952.5726,200.9666);}
GameTextForPlayer(playerid,"Sniper rifle in hut",2500,3);}
return 1;}
//--------------------------------------------water
if(strcmp(cmdtext,"/water",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-182.4991,-638.5092,-0.1008);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-182.4991,-638.5092,-0.1008);
SetVehicleZAngle(cartype,280.1208);}
else{
SetPlayerPos(playerid,-182.4991,-638.5092,-0.1008);}
GameTextForPlayer(playerid,"Got stuck huh?",2500,3);}
return 1;}
//--------------------------------------------Crooked
if(strcmp(cmdtext,"/crooked",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-2129.1333,917.3199,79.8624);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-2129.1333,917.3199,79.8624);
SetVehicleZAngle(cartype,267.2490);}
else{
SetPlayerPos(playerid,-2129.1333,917.3199,79.8624);}
GameTextForPlayer(playerid,"Welcome to Crooked Street",2500,3);}
return 1;}
//--------------------------------------------Crucio HQ
if(strcmp(cmdtext,"/cc",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,-690.4940,917.8240,12.2079);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,-690.4940,917.8240,12.2079);
SetVehicleZAngle(cartype,356.1463);}
else{
SetPlayerPos(playerid,-690.4940,917.8240,12.2079);}
GameTextForPlayer(playerid,"Crucio clan HQ",2500,3);}
return 1;}
//------------------------------------------------tools
if(strcmp(cmdtext,"/tools",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2149.9751,942.9152,10.6719);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2149.9751,942.9152,10.6719);
SetVehicleZAngle(cartype,180.7417);}
else{
SetPlayerPos(playerid,2149.9751,942.9152,10.6719);}
GameTextForPlayer(playerid,"Get tooled up!!",2500,3);}
return 1;}
//-----------------------------------------pyramid height's > seif's place
if(strcmp(cmdtext,"/seif",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,2323.7029,1283.2653,97.6163);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,2323.7029,1283.2653,97.6163);
SetVehicleZAngle(cartype,88.4265);}
else{
SetPlayerPos(playerid,2323.7029,1283.2653,97.6163);}
GameTextForPlayer(playerid,"Welcome to seif's place",2500,3);}
return 1;}
//-----------------------------------------francis' place
if(strcmp(cmdtext,"/frank",true)==0){
new cartype=GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
SetPlayerInterior(playerid,0);{
if(State!=PLAYER_STATE_DRIVER){
SetPlayerPos(playerid,1465.033447, 1919.972167, 11.460937);}
else if(IsPlayerInVehicle(playerid,cartype)==1){
SetVehiclePos(cartype,1471.254638, 1925.026367, 11.338704);
SetVehicleZAngle(cartype,269);}
else{
SetPlayerPos(playerid,1465.033447, 1919.972167, 11.460937);}
GameTextForPlayer(playerid,"Welcome to francis' place",2500,3);}
return 1;}
//==========================[MISC]==============================================
	    if (strcmp("/admincity1337", cmdtext, true, 10) == 0)
		{
			SetPlayerPos(playerid,2717.3059,-3013.0869,4.5331);
			SetPlayerFacingAngle(playerid, 266.1166);
			SendClientMessage(playerid, COLOR_GREEN, "Welcome to Admin City");
			DynUpdateStart(playerid); // Avoid falling through object's
	        return 1;
		 }
//------------------------------------------------------------------------------
//================================[DRIFTS]======================================
	    if(strcmp(cmdtext, "/drift 1", true) == 0 || strcmp(cmdtext, "/piaoyi 1", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 2089.9773,2431.0759,49.5234);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2089.9773,2431.0759,49.5234);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Drift 1!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/drift 2", true) == 0 || strcmp(cmdtext, "/piaoyi 2", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), -2408.3521,-599.5757,132.6484);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, -2408.3521,-599.5757,132.6484);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Drift 2!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/drift 3", true) == 0 || strcmp(cmdtext, "/piaoyi 3", true) == 0 || strcmp(cmdtext, "/ldz", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), -353.8616,1530.5092,75.1320);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, -326.4971,1508.1768,75.5625);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Drift 3!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/drift 4", true) == 0 || strcmp(cmdtext, "/piaoyi 4", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 2265.6292,1398.5432,42.4766);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2265.6292,1398.5432,42.4766);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Drift 4!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/drift 5", true) == 0 || strcmp(cmdtext, "/piaoyi 5", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 2235.1140,1963.4467,31.6547);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2235.1140,1963.4467,31.6547);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Drift 5!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/lvxingshe", true) == 0 || strcmp(cmdtext, "/lygs", true) == 0 || strcmp(cmdtext, "/bmw", true) == 0 || strcmp(cmdtext, "/daoyou", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 1475.8315,2769.1665,10.9209);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 1473.9849,2860.9988,10.8247);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "lv xing she",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/zhanjian", true) == 0 || strcmp(cmdtext, "/parkour 6", true) == 0 || strcmp(cmdtext, "/paoku 6", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 1678.0054, -1337.3616, 158.4766);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 1884.2949,-1463.4733,192.9261);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "zhanjian",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/hdcs", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 5670.0400,-4614.8628,-16.2370);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 5676.9941,-4618.9248,-15.2854);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "hdcs",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
//------------------------------------------------------------------------------
//==========================[TUNES]=============================================
	    if(strcmp(cmdtext, "/arch", true) == 0 || strcmp(cmdtext, "/gaiche 2", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), -2712.8408,217.7281,5.2436);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, -2712.8408,217.7281,5.2436);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "ARCH!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/trans", true) == 0 || strcmp(cmdtext, "/gaiche 1", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 2385.7163,1012.6401,10.5273);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2385.7163,1012.6401,10.5273);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "TRANSFENDER!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/loco", true) == 0 || strcmp(cmdtext, "/gaiche 3", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 2645.1208,-2018.3188,13.3512);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 2645.1208,-2018.3188,13.3512);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Loco low Do!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
	    }
	    if(strcmp(cmdtext, "/bombshop", true) == 0 || strcmp(cmdtext, "/bombshop", true) == 0)
	    {

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				SetVehiclePos(GetPlayerVehicleID(playerid), 1829.6621,-1856.1829,13.2850);
	 			SetVehicleZAngle(GetPlayerVehicleID(playerid), 266.6323);
	  			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
			}
	        else
	        {
	        	SetPlayerPos(playerid, 1829.6621,-1856.1829,13.2850);
	        	DynUpdateStart(playerid); // Avoid falling through object's
	        }
			GameTextForPlayer(playerid, "Bomb Shop!",1500,3);
			TogglePlayerControllable(playerid, 1);
	 		SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			return 1;
   }
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
		else
		{
		format(string, sizeof(string), "[错误] %s 这个命令不存在,/help查看能使用的命令", cmdtext);
		SendClientMessage(playerid, COLOR_WHITE, string);
		}
		return 1;
	}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
public OnGameModeInit(){


    SetDisabledWeapons(43,44,45);
    AddOthers();     //Others
    AddSkins();      //Skins
	lbt = TextDrawCreate(-1.000000,2.000000,"---");
	lbb = TextDrawCreate(0.000000,337.000000,"---");
	TextDrawUseBox(lbt,1);
	TextDrawBoxColor(lbt,0x000000ff);
	TextDrawTextSize(lbt,640.000000,-69.000000);
	TextDrawUseBox(lbb,1);
	TextDrawBoxColor(lbb,0x000000ff);
	TextDrawTextSize(lbb,638.000000,-60.000000);
	TextDrawAlignment(lbt,0);
	TextDrawAlignment(lbb,0);
	TextDrawBackgroundColor(lbt,0x000000ff);
	TextDrawBackgroundColor(lbb,0x000000ff);
	TextDrawFont(lbt,3);
	TextDrawLetterSize(lbt,1.000000,12.199999);
	TextDrawFont(lbb,3);
	TextDrawLetterSize(lbb,0.899999,15.000000);
	TextDrawColor(lbt,0x000000ff);
	TextDrawColor(lbb,0x000000ff);
	TextDrawSetOutline(lbt,1);
	TextDrawSetOutline(lbb,1);
	TextDrawSetProportional(lbt,1);
	TextDrawSetProportional(lbb,1);
	TextDrawSetShadow(lbt,1);
	TextDrawSetShadow(lbb,1);
/*	Uranus1 = CreateVehicle(558,350.2055,2459.4592,16.0787,267.4406,1,1,-1); // Uranus1
	Elegy1 = CreateVehicle(562,346.6538,2467.8552,16.1432,357.1716,101,1,-1); // Elegy1
	Sultan1 = CreateVehicle(560,361.1407,2466.6042,16.1885,358.9384,17,1,-1); // Sultan1
	Uranus2 = CreateVehicle(558,360.1601,2458.9983,16.0735,267.3152,1,1,-1); // Uranus2
	Elegy2 = CreateVehicle(562,337.1456,2467.9075,16.1377,353.3522,101,1,-1); // Elegy2
	Sultan2 = CreateVehicle(560,361.1407,2466.6042,16.1885,358.9384,17,1,-1); // Sultan2
	TuneCar();*/
	//SetTimer("ReactionTest",1000*60,false);
	//SetTimer("ReactionTest",time1+random(time2),true);
	SetTimer("Sync_pScore",1000*3,true);
}

public OnGameModeExit(){
   	KillTimer(ConnectTimer);
	TextDrawHideForAll(lbt);
	TextDrawHideForAll(lbb);
	TextDrawDestroy(lbt);
	TextDrawDestroy(lbb);
   return 1;
}

public OnVehicleSpawn(vehicleid){
	SetTimer("TuneCar",1000,0);
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public OnPlayerPrivmsg(playerid, recieverid, text[]){
    SendedPM[playerid] += 1;
    new SenderName[24], RecName[24], string[128];
    if(!IsPlayerConnected(recieverid))
    {
        format(string, sizeof(string), "There isn't anyone connected with ID %i", recieverid);
        SendClientMessage(playerid, COLOR_CYAN, string);
        return true;
    }
	if(recieverid == playerid)
    {
        SendClientMessage(playerid, COLOR_CYAN, "[错误] 您不能和自己说悄悄话!");
        return true;
    }
    GetPlayerName(playerid, SenderName, sizeof(SenderName));
    GetPlayerName(recieverid, RecName, sizeof(RecName));
    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Private message ~r~Sent~w~.", 3000, 3);
    GameTextForPlayer(recieverid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Private message ~r~Recieved~w~.", 3000, 3);
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    PlayerPlaySound(recieverid,1057,0.0,0.0,0.0);
    format(string, sizeof(string), "        密语来自 %s(%i): %s", SenderName, playerid, text);
    SendClientMessage(recieverid, COLOR_CYAN, string);
    format(string, sizeof(string), "        密语给 %s(%i): %s", RecName, recieverid, text);
    SendClientMessage(playerid, COLOR_CYAN, string);
    return 0;
}

public OnPlayerText(playerid, text[]){
	SendedMess[playerid]++;
	/*if(ReactionTest_ && !strcmp(text, reactionstr, false)){
        if(reactioninprog == 2){// ReactionWin(playerid);
			GivePlayerMoney(playerid, 50000);
			new reactionwinner[MAX_STRING];
			reactionwinnerid = playerid;
			new tempstring[MAX_STRING];
			GetPlayerName(playerid,reactionwinner,sizeof(reactionwinner));
			format(tempstring, sizeof(tempstring), "[游戏]%s 赢得了反应试验! **", reactionwinner);
			SendClientMessageToAll(COLOR_YELLOW, tempstring);
			reactioninprog = 1;
			ReactionTest_ = false;
		}
        if(reactioninprog == 1){
            if(reactionwinnerid == playerid)
            {
                SendClientMessage(playerid, COLOR_GREEN, "[游戏] 您赢得了反应测试.");
            }
            else
            {
                SendClientMessage(playerid, COLOR_GREEN, "[游戏] 太慢了! 有人已经赢得了反应测试");
            }
        }
	}else */if(text[0] == '!' && text[1]){
        if(playerGang[playerid] > 0){
            new senderName[MAX_PLAYER_NAME];
            new string[MAX_STRING];
            GetPlayerName(playerid, senderName, sizeof(senderName));
            format(string, sizeof(string),"%s: %s", senderName, text[1]);
            for(new i = 0; i < gangInfo[playerGang[playerid]][1]; i++) {
				SendClientMessage(gangMembers[playerGang[playerid]][i], COLOR_LIGHTBLUE, string);
            }
        }
        return 0;
    }//else{
		SendFormatMessageToAll(GetPlayerColor(playerid),"    %s(%i): %s",ReturnPlayerName(playerid),playerid,text);
		//return false;
	//}
    return false;
}


public ReactionTest(){	
	ReactionTest_ = true;
	reactionstr = "";
	new str[MAX_STRING];
	new random_set[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	for (new i = 0; i < 8; i++)
	{
		reactionstr[i] = random_set[random(sizeof(random_set))];
	}
	reactioninprog = 2;
	format(str, sizeof(str), "[游戏] 第一个输入 %s 的玩家将会赢得 50000$!", reactionstr);
	SendClientMessageToAll(COLOR_YELLOW,str);
}

public ReactionWin(playerid){
	GivePlayerMoney(playerid, 50000);
	new reactionwinner[MAX_STRING];
	reactionwinnerid = playerid;
	new tempstring[MAX_STRING];
	GetPlayerName(playerid,reactionwinner,sizeof(reactionwinner));
	format(tempstring, sizeof(tempstring), "[游戏] %s 赢得了反应测试! 牛年牛运!!!", reactionwinner);
	SendClientMessageToAll(COLOR_YELLOW, tempstring);
	reactioninprog = 1;
}

public PlayerLeaveGang(playerid) {
	new string[MAX_STRING];
	new playername[MAX_PLAYER_NAME];
	new gangnum = playerGang[playerid];

    if(gangnum > 0) {
		for(new i = 0; i < gangInfo[gangnum][1]; i++) {
			if(gangMembers[gangnum][i]==playerid) {

			    //One less gang member
			    gangInfo[gangnum][1]--;

      		    for(new j = i; j < gangInfo[gangnum][1]; j++) {
				    //Shift gang members
				    gangMembers[gangnum][j]=gangMembers[gangnum][j+1];
	    		}

			    //Disband gang if no more members
			    if(gangInfo[gangnum][1]<1) {
			        gangInfo[gangnum][0]=0;
			        gangInfo[gangnum][1]=0;
       			}

				//Notify other members
				for(new j = 0; j < gangInfo[gangnum][1]; j++) {
				    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
					format(string, sizeof(string),"[帮派] %s 退出了您的帮派.", playername);
					SendClientMessage(gangMembers[gangnum][j], COLOR_ORANGE, string);
				}

				format(string, sizeof(string),"[帮派] 您退出了帮派 '%s' (id: %d)", gangNames[gangnum], gangnum);
				SendClientMessage(playerid, COLOR_ORANGE, string);

				playerGang[playerid]=0;

				SetPlayerColor(playerid,playerColors[playerid]);

				return;
			}
		}
	} else {
		SendClientMessage(playerid, COLOR_RED, "[错误] 您没有在帮派里.");
	}
}
/*public TuneCar()
{
	//There are the components for when the vehicle respawns
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
*/
public OnPlayerExitVehicle(playerid, vehicleid){
	VehicleExits[playerid] += 1;
	
	/*for (new i=0; i<MAX_PLAYERS; i++)
	{
		if (jumped[i] != -1) DestroyObject(jumped[i]);
	}*/

	if (GetPlayerVehicleID(playerid) == 564)
	{
		new Float:xpp;
		new Float:ypp;
		new Float:zpp;
		GetVehiclePos(vehicleid, Float:xpp, Float:ypp, Float:zpp);
		SetPlayerPos(playerid, xpp, ypp, zpp);
	}

return 1;
}
//---------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------
public OnPlayerSelectedMenuRow(playerid, row){
	return 1;
}
    
public OnPlayerExitedMenu(playerid){
	TogglePlayerControllable(playerid,1);
	HideMenuForPlayer(GetPlayerMenu(playerid),playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid){
	SetPlayerCameraPos(playerid, -2672.529541, 1410.453491, 912.723999);
    SetPlayerCameraLookAt(playerid, -2676.433349, 1410.398925, 912.723999);
    SetPlayerPos(playerid, -2676.433349, 1410.398925, 912.723999);
    SetPlayerInterior(playerid, 3);
    SetPlayerFacingAngle(playerid, 266.910003);
	PlayerPlaySound(playerid,1058 ,0, 0, 0);
    ApplyAnimation(playerid,"DANCING","dnce_M_b",4.0,1,0,0,0,-1);
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerRequestSpawn(playerid){
    PlayerPlaySound(playerid,1186 ,0, 0, 0);

    return 1;
}
//------------------------------------------------------------------------------
public OnPlayerConnect(playerid){
	new string [MAX_STRING];
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(string, sizeof(string), "%s(%d) [sa-mp.com.cn/player/%s/] 进入服务器", pName, playerid, pName);
	SendClientMessageToAll(COLOR_GREEN, string);
    playerGang[playerid] = 0;
    Connects[playerid] += 1;
    TDHS[playerid] = 1;
    SBAD[playerid] = 1;
	//ramped[playerid] = 1;
	//noramp[playerid] = 1;
	CheckName(playerid);
    SetTimer("MoneyUpdate",60000,1);
    SetTimerEx("AutoRepair",100,true,"d",playerid);
	GameTextForPlayer(playerid, "~r~SA-MP ~b~.com ~w~.cn", 1500, 1);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "欢迎来到 未来世界, 按键盘 T 键,输入 /help 获取帮助信息!");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "管理员信箱:sa-mp@qq.com QQ讨论群:22288828");
	PlayerPlaySound(playerid,1097, -1121.076, -1191.143, 15);
	
	//zhu:
	SetPlayerColor(playerid,playerColors[playerid]);
	
	
	return 1;
}

//------------------------------------------------------------------------------
public OnPlayerDisconnect(playerid,reason){
  switch (reason)
  {
    case 0:
    {
	Crashs[playerid] += 1;
    }
    case 1:
    {
	Disconnects[playerid] += 1;
    }
    case 2:
    {
	Kicks[playerid] += 1;
    }
}
    TDHS[playerid] = 1;
    SBAD[playerid] = 1;
    //TextDrawDestroy(Text:Textdraw0);
   // TextDrawDestroy(Text:Textdraw1);
    KillTimer(MoneyUpdate(playerid));
    new string[MAX_STRING];
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));


	switch(reason)
	{
		case 0: format(string, sizeof(string), "%s(%d) 离开服务器 (掉线)",pName, playerid);
		case 1: format(string, sizeof(string), "%s(%d) 离开服务器 (退出)",pName, playerid);
		case 2: format(string, sizeof(string), "%s(%d) 离开服务器 (kick/ban)",playerid, pName);
	}

	SendClientMessageToAll(COLOR_GREEN, string);
	pDMPosition[playerid]=DM_NONE;
	printf(string);
	return 1;
}


public StopPMTimer(playerid){
	for(new i=0;i<MAX_PLAYERS;i++){
		if(IsPlayerConnected(i)){
		GivePlayerMoney(playerid,40000);
		SendClientMessage(playerid, COLOR_WHITE, "最后30分钟过去, here you go,您收到 40000$");
		GameTextForPlayer(playerid, "~y~4~w~0000~g~$ ~n~~r~Received.",3000,0);
		return 1;
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerSpawn(playerid){
    Spawns[playerid] += 1;
/*	andrompara1 = CreatePickup(371 , 2, 312.1582,991.3581,1957.4447);
	andrompara2 = CreatePickup(371 , 2, 319.7898,988.2772,1958.1556);
	andrompara3 = CreatePickup(371 , 2, 319.5330,983.4193,1959.2767);
	andrompara4 = CreatePickup(371 , 2, 311.5391,983.5497,1959.2466);
	andrompara5 = CreatePickup(371 , 2, 318.8687,998.9326,1955.6967);
	andrompara6 = CreatePickup(371 , 2, 311.8329,1004.9678,1954.3040);
	andrompara7 = CreatePickup(371 , 2, 312.6456,1020.6475,1950.6855);
	andrompara8 = CreatePickup(371 , 2, 319.3426,1021.0186,1950.6000);
	andrompara9 = CreatePickup(371 , 2, 311.9515,1024.5446,1949.7863);
	andrompara10 = CreatePickup(371 , 2, 319.7364,1024.7739,1949.7333);
	airport1para = CreatePickup(1273  , 23, 1685.4576,-2334.1506,13.5469);
	airport2para = CreatePickup(1273  , 23, 1673.9154,1447.9954,10.7841);
	airport3para = CreatePickup(1273  , 23, -1421.6687,-287.7242,14.1484);
	airport4para = CreatePickup(1273  , 23, 428.4151,2546.8318,16.2382);
	jump = CreatePickup(1273  , 2, 315.6004,1029.4099,1948.1918);*/
	SetPlayerToSpawn(playerid,pDMPosition[playerid]);
	//new r = random(sizeof(spawns));
	///SetPlayerPos(playerid, spawns[r][ex], spawns[r][ey], spawns[r][ez]);
	//SetPlayerInterior(playerid, spawns[r][interior]);
	//SendClientMessage(playerid, COLOR_WHITE, spawns[r][emsg]);
	DynUpdateStart(playerid); // Avoid falling through object's
	GivePlayerWeapon(playerid,8,1);
	SetPlayerArmour(playerid, 80.0);
	SetPlayerHealth(playerid, 80.0);
	return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid){
/*		PickUpedPickups[playerid] += 1;
		if (pickupid == jump)
    {
		GameTextForPlayer(playerid,"~W~dont forget to ~Y~open ~W~your ~G~parachute~W~!",6000,5);
		PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		new string[MAX_STRING];
		new name[128];
		GetPlayerName(playerid,name,128);
		format(string, sizeof(string), "[跳伞] 什么东西在空中??? 鸟? 灰机? 超人? 不! 那是 %s 从飞机上跳了下来!!!!!!!",name);
		SendClientMessageToAll(COLOR_GREEN, string);
		SetPlayerPos(playerid,311.0149,1085.0867,2043.0105);
		SetPlayerInterior(playerid, 0);
    }
     	if (pickupid == airport1para)
    {
        GameTextForPlayer(playerid,"~W~teleported to the ~G~andromada!~N~~W~go into the ~R~green house ~W~to ~B~jump~W~!~N~oh, and get a ~G~parachute~W~!",6000,5);
        SetPlayerInterior(playerid, 9);
       	SetPlayerPos(playerid,316.0568,985.7001,1958.7504);
		SetPlayerFacingAngle(playerid, 1.9321);
    }
    	if (pickupid == airport2para)
    {
        GameTextForPlayer(playerid,"~W~teleported to the ~G~andromada!~N~~W~go into the ~R~green house ~W~to ~B~jump~W~!~N~oh, and get a ~G~parachute~W~!",6000,5);
        SetPlayerInterior(playerid, 9);
       	SetPlayerPos(playerid,316.0568,985.7001,1958.7504);
		SetPlayerFacingAngle(playerid, 1.9321);
    }
        if (pickupid == airport3para)
    {
        GameTextForPlayer(playerid,"~W~teleported to the ~G~andromada!~N~~W~go into the ~R~green house ~W~to ~B~jump~W~!~N~oh, and get a ~G~parachute~W~!",6000,5);
        SetPlayerInterior(playerid, 9);
       	SetPlayerPos(playerid,316.0568,985.7001,1958.7504);
		SetPlayerFacingAngle(playerid, 1.9321);
    }
        if (pickupid == airport4para)
    {
        GameTextForPlayer(playerid,"~W~teleported to the ~G~andromada!~N~~W~go into the ~R~green house ~W~to ~B~jump~W~!~N~oh, and get a ~G~parachute~W~!",6000,5);
    	SetPlayerInterior(playerid, 9);
       	SetPlayerPos(playerid,316.0568,985.7001,1958.7504);
		SetPlayerFacingAngle(playerid, 1.9321);
    }
        if (pickupid == andrompara1)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara2)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara3)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara4)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara5)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara6)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara7)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara8)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara9)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }
        if (pickupid == andrompara10)
    {
        GivePlayerWeapon(playerid, 46, 1);
        GameTextForPlayer(playerid,"~W~found a ~G~parachute~W~!~N~go to the ~R~green house ~W~to ~Y~jump~W~!",6000,5);
    }*/
	return true;
}

public PlayingTime(){
for(new i=0;i<MAX_PLAYERS;i++)
{
   if(IsPlayerConnected(i))
   {
	  if(PlayingMinutes[i] < 60)
	  {
	  PlayingMinutes[i]++;
	  }else{
	  PlayingMinutes[i] = 0;
	  PlayingHours[i]++;
	  }
   }
}
}

public MoneyUpdate(){
    for(new i=0; i<MAX_PLAYERS; ++i)
	{
	if ( IsPlayerConnected(i) )
	{
	GivePlayerMoney(i,5000);
	}
	}
}
public OnPlayerDeath(playerid, killerid, reason){
    new playercash;
	new killedplayer[MAX_PLAYER_NAME];
 	new string[MAX_STRING];

	playercash = GetPlayerMoney(playerid);
 	
	if(killerid != INVALID_PLAYER_ID)
    {
    Kills[killerid] += 1;
    Deaths[playerid] += 1;
    }else{
    Deaths[playerid] += 1;
    }
	SendDeathMessage(killerid, playerid, reason);
	GameTextForPlayer(playerid, "~r~Pwnt! ~b~Pwnt! ~r~Pwnt! ~b~Pwnt!", 1500, 1);
	if(bounty[playerid] > 0 && (playerGang[killerid] == 0 || playerGang[playerid] != playerGang[killerid])) {
	GetPlayerName(playerid, killedplayer, sizeof(killedplayer));
	format(string, sizeof(string), "[悬赏] 您出 %d 的雇佣金,杀掉 %s 任务已完成.", bounty[playerid], killedplayer);
	SendClientMessage(killerid, COLOR_GREEN, string);

	GivePlayerMoney(killerid, bounty[playerid]);
	bounty[playerid] = 0;
	}
	if(playercash > 0)  {
	GivePlayerMoney(killerid, playercash);
	}
   	if(playercash > 0)
   	{
	    ResetPlayerMoney(playerid);
    }
 	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
	 StateChanges[playerid] += 1;
 	new string[MAX_STRING];
 	if(newstate == PLAYER_STATE_DRIVER)
	{
	   new newcar = GetPlayerVehicleID(playerid);
       format(string, sizeof(string), "%s",VehicleNames[GetVehicleModel(newcar)-400]);
	   GameTextForPlayer(playerid,string,2500,1);
	 	VehicleEnters[playerid] += 1;
	 }
 	 new vehicleid = GetPlayerVehicleID(playerid);
   	 if(newstate == PLAYER_STATE_DRIVER) {
	}
    if(!IsPlayerInInvalidNosVehicle(playerid,vehicleid))
	{
		if(newstate == 2)
		{
		new vid = GetPlayerVehicleID(playerid);
		AddVehicleComponent(vid, 1010);
		KillTimer(Timers[playerid]);
		Timers[playerid] = SetTimerEx("Update", 20000, true, "i", playerid);
		}
	}
    new str[80];
	if (newstate == 2 || newstate == 3)
    {
        format(str, sizeof(str), "~r~~h~%s ",VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
        GameTextForPlayer(playerid, str, 1534, 1);
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){

	/*if(newkeys == KEY_SECONDARY_ATTACK ){
		if(!IsPlayerInAnyVehicle(playerid)){
			new Float:x, Float:y, Float:z, vehicle;
			GetPlayerPos(playerid, x, y, z );
			GetVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);

			if(IsVehicleRcTram(vehicle)){
			    PutPlayerInVehicle(playerid, vehicle, 0);
			}
		}

		else {
			new vehicleID = GetPlayerVehicleID(playerid);
			if(IsVehicleRcTram(vehicleID) || GetVehicleModel(vehicleID) == RC_CAM){
			    if(GetVehicleModel(vehicleID) != D_TRAM){
			    	new Float:x, Float:y, Float:z;
			   	 	GetPlayerPos(playerid, x, y, z);
		    		SetPlayerPos(playerid, x+0.5, y, z+1.0);
				}
			}
		}
	}*/
	return true;
}
	

CheckName(playerid){
    new PlayerName[24];
	new string[MAX_STRING];
    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
    for(new names = 0; names < FORBIDDENNAMES; names++)
    {
        if(strcmp(PlayerName, IllegalNames[names], true) == 0)
        {
            //format(string, sizeof(string), " 服务器: %s(%i) 请更改用户名重新进入游戏!", PlayerName, playerid);
            //SendClientMessageToAll(COLOR_PINK, string);
            format(string, sizeof(string), "[错误] 注意: 玩家(%d)\"%s\" - 请不要把纯数字(0~9)作为用户名!",playerid, PlayerName);
            SendClientMessageToAll(COLOR_PINK, string);
			format(string,sizeof(string),"sb%3d",playerid);
            SetPlayerName(playerid,string);
			Kick(playerid);
			return;
        }
    }
}
/*
public Keys()
{


    for(new i=0; i<MAX_PLAYERS; ++i)
	{
	    if( IsPlayerConnected(i) )
	    {
	        if( IsPlayerInAnyVehicle(i) )
	        {
	            if ( GetVehicleModel(GetPlayerVehicleID(i)) == 522 || GetVehicleModel(GetPlayerVehicleID(i)) == 481 ||GetVehicleModel(GetPlayerVehicleID(i)) == 510 ||GetVehicleModel(GetPlayerVehicleID(i)) == 463 || GetVehicleModel(GetPlayerVehicleID(i)) == 468 || GetVehicleModel(GetPlayerVehicleID(i)) == 471 )
				{
				SetVehicleHealth(GetPlayerVehicleID(i), 1000.0);
				}
			}
		}
	}
	
	new keys, jump2, updown, playerid;
	new Float:x, Float:y, Float:z, Float:angle;
	for (playerid = 0; playerid < MAX_PLAYERS; playerid++) {
	    if (IsPlayerConnected(playerid)) {
			GetPlayerKeys(playerid, keys, jump2, updown);
			if(ramped[playerid] == 1 && noramp[playerid] == 1)
			{
			if(keys & KEY_FIRE && IsPlayerInAnyVehicle(playerid))
   			{

			}
			}
			else if(ramped[playerid] == 1)
			{

			}
			else if (keys & KEY_FIRE && IsPlayerInAnyVehicle(playerid)) {{
					    GetPlayerPos(playerid, x, y, z);
					    angle = GetPosInFrontOfPlayer(playerid, x, y, GetRampDistance(playerid));
					    jumped[playerid] = CreateObject(1632, x, y, z - 0.5, 0.0, 0.0, angle);
					    ramped[playerid] = 1;
					    SetTimerEx("DeleteRamp", 2500, 0, "d", playerid);
				    }
			    }
			} else Pressedkey[playerid] = false;
		}
}

public DeleteRamp(playerid)
{
	if (jumped[playerid] != -1) {
	    DestroyObject(jumped[playerid]);
	    jumped[playerid] = -1;
	    ramped[playerid]=0;
	}
}

GetVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh){
	for(new i = 1; i < MAX_VEHICLES; i++){
		if(GetVehicleModel(i) > 0){
			if(GetPlayerVehicleID(playerid) != i ){
	        	new Float:x, Float:y, Float:z;
	        	new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
				new Float:vDist = (x2*x2+y2*y2+z2*z2);
				if( vDist < dist){
					veh = i;
					dist = vDist;
				}
			}
		}
	}
}
*/
/*IsVehicleRcTram( vehicleid ){
    new model = GetVehicleModel(vehicleid);
   	switch(model){
		case D_TRAM, RC_GOBLIN, RC_BARON, RC_BANDIT, RC_RAIDER, RC_TANK: return 1;
		default: return 0;
	}
	return 0;
}*/
/*
stock GetXYInFrontOfPlayer(playerid, &Float:x2, &Float:y2, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x2, y2, a);
    GetPlayerFacingAngle(playerid, a);
    if(GetPlayerVehicleID(playerid)){
    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);}
    x2 += (distance * floatsin(-a, degrees));
    y2 += (distance * floatcos(-a, degrees));
}*/
//-------------------------------------------------------------------------------------------------------------------------------------------
public OnVehicleDeath(vehicleid, killerid){
	VehicleDestroys[killerid] += 1;
    for(new i = 0; i < MAX_PLAYERS; i++) {
    if(GetPlayerVehicleID(i) == vehicleid) RemovePlayerFromVehicle(i);}
    return 1;
}
//---------------------------------------------------------------------------------------------------------------------------------------------
public CountDown(){
   if (Count > 0){
   GameTextForAll( CountText[Count-1], 2500, 3);
   Count--;
   SetTimer("CountDown", 1000, 0);}else{
   GameTextForAll("~g~GO~r~!!~n~~g~GO~r~!!~n~~g~GO~r~!!", 2500, 3);
   Count = 5;}
   return 1;
}
public SetRandomWeather(){
	new rand = random(sizeof(RandomWeatherIDs));
	new strout[MAX_STRING];
	format(strout, sizeof(strout), "[天气] 天气更换到: %s", RandomWeatherIDs[rand][randomweather_text]);
	SetWeather(RandomWeatherIDs[rand][randomweather_id]);
	SendClientMessageToAll(COLOR_YELLOW,strout);
	print(strout);
}

//------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
IsInvalidSkin(skinid){
    #define MAX_BAD_SKINS 22
    new InSkin[MAX_BAD_SKINS] = {
    0, 3, 4, 5, 6, 8, 42, 65, 74, 86,
    119, 149, 208,  273, 289};
    for (new i = 0; i < MAX_BAD_SKINS; i++) {
    if (skinid == InSkin[i]) return true;}
    return 0;
}
IsPlayerInInvalidNosVehicle(playerid,vehicleid){
	#define MAX_INVALID_NOS_VEHICLES 38

	new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
	{
		581,523,462,521,463,522,461,448,468,586,
		509,481,510,472,473,493,595,484,430,453,
		452,446,454,590,569,537,538,570,449,513,
		520,519,487,417,406,556,444,557

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
public Update(playerid){
	if(!IsPlayerConnected(playerid) || !IsPlayerInAnyVehicle(playerid))
		return KillTimer(Timers[playerid]);
	if(IsPlayerInInvalidNosVehicle(playerid,GetPlayerVehicleID(playerid)))
	{
		//do nothing
	}
	else {
		new vid = GetPlayerVehicleID(playerid);
		AddVehicleComponent(vid, 1010);
	}
	return 1;
}
//---------------------------------------------------------------------------------------------------------------------------------------------
/*stock Player(playerid)
{
 new player[MAX_PLAYER_NAME];
 GetPlayerName(playerid, player, sizeof(player));
 return player;
}*/

public AddOthers()
{
//timers
  //  SetTimer("Keys", 100, 1); //100 miliseconds
    SetTimer("WarningMessages",240000,1);
    SetTimer("TipMessages",120000,1);
    SetTimer("FunMessages",360000,1);
	SetTimer("SetRandomWeather",1200000,1);
	SetTimer("TimeUpdate",60009, 1);
	ConnectTimer = SetTimer("PlayingTime",60000,1);


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

    SetGameModeText("赛车/旅游/特技/DM");
	ShowNameTags(1);                  
    SetNameTagDrawDistance(70);      
	SetWeather(0);                   
	SetWorldTime(13);                 
	AllowInteriorWeapons(1);         
	UsePlayerPedAnims();            
	EnableTirePopping(1);

}
/*public AddPickups()
{
//------------------------------------------------------------------------------
//-------------------------------[[PICKUPS]]------------------------------------
//------------------------------------------------------------------------------
    CreatePickup(1266, 1, 1529.096069, -1348.223632, 329.460937);//Funny!! on Big Tower
    CreatePickup(371,2,-2237.7300,-1711.5620,480.8730);//PARACHUTE
   	CreatePickup(371, 15, -2240.2351,-1747.3890,480.8622);//PARACHUTE
	CreatePickup(371, 15, 1545.5070,-1225.3750,261.5938);//PARACHUTE
	CreatePickup(371, 15, 1440.8297,-1227.1548,187.1926);//PARACHUTE
	CreatePickup(371, 15, 1498.3612,-1282.6539,113.7795);//PARACHUTE
	CreatePickup(371, 15, 1552.8856,-1264.9105,277.8750);//PARACHUTE
	CreatePickup(371, 15, 1548.4478,-1268.6362,261.5938);//PARACHUTE
	CreatePickup(371, 15, 1544.6133,-1272.7666,250.6563);//PARACHUTE
	CreatePickup(371, 15, 1656.8127,-1249.7767,233.3750);//PARACHUTE
	CreatePickup(371, 15, 1656.8175,-1274.2491,200.5234);//PARACHUTE
	CreatePickup(371, 15, 1661.2855,-1644.0159,87.3735);//PARACHUTE

}*/
public AddSkins()
{
//------------------------------------------------------------------------------
//================================[SKINS]=======================================
//------------------------------------------------------------------------------
	AddPlayerClass(0,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//cj
	AddPlayerClass(1,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(2,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(71,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(290,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(291,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(292,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(293,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(294,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(295,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(296,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(297,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(299,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(105,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Grove
	AddPlayerClass(106,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(107,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(102,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Ballas
	AddPlayerClass(103,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(104,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(114,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Varios Los Aztecas
	AddPlayerClass(115,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(116,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(108,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Los Santos Vagos
	AddPlayerClass(109,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(110,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(121,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//DaNang
	AddPlayerClass(122,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(123,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(173,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//San Fierro Rifa
    AddPlayerClass(174,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
    AddPlayerClass(175,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
    AddPlayerClass(117,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Triads
	AddPlayerClass(118,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(120,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(100,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Bikers
	AddPlayerClass(247,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(248,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(254,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(111,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Mafia
	AddPlayerClass(112,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(113,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(124,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(125,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(126,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(127,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(163,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Public Services
	AddPlayerClass(164,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(165,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(166,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(274,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(275,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(276,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(277,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(278,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(279,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(280,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(281,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(282,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(283,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(288,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(284,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(285,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(286,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(287,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(138,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Beach Visitor
	AddPlayerClass(139,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(140,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(145,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(146,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(154,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(251,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(92,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(97,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(45,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(18,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(132,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Agriculture People
	AddPlayerClass(133,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(158,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(159,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(160,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(161,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(162,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(200,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(202,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(31,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(32,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(33,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(34,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(258,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Sportive Pedestrians
	AddPlayerClass(259,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(26,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(51,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(52,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(80,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(81,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(23,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(96,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(99,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(147,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Specific Professions
	AddPlayerClass(153,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(167,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(68,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(171,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(176,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(177,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(179,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(187,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(189,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(203,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(204,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(155,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(205,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(209,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(217,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(219,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(260,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(16,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(27,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(264,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(70,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(134,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Other Skins
	AddPlayerClass(135,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(137,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(181,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(213,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(212,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(230,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(239,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(249,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(241,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(242,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(252,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(253,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(255,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(29,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(30,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(49,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(50,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(57,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(61,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(62,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(66,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(73,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(78,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(79,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(82,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(83,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(84,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(101,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 1)
	AddPlayerClass(136,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(14,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(142,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(143,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(144,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(15,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(156,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(168,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(17,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(170,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(180,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(182,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(183,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(184,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(186,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(185,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(188,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(19,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(20,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(206,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 2)
	AddPlayerClass(21,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(22,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(210,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(220,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(221,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(222,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(223,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(227,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(228,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(234,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(235,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(236,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(24,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(240,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(25,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(250,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(261,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(28,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(35,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 3)
	AddPlayerClass(37,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(38,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(36,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(44,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(43,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(46,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(93,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(48,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(47,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(262,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(229,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(58,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(59,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(60,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(233,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(67,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(7,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(72,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(94,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(95,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(98,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);
	AddPlayerClass(298,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(53,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(91,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(195,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Carl's Girlfriends //girl
	AddPlayerClass(190,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(191,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(192,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(193,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(194,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(128,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Agriculture People //girl
	AddPlayerClass(129,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(130,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(131,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(157,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(196,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(197,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(198,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(199,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(201,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(152,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Whore's of San Andreas //girl
	AddPlayerClass(178,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(237,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(238,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(243,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(244,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(207,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(245,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(246,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(85,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(256,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(257,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(64,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(63,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(87,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(90,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(11,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Specific Professions //girl
	AddPlayerClass(141,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0); //girl
	AddPlayerClass(148,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(150,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(172,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(211,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(224,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Other Skins //girl
	AddPlayerClass(77,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(10,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 1) //girl
	AddPlayerClass(12,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(13,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(151,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(169,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(54,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(263,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(75,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(216,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(214,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 2) //girl
	AddPlayerClass(215,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(225,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(226,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(231,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(76,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(89,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(88,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(218,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(40,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(41,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(69,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//Normal Skins (Part 3) //girl
	AddPlayerClass(9,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(39,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(232,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(55,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
	AddPlayerClass(56,401.8559, 2438.9685, 16.5000, 359.4314,0,0,0,0,0,0);//girl
//------------------------------------------------------------------------------
//-------------------------------[[VEHICLES]]-----------------------------------
//------------------------------------------------------------------------------
//================================[Chilliad]====================================
    CreateVehicle(522,-2344.783,-1591.691,483.236,261.0,-1,-1,120);
    //CreateVehicle(522,-2345.076,-1592.458,483.240,261.0,-1,-1,120);
    CreateVehicle(522,-2345.333,-1593.308,483.245,261.0,-1,-1,120);
    //CreateVehicle(522,-2345.641,-1593.985,483.248,261.0,-1,-1,120);
    CreateVehicle(522,-2345.912,-1594.771,483.252,261.0,-1,-1,120);
    //CreateVehicle(522,-2346.172,-1595.473,483.255,261.0,-1,-1,120);
    CreateVehicle(522,-2346.512,-1596.191,483.258,261.0,-1,-1,120);
    //CreateVehicle(522,-2346.829,-1596.964,483.262,261.0,-1,-1,120);
    CreateVehicle(522,-2347.056,-1597.707,483.266,261.0,-1,-1,120);
//================================[Drift 4]=====================================
    //CreateVehicle(541, 2279.136718, 1391.112426, 42.407886, 359.950714, -1, -1,120);
    //CreateVehicle(541, 2282.316406, 1391.244262, 42.405426, 358.775970, -1, -1,120);
    //CreateVehicle(541, 2285.675048, 1391.159545, 42.406478, 357.931579, -1, -1,120);
    //CreateVehicle(411, 2289.241943, 1391.163818, 42.547393, 359.627838, -1, -1,120);
    //CreateVehicle(411, 2292.472412, 1390.967773, 42.547393, 0.904320, -1, -1,120);
    //CreateVehicle(411, 2295.574707, 1390.927856, 42.547386, 358.651123, -1, -1,120);
    //CreateVehicle(562, 2298.940673, 1391.335937, 42.480144, 0.318066, -1, -1,120);
    //CreateVehicle(562, 2302.618896, 1391.125854, 42.479106, 1.311367, -1, -1,120);
    //CreateVehicle(562, 2305.541259, 1391.228271, 42.479648, 358.072937, -1, -1,120);
    //CreateVehicle(559, 2304.783691, 1405.055541, 42.476676, 270.399444, -1, -1,120);
//drift2
CreateVehicle(411,-2399.6819,-613.2119,132.3549,34.3428,-1,-1,300); //
//CreateVehicle(411,-2397.0625,-611.4222,132.3549,34.3430,-1,-1,300); //
CreateVehicle(411,-2394.6221,-609.7548,132.3539,34.3430,-1,-1,300); //
//CreateVehicle(411,-2392.0410,-607.9908,132.3539,34.3430,-1,-1,300); //
CreateVehicle(411,-2391.0090,-601.6914,132.3526,125.6364,-1,-1,300); //
//CreateVehicle(411,-2392.7305,-599.2900,132.3526,125.6364,-1,-1,300); //
CreateVehicle(411,-2394.4939,-596.8301,132.3526,125.6364,-1,-1,300); //
//CreateVehicle(411,-2396.2009,-594.4490,132.3526,125.6364,-1,-1,300); //
CreateVehicle(451,-2397.9092,-592.0665,132.3526,125.6364,-1,-1,300); //
//CreateVehicle(451,-2399.6304,-589.6652,132.3526,125.6364,-1,-1,300); //
CreateVehicle(451,-2401.3647,-587.2453,132.3526,125.6364,-1,-1,300); //
//CreateVehicle(451,-2403.1580,-584.7443,132.3526,125.6364,-1,-1,300); //
CreateVehicle(451,-2409.2180,-583.4867,132.3545,216.2870,-1,-1,300); //
//CreateVehicle(451,-2411.7756,-585.3646,132.3545,216.2870,-1,-1,300); //
CreateVehicle(451,-2414.2773,-587.2015,132.3545,216.2870,-1,-1,300); //
//CreateVehicle(451,-2416.7175,-588.9933,132.3545,216.2870,-1,-1,300); //
//================================[Drift 3]=====================================
    //CreateVehicle(411,-304.821,1582.122,75.159,135.0,-1,-1,120); //Infernus
    //CreateVehicle(411,-302.556,1579.797,75.159,135.0,-1,-1,120); //Infernus
    //CreateVehicle(411,-300.124,1577.368,75.159,135.0,-1,-1,120); //Infernus
    //CreateVehicle(411,-297.641,1574.922,75.159,135.0,-1,-1,120); //Infernus
    //CreateVehicle(451,-295.199,1572.578,75.159,135.0,-1,-1,120); //Turismo
    //CreateVehicle(451,-292.844,1570.113,75.159,135.0,-1,-1,120); //Turismo
    //CreateVehicle(451,-275.322,1552.566,75.159,135.0,-1,-1,120); //Turismo
    //CreateVehicle(541,-272.767,1550.340,75.159,135.0,-1,-1,120); //Bullet
    //CreateVehicle(541,-270.323,1547.977,75.159,135.0,-1,-1,120); //Bullet
    //CreateVehicle(541,-267.741,1545.644,75.159,135.0,-1,-1,120); //Bullet
    //CreateVehicle(541,-265.209,1543.389,75.159,135.0,-1,-1,120); //Bullet
    //CreateVehicle(506,-262.680,1541.155,75.159,135.0,-1,-1,120); //Super GT
    //CreateVehicle(506,-287.661,1564.257,75.159,135.0,-1,-1,120); //Super GT
    //CreateVehicle(506,-282.837,1559.101,75.159,135.0,-1,-1,120); //Super GT
    CreateVehicle(541,-345.733,1514.535,75.159,0.0,-1,-1,120); //Super GT
    CreateVehicle(506,-342.891,1514.491,75.159,0.0,-1,-1,120); //Jester
    CreateVehicle(451,-339.782,1514.561,75.159,0.0,-1,-1,120); //Ranger
    CreateVehicle(411,-336.607,1514.575,75.159,0.0,-1,-1,120); //DFT-30
    CreateVehicle(429,-333.183,1514.797,75.159,0.0,-1,-1,120); //DFT-30
    CreateVehicle(541,-330.103,1514.733,75.159,0.0,-1,-1,120); //DFT-30
    CreateVehicle(506,-327.040,1514.753,75.159,0.0,-1,-1,120); //Alpha
    CreateVehicle(451,-323.801,1514.834,75.159,0.0,-1,-1,120); //Alpha
    CreateVehicle(411,-320.890,1514.911,75.159,0.0,-1,-1,120); //Infernus
    CreateVehicle(429,-317.843,1514.938,75.157,0.0,-1,-1,120); //Infernus
    CreateVehicle(411,-314.701,1514.923,75.157,0.0,-1,-1,120); //Infernus
//===================================[Party Land]===============================
    /*CreateVehicle(502,-1050.802,-1147.506,127.426,192.0,-1,-1,120);//partyland
    CreateVehicle(502,-1106.223,-1220.302,129.019,282.0,-1,-1,120);
    CreateVehicle(411,-1106.157,-1215.504,129.019,282.0,-1,-1,120);
    CreateVehicle(411,-1105.777,-1211.108,129.026,282.0,-1,-1,120);
    CreateVehicle(411,-1105.540,-1206.729,129.026,282.0,-1,-1,120);
    CreateVehicle(559,-1105.249,-1202.071,129.026,282.0,-1,-1,120);
    CreateVehicle(559,-1117.296,-1219.948,129.019,56.0,-1,-1,120);
    CreateVehicle(559,-1117.055,-1214.989,129.019,56.0,-1,-1,120);
    CreateVehicle(603,-1116.799,-1209.417,129.019,56.0,-1,-1,120);
    CreateVehicle(603,-1116.680,-1204.109,129.019,56.0,-1,-1,120);
    CreateVehicle(603,-1116.043,-1200.825,129.026,56.0,-1,-1,120);
    CreateVehicle(477,-1102.100,-1170.081,129.019,214.0,-1,-1,120);*/
    //CreateVehicle(451,-2128.240,-1411.737,202.688,304.0,-1,-1,120);
    //CreateVehicle(451,-2130.780,-1408.137,202.695,304.0,-1,-1,120);
    //CreateVehicle(411,-2122.475,-1408.159,202.218,304.0,-1,-1,120);
    //CreateVehicle(411,-2125.069,-1404.206,202.216,304.0,-1,-1,120);
//===================================[Spawn Point(Los Santos Airport)]==========
    CreateVehicle(451, 1367.346801, -2465.054687, 13.261029, 0.851735, -1, -1,120);//lsair
    CreateVehicle(411, 1371.719238, -2465.568359, 13.281769, 358.419281, -1, -1,120);
    CreateVehicle(522, 1374.848144, -2466.834472, 13.126310, 359.667327, -1, -1,120);
    //CreateVehicle(522, 1375.729248, -2466.883300, 13.125295, 0.942371, -1, -1,120);
    CreateVehicle(522, 1376.517700, -2466.948242, 13.123107, 359.941772, -1, -1,120);
    //CreateVehicle(522, 1377.306762, -2466.992187, 13.125128, 3.322744, -1, -1,120);
    CreateVehicle(522, 1378.177124, -2466.990234, 13.120537, 4.575102, -1, -1,120);
    //CreateVehicle(522, 1378.948730, -2467.001708, 13.130892, 359.314270, -1, -1,120);
    CreateVehicle(522, 1379.794799, -2466.958984, 13.123526, 354.934143, -1, -1,120);
    CreateVehicle(481, 1368.142700, -2474.110595, 13.069089, 86.338127, -1, -1,120);
    CreateVehicle(481, 1367.754516, -2469.455078, 13.377351, 282.427246, -1, -1,120);
    CreateVehicle(481, 1387.101196, -2471.314941, 13.378908, 357.215759, -1, -1,120);
    CreateVehicle(481, 1387.818115, -2471.257812, 13.380636, 355.973358, -1, -1,120);
    CreateVehicle(481, 1388.603515, -2471.250244, 13.380598, 0.146302, -1, -1,120);
    CreateVehicle(509, 1389.271728, -2471.226562, 13.377300, 359.358459, -1, -1,120);
    CreateVehicle(509, 1390.000122, -2471.177001, 13.377556, 359.079650, -1, -1,120);
    CreateVehicle(510, 1390.851074, -2471.110351, 13.473617, 1.423702, -1, -1,120);
    CreateVehicle(510, 1391.440673, -2471.169189, 13.474577, 1.654415, -1, -1,120);
    CreateVehicle(471, 1392.965454, -2470.899414, 13.345818, 3.009774, -1, -1,120);
    CreateVehicle(471, 1394.603637, -2470.904296, 13.347564, 3.694217, -1, -1,120);
    CreateVehicle(451, 1367.537597, -2450.812744, 13.261469, 272.169250, -1, -1,120);
    CreateVehicle(451, 1367.446166, -2448.263427, 13.261090, 270.265197, -1, -1,120);
    CreateVehicle(411, 1367.263916, -2445.279785, 13.281755, 271.370880, -1, -1,120);
    CreateVehicle(444, 1368.136474, -2441.301025, 13.926261, 271.853790, -1, -1,120);
    CreateVehicle(444, 1367.980102, -2436.473144, 13.926137, 269.798889, -1, -1,120);
    //CreateVehicle(561, 1396.866210, -2464.912597, 13.368294, 1.956160, -1, -1,120);
    //CreateVehicle(561, 1400.089233, -2464.783935, 13.368244, 3.444640, -1, -1,120);
    CreateVehicle(487, 1372.794311, -2419.963378, 13.736294, 271.309173, -1, -1,120);
    CreateVehicle(417, 1393.923828, -2420.272705, 13.667263, 179.717620, -1, -1,120);
    CreateVehicle(519, 1476.534667, -2399.219970, 14.473155, 179.526535, -1, -1,120);
    CreateVehicle(487, 1380.800659, -2412.010253, 13.730427, 223.239440, -1, -1,120);
    CreateVehicle(487,1408.4951,-2418.7412,13.7299,180.2382, -1, -1,120);
    CreateVehicle(487,1419.6526,-2417.8892,13.4669,180.2718, -1, -1,120);
    //CreateVehicle(451, 1517.774291, -2651.044921, 45.256050, 0.580745, -1, -1,120);
    //CreateVehicle(451, 1521.090820, -2650.780029, 45.256237, 0.304180, -1, -1,120);
    //CreateVehicle(451, 1524.311889, -2650.397460, 45.255531, 0.085462, -1, -1,120);
    //CreateVehicle(411, 1527.759887, -2650.759033, 45.276397, 359.933105, -1, -1,120);
    //CreateVehicle(411, 1531.035400, -2651.051757, 45.276393, 359.529296, -1, -1,120);
//===============================[Insane Race]==================================
    //CreateVehicle(506,-680.349,1962.515,1.290,168.0,-1,-1,120);//idrace
    //CreateVehicle(411,-685.762,1963.851,1.290,168.0,-1,-1,120);
    //CreateVehicle(506,-691.833,1964.815,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-697.352,1966.355,1.290,168.0,-1,-1,120);
    //CreateVehicle(451,-703.567,1967.562,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-708.941,1968.758,1.290,168.0,-1,-1,120);
    //CreateVehicle(603,-714.817,1969.830,1.290,168.0,-1,-1,120);
    //CreateVehicle(451,-719.880,1970.809,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-725.341,1971.358,1.290,168.0,-1,-1,120);
    //CreateVehicle(451,-730.584,1973.063,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-737.164,1974.258,1.290,168.0,-1,-1,120);
    //CreateVehicle(506,-742.772,1975.370,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-748.412,1976.164,1.290,168.0,-1,-1,120);
    //CreateVehicle(603,-674.294,1961.129,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-668.547,1960.363,1.290,168.0,-1,-1,120);
    //CreateVehicle(541,-662.838,1959.153,1.290,168.0,-1,-1,120);
    //CreateVehicle(603,-657.047,1958.217,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-651.224,1956.071,1.290,168.0,-1,-1,120);
    //CreateVehicle(541,-645.501,1954.832,1.290,168.0,-1,-1,120);
    //CreateVehicle(506,-640.436,1954.373,1.290,168.0,-1,-1,120);
    //CreateVehicle(411,-635.297,1953.144,1.290,168.0,-1,-1,120);
    //CreateVehicle(541,-629.391,1952.382,1.290,168.0,-1,-1,120);
//====================================[Town Hard Race]==========================
    //CreateVehicle(411,397.530,-2334.709,31.614,318.0,-1,-1,120);//thrace
    //CreateVehicle(541,395.477,-2332.545,31.614,318.0,-1,-1,120);
    //CreateVehicle(411,393.417,-2330.410,31.614,318.0,-1,-1,120);
    //CreateVehicle(451,391.290,-2328.065,31.614,318.0,-1,-1,120);
    //CreateVehicle(541,389.096,-2326.113,31.614,318.0,-1,-1,120);
    //CreateVehicle(559,386.754,-2323.994,31.614,318.0,-1,-1,120);
    //CreateVehicle(541,384.649,-2321.957,31.614,318.0,-1,-1,120);
    //CreateVehicle(411,380.403,-2317.561,31.614,318.0,-1,-1,120);
    //CreateVehicle(541,382.578,-2319.829,31.614,318.0,-1,-1,120);
    //CreateVehicle(411,378.418,-2315.519,31.614,318.0,-1,-1,120);
    //CreateVehicle(451,376.293,-2313.170,31.614,318.0,-1,-1,120);
    //CreateVehicle(559,373.964,-2310.697,31.614,318.0,-1,-1,120);
    //CreateVehicle(411,371.661,-2308.143,31.614,318.0,-1,-1,120);
    //CreateVehicle(559,369.223,-2305.891,31.614,318.0,-1,-1,120);
    //CreateVehicle(451,360.830,-2271.618,31.614,226.0,-1,-1,120);
    //CreateVehicle(411,363.269,-2269.288,31.614,226.0,-1,-1,120);
    //CreateVehicle(559,365.644,-2266.843,31.614,226.0,-1,-1,120);
    //CreateVehicle(451,367.746,-2264.282,31.614,226.0,-1,-1,120);
    //CreateVehicle(411,369.953,-2261.963,31.614,226.0,-1,-1,120);
    //CreateVehicle(559,372.311,-2259.178,31.614,226.0,-1,-1,120);
    //CreateVehicle(411,374.731,-2255.983,31.614,226.0,-1,-1,120);
    //CreateVehicle(411,377.417,-2252.894,31.614,226.0,-1,-1,120);
//=Vehicles San Fiero/Las Venturas/Los Santos/Insane Deadly Race/Town Hard Race=
    CreateVehicle(411, 1306.345947, 1278.184814, 10.547395, 359.825653, -1, -1, 120);//lvair
    CreateVehicle(451, 1309.448730, 1278.372802, 10.526859, 359.082122, -1, -1, 120);
    CreateVehicle(411, 1312.746582, 1278.146362, 10.547393, 359.687255, -1, -1, 120);
    CreateVehicle(541, 1315.967773, 1278.498168, 10.445274, 2.317829, -1, -1, 120);
    CreateVehicle(541, 1318.991333, 1278.640258, 10.445224, 358.996429, -1, -1, 120);
    CreateVehicle(565, 1325.641235, 1278.857299, 10.444962, 0.503725, -1, -1, 120);
    CreateVehicle(522, 1306.859252, 1270.181884, 10.384943, 4.256974, -1, -1, 120);
    CreateVehicle(522, 1307.678955, 1270.332519, 10.403647, 9.233302, -1, -1, 120);
    CreateVehicle(522, 1308.626953, 1270.248291, 10.395001, 10.717947, -1, -1, 120);
    CreateVehicle(522, 1309.518554, 1270.317138, 10.387339, 7.221857, -1, -1, 120);
    CreateVehicle(471, 1302.261596, 1266.257690, 10.301456, 0.271340, -1, -1, 120);
    CreateVehicle(513,1278.6016,1323.1083,10.8203,271.6209,-1,-1,300); //
CreateVehicle(513,1302.2605,1323.4404,10.8203,270.3676,-1,-1,300); //
CreateVehicle(513,1323.2747,1323.0813,10.8203,269.1141,-1,-1,300); //
CreateVehicle(513,1336.8108,1323.2573,10.8203,271.5975,-1,-1,300); //
CreateVehicle(513,1304.6617,1343.2766,10.8203,270.3440,-1,-1,300); //
CreateVehicle(513,1326.0957,1342.6517,10.8203,266.5839,-1,-1,300); //
CreateVehicle(513,1281.8444,1358.1190,10.8203,268.4638,-1,-1,300); //
CreateVehicle(513,1299.5013,1358.2914,10.8203,271.9106,-1,-1,300); //
CreateVehicle(513,1312.3784,1359.0537,10.8203,271.2838,-1,-1,300); //
CreateVehicle(513,1327.9395,1359.5656,10.8203,289.1440,-1,-1,300); //
    CreateVehicle(411, -1646.859130, -178.475189, 13.871031, 132.997375, -1, -1, 120);//sfair
    CreateVehicle(411, -1644.076293, -181.508529, 13.875519, 131.360214, -1, -1, 120);
    CreateVehicle(411, -1641.006469, -184.548828, 13.873426, 133.565750, -1, -1, 120);
    CreateVehicle(451, -1637.949096, -186.605209, 13.855470, 159.370559, -1, -1, 120);
    CreateVehicle(451, -1634.710815, -187.913330, 13.854873, 159.546249, -1, -1, 120);
    CreateVehicle(541, -1631.207885, -188.753356, 13.773288, 162.163391, -1, -1, 120);
    CreateVehicle(541, -1627.646850, -190.273651, 13.773284, 156.412780, -1, -1, 120);
    CreateVehicle(522, -1650.971313, -200.899520, 13.724677, 258.927673, -1, -1, 120);
    CreateVehicle(522, -1650.856811, -199.630416, 13.718091, 257.078094, -1, -1, 120);
    CreateVehicle(522, -1650.323364, -198.277084, 13.718837, 259.906738, -1, -1, 120);
    CreateVehicle(522, -1651.060913, -202.075698, 13.718446, 255.898986, -1, -1, 120);
    CreateVehicle(522, -1651.411743, -203.324600, 13.717761, 256.968078, -1, -1, 120);
    //CreateVehicle(521, 1529.5933,-2434.8188,13.1391,187.5093, -1, -1, 120);//lsair
    //CreateVehicle(521, 1527.3854,-2434.6880,13.1169,192.2064, -1, -1, 120);
    //CreateVehicle(521, 1525.3026,-2434.6907,13.1174,194.6794, -1, -1, 120);
    //CreateVehicle(521, 1523.0364,-2434.7144,13.1139,192.1497, -1, -1, 120);
    //CreateVehicle(521, 1520.8973,-2434.9260,13.1132,190.5277, -1, -1, 120);
    //CreateVehicle(522, 1531.833984,-2432.863769,13.124451,214.796432, -1, -1, 120);
    //CreateVehicle(522, 1533.563598,-2431.478027,13.120539,214.796508, -1, -1, 120);
    //CreateVehicle(522, 1535.293701,-2430.093017,13.121326,214.796417, -1, -1, 120);
    //CreateVehicle(522, 1537.023559,-2428.707275,13.118118,214.796676, -1, -1, 120);
    //CreateVehicle(522, 1538.753662,-2427.322021,13.121539,214.796478, -1, -1, 120);
    CreateVehicle(522, 1949.943603,-2275.411132,87.987976,276.591308, -1, -1, 120);
    CreateVehicle(522, 406.174255, 2535.074218, 16.114707, 113.227462, -1, -1, 120);//aa摩托
    CreateVehicle(522, 406.783508, 2533.756835, 16.118820, 115.444358, -1, -1, 120);
    CreateVehicle(522, 405.629577, 2536.327392, 16.117507, 114.158729, -1, -1, 120);
    CreateVehicle(522, 405.131958, 2537.502441, 16.114463, 114.182479, -1, -1, 120);
    CreateVehicle(522, 404.592407, 2538.658691, 16.114402, 114.185447, -1, -1, 120);
    CreateVehicle(411, 394.007690, 2541.558837, 16.270299, 59.492977, -1, -1, 120);
    CreateVehicle(451, 395.322845, 2544.121582, 16.250514, 60.493251, -1, -1, 120);
    CreateVehicle(541, 397.046569, 2546.839355, 16.156309, 61.150604, -1, -1, 120);
    CreateVehicle(587, 390.500793, 2552.171875, 16.177305, 180.802078, -1, -1, 120);
    CreateVehicle(415, 387.501586, 2552.374023, 16.286071, 186.805328, -1, -1, 120);
    //CreateVehicle(415, 404.195922, -2338.763916, 31.605312, 223.992691, -1, -1, 120);//thrace
    //CreateVehicle(415, 409.076019, -2343.817626, 31.607700, 223.992675, -1, -1, 120);
    //CreateVehicle(415, 422.258911, -2320.905761, 31.607009, 226.494003, -1, -1, 120);
    //CreateVehicle(415, 427.068145, -2325.730224, 31.606695, 224.318283, -1, -1, 120);
    //CreateVehicle(415, 371.279418, -2299.683593, 31.606119, 315.101562, -1, -1, 120);
    //CreateVehicle(415, 366.513916, -2295.253906, 31.605953, 313.401916, -1, -1, 120);
    //CreateVehicle(415, -627.583312, 1964.329223, 1.235989, 80.320213, -1, -1, 120);//idrace
    //CreateVehicle(415, -627.879455, 1960.584472, 1.235827, 83.042076, -1, -1, 120);
    //CreateVehicle(415, -628.156555, 1957.296875, 1.235286, 76.051727, -1, -1, 120);
	CreateVehicle(412,409.9576,2554.6812,16.1707,176.5173, -1, -1, 120);//aa汽车
	CreateVehicle(565,413.1241,2554.5725,15.9254,177.9655, -1, -1, 120);
	CreateVehicle(411,416.7716,2554.4961,15.9841,182.2233, -1, -1, 120);
	CreateVehicle(451,419.8773,2554.4465,15.9290,180.2733, -1, -1, 120);
	CreateVehicle(434,416.6978,2560.5820,16.3057,179.2233, -1, -1, 120);
	CreateVehicle(587,422.9831,2554.3630,15.9229,178.7709, -1, -1, 120);
	CreateVehicle(560,425.7605,2555.3657,15.9471,177.0573, -1, -1, 120);
	CreateVehicle(541,426.4404,2561.0820,16.0754,172.8659, -1, -1, 120);
	CreateVehicle(559,423.4213,2561.6853,16.0225,175.8891, -1, -1, 120);
	CreateVehicle(562,419.6425,2560.8662,15.9914,177.4440, -1, -1, 120);
	CreateVehicle(561,413.4572,2560.8457,16.2081,177.1618, -1, -1, 120);
	CreateVehicle(415,410.5425,2561.4478,16.2520,176.1088, -1, -1, 120);
	CreateVehicle(444,401.8549,2555.7979,16.8888,130.2665, -1, -1, 120);
	CreateVehicle(541,392.5258,2538.5706,16.1681,56.3162, -1, -1, 120);
	CreateVehicle(462,395.1019,2536.6777,16.1438,152.5448, -1, -1, 120);
	CreateVehicle(462,396.4384,2536.0244,16.1436,150.3160, -1, -1, 120);
	CreateVehicle(571,422.0797,2532.1099,15.8827,183.7101, -1, -1, 120);
	CreateVehicle(571,420.0965,2532.6235,15.8723,177.9378, -1, -1, 120);
	CreateVehicle(571,418.6173,2532.7659,15.8684,180.1931, -1, -1, 120);
	//CreateVehicle(465,338.9475,2542.1995,16.6007,180.0570, -1, -1, 10);//rc
	//CreateVehicle(564,341.7169,2541.8044,16.5177,178.2276, -1, -1, 10);
	//CreateVehicle(594,345.8146,2541.9888,16.5978,177.9581, -1, -1, 10);
	//CreateVehicle(501,349.0262,2541.8750,16.4513,177.6467, -1, -1, 10);
	//CreateVehicle(464,351.8749,2542.3782,16.4569,177.1916, -1, -1, 10);
	//CreateVehicle(441,343.7580,2542.4451,16.3413,175.5826, -1, -1, 10);
//=================================[Ostacle Race - Madness]=====================  /nrgocm
    CreateVehicle(522,2867.576,-773.696,10.584,271.0,-1,-1,120);
    //CreateVehicle(522,2867.565,-772.653,10.580,271.0,-1,-1,120);
    CreateVehicle(522,2867.527,-771.458,10.576,271.0,-1,-1,120);
    //CreateVehicle(522,2867.506,-770.435,10.576,271.0,-1,-1,120);
    CreateVehicle(522,2867.584,-769.434,10.574,271.0,-1,-1,120);
    //CreateVehicle(522,2867.636,-768.298,10.572,271.0,-1,-1,120);
    CreateVehicle(522,2867.693,-767.171,10.570,271.0,-1,-1,120);
    //CreateVehicle(522,2867.565,-765.955,10.574,271.0,-1,-1,120);
    CreateVehicle(522,2867.744,-764.760,10.568,271.0,-1,-1,120);
    //CreateVehicle(522,2867.776,-763.652,10.567,271.0,-1,-1,120);
    CreateVehicle(522,2867.757,-762.250,10.568,271.0,-1,-1,120);
    //CreateVehicle(522,2776.695,-741.418,10.568,271.0,-1,-1,120);
    CreateVehicle(522,2867.801,-760.850,10.566,271.0,-1,-1,120);
    //CreateVehicle(522,2867.889,-759.691,10.563,271.0,-1,-1,120);
    CreateVehicle(522,2867.784,-758.447,10.567,271.0,-1,-1,120);
    //CreateVehicle(522,2867.701,-757.202,10.570,271.0,-1,-1,120);
    CreateVehicle(522,2867.668,-755.971,10.571,271.0,-1,-1,120);
    //CreateVehicle(522,2867.713,-754.654,10.571,271.0,-1,-1,120);
    CreateVehicle(522,2867.761,-753.314,10.570,271.0,-1,-1,120);
    //CreateVehicle(522,2867.616,-774.718,10.590,271.0,-1,-1,120);
    CreateVehicle(522,2867.565,-775.821,10.598,271.0,-1,-1,120);
    //CreateVehicle(522,2867.567,-777.051,10.607,271.0,-1,-1,120);
    CreateVehicle(522,2867.414,-778.054,10.610,271.0,-1,-1,120);
//lv
CreateVehicle(409,2039.6442,1008.3510,10.4646,178.7774,-1,-1,300); //
CreateVehicle(562,2039.9252,1019.8704,10.3553,179.7789,-1,-1,300); //
CreateVehicle(402,2039.0867,1160.6548,10.5221,179.5146,-1,-1,300); //
CreateVehicle(420,2039.7212,1335.4227,10.4267,178.9215,-1,-1,300); //
CreateVehicle(420,2040.1990,1344.9266,10.4266,178.6028,-1,-1,300); //
CreateVehicle(560,2039.5768,1560.1542,10.3967,179.5952,-1,-1,300); //
CreateVehicle(409,2176.3464,1676.1705,10.6102,179.9265,-1,-1,300); //
CreateVehicle(535,2075.9692,1677.7285,10.4623,359.9696,-1,-1,300); //
CreateVehicle(587,2075.2620,1490.8475,10.3820,0.5680,-1,-1,300); //
CreateVehicle(545,2075.7278,1482.4116,10.5207,359.2965,-1,-1,300); //
CreateVehicle(541,2075.6467,1312.3184,10.3261,359.4247,-1,-1,300); //
CreateVehicle(439,2133.0220,1006.8338,10.7145,88.8489,-1,-1,300); //
CreateVehicle(429,2141.7615,1022.7036,10.5083,90.9768,-1,-1,300); //
CreateVehicle(436,2150.9509,987.4146,10.6244,180.8611,-1,-1,300); //
CreateVehicle(461,2132.7344,898.2937,10.4034,269.0096,-1,-1,300); //
CreateVehicle(474,2197.8223,936.0228,10.5996,185.5566,-1,-1,300); //
CreateVehicle(402,2231.8359,1277.3821,10.5528,0.8295,-1,-1,300); //
CreateVehicle(451,2180.4319,1287.7809,10.5262,179.4236,-1,-1,300); //
CreateVehicle(451,2148.8728,1398.3777,10.5159,359.6847,-1,-1,300); //
CreateVehicle(558,2132.6245,1409.2686,10.4607,180.3101,-1,-1,300); //
CreateVehicle(409,2108.1375,1440.6631,10.6315,268.1550,-1,-1,300); //
CreateVehicle(579,2168.6711,1412.4213,10.7093,179.3723,-1,-1,300); //
CreateVehicle(402,2214.6814,1512.2753,10.6113,269.7448,-1,-1,300); //
CreateVehicle(562,1882.0356,1054.4166,10.4831,90.3886,-1,-1,300); //
CreateVehicle(562,1881.7815,964.0563,10.4988,89.6011,-1,-1,300); //
CreateVehicle(439,1866.8518,1179.2213,10.7525,0.1705,-1,-1,300); //
CreateVehicle(522,1843.6910,1255.2235,10.4074,89.6354,-1,-1,300); //
CreateVehicle(411,1844.4285,1209.7374,10.5510,91.1954,-1,-1,300); //
CreateVehicle(409,1944.3588,1335.7651,8.9068,178.6215,-1,-1,300); //
CreateVehicle(409,1944.0548,1346.0627,8.8774,180.2980,-1,-1,300); //
CreateVehicle(477,2118.6614,1892.0721,10.4080,181.2676,-1,-1,300); //
CreateVehicle(496,2102.4282,2066.0054,10.5201,270.8546,-1,-1,300); //
CreateVehicle(477,2103.5505,2089.0322,10.5627,269.2956,-1,-1,300); //
CreateVehicle(420,2217.2993,1838.0653,10.5815,180.0927,-1,-1,300); //
CreateVehicle(410,2192.2512,1856.6970,10.4551,181.3636,-1,-1,300); //
CreateVehicle(482,2170.8975,1981.6842,10.9461,90.0687,-1,-1,300); //
CreateVehicle(479,2272.5039,1953.0511,9.6545,179.0810,-1,-1,300); //
CreateVehicle(415,2294.6204,1952.2435,26.0871,268.4258,-1,-1,300); //
CreateVehicle(461,2283.6716,1975.0837,31.3764,182.0217,-1,-1,300); //
CreateVehicle(587,2338.7258,1943.9393,10.4353,183.2675,-1,-1,300); //
CreateVehicle(461,2258.3555,2065.3555,10.4040,6.4255,-1,-1,300); //
CreateVehicle(414,2063.6423,2237.0996,10.1863,85.9456,-1,-1,300); //
CreateVehicle(522,1997.8575,2187.2932,10.4207,183.3892,-1,-1,300); //
CreateVehicle(525,1963.1377,2171.0911,10.7037,257.0750,-1,-1,300); //
CreateVehicle(516,1912.8146,2158.5762,10.6479,271.8423,-1,-1,300); //
CreateVehicle(436,1907.3175,2078.6470,10.6168,270.3478,-1,-1,300); //
CreateVehicle(411,1889.2762,1934.0372,13.4956,180.0616,-1,-1,300); //
CreateVehicle(429,1702.6101,1804.3876,10.5069,359.1253,-1,-1,300); //
CreateVehicle(437,1736.9502,1878.4279,10.9275,269.9015,-1,-1,300); //
CreateVehicle(436,1691.2648,2131.1482,11.0692,91.2256,-1,-1,300); //
CreateVehicle(480,1613.5994,2207.0569,10.5928,271.9675,-1,-1,300); //
CreateVehicle(401,1508.7942,2091.1389,10.6225,271.2127,-1,-1,300); //
CreateVehicle(482,1450.2019,2017.9803,10.9009,90.8832,-1,-1,300); //
CreateVehicle(436,1368.7349,2020.8087,11.2106,88.8745,-1,-1,300); //
CreateVehicle(426,1453.9873,1957.8292,10.9603,179.1386,-1,-1,300); //
CreateVehicle(421,1602.3923,1839.9326,10.7107,178.4764,-1,-1,300); //
CreateVehicle(541,1113.0646,1726.9901,10.4719,180.0108,-1,-1,300); //
CreateVehicle(521,1024.3048,1723.6971,10.4158,88.7343,-1,-1,300); //
CreateVehicle(522,949.3976,1661.9830,8.4342,269.5899,-1,-1,300); //
CreateVehicle(403,1059.6808,1916.6599,11.4038,0.6038,-1,-1,300); //
CreateVehicle(400,1108.1290,1903.8434,10.9110,269.2198,-1,-1,300); //
CreateVehicle(483,1117.3728,2112.1541,10.8370,0.5512,-1,-1,300); //
CreateVehicle(419,1115.5000,2310.4214,10.5880,267.7291,-1,-1,300); //
CreateVehicle(561,990.2887,2307.3547,11.2280,91.4694,-1,-1,300); //
CreateVehicle(530,980.7014,2060.1506,10.5673,159.6551,-1,-1,300); //
CreateVehicle(542,1023.1163,2019.7916,10.9699,272.3912,-1,-1,300); //
CreateVehicle(554,991.8256,1886.8772,11.4540,270.4510,-1,-1,300); //
CreateVehicle(409,2361.3262,2170.0618,10.5474,359.3093,-1,-1,300); //
CreateVehicle(415,2339.1240,2114.0637,10.4553,177.3783,-1,-1,300); //
CreateVehicle(463,2436.2776,2060.5471,10.3586,324.7230,-1,-1,300); //
CreateVehicle(463,2437.9817,2060.0022,10.3538,323.5547,-1,-1,300); //
CreateVehicle(463,2439.4436,2059.3215,10.3590,317.0792,-1,-1,300); //
CreateVehicle(533,2444.2771,1990.9320,10.5201,359.1869,-1,-1,300); //
CreateVehicle(480,2458.2371,1992.2131,10.5907,180.6308,-1,-1,300); //
CreateVehicle(603,2389.2195,1658.2765,10.6532,358.7754,-1,-1,300); //
CreateVehicle(409,2481.4556,1544.0549,10.4408,203.2637,-1,-1,300); //
CreateVehicle(415,2447.5208,1327.1155,10.6077,179.1100,-1,-1,300); //
CreateVehicle(535,2455.4600,1275.5591,10.5798,270.0720,-1,-1,300); //
CreateVehicle(442,2485.1382,936.1897,10.6455,0.1060,-1,-1,300); //
CreateVehicle(524,2629.9148,850.8232,6.9362,317.3953,-1,-1,300); //
CreateVehicle(560,2705.9063,788.8558,10.5822,359.2400,-1,-1,300); //
CreateVehicle(486,2707.1621,822.2551,10.7170,2.2320,-1,-1,300); //
CreateVehicle(455,2726.9995,867.2231,11.1998,359.9999,-1,-1,300); //
CreateVehicle(403,2873.1082,920.3192,11.3380,94.3501,-1,-1,300); //
CreateVehicle(403,2873.2478,913.3608,11.3362,85.7944,-1,-1,300); //
CreateVehicle(578,2840.3694,994.4697,11.3910,177.3833,-1,-1,300); //
CreateVehicle(530,2833.1304,996.5218,10.5035,174.1764,-1,-1,300); //
CreateVehicle(560,2817.4487,941.7303,10.4604,0.5725,-1,-1,300); //
CreateVehicle(405,2782.1948,1295.4268,10.6096,179.4258,-1,-1,300); //
CreateVehicle(581,2600.0735,1691.1099,10.4400,89.1782,-1,-1,300); //
CreateVehicle(477,2602.5796,1846.6437,10.5997,90.5310,-1,-1,300); //
CreateVehicle(448,2631.0923,1845.7836,10.4033,261.1277,-1,-1,300); //
CreateVehicle(477,2156.2295,2188.8953,10.4261,0.1901,-1,-1,300); //
CreateVehicle(477,2272.6008,2326.2439,10.5658,88.5976,-1,-1,300); //
CreateVehicle(428,2242.5039,2231.3745,10.9222,270.8870,-1,-1,300); //
CreateVehicle(474,2511.0986,2394.3945,10.5543,269.3659,-1,-1,300); //
CreateVehicle(481,2518.1206,2456.0100,10.5490,178.5534,-1,-1,300); //
CreateVehicle(418,2530.6255,2535.9524,21.9608,268.5752,-1,-1,300); //
CreateVehicle(415,2455.1396,2531.6138,21.6272,179.4468,-1,-1,300); //
CreateVehicle(419,2349.0598,2578.3972,10.5782,359.5132,-1,-1,300); //
//sf
CreateVehicle(443,-1747.0105,-164.0554,4.2005,33.3892,-1,-1,300); //
CreateVehicle(492,-1821.1345,-161.7386,9.2278,165.4666,-1,-1,300); //
CreateVehicle(403,-1855.5903,-176.3475,9.9100,269.7613,-1,-1,300); //
CreateVehicle(482,-1861.0288,-140.4761,11.9875,87.6782,-1,-1,300); //
CreateVehicle(426,-1839.7610,-21.5044,14.8610,266.1626,-1,-1,300); //
CreateVehicle(522,-1697.8929,63.2369,3.1334,301.0477,-1,-1,300); //
CreateVehicle(522,-1694.0784,48.5605,3.1266,317.3058,-1,-1,300); //
CreateVehicle(522,-1682.4451,41.2987,3.0995,338.2351,-1,-1,300); //
CreateVehicle(426,-1669.5283,-33.8687,3.3049,314.0983,-1,-1,300); //
CreateVehicle(455,-1578.0427,97.1747,3.9830,135.2130,-1,-1,300); //
CreateVehicle(530,-1712.0806,10.8209,3.3777,303.1426,-1,-1,300); //
CreateVehicle(530,-1700.6157,6.3028,3.2979,352.1097,-1,-1,300); //
CreateVehicle(484,-1475.4067,703.9037,0.2623,180.6433,-1,-1,300); //
CreateVehicle(480,-1488.4320,666.5052,6.9374,92.0208,-1,-1,300); //
CreateVehicle(480,-1623.0934,817.0691,6.5929,2.0274,-1,-1,300); //
CreateVehicle(439,-1629.1405,870.3052,8.1171,178.1245,-1,-1,300); //
CreateVehicle(533,-1707.1240,795.3775,24.4955,2.4245,-1,-1,300); //
CreateVehicle(551,-1767.2251,857.6207,24.6002,90.8636,-1,-1,300); //
CreateVehicle(405,-1755.8124,953.2112,24.5991,84.9866,-1,-1,300); //
CreateVehicle(482,-1673.3120,1090.5762,8.0829,269.4870,-1,-1,300); //
CreateVehicle(439,-1696.8988,977.2706,17.5200,359.7376,-1,-1,300); //
CreateVehicle(481,-1950.3280,880.2209,38.0228,185.2232,-1,-1,300); //
CreateVehicle(560,-2004.1337,888.2909,44.9851,0.1133,-1,-1,300); //
CreateVehicle(533,-1996.7838,780.7227,45.0761,0.6987,-1,-1,300); //
CreateVehicle(533,-1997.1072,708.1375,45.0807,0.1914,-1,-1,300); //
CreateVehicle(429,-1944.3304,585.2783,34.8059,0.6205,-1,-1,300); //
CreateVehicle(582,-2044.8705,460.4153,35.2465,304.5740,-1,-1,300); //
CreateVehicle(439,-1922.0637,303.6670,40.9573,177.2475,-1,-1,300); //
CreateVehicle(461,-1974.6832,170.8083,27.2736,271.7078,-1,-1,300); //
CreateVehicle(420,-1988.1044,147.8852,27.3030,0.2008,-1,-1,300); //
CreateVehicle(420,-1987.9829,104.7410,27.3032,0.4062,-1,-1,300); //
CreateVehicle(535,-2085.3076,61.6714,34.2493,88.7252,-1,-1,300); //
CreateVehicle(535,-2099.2332,-36.4078,35.0822,357.3716,-1,-1,300); //
CreateVehicle(415,-2089.7454,-85.3234,34.9399,0.0899,-1,-1,300); //
CreateVehicle(415,-2076.7393,-84.4285,34.9404,357.8585,-1,-1,300); //
CreateVehicle(535,-2021.4000,-47.6943,35.1317,184.0939,-1,-1,300); //
CreateVehicle(504,-2091.6189,-106.7158,35.1348,179.9077,-1,-1,300); //
CreateVehicle(567,-2145.0002,-210.9104,35.1581,359.9994,-1,-1,300); //
CreateVehicle(461,-2205.1877,-310.7155,35.1679,330.4087,-1,-1,300); //
CreateVehicle(437,-2092.6169,-381.4303,35.4543,90.0272,-1,-1,300); //
CreateVehicle(437,-2201.6943,-406.7658,35.4483,228.5155,-1,-1,300); //
CreateVehicle(437,-2047.2263,-528.5165,35.4930,286.3203,-1,-1,300); //
CreateVehicle(483,-1906.4750,-611.7370,24.5805,318.8246,-1,-1,300); //
CreateVehicle(482,-1871.7909,-874.4851,32.1588,90.1316,-1,-1,300); //
CreateVehicle(411,-1872.5627,-957.2282,31.7543,88.9793,-1,-1,300); //
CreateVehicle(411,-2148.7537,-922.7443,31.7646,267.8929,-1,-1,300); //
CreateVehicle(400,-2124.5403,-935.2542,32.1119,268.6219,-1,-1,300); //
CreateVehicle(411,-2125.3843,-885.7676,31.7673,270.2341,-1,-1,300); //
CreateVehicle(421,-2124.5457,-847.0034,31.9184,270.5158,-1,-1,300); //
CreateVehicle(506,-2150.3076,-772.5897,31.7205,270.3167,-1,-1,300); //
CreateVehicle(481,-2399.1526,-253.9133,39.2631,343.6470,-1,-1,300); //
CreateVehicle(448,-2319.5146,-150.9778,35.1564,176.9124,-1,-1,300); //
CreateVehicle(480,-2352.2268,-124.4603,35.0722,179.3502,-1,-1,300); //
CreateVehicle(567,-2357.7898,-43.2304,35.1536,90.4796,-1,-1,300); //
CreateVehicle(411,-2458.0825,-150.9827,26.0191,1.6983,-1,-1,300); //
CreateVehicle(436,-2547.1064,-143.0562,13.7333,0.9179,-1,-1,300); //
CreateVehicle(429,-2592.8479,-110.8349,3.9452,89.8546,-1,-1,300); //
CreateVehicle(496,-2593.0640,-191.1819,4.0394,90.9675,-1,-1,300); //
CreateVehicle(411,-2616.4414,-179.6383,4.5082,268.5175,-1,-1,300); //
CreateVehicle(457,-2650.3347,-284.5875,7.1580,135.9134,-1,-1,300); //
CreateVehicle(457,-2652.5535,-295.5245,7.1393,312.4187,-1,-1,300); //
CreateVehicle(409,-2738.0159,-322.8925,6.8169,313.4230,-1,-1,300); //
CreateVehicle(505,-2774.2710,-281.9137,7.2517,178.6838,-1,-1,300); //
CreateVehicle(421,-2796.6179,-184.0408,7.0845,91.6072,-1,-1,300); //
CreateVehicle(411,-2719.3848,-182.9646,4.2666,269.6466,-1,-1,300); //
CreateVehicle(411,-2692.3420,-83.6108,4.0583,90.7628,-1,-1,300); //
CreateVehicle(566,-2796.2910,-39.5264,6.9350,89.7988,-1,-1,300); //
CreateVehicle(560,-2682.6699,-22.7147,4.0562,178.6174,-1,-1,300); //
CreateVehicle(408,-2655.6343,-194.2879,4.7221,359.8165,-1,-1,300); //
CreateVehicle(560,-2627.3582,-34.8298,4.0562,181.9431,-1,-1,300); //
CreateVehicle(560,-2710.4944,128.6361,3.9694,177.2722,-1,-1,300); //
CreateVehicle(439,-2681.6304,268.0088,4.2350,358.7699,-1,-1,300); //
CreateVehicle(426,-2664.9829,267.9223,4.0736,0.0177,-1,-1,300); //
CreateVehicle(462,-2635.9460,247.3540,3.9229,168.5486,-1,-1,300); //
CreateVehicle(559,-2691.8088,204.5158,3.9904,359.4067,-1,-1,300); //
CreateVehicle(533,-2613.7688,205.7689,4.6612,1.3974,-1,-1,300); //
CreateVehicle(482,-2586.3762,311.3397,4.9613,90.7021,-1,-1,300); //
CreateVehicle(439,-2586.3093,325.2872,4.7804,270.9106,-1,-1,300); //
CreateVehicle(405,-2655.9502,374.4828,4.2139,0.8295,-1,-1,300); //
CreateVehicle(409,-2752.1565,374.9534,3.9308,179.1497,-1,-1,300); //
CreateVehicle(467,-2922.5190,428.7528,4.6810,276.2398,-1,-1,300); //
CreateVehicle(500,-2927.1533,500.5025,5.0384,268.8672,-1,-1,300); //
CreateVehicle(493,-2980.9753,495.2190,-0.4251,2.4108,-1,-1,300); //
CreateVehicle(496,-2867.3049,695.7758,23.2633,295.9004,-1,-1,300); //
CreateVehicle(467,-2879.0039,734.4675,29.3198,280.3607,-1,-1,300); //
CreateVehicle(496,-2857.6187,830.1863,39.9053,239.3628,-1,-1,300); //
CreateVehicle(401,-2836.6194,870.4554,43.8498,267.2127,-1,-1,300); //
CreateVehicle(401,-2839.8757,925.7388,43.8572,274.0429,-1,-1,300); //
CreateVehicle(410,-2855.1865,962.1592,43.6216,294.3518,-1,-1,300); //
CreateVehicle(411,-2646.5010,1334.4891,6.8927,0.5806,-1,-1,300); //
CreateVehicle(480,-2645.6704,1375.8961,6.9393,268.6543,-1,-1,300); //
CreateVehicle(477,-2617.5010,1376.3604,6.8653,180.0679,-1,-1,300); //
CreateVehicle(411,-2618.2131,1346.1387,6.9201,2.2162,-1,-1,300); //
CreateVehicle(575,-2610.8403,1405.6073,6.7204,270.0911,-1,-1,300); //
CreateVehicle(487,-2632.1709,1417.5668,24.9078,235.3498,-1,-1,300); //
CreateVehicle(469,-2514.7397,1545.1023,17.3351,349.7475,-1,-1,300); //
CreateVehicle(473,-2434.8977,1571.7601,-0.0380,348.5434,-1,-1,300); //
CreateVehicle(473,-2432.8574,1568.0583,-0.3939,353.6037,-1,-1,300); //
CreateVehicle(417,-2311.2490,1544.8896,18.8672,184.2903,-1,-1,300); //
CreateVehicle(482,-1834.8290,1425.0422,7.3138,179.1685,-1,-1,300); //
CreateVehicle(522,-1821.9431,1310.3896,59.3204,186.3904,-1,-1,300); //
CreateVehicle(558,-1656.2681,1208.2485,20.7887,268.6006,-1,-1,300); //
CreateVehicle(558,-1660.5303,1215.1503,20.7950,315.8494,-1,-1,300); //
CreateVehicle(451,-1656.4816,1215.6750,13.3692,259.0956,-1,-1,300); //
CreateVehicle(451,-1650.9395,1208.6311,13.3819,247.0161,-1,-1,300); //
CreateVehicle(411,-1663.4672,1211.4713,6.9839,276.9536,-1,-1,300); //
//ls
CreateVehicle(542,1404.6641,-2314.1106,13.2905,180.5298,-1,-1,300); //
CreateVehicle(475,1391.6547,-2241.8691,13.3286,180.6320,-1,-1,300); //
CreateVehicle(542,1364.5386,-2242.7036,13.2717,270.7714,-1,-1,300); //
CreateVehicle(439,1398.1588,-2225.4890,13.4487,179.6556,-1,-1,300); //
CreateVehicle(518,1454.6987,-2224.9192,13.1946,1.0188,-1,-1,300); //
CreateVehicle(429,1441.7050,-2225.1501,13.2284,1.5904,-1,-1,300); //
CreateVehicle(536,1696.6797,-2097.0371,13.3024,179.3784,-1,-1,300); //
CreateVehicle(567,1725.0470,-2130.4272,13.3942,180.7249,-1,-1,300); //
CreateVehicle(411,1722.6769,-2092.2903,13.4762,178.9920,-1,-1,300); //
CreateVehicle(412,1724.1238,-2092.9292,13.3560,179.9109,-1,-1,300); //
CreateVehicle(536,1747.4454,-2097.3748,13.2554,179.0735,-1,-1,300); //
CreateVehicle(536,1772.7335,-2096.0852,13.2532,181.7467,-1,-1,300); //
CreateVehicle(420,1734.6830,-1859.8689,13.2735,270.6927,-1,-1,300); //
CreateVehicle(420,1748.9728,-1859.9052,13.2708,270.7615,-1,-1,300); //
CreateVehicle(420,1763.0189,-1859.9486,13.2757,271.3831,-1,-1,300); //
CreateVehicle(420,1775.6227,-1859.9550,13.2744,269.3341,-1,-1,300); //
CreateVehicle(443,2002.9690,-1940.1613,13.9209,90.7771,-1,-1,300); //
CreateVehicle(426,2065.5422,-1920.3378,13.2948,179.3152,-1,-1,300); //
CreateVehicle(546,2095.9946,-1800.3225,13.1044,268.3970,-1,-1,300); //
CreateVehicle(534,2284.0776,-1681.8391,13.8521,1.9647,-1,-1,300); //
CreateVehicle(475,2271.4460,-1634.8629,15.0986,1.4860,-1,-1,300); //
CreateVehicle(496,2296.9368,-1644.5157,14.4958,178.9131,-1,-1,300); //
CreateVehicle(451,2436.3740,-1676.4048,13.4079,359.7726,-1,-1,300); //
CreateVehicle(600,2501.2712,-1685.7070,13.2003,53.8327,-1,-1,300); //
CreateVehicle(404,2514.8582,-1671.4227,13.4483,247.0798,-1,-1,300); //
CreateVehicle(482,2473.6375,-1688.4152,13.6375,1.3289,-1,-1,300); //
CreateVehicle(451,2526.9265,-1678.7357,19.6369,140.9335,-1,-1,300); //
CreateVehicle(451,2450.5916,-1605.0120,14.4022,41.1977,-1,-1,300); //
CreateVehicle(546,2657.6064,-1701.7751,9.0059,93.0564,-1,-1,300); //
CreateVehicle(521,2654.6580,-1692.7294,8.9031,251.8596,-1,-1,300); //
CreateVehicle(588,2686.6787,-1672.3335,9.3509,1.2833,-1,-1,300); //
CreateVehicle(463,2696.4204,-1669.2931,9.0472,152.6987,-1,-1,300); //
CreateVehicle(521,2808.0320,-1669.2372,9.5080,168.8970,-1,-1,300); //
CreateVehicle(466,2829.7678,-1699.7467,9.7329,256.3793,-1,-1,300); //
CreateVehicle(426,2757.8303,-1847.0499,9.4509,20.5669,-1,-1,300); //
CreateVehicle(547,2787.8394,-1876.2352,9.5973,179.4585,-1,-1,300); //
CreateVehicle(479,2732.6770,-1875.2531,9.4262,359.8041,-1,-1,300); //
CreateVehicle(443,2660.1494,-1454.4664,79.9863,358.5616,-1,-1,300); //
CreateVehicle(451,2634.4163,-1459.3042,30.3137,271.0122,-1,-1,300); //
CreateVehicle(481,1953.5090,-1381.8810,18.0951,219.1255,-1,-1,300); //
CreateVehicle(481,1956.8558,-1381.6945,18.0959,209.2259,-1,-1,300); //
CreateVehicle(481,1955.0332,-1363.9298,18.0946,32.4259,-1,-1,300); //
CreateVehicle(481,1952.1837,-1363.8356,18.0911,16.5769,-1,-1,300); //
CreateVehicle(481,1886.7780,-1364.9199,13.0774,306.3474,-1,-1,300); //
CreateVehicle(481,1886.9675,-1362.5293,13.0641,304.9974,-1,-1,300); //
CreateVehicle(481,1886.6769,-1361.0046,13.0436,304.9978,-1,-1,300); //
CreateVehicle(533,1819.8563,-1403.5039,13.1672,89.9445,-1,-1,300); //
CreateVehicle(496,1809.4689,-1432.1581,13.1580,274.7265,-1,-1,300); //
CreateVehicle(536,1762.5532,-1085.8547,23.6984,180.7030,-1,-1,300); //
CreateVehicle(496,1780.0527,-1069.8855,23.6963,359.9333,-1,-1,300); //
CreateVehicle(475,1770.8772,-1061.7114,23.7777,179.4641,-1,-1,300); //
CreateVehicle(439,1455.1497,-920.9672,37.5052,5.5309,-1,-1,300); //
CreateVehicle(429,1429.4189,-883.6742,50.4346,45.8230,-1,-1,300); //
CreateVehicle(451,1464.4940,-902.8561,54.5308,174.2450,-1,-1,300); //
CreateVehicle(506,1515.6870,-879.8787,61.2406,73.4542,-1,-1,300); //
CreateVehicle(458,1530.5291,-814.3157,71.7948,269.4181,-1,-1,300); //
CreateVehicle(535,1517.0182,-765.4269,79.7204,143.2556,-1,-1,300); //
CreateVehicle(522,1466.6241,-728.9778,92.5133,181.1646,-1,-1,300); //
CreateVehicle(473,220.9361,-1884.5100,0.6712,104.7747,-1,-1,300); //
CreateVehicle(413,327.8135,-1809.6460,4.5636,359.7770,-1,-1,300); //
CreateVehicle(439,311.7195,-1809.8710,4.3549,180.0079,-1,-1,300); //
CreateVehicle(496,334.3841,-1788.6083,4.5985,358.1154,-1,-1,300); //
CreateVehicle(411,407.1389,-1151.4436,76.6216,148.0546,-1,-1,300); //
CreateVehicle(542,412.7451,-1318.5364,14.6526,210.5239,-1,-1,300); //
CreateVehicle(521,407.4197,-1317.9996,14.4364,184.5406,-1,-1,300); //
CreateVehicle(451,437.4235,-1358.6813,14.5195,211.4208,-1,-1,300); //
CreateVehicle(589,534.3375,-1291.4130,16.8826,1.2699,-1,-1,300); //
CreateVehicle(589,557.2873,-1252.6322,23.9571,9.1276,-1,-1,300); //
CreateVehicle(429,777.4946,-1038.5548,23.9568,295.7044,-1,-1,300); //
CreateVehicle(510,886.6276,-1077.4546,22.2533,38.1756,-1,-1,300); //
CreateVehicle(510,895.1010,-1102.0125,24.2713,30.5671,-1,-1,300); //
CreateVehicle(487,1048.5839,-1126.7400,34.1342,180.0124,-1,-1,300); //
CreateVehicle(487,997.3099,-1126.3048,34.1367,180.0226,-1,-1,300); //
CreateVehicle(481,1022.1263,-1116.5179,46.8994,269.1056,-1,-1,300); //
CreateVehicle(487,1100.6816,-823.8624,114.6293,357.6167,-1,-1,300); //
CreateVehicle(530,1555.1361,-1361.7866,329.2292,102.3775,-1,-1,300); //
CreateVehicle(530,1562.4742,-1352.6710,317.1321,149.8573,-1,-1,300); //
CreateVehicle(481,1531.7068,-1345.4933,329.5552,98.1497,-1,-1,300); //
CreateVehicle(481,1527.1501,-1346.1804,329.5635,98.5874,-1,-1,300); //
CreateVehicle(481,1044.9282,-1979.0541,22.2237,86.3566,-1,-1,300); //
CreateVehicle(481,1122.5931,-2020.1888,75.2962,0.1933,-1,-1,300); //
CreateVehicle(481,1122.7039,-2052.9558,75.2969,0.1934,-1,-1,300); //
CreateVehicle(487,1116.3784,-2051.9336,74.7544,1.9295,-1,-1,300); //
CreateVehicle(487,1115.3145,-2020.8219,74.5769,181.8695,-1,-1,300); //
CreateVehicle(530,1117.7332,-2038.3767,78.2007,359.3811,-1,-1,300); //
CreateVehicle(589,1124.4852,-2060.1536,68.6659,180.1902,-1,-1,300); //
CreateVehicle(470,1329.8083,-2064.5691,57.6209,316.2113,-1,-1,300); //
CreateVehicle(470,1328.9896,-2048.7043,57.6373,231.6773,-1,-1,300); //
CreateVehicle(470,1400.3440,-1929.0981,16.8251,189.1199,-1,-1,300); //
CreateVehicle(470,1401.1307,-1934.0227,16.8682,189.6277,-1,-1,300); //
CreateVehicle(470,1399.2958,-1922.8922,17.0207,190.5815,-1,-1,300); //
CreateVehicle(470,1472.9833,-1980.8181,30.8101,117.7644,-1,-1,300); //
CreateVehicle(470,2106.7903,-1638.8962,19.2456,127.1419,-1,-1,300); //
CreateVehicle(470,2213.1094,-1725.1085,13.3798,287.3970,-1,-1,300); //
CreateVehicle(470,2217.1494,-1728.4348,13.3879,307.7044,-1,-1,300); //
CreateVehicle(470,2221.0938,-1734.4924,13.3947,335.5147,-1,-1,300); //
CreateVehicle(470,2480.9731,-1708.7979,13.5400,272.2556,-1,-1,300); //

//玩家
CreateVehicle(451,-2671.6809,1936.1288,3.2226,175.3689,-1,-1,300); // luck
CreateVehicle(560,2506.6377,-1694.5848,13.2429,179.0075,-1,-1,300); // bill
CreateVehicle(460,-1320.0217,2114.4058,44.3354,103.1373,-1,-1,300); // cat
CreateVehicle(469,-1378.8846,2111.6819,42.7757,225.4506,-1,-1,300); // cat
CreateVehicle(593,-1159.4781,2015.5386,136.1175,79.4745,-1,-1,300); //
CreateVehicle(476,-1401.2633,2186.1689,49.5630,53.8238,-1,-1,300); //
CreateVehicle(522,-1434.8383,2172.4902,49.3770,357.8292,-1,-1,300); //
CreateVehicle(468,-1433.2441,2172.4211,49.5376,346.8665,-1,-1,300); //
CreateVehicle(510,-1431.5654,2172.1228,49.5169,350.5066,-1,-1,300); //
CreateVehicle(471,-1433.4333,2174.9172,49.4706,2.9039,-1,-1,300); //
CreateVehicle(444,-1438.8536,2176.6394,50.3316,0.1693,-1,-1,300); //
CreateVehicle(571,-1433.4491,2179.6348,49.5052,351.9433,-1,-1,300); //
CreateVehicle(530,-1443.3344,2177.4099,49.5692,359.6790,-1,-1,300); //
CreateVehicle(446,-1375.8584,2125.6821,40.1227,263.5417,-1,-1,300); //
CreateVehicle(525,-1420.1195,2163.7947,48.5950,302.1138,-1,-1,300); //
CreateVehicle(470,-1432.4785,2183.4114,51.4581,299.6107,-1,-1,300); //
//CreateVehicle(447,-1371.6691,2118.1904,41.4322,247.6929,-1,-1,300); //
CreateVehicle(527,1580.1433,-2682.4685,13.4377,357.8649,-1,-1,300); // HuEi_Se
CreateVehicle(437,2074.5073,1686.5562,10.8130,0.7089,-1,-1,300); //baobiao
CreateVehicle(411,2075.5669,1670.4089,10.4010,360.0000,-1,-1,300); //
CreateVehicle(437,2074.6528,1661.3853,10.8315,1.0703,-1,-1,300); //
CreateVehicle(469,2096.3997,1702.9803,10.8585,0.0074,-1,-1,300); //
CreateVehicle(487,-790.6138,2433.6853,157.3280,181.5236,-1,-1,300); //huanxiang
CreateVehicle(409,-803.2639,2427.8386,156.8761,186.3806,-1,-1,300); //
CreateVehicle(451,-812.2735,2419.6042,156.5264,7.3420,-1,-1,300); //
//ls loco Savanna
CreateVehicle(567,2684.8457,-2020.9487,13.2580,357.7393,-1,-1,300); //
CreateVehicle(567,2645.2981,-1987.8892,13.2797,178.9127,-1,-1,300); //
CreateVehicle(567,2684.5686,-1986.9758,13.2792,181.1619,-1,-1,300); //
CreateVehicle(567,2640.5459,-2003.1964,13.2818,180.9460,-1,-1,300); //
//ls 旅馆
CreateVehicle(602,2227.7493,-1166.6039,25.4736,90.7066,-1,-1,300); //
CreateVehicle(411,2217.5305,-1170.8077,25.4491,90.7074,-1,-1,300); //
CreateVehicle(451,2206.1858,-1173.1838,25.4536,269.7255,-1,-1,300); //
CreateVehicle(579,2206.2458,-1160.9498,25.4537,269.7256,-1,-1,300); //陆虎?
CreateVehicle(480,2216.5564,-1157.1104,25.4430,267.3364,-1,-1,300); //
CreateVehicle(429,2228.2139,-1177.2090,25.4334,88.4573,-1,-1,300); //

//旅游
CreateVehicle(431,1460.2158,2843.1487,10.9383,180.2677,-1,-1,300); //
CreateVehicle(431,1470.0359,2842.7051,10.9491,0.1159,-1,-1,300); //
CreateVehicle(437,1479.7533,2842.3342,10.9850,0.1159,-1,-1,300); //
CreateVehicle(437,1489.2629,2842.3630,10.9787,180.5057,-1,-1,300); //
CreateVehicle(409,1529.0364,2836.2646,10.6993,88.5868,-1,-1,300); //
CreateVehicle(409,1529.2546,2845.0981,10.6476,88.5868,-1,-1,300); //
CreateVehicle(409,1528.8948,2831.7234,10.5843,88.5847,-1,-1,300); //
CreateVehicle(409,1529.1578,2840.5962,10.6568,88.7333,-1,-1,300); //
CreateVehicle(424,1460.2554,2879.5227,10.5817,180.0166,-1,-1,300); //
CreateVehicle(424,1464.7980,2879.5237,10.5817,180.0166,-1,-1,300); //
CreateVehicle(424,1469.3374,2879.5251,10.5817,180.0166,-1,-1,300); //
CreateVehicle(424,1473.8768,2879.5266,10.5817,180.0166,-1,-1,300); //
CreateVehicle(500,1478.0233,2878.9814,10.9267,180.5647,-1,-1,300); //
CreateVehicle(500,1482.5386,2879.0264,10.9265,180.5647,-1,-1,300); //
CreateVehicle(500,1486.9830,2879.0703,10.9264,180.5647,-1,-1,300); //
CreateVehicle(500,1491.6189,2879.1160,10.9262,180.5647,-1,-1,300); //
CreateVehicle(495,1495.9905,2879.2419,11.1162,179.2643,-1,-1,300); //
CreateVehicle(495,1500.3605,2879.1858,11.1197,179.2643,-1,-1,300); //
CreateVehicle(495,1504.9507,2879.1267,11.1234,179.2643,-1,-1,300); //
CreateVehicle(495,1509.4413,2879.0691,11.1269,179.2643,-1,-1,300); //
CreateVehicle(463,1422.1444,2826.0647,10.3609,270.2582,-1,-1,300); //
CreateVehicle(463,1422.1246,2830.4092,10.3608,270.2582,-1,-1,300); //
CreateVehicle(463,1422.1053,2834.7041,10.3608,270.2582,-1,-1,300); //
CreateVehicle(463,1422.0856,2839.0745,10.3608,270.2582,-1,-1,300); //
CreateVehicle(463,1422.0675,2843.1003,10.3608,270.2582,-1,-1,300); //
CreateVehicle(463,1422.0466,2847.6177,10.3567,270.2582,-1,-1,300); //
CreateVehicle(468,1422.0883,2851.6658,10.4847,269.3494,-1,-1,300); //
CreateVehicle(468,1422.1345,2855.7432,10.4843,269.3493,-1,-1,300); //
CreateVehicle(468,1422.1830,2860.0159,10.4839,269.3493,-1,-1,300); //
CreateVehicle(468,1422.2322,2864.3625,10.4835,269.3493,-1,-1,300); //
CreateVehicle(468,1422.2843,2868.9524,10.4830,269.3493,-1,-1,300); //
CreateVehicle(468,1422.3311,2873.0759,10.4826,269.3493,-1,-1,300); //
CreateVehicle(470,1455.7864,2879.1348,10.8134,180.7326,-1,-1,300); //
CreateVehicle(470,1451.4155,2879.0786,10.8135,180.7326,-1,-1,300); //
CreateVehicle(470,1446.8021,2879.0193,10.8136,180.7326,-1,-1,300); //
CreateVehicle(470,1442.5538,2878.9653,10.8138,180.7326,-1,-1,300); //
CreateVehicle(523,1473.1600,2812.0237,10.3908,277.5854,-1,-1,300); //
CreateVehicle(523,1472.6923,2815.5342,10.3908,277.5854,-1,-1,300); //
CreateVehicle(523,1499.2009,2810.1355,10.3847,62.4077,-1,-1,300); //
CreateVehicle(523,1500.6150,2812.8408,10.3846,62.4077,-1,-1,300); //
CreateVehicle(471,1530.6957,2854.2593,10.3428,91.0250,-1,-1,300); //
CreateVehicle(471,1530.6141,2858.8240,10.3350,91.0250,-1,-1,300); //
CreateVehicle(471,1530.5332,2863.3613,10.3271,91.0250,-1,-1,300); //
CreateVehicle(471,1530.4561,2867.6804,10.3197,91.0250,-1,-1,300); //
CreateVehicle(471,1530.3757,2872.1729,10.3119,91.0250,-1,-1,300); //
CreateVehicle(471,1530.7794,2849.5640,10.3509,91.0250,-1,-1,300); //
CreateVehicle(568,1530.4398,2827.2698,10.7085,87.8764,-1,-1,300); //
CreateVehicle(568,1530.2714,2822.7312,10.7063,87.8764,-1,-1,300); //
CreateVehicle(568,1530.0958,2818.0010,10.7041,87.8764,-1,-1,300); //
CreateVehicle(568,1529.9382,2813.7551,10.7021,87.8764,-1,-1,300); //
CreateVehicle(568,1529.7682,2809.1692,10.6999,87.8764,-1,-1,300); //
CreateVehicle(568,1529.5999,2804.6299,10.6977,87.8764,-1,-1,300); //
//=================[NAVY VEHICLES]=============================================
    /*CreateVehicle(494,-2271.2573,2294.3916,4.7153,269.6600,-1,-1,120);
	CreateVehicle(494,-2271.0291,2300.7029,4.7156,270.3062,-1,-1,120);
	CreateVehicle(494,-2271.2168,2305.7542,4.7158,267.1935,-1,-1,120);
	CreateVehicle(571,-2272.1204,2318.2117,4.1039,273.1187,-1,-1,120);
	CreateVehicle(571,-2272.8506,2321.6018,4.1042,264.1184,-1,-1,120);
	CreateVehicle(571,-2271.6641,2324.6003,4.1040,267.0034,-1,-1,120);
	CreateVehicle(571,-2271.4309,2326.6685,4.1040,273.5652,-1,-1,120);
	CreateVehicle(557,-2253.2625,2314.0952,5.1875,273.5021,-1,-1,120);
	CreateVehicle(557,-2252.6514,2302.5530,5.1875,268.3868,-1,-1,120);
	CreateVehicle(557,-2273.0586,2284.6157,5.2666,85.4380,-1,-1,120);*/
	CreateVehicle(441,-2242.8621,2341.9648,4.1104,181.2908,-1,-1,120);
	CreateVehicle(464,-2241.2493,2342.0806,4.1032,173.2190,-1,-1,120);
	CreateVehicle(501,-2238.5122,2342.0627,4.1032,176.5956,-1,-1,120);
	CreateVehicle(594,-2236.4492,2342.0947,4.1030,176.6222,-1,-1,120);
	//CreateVehicle(522,-2257.2798,2349.9741,4.4610,141.6942,-1,-1,120);
	//CreateVehicle(522,-2260.4285,2352.0505,4.4602,146.5680,-1,-1,120);
	//CreateVehicle(522,-2263.6545,2353.9380,4.4456,138.8166,-1,-1,120);
	//CreateVehicle(522,-2266.8335,2355.6912,4.4300,144.7810,-1,-1,120);
	//CreateVehicle(522,-2252.8179,2275.3242,4.5608,359.1619,-1,-1,120);
	//CreateVehicle(522,-2256.6782,2275.4563,4.5564,1.7463,-1,-1,120);
	//CreateVehicle(522,-2261.4216,2275.9858,4.5630,2.7924,-1,-1,120);
	CreateVehicle(443,-2245.7588,2371.3098,5.6334,133.9219,-1,-1,120);
	CreateVehicle(487,-2228.2024,2326.4795,7.7243,1.3074,-1,-1,120);
	CreateVehicle(446,-2239.9202,2259.6987,-0.4108,182.1104,-1,-1,120);
	CreateVehicle(446,-2257.6892,2261.6250,-0.5258,182.0853,-1,-1,120);
	CreateVehicle(446,-2269.4604,2258.4526,-0.6451,181.6100,-1,-1,120);
//=================[monstedm]=============================================
	/*CreateVehicle(444,2889.8472,1169.4668,10.8984,123.0059,-1,-1,2);
	CreateVehicle(556,2894.5837,1050.9775,10.8984,57.5186,-1,-1,2);
	CreateVehicle(557,2754.9634,1042.5928,10.8588,311.9243,-1,-1,2);
	CreateVehicle(444,2757.6431,1190.3247,10.8135,239.5437,-1,-1,2);
	CreateVehicle(556,2825.2405,1175.8285,10.8429,116.6434,-1,-1,2);
	CreateVehicle(557,2850.2627,1106.5421,10.8861,200.6900,-1,-1,2);
	CreateVehicle(444,2785.8386,1101.0029,10.8551,96.9757,-1,-1,2);
	CreateVehicle(556,2784.4170,1160.3075,10.8495,231.3736,-1,-1,2);
	CreateVehicle(557,2820.9885,1136.4963,10.8178,254.5605,-1,-1,2);*/
//=== [ Navy Mod NRG ] ===
    new mnrg = CreateVehicle(522,-2257.2798,2349.9741,4.4610,141.6942,252,0,-1); //
	new mnrg1= CreateVehicle(522,-2260.4285,2352.0505,4.4602,146.5680,252,0,-1); //
	new mnrg2= CreateVehicle(522,-2263.6545,2353.9380,4.4456,138.8166,252,0,-1); //
	new mnrg3= CreateVehicle(522,-2266.8335,2355.6912,4.4300,144.7810,252,0,-1); //
	new mnrg4= CreateVehicle(522,-2252.8179,2275.3242,4.5608,359.1619,252,0,-1); //
	new mnrg5= CreateVehicle(522,-2256.6782,2275.4563,4.5564,1.7463,252,0,-1); //
	new mnrg6= CreateVehicle(522,-2261.4216,2275.9858,4.5630,2.7924,252,0,-1); //

	AddVehicleComponent(mnrg, 1079);
	AddVehicleComponent(mnrg1, 1079);
	AddVehicleComponent(mnrg2, 1079);
	AddVehicleComponent(mnrg3, 1079);
	AddVehicleComponent(mnrg4, 1079);
	AddVehicleComponent(mnrg5, 1079);
	AddVehicleComponent(mnrg6, 1079);
//==========================[ADMIN CITY]========================================
	CreateVehicle(415,3068.3054,-3093.7605,3.3355,78.8218,-1,-1,120);
	CreateVehicle(480,3066.6335,-3103.4705,3.3363,75.5378,-1,-1,120);
	//CreateVehicle(596,3009.7607,-3025.4436,3.4891,255.4204,-1,-1,120);
	//CreateVehicle(596,3010.5503,-3022.1777,3.4892,255.5947,-1,-1,120);
	CreateVehicle(496,2790.1396,-3055.2373,4.1548,345.8990,-1,-1,120);
	CreateVehicle(521,2732.6875,-3031.3254,7.0553,77.2441,-1,-1,120);
	CreateVehicle(446,2732.2258,-3002.5815,-0.3143,348.3586,-1,-1,120);
	CreateVehicle(455,2828.7505,-2977.7366,4.6392,344.0300,-1,-1,120);
	CreateVehicle(472,2864.5615,-2978.9685,-0.4619,257.0977,-1,-1,120);
	CreateVehicle(454,3038.7439,-3279.0964,0.7309,82.9488,-1,-1,120);
	CreateVehicle(416,3044.5234,-3015.5098,3.9253,169.7763,-1,-1,120);
	CreateVehicle(416,3070.0188,-3022.7021,3.9255,166.9067,-1,-1,120);
	CreateVehicle(487,3024.1147,-3100.7485,20.5159,168.1974,-1,-1,120);
	CreateVehicle(497,2991.5930,-3034.1331,22.8920,350.0710,-1,-1,120);
	CreateVehicle(487,3023.8137,-2993.4917,15.9710,256.4415,-1,-1,120);
	CreateVehicle(470,3008.3059,-3094.9075,3.5214,169.7442,-1,-1,120);
	return 1;
}

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

public DynUpdateStart(playerid)
{
TogglePlayerControllable(playerid, false); // Freeze
new string[255];
format(string, sizeof(string), "~g~Objects~n~~r~Loading");
GameTextForPlayer(playerid, string, 3000, 6);
PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
SetTimerEx("DynUpdateEnd", 2000, 0,"e",playerid);
return 1;
}

public DynUpdateEnd(playerid)
{
TogglePlayerControllable(playerid, true); // Unfreeze
new string[255];
format(string, sizeof(string), "~g~Objects~n~~r~Loaded!");
GameTextForPlayer(playerid, string, 3000, 6);
PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
return 1;
}



stock ReturnPlayerName(playerid){
	new
		name[MAX_PLAYER_NAME];
	name = "none";
	if(IsPlayerConnected(playerid)){
		GetPlayerName(playerid,name,sizeof(name));
	}
	return name;


}

stock SetPlayerToSpawn(playerid,spawn_position){
	switch(spawn_position){
		case DM_NONE:{
			new r = random(sizeof(spawns));
			SetPlayerPos(playerid, spawns[r][ex], spawns[r][ey], spawns[r][ez]);
			SetPlayerInterior(playerid, spawns[r][interior]);
			SendClientMessage(playerid, COLOR_WHITE, spawns[r][emsg]);
		}
		case DM_TANK:
			OnPlayerCommandText(playerid,"/dm 11");
		case DM_BEACH:
			OnPlayerCommandText(playerid,"/dm 4");
		case DM_DILDO:
			OnPlayerCommandText(playerid,"/dm 9");
		case DM_SMG:
			OnPlayerCommandText(playerid,"/dm 10");
		case DM_RING:
			OnPlayerCommandText(playerid,"/dm 5");
		case DM_BOX:
			OnPlayerCommandText(playerid,"/dm 7");
		case DM_AK:
			OnPlayerCommandText(playerid,"/dm 1");
		case DM_TENNIS:
			OnPlayerCommandText(playerid,"/tennisdm");
		case DM_SNIPER:
			OnPlayerCommandText(playerid,"/dm 2");
		case DM_FARM:
			OnPlayerCommandText(playerid,"/dm 6");
		case DM_TOWN:
			OnPlayerCommandText(playerid,"/dm 3");
		case DM_KATANA:
			OnPlayerCommandText(playerid,"/dm 8");
		case DM_ROCKET:
			OnPlayerCommandText(playerid,"/rocketdm");
	}
}


stock randplayer(){
	for(new randid;randid<MAX_PLAYERS;randid++){
		if(IsPlayerConnected(randid)){
			while(TRUE){
				randid=random(MAX_PLAYERS);
				if(IsPlayerConnected(randid)) return randid;
			}
		}
	}
	return INVALID_PLAYER_ID;
}
public Sync_pScore(){
	for(new i;i<MAX_PLAYERS;i++){
		if(IsPlayerConnected(i)){
			SetPlayerScore(i,GetPlayerMoney(i));
		}
	}
	return true;
}
