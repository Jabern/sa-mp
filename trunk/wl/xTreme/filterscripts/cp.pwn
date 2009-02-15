#include <a_samp>

#define FILTERSCRIPT
#define MAX_CHECKPOINTS 200
#define FILE "savepos.txt"
#define TIME 1000
#define DISTANCE 200
#define CPSIZE 2

#define WHITE 0xFFFFFFAA

//new PlayerCPID[MAX_PLAYERS];
enum CPPosEnum { Float:X,Float:Y,Float:Z,iname[MAX_PLAYER_NAME] };
new CPs[MAX_CHECKPOINTS][CPPosEnum];
enum TargetPosEnum { Float:X,Float:Y,Float:Z };
new Target[MAX_CHECKPOINTS][TargetPosEnum];
new PlayerCCP[MAX_PLAYERS];
new Info[MAX_CHECKPOINTS];
new tmpi[MAX_PLAYERS];
enum PosEnum { Float:CX,Float:CY,Float:CZ,Float:TX,Float:TY,Float:TZ };
new Pos[MAX_PLAYERS][PosEnum];
//new Float:NewCPs[MAX_CHECKPOINTS][4];

forward AddCheckpoint();
forward DestroyCheckpoint();
forward AddI();
forward DynUpdateStart(playerid);
forward DynUpdateEnd(playerid);

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

stock SavePos(&Float:cx,&Float:cy,&Float:cz,&Float:tx,&Float:ty,&Float:tz,Name[])
{
	new string[256];
	for (new i = 0;i <= MAX_CHECKPOINTS;i++)
	{
		if(CPs[i][X] == 0.0 && CPs[i][Y] == 0.0 && CPs[i][Z] == 0.0 && Target[i][X] == 0.0 && Target[i][Y] == 0.0 && Target[i][Y] == 0.0)
		{
		    CPs[i][X] = cx; CPs[i][Y] = cy; CPs[i][Z] = cz;
		    format(CPs[i][iname],MAX_PLAYER_NAME,"%s",Name);
		    Target[i][X] = tx; Target[i][Y] = ty; Target[i][Z] = tz;
            Info[i] = CreatePickup(1239,2,cx,cy,cz);
		    if(fexist(FILE))
		    {
				new File:CFile = fopen(FILE,io_append);
				format(string,sizeof(string),"//-------i������:%s-------\r\nformat(CPs[%d][iname],MAX_PLAYER_NAME,\"%s\");\r\nCPs[%d][X] = %f; CPs[%d][Y] = %f; CPs[%d][Z] = %f;\r\nTarget[%d][X] = %f; Target[%d][Y] = %f; Target[%d][Z] = %f;\r\n\r\n",Name,i,Name,i,cx,i,cy,i,cz,i,tx,i,ty,i,tz);
				fwrite(CFile,string);
				fclose(CFile);
		    } else {
  				new File:CFile = fopen(FILE,io_write);
				format(string,sizeof(string),"//-------i������:%s-------\r\nCPs[%d][iname] = %s\r\nCPs[%d][X] = %f; CPs[%d][Y] = %f; CPs[%d][Z] = %f;\r\nTarget[%d][X] = %f; Target[%d][Y] = %f; Target[%d][Z] = %f;\r\n\r\n",Name,i,Name,i,cx,i,cy,i,cz,i,tx,i,ty,i,tz);
				fwrite(CFile,string);
				fclose(CFile);
		    }
		    i = MAX_CHECKPOINTS;
		}
	}
	return 1;
}

