//==Dev Group:GCS Script Team==//
//==Our Website:www.sa-mp.com.cn==//

//==Car System:sat with 未来世界==//

//==Temporarily has no license owned because this source is not strong enough.==//


//---------------------Car System---------------------//
//Date start:1/28/2009
//Date end:still test
//Remarks:none
//----------------------------------------------------//

#include <a_samp>

#pragma dynamic 145000

#define MAX_STRING				(128)
#define COLOR_SYSTEM			(0x0AFF0AAA)//green~~



new const bool:FALSE=false;
new const bool:TRUE=true;
#define CS_MsgSend(%1,%2,%3)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessage((%1),COLOR_SYSTEM,sendfstring);}while(FALSE)
stock CS_MsgSend(playerid,const sendfstring[]){
	SendClientMessage(playerid,COLOR_SYSTEM,sendfstring);
	return TRUE;
}
#define CS_MsgSendToAll(%1,%2)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%1),%2);SendClientMessageToAll(COLOR_SYSTEM,sendfstring);}while(FALSE)
stock CS_MsgSendToAll(const sendfstring[]){
	SendClientMessageToAll(COLOR_SYSTEM,sendfstring);
	return TRUE;
}




#define dcmd(%1,%2,%3)            if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
forward CS_PutPlayerInVehicle(playerid,vehicleid,seatid);
public CS_PutPlayerInVehicle(playerid,vehicleid,seatid){
	PutPlayerInVehicle(playerid,vehicleid,seatid);
	return true;
}

