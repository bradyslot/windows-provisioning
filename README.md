We've Been Trying To Reach You About Your Car's Extended Warranty

# Windows Provisioning
A whole bunch of scripts etc to provision Windows, set settings and install software the way I like it.

## Running

Pretty much the way it works is:
1. Open Powershell as admin
2. Move into this directory
3. Run the command `Set-ExecutionPolicy Bypass -Scope Process -Force` in order to allow scripts to run just in the one instance of Powershell.
4. Run the command `.\run.ps1`.

This will first download the install script for chocolatey then install it, use chocolatey to install Python, install Ansible, then Ansible, chocolatey, and (maybe) custom Python handles the rest.

## TODO

https://docs.ansible.com/ansible/latest/os_guide/windows_ssh.html#windows-ssh
https://docs.ansible.com/ansible/latest/collections/chocolatey/chocolatey/win_chocolatey_module.html#ansible-collections-chocolatey-chocolatey-win-chocolatey-module
Termux Android as Ansible control node
List programs, gather configs, write install scripts for everything
