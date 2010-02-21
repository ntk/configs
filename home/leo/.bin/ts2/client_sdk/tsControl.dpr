{
This program is not meant as a fuly functional application. It is meant as a
demonstration program to show how the TsRemote DLL/so works.

Feel free to edit / use /copy / distribute this program as much as you like.

This program was created by: Niels Werensteijn  in oct 2002
}

program tsControl;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  TsRemoteImport in 'TsRemoteImport.pas';

procedure Usage;
begin
  Writeln('TeamSpeak 2 remote control');
  Writeln('');
  Writeln('Usage: tscontrol COMMAND [parameters] <optional>');
  writeln('Commands:');
  Writeln('');
  writeln('CONNECT [teamspeak_url]                             Connect to teamspeak server');
  writeln('   Example: CONNECT TeamSpeak://teamspeak.org?channelname=Channel%201');
  writeln('DISCONNECT                                      Disconnect fromteamspeak server');
  writeln('QUIT                                                            Close teamspeak');
  writeln('SWITCH_CHANNEL [channelid] <password>                         Switch to channel');
  writeln('GET_CLIENT_VERSION                                       Returns Client Version');
  writeln('GET_SERVER_INFO                                      Returns info on the Server');
  writeln('GET_USER_INFO                         Returns info on the user of the TS client');
  writeln('GET_CHANNEL_INFO [channelid]               Returns info on the selected channel');
  writeln('GET_PLAYER_INFO [playerid]                  Returns info on the selected player');
  writeln('GET_CHANNELS                                 Returns a list of all the channels');
  writeln('GET_PLAYERS                                   Returns a list of all the players');
  writeln('GET_SPEAKERS                         Returns a list of all the current speakers');
  writeln('MUTE / UNMUTE                                    Mutes or unmutes your speakers');
  writeln('SET_OPERATOR [playerid] [GRANT/REVOKE] GRANT / REVOKE operator status to player');
  writeln('SET_VOICE [playerid] [GRANT/REVOKE]       GRANT / REVOKE Voice status to player');
  writeln('KICK_PLAYER_CHANNEL [playerid] <reason>          Kick a player from the channel');
  writeln('KICK_PLAYER_SERVER [playerid] <reason>            Kick a player from the server');
  writeln('SEND_MESSAGE_CHANNEL [channelid] [message]    Sends a text message to a channel');
  writeln('SEND_MESSAGE [message]                    Sends a text message to every channel');
end;

Function DisplayResult( Res: Integer ) : Boolean;
Var
  ErrorMessage: array[0..1023] of Char;
begin
  if res=0 then
  begin
    Writeln('OK');
    Result := True;
  end
  else
  begin
    tsrGetLastError(@ErrorMessage, SizeOf(ErrorMessage));
    Writeln(ErrorMessage);
    Result := False;
  end;
end;

Function GetInteger(Var Params: String; var ID: Integer) :Boolean;
var
  e, P : integer;
