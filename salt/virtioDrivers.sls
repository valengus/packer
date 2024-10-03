downloadVirtioIso:
  file.managed:
    - name: C:\Windows\Temp\virtio\virtio-win.iso
    - makedirs: true
    - source: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-2/virtio-win.iso
    - source_hash: 5e36f06de4ac0ff206fb9578c0a25d0d9888f2b7cc81a2539f2f041efd38f00f970a2a9fd0b8be7a81c683671b444d9473ebe9192d034275927b18c8d5a48959

installVirtioDrivers:
  cmd.run:
    - name: >
        $virtioISO = Mount-DiskImage -PassThru C:\Windows\Temp\virtio\virtio-win.iso;
        $virtioISODL = (Get-Volume -DiskImage $virtioISO).DriveLetter;

        Dismount-DiskImage -ImagePath C:\Windows\Temp\virtio\virtio-win.iso
    - shell: powershell
    - require:
      - downloadVirtioIso
