{{ saltenv }}:
  '*':
    # - updateSystem
    - installVirtGuestAdditions
    - installSdelete
