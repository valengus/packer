{% if grains['virtual'] == 'VirtualBox' %}

virtualbox-guest-additions-guest.install:
  chocolatey.installed: []

{% elif 'QEMU' in  grains['cpu_model'] %}

vdagent:
  cmd.run:
    - name: >
        $WebClient = New-Object System.Net.WebClient;
        $WebClient.DownloadFile("https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/vdagent-win-0.10.0-x64.zip","$env:TEMP\vdagent-win-0.10.0-x64.zip");
        Expand-Archive -Path $env:TEMP\vdagent-win-0.10.0-x64.zip -DestinationPath "${Env:ProgramFiles(x86)}";
        Rename-Item -Path "${Env:ProgramFiles(x86)}\vdagent-win-0.10.0-x64" -NewName "${Env:ProgramFiles(x86)}\SPICE Guest Tools";
        & "${Env:ProgramFiles(x86)}\SPICE Guest Tools\vdservice.exe" install;
        Remove-Item -Path "$env:TEMP\vdagent-win-0.10.0-x64.zip" -Force
    - shell: powershell

{% else %}

{% endif %}
