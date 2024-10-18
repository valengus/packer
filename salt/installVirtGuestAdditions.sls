{% if grains['virtual'] == 'VirtualBox' %}

virtualbox-guest-additions-guest.install:
  chocolatey.installed: []

{% elif grains['virtual'] == 'VMware' %}

vmware-tools:
  chocolatey.installed: []

{% elif 'QEMU' in  grains['cpu_model'] %}

SPICE Guest Tools:
  archive.extracted:
    - name: "C:\\Program Files (x86)\\"
    - if_missing: "C:\\Program Files (x86)\\SPICE Guest Tools\\vdservice.exe"
    - enforce_toplevel: false
    - source: https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/vdagent-win-0.10.0-x64.zip
    - source_hash: sha256=713c14456846ee62431afdc269cffefd437b0cd4474fa24ed8338cd2e8665cf4
  file.rename:
    - name: "C:\\Program Files (x86)\\SPICE Guest Tools"
    - source: "C:\\Program Files (x86)\\vdagent-win-0.10.0-x64"
    - force: True
  cmd.run:
    - name: '& "C:\Program Files (x86)\SPICE Guest Tools\vdservice.exe" install'
    - unless: Get-Service vdservices
    - shell: powershell

QEMU guest agent:
  file.managed:
    - name: C:\install\qemu-ga-x86_64.msi
    - source: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-qemu-ga/qemu-ga-win-108.0.2-1.el9/qemu-ga-x86_64.msi
    - source_hash: sha256=22a80d9f715b0df944a1513496cae4258baa35f0eaa70b9abe22abfc6ca24841
    - makedirs: true
  cmd.run:
    - name: Start-Process msiexec.exe -Wait -ArgumentList '/I C:\install\qemu-ga-x86_64.msi /qn /norestart'
    - creates: C:\Program Files\Qemu-ga\qemu-ga.exe
    - shell: powershell

Remove installer:
  file.absent:
    - name: C:\install
    - require:
      - QEMU guest agent

{% else %}

{% endif %}
