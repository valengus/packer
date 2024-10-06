pswindowsupdate:
  chocolatey.installed: []


{% if grains['osfinger'] == 'Windows-11' %}

# install_updates:
#   wua.installed:
#     - updates:
      # - KB5043076
      # - KB5012170
      # - KB4023057
      # - KB890830
      # - KB2267602
      # - KB5042099

{% else %}

Install-WindowsUpdate:
  cmd.run:
    - name: >
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force;
        Import-Module PSWindowsUpdate;
        Install-WindowsUpdate -NotCategory Drivers -NotTitle Silverlight -MicrosoftUpdate -AcceptAll -IgnoreReboot
    - shell: powershell
    - require:
      - pswindowsupdate

{% endif %}
