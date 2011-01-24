//----------------------------------------------------------
//
//   SA:MP Multiplayer Modification For GTA:SA
//   Copyright 2004-2007 SA:MP Team
//----------------------------------------------------------

/*
	Extended File Function Plugin
	Copyright (C) 2011 Shindo
	
	Version: 0.1
	This is a part of OpenGTA project, visit www.opengta.org
	Contact us: ssh@opengta.org

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// 不检测无效指针来让开发者注意

#include <stdio.h>
#include <string.h>

#ifdef LINUX
#include <sys/stat.h>
#include <unistd.h>
#else
#include <malloc.h>
#include <windows.h>
#include <io.h>
#endif

#include "SDK/amx/amx.h"
#include "SDK/plugincommon.h"

//----------------------------------------------------------
#define FILE_LIMIT 500

typedef struct
{
	FILE *fHandle;
	char fMode[2];
} fileStruct;
fileStruct fileArray[FILE_LIMIT];
//----------------------------------------------------------

typedef void (*logprintf_t)(char *format, ...);

logprintf_t logprintf;
void **ppPluginData;
extern void *pAMXFunctions;

PLUGIN_EXPORT unsigned int PLUGIN_CALL Supports() 
{
	return SUPPORTS_VERSION | SUPPORTS_AMX_NATIVES;
}

PLUGIN_EXPORT bool PLUGIN_CALL Load( void **ppData ) 
{
	pAMXFunctions = ppData[PLUGIN_DATA_AMX_EXPORTS];
	logprintf = (logprintf_t)ppData[PLUGIN_DATA_LOGPRINTF];

	logprintf( "\n * Shindo's extended file function plugin loaded.\n" );
	return true;
}

PLUGIN_EXPORT  void PLUGIN_CALL Unload( )
{
	logprintf( "\n * Shindo's extended file function plugin unloaded.\n" );
}

// native Ext_fopen(FileNum, FileName[], mode[]);
// return value:
// -1 - file has been opened.
// -2 - open mode error.
// -3 - fileNum is too big.
// 0 - opening file failed.
// 1 - opening file succeed.
static cell AMX_NATIVE_CALL n_Ext_fopen( AMX* amx, cell* params )
{
	int FileNum = params[1];

	if (FileNum > FILE_LIMIT - 1)
		return -3;

	if (fileArray[FileNum].fHandle != NULL)
		return -1;

	char *fName, *fMode;
	amx_StrParam(amx, params[2], fName);
	amx_StrParam(amx, params[3], fMode);

	if (!strcmp(fMode, "w") || !strcmp(fMode, "r") || !strcmp(fMode, "a") || !strcmp(fMode, "w+") || !strcmp(fMode, "r+") || !strcmp(fMode, "a+"))
	{
		if ((fileArray[FileNum].fHandle = fopen(fName, fMode)) == NULL)
			return 0;

		strcpy(fileArray[FileNum].fMode, fMode);
		return 1;
	}
	else
		return -2;
}

// native Ext_fread(FileNum, string[], size = sizeof string);
// return value:
// -1 - the stream is not opened.
// -2 - the stream can't be readed.
// -3 - has been eof
// 0 - reading file failed.
// 1 - reading file succeed.
static cell AMX_NATIVE_CALL n_Ext_fread( AMX* amx, cell* params )
{
	int FileNum = params[1];
	if (fileArray[FileNum].fHandle == NULL)
		return -1;

	if (!strcmp(fileArray[FileNum].fMode, "r") || !strcmp(fileArray[FileNum].fMode, "r+"))
	{
		if (!feof(fileArray[FileNum].fHandle))
		{
			char *string = (char *)malloc(params[3]);

			if (fgets(string, params[3], fileArray[FileNum].fHandle) == NULL)
				return 0;

			size_t len = strlen(string);
			while (len > 0  && (string[len-1] == '\r' || string[len-1] == '\n'))
			{
				len--;
				string[len] = 0;
			}

			cell *dest;
			amx_GetAddr(amx, params[2], &dest);
			amx_SetString(dest, string, 0, 0, params[3]);

			free(string);
			
			return 1;
		}
		else
			return -3;
	}
	else 
		return -2;
}

// native Ext_fwrite(FileNum, string[]);
// return value:
// -1 - the stream is not opened.
// -2 - the stream can't be writed.
// 0 - writing file failed.
// 1 - writing file succeed.
static cell AMX_NATIVE_CALL n_Ext_fwrite( AMX* amx, cell* params )
{
	int FileNum = params[1];
	if (fileArray[FileNum].fHandle == NULL)
		return -1;

	if (!strcmp(fileArray[FileNum].fMode, "w") || !strcmp(fileArray[FileNum].fMode, "w+") || !strcmp(fileArray[FileNum].fMode, "a") || !strcmp(fileArray[FileNum].fMode, "a+"))
	{
		char *string;
		amx_StrParam(amx, params[2], string);

		if (fputs(string, fileArray[FileNum].fHandle) == EOF)
			return 0;
		else	
			return 1;
	}
	else 
		return -2;
}

// native Ext_feof(FileNum);
// return value:
// -1 - the file is not opened.
// 0 - not eof.
// 1 - eof.
static cell AMX_NATIVE_CALL n_Ext_feof( AMX* amx, cell* params )
{
	int FileNum = params[1];
	if (fileArray[FileNum].fHandle == NULL)
		return -1;

	if (!feof(fileArray[FileNum].fHandle))
		return 0;
	else
		return 1;
}

// native Ext_fclose(FileNum);
// return value:
// -1 - the file is not opened.
// 0 - closing file failed.
// 1 - closing file succeed.
static cell AMX_NATIVE_CALL n_Ext_fclose( AMX* amx, cell* params )
{
	int FileNum = params[1];
	if (fileArray[FileNum].fHandle == NULL)
		return -1;

	if (fclose(fileArray[FileNum].fHandle) == 0)
	{
		fileArray[FileNum].fHandle = NULL;
		memset(fileArray[FileNum].fMode, 0, 2);
		return 1;
	}
	else
		return 0;
}

// bool Ext_dexist(char *dName)
// only private use for plugin.
// return value:
// 0 - the directory doesn't exist.
// 1 - the directory exists.
bool Ext_dexist(char *dName)
{
	if (access(dName, 0) != -1)
		return 1;
	else
		return 0;
}

// native Ext_dcreate(dName[]);
// return value:
// 0 - creating directory failed.
// 1 - creating directory succeed.
// 2 - the directory has existed.
static cell AMX_NATIVE_CALL n_Ext_dcreate( AMX* amx, cell* params )
{
	char *dName;
	amx_StrParam(amx, params[1], dName);

	if (Ext_dexist(dName))
		return 2;

	char *pch = strtok(dName, "/");

	if (pch == NULL)
	{
#ifdef LINUX
		mkdir(dName, S_IRWXG | S_IRWXU | S_IRWXO);
#else
		CreateDirectoryA(dName, NULL);
#endif
	}
	else
	{
		char pPath[1024];
		strcpy(pPath, pch);

		while (pch != NULL)
		{
#ifdef LINUX
			mkdir(pPath, S_IRWXG | S_IRWXU | S_IRWXO);
#else
			CreateDirectoryA(pPath, NULL);
#endif
			pch = strtok(NULL, "/");
			if (pch != NULL)
				sprintf(pPath, "%s/%s", pPath, pch);
		}
	}

	return Ext_dexist(dName);
}

// native Ext_dremove(dName[]);
// return value:
// 0 - removing directory failed.
// 1 - removing directory succeed.
// 2 - the directory doesn't exist.
static cell AMX_NATIVE_CALL n_Ext_dremove( AMX* amx, cell* params )
{
	char *dName;
	amx_StrParam(amx, params[1], dName);

	if (!Ext_dexist(dName))
		return 2;

#ifdef LINUX
	return (rmdir(dName) == 0);
#else
	return RemoveDirectoryA(dName);
#endif
}

// native Ext_drename(dSourceName[], dDestName[]);
// return value:
// 0 - renameing directory failed.
// 1 - renameing directory succeed.
// 2 - the directory doesn't exist.
static cell AMX_NATIVE_CALL n_Ext_drename( AMX* amx, cell* params )
{
	char *dSourceName, *dDestName;
	amx_StrParam(amx, params[1], dSourceName);
	amx_StrParam(amx, params[2], dDestName);

	if (!Ext_dexist(dSourceName))
		return 2;

	// 很欣慰的是这个函数linux/windows通用..
	return (rename(dSourceName, dDestName) == 0);
}

AMX_NATIVE_INFO ExtNatives[ ] =
{
	// File Functions
	{ "Ext_fopen",			n_Ext_fopen },
	{ "Ext_fread",			n_Ext_fread },
	{ "Ext_fwrite",			n_Ext_fwrite },
	{ "Ext_feof",			n_Ext_feof },
	{ "Ext_fclose",			n_Ext_fclose },
	// Directory Functions
	{ "Ext_dcreate",		n_Ext_dcreate },
	{ "Ext_dremove",		n_Ext_dremove },
	{ "Ext_drename",		n_Ext_drename },
	{ 0,					0 }
};

PLUGIN_EXPORT int PLUGIN_CALL AmxLoad( AMX *amx ) 
{
	return amx_Register( amx, ExtNatives, -1 );
}

PLUGIN_EXPORT int PLUGIN_CALL AmxUnload( AMX *amx ) 
{
	return AMX_ERR_NONE;
}
