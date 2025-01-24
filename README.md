# Home Assistant Add-on: PLCComS

PLCComS - Communication server implemented as Home Assistant addon.

Tested with rpi4-64.

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

## About

Communication server provide TCP/IP connection with client device and a PLC. Communication of server with client is created by simple text oriented protocol - question/answer. Server communicates with PLS optimalized by EPSNET protocol or in case of SoftPLC by shared module.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg


## Home Assistant configuration.yaml example:
```
switch:
  - platform: telnet
    switches:
      ac_bedroom:
        name: "A/C Bedroom"
        resource: 192.168.1.190 #ip of PLCcomS (Home Assistant)
        port: 5011 #port of PLCcomS (defined in addon config)
        command_on: "SET:T_ZONES_SET[0].TOPIT_TC,1\n"
        command_off: "SET:T_ZONES_SET[0].TOPIT_TC,0\n"
        command_state: "GET:T_ZONES_SET[0].TOPIT_TC\r\n"
        value_template: '{{ value == "GET:T_ZONES_SET[0].TOPIT_TC,1" }}'
        timeout: 3
```
## Configuration file `PLCComS.ini`:

Your TECO device has to be defined in **rootfs / etc / plccoms / PLCComS.ini**


## Client protocol, use putty to test:

Is simple text oriented protocol. Every line is ended new line character (DOS [\r\n] or UNIX [\n]). For testing is possible use telnet client.
```
	Commands:
    
		LIST:\n											- Get list of all variables in public file.
		SET:<variable_name,value>\n						- Set variable in PLC to requested value.
		GET:<variable_name>\n							- Get value of variable from PLC.
		EN:[variable_name] [delta]\n					- Enable variable(s) in public file and set variance delta.
		DI:[variable_name] [delta]\n					- Disable variable(s) in public file and set variance delta.
		HIDE:<variable_name>\n							- Hide variable(s) in public file.
		UNHIDE:<variable_name>\n						- Unhide variable(s) in public file.
		GETMEM:<variable_name mem_size>					- Get memory block from PLC.
		GETFILE:<file_name>\n							- Get file from PLC.
		GETFILEINFO:<file_name>\n						- Get informations about file from PLC.
		WRITEFILE:<file_name>[<block_size>]=data\n		- Write file into PLC or PC.
		WRITEFILEINFO:<file_name>[<block_size>]=data\n	- Write informations about file into PLC or PC.
		GETINFO:[name]\n								- Get informations about communication server.
			name:
				version					- Version of the communication server.
				version_epsnet			- Version of EPSNET library.
				version_ini				- Version of INI parsing library.
				version_plc				- PLC version.
				ipaddr					- IP address of PLC.
				epsaddr					- EPSNET source address.
				epsport					- EPSNET communication port.
				serial_device			- Settings of serial line.
				pubfile					- The names of actual public files.
				network					- List of connected clients.
		SETCONF:<variable_name,value>\n - Change variable listed in configuration file.
			variable_name:
				ipaddr					- IP address of PLC.
				epsaddr					- EPSNET source address (1 - 126).
				epsport					- EPSNET communication port.
				serial_device			- Name of serial line.
				serial_speed			- Communication speed for serial line.
				pubfile					- Public file.
				crlf					- End line character (yes = DOS [\r\n], no = UNIX [\n]).
				diff					- Enable or disable sending DIFF messages (yes = Enabled).
 variables (yes = Enabled).
		HELP:\n                         - Display help message.

	Answers for commands:
    
		LIST:\n
		LIST:test_1\n
		LIST:test_2\n
		LIST:\n
	
		SET:test_1,123\n
		DIFF:test_1,123\n				- DIFF is send if any variables change value.
	
		GET:test_1\n
		GET:test_1,123\n
		GET:test_string\n
		GET:test_string,"Hello!"\n

		GETFILE://www/LOGIN.XML\n
		GETFILE://www/LOGIN.XML[195]=<?xml version="1.0"
		encoding="windows-1250" ?>\n
		<?xml-stylesheet type="text/xsl" href="login.xsl"
		version="1.0"?>\n
		<LOGIN>\n
			<USER VALUE=""/>\n
			<PASS VALUE=""/>\n
        		<ACER VALUE="0"/>\n
		</LOGIN>\n
		\n
		GETFILE://www/LOGIN.XML[0]=\n

		GETFILEINFO://www/LOGIN.XML\n
		GETFILEINFO://www/LOGIN.XML[36]=195 32 59391128503405 59391128503405\n

		GETINFO:\n
        GETINFO:VERSION,Ver 5.9 May 9 2022 11:19:25
        GETINFO:VERSION_EPSNET,Ver 3.5 May 9 2022 11:19:21
        GETINFO:VERSION_INI,Ver 3.2 May 9 2022 11:19:25
        GETINFO:VERSION_PLC,CP2080I   B 2.7 2.1
        GETINFO:IPADDR,192.168.134.176
        GETINFO:EPSADDR,1
        GETINFO:EPSPORT,61682
		GETINFO:PUBFILE,2/2 [FIXED_Foxtrot.pub,//iFoxtrot.pub]
		GETINFO:NETWORK,1/128 [127.0.0.1]
		GETINFO:\n
```
Commands and variable names is not case sensitive. Is possible combine upper and lower chracters. Closing connection in telnet client is via ansi escape sequence ctrl+d.


