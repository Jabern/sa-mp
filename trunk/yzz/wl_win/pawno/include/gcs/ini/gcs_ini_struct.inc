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




static stock
	gini_pass_str[512],
	gini_pass_integer,
	Float:gini_pass_float;


//#pragma unused gini_pass_str,gini_pass_integer,gini_pass_float


forward gini_passs(const str[]);
forward gini_passi(const value);
forward gini_passf(const Float:value);

public gini_passs(const str[]){
	format(gini_pass_str,sizeof(gini_pass_str),"%s",str);
	return true;
}

public gini_passi(const value){
	gini_pass_integer = value;
	return true;
}

public gini_passf(const Float:value){
	gini_pass_float = value;
	return true;
}





stock gini_open(const file[]){
	return CallRemoteFunction("gini_open","s",file);
}
stock gini_save(){
	return CallRemoteFunction("gini_save","");
}
stock gini_close(){
	return CallRemoteFunction("gini_close","");
}

stock Float:gini_readf(const entry_name[],entry_section[] = "",const len = sizeof(entry_section)){
	if(!entry_section[0]) entry_section[0] = '\1';
	CallRemoteFunction("gini_readf","ssi",entry_name,entry_section,len);
	//printf("gini_pass_float_%f",gini_pass_float);
	return gini_pass_float;
}
stock gini_readi(const entry_name[],entry_section[] = "",const len = sizeof(entry_section)){
	if(!entry_section[0]) entry_section[0] = '\1';
	CallRemoteFunction("gini_readi","ssi",entry_name,entry_section,len);
	//printf("gini_pass_integer_%i",gini_pass_integer);
	return gini_pass_integer;
}
stock gini_reads(const entry_name[],entry_section[] = "",const len = sizeof(entry_section)){
	//printf("[debug_gini]gini_reads(%s,%s,%d)",entry_name,entry_section,len);
	if(!entry_section[0]) entry_section[0] = '\1';
	CallRemoteFunction("gini_reads","ssi",entry_name,entry_section,len);
	//printf("gini_pass_str_%s",gini_pass_str);
	return gini_pass_str;
}

stock gini_writei(const entry_name[],const value,entry_section[] = "",const len = sizeof(entry_name)){
	if(!entry_section[0]) entry_section[0] = '\1';
	return CallRemoteFunction("gini_writei","sisi",entry_name,value,entry_section,len);
}
stock gini_writef(const entry_name[],const Float:value,entry_section[] = "",const len = sizeof(entry_name)){
	if(!entry_section[0]) entry_section[0] = '\1';
	return CallRemoteFunction("gini_writef","sfsi",entry_name,value,entry_section,len);
}
stock gini_writes(const entry_name[],value[],entry_section[] = "",const len = sizeof(entry_name)){
	if(!value[0]) value[0] = '\1';
	if(!entry_section[0]) entry_section[0] = '\1';
	return CallRemoteFunction("gini_writes","sssi",entry_name,value,entry_section,len);
}




















