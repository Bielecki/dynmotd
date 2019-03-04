#!/bin/bash

#
# Dynamic MOTD file written by Bielecki
# Based on Parker Samp dynmotd (his version and site are not available anymore)
VERSION="0.4.2"
LASTUPDATE="24.06.2017"
#
# Changelog
# v0.4.2    - Added timeout to curl, fixed changing colors in --config.
# v0.4.1    - fixed installing as root - chown'ing config directory into user account during installation.
# v0.4.0    - Multilanguage, colorful update! Customisable lang file and colors.
# v0.3.1    - DynMOTD can now install himself into system; some fixes
# v0.3.0    - introduced external .conf file, added reconfiguration and install scripts, added addictional parameters, maked simple man page
# v0.2.4    - simplified changing to alternative memory reading
# v0.2.3    - alternative total memory reading added; fixed Figlet params; Figlet now can be disabled; cleaned code a bit
# v0.2.2    - logo changed to dynamic - introduced Figlet; fixed displaying user IP on some systems
# v0.2.1    - some fixes
# v0.2.0    - dynmotd almost rewritten - fully changed structure; added dynmotd customisation
# v0.1.1, newer    - more infos
# v0.1.0    - introduced reading infos from system, dynmotd is real dynamic now
# v0.0.1    - original Parker Samp dynmotd
#

#
# Dependencies - if something's not working, try to install following packages:
# - curl - necessary to retrieve external server IP
# - geoip-bin - necessary to trace user location
# - geoip-database - as above
# - figlet - necessary to display fancy text of your choice as logo
#
# # # # # # # # # # # # # # # # # # Colors # # # # # # # # # # # # # # # # # #
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'

DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTMAGENTA='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

ERRORCOLOR='\033[0;31m\033[4m'
NORMAL='\033[0m'
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
userhome=$(eval echo ~$SUDO_USER)
DYNFOLDERconf=$(printf "%s/.dynmotd/dynconf.conf" "$userhome")
DYNFOLDER=$(printf "%s/.dynmotd" "$userhome")
if [[ -s "$DYNFOLDERconf" ]]
    then
        . "$DYNFOLDERconf"
    else
        TIMEZONE="UTC"
        MAINTFILE=""
        ALTERNATEMEMORY="false"
        FIGFONT="big"
        FIGTEXT="DynMOTD"
        FIGPARAM=""
        LANGUAGE="en_US"
        COLOR_FRAME="$MAGENTA"
        COLOR_DESC="$LIGHTCYAN"
        COLOR_EQUAL="$MAGENTA"
        COLOR_OUTPUT="$LIGHTGREEN"
        COLOR_FIGLET="$LIGHTGREEN"
        COLOR_TITLE="$YELLOW"
        COLOR_MAINTFILE="$YELLOW"
        LINE_CHARACTER="+"
