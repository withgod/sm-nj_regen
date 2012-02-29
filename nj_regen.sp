/**
* vim: set ts=4 
* Author: withgod <noname@withgod.jp>
* GPL 2.0
* 
**/

#pragma semicolon 1

#include <sourcemod>
#include <tf2>

#define PLUGIN_VERSION "0.0.1"

#define MAX_PLAYERS 24

new Handle:RegenTimers[MAX_PLAYERS+1];
new Handle:cvar_RegenInterval;
new Float:RegenInterval;

public Plugin:myinfo = 
{
	name = "nj_Regen",
	author = "withgod",
	description = "regen command",
	version = PLUGIN_VERSION,
	url = "http://github.com/withgod/sm-nj_regen"
};

public OnPluginStart()
{
	PrintToServer("start my plugin");
	CreateConVar("nj_regen_version", PLUGIN_VERSION, "nj Regen Command Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	RegConsoleCmd("nj_regen_on", Command_RegenOn);
	RegConsoleCmd("nj_regen_off", Command_RegenOff);
	cvar_RegenInterval = CreateConVar("sm_regen_interval", "0.5", "regen interval", _, true, 1.0, true, 10.0);
}

// remove all timers
public OnMapEnd()
{
	new i = 1;
	for (i = 1; i < MAX_PLAYERS; i++)
	{
		if (RegenTimers[i] != INVALID_HANDLE)
		{
			KillTimer(RegenTimers[i]);
			RegenTimers[i] = INVALID_HANDLE;
		}
	}
}


public Action:Command_RegenOn(client, args)
{
	
	PrintToServer("regen on[%d]", client);
	if (GetClientTeam(client) != 1) //not spectator
	{
		RegenInterval = GetConVarFloat(cvar_RegenInterval);
		RegenTimers[client] = CreateTimer(RegenInterval, RegenPlayer, client, TIMER_REPEAT);
	}
}
public Action:Command_RegenOff(client, args)
{
	PrintToServer("regen off[%d]", client);
	if (RegenTimers[client] != INVALID_HANDLE)
	{
		KillTimer(RegenTimers[client]);
		RegenTimers[client] = INVALID_HANDLE;
	}
}

public Action:RegenPlayer(Handle:timer, any:client)
{
	
	if (GetClientTeam(client) != 1) 
	{
		TF2_RegeneratePlayer(client);
	} 
	else
	{
		KillTimer(RegenTimers[client]);
	}
	return Plugin_Continue;
}

