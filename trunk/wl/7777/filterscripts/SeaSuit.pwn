#include <a_samp>
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
// Don't delete the line above, it allows use of DCMD

#define FILTERSCRIPT

#if defined FILTERSCRIPT

	new SeaSuit[MAX_PLAYERS], SuitStatus[MAX_PLAYERS]; //SeaSuit stores object ID, SharkStatus stores the type of suit
	new Float:sharkx, Float:sharky, Float:sharkz, Float:sharka; //Used in /lsuit to take player position
/*	new Float:sxoffset, Float:syoffset, Float:szoffset; //Shark offsets
	new Float:dxoffset, Float:dyoffset, Float:dzoffset; // Dolphin Offsets
	new Float:txoffset, Float:tyoffset, Float:tzoffset; //Turtle offsets
*/
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Sea Suits by Thomas_Conroy");
	print("--------------------------------------\n");
	
	//SendClientMessageToAll(0xFF00FFAA, "SeaSuits Activated! Type /suithelp for commands! (by: Thomas_Conroy)");
 	return 1;
}

public OnFilterScriptExit()
{
    SendClientMessageToAll(0xFF00FFAA, "SeaSuits Deactivated! (by: Thomas_Conroy)"); //Farewell message
    for(new i=0; i<=MAX_PLAYERS; i++) //Loops Playerid's
    	{
    	if(IsValidObject(SeaSuit[i])==1) GameTextForAll("Yoink!", 5000, 3), DestroyObject(SeaSuit[i]); //If player is wearing suit, delete it!
    	SeaSuit[i] = 0; //Reset all values to 0
		SuitStatus[i] = 0;
    	}
	return 1;
}

#else

#endif


public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	SuitStatus[playerid] = 0; //Ensures the player does not have an erroneous SharkStatus setting
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DestroyObject(SeaSuit[playerid]); //Despawns and resets the players sharkstatus upon disconnection
    SuitStatus[playerid] = 0;
	return 1;
}



public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/dsuit", cmdtext, true, 6) == 0) // This command deletes the currently spawned suit
	{
		if (SuitStatus[playerid] == 0) // Checks to see if the player has a suit
			{ GameTextForPlayer(playerid, "~p~You need to be wearing a suit to delete it!",3000,3); }
		else // if the player DOES have a suit it is deleted and its status reset.
			{
			DestroyObject(SeaSuit[playerid]);
			GameTextForPlayer(playerid, "~r~All Gone!",3000,3);
   			SuitStatus[playerid] = 0;
			}
		return 1;
	}
	
	
	if (strcmp("/lsuit", cmdtext, true, 6) == 0) //This command drops the suit (roughly) where the player is standing
	{
		if (SuitStatus[playerid] == 0) // Checks to see if the player has a suit
			{ GameTextForPlayer(playerid, "~p~You need to be wearing a suit to take it off!",3000,3); }
		else //if the player DOES have a suit the players position is taken and the suit placed in relation to it.
			{
			GetPlayerPos(playerid, sharkx, sharky, sharkz); //Player pos and facing angle saved
			GetPlayerFacingAngle(playerid, sharka);
			DestroyObject(SeaSuit[playerid]); //I found it easier to delete and respawn the object as there is no DetachObjectFromPlayer command.
			switch(SuitStatus[playerid]) {
			case 1608: // Acts as if suitnumber = 1608 (Shark)
				{ SeaSuit[playerid] = CreateObject(SuitStatus[playerid], sharkx, sharky - 2, sharkz, 0.0, 0.0, sharka); }
			case 1607: // Acts as if suitnumber = 1607 (Dolphin)
				{ SeaSuit[playerid] = CreateObject(SuitStatus[playerid], sharkx, sharky - 0.2, sharkz + 0.2, 0.0, 0.0, sharka); }
            case 1609: // Acts as if suitnumber = 1609 (Turtle)
				{ SeaSuit[playerid] = CreateObject(SuitStatus[playerid], sharkx - 0.1, sharky, sharkz + 0.27, 0.0, 0.0, sharka); }
			}
			GameTextForPlayer(playerid, "~r~Dumped!",3000,3);
			SuitStatus[playerid] = 2; //Status set to 2 announces the fact the suit is "loose", however this is not currently needed
			}
		return 1;
	}

	if (strcmp("/suits", cmdtext, true, 6) == 0) //This command lists the available suits (obvious)
	{
		GameTextForPlayer(playerid, "~r~1 - Shark~n~~p~2 - Dolphin~n~~r~3 - Turtle", 5000, 3);
		return 1;
	}
	
	
	if (strcmp("/suithelp", cmdtext, true, 9) == 0)
	{
		SendClientMessage(playerid,0xFF0000AA,"SeaSuit Commands:");
	    SendClientMessage(playerid,0xFF6600AA,"/ssuit <1-3> - Gives you a suit");
        SendClientMessage(playerid,0xFFFF00AA,"/lsuit - Drops the suit at your current position");
        SendClientMessage(playerid,0x00FF00AA,"/dsuit - Despawns the suit (deletes)");
        SendClientMessage(playerid,0x00FFFFAA,"/suits - Lists available suits");
		return 1;
	}

	dcmd(ssuit, 5, cmdtext); // "Activates" /ssuit  !!Do Not Delete!!
	return 0;
}


dcmd_ssuit(playerid, params[])
	{
		new
			suitnumber;
		if (sscanf(params, "i", suitnumber)) SendClientMessage(playerid, 0xFF00FFAA, "Usage: /ssuit [Suit Number]"); //Ensures command is properly typed and saves the suit integer to correct variable
		else if (suitnumber > 3 || suitnumber < 1 || suitnumber == 0) SendClientMessage(playerid, 0xFF00FFAA, "Suit Number must be 1,2 or 3. Consult /suits"); // Ensures no suits out of the 1-3 range are requested
		else
		{
        if(SuitStatus[playerid] != 0) DestroyObject(SeaSuit[playerid]); // Deletes any old suits
		GameTextForPlayer(playerid, "~b~Enjoy your ~r~SeaSuit!",3000,3);
		switch(suitnumber){
  		case 1: // Shark
  			{
			SeaSuit[playerid] = CreateObject(1608, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachObjectToPlayer(SeaSuit[playerid], playerid, 0.0, -2.0, 0.0, 0.0, 0.0, 0.0);
			SuitStatus[playerid] = 1608;
			}
		case 2: // Dolphin
			{
			SeaSuit[playerid] = CreateObject(1607, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachObjectToPlayer(SeaSuit[playerid], playerid, 0.0, -0.2, 0.2, 0.0, 0.0, 0.0);
			SuitStatus[playerid] = 1607;
			}
		case 3: // Turtle
			{
			SeaSuit[playerid] = CreateObject(1609, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachObjectToPlayer(SeaSuit[playerid], playerid, -0.10, 0.0, 0.27, 0.0, 0.0, 0.0);
			SuitStatus[playerid] = 1609;
			}
		}
		}
		return 1;
	}

stock sscanf(string[], format[], {Float,_}:...) //This allows use of Sscanf, !!DO Not Delete!!
{
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
