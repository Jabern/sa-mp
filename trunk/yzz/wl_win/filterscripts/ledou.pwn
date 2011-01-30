#include <a_samp>
#include <a_http>
main(){}

new
	ledouaccount[][] = 
		{
			"1824944908",
			"1826486432",
			"1781576837",
			"1781951982",
			"1779163596",
			"528999491",
			"1826893431",
			"1737756572",
			"1776601913",
			"1586245288",
			"1820559359",
			"809438274",
			"1755012868",
			"1759006425",
			"1779465943",
			"1820200992",
			"1825519492",
			"1760284314",
			"1824627255",
			"1433865165",
			"1779039129",
			"1825227296",
			"1601877497",
			"1805115052",
			"1764694172",
			"1825549487",
			"1779443060", 
			"1737815078",
			"1779513963",
			"1780382026",
			"1529713462",
			"1748063297",
			"1781671412",
			"1820109950",
			"1825121804",
			"1171238295",
			"1714047771",
			"1749613480",
			"1781098746",
			"1826617968"
		};
		
new ledoupassword[][] =
	{
		"ewSetAf/gn8j3tHCfGnPzg",
		"dIx/ePhDEzg1X0WNgCpsIA",
		"vx9Dsm97ATyPT2%20lx%20roeA",
		"AGUAsqyMNA%207fa8ZQLI8Cw",
		"9fsaBidpl3DgmP1CC43uZQ",
		"Xp8UsPt0tnEZQY5maj2KAA",
		"6VWJUhvKdMqUJdfzTtiaxw",
		"zfTEsHfk2x3NhMvttLorBw",
		"S0z+CWljQqAZKIPX8s9HCw",
		"5lfp2HosvxtV22ZjW2GCdQ",
		"GX844jkhSyxBcUEOOWsR9Q",
		"ZrUfvRGAMU2My9Is7g0bOQ",
		"2sWoWq8B2OZaKFBM09YuaA",
		"mUbKTF5S4cpgMoWdKeDBZA",
		"jPoUK13gEOOQsrq2jFx9nw",
		"P/OOnyGmribBRFrLqSH0bw",
		"rk103UpJEge/QbnvDkmhWw",
		"jHeY1b6eA/YJIGlTm5rWyQ",
		"W6fbxOK91Svl2%205AAsayug",
		"Vv4nDZ7ZATlYknmfWOH10A",
		"oaoRIAo8LyAh3hFMyOPwtw",
		"YRH5RurWMTMlfq%20N99uz1Q",
		"IEORooUhicBCv0F93mDsMg",
		"7pIwh8mPA0oRYELuDe2PZw",
		"KaPQG8anMJ4bRkJG9/ZnPA",
		"fcdpruvjTbBI5t8jpF0Ig",
		"Gm7TYXpD9O8VQmiX%20eyEAA",
		"IfEhNjNhfYzOJXfSC9tuOA",
		"HbSDFImMZZwO4W4yaDhzMQ",
		"xPHg3uGxGfOyqLajQBJ2lw",
		"3Vmvo3F6TWCraNCU61RdIQ",
		"CqOvyLSQrvbMN/MGW5aHqw",
		"ygfY65RhcIcpaX7BSjqMYg",
		"lgDvKjPjk9QtlFr/elcrVg",
		"gOmKOYaWHSZIp/9AwIbmSg",	
		"hmRqa7yFsqLkr/WMWqekvw",
		"It7X8oMcSs/HMkUMge/P2w",
		"s8HOKV0kYTLDMKxJMsc2YA",
		"WS5WoDFLlXwFRb5GM/Nhvw",
		"Q3amGLs685wAl0fYE3xuuA"
	};

new ledouhttpqueryclient[][] = 
	{
		"-1", //selfclient
		"-1", 
		"7", //caicai
		"917736653",
		"346265676",
		"445605449",
		"121547921"
	};



forward ledou_fight_query(type,accountindex,clientindex);
forward ledou_query_result(index, response_code, data[]);


