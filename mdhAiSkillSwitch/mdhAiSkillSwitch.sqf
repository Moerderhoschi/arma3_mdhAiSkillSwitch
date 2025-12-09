///////////////////////////////////////////////////////////////////////////////////////////////////
// MDH AI SKILL SWITCH(by Moerderhoschi) - v2025-12-09
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
						_loopAlreadyActive = missionNameSpace getVariable ["mdhAiSkillSwitchLoop",0];
						if ((_this#0) == "allOfTheAbove") then
						{
							{
								_side = missionNameSpace getVariable ["mdhAiSkillSwitchSide",0];
								if (_side == 0 OR _side == 1) then {missionNameSpace setVariable [("mdhAiSkillSwitchWest"+_x),(_this#1),true]};
								if (_side == 0 OR _side == 2) then {missionNameSpace setVariable [("mdhAiSkillSwitchEast"+_x),(_this#1),true]};
								if (_side == 0 OR _side == 3) then {missionNameSpace setVariable [("mdhAiSkillSwitchInde"+_x),(_this#1),true]};
							} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime"];
							missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
						}
						else
						{
							if ((_this#0) == "side") exitWith
							{
								missionNameSpace setVariable ["mdhAiSkillSwitchSide",(_this#1)];
								systemChat (_this#2);
								_exit = true;
							};
						
							if ((_this#0) == "loop") exitWith
							{
								if ((_this#1) == 1) then
								{
									if (missionNameSpace getVariable ["mdhAiSkillSwitchLoop",0] == 1) then
									{
										systemChat "MDH AI Skill Switch Loop already ON";
										_exit = true;
									}
									else
									{
										//systemChat "MDH AI Skill Switch Loop ON";
										//_exit = true;
									};
								}
								else
								{
									systemChat (_this#2);
									_exit = true;
								};
								missionNameSpace setVariable ["mdhAiSkillSwitchLoop",(_this#1)];
							};
						
							if ((_this#0) == "debug") exitWith
							{
								if ((_this#1) == 1) then
								{
									if ((missionNameSpace getVariable ["mdhAiSkillSwitchDebug",0]) == 1) then
									{
										systemChat "MDH AI Skill Switch Debug already ON";
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
								missionNameSpace setVariable ["mdhAiSkillSwitchDebug",(_this#1)];
							};
						
							if ((_this#0) == "save") exitWith
							{
								_slot = str(_this#1);
								_arrayW = [];
								_arrayE = [];
								_arrayI = [];
								{
									_type = _x;
									{
										_side = _x;
										_value = missionNameSpace getVariable [("mdhAiSkillSwitch" + _side + _type), -1];
										profileNameSpace setVariable [("mdhAiSkillSwitch" + _side + _type + _slot), _value];
										if (_side == "West") then {_arrayW pushBack (_type +": "+str(_value)+" ")};
										if (_side == "East") then {_arrayE pushBack (_type +": "+str(_value)+" ")};
										if (_side == "Inde") then {_arrayI pushBack (_type +": "+str(_value)+" ")};
									} forEach ["West","East","Inde"];
								} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime","allowFleeing","AutoCombat"];
								systemChat (_this#2);
								systemChat ("West - "  + (str(_arrayW) regexReplace ["""", ""]));
								systemChat ("East -  " + (str(_arrayE) regexReplace ["""", ""]));
								systemChat ("Inde -  " + (str(_arrayI) regexReplace ["""", ""]));
								_exit = true;
							};

							if ((_this#0) in["load","loadE"]) exitWith
							{
								_slot = (_this#1);
								if (_slot > 0) then
								{
									_slot = str(_slot);
									_arrayW = [];
									_arrayE = [];
									_arrayI = [];
									{
										_type = _x;
										{
											_side = _x;
											_value = profileNameSpace getVariable [("mdhAiSkillSwitch" + _side + _type + _slot), -1];
											missionNameSpace setVariable [("mdhAiSkillSwitch" + _side + _type), _value, true];
											if (_side == "West") then {_arrayW pushBack (_type +": "+str(_value)+" ")};
											if (_side == "East") then {_arrayE pushBack (_type +": "+str(_value)+" ")};
											if (_side == "Inde") then {_arrayI pushBack (_type +": "+str(_value)+" ")};
										} forEach ["West","East","Inde"];
									} forEach ["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime","allowFleeing","AutoCombat"];
									systemChat ("West - "  + (str(_arrayW) regexReplace ["""", ""]));
									systemChat ("East -  " + (str(_arrayE) regexReplace ["""", ""]));
									systemChat ("Inde -  " + (str(_arrayI) regexReplace ["""", ""]));									
								};
								//systemChat (_this#2);
								if ((_this#0) == "loadE") then
								{
									profileNameSpace setVariable ["mdhAiSkillSwitchLoadEvery", (_this#1)];
									if ((_this#1) == 0) exitWith {systemChat (_this#2); _exit = true};
									missionNameSpace setVariable ["mdhAiSkillSwitchLoop", 1];
								};
								missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
							};

							_side = missionNameSpace getVariable ["mdhAiSkillSwitchSide",0];
							if (_side == 0 OR _side == 1) then {missionNameSpace setVariable [("mdhAiSkillSwitchWest"+(_this#0)),(_this#1),true]};
							if (_side == 0 OR _side == 2) then {missionNameSpace setVariable [("mdhAiSkillSwitchEast"+(_this#0)),(_this#1),true]};
							if (_side == 0 OR _side == 3) then {missionNameSpace setVariable [("mdhAiSkillSwitchInde"+(_this#0)),(_this#1),true]};
							missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
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
												_s1 = if (_x checkAIFeature "AutoCombat") then {1} else {0};
												_s2 = if (_x getVariable["mdhAiSkillSwitchAutoCombatorig",_s1] == 1) then {1} else {0};
												_s = ("AutoCombat " + (_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1));
												drawIcon3D ["", _color, _pos, 1, 1, 0, _s, 1, _tSize, "RobotoCondensedBold", "left"];
											};
										}
									} forEach allUnits;
								},[]];
								missionNameSpace setVariable ["mdhAiSkillSwitchDraw3D",_eh];
						
								0 spawn
								{
									scriptName "mdhAiSkillSwitchMapMarkerRefresh";
									missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
									_allUnits = allUnits;
									while {sleep 3; missionNameSpace getVariable ["mdhAiSkillSwitchDraw3D",-1] != -1} do
									{
										_c = {_x in _allUnits} count allUnits == count allUnits;
										if (!_c OR missionNameSpace getVariable ["mdhAiSkillSwitchMapMarkerRefresh",0] == 1) then
										{
											_allUnits = allUnits;
											missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",0];
											{deleteMarkerLocal _x} forEach (missionNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
											missionNameSpace setVariable["mdhAiSkillSwitchArray",[]];
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
													_vectorAdd = -2;
													{
														_pos = _pos vectorAdd [0, _vectorAdd, 0];
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
						
													_pos = _pos vectorAdd [0, _vectorAdd, 0];
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
						
													_pos = _pos vectorAdd [0, _vectorAdd, 0];
													_marker = createMarkerLocal [("mdhAiSkillSwitchMarker_special2_"+str(_forEachIndex)), _pos];
													_marker setMarkerShapeLocal "ICON";
													_marker setMarkerTypeLocal "hd_dot";
													_marker setMarkerSize [0.1, 0.1];
													_colorX = "ColorCIV";
													if (side group _x == west) then {_colorX = "ColorWEST"};
													if (side group _x == east) then {_colorX = "ColorEAST"};
													if (side group _x == Independent) then {_colorX = "ColorGUER"};
													_marker setMarkerColorLocal _colorX;
													_s1 = if (_x checkAIFeature "AutoCombat") then {1} else {0};
													_s2 = if (_x getVariable["mdhAiSkillSwitchAutoCombatorig",_s1] == 1) then {1} else {0};
													_s = ((_s2 toFixed 1) + " / " + (_s1 toFixed 1) + " / " + (_s1 toFixed 1) + " AutoCombat");
													_marker setMarkerTextLocal _s;
													_array pushBack _marker;
												};
											} forEach allUnits;
											missionNameSpace setVariable["mdhAiSkillSwitchArray",_array];
										};
									};
									{deleteMarkerLocal _x} forEach (missionNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
								};
							}
							else
							{
								removeMissionEventHandler ["Draw3D",(missionNameSpace getVariable ["mdhAiSkillSwitchDraw3D",-1])];
								missionNameSpace setVariable ["mdhAiSkillSwitchDraw3D",-1];
								{deleteMarkerLocal _x} forEach (missionNameSpace getVariable["mdhAiSkillSwitchArray",[]]);
							};
						};
						
						[_this,_loopAlreadyActive] spawn
						{
							scriptName "mdhAiSkillSwitchLoop";
							_loopAlreadyActive = _this#1;
							_i = 0;
							_sideTxt = "";

							if ((_this#0#0)in["aimingAccuracy","aimingShake","aimingSpeed","commanding","courage","general","reloadSpeed","spotDistance","spotTime","allOfTheAbove","allowFleeing","AutoCombat"]) then
							{
								_side = missionNameSpace getVariable ["mdhAiSkillSwitchSide",0];
								if (_side == 0) then {_sideTxt = " for All"};
								if (_side == 1) then {_sideTxt = " for West"};
								if (_side == 2) then {_sideTxt = " for East"};
								if (_side == 3) then {_sideTxt = " for Independent"};
							};

							[((_this#0#2)+_sideTxt+" by "+(name player))] remoteExec ["systemChat", 0];
							while {(missionNameSpace getVariable["mdhAiSkillSwitchLoop",0] == 1) OR {_i == 0}} do
							{
								//if ((missionNameSpace getVariable ["mdhAiSkillSwitchDebug",0]) == 1) then {systemChat "MDH AI Skill Switch set for units"};
								_i = 1;
								sleep 0.5;
								[
									{
										if (!(_x in allPlayers)) then
										{
											if (_x getVariable["mdhAiSkillSwitchAutoCombatorig",-1] == -1) then
											{
												_s1 = if (_x checkAIFeature "AutoCombat") then {1} else {0}; 
												_x setVariable["mdhAiSkillSwitchAutoCombatorig",_s1];
											};

											_s1 = -1;
											if (side group _x == west) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchWestAutoCombat"),-1]};
											if (side group _x == east) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchEastAutoCombat"),-1]};
											if (side group _x == independent) then {_s1 = missionNameSpace getVariable[("mdhAiSkillSwitchIndeAutoCombat"),-1]};
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
								missionNameSpace setVariable ["mdhAiSkillSwitchMapMarkerRefresh",1];
								if (_loopAlreadyActive == 1) exitWith {};
								while {_i = _i + 1; _i < 120 && (missionNameSpace getVariable["mdhAiSkillSwitchLoop",0] == 1)} do {sleep 0.5};
							};
						};
					};

					_diaryRecord = "
						'<br/>MDH AI Skill Switch is a Mod, created by Moerderhoschi for Arma 3. (v2025-12-09)<br/>'
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
						+      '<font color=""#CC0000""><execute expression = ""[''loop'',0,''MDH AI Skill Switch Loop OFF''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''loop'',1,''MDH AI Skill Switch Loop ON''] call mdhAiSkillSwitchBriefingFnc"">ON</execute></font color>'
						+ ' -> run in a loop to auto apply options to new spawned AI'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#CC0000""><execute expression = ""[''debug'',0,''MDH AI Skill Switch Debug OFF''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''debug'',1,''MDH AI Skill Switch Debug ON''] call mdhAiSkillSwitchBriefingFnc"">ON</execute></font color>'
						+ ' -> Debuginfo'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#33CC33""><execute expression = ""[''save'',1,''MDH AI Skill Switch saved skill values 1''] call mdhAiSkillSwitchBriefingFnc"">SAVE1</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''save'',2,''MDH AI Skill Switch saved skill values 2''] call mdhAiSkillSwitchBriefingFnc"">SAVE2</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''save'',3,''MDH AI Skill Switch saved skill values 3''] call mdhAiSkillSwitchBriefingFnc"">SAVE3</execute></font color>'
						+ ' -> save current settings'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#33CC33""><execute expression = ""[''load'',1,''MDH AI Skill Switch loaded skill values 1''] call mdhAiSkillSwitchBriefingFnc"">LOAD1</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''load'',2,''MDH AI Skill Switch loaded skill values 2''] call mdhAiSkillSwitchBriefingFnc"">LOAD2</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''load'',3,''MDH AI Skill Switch loaded skill values 3''] call mdhAiSkillSwitchBriefingFnc"">LOAD3</execute></font color>'
						+ ' -> load settings'
					";

					_diaryRecord = _diaryRecord + "
						+'<br/>'
						+'<br/>'
						+      '<font color=""#CC0000""><execute expression = ""[''loadE'',0,''MDH AI Skill Switch load on every missionstart OFF''] call mdhAiSkillSwitchBriefingFnc"">OFF</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''loadE'',1,''MDH AI Skill Switch load on every missionstart 1 ON''] call mdhAiSkillSwitchBriefingFnc"">LOAD1</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''loadE'',2,''MDH AI Skill Switch load on every missionstart 2 ON''] call mdhAiSkillSwitchBriefingFnc"">LOAD2</execute></font color>'
						+ '  /  <font color=""#33CC33""><execute expression = ""[''loadE'',3,''MDH AI Skill Switch load on every missionstart 3 ON''] call mdhAiSkillSwitchBriefingFnc"">LOAD3</execute></font color>'
						+ ' -> load settings on every missionstart'
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
			if (_mdhFnc == 0) then
			{
				_mdhFnc = 1;
				_value = (profileNameSpace getVariable ["mdhAiSkillSwitchLoadEvery", 0]);
				if (_value != 0) then {["loadE", _value, ("MDH AI Skill Switch load on every missionstart "+str(_value)+" ON")] call mdhAiSkillSwitchBriefingFnc};
			};
			sleep (4 + random 2);
			if (hasInterface) then {{call (_x#1)} forEach _mdhModDiaryEntries};
		};
	};
};
