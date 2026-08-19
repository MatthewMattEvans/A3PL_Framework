/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_FilesManager_getComputerInfo", {
	private _client = _this#0;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {
		private _query = format["SELECT * FROM fm_%1_folders WHERE status <> 1",_job];
		private _resultFolders = [_query,2,true] call Server_Database_Async;

		private _query = format["SELECT * FROM fm_%1_files WHERE status <> 2",_job];
		private _resultFiles = [_query,2,true] call Server_Database_Async;

		A3PL_ComputerResponse = [_resultFolders, _resultFiles];
		(owner _client) publicVariableClient "A3PL_ComputerResponse";
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) exitWith {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format["SELECT * FROM fm_companies_folders WHERE status <> 1 AND cid=%1",_cid];
		private _resultFolders = [_query,2,true] call Server_Database_Async;

		private _query = format["SELECT * FROM fm_companies_files WHERE status <> 2 AND cid=%1",_cid];
		private _resultFiles = [_query,2,true] call Server_Database_Async;

		private _query = format["SELECT Texture_FilesManager FROM companies WHERE id=%1",_cid];
		private _resultTexture = [_query,2,true] call Server_Database_Async;
		private _texture = if (count _resultTexture > 0) then {_resultTexture#0#0} else {""};

		A3PL_ComputerResponse = [_resultFolders, _resultFiles, _texture];
		(owner _client) publicVariableClient "A3PL_ComputerResponse";
	};
}] call compile_Server;

["Server_FilesManager_saveStatusFile", {
	private _fileID = _this#0;
	private _status = _this#1;
	private _client = _this#2;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["UPDATE fm_%1_files SET status=%3 WHERE fileID=%2",_job,_fileID,_status];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["UPDATE fm_companies_files SET status=%2 WHERE fileID=%1 AND cid=%3",_fileID,_status,_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_FilesManager_saveFilePV", {
	private _fileID = _this#0;
	private _folderID = _this#1; 
	private _fileName = _this#2 ;
	private _content = _this#3;
	private _createdAt = _this#4;
	private _updatedAt = _this#5;
	private _client = _this#6;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["UPDATE fm_%1_files SET fileName=""%2"", content=""%3"" WHERE fileID=%4",_job,_fileName,_content,_fileID];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["UPDATE fm_companies_files SET fileName=""%1"", content=""%2"" WHERE fileID=%3 AND cid=%4",_fileName,_content,_fileID,_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_FilesManager_saveFolderPV", {
	private _fileID = _this#0;
	private _fileName = _this#1;
	private _client = _this#2;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["UPDATE fm_%1_folders SET folderName=""%2"" WHERE folderID=%3",_job,_fileName,_fileID];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["UPDATE fm_companies_folders SET folderName=""%1"" WHERE folderID=%2 AND cid=%3",_fileName,_fileID,_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_FilesManager_createFilePV", {
	private _folderID = _this#0;
	private _fileName = _this#1;
	private _client = _this#2;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["INSERT INTO fm_%1_files (folderID, fileName, content) VALUES (%2, ""%3"", ""%4"");",_job,_folderID, _fileName,"Vide"];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["INSERT INTO fm_companies_files (folderID, fileName, content, cid) VALUES (%1, ""%2"", ""%3"", %4);",_folderID, _fileName,"Vide",_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_FilesManager_createFolderPV", {
	private _folderName = _this#0;
	private _folderParentID = _this#1;
	private _client = _this#2;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["INSERT INTO fm_%1_folders (folderName, folderParentID) VALUES (""%2"", %3)",_job,_folderName,_folderParentID];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["INSERT INTO fm_companies_folders (folderName, folderParentID, cid) VALUES (""%1"", %2, %3)",_folderName,_folderParentID,_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_FilesManager_deleteFolder", {
	private _folderID = _this#0;
	private _client = _this#1;
	private _job = _client getVariable "job";

	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		private _query = format ["UPDATE fm_%1_folders SET status=1 WHERE folderID=%2",_job,_folderID];
		[_query,1] spawn Server_Database_Async;
		_query = format ["UPDATE fm_%1_folders SET status=1 WHERE folderParentID=%2",_job,_folderID];
		[_query,1] spawn Server_Database_Async;
		_query = format ["UPDATE fm_%1_files SET status=2 WHERE folderID=%2",_job,_folderID];
		[_query,1] spawn Server_Database_Async;
	};

	if (_job IN [("STR_Common_Company" call A3PL_Localize)]) then {
		private _cid = [(_client getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

		private _query = format ["UPDATE fm_companies_folders SET status=1 WHERE folderID=%1 AND cid=%2",_folderID,_cid];
		[_query,1] spawn Server_Database_Async;
		_query = format ["UPDATE fm_companies_folders SET status=1 WHERE folderParentID=%1 AND cid=%2",_folderID,_cid];
		[_query,1] spawn Server_Database_Async;
		_query = format ["UPDATE fm_companies_files SET status=2 WHERE folderID=%1 AND cid=%2",_folderID,_cid];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;