public AddCheckpoint()
{
	//��savepos.txt�еĶ�����������,�������ñ���i��.
	//-------i������:ls2lv-------
	format(CPs[0][iname],MAX_PLAYER_NAME,"/lv");
	CPs[0][X] = 1411.101074; CPs[0][Y] = -2475.069824; CPs[0][Z] = 13.554687;
	Target[0][X] = 1327.258178; Target[0][Y] = 1262.324584; Target[0][Z] = 10.820312;
	//-------i������:lv2sf-------
	format(CPs[1][iname],MAX_PLAYER_NAME,"/sf");
	CPs[1][X] = 1343.721313; CPs[1][Y] = 1266.789916; CPs[1][Z] = 10.820312;
	Target[1][X] = -1658.292602; Target[1][Y] = -182.331451; Target[1][Z] = 14.148437;
	//-------i������:sf2aa-------
	format(CPs[2][iname],MAX_PLAYER_NAME,"/aa");
	CPs[2][X] = -1625.150756; CPs[2][Y] = -170.416275; CPs[2][Z] = 14.546875;
	Target[2][X] = 432.334350; Target[2][Y] = 2536.598876; Target[2][Z] = 16.302120;
	//-------i������:aa2ls-------
	format(CPs[3][iname],MAX_PLAYER_NAME,"/ls");
	CPs[3][X] = 379.688903; CPs[3][Y] = 2479.267333; CPs[3][Z] = 16.484375;
	Target[3][X] = 1442.907348; Target[3][Y] = -2417.336425; Target[3][Z] = 13.554687;
	//-------i������:lc-------
	format(CPs[4][iname],MAX_PLAYER_NAME,"/lc");
	CPs[4][X] = 1463.214843; CPs[4][Y] = 2814.702636; CPs[4][Z] = 10.820312;
	Target[4][X] = -784.331420; Target[4][Y] = 502.024566; Target[4][Z] = 1381.601196;
	//-------i������:lvyou-------
	format(CPs[5][iname],MAX_PLAYER_NAME,"/����");
	CPs[5][X] = -781.240112; CPs[5][Y] = 486.932098; CPs[5][Z] = 1381.574951;
	Target[5][X] = 1507.767944; Target[5][Y] = 2807.515869; Target[5][Z] = 10.824650;
	AddI();
	return 1;
}

public AddI()
{
	for (new i = 0;i <= MAX_CHECKPOINTS;i++)
	{
	    if(CPs[i][X] == 0.0 && CPs[i][Y] == 0.0 && CPs[i][Z] == 0.0 && Target[i][X] == 0.0 && Target[i][Y] == 0.0 && Target[i][Y] == 0.0)
		{
		    //do nothing
		} else {
        	CreatePickup(1239,2,CPs[i][X],CPs[i][Y],CPs[i][Z]);
		}
	}
}

public DestroyCheckpoint()
{
	for (new j = 0;j <= MAX_CHECKPOINTS;j++)
	{
	    if(!strlen(Info[j]))
	    {
	    	DestroyPickup(Info[j]);
	    }
	}
	return 1;
}