fi
if [[ -s "$DYNFOLDER/$LANGUAGE.lang" ]]
    then
        . "$DYNFOLDER/$LANGUAGE.lang"
    else
        LANG_ABORT="abort configuration"
        LANG_ABORTED="Aborted reconfiguration!"
        LANG_ABORTEDCONFINSTALL="Aborted config installation"
        LANG_ALTERNATEMEM="AlternateMem"
        LANG_ANSWERYN="Please answer y/n!"
        LANG_AVAILABLEOPTIONS="Available options"
        LANG_BACK="back"
        LANG_COLORS="Customise colors"
        LANG_COLORSDESC="Customise DynMOTD colors"
        LANG_COLORPART="This is a color configuration part!"
        LANG_CONFFILEEXISTS="Configuration file already exists! Do you want to reset it?"
        LANG_CPU="CPU"
        LANG_CREATINGCONFIG="Creating default config in"
        LANG_CURLNOTINSTALLED="curl not installed"
	LANG_CURLTIMEOUT="Timed out"
        LANG_CUSTOMISEDESIGN="customise design"
        LANG_DATE="Date"
        LANG_DEFAULTSETTINGS="Using default settings. Install DynMOTD using dynmotd --install"
        LANG_DESIGN="Design"
        LANG_DESIGNPART="You are in design part."
        LANG_DISABLINGPAMMOTD="Disabling pam_motd in"
        LANG_DISABLINGSSHDMOTD="Disabling PrintMotd in"
        LANG_DONE="DONE!"
        LANG_ENABLINGDYNMOTD="Enabling DynMOTD in"
        LANG_ENTER_COLOR_DESC="Enter color name for description"
        LANG_ENTER_COLOR_EQUAL="Enter color name for equal char"
        LANG_ENTER_COLOR_FIGLET="Enter color name for logo"
        LANG_ENTER_COLOR_FRAME="Enter color name for frame"
        LANG_ENTER_COLOR_MAINTFILE="Enter color name for maintfile"
        LANG_ENTER_COLOR_OUTPUT="Enter color name for output"
        LANG_ENTER_COLOR_TITLE="Enter color name for title"
        LANG_ENTER_FRAMECHARACTER="Enter character to use as frame"
        LANG_ENTEREDCONFIG="You have entered into config!"
        LANG_ENTERFIGFONT="Enter your font name (case sensitive!)"
        LANG_ENTERFIGPARAMS="Enter parameters to be passed to Figlet (with '-' included)"
        LANG_ENTERFIGTEXT="Enter text you want to be displayed"
        LANG_ENTERLANGFILE="Enter language code - file with that code must exist in "
        LANG_ENTERMAINTFILE="Enter your maintfile full path location"
        LANG_ENTERTIMEZONE="Enter your timezone in correct syntax"
        LANG_ERROROCCURED="Error occurred! Aborting!"
        LANG_EXIT="exit"
        LANG_EXITED="Exited reconfiguration!"
        LANG_FAILED="FAIL!"
        LANG_FIGLETPART="You are in logo config part. You can now configure"
        LANG_FONT="Font"
        LANG_HELP_CONFIG="allows you to reconfigure dynmotd"
        LANG_HELP_CREATECONFIG="makes configuration file"
        LANG_HELP_HELP="display help and exit"
        LANG_HELP_INSTALL="fully installs DynMOTD into system. Run it as root. Be careful with that!"
        LANG_HELP_VERSION="show version and exit"
        LANG_HOSTNAME="Hostname"
        LANG_INCORRECT_CHAR="OH MY GOD, THIS IS THE ONLY CHAR THAT YOU CANNOT SELECT AND YOU JUST SELECTED IT ;_; NOPE, SORRY, SELECT ANY OTHER CHAR..."
        LANG_INCORRECT_COLOR="No such color. Try again!"
        LANG_INCORRECTCHOICE="Incorrect choice!"
        LANG_INSTALLCOMPLETED="Installation completed!"
        LANG_IP="IP"
        LANG_IPV4="IPv4"
        LANG_IPV6="IPv6"
        LANG_KERNEL="Kernel"
        LANG_LANGDESC="Select language code - current is"
        LANG_LASTUPDATED="last updated"
        LANG_LOCATION="Location"
        LANG_LOGGEDAS="logged in as"
        LANG_LOGO="Logo"
        LANG_LOGOSETNOFIGLET="Logo is set, but Figlet is not installed"
        LANG_LOGOSETTINGS="configure figlet logo settings"
        LANG_MAINTFILE="MaintFile"
        LANG_MAINTFILEEMPTY="Maintenance file is empty. I think everything's okay then."
        LANG_MAINTFILENOTSET="Maintenance file is not set, but everything should be okay."
        LANG_MAINTINFO="Maintenance information"
        LANG_MAKEDCONFFILE="Maked configuration file!"
        LANG_MEMORY="Memory"
        LANG_MEMPART1="Unused"
        LANG_MEMPART2="of total"
        LANG_MISC="Misc"
        LANG_MISCPART="You have selected misc part. You can now configure"
        LANG_MOVINGDYNMOTD="Moving dynmotd to"
        LANG_MOVINGLANGFILE="Moving language file to"
        LANG_MOVINGMANPAGE="Moving dynmotd manpage to"
        LANG_NOCONFIG1="There is no config file! Use"
        LANG_NOCONFIG2="first!"
        LANG_NOCURL="You don't have curl installed. Do you want me to install it?"
        LANG_NOFIGLET="You don't have Figlet installed. Do you want me to install it?"
        LANG_NOGEOIP="You don't have geoip installed. Do you want me to install it?"
        LANG_NOMAINTFILE="There is no maintenance file, so I suppose everything's okay."
        LANG_NOTROOT="Installation has to be runned as root!"
        LANG_OR="or"
        LANG_OF="of"
        LANG_PARAMS="Parameters"
        LANG_PARTSELECTION="Which part do you want to configure?"
        LANG_PROCESSES="Processes"
        LANG_RESTARTINGSSHSERVICE="Restarting SSH service"
        LANG_RETURNPARTSEL="return to part selecting"
        LANG_RETURNTODESIGNPART="return to design part"
        LANG_SELECT_CHAR="Character"
        LANG_SELECT_CHAR_DESC="select character you want to use as frame"
        LANG_SELECT_COLOR_DESC="Description"
        LANG_SELECT_COLOR_DESC_DESC="select descriptions colors"
        LANG_SELECT_COLOR_EQUAL="Equal char"
        LANG_SELECT_COLOR_EQUAL_DESC="select equal char color"
        LANG_SELECT_COLOR_FIGLET="Figlet"
        LANG_SELECT_COLOR_FIGLET_DESC="select logo color"
        LANG_SELECT_COLOR_FRAME="Frame"
        LANG_SELECT_COLOR_FRAME_DESC="select frame color"
        LANG_SELECT_COLOR_MAINTFILE="Maintfile"
        LANG_SELECT_COLOR_MAINTFILE_DESC="select maintfile output color"
        LANG_SELECT_COLOR_OUTPUT="Output"
        LANG_SELECT_COLOR_OUTPUT_DESC="select output color (after equal char)"
        LANG_SELECT_COLOR_TITLE="Title"
        LANG_SELECT_COLOR_TITLE_DESC="select titles color (user data, etc.)"
        LANG_SELECTLANG="Select language"
        LANG_SELECTOPTION="Which option do you want to configure?"
        LANG_SESSIONS="Sessions"
        LANG_SETALERNATEMEM="set to true if you want to use alternative memory reading method - current is"
        LANG_SETFONT="set font you want to use. Case sensitive! - current is"
        LANG_SETMAINTFILE="set maintfile location - current is"
        LANG_SETMISC="set timezone, maintfile location or AlternateMemory(Read) usage"
        LANG_SETPARAMS="set additional parameters to use with Figlet"
        LANG_SETTEXT="set text you want to be displayed - current is"
        LANG_SETTIMEZONE="set timezone you want to use - current is"
        LANG_SYSTEMDATA="System data"
        LANG_TEXT="Text"
        LANG_TIMEZONE="Timezone"
        LANG_UNAVAILABLE="Unavailable"
        LANG_UPTIME="Uptime"
        LANG_USAGE="Usage: dynmotd [option]"
        LANG_USEALTMEMORY="Use alternate memory?"
        LANG_USERDATA="User data"
        LANG_USERNAME="Username"
        LANG_WRONGOPTION="Unrecognised option!"
        LANG_YOUCANCONFIGURE="You can configure the following settings"
