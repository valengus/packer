pswindowsupdate:
  chocolatey.installed: []

Install-WindowsUpdate:
  cmd.run:
    - name: >
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force;
        Import-Module PSWindowsUpdate;
        Install-WindowsUpdate -NotCategory Drivers -NotTitle Silverlight -MicrosoftUpdate -AcceptAll -IgnoreReboot
    - shell: powershell
    - require:
      - pswindowsupdate