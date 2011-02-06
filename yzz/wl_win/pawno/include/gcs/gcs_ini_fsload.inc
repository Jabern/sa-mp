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






stock gini_writei(const entry_name[],const value,const entry_section[] = "",const len = sizeof(entry_name)){
	return CallRemoteFunction("gini_writeiEx","sisi",entry_name[0]?entry_name:"\1",value,entry_section[0]?entry_section:"\1",len);
}


stock gini_writes(const entry_name[],const value[],const entry_section[] = "",const len = sizeof(entry_name)){
	return CallRemoteFunction("gini_writesEx","sssi",entry_name[0]?entry_name:"\1",value[0]?value:"\1",entry_section[0]?entry_section:"\1",len);
}

stock gini_writef(const entry_name[],const Float:value,const entry_section[] = "",const len = sizeof(entry_name)){
	return CallRemoteFunction("gini_writefEx","sfsi",entry_name[0]?entry_name:"\1",Float:value,entry_section[0]?entry_section:"\1",len);
}


stock gini_readi(const entry_name[],const entry_section[] = "",const len = sizeof(entry_section)){
	return CallRemoteFunction("gini_readiEx","ssi",entry_name[0]?entry_name:"\1",entry_section[0]?entry_section:"\1",len);
}

/*
stock Float:gini_readf(const entry_name[],const entry_section[] = "",const len = sizeof(entry_section)){
	new 
		Float:value = CallRemoteFunction("gini_readfEx","ssi",entry_name[0]?entry_name:"\1",entry_section[0]?entry_section:"\1",len);
	return value;
}
*/

static stock
	gini_value[MAX_FILE_STR],
	Float:gini_fvalue;
forward gini_passString(value[]);
public gini_passString(value[]){
	if(value[0] == '\1')value[0] = '\0';
	format(gini_value,sizeof(gini_value),"%s",value);
}

stock gini_reads(const entry_name[],const entry_section[] = "",const len = sizeof(entry_section)){
	CallRemoteFunction("gini_readsEx","ssi",entry_name[0]?entry_name:"\1",entry_section[0]?entry_section:"\1",len);
	return gini_value;
}


forward gini_passFloat(Float:value);
public gini_passFloat(Float:value){
	gini_fvalue = value;
}
stock Float:gini_readf(const entry_name[],const entry_section[] = "",const len = sizeof(entry_section)){
	CallRemoteFunction("gini_readfEx","ssi",entry_name[0]?entry_name:"\1",entry_section[0]?entry_section:"\1",len);
	return gini_fvalue;
}

stock gini_open(const filename[]){
	return CallRemoteFunction("gini_openEx","s",filename);
}

stock gini_close(){
	return CallRemoteFunction("gini_closeEx","");
}

stock gini_save(){
	return CallRemoteFunction("gini_saveEx","");
}


stock gini_getEntryNameFromID(const entryid){
	CallRemoteFunction("gini_getEntryNameFromIDEx","i",entryid);
	//printf("r%d:%s",entryid,gini_value);
	return gini_value;
}