fi
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
DYNLOGO="$LIGHTCYAN[DynMOTD]"

function abort
{
        tput rmcup
        printf "$DYNLOGO $LIGHTRED%s $NORMAL \n" "$LANG_ABORTED"
        exit 1
}
function quit
{
    tput rmcup
    printf "$DYNLOGO $YELLOW%s $NORMAL \n" "$LANG_EXITED"
    exit 1
}
function config_misc_timezone
{
    printf "%s:  $NORMAL" "$LANG_ENTERTIMEZONE"
    read -r sel
        tput smcup
    sel="\'$sel\'"
    sed -i "/TIMEZONE/ s#.*#TIMEZONE=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
    config_misc
}
function config_misc_maintfile
{
        printf "%s:  $NORMAL" "$LANG_ENTERMAINTFILE"
        read -r sel
        tput smcup
        sel="\'$sel\'"
        sed -i "/^MAINTFILE/ s#.*#MAINTFILE=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_misc
}
function config_misc_alternatemem
{
    printf "%s (y/n)?  $NORMAL" "$LANG_USEALTMEMORY"
    read -r yn
        tput smcup
    case $yn in
            [Yy])
                sed -i '/ALTERNATEMEMORY/ s/.*/ALTERNATEMEMORY="true"/' "$DYNFOLDERconf"
                ;;
            [Nn])
                sed -i '/ALTERNATEMEMORY/ s/.*/ALTERNATEMEMORY="false"/' "$DYNFOLDERconf"
                ;;
    esac
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_misc
}
function config_misc
{
	. "$DYNFOLDERconf"
    printf "$DYNLOGO $CYAN%s:$NORMAL \n" "$LANG_MISCPART"
    printf "   %-15s %s \n"  "1) $LANG_TIMEZONE" "- $LANG_SETTIMEZONE $TIMEZONE" \
	"2) $LANG_MAINTFILE" "- $LANG_SETMAINTFILE $MAINTFILE" \
	"3) $LANG_ALTERNATEMEM" "- $LANG_SETALERNATEMEM $ALTERNATEMEMORY" \
	"4) $LANG_BACK" "- $LANG_RETURNPARTSEL" \
	"5) $LANG_EXIT" "- $LANG_ABORT"
    printf "%s  " "$LANG_SELECTOPTION"
        read -r opt
        case $opt in
                1 ) config_misc_timezone
                ;;
                2 ) config_misc_maintfile
                ;;
                3 ) config_misc_alternatemem
                ;;
                4 ) tput smcup && config
        ;;
        5 ) quit
        ;;
        * ) printf "$DYNLOGO $RED%s \n$NORMAL \n" "$LANG_WRONGOPTION" && config_misc
        esac
}
function config_lang_set
{
        printf "%s:  $NORMAL" "$LANG_ENTERLANGFILE $DYNFOLDER/[code].lang   "
        read -r sel
        tput smcup
        sel="\'$sel\'"
        sed -i "/LANGUAGE/ s#.*#LANGUAGE=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_design
}
function config_colors
{
    printf "$DYNLOGO $CYAN%s:$NORMAL \n" "$LANG_COLORPART $LANG_YOUCANCONFIGURE"
    printf "   %-17s %s \n"  \
	"1) $LANG_SELECT_COLOR_FRAME" "- $LANG_SELECT_COLOR_FRAME_DESC" \
	"2) $LANG_SELECT_COLOR_DESC" "- $LANG_SELECT_COLOR_DESC_DESC"\
	"3) $LANG_SELECT_COLOR_EQUAL" "- $LANG_SELECT_COLOR_EQUAL_DESC"\
	"4) $LANG_SELECT_COLOR_OUTPUT" "- $LANG_SELECT_COLOR_OUTPUT_DESC"\
	"5) $LANG_SELECT_COLOR_FIGLET" "- $LANG_SELECT_COLOR_FIGLET_DESC"\
	"6) $LANG_SELECT_COLOR_TITLE" "- $LANG_SELECT_COLOR_TITLE_DESC"\
	"7) $LANG_SELECT_COLOR_MAINTFILE" "- $LANG_SELECT_COLOR_MAINTFILE_DESC"\
	"8) $LANG_SELECT_CHAR" "- $LANG_SELECT_CHAR_DESC" \
	"9) $LANG_BACK" "- $LANG_RETURNTODESIGNPART" \
	"0) $LANG_EXIT" "- $LANG_ABORT"
	printf "%s  " "$LANG_SELECTOPTION"
		read -r opt
		sel=""
		case $opt in
			1 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_FRAME"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_FRAME/ s,.*,COLOR_FRAME="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			2 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_DESC"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_DESC/ s,.*,COLOR_DESC="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			3 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_EQUAL"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_EQUAL/ s,.*,COLOR_EQUAL="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			4 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_OUTPUT"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_OUTPUT/ s,.*,COLOR_OUTPUT="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			5 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_FIGLET"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_FIGLET/ s,.*,COLOR_FIGLET="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			6 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_TITLE"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_TITLE/ s,.*,COLOR_TITLE="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			7 ) while [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; do
					printf "\n%s:   $NORMAL" "$LANG_ENTER_COLOR_MAINTFILE"
					read -r sel
					sel=$(printf "%s" "$sel" | awk '{print toupper($0)}')
					if [[ $sel != "BLACK" && $sel != "RED" && $sel != "GREEN" && $sel != "BROWN" && $sel != "BLUE" && $sel != "MAGENTA" && $sel != "CYAN" && $sel != "LIGHTGRAY" && $sel != "DARKGRAY" && $sel != "LIGHTRED" && $sel != "LIGHTGREEN" && $sel != "YELLOW" && $sel != "LIGHTBLUE" && $sel != "LIGHTMAGENTA" && $sel != "LIGHTCYAN" && $sel != "WHITE" && $sel != "NORMAL" ]]; then
						printf "$RED%s $NORMAL" "$LANG_INCORRECT_COLOR"
					else
						tput smcup
						break
					fi
				done
				sed -i '/COLOR_MAINTFILE/ s,.*,COLOR_MAINTFILE="'"\$$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			8 ) printf "\n%s:   $NORMAL" "$LANG_ENTER_FRAMECHARACTER"
				read -r sel
				if [[ $sel == "," ]]; then
					while [[ $sel == "," ]]; do
						printf "$RED%s $NORMAL\n" "$LANG_INCORRECT_CHAR"
						printf "%s:   $NORMAL" "$LANG_ENTER_FRAMECHARACTER"
						read -r sel
					done
				else
					tput smcup
				fi
				sed -i '/LINE_CHARACTER/ s,.*,LINE_CHARACTER="'"$sel"'",' "$DYNFOLDERconf"
				printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
				config_colors
			;;
			9 ) tput smcup && config_design
			;;
			0 ) quit
			;;
		esac

}
function config_design
{
	. "$DYNFOLDERconf"
	if [[ -s "$DYNFOLDER/$LANGUAGE.lang" ]]; then
        . "$DYNFOLDER/$LANGUAGE.lang"
	fi
    printf "$DYNLOGO $CYAN%s:$NORMAL \n" "$LANG_DESIGNPART $LANG_YOUCANCONFIGURE"
    printf "   %-19s %s \n"  \
	"1) $LANG_SELECTLANG" "- $LANG_LANGDESC $LANGUAGE" \
	"2) $LANG_COLORS" "- $LANG_COLORSDESC" \
	"3) $LANG_BACK" "- $LANG_RETURNPARTSEL" \
	"4) $LANG_EXIT" "- $LANG_ABORT"
    printf "%s  " "$LANG_SELECTOPTION" 
        read -r opt
        case $opt in
                1 ) config_lang_set
                ;;
				2 ) tput smcup && config_colors
				;;
                3 ) tput smcup && config
                ;;
                4 ) quit
                ;;
                * ) printf "$DYNLOGO $RED%s \n$NORMAL \n" "$LANG_WRONGOPTION" && config_misc
        esac
}
function config_logo_font
{
        printf "$DYNLOGO $CYAN%s:  $NORMAL" "$LANG_ENTERFIGFONT"
        read -r sel
        tput smcup
        sel="\"$sel\""
        sed -i "/FIGFONT/ s#.*#FIGFONT=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_logo
}
function config_logo_text
{
        printf "$DYNLOGO $CYAN%s:  $NORMAL" "$LANG_ENTERFIGTEXT"
        read -r sel
        tput smcup
        sel="\"$sel\""
        sed -i "/FIGTEXT/ s#.*#FIGTEXT=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_logo
}
function config_logo_param
{
        printf "$DYNLOGO $CYAN%s:  $NORMAL" "$LANG_ENTERFIGPARAMS"
        read -r sel
        tput smcup
        sel="\"$sel\""
        sed -i "/FIGPARAM/ s#.*#FIGPARAM=$sel#" "$DYNFOLDERconf"
        printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_DONE"
        config_logo
}
function config_logo
{
	. "$DYNFOLDERconf"
    printf "$DYNLOGO $CYAN%s: $NORMAL \n" "$LANG_FIGLETPART"
    printf "   %-15s %s \n"  \
	"1) $LANG_FONT" "- $LANG_SETFONT $FIGFONT" \
	"2) $LANG_TEXT" "- $LANG_SETTEXT  $FIGTEXT" \
	"3) $LANG_PARAMS" "- $LANG_SETPARAMS" \
	"4) $LANG_BACK" "- $LANG_RETURNPARTSEL" \
	"5) $LANG_EXIT" "- $LANG_ABORT"
    printf "%s  " "$LANG_SELECTOPTION"
        read -r opt
        case $opt in
                1 ) config_logo_font
                ;;
                2 ) config_logo_text
                ;;
                3 ) config_logo_param
                ;;
                4 ) tput smcup && config
                ;;
                5 ) quit
                ;;
                * ) tput smcup && printf "$DYNLOGO $RED%s \n$NORMAL \n" "$LANG_WRONGOPTION" && config_logo
        esac

}
function config
{
    printf "$DYNLOGO $CYAN%s:$NORMAL \n" "$LANG_YOUCANCONFIGURE"
    printf "   %-15s %s \n" \
	"1) $LANG_MISC" "- $LANG_SETMISC" \
	"2) $LANG_DESIGN" "- $LANG_CUSTOMISEDESIGN" \
	"3) $LANG_LOGO" "- $LANG_LOGOSETTINGS" \
	"4) $LANG_EXIT" "- $LANG_ABORT"
    printf "%s  " "$LANG_PARTSELECTION"
    read -r opt
    case $opt in
        1 ) tput smcup && config_misc
        ;;
        2 ) tput smcup && config_design
        ;;
        3 ) tput smcup && config_logo
         ;;
        4 ) quit
        ;;
        * ) tput smcup && printf "$DYNLOGO $RED%s \n$NORMAL \n" "$LANG_WRONGOPTION" && config
    esac
}
function usage
{
    printf "$DYNLOGO $NORMAL%s\n" "$LANG_USAGE"
    printf "%s\n" "$LANG_AVAILABLEOPTIONS"
    printf " %-7s %-18s %s \n" \
	"-[hu?]," "--help, --usage" "- $LANG_HELP_HELP" \
	"-v," "--version" "- $LANG_HELP_VERSION" \
	"" "--config" "- $LANG_HELP_CONFIG" \
	"" "--createconfig" "- $LANG_HELP_CREATECONFIG" \
	"" "--install" "- $LANG_HELP_INSTALL"
}
function version
{
    printf "$DYNLOGO$NORMAL v%s %s %s by Bielecki\n" "$VERSION" "$LANG_LASTUPDATED" "$LASTUPDATE"
}
function makeconfig
{
    if [[ -f "$DYNFOLDERconf" ]]; then
        printf "
# Misc
TIMEZONE=\"UTC\"
MAINTFILE=\"\"
ALTERNATEMEMORY=\"false\"
LANGUAGE=\"en_US\"

# Logo
FIGFONT=\"big\"
FIGTEXT=\"DynMOTD\"
FIGPARAM=\"\"

# Design
COLOR_FRAME=\"\$MAGENTA\"
COLOR_DESC=\"\$LIGHTCYAN\"
COLOR_EQUAL=\"\$MAGENTA\"
COLOR_OUTPUT=\"\$LIGHTGREEN\"
COLOR_FIGLET=\"\$LIGHTGREEN\"
COLOR_TITLE=\"\$YELLOW\"
COLOR_MAINTFILE=\"\$YELLOW\"
LINE_CHARACTER=\"+\"
" > "$DYNFOLDERconf"
        else
            printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_ERROROCCURED" && return
    fi
    printf "$DYNLOGO $GREEN%s $NORMAL \n" "$LANG_MAKEDCONFFILE" && return
}
function createconf
{
    while [[ ! -d "$DYNFOLDER" ]]; do
        mkdir "$DYNFOLDER"
        break
    done
    if [[ -f "$DYNFOLDERconf" ]]; then
        printf "\n$DYNLOGO $RED%s (y/n)  $NORMAL" "$LANG_CONFFILEEXISTS"
        read -r yn
        case $yn in
            [Yy])
                makeconfig
                ;;
            [Nn])
                printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_ABORTEDCONFINSTALL"
                ;;
            * )     printf "$DYNLOGO $RED%s \n$NORMAL \n" "$LANG_INCORRECTCHOICE"
        esac
    else
        touch "$DYNFOLDERconf"
        makeconfig
	chown $(logname):$(logname) "$DYNFOLDER" -R
        return
    fi

}
function install
{
    if [[ "$EUID" -ne 0 ]]; then
        printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_NOTROOT"
        exit 1
    else
        printf "$DYNLOGO $CYAN%s /etc/ssh/sshd_config!...  $NORMAL" "$LANG_DISABLINGSSHDMOTD"
        sleep 2
        sed -i "/PrintMotd/ s#.*#PrintMotd no#" /etc/ssh/sshd_config
        printf "%b %s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
        printf "$DYNLOGO $CYAN%s /etc/pam.d/login!...  $NORMAL" "$LANG_DISABLINGPAMMOTD"
        sleep 2
        sed -i '/![^#]/ s/\(^.*pam_motd.*$\)/#\ \1/' /etc/pam.d/login
        printf "%b %10.10s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
        ETCPROFILE=$(grep dynmotd /etc/profile)
        if [[ -z "$ETCPROFILE" ]]
            then
                printf "$DYNLOGO $CYAN%s /etc/profile!...  $NORMAL" "$LANG_ENABLINGDYNMOTD"
                sleep 2
                printf '/usr/local/bin/dynmotd' >> /etc/profile
                printf "$GREEN \t %s $NORMAL \n" "$LANG_DONE"
        fi
        SCRIPTLOCATION=$(readlink -f "$0")
        printf "$DYNLOGO $CYAN%s /usr/local/bin/dynmotd!...  $NORMAL" "$LANG_MOVINGDYNMOTD"
        sleep 2
        mv "$SCRIPTLOCATION" /usr/local/bin/dynmotd > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            printf "%b %10.10s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
        else
            printf "%b %10.10s %b\n" "$RED" "$LANG_FAILED" "$NORMAL"
        fi
        printf "$DYNLOGO $CYAN%s %s/dynconf.conf!...  $NORMAL" "$LANG_CREATINGCONFIG" "$DYNFOLDER"
        sleep 2
        createconf
        printf "$DYNLOGO $CYAN%s %s/en_US.lang!...  $NORMAL" "$LANG_MOVINGLANGFILE" "$DYNFOLDER"
        sleep 2
        LANG="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/en_US.lang"
        mv "$LANG" "$DYNFOLDER/" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            printf "%b %10.10s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
        else
            printf "%b %10.10s %b\n" "$RED" "$LANG_FAILED" "$NORMAL"
        fi
        printf "$DYNLOGO $CYAN%s /usr/share/man/man1/!...  $NORMAL" "$LANG_MOVINGMANPAGE"
        sleep 2
        MAN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/dynmotd.1.gz"
        mv "$MAN" /usr/share/man/man1/ > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            printf "%b %10.10s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
        else
            printf "%b %10.10s %b\n" "$RED" "$LANG_FAILED" "$NORMAL"
        fi
        if ! type figlet > /dev/null 2>&1
            then
                while true; do
                    printf "$DYNLOGO $LIGHTMAGENTA%s (y/n)  $NORMAL" "$LANG_NOFIGLET"
                    read -r yn
                    case $yn in
                        [Yy])
                            apt-get install figlet -y -qq > /dev/null 2>&1
                            if [[ $? -eq 0 ]]; then
                                printf "$DYNLOGO $GREEN%s $NORMAL \n" "$LANG_DONE"
                            else
                                printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_FAILED"
                            fi
                            break
                            ;;
                        [Nn])
                            break
                            ;;
                        * )     printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_ANSWERYN"
                    esac
                done
        fi
        if ! type curl > /dev/null 2>&1
            then
                while true; do
                    printf "$DYNLOGO $LIGHTMAGENTA%s (y/n)  $NORMAL" "$LANG_NOCURL"
                    read -r yn
                    case $yn in
                        [Yy])
                            apt-get install curl -y -qq > /dev/null 2>&1
                            if [[ $? -eq 0 ]]; then
                                printf "$DYNLOGO $GREEN%s $NORMAL \n" "$LANG_DONE"
                            else
                                printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_FAILED"
                            fi
                            break
                            ;;
                        [Nn])
                            break
                            ;;
                        * )     printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_ANSWERYN"
                    esac
                done
        fi
        if ! type geoiplookup > /dev/null 2>&1
            then
                while true; do
                    printf "$DYNLOGO $LIGHTMAGENTA%s (y/n)  $NORMAL" "$LANG_NOGEOIP"
                    read -r yn
                    case $yn in
                        [Yy])
                            apt-get install geoip-bin geoip-database -y -qq > /dev/null 2>&1
                            if [[ $? -eq 0 ]]; then
                                printf "$DYNLOGO $GREEN%s $NORMAL \n" "$LANG_DONE"
                            else
                                printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_FAILED"
                            fi
                            apt-get install geoip-database-contrib -y -qq > /dev/null 2>&1
                            if type geoip-database-contrib_update > /dev/null 2>&1
                                then
                                    geoip-database-contrib_update > /dev/null 2>&1
                            fi
                            break
                            ;;
                        [Nn])
                            break
                            ;;
                        * )     printf "$DYNLOGO $RED%s $NORMAL \n" "$LANG_ANSWERYN"
                    esac
                done
        fi
    printf "$DYNLOGO $CYAN%s...   $NORMAL" "$LANG_RESTARTINGSSHSERVICE"
    sleep 2
    service ssh restart > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        printf "%b %10.10s %b\n" "$GREEN" "$LANG_DONE" "$NORMAL"
    else
        printf "%b %10.10s %b\n" "$RED" "$LANG_FAILED" "$NORMAL"
    fi
    printf "$DYNLOGO $GREEN%s \n$NORMAL \n" "$LANG_INSTALLCOMPLETED"
    sleep 2
    exit 1
    fi
}
while [ "$1" != "" ]; do
    case $1 in
    --createconfig)        createconf && exit 1
                ;;
    --install)        install
                ;;
    --config)    if [[ -f "$DYNFOLDERconf" ]]; then
                trap 'abort' INT HUP QUIT
                tput smcup
                printf "$DYNLOGO $CYAN%s $NORMAL \n" "$LANG_ENTEREDCONFIG"
                config
            else
                printf "$DYNLOGO $RED%s %s %s %s %s $NORMAL \n" "$LANG_NOCONFIG1" "'dynmotd --install'" "$LANG_OR" "'dynmotd --createconfig'" "$LANG_NOCONFIG2"
            fi
                exit
                ;;
        -v | --version)        version
                exit
                                ;;
        -h | -u | -? | --usage | --help ) usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

                                                                                
