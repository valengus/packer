{{ saltenv }}:
  '*':
    - installWindowsUpdates
    - installVirtGuestAdditions
    - installSdelete
