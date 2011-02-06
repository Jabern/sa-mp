/*
								The MIT License  
								
	Copyright (c) <2010> <yezizhu>  
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:  

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.  
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.  
	==================================
	��Ȩ(c) <2010> <yezizhu>  

	ʹ�ø�����֤����������������Ȩ�ޣ���ѣ��κ��˿��Եõ����������������ĵ���һ��������
	���Ҿ�Ӫ�����������κ����ƣ����������Ƶ�ʹ�á����ơ��޸ġ��ϲ������桢���С����Ŵ���֤�顢���߳��۸������Ŀ�����Ȩ����
	ͬʱ���������Щ�������û�������ЩȨ����ʹ����������������  
	
	���ϵİ�Ȩ֪ͨ��Ȩ��֪ͨӦ�ð��������и������Ŀ����л�������������������ʵ�����С�
	
	�������������������ṩ��û���κ���ʽ�ĵ�������������ȷ�ػ��߰����ģ�������Щ���ǲ�����ҵ���ʵĵ��������ơ�
	�ʺ�һ���ض�����;���Ҳ����ַ������ߺͰ�Ȩ���������κγ��϶�ʹ�ø������漰���κ�Ҫ���𺦻����������ζ���Ӧ����
	�����������������û���ֻ�Ǻ�ͬ��ʽ��������Ȩ����������ʽ�������������������÷�Χ�ڡ������������ϵ����������ʹ�û�����������������������Ϊ��  
	=====================================   
*/	


//================================================================


dmw:autoOpen_struct(){
	gini_open("wl/GlobalSet.ini");
	SetGVarInt("dmw_auto_openTime",gini_readi("dmw_auto_openTime"));
	SetGVarInt("dmw_auto_closeTime",gini_readi("dmw_auto_closeTime"));
	//printf "cache:%d %d file:%d %d",GetGVarInt("dmw_auto_openTime"),GetGVarInt("dmw_auto_closeTime"),gini_readi("dmw_auto_openTime"),gini_readi("dmw_auto_closeTime")
	gini_close();
}

dmw:activeAutoOpen(){
	new
		h,m,s;
	gettime(h,m,s);
	if(h >= GetGVarInt("dmw_auto_openTime") && h < GetGVarInt("dmw_auto_closeTime")){
		if(!GetGVarInt("wl_dmw_admission")){
			SetTimer("dmw_closeDMW",1000 * 60 * 60 * (GetGVarInt("dmw_auto_closeTime") - GetGVarInt("dmw_auto_openTime")),false);
		}
		SetGVarInt("wl_dmw_admission",true); 
	}
}
forward dmw_closeDMW();
public dmw_closeDMW(){
	loopPlayer(playerid){
		if(dmw:getPlayer(playerid)){
			dmw:setPlayerOut(playerid);
		}
	}
	SetGVarInt("wl_dmw_admission",false);
}
//================================================================