public ledou_fight_query(type,accountindex,clientindex){
	new
		httpquery[512];
	printf("type:%d accountindex:%d clientindex:%d",type,accountindex,clientindex);
	if(type == 1){ //login query
		format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?cmd=index&zapp_sid=%s==&zapp_uin=%s",ledoupassword[accountindex],ledouaccount[accountindex]);
	}
	else if(type == 2){ //fight query
		if(!strcmp(ledouhttpqueryclient[clientindex],"-1")){ //selfclient
			format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[accountindex],ledoupassword[accountindex],ledouaccount[accountindex]);
		}
		else { //custom client
			format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[accountindex],ledoupassword[accountindex],ledouhttpqueryclient[clientindex]);
		}
	}
	else if(type == 3){ //unloadfs singal
		SendRconCommand("unloadfs ledou");
	}
	HTTP(0, HTTP_GET, httpquery,"", "ledou_query_result");
	printf("%s",httpquery);
	clientindex++;
	if(clientindex == sizeof(ledouhttpqueryclient)){ //a client unit finished
		accountindex++;
		clientindex = 0;
		if(accountindex == 3/*sizeof(ledouaccount)*/){ //all account units finished
			SetTimerEx("ledou_fight_query",1000 * 180,false,"iii",3,accountindex,clientindex);
			printf("ledou process has finished, unload ledou.amx within 60seconds");
			return false;
		}
		SetTimerEx("ledou_fight_query",600,false,"iii",1,accountindex,clientindex);
	}
	else { //continue a client unit
		SetTimerEx("ledou_fight_query",600,false,"iii",2,accountindex,clientindex);
	}
	return true;
}


public ledou_query_result(index, response_code, data[]){
}

public OnFilterScriptInit(){
	printf("ledou process has started.");
	SetTimerEx("ledou_fight_query",1985,false,"iii",1,0,0);
	return true;
}

public OnFilterScriptExit(){
	printf("ledou process has ended.");
	return true;
}


//new ledouhttpqueryhead[] = 	"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=";
//new ledouhttpquerymid1[] = "&zapp_sid=";
//new ledouhttpquerymid2[] = "==&cmd=fight&B_UID=";
//new ledouhttpquerybottom[] = "&page=";
//new ledouhttpquery[1024];
/*
public ledoutest_timer(){
	new
		timeprefix,
		httpquery[512];
	for(new i;i < sizeof(ledouaccount);i++){
		format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?cmd=index&zapp_sid=%s==&zapp_uin=%s",ledoupassword[i],ledouaccount[i]);
		pause(400);timeprefix += 400;
		ledou_fight_httpquery(httpquery);
		
		format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[i],ledoupassword[i],"7");
		pause(400);timeprefix += 400;
		ledou_fight_httpquery(httpquery);
		
		format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[i],ledoupassword[i],ledouaccount[i]);
		pause(400);timeprefix += 400;
		ledou_fight_httpquery(httpquery);		

		format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[i],ledoupassword[i],ledouaccount[i]);
		pause(400);timeprefix += 400;
		ledou_fight_httpquery(httpquery);	
		
		//SetTimerEx("ledou_fight_httpquery",timeprefix,0,"s",httpquery);
		//http://qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=1826617968&zapp_sid=Q3amGLs685wAl0fYE3xuuA==&cmd=fight&B_UID=7&page=1
		//http://qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=1826617968&zapp_sid=Q3amGLs685wAl0fYE3xuuA==&cmd=fight&B_UID=1826617968&page=
		for(new j;j < sizeof(ledouhttpqueryclient);j++){
			format(httpquery,sizeof(httpquery),"qzapp.z.qq.com/qpet/cgi-bin/phonepk?zapp_uin=%s&zapp_sid=%s==&cmd=fight&B_UID=%s&page=",ledouaccount[i],ledoupassword[i],ledouhttpqueryclient[j]);
			pause(400);timeprefix += 400;
			ledou_fight_httpquery(httpquery);
			//timeprefix += 400;
			//SetTimerEx("ledou_fight_httpquery",timeprefix,0,"s",httpquery);
			//printf("set %s (%s) attack %s",ledouaccount[i],ledoupassword[i],ledouhttpqueryclient[j]);
		}
	}
	pause(5000);
	printf("Ledou ended, total used time :%d ms",timeprefix);
}
*/

/*
pause(ms){
	new
		tick = GetTickCount();
	while(GetTickCount() - tick < ms){}
}
*/

//forward ledoutest(index, response_code, data[]);
//forward ledoutest_timer();
//public ledoutest(index, response_code, data[]){
	/*
	new
		tmpstr[500];
	format(tmpstr,sizeof(tmpstr),data);
	print("=======");
	printf("index:%d response_code:%d data:%d",index,response_code,strlen(data));
	print(tmpstr);
	if(strfind(tmpstr,"落花",.ignorecase = true) != -1){
		printf("win");
	}
	else if(strfind(tmpstr,"寰堟姳姝夛",.ignorecase = true) != -1){
		printf("already");		
	}
	else if(strfind(tmpstr,"摆平",.ignorecase = true) != -1){
		printf("lose");	
	}
	else if(strfind(tmpstr,"不足",.ignorecase = true) != -1){
		printf("lack strenth");	
	}
	else {
		printf("unknown");
	}
	
	print("=======");
	*/
	/*
	落花 - 胜利
	换个好友 - 已挑
	摆平 - 失败
	*/
//}