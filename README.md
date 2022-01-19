# ansible

# Why does this repository exist?
So whenever someone old or new needs to reinstall their setup, or configure their machine, they don't have to individually install each component and take ages to get up and running.

# Setup
First make sure you have python3, pip3 and ansible installed
```bash
sudo apt install python3-minimal python3-pip
pip3 install --upgrade pip
python3 -m pip install ansible
```

Then add the Ansible PPA so we can get the latest version of Ansible>=2.9, this enables some features that do not come with Ansible 2.5 that comes with Ubuntu 18.04
```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update && sudo apt install ansible
```



# How to use this repository
1. Edit settings.yml for different library or driver versions you want.
2. Place your user password into `ansible/secrets/secrets.yml` (**by default secrets.yml isn't created**) using the following:
```yaml
---
my_password: "asdfg" #for example
```
3. Run specific playbook i.e. playbook.yml that includes different libraries that you want, see [Running Playbooks](#running-playbooks)


## Running playbooks

### Parsing my_password variable in secrets.yml
This is ideal since you only need to type your password once. Change `full_playbook.yml` to your desired environment yml file, e.g. `development.yml`, `production_apm.yml` or `production_aqc.yml`, as `full_playbook.yml` exists to show all options available.
```bash
cd ansible/
ansible-playbook -v full_playbook.yml --extra-vars "@secrets/secrets.yml" \
--extra-vars "ansible_sudo_pass={{ my_password }}"
```

### With sudo password prompt
Run any playbook in verbose mode aka spam the terminal mode using the following:
```bash
cd ansible/
# --ask-become-pass or -K flag
# this playbook is meant to show you how to format your own playbooks, it contains all roles within this repo
# ansible-playbook -v --ask-become-pass full_playbook.yml
# other examples
ansible-playbook -v -K development.yml
ansible-playbook -v -K production_apm.yml
ansible-playbook -v -K production_aqc.yml
```



# Viewing ansible facts
To view all Ansible related variables for a specific host run:
```bash
ansible -m setup hostname
ansible -m setup localhost # e.g. for localhost
ansible -m setup localhost > ansible_facts_saved.txt
```



# Notes
- Ansible tasks and roles are procedural.
- Think of a playbook as a recipe, and roles are flavours to that recipe. Using this you can create production/development playbooks, and even use playbooks within playbooks.
- All downloaded files will be downloaded to `~/install_dir`
- when running `sudo make install` add the `--debug=basic` argument so the status is printed at the end when running ansible playbooks in verbose mode i.e. `ansible-playbook -v some_playbook.yml`, since you probably can't read all the lines.
- use `wget` instead of builtin ansible `get_url` module, as wget has automatic retries, `get_url` is **will break unless** you specify the retries/timeouts.
- Currently, files being downloaded from the URL set in the variable aid_aws_url are ...
    - Baumer SDK (baumer_deb_file)
    - CUDA Toolkit (cuda_deb_file)
    - cuDNN Runtime Library (cudnn_runtime_deb_file)
    - cuDNN Development Library (cudnn_devel_deb_file)
    - TensorRT (tensorrt_deb_file)
- Handlers e.g. apt_update, by default, are only triggered at the end of any `tasks/main.yml` file. In order to trigger handlers immediately, use meta tasks in role_name/tasks/main.yml e.g.`- meta: flush_handlers`
- Define role dependencies in any role using the `meta` folder, see the **g2o role** for example.



# Roles included
- baumer:
    - download baumer deb file from AWS if not present
    - install baumer SDK via .deb

- cmake:
    - [Reference](https://apt.kitware.com/)
    - install CMake related APT packages
    - obtain Kitware GPG key
    - install kitware-archive-keyring APT package
    - remove GPG key (because they tend to expire or some shit)
    - upgrade CMake to latest stable version (see [Reference](https://apt.kitware.com/) if you want release candidates)

- cuda:
    - basically follow all the steps [here](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation)
    - add CUDA and cuDNN related paths to ~/.bashrc
    - NOTE: this installs the corresponding NVIDIA Driver for the specified CUDA version

- cudnn:
    - basically follow all the steps [here](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#installlinux-deb)
    - fix broken symbolic links

- docker:
    - removes previous versions of docker
    - installs docker
    - installs NVIDIA Container Toolkit
    - installs docker-compose

- common:
    - install some common APT packages
    - Remove unattended-upgrades, update-notifier APT packages
    - add nano settings in /etc/nanorc (adding settings in ~/.nanorc does not apply to sudo commands)
    - add bash history timestamps, format DD/MM/YY HH:MM, for different formats see [here](https://www.networkworld.com/article/2923844/bash-history-remembering-what-you-did-and-when-you-did-it.html)
    - add extra udev rules to elevate ttyUSB* and ttyS* permissions
    - Create ~/install_dir to prevent clutter

- eigen:
    - install Eigen related APT packages
    - download & unarchive eigen tar.bz2 from gitlab into ~/install_dir
    - create build folder, make -j, and sudo make install --debug=basic

- flycap:
    - unzip flycap___.tar.gz to ~/install_dir
    - install Flycap SDK including unlisted dependencies that cause `./install_flycapture.sh` to break
    - install pexpect, allowing for automatic responses to prompts using regexp
    - change linux buffer sizes in /etc/sysctl.conf

- g2o:
    - install g2o from source

- git:
    - add some git aliases seen [here](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)
    - add pretty git logging aliases [credits](https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs)
    - upgrade git to latest version

- jetson:
    - ...

- julia:
    - download julia___.tar.gz to ~/install_dir
    - unzip to /opt/
    - create julia symbolic link
    - copy ONEinitialsetup.jl script to ~/install_dir and run

- kvaser:
    - add autonomousstuff APT repo
    - install kvaser related APT packages
    - install ROS esr and srr messages, and ROS kvaser interface

- linuxcan:
    - download linuxcan.tar.gz to ~/install_dir
    - make -j && sudo make install --debug=basic

- ms_teams:
    - install Microsoft Teams

- peakcan:
    - download peak-linux-driver___.tar.gz to ~/install_dir
    - unzip && make -j all && sudo make install (peakcan driver)
    - install pcan-view

- pip:
    - install pip2 then pip3
    - upgrade pip2 and pip3 (this allows for latest pip features e.g. 2020-resolver to be used by default from pip>=21.0)
    - set default pip to pip3

- pytorch:
    - basically follow all the steps [here](https://pytorch.org/get-started/locally/) VERY JANK atm

- robosense:
    - install robosense related APT
    - create symlink to enable RSView on Ubuntu

- ros:
    - basically follow all the steps [here](https://wiki.ros.org/melodic/Installation/Ubuntu)
    - install ROS desktop full, and additional ROS APT packages
    - install python-catkin-tools

- sshd:
    - reinstall openssh-client that comes with Ubuntu
    - start sshd service if not started

- tensorrt:
    - download tensorrt from AWS if not present
    - install TensorRT via .deb, as well as Python and C++ development packages
    - install pycuda2020.1 to /opt/
- terminal_velocity:
    - install fzf from https://github.com/junegunn/fzf.git into ~/bin(see [keybindings](https://github.com/junegunn/fzf#key-bindings-for-command-line))
    - install [silversearcher-ag](https://github.com/ggreer/the_silver_searcher) (so you don't need to `cat file | grep text` just do `ag text file_you_want_to_search`)
    - install [universal-ctags](https://github.com/universal-ctags/ctags)
    - install [ripgrep](https://github.com/BurntSushi/ripgrep) (search multiple files for text in cwd)
    - install [z](https://github.com/rupa/z)
    - install [batcat](https://github.com/sharkdp/bat) (a better `cat` with git integration)
    - install [tldr](https://github.com/raylee/tldr-sh-client) (a substitute to manpages)

- vscode:
    - install Visual Studio Code (stable)
    - install VSCode extensions if setting is enabled in `settings.yml`, see recommended [VSCode Tools](vscode_tools.md)

- zoom:
    - install Zoom

## Version checking
- cuda
- cudnn
- eigen
- julia
- tensorrt
- pycuda
- peakcan driver
- peakcan API

# TODO
## Roles
- jetson -> complete role
- xrdp #For remote access
- ifenslave
- git LFS
- xsens driver
- vcstool
- peakcan (pcan) API
- diagnostics i.e. download different code samples, and libraries to check that stuff is working

## Playbooks
- development & production (APM/AQC)
- further split into playbooks
    - drivers
    - tooling