# # # # # # # # # # # # # # # # # # Misc # # # # # # # # # # # # # # # # # #
if type curl > /dev/null 2>&1
    then
        IPv4=$(curl -4sfm 3 icanhazip.com/s)
	errorcode="$?"
	if [ "$errorcode" -eq 28 ]; then
		IPv4="$ERRORCOLOR$LANG_CURLTIMEOUT"
	fi
        IPv6=$(curl -6sfm 3 icanhazip.com/s)
	errorcode="$?"
	if [ "$errorcode" -eq 28 ]; then
		IPv4="$ERRORCOLOR$LANG_CURLTIMEOUT"
	fi
    else
        IPv4="$ERRORCOLOR$LANG_CURLNOTINSTALLED"
        IPv6="$ERRORCOLOR$LANG_CURLNOTINSTALLED"
    fi
PROCCOUNT=$(ps -Afl | wc -l)
WHO=$(whoami)
USER=$(logname)
UNUSEDMEM=$(free -m | grep Mem | awk '{print $NF}')
if  [[ $ALTERNATEMEMORY == "true" ]]
    then
        TOTALMEM=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 ))
    else
        TOTALMEM=$(free -m | grep Mem | awk '{print $2}')
fi

# # # # # # # # # # # # # # # # # # Figlet # # # # # # # # # # # # # # # # #
if type figlet > /dev/null 2>&1
    then
        FIGLET=$(if [[ -n $FIGFONT ]]
                then
                    echo "figlet -f \"$FIGFONT\" \"$FIGTEXT\""
                else
                    echo "figlet \"$FIGTEXT\""
            fi)
        if [[ -n $FIGTEXT ]]
            then
                RUNFIGLET=$(eval "$FIGLET" "$FIGPARAM")
            else
                RUNFIGLET=$()
        fi
    else
        RUNFIGLET="$ERRORCOLOR$LANG_LOGOSETNOFIGLET"
