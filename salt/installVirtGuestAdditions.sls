{% if grains['virtual'] == 'VirtualBox' %}

virtualbox-guest-additions-guest.install:
  chocolatey.installed: []

{% elif 'QEMU' in  grains['cpu_model'] %}

virtio-win:
  cmd.run:
    - name: >
        $WebClient = New-Object System.Net.WebClient;
        $WebClient.DownloadFile("https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.248-1/virtio-win-gt-x64.msi","$env:TEMP\virtio-win-gt-x64.msi");
        Start-Process msiexec.exe -Wait -ArgumentList "/I $env:TEMP\virtio-win-gt-x64.msi /qn /norestart";
        Remove-Item -Path "$env:TEMP\virtio-win-gt-x64.msi" -Force
    - shell: powershell

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
