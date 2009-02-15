////////////////////////////////////////////////////////////////////////////////
// ReX's chat features                                                        //
//                                                                            //
// Version: 1.0b                                                              //
//                                                                      	  //
// Coders: ReX ( ICQ 305-299-320)                                             //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// SORRY FOR MY BAD ENGLISH :)

// OTHER CREDITS :
//Anti Swear based on Boylett's Anti Swear

#include <a_samp>


// defines
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIGHTRED 0xFF6A6AFF
#define COLOR_WHITE 0xFFFFFFAA

// anti-spam
new msgsent[MAX_PLAYERS];
forward spam(playerid); // forward :D
//-----------|
// anti-swear
#define MAX_SWEARS 100
#define STR 100
new Swears[MAX_SWEARS][STR];
new num_words = 0;
//-----------|

#define FILTERSCRIPT

#if defined FILTERSCRIPT


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("   ReX's chat features   VERSION 1.0b   ");
	print("--------------------------------------\n");

//-----------| Anti Swear
   	new	string[STR], File:file;
	if((file = fopen("antichat.cfg",io_read)))
	{
		while(fread(file,string))
		{
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            Swears[num_words] = string;
            num_words++;
		}
		fclose(file);
	}
//-----------|

	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n--------------------------------------");
	print("   ReX's chat features   VERSION 1.0b   ");
	print("--------------------------------------\n");
}

#endif

public OnPlayerText(playerid, text[])
{
//-----------| ANTI SPAM
   	if(msgsent[playerid] == 1) {	// if he already sent message in 5 secs
      SendClientMessage(playerid,COLOR_RED,"[注意] “刷卡”太快，请重“发”。");	// alert
      return 0;	// message wont't be sent (return false)
   	} else {	// if message didn't send message
      msgsent[playerid] = 1;	// set "he sent message"
      SetTimerEx("spam",3000,0,"i",playerid);	//timer
   	}
//-----------|

//-----------| Anti SWEAR
	for(new s = 0; s < num_words; s++)
    {
   	  new pos;
	  while((pos = strfind(text,Swears[s],true)) != -1) for(new i = pos, j = pos + strlen(Swears[s]); i < j; i++) text[i] = ' ';//*
	}
//-----------|
	return 1;
}



public spam(playerid)
{
   msgsent[playerid] = 0;//reset msgsent
}