/*----------------------------------------------------------------------------*-
Function:
sscanf
Params:
string[] - String to extract parameters from.
format[] - Parameter types to get.
{Float,_}:... - Data return variables.
Return:
0 - Successful, not 0 - fail.
Notes:
A fail is either insufficient variables to store the data or insufficient
data for the format string - excess data is disgarded.
 
A string in the middle of the input data is extracted as a single word, a
string at the end of the data collects all remaining text.
 
The format codes are:
 
c - A character.
d, i - An integer.
h, x - A hex number (e.g. a colour).
f - A float.
s - A string.
z - An optional string.
pX - An additional delimiter where X is another character.
'' - Encloses a litteral string to locate.
u - User, takes a name, part of a name or an id and returns the id if they're connected.
 
Now has IsNumeric integrated into the code.
 
Added additional delimiters in the form of all whitespace and an
optioanlly specified one in the format string.
-*----------------------------------------------------------------------------*/
stock sscanf(string[], format[], {Float,_}:...){
#if defined isnull
	if (isnull(string))
#else
	if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
#endif
	{
		return format[0];
	}
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' '){
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos]){
		switch (format[formatPos++]){
			case '\0':{
				return 0;
			}
			case 'i', 'd':{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-'){
					neg = -1;
					ch = string[++stringPos];
				}
				do{
					stringPos++;
					if ('0' <= ch <= '9'){
						num = (num * 10) + (ch - '0');
					}else{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
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
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':{
				delim = format[formatPos++];
				continue;
			}
			case '\'':{
			new
				end = formatPos - 1,
				ch;
			while ((ch = format[++end]) && ch != '\''){}
			if (!ch){
				return -1;
			}
			format[end] = '\0';
			if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1){
				if (format[end + 1]){
					return -1;
				}
				return 0;
			}
			format[end] = '\'';
			stringPos = ch + (end - formatPos);
			formatPos = end + 1;
			}
			case 'u':{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim){
					if (num){
						if ('0' <= ch <= '9'){
							id = (id * 10) + (ch - '0');
						}else{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id)){
					setarg(paramPos, 0, id);
				}else{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid){
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id)){
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num){
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
						#endif
				}
				stringPos = end;
			}
			case 's', 'z':{
				new
					i = 0,
					ch;
				if (format[formatPos]){
					while ((ch = string[stringPos++]) && ch != delim){
						setarg(paramPos, i++, ch);
					}
					if (!i){
						return -1;
					}
				}else{
					while ((ch = string[stringPos++])){
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' '){
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' ')){
			stringPos++;
		}
		paramPos++;
	}
	do{
		if ((delim = format[formatPos++]) > ' '){
			if (delim == '\''){
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}else if (delim != 'z'){
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}


enum CS_pInfo_{
	Vec_Death,
	Vec_Owned,
	pvid,
	bool:Vec_Locked
}
new CS_pInfo[MAX_PLAYERS][CS_pInfo_];
new Invalid_Vec;
new CS_PutPlayerInVehicle_Timer[MAX_PLAYERS];

stock CS_pProcessing(playerid){
	return (
	IsPlayerConnected(playerid) &&
	GetPlayerState(playerid) != PLAYER_STATE_SPAWNED && 
	GetPlayerState(playerid) != PLAYER_STATE_WASTED && 
	GetPlayerState(playerid) != PLAYER_STATE_SPECTATING
	)?true:false;
}
stock RetpName(playerid){
	new
		name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
stock CS_VecOwned(vehicleid){
	for(new i;i<MAX_PLAYERS;i++){
		if(CS_pInfo[i][Vec_Owned] == vehicleid)
			return i;
	}
	return INVALID_PLAYER_ID;
}

stock CS_pInVec(vehicleid){
	for(new i;i<MAX_PLAYERS;i++){
		if(CS_pInfo[i][pvid] == vehicleid)
			return i;
	}
	return INVALID_PLAYER_ID;
}
stock CS_HelpPlayer(playerid){
	if(!CS_pProcessing(playerid))return false;
	CS_MsgSend(playerid,"====================帮助=================");
	CS_MsgSend(playerid,"/car woyao(我要) 即可拥有一辆车");
	CS_MsgSend(playerid,"/car rengdiao(扔掉) 可以扔掉你的家车");
	CS_MsgSend(playerid,"/car wode(我的) 可以叫你家车过来");
	CS_MsgSend(playerid,"/car ti(踢) 踢掉你的乘客");
	CS_MsgSend(playerid,"/car suo(锁) 可以锁车");
	CS_MsgSend(playerid,"/car sos(帮助) 查看帮助");
	CS_MsgSend(playerid,"=========================================");
	return true;
}
//---------------------------扔---------------------------------//
stock CS_ThrowPlayer(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(CS_pInfo[playerid][pvid] != CS_pInfo[playerid][Vec_Owned]){
		new
			Float:ftmp[3],
			tmpval[2];
		tmpval[0] = GetPlayerState(playerid);
		tmpval[1] = GetPlayerState(CS_VecOwned(CS_pInfo[playerid][pvid]));
		GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
		RemovePlayerFromVehicle(playerid);
		SetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]+3);
		if(tmpval[0] == PLAYER_STATE_DRIVER && tmpval[1] == PLAYER_STATE_DRIVER){
			KillTimer(CS_PutPlayerInVehicle_Timer[CS_VecOwned(CS_pInfo[playerid][pvid])]);
			CS_PutPlayerInVehicle_Timer[CS_VecOwned(CS_pInfo[playerid][pvid])]=SetTimerEx("CS_PutPlayerInVehicle",1000,false,"iii",CS_VecOwned(CS_pInfo[playerid][pvid]),CS_pInfo[playerid][pvid],0);
			//PutPlayerInVehicle(CS_VecOwned(CS_pInfo[playerid][pvid]),CS_pInfo[playerid][pvid],0);
		}
		CS_MsgSend(playerid,"[车管]%s自言自语道:'奇怪,我被扔出去了?( %s 在阴笑)'",RetpName(playerid),RetpName(CS_VecOwned(CS_pInfo[playerid][pvid])));
		
	}
	return true;
}

stock CS_UnThrowPlayer(playerid){
	if(!CS_pProcessing(playerid))return false;
	CS_MsgSend(playerid,"[车管]该车属于 %s的,想要吗?私人解决",RetpName(CS_VecOwned(CS_pInfo[playerid][pvid])));
	CS_MsgSend(CS_VecOwned(CS_pInfo[playerid][pvid]),"[车管]%s想做你车,感想如何?",RetpName(playerid));
	return true;
}
//--------------------------------------------------------------//
//---------------------------踢---------------------------------//
stock CS_Vec_Kick_Start(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(!CS_pInfo[playerid][Vec_Owned]){
		CS_MsgSend(playerid,"[车管]你都没车,踢空气?");
		return false;
	}else if(CS_pInVec(CS_pInfo[playerid][Vec_Owned]) == INVALID_PLAYER_ID){
		CS_MsgSend(playerid,"[车管]你车上没人啊,别乱踢");
	}else{
		CS_Vec_Kick_End(playerid);
		return true;
	}
	return true;
}
stock CS_Vec_Kick_End(playerid){
	if(!CS_pProcessing(playerid))return false;
	for(new i;i<MAX_PLAYERS;i++){
		if(i != playerid && CS_pInfo[i][pvid] == CS_pInfo[playerid][Vec_Owned]){
			CS_ThrowPlayer(i);
		}
	}
	return true;
}
//---------------------------锁---------------------------------//
stock CS_Vec_Lock_Start(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(!CS_pInfo[playerid][Vec_Owned]){
		CS_MsgSend(playerid,"[车管]你都没车,锁空气?");
		return false;
	}else{
		CS_Vec_Lock_End(playerid);
		return true;
	}
}

stock CS_Vec_Lock_End(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(CS_pInfo[playerid][Vec_Locked]){
		CS_pInfo[playerid][Vec_Locked] = false;
		CS_MsgSend(playerid,"[车管]你的车已解锁");
	}else{
		CS_pInfo[playerid][Vec_Locked] = true;
		CS_MsgSend(playerid,"[车管]你的车已上锁");
	}
	return true;
}
//--------------------------------------------------------------//
//---------------------------叫---------------------------------//
stock CS_Vec_Call_Start(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(!CS_pInfo[playerid][Vec_Owned]){
		CS_MsgSend(playerid,"[车管]你都没车,叫什么叫");
		return true;
	}else if(CS_pInfo[playerid][Vec_Death]){
		CS_MsgSend(playerid,"[车管]你的车暂时传送不了");
		return false;
	}else{
		SetVehicleHealth(CS_pInfo[playerid][Vec_Death],1000);
		CS_Vec_Call_End(playerid);
	}
	return true;
}

stock CS_Vec_Call_End(playerid){
	if(!CS_pProcessing(playerid))return false;
	for(new i;i<MAX_PLAYERS;i++){
		if(IsPlayerInVehicle(i,CS_pInfo[playerid][Vec_Owned])){
			CS_ThrowPlayer(i);
		}
	}
	new
		Float:ftmp[3];
	GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
	SetVehiclePos(CS_pInfo[playerid][Vec_Owned],ftmp[0],ftmp[1],ftmp[2]);
	PutPlayerInVehicle(playerid,CS_pInfo[playerid][Vec_Owned],0);
	SetVehicleHealth(CS_pInfo[playerid][Vec_Death],1000);
	CS_MsgSend(playerid,"[车管]你的车传送成功!");
	return true;
}
//--------------------------------------------------------------//
//---------------------------买---------------------------------//
stock CS_Vec_Owned_Start(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(CS_pInfo[playerid][pvid]){
		if(CS_VecOwned(CS_pInfo[playerid][pvid]) != INVALID_PLAYER_ID){
			CS_MsgSend(playerid,"[车管]该车属于 %s的,想要吗?私人解决",RetpName(CS_VecOwned(CS_pInfo[playerid][pvid])));
			return false;
		}else if(CS_pInfo[playerid][Vec_Owned]){
			CS_MsgSend(playerid,"[车管]你已经有一辆车了,不要太贪心哦(输入/car wode 可以叫车过来)");
			return false;
		}
		CS_Vec_Owned_End(playerid);
		return true;
	}
	CS_MsgSend(playerid,"[车管]你要空气啊?上车再要车吧");
	return false;
}

stock CS_Vec_Owned_End(playerid){
	if(!CS_pProcessing(playerid))return false;
	CS_pInfo[playerid][Vec_Owned] = CS_pInfo[playerid][pvid];
	CS_pInfo[playerid][Vec_Locked] = true;
	SetVehicleHealth(CS_pInfo[playerid][pvid],1000);
	CS_MsgSend(playerid,"[车管]现在车属于 %s的,已经自动上锁(输入/car sos 查看帮助",RetpName(playerid));
	return true;
}
//--------------------------------------------------------------//	
//---------------------------卖---------------------------------//
stock CS_Vec_UnOwned_Start(playerid){
	if(!CS_pProcessing(playerid))return false;
	if(CS_pInfo[playerid][Vec_Owned]){
		if(CS_pInVec(CS_pInfo[playerid][Vec_Owned]) != INVALID_PLAYER_ID){
			CS_ThrowPlayer(CS_pInVec(CS_pInfo[playerid][Vec_Owned]));
		}
		CS_Vec_UnOwned_End(playerid);
		return true;
	}else{
		CS_MsgSend(playerid,"[车管]你都没车,想干嘛呢(输入/car woyao即可拥有一辆车)");
		return false;
	}
//	return false;
}

stock CS_Vec_UnOwned_End(playerid){
	if(!CS_pProcessing(playerid))return false;
	CS_pInfo[playerid][Vec_Owned] = Invalid_Vec;
	CS_pInfo[playerid][Vec_Locked] = false;
	CS_pInfo[playerid][Vec_Death] = false;
	CS_MsgSend(playerid,"[车管]你扔掉你的老车了,赶快去寻找你心仪的车车");
	return true;
}
//--------------------------------------------------------------//
public OnFilterScriptInit(){
	print("//---------------------------------------//");
	print("//------------->Car-System<--------------//");
	print("//----------->GCS Script Team<-----------//");
	print("//---------------------------------------//");
	Invalid_Vec = GetPlayerVehicleID(INVALID_PLAYER_ID);
	for(new i;i<MAX_PLAYERS;i++){
		CS_pInfo[i][Vec_Owned] = Invalid_Vec;
		CS_pInfo[i][Vec_Locked] = false;
		CS_pInfo[i][pvid] = Invalid_Vec;
		CS_pInfo[i][Vec_Death] = false;
	}
	return true;
}

public OnFilterScriptExit(){
	DestroyObject(0);
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	CS_pInfo[playerid][Vec_Owned] = Invalid_Vec;
	CS_pInfo[playerid][Vec_Locked] = false;
	CS_pInfo[playerid][pvid] = Invalid_Vec;
	CS_pInfo[playerid][Vec_Death] = false;
	return true;
}
public OnVehicleSpawn(vehicleid){
//---------------------------叫---------------------------------//
	for(new owner;owner < MAX_PLAYERS;owner++){
		if(CS_pInfo[owner][Vec_Owned] == vehicleid){
			CS_pInfo[owner-1][Vec_Death]=false;
		}
	}
	return true;
}
public OnPlayerUpdate(playerid){
	return true;
}
//--------------------------------------------------------------//
public OnVehicleDeath(vehicleid,killerid){
	for(new i;i<MAX_PLAYERS;i++){
		if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleid){
			new
				Float:ftmp[3];
			GetPlayerPos(i,ftmp[0],ftmp[1],ftmp[2]);
			SetPlayerPos(i,ftmp[0],ftmp[1],ftmp[2]+5);
		}
	}
//---------------------------叫---------------------------------//
	for(new owner;owner < MAX_PLAYERS;owner++){
		if(CS_pInfo[owner][Vec_Owned] == vehicleid){
			CS_pInfo[owner-1][Vec_Death]=true;
		}
	}
	return true;
//--------------------------------------------------------------//
}

public OnPlayerDeath(playerid,killerid,reason){
	if(GetPlayerVehicleID(playerid)){
		new
			Float:ftmp[3];
		GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
		SetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]+5);
	}
	return true;
}
public OnPlayerSpawn(playerid){
	return true;
}
public OnPlayerStateChange(playerid,newstate,oldstate){
	if(newstate == PLAYER_STATE_NONE || 
	newstate == PLAYER_STATE_WASTED || 
	newstate == PLAYER_STATE_SPECTATING || 
	newstate == PLAYER_STATE_SPAWNED)
	return true;
	CS_pInfo[playerid][pvid] = GetPlayerVehicleID(playerid);
//---------------------------锁---------------------------------//
	if(
	(newstate == PLAYER_STATE_DRIVER) ||
	(newstate == PLAYER_STATE_PASSENGER)
	){
		if(CS_pInfo[playerid][pvid] == CS_pInfo[playerid][Vec_Owned]){//playerid's vec or not
			if(CS_pInfo[playerid][Vec_Locked]){
				CS_MsgSend(playerid,"[车管]老板欢迎!你的车已上锁");
			}else{
				CS_MsgSend(playerid,"[车管]老板欢迎!你的车没上锁");
			}
			return true;
		}else if(CS_VecOwned(CS_pInfo[playerid][pvid]) != INVALID_PLAYER_ID){
			if(CS_pInfo[CS_VecOwned(CS_pInfo[playerid][pvid])][Vec_Locked]){
				CS_ThrowPlayer(playerid);
			}else{
				CS_UnThrowPlayer(playerid);
			}
		}else{
			CS_MsgSend(playerid,"[车管]你可以拥有这辆车(输入/car woyao即可)");
		}
		return true;
	}
//-------------------------------------------------------------//	
	return true;
}




