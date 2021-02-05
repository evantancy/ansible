# ansible_adventures

# Setup
First make sure you have python2.7 installed
```bash
sudo apt install python-minimal
```

Then add the Ansible PPA so we can get the latest version of Ansible >=2.9, this enables some features that do not come with Ansible 2.5 that comes with Ubuntu 18.04
```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update && sudo apt install ansible
```
# How to use this repository
1. Edit settings.yml for different library/driver versions you want
2. Place your user password into secrets/secrets.yml using the following:
```
---
my_password: "asdfg" # for example
```
3. Run specific playbook i.e. playbook.yml that includes different libraries that you want see [here](#running-playbooks)

## Running playbooks
Run any playbook in verbose mode aka spam the terminal mode using the following:
```bash
# -K flag or --ask-become-pass
cd ansible_adventures/ansible
ansible-playbook -v -K playbook.yml
```

To view all Ansible related variables for a specific host run:
```bash
ansible -m setup hostname
# e.g. for localhost
ansible -m setup localhost
```

# Notes
- Ansible tasks and roles are procedural.
- Think of a playbook as a recipe, and roles are flavours to that recipe. Using this you can create production/development playbooks, and even use playbooks within playbooks.
- All downloaded files will be downloaded to `~/install_dir`
- when running `sudo make install` add the `--debug=basic` argument so the status is printed at the end when running ansible playbooks in verbose mode i.e. `ansible-playbook -v some_playbook.yml`
- use `wget` instead of builtin ansible `get_url` module, as wget has automatic retries, `get_url` is will break unless you specify the retries/timeouts.
- Handlers e.g. apt_update, by default, are only triggered at the end of any `tasks/main.yml` file. In order to trigger handlers immediately, use `meta` tasks e.g.`- meta: flush_handlers`
- Define role dependencies in any role using the `meta` folder, see the **g2o role** for example.


# Roles included
- check_vars:
    - Check that variables placed in ansible/vars/settings.yml exist in their respective dictionaries defined in ansible/vars/defaults.yml
        - Current checks include Eigen, CUDA Toolkit, ROS, PeakCAN, TRTorch (TensorRT Torch)
- baumer:
    - download baumer deb file from AWS if not present
    - install baumer SDK via .deb

- cmake:
    - [Reference](https://apt.kitware.com/)
    - install CMake related APT packages
    - obtain Kitware GPG key
    - install kitware-archive-keyring APT package
    - remove GPG key
    - upgrade CMake to latest stable version

- common:
    - install some common APT packages
    - Remove unattended-upgrades, update-notifier APT packages
    - add nano settings in /etc/nanorc (adding settings in ~/.nanorc does not apply to sudo commands)
    - add bash history timestamps, format DD/MM/YY HH:MM, for different formats see [here]()
    - add extra udev rules to elevate ttyUSB* and ttyS* permissions
    - Create ~/install_dir to prevent clutter

- pip:
    - install pip2 then pip3, **THIS WILL SET DEFAULT pip to pip3**
    - upgrade pip2 and pip3 (this allows for latest pip features e.g. 2020-resolver to be used by default from pip 21.0 onwards)

- git:
    - add some git alises seen [here](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)
    - upgrade git to latest version

- eigen:
    - install Eigen related APT packages
    - download & unarchive eigen tar.bz2 from gitlab into ~/install_dir
    - create build folder, make -j, and sudo make install --debug=basic

- cuda:
    - basically follow all the steps [here](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation)
    - add CUDA and cuDNN related paths to ~/.bashrc
    - NOTE: this installs the corresponding NVIDIA Driver for the specified CUDA version

- cudnn:
    - basically follow all the steps [here](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#installlinux-deb)
    - fix broken symbolic links

- flycap:
    - unzip flycap___.tar.gz to ~/install_dir
    - install Flycap SDK including unlisted dependencies that cause `./install_flycapture.sh` to break
    - install pexpect, allowing for automatic responses to prompts using regexp
    - change linux buffer sizes in /etc/sysctl.conf

- g2o:
    - install g2o from source

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

- peakcan:
    - download peak-linux-driver___.tar.gz to ~/install_dir
    - unzip && make -j all && sudo make install
    - install pcan-view

- ros:
    - basically follow all the steps [here](https://wiki.ros.org/melodic/Installation/Ubuntu)
    - install ROS desktop full, and additional ROS APT packages
    - install python-catkin-tools
- robosense:
    - install robosense dependencies
    -
- sshd:
    - reinstall openssh-client that comes with ubuntu
    - start sshd if not started

- tensorrt:
    - download tensorrt from AWS if not present
    - install TensorRT via .deb, as well as Python and C++ development packages
    - install pycuda2020.1 to /opt/

- torch:
    - basically follow all the steps [here](https://pytorch.org/get-started/locally/)
- trtorch:
    - ...
- xsens:
    - ...
- netplan:
    - ...
- jetson:
    - ...
# TODO
## Roles
- git LFS
- vcstool
- peakcan (pcan) API
- xsens driver
- diagnostics i.e. download different code samples, and libraries to check that stuff is working

## Playbooks
- development & production (APM/AQC)
