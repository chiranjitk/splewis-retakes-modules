#include <sourcemod>
#include <sdkhooks>

public OnClientPutInServer(client)
{
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
    // let damage done by world, map entities, self damage, enemy damage
    if (attacker < 1 || attacker > MaxClients || attacker == victim || GetClientTeam(attacker) != GetClientTeam(victim))
    {
        return Plugin_Continue;
    }
    
    if (inflictor != -1) // there's an inflictor (weapon is -1 for this case)
    {
        // let damage done by c4 and molotovs
        char inflictorClass[64];
        if (GetEdictClassname(inflictor, inflictorClass, sizeof(inflictorClass)))
        {
            if (StrEqual(inflictorClass, "planted_c4"))
            {
                return Plugin_Continue;
            }
            
            if (StrEqual(inflictorClass, "inferno"))
            {
                return Plugin_Continue;
            }
        }
    }
    
    // block everything else
    return Plugin_Handled;
} 