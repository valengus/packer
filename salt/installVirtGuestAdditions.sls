{% if grains['virtual'] == 'VirtualBox' %}

virtualbox-guest-additions-guest.install:
  chocolatey.installed: []

{% endif %}
