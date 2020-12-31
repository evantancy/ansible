# ansible_adventures

Run the playbook in verbose mode using the following:
```bash
# -K flag or --ask-become-pass
ansible-playbook -v -K playbook.yml
```

# Roles included
- common:
    - install some common APT packages
    - add bash history timestamps
    - add extra udev rules to elevate USB permissions
    - Remove unattended-upgrades and some other settigs to disable dpkg lock
    - Create ~/install_dir to prevent clutter
- cuda:
    - add CUDA related paths to ~/.bashrc

# TODO
## Roles
- cmake
- eigen
- cudnn
- tensorRT
- julia
- linuxcan
- kvaser
- baumer
- flycap
- ros
- git (maybe?)
- vcstool