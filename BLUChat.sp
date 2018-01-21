#define PLUGIN_AUTHOR "x3Karma"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <tf2jail>
#include <morecolors>
#include <tf2_stocks>

public Plugin myinfo = 
{
	name = "BLUChat", 
	author = PLUGIN_AUTHOR, 
	description = "Grants donators the ability to type in chat as warden.", 
	version = PLUGIN_VERSION, 
	url = "https://titan.tf"
};

public void OnPluginStart()
{
	RegConsoleCmd("say", Command_Say);
	
	HookEvent("teamplay_round_start", Event_RoundStart);
}

public Action Event_RoundStart(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	int donators = 0;
	for (new client = 1; client <= MaxClients; client++)
	{
		if (GetEntityTeamNum(client) == 3)
		{
			if (CheckCommandAccess(client, "sm_pets", ADMFLAG_CUSTOM6))
			{
				donators++;
			}
		}
	}
	PrintToChatAll("[SM] %i donators found on BLU team.", donators);
}

public TF2Jail_OnWardenCreated(int client)
{
	if (CheckCommandAccess(client, "sm_pets", ADMFLAG_CUSTOM6))
	{
		PrintToChatAll("[SM] Donator detected. Warden's message will now appear on HUD.");
	}
}

public Action:Command_Say(client, args)
{
	new String:text[192];
	new String:name[192];
	GetClientName(client, name, sizeof(name));
	GetCmdArgString(text, sizeof(text));
	if (!text[0])
		return Plugin_Handled;
	if (TF2Jail_IsWarden(client)) {
		if (CheckCommandAccess(client, "sm_pets", ADMFLAG_CUSTOM6))
		{
			PrintCenterTextAll("%s: %s", name, text);
		}
	}
	return Plugin_Handled;
}

stock GetEntityTeamNum(iEnt)
{
    return GetEntProp(iEnt, Prop_Send, "m_iTeamNum");
}