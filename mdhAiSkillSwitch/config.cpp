class CfgPatches 
{
	class mdhAiSkillSwitch
	{
		author = "Moerderhoschi";
		name = "MDH AI Skill Switch";
		url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3618182727";
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		version = "1.20160815";
		versionStr = "1.20160815";
		versionAr[] = {1,20160816};
		authors[] = {};
	};
};

class CfgFunctions
{
	class mdh
	{
		class mdhFunctions
		{
			class mdhAiSkillSwitch
			{
				file = "mdhAiSkillSwitch\mdhAiSkillSwitch.sqf";
				postInit = 1;
			};
		};
	};
};

class CfgMods
{
	class mdhAiSkillSwitch
	{
		dir = "@mdhAiSkillSwitch";
		name = "MDH AI Skill Switch";
		picture = "mdhAiSkillSwitch\mdhAiSkillSwitch.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "https://steamcommunity.com/sharedfiles/filedetails/?id=3618182727";
	};
};