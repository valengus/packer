{{ saltenv }}:
  '*':
    - installWindowsUpdates
    - installSdelete
    - installVirtGuestAdditions
