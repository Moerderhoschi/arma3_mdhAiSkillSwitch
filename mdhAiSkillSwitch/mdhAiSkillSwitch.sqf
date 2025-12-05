///////////////////////////////////////////////////////////////////////////////////////////////////
// MDH AI SKILL SWITCH(by Moerderhoschi) - v2025-12-05
// github: https://github.com/Moerderhoschi/arma3_mdhAiSkillSwitch
// steam mod version: https://steamcommunity.com/sharedfiles/filedetails/?id=3618182727
///////////////////////////////////////////////////////////////////////////////////////////////////
if (hasInterface && {missionNameSpace getVariable ["pMdhAiSkillSwitch",99] == 99}) then
{
	0 spawn
	{
		scriptName "mdhAiSkillSwitch.sqf";
		_valueCheck = 99;
		_defaultValue = 99;
		_env  = hasInterface;

		_diary   = 0;
		_mdhFnc  = 0;

		if (hasInterface) then
		{
			_diary =
			{
				waitUntil {!(isNull player)};
				_c = true;
				_t = "MDH AI Skill Switch";
				if (player diarySubjectExists "MDH Mods") then
				{
					{
						if (_x#1 == _t) then {_c = false}
					} forEach (player allDiaryRecords "MDH Mods");
				}
				else
				{
					player createDiarySubject ["MDH Mods","MDH Mods"];
				};
		
				if(_c) then
				{
					mdhAiSkillSwitchBriefingFnc =
					{
						if (!(serverCommandAvailable "#logout") && {!isServer}) exitWith {systemChat "ONLY ADMIN CAN CHANGE OPTION"};
						_exit = false;
						_loopAlreadyActive = localNameSpace getVariable ["mdhAiSkillSwitchLoop",0];
						if ((_this#0) == "allOfTheAbove") then
						{
							{
								_side = localNameSpace getVariable ["mdhAiSkillSwitchSide",0];
								if (_side == 0 OR _side == 1) then {missionNameSpace setVariable [("mdhAiSkillSwitchWest"+_x),(_this#1),true]};
								if (_side == 0 OR _side == 2) then {missionNameSpace setVariable [("mdhAiSkillSwitchEast"+_x),(_this#1),true]};
								if (_side == 0 OR _side == 3) then {missionNameSpace setVariable [("mdhAiSkillSwitchInde"+_x),(_this#1),true]};
							} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime"];
							localNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
						}
						else
						{
							if ((_this#0) == "side") exitWith
							{
								localNameSpace setVariable ["mdhAiSkillSwitchSide",(_this#1)];
								systemChat (_this#2);
								_exit = true;
							};
						
							if ((_this#0) == "loop") exitWith
							{
								if ((_this#1) == 1) then
								{
									if (localNameSpace getVariable ["mdhAiSkillSwitchLoop",0] == 1) then
									{
										systemChat "MDH AI Skill Switch Loop already activated";
										_exit = true;
									}
									else
									{
										//systemChat "MDH AI Skill Switch Loop activated";
										//_exit = true;
									};
								}
								else
								{
									systemChat (_this#2);
									_exit = true;
								};
								localNameSpace setVariable ["mdhAiSkillSwitchLoop",(_this#1)];
							};
						
							if ((_this#0) == "debug") exitWith
							{
								if ((_this#1) == 1) then
								{
									if ((localNameSpace getVariable ["mdhAiSkillSwitchDebug",0]) == 1) then
									{
										systemChat "MDH AI Skill Switch Debug already activated";
										_exit = true;
									}
									else
									{
										systemChat (_this#2);
										//_exit = true;
									};
								}
								else
								{
									systemChat (_this#2);
									//_exit = true;
								};
								localNameSpace setVariable ["mdhAiSkillSwitchDebug",(_this#1)];
							};
						
							_side = localNameSpace getVariable ["mdhAiSkillSwitchSide",0];
							if (_side == 0 OR _side == 1) then {missionNameSpace setVariable [("mdhAiSkillSwitchWest"+(_this#0)),(_this#1),true]};
							if (_side == 0 OR _side == 2) then {missionNameSpace setVariable [("mdhAiSkillSwitchEast"+(_this#0)),(_this#1),true]};
							if (_side == 0 OR _side == 3) then {missionNameSpace setVariable [("mdhAiSkillSwitchInde"+(_this#0)),(_this#1),true]};
							localNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
						};
						if (_exit) exitWith {};
						
						if ((_this#0) == "debug") exitWith
						{
							if ((_this#1) == 1) then
							{
								_eh = addMissionEventHandler["Draw3D",
								{
									{
										if (alive _x && {!(_x in allPlayers)}) then
										{
											if (vehicle player distance _x < 30) then
											{
												_tSize = 0.032;
												_vectorAdd = [0,0, -(((vehicle player distance _x)/45)*getObjectFOV player)];
												_color = [1,1,1,1];
						
												_pos = unitAimPositionVisual _x;
												_pos = _pos vectorAdd [0,0,0.5];
												_s = "Ori / Cur / Fin";
												drawIcon3D ["", _color, _pos, 1, 1, 0, _s, 1, _tSize, "RobotoCondensedBold", "left"];
						
												_u = _x;
												{
													_pos = _pos vectorAdd _vectorAdd;
													call compile
													(
														"_"+_x+"Orig = _u getVariable[""mdhAiSkillSwitch"+_x+"Orig"",(_u skill """+_x+""")];"
														+"_"+_x+"Final = _u skillFinal ("""+_x+""");"
														+"_"+_x+"Current = _u skill ("""+_x+""");"
														+"_s = """+_x+" ""+(_"+_x+"Orig toFixed 1)+"" / ""+(_"+_x+"Current toFixed 1)+"" / ""+(_"+_x+"Final toFixed 1);"
														+"drawIcon3D ["""", _color, _pos, 1, 1, 0, _s, 1, _tSize, ""RobotoCondensedBold"", ""left""];"
													);
												} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime"];
						
												_pos = _pos vectorAdd _vectorAdd;
												_s1 = _x getVariable ["mdhAiSkillSwitchallowFleeing",0.5];
												_s2 = 0.5;
												_s = ("allowFleeing " + (_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1));
												drawIcon3D ["", _color, _pos, 1, 1, 0, _s, 1, _tSize, "RobotoCondensedBold", "left"];
						
												_pos = _pos vectorAdd _vectorAdd;
												_s1 = if (_x checkAIFeature "AUTOCOMBAT") then {1} else {0};
												_s2 = if (_x getVariable["mdhAiSkillSwitchAUTOCOMBATorig",_s1] == 1) then {1} else {0};
												_s = ("autoCombat " + (_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1));
												drawIcon3D ["", _color, _pos, 1, 1, 0, _s, 1, _tSize, "RobotoCondensedBold", "left"];
											};
										}
									} forEach allUnits;
								},[]];
								localNameSpace setVariable ["mdhAiSkillSwitchDraw3D",_eh];
						
								0 spawn
								{
									scriptName "mdhAiSkillSwitchMapMarkerRefresh";
									localNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
									_allUnits = allUnits;
									while {sleep 3; localNameSpace getVariable ["mdhAiSkillSwitchDraw3D",-1] != -1} do
									{
										_c = {_x in _allUnits} count allUnits == count allUnits;
										if (!_c OR localNameSpace getVariable ["mdhAiSkillSwitchMapMarkerRefresh",0] == 1) then
										{
											_allUnits = allUnits;
											localNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",0];
											{deleteMarkerLocal _x} forEach (localNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
											localNameSpace setVariable["mdhAiSkillSwitchArray",[]];
											_array = [];
											{
												if (alive _x && {_x == leader group _x} && {!(_x in allPlayers)}) then
												{
													_pos = getPosWorld _x;
													_marker = createMarkerLocal [("mdhAiSkillSwitchMarker_"+str(_forEachIndex)), _pos];
													_marker setMarkerShapeLocal "ICON";
													_marker setMarkerTypeLocal "hd_dot";
													_marker setMarkerSize [0.1, 0.1];
													_colorX = "ColorCIV";
													if (side group _x == west) then {_colorX = "ColorWEST"};
													if (side group _x == east) then {_colorX = "ColorEAST"};
													if (side group _x == Independent) then {_colorX = "ColorGUER"};
													_marker setMarkerColorLocal _colorX;
													_s = "Ori / Cur / Fin";
													_marker setMarkerTextLocal _s;
													_array pushBack _marker;
													
													_u = _x;
													{
														_pos = _pos vectorAdd [0, -0.4, 0];
														_marker = createMarkerLocal [(_marker+"_2_"+str(_forEachIndex)), _pos];
														_marker setMarkerShapeLocal "ICON";
														_marker setMarkerTypeLocal "hd_dot";
														_marker setMarkerSize [0.1, 0.1];
														_colorX = "ColorCIV";
														if (side _u == west) then {_colorX = "ColorWEST"};
														if (side _u == east) then {_colorX = "ColorEAST"};
														if (side _u == sideEnemy) then {_colorX = "ColorEAST"};
														if (side _u == Independent) then {_colorX = "ColorGUER"};
														_marker setMarkerColorLocal _colorX;
						
														call compile
														(
															"_"+_x+"Orig = _u getVariable[""mdhAiSkillSwitch"+_x+"Orig"",(_u skill """+_x+""")];"
															+"_"+_x+"Final = _u skillFinal ("""+_x+""");"
															+"_"+_x+"Current = _u skill ("""+_x+""");"
															+"_s = (_"+_x+"Orig toFixed 1)+"" / ""+(_"+_x+"Current toFixed 1)+"" / ""+(_"+_x+"Final toFixed 1)+"" "+_x+""";"
														);
						
														_marker setMarkerTextLocal _s;
														_array pushBack _marker;
													} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime"];
						
													_pos = _pos vectorAdd [0, -0.4, 0];
													_marker = createMarkerLocal [("mdhAiSkillSwitchMarker_special_"+str(_forEachIndex)), _pos];
													_marker setMarkerShapeLocal "ICON";
													_marker setMarkerTypeLocal "hd_dot";
													_marker setMarkerSize [0.1, 0.1];
													_colorX = "ColorCIV";
													if (side group _x == west) then {_colorX = "ColorWEST"};
													if (side group _x == east) then {_colorX = "ColorEAST"};
													if (side group _x == Independent) then {_colorX = "ColorGUER"};
													_marker setMarkerColorLocal _colorX;
													_s1 = _x getVariable ["mdhAiSkillSwitchallowFleeing",0.5];
													_s2 = 0.5;
													_s = ((_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1) + " allowFleeing");
													_marker setMarkerTextLocal _s;
													_array pushBack _marker;
						
													_pos = _pos vectorAdd [0, -0.4, 0];
													_marker = createMarkerLocal [("mdhAiSkillSwitchMarker_special2_"+str(_forEachIndex)), _pos];
													_marker setMarkerShapeLocal "ICON";
													_marker setMarkerTypeLocal "hd_dot";
													_marker setMarkerSize [0.1, 0.1];
													_colorX = "ColorCIV";
													if (side group _x == west) then {_colorX = "ColorWEST"};
													if (side group _x == east) then {_colorX = "ColorEAST"};
													if (side group _x == Independent) then {_colorX = "ColorGUER"};
													_marker setMarkerColorLocal _colorX;
													_s1 = if (_x checkAIFeature "AUTOCOMBAT") then {1} else {0};
													_s2 = if (_x getVariable["mdhAiSkillSwitchAUTOCOMBATorig",_s1] == 1) then {1} else {0};
													_s = ((_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1) + " autoCombat");
													_marker setMarkerTextLocal _s;
													_array pushBack _marker;
												};
											} forEach allUnits;
											localNameSpace setVariable["mdhAiSkillSwitchArray",_array];
										};
									};
									{deleteMarkerLocal _x} forEach (localNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
								};
							}
							else
							{
								removeMissionEventHandler ["Draw3D",(localNameSpace getVariable ["mdhAiSkillSwitchDraw3D",-1])];
								localNameSpace setVariable ["mdhAiSkillSwitchDraw3D",-1];
								{deleteMarkerLocal _x} forEach (localNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
							};
						};
						
						[_this,_loopAlreadyActive] spawn
						{
							scriptName "mdhAiSkillSwitchLoop";
							_loopAlreadyActive = _this#1;
							_i = 0;
							[((_this#0#2)+" by "+(name player))] remoteExec ["systemChat", 0];
							while {(localNameSpace getVariable["mdhAiSkillSwitchLoop",0] == 1) OR {_i == 0}} do
							{
								if ((localNameSpace getVariable ["mdhAiSkillSwitchDebug",0]) == 1) then {systemChat "MDH AI Skill Switch set for units"};
								_i = 1;
								sleep 0.5;
								[
									{
										if (!(_x in allPlayers)) then
										{
											if (_x getVariable["mdhAiSkillSwitchAUTOCOMBATorig",-1] == -1) then
											{
												_s1 = if (_x checkAIFeature "AUTOCOMBAT") then {1} else {0}; 
												_x setVariable["mdhAiSkillSwitchAUTOCOMBATorig",_s1];
											};

											_s1 = -1;
											if (side group _x == west) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchWestAUTOCOMBAT"),-1]};
											if (side group _x == east) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchEastAUTOCOMBAT"),-1]};
											if (side group _x == independent) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchIndeAUTOCOMBAT"),-1]};
											if (_s1 != -1) then
											{
												if (_s1 == 0) then
												{
													_x disableAI "AUTOCOMBAT";
												}
												else
												{
													_x enableAI "AUTOCOMBAT";
												}
											};

											_s1 = -1;
											if (side group _x == west) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchWestallowFleeing"),-1]};
											if (side group _x == east) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchEastallowFleeing"),-1]};
											if (side group _x == independent) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchIndeallowFleeing"),-1]};
											if (_s1 != -1) then
											{
												_x allowFleeing _s1;
												_x setVariable["mdhAiSkillSwitchallowFleeing",_s1];
											};

											_u = _x;
											{
												if (_u getVariable[("mdhAiSkillSwitch"+_x+"Orig"),-1] == -1) then
												{
													_u setVariable[("mdhAiSkillSwitch"+_x+"Orig"),(_u skill _x)];
												};
						
												_s1 = -1;
												if (side group _u == west) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchWest"+_x),-1]};
												if (side group _u == east) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchEast"+_x),-1]};
												if (side group _u == independent) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchInde"+_x),-1]};
												if (_s1 != -1) then {_u setSkill[_x, _s1]};
											} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime"];

											if (FALSE && isServer) then
											{
												[("ServerMessage: " + str(_x) + " " + _s1 + " " + str(_x skill _s1))] remoteExec ["systemChat", 0];
											};
										}
									}
									,allUnits
								] remoteExec ["forEach", 0];
								sleep 0.5;
								localNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
								if (_loopAlreadyActive == 1) exitWith {};
								while {_i = _i + 1; _i < 120 && (localNameSpace getVariable["mdhAiSkillSwitchLoop",0] == 1)} do {sleep 0.5};
							};
						};
					};

					_diaryRecord = "
						'<br/>MDH AI Skill Switch is a Mod, created by Moerderhoschi for Arma 3. (v2025-12-05)<br/>'
						+ '<br/>'
						+ 'You can set AI Skill values.<br/>'
					";
					{
						if (true) then
						{
							_v = _x;
							_v2 = _x;
							if (_v2 == "allOfTheAbove") then {_v2 = ""};
							if (_v == "") exitWith {_diaryRecord = _diaryRecord + "+'<br/>'"};
							if (_v == "---") exitWith {_diaryRecord = _diaryRecord + "+'<br/>-------------------------------------------------------------------------------------------------'"};
							_diaryRecord = _diaryRecord + "
								+'<br/>'
								+      '<font color=""#CC0000""><execute expression = ""[''"+_v+"'',0.0,''MDH AI Skill "+_v2+" set 0''  ] call mdhAiSkillSwitchBriefingFnc"">0</execute></font color>'
								+ '  /  <font color=""#CC0000""><execute expression = ""[''"+_v+"'',0.1,''MDH AI Skill "+_v2+" set 0.1''] call mdhAiSkillSwitchBriefingFnc"">1</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.2,''MDH AI Skill "+_v2+" set 0.2''] call mdhAiSkillSwitchBriefingFnc"">2</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.3,''MDH AI Skill "+_v2+" set 0.3''] call mdhAiSkillSwitchBriefingFnc"">3</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.4,''MDH AI Skill "+_v2+" set 0.4''] call mdhAiSkillSwitchBriefingFnc"">4</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.5,''MDH AI Skill "+_v2+" set 0.5''] call mdhAiSkillSwitchBriefingFnc"">5</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.6,''MDH AI Skill "+_v2+" set 0.6''] call mdhAiSkillSwitchBriefingFnc"">6</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.7,''MDH AI Skill "+_v2+" set 0.7''] call mdhAiSkillSwitchBriefingFnc"">7</execute></font color>'
								+ '  /  <font color=""#33CC33""><execute expression = ""[''"+_v+"'',0.8,''MDH AI Skill "+_v2+" set 0.8''] call mdhAiSkillSwitchBriefingFnc"">8</execute></font color>'
								+ '  /  <font color=""#CC0000""><execute expression = ""[''"+_v+"'',0.9,''MDH AI Skill "+_v2+" set 0.9''] call mdhAiSkillSwitchBriefingFnc"">9</execute></font color>'
								+ '  /  <font color=""#CC0000""><execute expression = ""[''"+_v+"'',1.0,''MDH AI Skill "+_v2+" set 1''  ] call mdhAiSkillSwitchBriefingFnc"">10</execute></font color>'
								+ ' -> set "+_v+"'
							";
						}
					} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime","---","allOfTheAbove","","allowFleeing",""];

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+      '<font color=""#CC0000""><execute expression = ""[''AutoCombat'',0,''MDH AI AutoCombat set 0''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''AutoCombat'',1,''MDH AI AutoCombat set 1''] call mdhAiSkillSwitchBriefingFnc"">ON</execute></font color>'
						+ ' -> set AutoCombat(autonomous switching to Combat)'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#33CC33""><execute expression = ""[''side'',0,''MDH AI Side set all''] call mdhAiSkillSwitchBriefingFnc"">ALL</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''side'',1,''MDH AI Side set west''] call mdhAiSkillSwitchBriefingFnc"">WEST</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''side'',2,''MDH AI Side set east''] call mdhAiSkillSwitchBriefingFnc"">EAST</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''side'',3,''MDH AI Side set independent''] call mdhAiSkillSwitchBriefingFnc"">INDEPENDENT</execute></font color>'
						+ ' -> set side for skillchange'
					";
					
					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#33CC33""><execute expression = ""[''loop'',0,''MDH AI Skill Switch Loop deactivated''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ ' /  <execute expression = ""[''loop'',1,''MDH AI Skill Switch Loop activated''] call mdhAiSkillSwitchBriefingFnc"">ON</execute>'
						+ ' -> run in a loop to auto apply options to new spawned AI'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#CC0000""><execute expression = ""[''debug'',0,''MDH AI Skill Switch Debug deactivated''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''debug'',1,''MDH AI Skill Switch Debug activated''] call mdhAiSkillSwitchBriefingFnc"">ON</execute></font color>'
						+ ' -> Debuginfo'
					";

					_diaryRecord = _diaryRecord + "
						+ '<br/>'
						+ '<br/>'
						+ 'If you have any question you can contact me at the steam workshop page.<br/>'
						+ '<br/>'
						+ '<img image=""mdhAiSkillSwitch\mdhAiSkillSwitch.paa""/>'
						+ '<br/>'
						+ '<br/>'
						+ 'Credits and Thanks:<br/>'
						+ 'Armed-Assault.de Crew - For many great ArmA moments in many years<br/>'
						+ 'BIS - For ArmA3<br/>'
					";

					_briefingFormatFix =
					'
						player createDiaryRecord
						[
							"MDH Mods",
							[
								_t,('+_diaryRecord+')
							]
						];
					';
					call compile _briefingFormatFix;
				};
			};
		};


		if (hasInterface) then
		{
			if (isNil"mdhModDiaryEntries")then{mdhModDiaryEntries=[]; mdhModDiaryEntriesAdd = 1};
			mdhModDiaryEntries pushBack ["mdhAiSkillSwitch",_diary];
			uiSleep (2 + random 1);
			if (mdhModDiaryEntriesAdd == 1) then
			{
				mdhModDiaryEntriesAdd = 0;
				mdhModDiaryEntries sort false;
				{call (_x#1)} forEach mdhModDiaryEntries;
			};
		};

		_mdhModDiaryEntries = +mdhModDiaryEntries;
		sleep (1 + random 1);
		while {missionNameSpace getVariable ["pMdhAiSkillSwitch",_defaultValue] == _valueCheck} do
		{
			sleep (4 + random 2);
			if (hasInterface) then {{call (_x#1)} forEach _mdhModDiaryEntries};
		};
	};
};
