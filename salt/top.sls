{{ saltenv }}:
  '*':
    - installVirtGuestAdditions
    - installWindowsUpdates
    - installSdelete