fi

# # # # # # # # # # # # # # # # System data # # # # # # # # # # # # # # # # #
HOSTNAME=$(hostname)
IPV4=$(if [[ -z "$IPv4" ]]
        then
            printf "%b%s" "$ERRORCOLOR" "$LANG_UNAVAILABLE"
        else
            printf "%s" "$IPv4"
    fi)
IPV6=$(if [[ -z "$IPv6" ]]
        then
            printf "%b%s" "$ERRORCOLOR" "$LANG_UNAVAILABLE"
        else
            printf "%s" "$IPv6"
    fi)
KERNEL=$(uname -r)
DATE=$(TZ=$TIMEZONE date +'%A, %x (%B) %X')
UPTIME=$(uptime -p | sed -ne 's/up //p')
CPU="$(grep -c 'model name' /proc/cpuinfo)x $(< /proc/cpuinfo sed -n -e 's/^model.*name.*\: //p' | head -n 1)"
MEMORY="$LANG_MEMPART1 $UNUSEDMEM MB $LANG_MEMPART2 $TOTALMEM MB"

# # # # # # # # # # # # # # # # User data # # # # # # # # # # # # # # # # # #
USERNAME=$(if [[ "$WHO" != "$USER" ]]
        then
            printf "%s%s %s" "$USER (" "$LANG_LOGGEDAS" "$WHO)"
        else
            printf "%s" "$WHO"
    fi)
