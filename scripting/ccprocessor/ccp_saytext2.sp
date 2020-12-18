public Action UserMessage_SayText2(UserMsg msg_id, Handle msg, const int[] players, int playersNum, bool reliable, bool init)
{
    int iIndex, MsgType;

    char 
        szName[NAME_LENGTH], 
        szMessage[MESSAGE_LENGTH];

    int clients[MAXPLAYERS+1];
    
    CopyEqualArray(players, clients, playersNum);

    iIndex = 
        (!umType) ? 
            ReadBfMessage(view_as<BfRead>(msg), MsgType, SZ(szName), SZ(szMessage)) :
            ReadProtoMessage(view_as<Protobuf>(msg), MsgType, SZ(szName), SZ(szMessage));
            
    // If a player has added colors into his nickname
    ReplaceColors(SZ(szName), true);

    // If a player has added colors into his msg
    if(!Call_IsSkipColors(MsgType, iIndex))
        ReplaceColors(SZ(szMessage), true);
    
    Call_RebuildClients(MsgType, iIndex, clients, playersNum);
    
    g_mMessage.SetValue("client", iIndex);
    g_mMessage.SetValue("type", MsgType);
    g_mMessage.SetString("name", szName);
    g_mMessage.SetString("message", szMessage);
    g_mMessage.SetArray("players", clients, playersNum);
    g_mMessage.SetValue("playersNum", playersNum);

    return Plugin_Handled;
}

public void SayText2_Completed(UserMsg msgid, bool send)
{
    static const char msgName[] = "SayText2";

    int iClient;
    if(!send || !g_mMessage.GetValue("client", iClient))
        return;
    
    char 
        szName[NAME_LENGTH],
        szMessage[MESSAGE_LENGTH],
        szBuffer[MAX_LENGTH];

    int 
        playersNum,
        messageType,
        team = GetClientTeam(iClient);
    bool alive = IsPlayerAlive(iClient);

    // g_mMessage.SetValue("client", iBackup);
    g_mMessage.GetValue("type", messageType);
    g_mMessage.GetString("name", szName, sizeof(szName));
    g_mMessage.GetString("message", szMessage, sizeof(szMessage));
    g_mMessage.GetValue("playersNum", playersNum);

    int[] clients = new int[playersNum];
    g_mMessage.GetArray("players", clients, playersNum);

    g_mMessage.Clear();

    // Not equal (just fix clients array)
    CopyEqualArray(clients, clients, playersNum);
    ChangeModeValue(clients, playersNum, "0");

    Handle uMessage;
    playersNum--;
    while(playersNum >= 0) {
        
        // do not enable debug mode....
        if(!RebuildMessage(messageType, (iClient << 3|team << 1|view_as<int>(alive)), clients[playersNum], szName, szMessage, SZ(szBuffer), msgName))
            continue;
        
        ReplaceColors(SZ(szBuffer), false);

        // hehe
        uMessage = 
            StartMessageOne(msgName, clients[playersNum], USERMSG_RELIABLE|USERMSG_BLOCKHOOKS);

        if(uMessage)
        {
            if(!umType)
            {
                BfWriteByte(uMessage, iClient);
                BfWriteByte(uMessage, true);
                BfWriteString(uMessage, szBuffer);
            }

            else
            {
                PbSetInt(uMessage, "ent_idx", iClient);
                PbSetBool(uMessage, "chat", true);
                PbSetString(uMessage, "msg_name", szBuffer);
                PbSetBool(uMessage, "textallchat", view_as<bool>(messageType));

                for(int i; i < 4; i++)
                    PbAddString(uMessage, "params", NULL_STRING);
            }
            
            EndMessage();
        }

        playersNum--;
    }

    ChangeModeValue(clients, playersNum, mode_default_value); 
}

int ReadProtoMessage(Protobuf message, int &iMsgType, char[] szSenderName, int sn_size, char[] szSenderMsg, int sm_size)
{   
    message.ReadString("msg_name", szSenderName, sn_size);
    iMsgType = GetSayTextType(szSenderName);

    message.ReadString("params", szSenderName, sn_size, 0);
    message.ReadString("params", szSenderMsg, sm_size, 1);

    return message.ReadInt("ent_idx");
}

int ReadBfMessage(BfRead message, int &iMsgType, char[] szSenderName, int sn_size, char[] szSenderMsg, int sm_size)
{
    // Sender
    int iSender = message.ReadByte();
    
    // Is chat
    message.ReadByte();
    
    // msg_name
    message.ReadString(szSenderName, sn_size);
    iMsgType = GetSayTextType(szSenderName);

    // param 0
    message.ReadString(szSenderName, sn_size);

    // param 1
    message.ReadString(szSenderMsg, sm_size);

    return iSender;   
}

int GetSayTextType(char[] szMsgPhrase)
{
    return (StrContains(szMsgPhrase, "Cstrike_Name_Change") != -1) ? eMsg_CNAME : view_as<int>(StrContains(szMsgPhrase, "_All") != -1); 
}