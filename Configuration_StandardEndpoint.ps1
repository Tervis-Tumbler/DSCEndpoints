Configuration StandardEndpoint
{
    param
    (
    [string]$MachineName = "localhost"
    )

        Import-DscResource -module xNetworking

    Node $MachineName
        {

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
        }
    }
}
StandardEndpoint