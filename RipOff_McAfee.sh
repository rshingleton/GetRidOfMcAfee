#!/usr/bin/env bash

## HEADER


## DEFINITIONS


## FUNCTIONS

grabConsoleUserAndHome(){

	# don't assume the home folder is equal to the user's name

	currentUser=""
	homeFolder=""

	currentUser=$(stat -f %Su "/dev/console")
	homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed 's/^ *//'| tr -d '\n')

}


removeMcAfee(){

	bolRunARecon=true

	grabConsoleUserAndHome

	## ARRAYS

	McAfeeKernelExtensions=(
		'/usr/local/McAfee/AntiMalware/Extensions/AVKext.kext'
		'/usr/local/McAfee/AppProtection/Extensions/AppProtection.kext'
		'/usr/local/McAfee/StatefulFirewall/Extensions/SFKext.kext'
		'tocal/McAfee/fmp/Extensions/FMPSysCore.kext'
		'/usr/local/McAfee/fmp/Extensions/FileCore.kext'
		'/usr/local/McAfee/fmp/Extensions/NWCore.kext'
		)

	McAfeeLaunchDaemons=(
		'/Library/LaunchDaemons/com.mcafee.agent.cma.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.Eupdate.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist'
		'/Library/LaunchDaemons/com.mcafee.virusscan.fmpd.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.ma.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macmn.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macompat.plist'
		'/Library/LaunchAgents/com.mcafee.menulet.plist'
		'/Library/LaunchAgents/com.mcafee.reporter.plist'
		'/Library/LaunchDaemons/com.mcafee.aac.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.ma.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macmn.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macompat.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.Eupdate.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.McAfeeATP.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist'
		'/Library/LaunchDaemons/com.mcafee.virusscan.fmpd.plist'
		)

	McAfeeFiles=(
		'/etc/cma.conf'
		'/Library/Application Support/CrashReporter/McAfeeATP_703E6077-554B-5BE1-A174-D50F6356149C.plist'
		'/Library/Application Support/JAMF/Receipts/McAfee093019.dmg'
		'/Library/Application Support/JAMF/Receipts/McAfeeAgent.dmg'
		'/Library/Application Support/JAMF/Receipts/McAfeeAgent11112019.dmg'
		'/Library/Application Support/JAMF/Receipts/McAfee_Install_Script.dmg'
		'/Library/LaunchDaemons/com.mcafee.agent.cma.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.Eupdate.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist'
		'/Library/LaunchDaemons/com.mcafee.virusscan.fmpd.plist'
		'/Library/LaunchAgents/com.mcafee.menulet.plist'
		'/Library/LaunchAgents/com.mcafee.reporter.plist'
		'/Library/Preferences/.com.mcafee.StatefulFirewall.license'
		'/Library/Preferences/.com.mcafee.antimalware.license'
		'/Library/Preferences/.com.mcafee.appprotection.license'
		'/Library/Preferences/com.mcafee.ssm.StatefulFirewall.plist'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist'
		'/Library/Preferences/com.mcafee.ssm.appprotection.plist'
		'/Library/Preferences/.com.mcafee.AdaptiveThreatProtection.license'
		'/Library/Preferences/.com.mcafee.StatefulFirewall.license'
		'/Library/Preferences/.com.mcafee.antimalware.license'
		'/Library/Preferences/com.mcafee.atp.plist'
		'/Library/Preferences/com.mcafee.ssm.StatefulFirewall.plist'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist.30Mh6w2'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist.dY0CTKa'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist.xhrjsyL'
		'/var/log/McAfeeSecurity.log'
		'/private/var/db/receipts/com.mcafee.agent.pkg.bom'
		'/private/var/db/receipts/com.mcafee.agent.pkg.plist'
		'/private/var/db/receipts/com.mcafee.epm.pkg.bom'
		'/private/var/db/receipts/com.mcafee.epm.pkg.plist'
		'/private/var/db/receipts/com.mcafee.mscui.bom'
		'/private/var/db/receipts/com.mcafee.mscui.plist'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.bom'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.plist'
		'/private/var/db/receipts/com.mcafee.ssm.appp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.appp.plist'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.plist'
		'/private/var/db/receipts/com.mcafee.virusscan.bom'
		'/private/var/db/receipts/com.mcafee.virusscan.plist'
		'/private/var/db/receipts/com.mcafee.dxl.bom'
		'/private/var/db/receipts/com.mcafee.dxl.plist'
		'/private/var/db/receipts/com.mcafee.mscui.bom'
		'/private/var/db/receipts/com.mcafee.mscui.plist'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.bom'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.plist'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewallHF1213993.bom'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewallHF1213993.plist'
		'/private/var/db/receipts/com.mcafee.pkg.utility.bom'
		'/private/var/db/receipts/com.mcafee.pkg.utility.plist'
		'/private/var/db/receipts/com.mcafee.ssm.atp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.atp.plist'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.plist'
		'/private/var/db/receipts/com.mcafee.virusscan.bom'
		'/private/var/db/receipts/com.mcafee.virusscan.plist'
		'/private/var/db/receipts/com.mcafee.virusscanHF1226723.bom'
		'/private/var/db/receipts/com.mcafee.virusscanHF1226723.plist'
		'/etc/cma.conf'
		'/Library/Receipts/cma.pkg'
		'/usr/local/McAfee/AntiMalware/var/tmp/.com.mcafee.scanfactory'
		'/usr/local/McAfee/AntiMalware/var/tmp/.com.mcafee.virusscan.OAS'
		'/usr/local/McAfee/AntiMalware/var/tmp/.com.mcafee.virusscan.eupdateservice'
		)

	McAfeeFolders=(
		'/Library/McAfee'
		'/Library/StartupItems/cma'
		'/private/etc/cma.d'
		'/private/etc/ma.d'
		'/Library/Application Support/McAfee'
		'/Applications/McAfee Endpoint Protection for Mac.app'
		'/Applications/McAfee Endpoint Security for Mac.app'
		'/Library/Documentation/Help/McAfeeSecurity_AVOnly.help'
		'/Library/Documentation/Help/McAfeeSecurity_ApplicationProtection.help'
		'/Library/Documentation/Help/McAfeeSecurity_Firewall.help'
		'/usr/local/McAfee'
		'/private/var/McAfee'
		)

	if [[ "$currentUser" != "root" ]]; then

		su - $currentUser -c 'launchctl unload /Library/LaunchAgents/com.mcafee.menulet.plist'
		su - $currentUser -c 'launchctl unload /Library/LaunchAgents/com.mcafee.reporter.plist'
		su - $currentUser -c 'killall "McAfee Endpoint Protection for Mac"'
		su - $currentUser -c 'killall "McAfee Endpoint Security for Mac"'
		sleep 5

	fi

	printf "\nStop StartupItems\n"
	/Library/StartupItems/cma/cmamesh forcestop

	printf "\nUnload all LaunchDaemons from array McAfeeLaunchDaemons\n"
	for EachFile in "${McAfeeLaunchDaemons[@]}"; do
		[[ -e "$EachFile" ]] && launchctl unload "$EachFile" && echo "Unloading $EachFile"
	done

	printf "\nUnload all Kernel Extensions\n"
	for EachFile in "${McAfeeKernelExtensions[@]}"; do
		[[ -e "$EachFile" ]] && kextunload "$EachFile" > /dev/null 2>&1 && echo "Unloading $EachFile" && sleep 5
	done

	printf "\nDelete all files from array McAfeeFiles\n"
	for EachFile in "${McAfeeFiles[@]}"; do
		[[ -e "$EachFile" ]] && rm -f "$EachFile" && echo "Deleting $EachFile"
	done

	printf "\nDelete all folders from array McAfeeFolders\n"
	for EachFolder in "${McAfeeFolders[@]}"; do
		[[ -e "$EachFolder" ]] && rm -rf "$EachFolder" && echo "Deleting $EachFolder"
	done

	printf "\nDelete all LaunchDaemons from array McAfeeLaunchDaemons\n"
	for EachFile in "${McAfeeLaunchDaemons[@]}"; do
		echo $EachFile
		[[ -e "$EachFile" ]] && rm -f "$EachFile" && echo "Deleting $EachFile"
	done

	printf "\nUnload all Kernel Extensions\n"
	for EachFile in "${McAfeeKernelExtensions[@]}"; do
		[[ -e "$EachFile" ]] && rm -rf "$EachFile" > /dev/null 2>&1 && echo "Deleting $EachFile"
	done

	printf "\nIf above 10.6 forget package receipt\n"
	pltvrsn=`/usr/bin/sw_vers | grep ProductVersion | cut -d: -f2`
	majvrsn=`echo $pltvrsn | cut -d. -f1`
	minvrsn=`echo $pltvrsn | cut -d. -f2`
	if (($majvrsn>=10 && $minvrsn>=6)); then
		echo "Forgetting McAfee Agent package..."
		/usr/sbin/pkgutil --forget comp.nai.cmamac > /dev/null 2>&1
	fi

	dscl . -delete /Users/mfe

	dscl . -delete /Groups/mfe

	dscl . -delete /Groups/Virex

	killall -c Menulet

}


## BODY

removeMcAfee

#jamf policy -event <Your event name to install new goes here>


## FOOTER
exit 0
