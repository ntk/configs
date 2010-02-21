unit TsRemoteImport;

interface
(*
  25-7-2003
    added Function tsrGetSpeakers( IDs : PInteger; RecordCount: PInteger): Integer;
*)

{$ifdef mswindows}
Const LibName= 'TSRemote.dll';
{$endif}
{$ifdef LINUX}
Const LibName= 'libTSRemote.so.0.4';
{$endif}

const
  cCodecCelp51        = 0;
  cCodecCelp63        = 1;
  cCodecGSM148        = 2;
  cCodecGSM164        = 3;
  cCodecWindowsCELP52 = 4;

  //codec masks
  cmCelp51 = 1 shl cCodecCelp51;
  cmCelp63 = 1 shl cCodecCelp63;
  cmGSM148 = 1 shl cCodecGSM148;
  cmGSM164 = 1 shl cCodecGSM164;
  cmWindowsCELP52 = 1 shl cCodecWindowsCELP52;

  //PlayerChannelPrivileges
  pcpAdmin        = 1 shl 0;
  pcpOperator     = 1 shl 1;
  pcpAutoOperator = 1 shl 2;
  pcpVoiced       = 1 shl 3;
  pcpAutoVoice    = 1 shl 4;

  //PlayerPrivileges
  ppSuperServerAdmin = 1 shl 0;
  ppServerAdmin      = 1 shl 1;
  ppCanRegister      = 1 shl 2;
  ppRegistered       = 1 shl 3;
  ppUnregistered     = 1 shl 4;

  //player flags
  pfChannelCommander = 1 shl 0;
  pfWantVoice        = 1 shl 1;
  pfNoWhisper        = 1 shl 2;
  pfAway             = 1 shl 3;
  pfInputMuted       = 1 shl 4;
  pfOutputMuted      = 1 shl 5;
  pfRecording        = 1 shl 6;

  //channel flags
  cfRegistered   = 1 shl 0;
  cfUnregistered = 1 shl 1;
  cfModerated    = 1 shl 2;
  cfPassword     = 1 shl 3;
  cfHierarchical = 1 shl 4;
  cfDefault      = 1 shl 5;

  //ServerType Flags
  stClan       = 1 shl 0;
  stPublic     = 1 shl 1;
  stFreeware   = 1 shl 2;
  stCommercial = 1 shl 3;

  grRevoke = 0;
  grGrant  = 1;

Type

  PtsrPlayerInfo = ^TtsrPlayerInfo;
  TtsrPlayerInfo = packed record
    PlayerID  : Integer;
    ChannelID : Integer;
    NickName  : Array [0..29] of Char;
    PlayerChannelPrivileges : Integer;
    PlayerPrivileges : Integer;
    PlayerFlags : Integer;
  end;

  PtsrChannelInfo = ^TtsrChannelInfo;
  TtsrChannelInfo = packed record
    ChannelID            : Integer;
    ChannelParentID      : Integer;
    PlayerCountInChannel : Integer;
    ChannelFlags         : Integer;
    Codec                : Integer;
    Name                 : Array [0..29] of Char;
  end;

  PtsrVersion = ^TtsrVersion;
  TtsrVersion = packed record
    Major   : Integer;
    Minor   : Integer;
    Release : Integer;
    Build   : Integer;
  end;

  PtsrServerInfo = ^TtsrServerInfo;
  TtsrServerInfo = packed record
    ServerName      : Array [0..29] of Char;
    WelcomeMessage  : Array [0..255] of Char;
    ServerVMajor    : Integer;
    ServerVMinor    : Integer;
    ServerVRelease  : Integer;
    ServerVBuild    : Integer;
    ServerPlatform  : Array [0..29] of Char;
    ServerIp        : Array [0..29] of Char;
    ServerHost      : Array [0..99] of Char;
    ServerType      : Integer;
    ServerMaxUsers  : Integer;
    SupportedCodecs : Integer;
    ChannelCount    : Integer;
    PlayerCount     : Integer;
  end;

  PtsrUserInfo = ^TtsrUserInfo;
  TtsrUserInfo = packed record
    Player  : TtsrPlayerInfo;
    Channel : TtsrChannelInfo;
    ParentChannel : TtsrChannelInfo;
  end;

