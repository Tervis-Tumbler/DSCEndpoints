Configuration StandardDesktop
{
    param
    (
    [string]$MachineName = "localhost"
    )

    Node $MachineName
    {
    
        File Firefox.exe
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Firefox Setup 24.5.0esr.exe"
	        DestinationPath = "$env:SystemDrive\Windows\Temp\Firefox.exe"
        }

        File Firefox.ini
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Firefox.ini"
	        DestinationPath = "$env:SystemDrive\Windows\Temp\Firefox.ini"
        }

	 
        Package MozillaFirefox
        {
	        Ensure = "Present"
	        Path = "$env:SystemDrive\Windows\Temp\Firefox.exe"
            Name = "Mozilla Firefox 24.5.0 (x86 en-US)"
	        ProductId = ''
            Arguments = "/SilentMode,/INI=$env:SystemDrive\Windows\Temp\Firefox.ini" 
            DependsOn = "[File]Firefox.exe","[File]Firefox.ini"
        }
        
        Package MozillaMaintenanceService
        {
            Ensure = "Absent"
            Path = "C:\Program Files (x86)\Mozilla Maintenance Service\Uninstall.exe"
            Name = "Mozilla Maintenance Service"
            ProductID = ''
            Arguments = "/S"
        }
        
        File local-settings.js
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\local-settings.js"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\defaults\preferences\local-settings.js"
            DependsOn = "[Package]MozillaFirefox"
        }

        File Mozilla.cfg
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\mozilla.cfg"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\mozilla.cfg"
            DependsOn = "[Package]MozillaFirefox"
        }

        File Override.ini
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\Override.ini"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\override.ini"
            DependsOn = "[Package]MozillaFirefox"
        }

        File userChrome.css
        {
            Ensure = "Present"
            SourcePath = "\\tervis.prv\SYSVOL\tervis.prv\scripts\Logon\Firefox\userChrome.css"
	        DestinationPath = "C:\Program Files (x86)\Mozilla Firefox\browser\defaults\profile\chrome\userChrome.css"
            DependsOn = "[Package]MozillaFirefox"
        }
    }
}
StandardDesktop