public OnPlayerCommandText(playerid,cmdtext[]){
	new
		main_cmd[MAX_STRING],
		cmd[MAX_STRING];
	sscanf(cmdtext,"ss",main_cmd,cmd);
	if(!strcmp(main_cmd,"/c",false,3) || !strcmp(main_cmd,"/che",false,5) || !strcmp(main_cmd,"/车",false,4) ||
	!strcmp(main_cmd,"/v",false,3) || !strcmp(main_cmd,"/vv",false,4)){
		new
			tmpstr[MAX_STRING];
		format(tmpstr,sizeof(tmpstr),"/car %s",cmd);
		OnPlayerCommandText(playerid,tmpstr);
		return true;
	}
	dcmd(car, 3, cmdtext);
	return false;
}
/*
*\/car wode
*\/car woyao
*\/car rengdiao
*\/car suo
*/
dcmd_car(playerid, params[]){
	new
		tmpstr[MAX_STRING];
	if(!sscanf(params,"s",tmpstr)){
		if(!strlen(tmpstr)){
			CS_MsgSend(playerid,"[车管]你输入的命令无效");
			return true;
		}else if(!strcmp(tmpstr,"wode",false,4)){
			CS_Vec_Call_Start(playerid);
		}else if(!strcmp(tmpstr,"woyao",false,5)){
			CS_Vec_Owned_Start(playerid);
		}else if(!strcmp(tmpstr,"rengdiao",false,8)){
			CS_Vec_UnOwned_Start(playerid);
		}else if(!strcmp(tmpstr,"suo",false,3)){
			CS_Vec_Lock_Start(playerid);
		}else if(!strcmp(tmpstr,"sos",false,3)){
			CS_HelpPlayer(playerid);
		}else if(!strcmp(tmpstr,"ti",false,3)){
			CS_Vec_Kick_Start(playerid);
		}else{
			CS_MsgSend(playerid,"[车管]你输入的命令 %s 无效",params);
			return true;
		}
	}else{
		CS_HelpPlayer(playerid);
		return true;
	}
	return true;
}















