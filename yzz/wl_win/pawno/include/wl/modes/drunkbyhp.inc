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






















































forward mode_drunkbyhp();
public mode_drunkbyhp(){
	for(new i;i < MAX_PLAYERS;i++){
		if(IsPlayerConnected(i)){
			new
				Float:ph;
			GetPlayerHealth(i,ph);
			if(ph > 15){ //30
				SetPlayerDrunkLevel(i,0);
			}else if(PDM_getPlayerDM(i) == INVALID_PDM_ID){
				/*
				if(ph > 25 && ph <= 30){
					SetPlayerDrunkLevel(i,10000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}else if(ph > 20 && ph <= 25){
					SetPlayerDrunkLevel(i,20000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}else if(ph > 15 && ph <= 20){
					SetPlayerDrunkLevel(i,30000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}else 
				*/if(ph > 10 && ph <= 15){
					SetPlayerDrunkLevel(i,40000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}else if(ph > 5 && ph <= 10){
					SetPlayerDrunkLevel(i,45000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}else if(ph > 0 && ph <= 5){
					SetPlayerDrunkLevel(i,50000);
					System_send(i,"[ϵͳ]��Ѫ̫����,�Ͽ�ȥ��Ѫ~");
				}
			}
		}
	}
}

mode_drunkbyhp_struction(){
	//SetTimer("mode_drunkbyhp",1011*10,true);
}




