//##############################################################################
//#
//#  Function InitTsRemoteLibrary(TryLocal: Boolean): Integer;
//#
//#  Description:
//#    Loads and binds the TSRemote library
//#
//#  Input:
//#    TryLocal: if true, it will try to load the library from the same dir
//#              as the program location. If that fails it will fall back to
//#              the default locations.
//#
//#  Output:
//#    Result: (0=ok, -1= library already initialized,
//#             -2=error loading library
//#             -3=error during binding functions
//#
//##############################################################################
Function InitTsRemoteLibrary(TryLocal: Boolean): Integer;

//##############################################################################
//#
//#  Function CloseTsRemoteLibrary: integer
//#
//#  Description:
//#    Frees the hawkvoice library loaded by InitTsRemoteLibrary
//#
//#  Input:
//#    None
//#
//#  Output:
//#    Result: (0=ok, -1= library not initialized, -2=error during FreeLibrary
//#
//##############################################################################
Function CloseTsRemoteLibrary: Integer;

//##############################################################################
//#
//#  Procedure tsrGetLastError(pchBuffer : PChar; BufferLength: Integer)
//#
//#  Description:
//#    Get the full error message that was send with the last error
//#
//#  Input:
//#    pchBuffer: A pointer to a nulterminated string where the error message
//#               will be copied to.
//#    BufferLength: The size of pchBuffer
//#
//#  Output:
//#    None
//#
//##############################################################################
type TtsrGetLastError = Procedure (pchBuffer : PChar; BufferLength: Integer);{$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrGetLastError : TtsrGetLastError;
const fn_tsrGetLastError='tsrGetLastError';

//##############################################################################
//#
//#  Function tsrConnect(URL :Pchar): integer
//#
//#  Description:
//#    Connect the ts to a new server as described in the URL. Will disconnect
//#    if the client is currently connected. The Url is the same format as the
//#    normal starup link ("teamspeak://voice.teamspeak.org:9500" etc)
//#
//#  Input:
//#    URL: A pointer to a null terminated string containing the url for the
//#         server.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrConnect = Function (URL :Pchar): Integer;{$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrConnect : TtsrConnect;
const fn_tsrConnect='tsrConnect';

//##############################################################################
//#
//#  Function tsrDisconnect: integer
//#
//#  Description:
//#    Disconnects the client from the current server.
//#
//#  Input:
//#    None
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrDisconnect = Function: Integer;{$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrDisconnect : TtsrDisconnect;
const fn_tsrDisconnect='tsrDisconnect';

//##############################################################################
//#
//#  Function tsrQuit: integer
//#
//#  Description:
//#    Disconnect, Close and terminate the client.
//#
//#  Input:
//#    None
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrQuit = Function: Integer;{$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrQuit : TtsrQuit;
const fn_tsrQuit='tsrQuit';

//##############################################################################
//#
//#  Function tsrSwitchChannelName( ChannelName: PChar;
//#                                 ChannelPassword: PChar): Integer;
//#
//#  Description:
//#    Switch to the channel with the name "Channelname"
//#    Not that tsrSwitchChannelID is preferred.
//#
//#  Input:
//#    ChannelName: Name of the channel to switch to
//#    ChannelPassword: Password for the channel. May be nil
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrSwitchChannelName = Function( ChannelName: Pchar;
                                       ChannelPassword: PChar): Integer;
                  {$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrSwitchChannelName : TtsrSwitchChannelName;
const fn_tsrSwitchChannelName='tsrSwitchChannelName';

//##############################################################################
//#
//#  Function tsrSwitchChannelID( ChannelID : Integer;
//#                               ChannelPassword: PChar): Integer;
//#
//#  Description:
//#    Switch to the channel with the id "channelID"
//#
//#  Input:
//#    ChannelID : ID of the channel to switch to
//#    ChannelPassword: Password for the channel. May be nil
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrSwitchChannelID = Function( ChannelID: Integer;
                                     ChannelPassword: PChar): Integer;
                  {$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrSwitchChannelID : TtsrSwitchChannelID;
const fn_tsrSwitchChannelID='tsrSwitchChannelID';

//##############################################################################
//#
//#  Function tsrGetVersion( tsrVersion: PtsrVersion ): Integer;
//#
//#  Description:
//#    Get the version of the ts client
//#
//#  Input:
//#    Pointer to a TtsrVersion record
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrVersion is filled with the client version
//#
//##############################################################################
type TtsrGetVersion = Function( tsrVersion: PtsrVersion ): Integer;
                  {$ifdef linux}cdecl;{$endif}{$ifdef mswindows}stdcall;{$endif}
var tsrGetVersion : TtsrGetVersion;
const fn_tsrGetVersion='tsrGetVersion';

//##############################################################################
//#
//#  Function TtsrGetServerInfo( tsrServerInfo: PtsrServerInfo ): Integer;
//#
//#  Description:
//#    Get the Info on the server (name, channelcount, playercount etc etc)
//#
//#  Input:
//#    Pointer to a TtsrServerInfo record
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrServerInfo is filled with the server info
//#
//##############################################################################
type TtsrGetServerInfo = Function ( tsrServerInfo: PtsrServerInfo ): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetServerInfo : TtsrGetServerInfo;
Const fn_tsrGetServerInfo='tsrGetServerInfo';

//##############################################################################
//#
//#  Function tsrGetUserInfo( tsrUserInfo: PtsrUserInfo ): Integer;
//#
//#  Description:
//#    Get the Info on the user (name, channel, flags etc etc)
//#
//#  Input:
//#    Pointer to a TtsrUserInfo record
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrUserInfo is filled with the user info
//#
//##############################################################################
type TtsrGetUserInfo = Function ( tsrUserInfo: PtsrUserInfo ): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetUserInfo : TtsrGetUserInfo;
Const fn_tsrGetUserInfo='tsrGetUserInfo';

//##############################################################################
//#
//#  Function tsrGetChannelInfoByID( ChannelID: Integer;
//#         tsrChannelInfo: PtsrChannelInfo;
//#         tsrPlayerInfo : PtsrPlayerInfo; PlayerRecords : PInteger) : integer;
//#
//#  Description:
//#    Get the Info on the channel specified by ChannelID and optionally also
//#    get the users from that channel
//#
//#  Input:
//#    ChannelID: The ID of the channel you want the info from
//#    tsrChannelInfo: pointer to a TtsrChannelInfo record;
//#    tsrPlayerInfo: This is the pointer to an array of TtsrPlayerInfo records
//#                   If it is NIL, no player records will be retrieved
//#    PlayerRecords: Pointer to an integer. It must contain how many records
//#                   tsrPlayerInfo has room for. (records, not bytes)
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrChannelInfo is filled with the channel info.
//#                If tsrPlayerInfo was not NIL then the player records are
//#                filled. PlayerRecords indicates how many records were filled
//#
//##############################################################################
type TtsrGetChannelInfoByID = Function ( ChannelID: Integer; tsrChannelInfo: PtsrChannelInfo;
                                tsrPlayerInfo : PtsrPlayerInfo; PlayerRecords : PInteger) : integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetChannelInfoByID : TtsrGetChannelInfoByID;
Const fn_tsrGetChannelInfoByID='tsrGetChannelInfoByID';

//##############################################################################
//#
//#  Function tsrGetChannelInfoByName( ChannelName: PChar;
//#         tsrChannelInfo: PtsrChannelInfo;
//#         tsrPlayerInfo : PtsrPlayerInfo; PlayerRecords : PInteger) : integer;
//#
//#  Description:
//#    Get the Info on the channel specified by ChannelName and optionally also
//#    get the users from that channel
//#
//#  Input:
//#    ChannelName: The Name of the channel you want the info from
//#    tsrChannelInfo: pointer to a TtsrChannelInfo record;
//#    tsrPlayerInfo: This is the pointer to an array of TtsrPlayerInfo records
//#                   If it is NIL, no player records will be retrieved
//#    PlayerRecords: Pointer to an integer. It must contain how many records
//#                   tsrPlayerInfo has room for. (records, not bytes)
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrChannelInfo is filled with the channel info.
//#                If tsrPlayerInfo was not NIL then the player records are
//#                filled. PlayerRecords indicates how many records were filled
//#
//##############################################################################
type TtsrGetChannelInfoByName = Function ( ChannelName: PChar; tsrChannelInfo: PtsrChannelInfo;
                                tsrPlayerInfo : PtsrPlayerInfo; PlayerRecords : PInteger) : integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetChannelInfoByName : TtsrGetChannelInfoByName;
Const fn_tsrGetChannelInfoByName='tsrGetChannelInfoByName';

//##############################################################################
//#
//#  Function tsrGetPlayerInfoByID( PlayerID: Integer;
//#                                 tsrPlayerInfo : PtsrPlayerInfo): Integer;
//#
//#  Description:
//#    Get the Info on the player specified by PlayerID.
//#
//#  Input:
//#    PlayerID: The ID of the player you want the info from
//#    tsrPlayerInfo: This is the pointer to a TtsrPlayerInfo record
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrPlayerInfo is filled with the player info.
//#
//##############################################################################
type TtsrGetPlayerInfoByID = Function ( PlayerID: Integer; tsrPlayerInfo : PtsrPlayerInfo): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetPlayerInfoByID : TtsrGetPlayerInfoByID;
Const fn_tsrGetPlayerInfoByID='tsrGetPlayerInfoByID';

//##############################################################################
//#
//#  Function tsrGetPlayerInfoByName( PlayerName : Pchar
//#                                 tsrPlayerInfo : PtsrPlayerInfo): Integer;
//#
//#  Description:
//#    Get the Info on the player specified by PlayerName.
//#
//#  Input:
//#    PlayerName: The Name of the player you want the info from
//#    tsrPlayerInfo: This is the pointer to a TtsrPlayerInfo record
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrPlayerInfo is filled with the player info.
//#
//##############################################################################
type TtsrGetPlayerInfoByName = Function  ( PlayerName: Pchar; tsrPlayerInfo : PtsrPlayerInfo): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetPlayerInfoByName : TtsrGetPlayerInfoByName;
Const fn_tsrGetPlayerInfoByName='tsrGetPlayerInfoByName';

//##############################################################################
//#
//#  Function tsrGetChannels( tsrChannels : PtsrChannelInfo;
//#                           ChannelRecords: PInteger): Integer;
//#
//#  Description:
//#    Get a list of the channels on the server.
//#
//#  Input:
//#    tsrChannels: A pointer to an array of TtsrChannelInfo records
//#    ChannelRecords: pointer to a integer which specifies how many
//#                    TtsrChannelInfo records tsrChannels can hold.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrChannels is filled with the channel info.
//#              ChannelRecords will have the number or records that were filled
//#
//##############################################################################
type TtsrGetChannels = Function ( tsrChannels : PtsrChannelInfo; ChannelRecords: PInteger): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetChannels : TtsrGetChannels;
Const fn_tsrGetChannels='tsrGetChannels';

//##############################################################################
//#
//#  Function tsrGetPlayers( tsrPlayers: PtsrPlayerInfo;
//#                          PlayerRecords: PInteger): Integer;
//#
//#  Description:
//#    Get a list of the Players on the server.
//#
//#  Input:
//#    tsrPlayers: A pointer to an array of TtsrPlayerInfo records
//#    PlayerRecords: pointer to a integer which specifies how many
//#                    TtsrPlayerInfo records tsrPlayers can hold.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then tsrPlayers is filled with the Player info.
//#              PlayerRecords will have the number or records that were filled
//#
//##############################################################################
type TtsrGetPlayers = Function ( tsrPlayers: PtsrPlayerInfo; PlayerRecords: PInteger): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetPlayers : TtsrGetPlayers;
Const fn_tsrGetPlayers='tsrGetPlayers';

//##############################################################################
//#
//#  Function tsrGetSpeakers( IDs : PInteger; RecordCount: PInteger): Integer;
//#
//#  Description:
//#    Get ID list of people that are speaking now
//#
//#  Input:
//#    IDs: Buffer to hold atleast RecordCount Integers
//#    RecordCount: How much Integers IDs can hold
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#    if result = 0 then
//#                  IDs: Buffer to RecordCount* Ids of people who are talking
//#                  RecordCount: How Much people are talking
//#
//##############################################################################
Type TtsrGetSpeakers = Function ( IDs : PInteger; RecordCount: PInteger): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrGetSpeakers : TtsrGetSpeakers;
Const fn_tsrGetSpeakers='tsrGetSpeakers';

//##############################################################################
//#
//#  Function tsrSetPlayerFlags( tsrPlayerFlags : Integer ): Integer;
//#
//#  Description:
//#    Set player flags of the user
//#
//#  Input:
//#    tsrPlayerFlags: An integer wich has the bitmask for all the flags
//#                    All flags are set to this bitmask.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrSetPlayerFlags = Function ( tsrPlayerFlags : Integer ): Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSetPlayerFlags : TtsrSetPlayerFlags;
Const fn_tsrSetPlayerFlags='tsrSetPlayerFlags';

//##############################################################################
//#
//#  Function tsrSetWantVoiceReason( tsrReason: pchar ):Integer;
//#
//#  Description:
//#    set the reason you want voice on a channel
//#
//#  Input:
//#    tsrReason: The reseason for voice
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrSetWantVoiceReason = Function ( tsrReason: pchar ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSetWantVoiceReason : TtsrSetWantVoiceReason;
Const fn_tsrSetWantVoiceReason='tsrSetWantVoiceReason';

//##############################################################################
//#
//#  Function tsrSetOperator( PlayerID: Integer; GrantRevoke: Integer ):Integer;
//#
//#  Description:
//#    Grant or revoke Operator status
//#
//#  Input:
//#    PlayerID: ID of the player to set the operator status for
//#    GrantRevoke: Set to grGrant to grant or grRevoke to revoke the privilege
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrSetOperator = Function ( PlayerID: Integer; GrantRevoke: Integer ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSetOperator : TtsrSetOperator;
Const fn_tsrSetOperator='tsrSetOperator';

//##############################################################################
//#
//#  Function tsrSetVoice( PlayerID: Integer; GrantRevoke: Integer ):Integer;
//#
//#  Description:
//#    Grant or revoke Voice status
//#
//#  Input:
//#    PlayerID: ID of the player to set the Voice status for
//#    GrantRevoke: Set to grGrant to grant or grRevoke to revoke the privilege
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
Type TtsrSetVoice = Function ( PlayerID: Integer; GrantRevoke: Integer ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSetVoice : TtsrSetVoice;
Const fn_tsrSetVoice='tsrSetVoice';

//##############################################################################
//#
//#  Function tsrKickPlayerFromServer( PlayerID: Integer;
//#                                    Reason : Pchar ):Integer;
//#
//#  Description:
//#    Kick a player from the server;
//#
//#  Input:
//#    PlayerID: ID of the player to set the Voice status for
//#    Reason: The reason why he was kicked
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrKickPlayerFromServer = Function ( PlayerID: Integer; Reason : Pchar ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrKickPlayerFromServer : TtsrKickPlayerFromServer;
Const fn_tsrKickPlayerFromServer='tsrKickPlayerFromServer';

//##############################################################################
//#
//#  Function tsrKickPlayerFromChannel( PlayerID: Integer;
//#                                     Reason : Pchar ):Integer;
//#
//#  Description:
//#    Kick a player from the Channel;
//#
//#  Input:
//#    PlayerID: ID of the player to set the Voice status for
//#    Reason: The reason why he was kicked
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
type TtsrKickPlayerFromChannel = Function ( PlayerID: Integer; Reason : Pchar ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrKickPlayerFromChannel : TtsrKickPlayerFromChannel;
Const fn_tsrKickPlayerFromChannel='tsrKickPlayerFromChannel';

//##############################################################################
//#
//#  Function tsrSendTextMessageToChannel( ChannelID: Integer;
//#                                        Message : Pchar ):Integer;
//#
//#  Description:
//#    Send a text message to a channel
//#
//#  Input:
//#    ChannelID: The ID of the channel you want to send the txt message to
//#    Message : The message you want to send.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
Type TtsrSendTextMessageToChannel = Function ( ChannelID: Integer; Message : Pchar ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSendTextMessageToChannel : TtsrSendTextMessageToChannel;
Const fn_tsrSendTextMessageToChannel='tsrSendTextMessageToChannel';

//##############################################################################
//#
//#  Function tsrSendTextMessage( Message : Pchar ):Integer;
//#
//#  Description:
//#    Send a text message to everyone
//#
//#  Input:
//#    Message : The message you want to send.
//#
//#  Output:
//#    Result: 0 = OK, else the error number
//#
//##############################################################################
Type TtsrSendTextMessage = Function ( Message : Pchar ):Integer;
                 {$ifdef linux}cdecl;{$endif} {$ifdef mswindows}stdcall;{$endif}
var tsrSendTextMessage : TtsrSendTextMessage;
Const fn_tsrSendTextMessage='tsrSendTextMessage';


implementation
{$ifdef mswindows}
uses windows, SysUtils;
{$endif}
{$ifdef LINUX}
uses Libc, SysUtils;
{$endif}
Var Handle : Integer = 0;

Function GetAddress(Handle: Integer; Const FunctionName: PChar):Pointer;
begin
{$Ifdef mswindows}Result := GetProcAddress(Handle, FunctionName);{$Endif}
{$Ifdef linux}Result := dlsym(pointer(Handle), FunctionName);{$Endif};
end;

Function GetHandle( Name : Pchar ): Integer;
begin
{$ifdef mswindows}
  Result := LoadLibrary(Name);
{$endif}
{$ifdef linux}
  Result := integer(dlopen(Name,RTLD_NOW));
{$endif}
end;

Function InitTsRemoteLibrary(TryLocal: Boolean): Integer;
var
 LocalName : String;
begin
  if handle <> 0 then
  begin
    Result := -1;
    Exit;
  end;

  if TryLocal then
  begin
    LocalName := ExtractFilePath(ParamStr(0))+LibName;
    handle := GetHandle(pchar(LocalName));
    if Handle = 0 then handle := GetHandle(LibName);
  end
  else handle := GetHandle(LibName);
  if handle = 0 then
  begin
    Result := -2;
    exit;
  end;
  result := -3;

  @tsrGetLastError := GetAddress(Handle, fn_tsrGetLastError);
  if not assigned(tsrGetLastError ) then exit;
  @tsrConnect := GetAddress(Handle, fn_tsrConnect);
  if not assigned(tsrConnect) then exit;
  @tsrDisconnect := GetAddress(Handle, fn_tsrDisconnect);
  if not assigned(tsrDisconnect) then exit;
  @tsrQuit := GetAddress(Handle, fn_tsrQuit);
  if not assigned(tsrQuit) then exit;
  @tsrSwitchChannelName := GetAddress(Handle, fn_tsrSwitchChannelName);
  if not assigned(tsrSwitchChannelName) then exit;
  @tsrSwitchChannelID := GetAddress(Handle, fn_tsrSwitchChannelID);
  if not assigned(tsrSwitchChannelID ) then exit;
  @tsrGetVersion := GetAddress(Handle, fn_tsrGetVersion);
  if not assigned(tsrGetVersion) then exit;
  @tsrGetServerInfo := GetAddress(Handle, fn_tsrGetServerInfo);
  if not assigned(tsrGetServerInfo) then exit;
  @tsrGetUserInfo := GetAddress(Handle, fn_tsrGetUserInfo);
  if not assigned(tsrGetUserInfo) then exit;
  @tsrGetChannelInfoByID := GetAddress(Handle, fn_tsrGetChannelInfoByID);
  if not assigned(tsrGetChannelInfoByID) then exit;
  @tsrGetChannelInfoByName := GetAddress(Handle, fn_tsrGetChannelInfoByName);
  if not assigned(tsrGetChannelInfoByName) then exit;
  @tsrGetPlayerInfoByID := GetAddress(Handle, fn_tsrGetPlayerInfoByID);
  if not assigned(tsrGetPlayerInfoByID) then exit;
  @tsrGetPlayerInfoByName := GetAddress(Handle, fn_tsrGetPlayerInfoByName);
  if not assigned(tsrGetPlayerInfoByName) then exit;
  @tsrGetChannels := GetAddress(Handle, fn_tsrGetChannels);
  if not assigned(tsrGetChannels) then exit;
  @tsrGetPlayers := GetAddress(Handle, fn_tsrGetPlayers);
  if not assigned(tsrGetPlayers) then exit;
  @tsrGetSpeakers := GetAddress(Handle, fn_tsrGetSpeakers);
  if not assigned(tsrGetSpeakers) then exit;
  @tsrSetPlayerFlags := GetAddress(Handle, fn_tsrSetPlayerFlags);
  if not assigned(tsrSetPlayerFlags) then exit;
  @tsrSetWantVoiceReason := GetAddress(Handle, fn_tsrSetWantVoiceReason);
  if not assigned(tsrSetWantVoiceReason) then exit;
  @tsrSetOperator := GetAddress(Handle, fn_tsrSetOperator);
  if not assigned(tsrSetOperator) then exit;
  @tsrSetVoice := GetAddress(Handle, fn_tsrSetVoice);
  if not assigned(tsrSetVoice) then exit;
  @tsrKickPlayerFromServer := GetAddress(Handle, fn_tsrKickPlayerFromServer);
  if not assigned(tsrKickPlayerFromServer) then exit;
  @tsrKickPlayerFromChannel := GetAddress(Handle, fn_tsrKickPlayerFromChannel);
  if not assigned(tsrKickPlayerFromChannel) then exit;
  @tsrSendTextMessageToChannel := GetAddress(Handle, fn_tsrSendTextMessageToChannel);
  if not assigned(tsrSendTextMessageToChannel) then exit;
  @tsrSendTextMessage := GetAddress(Handle, fn_tsrSendTextMessage);
  if not assigned(tsrSendTextMessage) then exit;

  result := 0;
end;

Function CloseTsRemoteLibrary: Integer;
begin
  if handle = 0 then
  begin
    Result := -1;
    Exit;
  end;
  try
  {$ifdef mswindows}
    FreeLibrary(Handle);
  {$endif}
  {$ifdef linux}
    dlclose(pointer(Handle));
  {$endif}
    Handle := 0;
    Result := 0;
  Except
    Handle := 0;
    Result := -2;
  end;
end;

end.