begin
  P := Pos(#32,Params);
  if p=0 then p := Length(params) + 1;
  Val(Copy(Params,1,p-1), ID, e);
  if e <> 0 then
  begin
    writeln('ERROR -1004 PARAM IS NOT VALID INTEGER');
    Result := False;
    exit;
  end;
  Params := Copy(Params, P+1, Length(Params));
  Result := True;
end;

Function GetGrantRevoke(Var Params: String; var Gr: Integer) :Boolean;
var
  P : integer;
  V : String;
begin
  P := Pos(#32,Params);
  if p=0 then p := Length(params) + 1;
  V := UpperCase(Copy(Params,1,p-1));
  if (V = 'GRANT') then gr := grGrant else
  if (V = 'REVOKE') then gr := grRevoke else
  begin
    writeln('ERROR -1010 PARAM IS NOT "GRANT" or "REVOKE"');
    Result := False;
    exit;
  end;
  Params := Copy(Params, P+1, Length(Params));
  Result := True;
end;

procedure DisplayPlayerInfo(Const PlayerInfo: TtsrPlayerInfo );
begin
  with PlayerInfo Do
  writeln(Format('ID: %d  Channel: %d  Nick: %s  ChannelPrivs: 0x%2.2x  Privs: 0x%2.2x  Flags: 0x%2.2x',
    [PlayerID, ChannelID, NickName, PlayerChannelPrivileges,
     PlayerPrivileges, PlayerFlags] ));
end;

procedure DisplayDetailedPlayerInfo(Const PlayerInfo: TtsrPlayerInfo );
var
  CPrivs, Privs, Flags : String;
begin
 with PlayerInfo Do
 begin
  writeln(Format('ID: %d  Channel: %d  Nick: %s ',[PlayerID, ChannelID, NickName]));

  CPrivs :='';
  if (PlayerChannelPrivileges and pcpAdmin        <>0) then Cprivs :='Admin,';
  if (PlayerChannelPrivileges and pcpOperator     <>0) then Cprivs := Cprivs + 'Operator,';
  if (PlayerChannelPrivileges and pcpAutoOperator <>0) then Cprivs := Cprivs + 'Auto-Operator,';
  if (PlayerChannelPrivileges and pcpVoiced       <>0) then Cprivs := Cprivs + 'Voice,';
  if (PlayerChannelPrivileges and pcpAutoVoice    <>0) then Cprivs := Cprivs + 'Auto-Voice,';
  if Cprivs <> ''
      then SetLength( Cprivs, Length( Cprivs )-1 )
      else CPrivs := 'none';

  Privs := '';
  if ( PlayerPrivileges and ppSuperServerAdmin <> 0) then Privs :='SuperServerAdmin,';
  if ( PlayerPrivileges and ppServerAdmin <> 0) then Privs := Privs + 'ServerAdmin,';
  if ( PlayerPrivileges and ppCanRegister <> 0) then Privs := Privs + 'CanRegister,';
  if ( PlayerPrivileges and ppRegistered <> 0)
     then Privs := Privs + 'Registered'
     else Privs := Privs + 'Unregistered';

  Flags := '';
  if (PlayerFlags and pfChannelCommander <>0) then Flags :='ChannelCommander,' ;
  if (PlayerFlags and pfWantVoice <>0) then Flags :='WantVoice,' ;
  if (PlayerFlags and pfNoWhisper <>0) then Flags :='NoWhisper,' ;
  if (PlayerFlags and pfAway <>0) then Flags :='Away,' ;
  if (PlayerFlags and pfInputMuted <>0) then Flags :='InputMuted,' ;
  if (PlayerFlags and pfOutputMuted <>0) then Flags :='OutputMuted,' ;
  if (PlayerFlags and pfRecording <>0) then Flags :='Recording,' ;
  if Flags <> ''
      then SetLength( Flags, Length( Flags )-1 )
      else Flags := 'none';

  writeln(Format('ChannelPrivs: 0x%2.2x(%s)  Privs: 0x%2.2x(%s)  Flags: 0x%2.2x(%s)',
    [ PlayerChannelPrivileges,CPrivs, PlayerPrivileges, Privs, PlayerFlags, Flags] ));
 end;
end;

procedure DisplayChannelInfo(Const ChannelInfo: TtsrChannelInfo );
begin
  with channelInfo do
  writeln(Format('ID: %d  Parent: %d  Name: %s  Playercount: %d  Flags: 0x%2.2x  Codec: %d',
    [ChannelID, ChannelParentID, Name, PlayerCountInChannel, ChannelFlags, Codec]));
end;

procedure DoConnect(Const URL : String);
begin
  DisplayResult( tsrConnect(Pchar(URL)) );
End;

procedure DoDisconnect;
begin
  DisplayResult( tsrDisconnect);
End;

procedure DoQuit;
begin
  DisplayResult( tsrQuit );
End;

procedure DoSwitchChannel(Params : String);
var
  ID: integer;
  Password : PChar;
begin
  if Not getInteger(Params, ID) then exit;

  if Params ='' then Password := nil else password := Pchar(Params);
  DisplayResult( tsrSwitchChannelID(ID, Password) );
end;

procedure DoGetVersion;
var
  VersionInfo : TtsrVersion;
begin
  if not DisplayResult( tsrGetversion(@VersionInfo) ) then exit;
  with VersionInfo do
  writeln(format('Version: %d.%d.%d.%d',[ Major, Minor, Release, Build]));
End;

Procedure DoGetServerInfo;
var
  ServerInfo: TtsrServerInfo;
  St, Sc : String;
begin
  if not DisplayResult( tsrGetServerInfo(@ServerInfo) ) then exit;
  with ServerInfo do
  begin
    writeln(format('Servername: %s',[Servername]));
    writeln(format('Welcome Message: %s',[WelcomeMessage]));
    writeln(format('Version: %d.%d.%d.%d',[ServerVMajor, ServerVMinor,
                                           ServerVRelease, ServerVBuild]));
    writeln(format('Platform: %s',[ServerPlatform]));
    writeln(format('IP: %s',[ServerIp]));
    writeln(format('Host: %s',[ServerHost]));
    writeln(format('Max Users: %d',[ServerMaxUsers]));
    writeln(format('Current User Count: %d',[PlayerCount]));
    writeln(format('Current Channel Count: %d',[ChannelCount]));

    ST := '';
    If (ServerType and stFreeware <> 0) then ST := 'Freeware ';
    If (ServerType and stCommercial <> 0) then ST := 'Commercial ';
    If (ServerType and stClan <> 0) then ST := ST +'Clan server';
    If (ServerType and stPublic <> 0) then ST := ST +'Public Server';
    writeln(format('Server Type: %s',[ST]));

    SC := '';
    if (cmCelp51 and SupportedCodecs <> 0) then SC := 'Celp 5.1, ';
    if (cmCelp63 and SupportedCodecs <> 0) then SC := SC + 'Celp 6.3, ';
    if (cmGSM148 and SupportedCodecs <> 0) then SC := SC + 'GSM 14.8, ';
    if (cmGSM164 and SupportedCodecs <> 0) then SC := SC + 'GSM 16.4, ';
    if (cmWindowsCELP52 and SupportedCodecs <> 0) then SC := SC + 'WCELP 5.2, ';
    If SC <> '' then SetLength(SC, Length(SC)-2);
    writeln(format('Supported codecs: %s',[SC]));
  end;
end;

procedure DoGetUserInfo;
var
  UserInfo: TtsrUserInfo;
begin
  if not DisplayResult( tsrGetUserInfo(@UserInfo) ) then exit;
  Writeln('User: ');
  DisplayDetailedPlayerInfo(UserInfo.Player);
  Writeln('Channel: ');
  DisplayChannelInfo(Userinfo.Channel);
  if UserInfo.Channel.ChannelParentID <> -1 then
  begin
    Writeln('Parent Channel: ');
    DisplayChannelInfo(Userinfo.ParentChannel);
  end;
end;

procedure DoGetChannelInfo(Params: String);
var
  ChannelInfo : TtsrChannelInfo;
  PlayersInfo : Array[0..1023] of TtsrPlayerInfo;
  Records : Integer;
  ID, I: integer;
begin
  if Not getInteger(Params, ID) then exit;
  Records := 1024;
  if not DisplayResult( tsrGetChannelInfoById(ID,@ChannelInfo,@playersInfo,@Records) ) then exit;
  Writeln('Channel:');
  DisplayChannelInfo(ChannelInfo);
  Writeln(format('Users: (count %d)',[Records]));
  if Records > 0 then
  For I:= 0 to records-1 do DisplayPlayerInfo(PlayersInfo[I]);
end;

Procedure DoGetPlayerInfo(Params : String);
var
  PlayerInfo : TtsrPlayerInfo;
  ID: integer;
begin
  if Not getInteger(Params, ID) then exit;
  if not DisplayResult( tsrGetPlayerInfoById(ID,@playerInfo) ) then exit;
  DisplayDetailedPlayerInfo(playerInfo);
end;

Procedure DoGetChannels;
var
  ChannelsInfo : Array[0..1023] of TtsrChannelInfo;
  Records : Integer;
  I: integer;
begin
  Records := 1024;
  if not DisplayResult( tsrGetChannels(@ChannelsInfo, @records) ) then exit;
  Writeln('ChannelCount: ',Records);
  if Records > 0 then
  for I :=0 to Records-1 do DisplayChannelInfo(ChannelsInfo[I]);
end;

procedure DoGetPlayers;
var
  PlayersInfo : Array[0..1023] of TtsrPlayerInfo;
  Records : Integer;
  I: integer;
begin
  Records := 1024;
  if not DisplayResult( tsrGetPlayers(@playersInfo, @records) ) then exit;
  Writeln('PlayerCount: ',Records);
  if Records > 0 then
  for I :=0 to Records-1 do DisplayPlayerInfo(PlayersInfo[I]);
end;

procedure DoGetSpeakers;
var
  IDs : Array[0..1023] of Integer;
  Records : Integer;
  I: integer;
begin
  Records := 1024;
  if not DisplayResult( tsrGetSpeakers( @IDs, @records) ) then exit;
  Writeln('SpeakerCount: ',Records);
  if Records > 0 then
  for I :=0 to Records-1 do writeln(IDs[I]);
end;

procedure DoMute( Mute: Boolean);
var
  UserInfo: TtsrUserInfo;
  Res : Integer;
begin
  Res := tsrGetUserInfo(@UserInfo);
  if res <> 0 then if not DisplayResult( res ) then exit;
  If mute
    then UserInfo.Player.PlayerFlags := UserInfo.Player.PlayerFlags or (pfInputMuted or pfOutputMuted)
    else UserInfo.Player.PlayerFlags := UserInfo.Player.PlayerFlags and Not (pfInputMuted or pfOutputMuted);
  if not DisplayResult( tsrSetPlayerFlags(UserInfo.Player.PlayerFlags)) then exit;
end;

Procedure DoSetOperator( Params : String);
var
  ID : Integer;
  gr : Integer;
begin
  if Not getInteger(Params, ID) then exit;
  If not GetGrantRevoke(Params, gr) then exit;
  if not DisplayResult( tsrSetOperator(ID, gr)) Then Exit;
end;

Procedure DoSetVoice( Params : String);
var
  ID : Integer;
  gr : Integer;
begin
  if Not getInteger(Params, ID) then exit;
  If not GetGrantRevoke(Params, gr) then exit;
  if not DisplayResult( tsrSetVoice(ID, gr)) then Exit;
end;

procedure DoKickPlayerChannel(Params: String);
var
  ID : Integer;
begin
  if Not getInteger(Params, ID) then exit;
  if not DisplayResult( tsrKickPlayerFromChannel(ID, pchar(Params))) then Exit;
end;

procedure DoKickPlayerServer(Params: String);
var
  ID : Integer;
begin
  if Not getInteger(Params, ID) then exit;
  if not DisplayResult( tsrKickPlayerFromServer(ID, pchar(Params))) then Exit;
end;

procedure DoSendMessageChannel(Params: String);
var
  ID : Integer;
begin
  if Not getInteger(Params, ID) then exit;
  if not DisplayResult( tsrSendTextMessageToChannel(ID, pchar(Params))) then Exit;
end;

procedure DoSendMessage(Params: String);
begin
  if not DisplayResult( tsrSendTextMessage(pchar(Params))) then Exit;
end;

var
  Ins, Command : String;
  I, Res : Integer;
begin
  Res := InitTsRemoteLibrary(true);
  If Res <> 0 then
  begin
    Writeln('Error ',res,' during initialisation of the TsRemote Library');
    halt(-Res);
  end;

  if (paramCount=0) or ((paramCount=1) and ( (upperCase(paramstr(1))='-H') or (upperCase(paramstr(1))='--HELP')))
  then usage else
  begin
    Command := upperCase(ParamStr(1));
    if ParamCount > 1
      then Ins:= ParamStr(2)
      else Ins := '';
    if ParamCount > 2 then
    For I := 3 to ParamCount Do ins := Ins+' '+ParamStr(I);
    If Command='CONNECT' then doConnect(Ins) else
    If Command='DISCONNECT' then doDisconnect else
    If Command='QUIT' then doQuit else
    If Command='SWITCH_CHANNEL' then DoSwitchChannel(Ins) else
    If Command='GET_CLIENT_VERSION' then doGetVersion else
    If Command='GET_SERVER_INFO' then doGetServerInfo else
    If Command='GET_USER_INFO' then doGetUserInfo else
    If Command='GET_CHANNEL_INFO' then DoGetChannelInfo(Ins) else
    If Command='GET_PLAYER_INFO' then DoGetPlayerInfo(Ins) else
    If Command='GET_CHANNELS' then DoGetChannels else
    If Command='GET_PLAYERS' then DoGetPlayers else
    If Command='GET_SPEAKERS' then DoGetSpeakers else
    If Command='MUTE' then DoMute(True) else
    If Command='UNMUTE' then DoMute(False) else
    If Command='SET_OPERATOR' then DoSetOperator(ins) else
    If Command='SET_VOICE' then DoSetVoice(ins) else
    If Command='KICK_PLAYER_CHANNEL' then DoKickPlayerChannel(ins) else
    If Command='KICK_PLAYER_SERVER' then DoKickPlayerServer(ins) else
    If Command='SEND_MESSAGE_CHANNEL' then DoSendMessageChannel(ins) else
    If Command='SEND_MESSAGE' then DoSendMessage(ins) else
    Usage;
  end;

  CloseTsRemoteLibrary;
end.
