Configuration StandardEndpoint
{
    param
    (
    [string]$MachineName = "localhost"
    )

        Import-DscResource -module xNetworking
        Import-DscResource -module xRemoteDesktopAdmin
        Import-DscResource -module xPowerShellExecutionPolicy
        Import-DscResource -module xPSDesiredStateConfiguration

    Node $MachineName
        {

#Set PowerShell Execution Policy
    xPowershellExecutionPolicy RemoteSigned
        {
        ExecutionPolicy = "RemoteSigned"
        }

#Windows Update Settings
    Registry AUOptions 
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'AUOptions'
            ValueData = '4'
        }
    Registry AutoInstallMinorUpdates
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'AutoInstallMinorUpdates'
            ValueData = '1'
        }
    Registry NoAutoRebootWithLoggedOnUsers
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'NoAutoRebootWithLoggedOnUsers'
            ValueData = '0'
        }
    Registry ScheduleInstallDay
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'ScheduleInstallDay'
            ValueData = '4'
        }
    Registry ScheduleInstallTime
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'ScheduleInstallTime'
            ValueData = '12'
        }
    Registry UseWUServer
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueType = 'Dword'
            ValueName = 'UseWUServer'
            ValueData = '0'
        }

#Disable First Logon Animation
    Registry DisableFirstLogonAnimation
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueType = 'Dword'
            ValueName = 'EnableFirstLogonAnimation'
            ValueData = '0'
        }

#Windows Firewall Rules
    xFirewall AllowICMPv4-In-Domain
        {
            Name = "FPS-ICMP4-ERQ-In-NoScope"
            DisplayName = "File and Printer Sharing (Echo Request - ICMPv4-In)"
            DisplayGroup = "File and Printer Sharing"
            Access = "Allow"
            Ensure = "Present"
            State = "Enabled"
            Profile = "Domain"
            Protocol = "ICMPv4"
        }  
    xFirewall AllowICMPv6-In-Domain
        {
            Name = "FPS-ICMP6-ERQ-In-NoScope"
            DisplayName = "File and Printer Sharing (Echo Request - ICMPv6-In)"
            DisplayGroup = "File and Printer Sharing"
            Access = "Allow"
            Ensure = "Present"
            State = "Enabled"
            Profile = "Domain"
            Protocol = "ICMPv6"
        }
    xFirewall AllowSMB-In-Domain
        {
            Name = "FPS-SMB-In-TCP-NoScope"
            DisplayName = "File and Printer Sharing (SMB-In)"
            DisplayGroup = "File and Printer Sharing"
            Access = "Allow"
            Ensure = "Present"
            State = "Enabled"
            Profile = "Domain"
            Protocol = "TCP"
            LocalPort = "445"
            ApplicationPath = "System"
        }
    xFirewall AllowRemoteDesktopUDP
        {
            Name = "RemoteDesktop-UserMode-In-UDP"
            DisplayName = "Remote Desktop - User Mode (UDP-In)"
            DisplayGroup = "Remote Desktop"
            Ensure = "Present"
            State = "Enabled"
            Access = "Allow"
            Profile = "Domain"
            Protocol = "UDP"
            LocalPort = "3389"
            ApplicationPath = "%systemroot%\system32\svchost.exe"
        }
    xFirewall AllowRemoteDesktopTCP
        {
            Name = "RemoteDesktop-UserMode-In-TCP"
            DisplayName = "Remote Desktop - User Mode (TCP-In)"
            DisplayGroup = "Remote Desktop"
            Ensure = "Present"
            State = "Enabled"
            Access = "Allow"
            Profile = "Domain"
            Protocol = "TCP"
            LocalPort = "3389"
            ApplicationPath = "%systemroot%\system32\svchost.exe"
        }

#Enable Remote Desktop
    xRemoteDesktopAdmin EnableRemoteDesktop
        {
           Ensure = "Present"
           UserAuthentication = "NonSecure"
        }

