#include <a_samp>

#define GREEN 0x21DD00FF
#define RED 0xE60000FF
#define YELLOW 0xFFFF00FF

#define MAX_FLARES 30   //  Max flares for single player

new Float:flare_pos[MAX_PLAYERS][3];
new flare_id[MAX_PLAYERS][MAX_FLARES];
new timer_id[MAX_PLAYERS][MAX_FLARES];
forward StartFireworks(playerid);
forward Destroy(obj);

public OnFilterScriptInit()
{
    print("\n|=================================================|");
    print("|========== FireWorks Effect By PhyroIS ==========|");
    print("|==================== MottiOK ====================|\n");
    return 1;
}

public OnFilterScriptExit()
{
    for (new i=0;i<MAX_PLAYERS;i++)
    {
        if (IsPlayerConnected(i))
        {
            for(new j=1; j<timer_id[i][0]; j++)
            {
                KillTimer(timer_id[i][j]);
                DestroyObject(flare_id[i][j]);
            }
              flare_id[i][0] = 0;
              timer_id[i][0] = 0;
        }
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    flare_id[playerid][0] = 0;
    timer_id[playerid][0] = 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (!strcmp("/start_flare", cmdtext, true))
    {
        if (flare_id[playerid][0] >= (MAX_FLARES-1))
        {
            SendClientMessage(playerid,YELLOW,"You got to max flares allowed !!");
            return 1;
        }
        new Float:X,Float:Y,Float:Z;
        GetPlayerPos(playerid,X,Y,Z);
        flare_pos[playerid][0] = X;
        flare_pos[playerid][1] = Y;
        flare_pos[playerid][2] = Z;
        flare_id[playerid][0]++;
        timer_id[playerid][0]++;
        timer_id[playerid][timer_id[playerid][0]] = SetTimerEx("StartFireworks",2000,true,"i",playerid);
        return 1;
    }

    if (!strcmp("/move_flares", cmdtext, true))
    {
        new Float:X,Float:Y,Float:Z;
        GetPlayerPos(playerid,X,Y,Z);
        flare_pos[playerid][0] = X;
        flare_pos[playerid][1] = Y;
        flare_pos[playerid][2] = Z;
        return 1;
    }

    if (!strcmp("/stop_flares", cmdtext, true))
    {
        for(new i=1;i<=timer_id[playerid][0];i++)
        {
            KillTimer(timer_id[playerid][i]);
            DestroyObject(flare_id[playerid][i]);
         }
        flare_id[playerid][0] = 0;
        timer_id[playerid][0] = 0;
        SendClientMessage(playerid,YELLOW,"You successfully stop all your flares");
        return 1;
    }

    if (!strcmp("/help_flares", cmdtext))
    {
        SendClientMessage(playerid,GREEN,"/start_flare - Create single flare");
        SendClientMessage(playerid,GREEN,"/stop_flares - Stop all your flares");
        SendClientMessage(playerid,GREEN,"/move_flares - move your flares to current position");
        SendClientMessage(playerid,GREEN," ");
        if (IsPlayerAdmin(playerid))
        {
            SendClientMessage(playerid,YELLOW,"/night - Change server clock to 00:00");
            SendClientMessage(playerid,YELLOW,"/morning - Change server clock to 12:00");
        }
        SendClientMessage(playerid,GREEN," ");
        SendClientMessage(playerid,RED,"All rights reserved to PhyroIS - Israel");
        return 1;
    }

    if (!IsPlayerAdmin(playerid)) return 0;

    if (!strcmp("/night", cmdtext, true))
    {
        for (new i=0;i<MAX_PLAYERS;i++)
            if (IsPlayerConnected(i))
                SetPlayerTime(i,00,00);
        return 1;
    }

    if (!strcmp("/morning", cmdtext, true))
    {
        for (new i=0;i<MAX_PLAYERS;i++)
            if (IsPlayerConnected(i))
                SetPlayerTime(i,12,00);
        return 1;
    }

    return 0;
}

public StartFireworks(playerid)
{
    flare_id[playerid][flare_id[playerid][0]] = CreateObject(354,flare_pos[playerid][0],flare_pos[playerid][1],flare_pos[playerid][2],0,0,0);
    new Float:tX,Float:tY,Float:tZ;
    {
        if (!random(2))
        {
            tX = flare_pos[playerid][0]+random(30);
            tY = flare_pos[playerid][1]+random(30);
        }
        else
        {
            tX = flare_pos[playerid][0]+random(30)*(-1);
            tY = flare_pos[playerid][1]+random(30)*(-1);
        }
        tZ = flare_pos[playerid][2]+random(100) + 20;
    }
    MoveObject(flare_id[playerid][flare_id[playerid][0]], tX, tY, tZ, random(50) + 30);
    SetTimerEx("Destroy",1000,false,"i",flare_id[playerid][flare_id[playerid][0]]);
}

public Destroy(obj)
{
    DestroyObject(obj);
}
