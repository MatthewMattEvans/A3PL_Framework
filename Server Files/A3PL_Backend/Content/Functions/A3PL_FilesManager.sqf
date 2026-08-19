/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_FilesManager_Computer",
{
	A3PL_ComputerResponse = [];
	createDialog "A3PL_Computer";
	waitUntil { dialog };
	[player] remoteExec ["Server_FilesManager_getComputerInfo",2];
	waitUntil { count A3PL_ComputerResponse > 0 };
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	(_display) call A3PL_Dialog_Localize;
	_treeCtrl = _display displayCtrl 130901;
	tvClear _treeCtrl;
	_folders = A3PL_ComputerResponse # 0;
	_files = A3PL_ComputerResponse # 1;

	_factionBackground = _display displayCtrl 1500;
	_companyBackground = _display displayCtrl 1501;
	_logo = _display displayCtrl 15803;
	_factionBackground ctrlShow false;
	_companyBackground ctrlShow false;

	_job = player getvariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_job IN [("STR_Common_DOJ" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		_factionBackground ctrlShow true;
		_logo ctrlSetText format["\PO_UI\Data\Logos\%1.paa",_job];
	} else {
		_companyBackground ctrlShow true;
		private _textureFilesManager = if (count A3PL_ComputerResponse > 2) then {A3PL_ComputerResponse # 2} else {""};
		if (_textureFilesManager != "" && !isNil "_textureFilesManager") then {
			_logo ctrlSetText _textureFilesManager;
		} else {
			_logo ctrlSetText "\PO_UI\Data\Logos\default.paa";
		};
	};
	
	_logo ctrlCommit 0;

	A3PL_folderNodes = createHashMap;
	{
		_folderID = _x # 0;
		_folderName = _x # 1;
		_folderParentID = _x # 2;
		_folderStatus = _x # 3;

		private _replacedName = [_folderName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?y?', "'"] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?x?', "\"] call CBA_fnc_replace;

		private _parentNode = if (_folderParentID == -1) then { [] } else { A3PL_folderNodes get _folderParentID };
		
		private _nodeID = _treeCtrl tvAdd [_parentNode, _replacedName];
		_treeCtrl tvSetPicture [_parentNode + [_nodeID], "\A3PL_Common\GUI\filesmanager\folder.paa"];
		_treeCtrl tvSetData [_parentNode + [_nodeID],str[_folderID, _replacedName, _folderParentID,_folderStatus]];

		A3PL_folderNodes set [_folderID, _parentNode + [_nodeID]];
	} forEach _folders;
	{
		private _fileID = _x # 0;
		private _folderID = _x # 1; 
		private _fileName = _x # 2;
		private _content = _x # 3;
		private _createdAt = _x # 4;
		private _updatedAt = _x # 5;
		private _statusfile = _x # 6;

		private _replacedContent = [_content, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;

		private _replacedName = [_fileName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?x?', "\"] call CBA_fnc_replace;

		private _folderNode = if (_folderID == -1) then { [] } else { A3PL_folderNodes get _folderID };

		_fileAdded = _treeCtrl tvAdd [_folderNode, _replacedName];
		if (_statusfile isEqualTo 1) then {
			_treeCtrl tvSetPicture [_folderNode + [_fileAdded], "\A3PL_Common\GUI\filesmanager\lock.paa"];
		} else {
			_treeCtrl tvSetPicture [_folderNode + [_fileAdded], "\A3PL_Common\GUI\filesmanager\file.paa"];
		};
		_treeCtrl tvSetData [_folderNode + [_fileAdded],str[_fileID, _folderID, _replacedName, _replacedContent, _createdAt, _updatedAt, _statusfile]];
	} forEach _files;

	private _control = _display displayCtrl 130906;
	_control ctrlAddEventHandler ["KeyUp", {call A3PL_FilesManager_Search;}];

	tvExpandAll _treeCtrl;
}] call compile_Global;

["A3PL_FilesManager_Search",
{
    private _display = uiNamespace getVariable "A3PL_ComputerDisplay";
    private _searchControl = _display displayCtrl 130906;
    private _searchTerm = toLower (ctrlText _searchControl);

    private _folders = A3PL_ComputerResponse # 0;
    private _files = A3PL_ComputerResponse # 1;

    private _searchResultsFolders = [];
    private _searchResultsFiles = [];

    {
        private _folderID = _x # 0;
        private _folderName = toLower (_x # 1);
		private _folderParent = _x # 2;
		private _status = _x # 3;


        if (_folderName find _searchTerm >= 0) then {
            _searchResultsFolders pushBack _x;
			if (!(_folderParent IN [-1,0])) then {
				{
					private _ThisfolderID = _x # 0;
					if (_folderParent isEqualTo _ThisfolderID && !(_x IN _searchResultsFolders)) then {
						_searchResultsFolders pushBack _x;
					};
				} forEach _folders;
			};
        };
    } forEach _folders;

    {
        private _fileID = _x # 0;
        private _folderID = _x # 1;
        private _fileName = toLower (_x # 2);
		private _status = _x # 6;

        if (_fileName find _searchTerm >= 0) then {
            _searchResultsFiles pushBack _x;
			if (!(_folderID IN [-1,0])) then {
				{
					private _AllfolderID = _x # 0;
					private _folderParent = _x # 2;
					if (_folderID isEqualTo _AllfolderID && !(_x IN _searchResultsFolders)) then {
						_searchResultsFolders pushBack _x;
					};
				} forEach _folders;
			};
        };
    } forEach _files;

	private _treeCtrl = _display displayCtrl 130901;
    tvClear _treeCtrl;

    A3PL_folderNodes = createHashMap;
	{
		_folderID = _x # 0;
		_folderName = _x # 1;
		_folderParentID = _x # 2;
		_folderStatus = _x # 3;

		private _replacedName = [_folderName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?y?', "'"] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?x?', "\"] call CBA_fnc_replace;

		private _parentNode = if (_folderParentID IN [-1,0]) then { [] } else { A3PL_folderNodes get _folderParentID };
		
		private _nodeID = _treeCtrl tvAdd [_parentNode, _replacedName];
		_treeCtrl tvSetPicture [_parentNode + [_nodeID], "\A3PL_Common\GUI\filesmanager\folder.paa"];
		_treeCtrl tvSetData [_parentNode + [_nodeID],str[_folderID, _replacedName, _folderParentID,_folderStatus]];

		A3PL_folderNodes set [_folderID, _parentNode + [_nodeID]];
	} forEach _searchResultsFolders;
	{
		private _fileID = _x # 0;
		private _folderID = _x # 1; 
		private _fileName = _x # 2;
		private _content = _x # 3;
		private _createdAt = _x # 4;
		private _updatedAt = _x # 5;
		private _statusfile = _x # 6;

		private _replacedContent = [_content, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;

		private _replacedName = [_fileName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?z?', '"'] call CBA_fnc_replace;
		_replacedName = [_replacedName, '?x?', "\"] call CBA_fnc_replace;

		private _folderNode = if (_folderID IN [-1,0]) then { [] } else { A3PL_folderNodes get _folderID };

		_fileAdded = _treeCtrl tvAdd [_folderNode, _replacedName];
		if (_statusfile isEqualTo 1) then {
			_treeCtrl tvSetPicture [_folderNode + [_fileAdded], "\A3PL_Common\GUI\filesmanager\lock.paa"];
		} else {
			_treeCtrl tvSetPicture [_folderNode + [_fileAdded], "\A3PL_Common\GUI\filesmanager\file.paa"];
		};
		_treeCtrl tvSetData [_folderNode + [_fileAdded],str[_fileID, _folderID, _replacedName, _replacedContent, _createdAt, _updatedAt, _statusfile]];
	} forEach _searchResultsFiles;

    tvExpandAll _treeCtrl;
}] call compile_Global;


["A3PL_FilesManager_createFile",
{
	private "_parentID";
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_curSel = tvCurSel _treeCtrl;
	_dataOfParent = _treeCtrl tvData _curSel;
	_dataOfParent = call compile _dataOfParent;
	if (count _dataOfParent > 4) then {
		_curSel deleteAt ((count _curSel) - 1);
		_dataOfParent = _treeCtrl tvData _curSel;
		_dataOfParent = call compile _dataOfParent;
	};
	_parentID = -1;
	if (!isNil "_dataOfParent") then {
		if ((count _dataOfParent) > 0) then {
			_parentID = _dataOfParent # 0;
		} else {
			_parentID = -1;
		};
	};
	_fileAdded = _treeCtrl tvAdd [_curSel,("STR_A3PL_FilesManager_UnnamedFile" call A3PL_Localize)];
	_fileInfo = _display displayCtrl 130903;
	_fileInfo ctrlSetStructuredText parseText ("STR_A3PL_FilesManager_FileInfo" call A3PL_Localize);
	closeDialog 0;
	[_parentID, ("STR_A3PL_FilesManager_UnnamedFile" call A3PL_Localize), player] remoteExec ["Server_FilesManager_createFilePV",2];
	sleep 0.1;
	[] spawn A3PL_FilesManager_Computer;
}] call compile_Global;

["A3PL_FilesManager_createFolder",
{
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_curSel = tvCurSel _treeCtrl;
	private _dataOfParent = _treeCtrl tvData _curSel;
	_dataOfParent = call compile _dataOfParent;

	private _job = player getVariable "job";
	private _requiredLicense = switch (_job) do {
		case ("STR_Common_FISD" call A3PL_Localize): {"fisdmdtadmin"};
		case ("STR_Common_FIFR" call A3PL_Localize): {"fifrmdtadmin"};
		case ("STR_Common_DOJ" call A3PL_Localize): {"dojmdtadmin"};
		case ("STR_Common_GOV" call A3PL_Localize): {"govmdtadmin"};
	};
	if (_job IN [("STR_Common_FISD" call A3PL_Localize), ("STR_Common_FIFR" call A3PL_Localize), ("STR_Common_DOJ" call A3PL_Localize), ("STR_Common_GOV" call A3PL_Localize)] && !(_requiredLicense IN (player getVariable ["licenses",[]]))) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPerm = [_cid, "filesmanager", _charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = [_charID] call A3PL_Config_IsCompanyBoss;
	if (_job == ("STR_Common_Company" call A3PL_Localize) && (!_isBoss || !_hasPerm)) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if ((count _dataOfParent) > 4) then {
		_curSel deleteAt ((count _curSel) - 1);
		_dataOfParent = _treeCtrl tvData _curSel;
		_dataOfParent = call compile _dataOfParent;
	};
	_parentID = -1;
	if (!isNil "_dataOfParent") then {
		if ((count _dataOfParent) > 0) then {
			_parentID = _dataOfParent # 0;
		} else {
			_parentID = -1;
		};
	};

	_fileAdded = _treeCtrl tvAdd [_curSel,("STR_A3PL_FilesManager_UnnamedFolder" call A3PL_Localize)];
	_treeCtrl tvSetPicture [_curSel + [_fileAdded], "\A3PL_Common\GUI\filesmanager\folder.paa"];
	_treeCtrl tvSetCurSel (_curSel + [_fileAdded]);
	_treeCtrl tvSetData [_curSel + [_fileAdded],str["", ("STR_A3PL_FilesManager_UnnamedFolder" call A3PL_Localize), _curSel]];

	closeDialog 0;
	[("STR_A3PL_FilesManager_UnnamedFolder" call A3PL_Localize), _parentID, player] remoteExec ["Server_FilesManager_createFolderPV",2];
	sleep 0.1;
	[] spawn A3PL_FilesManager_Computer;
}] call compile_Global;

["A3PL_FilesManager_saveFile",
{
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_fileInfo = _display displayCtrl 130903;
	_fileManager = _display displayCtrl 130905;
	_editor = _display displayCtrl 130904;
	_curSel = tvCurSel _treeCtrl;
	_data = _treeCtrl tvData _curSel;
	_data = call compile _data;

	private _statusfile = _data # 6;
	if (_statusfile isEqualTo 1) exitWith {
		[("STR_A3PL_FilesManager_ProtectedFile" call A3PL_Localize),Color_Red] call A3PL_Notification;
		closeDialog 0;
		[] spawn A3PL_FilesManager_Computer;
	};

	if ((count _data) > 4) then {
		private _fileID = _data # 0;
		private _folderID = _data # 1; 
		private _fileName = ctrlText _fileManager;
		private _content = ctrlText _editor;
		private _createdAt = _data # 4;
		private _updatedAt = _data # 5;

		private _replacedContent = [_content, '"', '?z?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "'", '?y?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "\", '?x?'] call CBA_fnc_replace;

		private _replacedName = [_fileName, '"', '?z?'] call CBA_fnc_replace;
		_replacedName = [_replacedName, "'", '?y?'] call CBA_fnc_replace;
		_replacedName = [_replacedName, "\", '?x?'] call CBA_fnc_replace;
		
		[_fileID,_folderID,_replacedName, _replacedContent, _createdAt, _updatedAt, player] remoteExec ["Server_FilesManager_saveFilePV",2];
		[("STR_A3PL_FilesManager_FileModified" call A3PL_Localize),Color_Green] call A3PL_Notification;
	} else {
		private _fileID = _data # 0;
		private _folderName = ctrlText _fileManager;
		private _folderParentID = _data # 2; 

		private _replacedName = [_folderName, '"', '?z?'] call CBA_fnc_replace;
		_replacedName = [_replacedName, "'", '?y?'] call CBA_fnc_replace;
		_replacedName = [_replacedName, "\", '?x?'] call CBA_fnc_replace;

		[_fileID,_replacedName,player] remoteExec ["Server_FilesManager_saveFolderPV",2];
		[("STR_A3PL_FilesManager_FolderModified" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
	closeDialog 0;
	sleep 0.1;
	[] spawn A3PL_FilesManager_Computer;
}] call compile_Global;

["A3PL_FilesManager_showData",
{
	if (!dialog) exitWith {};
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_fileInfo = _display displayCtrl 130903;
	_fileManager = _display displayCtrl 130905;
	_editor = _display displayCtrl 130904;
	_curSel = tvCurSel _treeCtrl;
	_data = _treeCtrl tvData _curSel;
	_data = call compile _data;

	if (count _data > 4) then {
		private _fileID = _data # 0;
		private _folderID = _data # 1; 
		private _fileName = _data # 2;
		private _content = _data # 3;
		private _createdAt = _data # 4;
		private _updatedAt = _data # 5;

		_editor ctrlSetText _content;
		_fileManager ctrlSetText _fileName;
		_fileInfo ctrlSetStructuredText parseText format[("STR_A3PL_FilesManager_FileInfo2" call A3PL_Localize),_createdAt # 0,_createdAt # 1, _createdAt # 2, _createdAt # 3, _createdAt # 4, _createdAt # 5,
		_updatedAt # 0, _updatedAt # 1, _updatedAt # 2, _updatedAt # 3, _updatedAt # 4, _updatedAt # 5];
		[] spawn A3PL_FilesManager_updatePreview;
	} else {
		private _fileName = _data # 1;

		_editor ctrlSetText "";
		_fileManager ctrlSetText _fileName;
		_fileInfo ctrlSetStructuredText parseText "";
		[] spawn A3PL_FilesManager_updatePreview;
	};
}] call compile_Global;

["A3PL_FilesManager_updatePreview",
{
    _display = uiNamespace getVariable "A3PL_ComputerDisplay";
    _editor = _display displayCtrl 130904;
    _preview = _display displayCtrl 130902;
    _input = ctrlText _editor;
    _splitString = _input splitString (toString[10]);
    _structuredTextNew = "";
    {
        _structuredText = _x;
        _structuredText = _structuredText regexReplace ["^#{3}\s?([^\n]+)", "<t size='1.2' font='Raleway'>$1"];
        _structuredText = _structuredText regexReplace ["^#{2}\s?([^\n]+)", "<t size='1.4' font='Raleway'>$1"];
        _structuredText = _structuredText regexReplace ["^#{1}\s?([^\n]+)", "<t size='1.6' font='Raleway'>$1"];
        _structuredText = _structuredText regexReplace ["\*\*\s?([^\n]+?)\*\*", "<t font='PuristaBold'>$1</t>"];
        _structuredText = _structuredText regexReplace ["\_\_\s?([^\n]+?)\_\_", "<t underline='true'>$1</t>"];
        _structuredText = _structuredText regexReplace ["^\*\s?([^\n]+)", "<t>• $1</t>"];
        _structuredText = _structuredText regexReplace ["\[center\](.*?)\[/center\]", "<t align='center'>$1</t>"];
        _structuredText = _structuredText regexReplace ["\[left\](.*?)\[/left\]", "<t align='left'>$1</t>"];
        _structuredText = _structuredText regexReplace ["\[right\](.*?)\[/right\]", "<t align='right'>$1</t>"];
		_structuredText = _structuredText regexReplace ["\[size=([0-9.]+)\](.*?)\[/size\]", "<t size='\1'>\2"];
		_structuredText = _structuredText regexReplace ["\[i\](.*?)\[/i\]", "<t font='PuristaLight'>\1</t>"];
        _structuredTextNew = _structuredTextNew + _structuredText;
        if ("t size=" in _structuredText) then {
            _structuredTextNew = _structuredTextNew + "</t>";
        };
        _structuredTextNew = _structuredTextNew + "<br />"; 
        
    } forEach _splitString;
    _preview ctrlSetStructuredText parseText _structuredTextNew;
}] call compile_Global;

["A3PL_FilesManager_statusFile",
{
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_curSel = tvCurSel _treeCtrl;
	_data = _treeCtrl tvData _curSel;
	_data = call compile _data;

	private _job = player getVariable "job";
	private _requiredLicense = switch (_job) do {
		case ("STR_Common_FISD" call A3PL_Localize): {"fisdmdtadmin"};
		case ("STR_Common_FIFR" call A3PL_Localize): {"fifrmdtadmin"};
		case ("STR_Common_DOJ" call A3PL_Localize): {"dojmdtadmin"};
		case ("STR_Common_GOV" call A3PL_Localize): {"govmdtadmin"};
	};
	if (_job IN [("STR_Common_FISD" call A3PL_Localize), ("STR_Common_FIFR" call A3PL_Localize), ("STR_Common_DOJ" call A3PL_Localize), ("STR_Common_GOV" call A3PL_Localize)] && !(_requiredLicense IN (player getVariable ["licenses",[]]))) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPerm = [_cid, "filesmanager", _charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = [_charID] call A3PL_Config_IsCompanyBoss;
	if (_job == ("STR_Common_Company" call A3PL_Localize) && (!_isBoss || !_hasPerm)) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if ((count _data) > 4) then {
		private _fileID = _data # 0;
		private _statusfile = _data # 6;
		if (_statusfile isEqualTo 0) then {
			_statusfile = 1;
			[("STR_A3PL_FilesManager_FileProtected" call A3PL_Localize),Color_Green] call A3PL_Notification;
		} else {
			_statusfile = 0;
			[("STR_A3PL_FilesManager_FileUnprotected" call A3PL_Localize),Color_Green] call A3PL_Notification;
		};
		[_fileID,_statusfile,player] remoteExec ["Server_FilesManager_saveStatusFile",2];
	};
	closeDialog 0;
	sleep 0.1;
	[] spawn A3PL_FilesManager_Computer;
}] call compile_Global;

["A3PL_FilesManager_delete",
{
	_display = uiNamespace getVariable "A3PL_ComputerDisplay";
	_treeCtrl = _display displayCtrl 130901;
	_curSel = tvCurSel _treeCtrl;
	_data = _treeCtrl tvData _curSel;
	_data = call compile _data;

	private _job = player getVariable "job";
	private _requiredLicense = switch (_job) do {
		case ("STR_Common_FISD" call A3PL_Localize): {"fisdmdtadmin"};
		case ("STR_Common_FIFR" call A3PL_Localize): {"fifrmdtadmin"};
		case ("STR_Common_DOJ" call A3PL_Localize): {"dojmdtadmin"};
		case ("STR_Common_GOV" call A3PL_Localize): {"govmdtadmin"};
	};
	if (_job IN [("STR_Common_FISD" call A3PL_Localize), ("STR_Common_FIFR" call A3PL_Localize), ("STR_Common_DOJ" call A3PL_Localize), ("STR_Common_GOV" call A3PL_Localize)] && !(_requiredLicense IN (player getVariable ["licenses",[]]))) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPerm = [_cid, "filesmanager", _charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = [_charID] call A3PL_Config_IsCompanyBoss;
	if (_job == ("STR_Common_Company" call A3PL_Localize) && (!_isBoss || !_hasPerm)) exitWith {
		[("STR_A3PL_FilesManager_NoPermission" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _selID = _data # 0;
	private _status = 0;
	if ((count _data) > 4) then {
		_status = _data # 6;
		_status = 2;
		[("STR_A3PL_FilesManager_FileDeleted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[_selID,_status,player] remoteExec ["Server_FilesManager_saveStatusFile",2];
	} else {
		_status = _data # 4;
		_status = 1;
		[("STR_A3PL_FilesManager_FolderDeleted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[_selID,player] remoteExec ["Server_FilesManager_deleteFolder",2];
	};
	closeDialog 0;
	sleep 0.1;
	[] spawn A3PL_FilesManager_Computer;
}] call compile_Global;