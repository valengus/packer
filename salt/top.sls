{{ saltenv }}:
  '*':
    - installWindowsUpdates
    - installVirtGuestAdditions
    - installSdelete