#Install Office 2013 Pro SP1
    Package InstallOffice2013ProSP1
        {
            Name = "Microsoft Office Professional Plus 2013"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Office 2013 SP1\setup.exe"
            ProductId = "90150000-0011-0000-0000-0000000FF1CE" 
            Ensure = "Present"
        } 

#Install Java 8 Update 45 x86
    Package InstallJavax86
        {
            Name = "Java 8 Update 45"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Java 8\jre-8u45-windows-i586.exe"
            ProductId = "26A24AE4-039D-4CA4-87B4-2F83218045F0"
            Arguments = "/s"
            Ensure = "Present"
        }
    
#Disable Java AutoUpdate
    Registry DisableJavaUdate
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy'
            ValueType = 'Dword'
            ValueName = 'EnableJavaUpdate'
            ValueData = '0'
            DependsOn = "[Package]InstallJavax86"
        }
    Registry DisableJavaAutoUpdateCheck
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy'
            ValueType = 'Dword'
            ValueName = 'EnableAutoUpdateCheck'
            ValueData = '0'
            DependsOn = "[Package]InstallJavax86"
        }
    Registry DisableJavaNotifyDownload
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy\jucheck'
            ValueType = 'Dword'
            ValueName = 'NotifyDownload'
            ValueData = '0'
            DependsOn = "[Package]InstallJavax86"
        }
#Install Firefox
    File Firefox.ini
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Firefox.ini"
	        DestinationPath = "$env:SystemDrive\Windows\Temp\Firefox.ini"
        }
    Package InstallFirefox
        {
	        Ensure = "Present"
	        Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Firefox Setup 38.0.5.exe"
            Name = "Mozilla Firefox 38.0.5 (x86 en-US)"
	        ProductId = ""
            Arguments = "/SilentMode,/INI=$env:SystemDrive\Windows\Temp\Firefox.ini" 
            DependsOn = "[File]Firefox.ini"
        }
    File local-settings.js
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\local-settings.js"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\defaults\preferences\local-settings.js"
            DependsOn = "[Package]InstallFirefox"
        }

    File Mozilla.cfg
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\mozilla.cfg"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\mozilla.cfg"
            DependsOn = "[Package]InstallFirefox"
        }
    File Override.ini
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Override.ini"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\override.ini"
            DependsOn = "[Package]InstallFirefox"
        }
    File userChrome.css
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\userChrome.css"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\defaults\profile\chrome\userChrome.css"
            DependsOn = "[Package]InstallFirefox"
        }

#Install Adobe Flash 18 NPAPI for Firefox
    Package InstallAdobeFlash
        {
            Name = "Adobe Flash Player 18 NPAPI"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Adobe Flash\install_flash_player.exe"
            ProductId = ""
            Arguments = "-install"
            Ensure = "Present"
            DependsOn = "[Package]InstallFirefox"
        }
    
#Enable Adobe Flash Background Updater    
    File mms.cfg
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Adobe Flash\mms.cfg"
	        DestinationPath = "C:\Windows\SysWOW64\Macromed\Flash\mms.cfg"
            DependsOn = "[Package]InstallAdobeFlash"
        }
    
#Install Adobe Reader DC
    Package InstallAdobeReader
        {
            Name = "Adobe Acrobat Reader DC MUI"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Adobe Reader\AcroRdrDC1500720033_MUI.exe"
            ProductId = "AC76BA86-7AD7-FFFF-7B44-AC0F074E4100"
            Arguments = "/sAll /rs"
            Ensure = "Present"
        }

#Install Cisco Jabber
    Package InstallCiscoJabber
        {
            Name = "Cisco Jabber"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Jabber 9.7.4\CiscoJabberSetup.msi"
            ProductId = "A4C8716A-55AD-4FBD-9B47-0FB0036B0F5C"
            Ensure = "Present"
        }

#Install Google Chrome
    Package InstallChrome
        {
            Name = "Google Chrome"
            Path = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Google Chrome\googlechromestandaloneenterprise.msi"
            ProductId = ""
            Ensure = "Present"
        }
    }
}
StandardEndpoint