USERIP=$(who am i --ip | awk '{print $NF}')
if type geoiplookup > /dev/null 2>&1
    then
        LOCATION=$(geoiplookup "$USERIP" | sed -n -e 's/^GeoIP.*Country.*Edition\: //p')
    else
        LOCATION="$ERRORCOLOR$LANG_UNAVAILABLE"
fi
SESSIONS=$(who | grep -c "$USER")
PROCESSES="$PROCCOUNT $LANG_OF $(ulimit -u) MAX"

# # # # # # # # # # # # # # # Maintenance info # # # # # # # # # # # # # # # #
MAINTENANCE=$(
    if [[ ! -f "$DYNFOLDERconf" ]]
        then
            printf "%s" "$LANG_DEFAULTSETTINGS"
    elif [[ -z $MAINTFILE ]]
        then
            printf "%s" "$LANG_MAINTFILENOTSET"
    elif [[ ! -f "$MAINTFILE" ]]
        then
            printf "%s" "$LANG_NOMAINTFILE"
    elif [[ ! -s "$MAINTFILE" ]]
        then
            printf "%s" "$LANG_MAINTFILEEMPTY"
    else
        cat "$MAINTFILE"
fi)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # MAIN SCRIPT PART # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

width=60
char="$LINE_CHARACTER"


