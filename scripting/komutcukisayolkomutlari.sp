#include <sourcemod>
#include <warden>

public Plugin:myinfo ={
	name = "Komutçu Kisayol Komutlari",
	author = "Vortéx!",
	description	= "Kisayol komutlari kullanilmasina olanak saglar",
	version	= "1.0",
	url	= "https://turkmodders.com"
};

new Handle:g_PluginTagi = INVALID_HANDLE;
public OnPluginStart() {
	g_PluginTagi		=	CreateConVar("turkmodders_tag", "TurkModders.COM", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	AddCommandListener(HookPlayerChat,"say");
	AddCommandListener(HookPlayerChat,"say_team");
	AddCommandListener(HookPlayerChat,"say2");
}
new String:sPluginTagi[64];

public Action:HookPlayerChat(client,const String:command[],args){
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	decl String:strChat[255];
	decl String:strChat2[255];
	decl String:strCommand[255];
	decl String:player_text[300];
	decl String:finaltext[300];
	
	new Handle:kv = CreateKeyValues("KomutcuKisayolKomutlari");
	FileToKeyValues(kv,"addons/sourcemod/configs/KomutcuKisayolKomutlari.cfg");
	
	if(!KvGotoFirstSubKey(kv)){
		return;
	}
	do{
		KvGetString(kv,"kisayol",strChat,sizeof(strChat));
		KvGetString(kv,"komut",strCommand,sizeof(strCommand));
		
		GetCmdArgString(player_text,sizeof(player_text));
		StripQuotes(player_text);
		decl String:Partsx[10][64];
		new exploded = ExplodeString(player_text," ",Partsx,sizeof Partsx,sizeof Partsx[]);
		if(StrEqual(Partsx[0],strChat,true)){
			if(StrContains(strCommand,"[EK_PARAMETRE]",false) != -1){
				Format(finaltext,sizeof(finaltext),"%s",player_text);
				Format(strChat2,sizeof(strChat2),"%s ",strChat);
				ReplaceString(finaltext,sizeof(finaltext),strChat2,"");
				ReplaceString(finaltext,sizeof(finaltext),strChat,"");
				ReplaceString(strCommand,sizeof(strCommand),"[EK_PARAMETRE]",finaltext);
			}
			decl String:Parts[10][64];

			new Max = ExplodeString(strCommand,";",Parts,sizeof Parts,sizeof Parts[]);
			new i = 0;
			if(warden_iswarden(client))
			{
				PrintToChatAll(" \x02[%s] \x10%N \x04isimli komutçu \x0E%s \x06komutunu kullandi!", sPluginTagi, client, strChat);
				for(i = 0;i<Max;i++){
					ServerCommand(Parts[i]);
				}
			}
		}
		
	}while(KvGotoNextKey(kv));
	CloseHandle(kv);  
}