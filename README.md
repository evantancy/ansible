# ansible_adventures

# Setup
First add the Ansible PPA so we can get the latest version of Ansible (2.9).
This enables some features that do not come with Ansible 2.5 that comes with Ubuntu 18.04
```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update && sudo apt install ansible
```
# How to use this repository
1. Edit settings.yml for different library versions you want
2. Run specific playbook i.e. playbook.yml that includes different libraries that you want

## Running playbooks
Run any playbook in verbose mode using the following:
```bash
# -K flag or --ask-become-pass
ansible-playbook -v -K playbook_name.yml
```

To view all Ansible related variables for a specific host run:
```bash
ansible -m setup hostname
# e.g. for localhost
ansible -m setup localhost
```


# Roles included
- check_vars:

- common:
    - install some common APT packages
    - add bash history timestamps
    - add extra udev rules to elevate USB permissions
    - Remove unattended-upgrades and some other settigs to disable dpkg lock
    - Create ~/install_dir to prevent clutter
    - add settings for nano in ~/.nanorc
- cmake:
    - install CMake related APT packages
    - obtain Kitware GPG key
    - upgrade CMake
- eigen:
    - install Eigen related APT packages
    - download & unarchive eigen tar.bz2 from gitlab into ~/install_dir
    - create build folder, make -j, and sudo make install (printing status at the end)
- cuda:
    - add CUDA related paths to ~/.bashrc
    - blacklist nouveau drivers in /etc/modprobe.d/blacklist.conf
    - install cuda, cuda toolkit and related nvidia driver
- ros:
- robosense:

# TODO
## Roles
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