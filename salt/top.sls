{{ saltenv }}:
  '*':
    - installVirtGuestAdditions
    # - installWindowsUpdates
    - installSdelete
