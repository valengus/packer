{% if grains['virtual'] == 'VirtualBox' %}

virtualbox-guest-additions-guest.install:
  chocolatey.installed: []

{% elif 'QEMU' in  grains['cpu_model'] -%}

virtio-win:
  cmd.run:
    - name: >
        $WebClient = New-Object System.Net.WebClient;
        $WebClient.DownloadFile("https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.248-1/virtio-win-gt-x64.msi","$env:TEMP\virtio-win-gt-x64.msi");
        Start-Process msiexec.exe -Wait -ArgumentList "/I $env:TEMP\virtio-win-gt-x64.msi /qn /norestart";
        Remove-Item -Path "$env:TEMP\virtio-win-gt-x64.msi" -Force
    - shell: powershell

{% endif %}
