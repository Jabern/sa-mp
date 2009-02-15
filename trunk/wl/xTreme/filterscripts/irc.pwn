
#define ServerText "7F"


#include <a_samp>

forward MK_IRC();
new ircTimer;

public OnFilterScriptInit()
{
	if(fexist("MK_IRC_IN.txt"))
		fremove("MK_IRC_IN.txt");
	if(fexist("MK_IRC_OUT.txt"))
		fremove("MK_IRC_OUT.txt");

 	ircTimer = SetTimer("MK_IRC", 500, 1);
 	
	print("\n------------------------------------------");
	print(" ^^ MK's Simplified IRC System Loaded. ^^");
	print("------------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(ircTimer);
	return 1;
}

public OnGameModeInit()
{
 	new writedate[256];
	format(writedate,sizeof(writedate),"[新闻] 未来世界 %s (203.92.160.10:7777) 服务器开启了.\n", ServerText);
	new File:fp = fopen("MK_IRC_OUT.txt",io_append);
	fwrite(fp,writedate);
	fclose(fp);
 	
	return 1;
}

public OnGameModeExit()
{
	new writedate[256];
	format(writedate,sizeof(writedate),"[新闻] 未来世界 %s (203.92.160.10:7777) 服务器关闭了.\n", ServerText);
	new File:fp = fopen("MK_IRC_OUT.txt",io_append);
	fwrite(fp,writedate);
	fclose(fp);

	KillTimer(ircTimer);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new writedate[256];
	format(writedate,sizeof(writedate),"[新闻] %s 进入了未来世界 %s (203.92.160.10:7777) 服务器.\n",ReturnPlayerName(playerid), ServerText);
	new File:fp = fopen("MK_IRC_OUT.txt",io_append);
	fwrite(fp,writedate);
	fclose(fp);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new writedate[256];
	format(writedate,sizeof(writedate),"[新闻] %s 离开了未来世界 %s (203.92.160.10:7777) 服务器.\n",ReturnPlayerName(playerid), ServerText);
	new File:fp = fopen("MK_IRC_OUT.txt",io_append);
	fwrite(fp,writedate);
	fclose(fp);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new writedate[256];
	format(writedate,sizeof(writedate),"        [%s] %s:%s\n",ServerText,ReturnPlayerName(playerid), text);
	new File:fp = fopen("MK_IRC_OUT.txt",io_append);
	fwrite(fp,writedate);
	fclose(fp);
	return 1;
}


public MK_IRC()
{
	new text[256];
	new File:rf;
	
	if(fexist("MK_IRC_IN.txt"))
	{
		rf = fopen("MK_IRC_IN.txt",io_read);
		if(!rf) return;

		while(fread(rf,text,sizeof(text),false))
		{
			SendClientMessageToAll(0xFF9900AA, text);
		}
		fclose(rf);
		
		fremove("MK_IRC_IN.txt");
 	}
}



ReturnPlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof (pname));
	return pname;
}
