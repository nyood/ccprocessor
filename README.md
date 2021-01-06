<h1 align="center">Color Chat Processor</h1>
<p align="center">
    <img src="https://travis-ci.org/nyood/CCProcessor.svg?branch=ccp-3.1" />
    <img src="https://img.shields.io/github/license/nyood/ccprocessor" />
    <img src="https://img.shields.io/github/v/release/nyood/CCProcessor" />
    <img src="https://img.shields.io/badge/sourcemod-v.1.10-blue" />
    <img src="https://img.shields.io/discord/494942123548868609" />
    <img src="https://img.shields.io/github/downloads/nyood/ccprocessor/total" />
</p>

## About

### Description
The chat handler makes the hidden features of the standard in-game chat available.<br>
Its functionality and fixes for all known bugs make this handler the best of its kind.

### Real-Time Color Processing
RTCP is one of the features of the chat processor, which allows you to replace abbreviations with colors when sending a message

![RTCP](./.github/images/rtcp.gif)

To switch the default feature availability use (ConVar): `ccp_color_RTP  1/0`

### Flexible Localization
For a long time of development, it was decided to support flexible localization. <br>
This approach allows you to preserve the language affiliation and form a message in the language of the player's platform. <br>

<b>For example `ServerLang: "en"`

- What the RU-player sees <br>
![RU-Client](./.github/images/ru-client.png)

- What the EN-player sees at same time <br>
![EN-Client](./.github/images/en-client.png)

### Extended Radio
The handler also deals with the radio channel. <br>
You can edit already boring radio commands. <br>
![Radio](./.github/images/radio.png)

### And more other...

## Game support
---------
- [x] Counter-Strike: Global Offensive
- [x] Counter-Strike: Source (Open Beta)
- [x] Team Fortress 2
- [x] Left 4 Dead 2

## Requirements:
-------------
- Sourcemod 1.10 
    - [Windows](http://sourcemod.net/latest.php?os=windows&version=1.10)
    - [Linux](http://sourcemod.net/latest.php?os=linux&version=1.10)
    
## [Supported Modules](https://github.com/nyood/ccp-modules)

## License
[GNU Public License v3](https://github.com/nyood/ccprocessor/blob/main/LICENSE)