len=${#LANG_SYSTEMDATA}
fillerlen=$(((width - len - 2) / 2))
SYSTEMDATA_filler=$(printf "$char%.0s" $(seq 1 "$fillerlen"))

len=${#LANG_USERDATA}
fillerlen=$(((width - len - 2) / 2))
USERDATA_filler=$(printf "$char%.0s" $(seq 1 "$fillerlen"))

len=${#LANG_MAINTINFO}
fillerlen=$(((width - len - 2) / 2))
MAINTINFO_filler=$(printf "$char%.0s" $(seq 1 "$fillerlen"))

LINE=$(printf "$char%.0s" $(seq 1 "$width"))


printf \
"\n%b%b\n" "$COLOR_FIGLET" "$RUNFIGLET" 
printf "%b%s%b %s %b%s\n" "$COLOR_FRAME" "$SYSTEMDATA_filler" "$COLOR_TITLE" "$LANG_SYSTEMDATA" "$COLOR_FRAME" "$SYSTEMDATA_filler"
printf "%b%s%b%13.13s%b %s %b%s\n" "$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_HOSTNAME" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$HOSTNAME"
printf "%b%s%b%13.13s%b %s %b%b\n" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_IPV4" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$IPV4" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_IPV6" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$IPV6"
printf "%b%s%b%13.13s%b %s %b%s\n" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_KERNEL" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$KERNEL" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_DATE" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$DATE" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_UPTIME" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$UPTIME" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_CPU" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$CPU" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_MEMORY" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$MEMORY" 
printf "%b%s%b %s %b%s\n" "$COLOR_FRAME" "$USERDATA_filler" "$COLOR_TITLE" "$LANG_USERDATA" "$COLOR_FRAME" "$USERDATA_filler"
printf "%b%s%b%13.13s%b %s %b%s\n" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_USERNAME" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$USERNAME" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_IP" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$USERIP"
printf "%b%s%b%13.13s%b %s %b%b\n" "$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_LOCATION" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$LOCATION"
printf "%b%s%b%13.13s%b %s %b%s\n" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_SESSIONS" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$SESSIONS" \
"$COLOR_FRAME" "$char" "$COLOR_DESC" "$LANG_PROCESSES" "$COLOR_EQUAL" "=" "$COLOR_OUTPUT" "$PROCESSES"
printf "%b%s%b %s %b%s\n" "$COLOR_FRAME" "$MAINTINFO_filler" "$COLOR_TITLE" "$LANG_MAINTINFO" "$COLOR_FRAME" "$MAINTINFO_filler"
printf "%b%s%b %s\n" "$COLOR_FRAME" "$char" "$COLOR_MAINTFILE" "$MAINTENANCE"
printf "%b%s%b\n" "$COLOR_FRAME" "$LINE" "$NORMAL"


# # # # # # # # # # # # # # # # # END OF SCRIPT # # # # # # # # # # # # # # # # #

