# Angelica Project #
---

<p align="center"><img src="ange.png" /></p>


## Automatic web servers installation ##

This is an [Ansible project](https://docs.ansible.com/).
For the moment, it can only be runned on Debian Jessie machines.

---

### The philosophy ###

The vast majority of devops scripts are focused on specific applications. This project aims to make web server installation easy for 90% of cases, just by changing some files and configuration.


### Basic environment ###

At least three environments are needed. It can be on a single machine or a infinite number of machines:

- The host. This is likely to be your local machine. This is where you code and have an IDE installed.
- The ansible machine. This must be an Unix/Linux machine. You’ll start ansible deployment here.
- The application server(s). A single or a bunch of VMs or distant machines to host a web, dbms or smtp server.


### Prerequisite ###

- [Install necessary packages for ansible](docs.ansible.com/intro_installation.html) (ansible machine).

- Download this project (ansible machine).

- If you don’t have already, [generate your local SSH keys](https://help.github.com/articles/generating-ssh-keys/) (the host):

- Copy all the users SSH keys in `files/sshkeys`. Your (the deployer) key is a minimum. (ansible machine):

- Install [Debian Jessie](https://www.debian.org/distrib/) on the application server(s). Choose a root password (strong please, at least 16 chars). **It must be the same for all servers**, you can change it afterwards. (the application servers).

- Verify that `python` and `ssh` are installed (the application servers):

        $ sudo aptitude install python ssh

- Verify that [root](http://www.cyberciti.biz/faq/allow-root-account-to-use-ssh-openssh/) and password authentication are enabled - don’t worry, it will be disabled by ansible (the application servers).

### Deployment (ansible machine) ###

- Read carefully the constants in the file `vars/all`.

- Write down your specific configuration. See [vars](vars) documentation.

- Write down the application servers hosts in files located in `hosts`.

- Before the installation, connect once to the application servers with SSH, to initialize your `know_hosts` file.

- Run the initialisation script, with the right SSH port (default: 22). Add `--ask-pass` if it is your first connection:

        $ cd /path/ansible/
        $ ansible-playbook -i hosts/*env* init.yml [--ask-pass, --extra-vars "ssh_port=port"]

- To deploy, run these commands with the needed *env* (local, stage or prod):

        $ ansible-playbook -i hosts/*env* play-common.yml
        $ ansible-playbook -i hosts/*env* play-web.yml
        $ ansible-playbook -i hosts/*env* play-db.yml

That’s it. Your servers are ready.

Note: if you want to re-run only a part of a playbook, just add `--tags "your_tag"` to the command. *your_tag* could be a top variable in your configuration file (e.g. *ssh*, *apache*…).

### Local environment ###

- In a local environment, you’ll need to share your project between you guest and your host, to be able to edit your code. Three options are possible:

##### Sharing with a virtual machine - can harm performance really badly #####

- First, don’t forget to add `applications.download: False` in the right configuration file;

- In your virtual machine, edit the file `/etc/rc.local` and add the following line (replace **33** by your guest apache user id and apache group id). Exemple with VirtualBox:

        $ sudo mount.vboxsf -o umask=000,gid=33,uid=33 *Project_name* *Project_path*

- Shut down the guest VM and create a shared folder named after your project.

##### SFTP - not convenient and pretty slow #####

- Just configure your IDE to reach your VM project directory with SFTP.

##### SSHFS - the most reliable option #####

- First, don’t forget to add `applications.download: False` in the right configuration file;

- Install sshfs on both the host and the guest;

- Copy your virtual machine user public key on your host **~/.ssh/authorized_keys** file;

        $ ssh-keygen -b 4096 -t rsa -C "your_email@example.com"
        $ cat ~/.ssh/id_rsa.pub

- In your virtual machine, edit the file `/etc/rc.local` (or add a **systemd** rule) and add the following line (replace **33** by your guest apache user id and apache group id):

        $ sudo -u **your_user** sshfs -o allow_other,gid=33,uid=33 **your_host_user**@**your_host_ip**:**your_host_project_directory** **your_vm_project_directory** -p **your_host_ssh_port**

- If needed, you can unmount by doing:

        # fusermount -u **your_vm_project_directory**

- You might need a few other tweaks to make sshfs works properly (permissions, conf, …). Watch the error messages.

### Misc ###

##### Set up a debugger ######

- First, you’ll have to set up xdebug on your virtual machine, with the right options.

- You’ll have to configure the debugger on your IDE, to make the project path match. On Netbeans, go to your project, then `Properties > Run configuration > Advanced`.

##### Update production server #####

This ansible configuration **is** your servers configuration. This is a state, a description of what your servers will look like.
This means:
- you can be confident about running the playbook multiple times;
- you should always use ansible, even for the most trivial thing;
- a disabled service is removed on targeted servers, with all its configuration.

##### Roles and tasks dependencies #####

Roles and tasks are independants. For example, whether or not you install firewall service won’t cause any trouble to other tasks.
But, be aware that any tasks can use the configuration of another tasks (e.g. it’s important to firewall service to know if you install git service or not).
This means:
- it’s better you configure everything before running any playbook;
- it’s a good idea to re-run the whole playbooks if you enabled a tasks that wasn’t before.
- the tasks order is important. E.g. if your run apache before ssl (if both enabled), it will fail because apache needs ssl.

##### Dynamic IPs #####

Dynamic IPs (typically in a local environment) is an issue. It will cause your project to fail for many reasons (firewall rules, database users, etc.).
That’s why, we advise you to use static IPs for your servers. Otherwise, you’ll need to re-run ansible everytime an IP has changed.

##### Hostnames and aliases #####

Often, there are several ways to designate a server, for exemple, ip or domain names. When editing `hosts/*` files, it’s important to be consistent.
For instance, if *local.server.com* and *192.168.1.10* are the very same server, use only one of them (IP **or** domain names), not both. Ignoring this advice can lead to misconfigurations.

##### Protect confidential files #####

Often, your servers will contain files that must not be public. The problem is your ansible project is likely to be public...
The solution is to use ansible vault.

##### Ansible & security #####

Do not run ansible on an untrusted computer. When running this script, be sure to be the only user logged in the ansible machine. Otherwise, unauthorized user might be able to steal protected password and private keys when ansible is running.

##### Manage self-signed certificates and keys #####

It’s very likely you’ll have self-signed certificates in your ansible configuration. By default, ansible will always regenerate such keys when you run it multiple times. It’s usually not an issue, but if you want to keep all your self-signed keys when running your ansible script again, use the `--skip-tags "renew"` option.

##### More documentation #####

More documentation can be found in each essential sections of this project. Also, take a look at *.dist* files which are non-used example files.
