-- Some portions of this code are Copyright ThuGie. You can do whatever you want with them.
-- Some portions of this code are Copyright Alexander Harkness 2013. Rights are granted under the MIT license.

--Globals

PLUGIN = {}
LOGPREFIX = {}
local isAuth = {}
local authName = {}
local pluginCallList = {}
local rndGuest

-- Code Start

function Initialize( Plugin )

	-- Plugin Initialization

	PLUGIN = Plugin
	
	Plugin:SetName( "tAuthentication" )
	Plugin:SetVersion( 2 )

	-- Setting Log Prefix

	LOGPREFIX = "["..Plugin:GetName().."] "

	-- Hooks

	PluginManager = cRoot:Get():GetPluginManager()
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_LOGIN)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_JOINED)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_DISCONNECT)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_PLACING_BLOCK)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_BREAKING_BLOCK)
	PluginManager:AddHook(Plugin, cPluginManager.HOOK_TAKE_DAMAGE)
	PluginManager:AddHook( Plugin, cPluginManager.HOOK_PLAYER_SPAWNED )

	-- Commands

	Plugin:AddCommand("/register", " - Register your account", "auth.register")
	Plugin:AddCommand("/login", " - Logs you into your account", "auth.login")
	Plugin:AddCommand("/changepass", " - Change your account password", "auth.change")
	Plugin:AddCommand("/auth language", "Change your language", "beartrans.language")
	Plugin:BindCommand( "/register", "auth.register", authRegister )
	Plugin:BindCommand( "/login", "auth.login", authLogin )

	-- Start up language system

	InitTranslations()

	-- Other Stuff

	rndGuest = math.random(100,500)

	LOG( LOGPREFIX .. "Initialized Plugin v." .. Plugin:GetVersion() )
	return true

end

function addPlugin( PluginName )
	table.insert( pluginCallList, PluginName )
end

function authRegister( Split, Player )

	local playerName = Player:GetName()
	local IniFile = cIniFile(PLUGIN:GetLocalDirectory() .. "/users.ini")

	if(#Split < 2) then

		Player:SendMessage( GetTranslation(0, playerName, 1) )

	elseif(isAuth[authName[playerName]] == true) then

		Player:SendMessage( GetTranslation(0, playerName, 2) )

	else

		IniFile:ReadFile()

		local password = IniFile:GetValueSet(authName[Player:GetName()], "password", "" )

		if(password == "") then

			IniFile:SetValue(authName[Player:GetName()], "password", md5(Split[2]) ,false)
			IniFile:WriteFile()
			Player:SendMessage( GetTranslation(0, playerName, 3) )

		else

			Player:SendMessage( GetTranslation(0, playerName, 4) )

		end

	end

	return true
end

function authLogin( Split, Player )

	local playerName = Player:GetName()
	local IniFile = cIniFile(PLUGIN:GetLocalDirectory() .. "/users.ini")

	if(#Split < 2) then

		Player:SendMessage( GetTranslation(0, playerName, 5) )

	elseif(isAuth[authName[Player:GetName()]] == true) then

		Player:SendMessage( GetTranslation(0, playerName, 2) )

	else

		IniFile:ReadFile()
		local password = IniFile:GetValueSet(authName[playerName], "password", "" )

		if(password == "") then

			Player:SendMessage( GetTranslation(0, playerName, 6) )

		elseif(password == md5(Split[2])) then

			Player:SetName(authName[playerName])
			isAuth[playerName] = true
			Player:LoadPermissionsFromDisk()
			Player:SendMessage( GetTranslation(0, playerName, 7) )

			function callPlugins(_index)

				local addPlugin = PluginManager:GetPlugin( pluginCallList[_index] )
				addPlugin:Call("PlayerAuthenticated", Player )
				end

			table.foreach( pluginCallList, callPlugins )

		else

			Player:SendMessage( GetTranslation(0, playerName, 8) )

		end

	end

	return true

end

function OnDisconnect( Player, Reason )
    isAuth[Player:GetName()] = false
end

function OnLogin(Client, ProtocolVersion, Username)

	local skipAuth = false

	--local ClientHandle = Player:GetClientHandle()

	local loopPlayers = function( PlayerNew )

		if(PlayerNew:GetName() == Username) then

			PlayerNew:SendMessage( GetTranslation(0, Username, 9) )
			Client:Kick( GetTranslation(0, Username, 10) )
			skipAuth=true

		end

	end

	local loopWorlds = function ( World )
		World:ForEachPlayer( loopPlayers )
	end

	cRoot:Get():ForEachWorld( loopWorlds )

	if ( skipAuth == false ) then

		isAuth[Username] = false
		rndGuest = rndGuest + 1
		authName["Guest" .. rndGuest] = Username
		Client:SetUsername("Guest" .. rndGuest)

	end

	return false

end

function OnPlayerSpawned( Player )

end

function OnPlayerJoined( Player )

	--if(isAuth[Player:GetName()] == false) then
	Player:RemoveFromGroup("Default")
	Player:AddToGroup("Guest")
	--end
	return false

end

function OnTakeDamage( Pawn, TDI )

	--if not (isAuth[Pawn:GetName()]) then
		--TDI.Damage = 0
	--else
		--return false
	--end

end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, OldBlockType, OldBlockMeta)

	local playerName = Player:GetName()

	if (isAuth[playerName]) then

		return false

	else

		Player:SendMessage( GetTranslation(0, playerName, 11) )
		return true

	end

end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, cx, cy, cz, oldblock, meta)

	local playerName = Player:GetName()

	if (isAuth[playerName]) then

		return false

	else

		Player:SendMessage( GetTranslation(0, playerName, 12) )
		return true

	end

end

function OnDisable()

	-- Disabling Plugin

	local loopPlayers = function( Player )

		local ClientHandle = Player:GetClientHandle()
		ClientHandle:Kick( GetTranslation(0, Player:GetName(), 13) )

	end

	local loopWorlds = function ( World )
		World:ForEachPlayer( loopPlayers )
	end

	cRoot:Get():ForEachWorld( loopWorlds )

	LOG( LOGPREFIX.."Plugin disabled." )

end