/*public OnPlayerEnterCheckpoint(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(playerid,Target[PlayerCPID[playerid]][X],Target[PlayerCPID[playerid]][Y],Target[PlayerCPID[playerid]][Z]);
	else SetPlayerPos(playerid,Target[PlayerCPID[playerid]][X],Target[PlayerCPID[playerid]][Y],Target[PlayerCPID[playerid]][Z]);
	return 1;
}*/

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(PlayerCCP[playerid] == 1 || PlayerCCP[playerid] == 2 || PlayerCCP[playerid] == 3)
	{
		SendClientMessage(playerid,WHITE," ����/i e�˳�����ģʽ���ܴ���.");
		DestroyPickup(pickupid);
		CreatePickup(1239,2,CPs[pickupid][X],CPs[pickupid][Y],CPs[pickupid][Z]);
	} else {
		if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(playerid,Target[pickupid][X],Target[pickupid][Y],Target[pickupid][Z]);
		else SetPlayerPos(playerid,Target[pickupid][X],Target[pickupid][Y],Target[pickupid][Z]);
		DynUpdateStart(playerid);
		new str[256];
		format(str,sizeof(str),"[����] %s ���ͳɹ�",CPs[pickupid][iname]);
		SendClientMessage(playerid,WHITE,str);
		DestroyPickup(pickupid);
		CreatePickup(1239,2,CPs[pickupid][X],CPs[pickupid][Y],CPs[pickupid][Z]);
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new tmp[128];
	new tmp2[128];
	new cmd[128];
	new idx;
	cmd = strtok(cmdtext,idx);
	
	if (IsPlayerAdmin(playerid))
	{
		if(strcmp(cmd, "/i", true) == 0)
		{
            tmp = strtok(cmdtext,idx);
            if(!strlen(tmp)) OnPlayerCommandText(playerid,"/i h");
            if(strcmp(tmp, "h",true) == 0)
            {
		    	SendClientMessage(playerid,WHITE," ��������:");
		    	SendClientMessage(playerid,WHITE," /i b [���봴��ģʽ] /i c [����i��] /i t [����Ŀ��]");
				SendClientMessage(playerid,WHITE," /i d [ɾ��i��] /i s [����i��] /i e [�˳�����ģʽ]");
			}
   			if(strcmp(tmp, "b",true) == 0)
            {
		    	if(CPs[199][X] != 0.0 && CPs[199][X] != 0.0 && CPs[199][X] != 0.0)
		    	{
		        	SendClientMessage(playerid,WHITE," �Ѵﵽi������(200��),���ܴ���,��������������������AddCheckpoint()����.");
		    	} else {
	   	 			//PlayerCPID[playerid] = -1;
					PlayerCCP[playerid] = 1;
					SendClientMessage(playerid,WHITE," �������i�㴴��ģʽ,����/i c����i��,����/i e�˳�ģʽ.");
				}
			}
			if (strcmp(tmp,"c", true) == 0)
			{
		    	if (PlayerCCP[playerid] == 1)
		    	{
		        	PlayerCCP[playerid] = 2;
		        	//printf("ccp:%d",PlayerCCP[playerid]);
		        	GetPlayerPos(playerid,Pos[playerid][CX],Pos[playerid][CY],Pos[playerid][CZ]);
                	tmpi[playerid] = CreatePickup(1239,13,Pos[playerid][CX],Pos[playerid][CY],Pos[playerid][CZ]);
					//SetPlayerCheckpoint(playerid,Pos[playerid][CX],Pos[playerid][CY],Pos[playerid][CZ],CPSIZE);
					SendClientMessage(playerid,WHITE," �㴴����һ��i��,����Ŀ��ص��,����/i t,����/i dɾ��,����/i e�˳�ģʽ.");
	   			} else {
					if (PlayerCCP[playerid] == 0) SendClientMessage(playerid,WHITE," ��������/i b����i�㴴��ģʽ.");
		    		if (PlayerCCP[playerid] == 2) SendClientMessage(playerid,WHITE," ���Ѵ���i��,����/i dɾ��Ȼ��/i c.");
				}
			}
			if (strcmp(tmp,"t", true) == 0)
			{
				//printf("tcp:%d",PlayerCCP[playerid]);
		    	if (PlayerCCP[playerid] == 2)
		    	{
		        	GetPlayerPos(playerid,Pos[playerid][TX],Pos[playerid][TY],Pos[playerid][TZ]);
					SetPlayerCheckpoint(playerid,Pos[playerid][TX],Pos[playerid][TY],Pos[playerid][TZ],CPSIZE);
		        	PlayerCCP[playerid] = 3;
		        	SendClientMessage(playerid,WHITE," ����������Ŀ��,����/i s����,����/i e�˳�ģʽ,����/i dɾ��.");
		    	} else {
					if (PlayerCCP[playerid] == 0) SendClientMessage(playerid,WHITE," ��������/i b����i�㴴��ģʽ.");
		    		if (PlayerCCP[playerid] == 1) SendClientMessage(playerid,WHITE," �㻹û����i��,����/i c����i��.");
				}
			}
			if (strcmp(tmp,"d", true) == 0)
			{
		    	//printf("dcp:%d",PlayerCCP[playerid]);
		    	if (PlayerCCP[playerid] == 2 || PlayerCCP[playerid] == 3)
		    	{
		        	Pos[playerid][TX] = 0; Pos[playerid][TY] = 0; Pos[playerid][TZ] = 0;
	         		Pos[playerid][CX] = 0; Pos[playerid][CY] = 0; Pos[playerid][CZ] = 0;
	         		DisablePlayerCheckpoint(playerid);
					DestroyPickup(tmpi[playerid]);
					tmpi[playerid] = -1;
	         		PlayerCCP[playerid] = 1;
		        	SendClientMessage(playerid,WHITE," ����ɾ����i��,����/i e�˳�ģʽ.");
		    	} else {
					if (PlayerCCP[playerid] == 0) SendClientMessage(playerid,WHITE," ��������/i b����i�㴴��ģʽ.");
		    		if (PlayerCCP[playerid] == 1) SendClientMessage(playerid,WHITE," �㻹û����i��,����/i c����i��.");
				}
			}
			if (strcmp(tmp,"s", true) == 0)
			{
		    	//printf("scp:%d",PlayerCCP[playerid]);
            	tmp2 = strtok(cmdtext, idx);
            	if (!strlen(tmp2))
				{
					SendClientMessage(playerid,WHITE," �÷�:/i s [����]");
				} else {
            		if (strlen(tmp2) > 24)
					{
						SendClientMessage(playerid,WHITE," i�����Ʊ���С��24���ַ�.");
					} else {
	    				if (PlayerCCP[playerid] == 3)
   						{
     						DisablePlayerCheckpoint(playerid);
     						DestroyPickup(tmpi[playerid]);
     						SavePos(Pos[playerid][CX],Pos[playerid][CY],Pos[playerid][CZ],Pos[playerid][TX],Pos[playerid][TY],Pos[playerid][TZ],tmp2);
      						SendClientMessage(playerid,WHITE," ���ѱ���i��,����/i e�˳�ģʽ.");
 							SendClientMessage(playerid,WHITE," ����λ��:scriptfiles/savepos.txt.");
						} else {
							if (PlayerCCP[playerid] == 0) SendClientMessage(playerid,WHITE," ��������/i b����i�㴴��ģʽ.");
		    				if (PlayerCCP[playerid] == 1) SendClientMessage(playerid,WHITE," �㻹û����i��,����/i c����i��.");
		    				if (PlayerCCP[playerid] == 2) SendClientMessage(playerid,WHITE," �㻹û����Ŀ���,����/i t����.");
						}
					}
				}
			}
			if (strcmp(tmp,"e", true) == 0)
			{
		    	if (PlayerCCP[playerid] == 1 || PlayerCCP[playerid] == 2 || PlayerCCP[playerid] == 3)
		    	{
					SendClientMessage(playerid,WHITE," ���ѱ��˳�i�㴴��ģʽ.");
					PlayerCCP[playerid] = 0;
   	 			} else {
					if (PlayerCCP[playerid] == 0) SendClientMessage(playerid,WHITE," ��������/i b����i�㴴��ģʽ.");
				}
			}
			return 1;
		}
	}
	return 0;
}

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" i�㴫��ϵͳ by Cn_Shindo �ѳɹ�����!");
	print("--------------------------------------\n");
	AddCheckpoint();
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print(" i�㴫��ϵͳ by Cn_Shindo �ѳɹ��˳�!");
	print("--------------------------------------\n");
	for (new i = 0;i <= MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlayerAdmin(i))
	        {
	            if(PlayerCCP[i] == 1 || PlayerCCP[i] == 2 || PlayerCCP[i] == 3)
	            {
	            	DisablePlayerCheckpoint(i);
	            }
	        }
	    }
	}
	DestroyCheckpoint();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DisablePlayerCheckpoint(playerid);
	//PlayerCPID[playerid] = -1;
	tmpi[playerid] = -1;
	PlayerCCP[playerid] = 0;
	//i tmer[playerid] = -1;
	return 1;
}

public OnPlayerConnect(playerid)
{
    DisablePlayerCheckpoint(playerid);
	//PlayerCPID[playerid] = -1;
	tmpi[playerid] = -1;
	PlayerCCP[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    DisablePlayerCheckpoint(playerid);
	//PlayerCPID[playerid] = -1;
	PlayerCCP[playerid] = 0;
	tmpi[playerid] = -1;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (PlayerCCP[playerid] == 1 || PlayerCCP[playerid] == 2 || PlayerCCP[playerid] == 3) SendClientMessage(playerid,WHITE," ���˳���i�㴴��ģʽ.");
    DisablePlayerCheckpoint(playerid);
	//PlayerCPID[playerid] = -1;
	PlayerCCP[playerid] = 0;
	tmpi[playerid] = -1;
	return 1;
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

