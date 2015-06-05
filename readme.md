# Angelica Project #
---

___________________________________![angelica](ange.png)___________________________________![

## Semi-automatic web servers installation with ansible ##

---

At least three environments are needed. It can be on a single machine or a infinite number of machines:

- The host. This is likely to be your local machine. This is where you code and have an IDE installed.
- The ansible machine. This must be an Unix/Linux machine. You’ll start ansible deployment here.
- The application server(s). A single or a bunch of VMs or distant machines to host a web server and dbms. It must be a Linux machine.


### Prerequisite ###

- Install necessary packages (ansible machine):

        $ sudo aptitude update
        $ sudo aptitude install software-properties-common python-passlib sshpass
        $ sudo apt-add-repository ppa:ansible/ansible
        $ sudo aptitude update
        $ sudo aptitude install ansible

Note: If you’re not on Ubuntu, it's possible to get a 404 when running third command. In this case, you need to change source in ansible source file in `/etc/apt/source.list.d`. For instance, replace your OS version by an Ubuntu repository (ex: *Lucid* in place of *Wheezy*).

- If you don’t have already, generate your local SSH keys (the host):

        $ ssh-keygen -b 4096 -t rsa -C "your_email@example.com"
        $ cd && cd .ssh
        $ ssh-add id_rsa

- Get your public key and put it on your Github account, under `Settings/SSH keys` (the host):

        $ cat ~/.ssh/id_rsa.pub

- Get sources (ansible machine):

        $ cd && mkdir ansible
        $ git clone git@github.com:gui-don/angelica.git ansible

- Install a linux on the application server(s). Choose a root password (strong please, 16 chars). It must be the same for all servers (the application servers).

- Verify that `python` and `ssh` are installed (the application servers):

        $ sudo aptitude install python ssh

- Verify that root connections are enabled - dont’t worry, it will be disabled by ansible (the application servers):

### Installation (ansible machine) ###

- Paste your local public key into `/files/sshkeys/` in a file named after your deployment user `*user*.pub`.

- Modify carefully the constants in the file `group_vars/all`. This will set the main part of your project.

- Do the same for files located in `roles/*/vars`. These are specific options files.

- Write down the application servers IP addresses in the file `inventory/servers`.

- Before the installation, connect once to the application servers with SSH, to initialize your `know_hosts` file.

- Run the initialisation script:

        $ cd /path/ansible/
        $ ansible-playbook -i inventory/servers init.yml --ask-pass

- Deploy common configuration for all servers:

        $ ansible-playbook -i inventory/servers servers-common.yml --ask-sudo-pass

- Deploy web servers configuration (if you’re in local, read the next section before executing the command - you might need `--skip-tags "installapp"`):

        $ ansible-playbook -i inventory/servers servers-web.yml --ask-sudo-pass

- Deploy dbms servers configuration:

        $ ansible-playbook -i inventory/servers servers-db.yml --ask-sudo-pass

### Local environment ###

- In a local environment, you’ll need to share your project between you guest and your host, to edit the code with your IDE. Three options are possible:

##### Sharing with VirtualBox - can harm performance really badly #####

- First, don’t forget to add `--skip-tags "installapp"` when your run the web playbook;

- In your virtual machine, edit the file `/etc/rc.local` and add the following line (replace **33** by your guest apache user id and apache group id):

        $ sudo mount.vboxsf -o umask=000,gid=33,uid=33 *Project* /var/www/*Project*

- Shut down the guest VM and create a shared folder named after your project.

##### SFTP - not convenient and pretty slow #####

- Just configure your IDE to reach your VM code with SFTP.

##### SSHFS - the most reliable option #####

- First, don’t forget to add `--skip-tags "installapp"` when your run the web playbook;

- Install sshfs on both the host and the guest;

- Generate SSH keys on the virtual machine and copy the publickey on your host **~/.ssh/authorized_keys** file. Verify you can connect from your virtual machine to your host;

        $ ssh-keygen -b 4096 -t rsa -C "your_email@example.com"
        $ cat ~/.ssh/id_rsa.pub

- In your virtual machine, edit the file `/etc/rc.local` and add the following line (replace **33** by your guest apache user id and apache group id):

        $ sudo -u **your_user** sshfs -o allow_other,gid=33,uid=33 **your_host_user**@**your_host_ip**:**your_host_project_directory** /var/www/*Project* -p **your_host_ssh_port**

- If needed, you can unmount by doing:

        # fusermount -u /var/www/*Project*

#### Set up a debugger ####

- First, you’ll have to set up xdebug on your virtual machine, with the right options.

- On netbeans, you’ll have to configure the debugger . Go to your project, then `Properties > Run configuration > Advanced`.

### Update production server ###

To update the server, please always use ansible. This permits to control the validity of this script.

#### Add a user ####

1. Add his public key into `/files/sshkeys/`;

2. Add the username in `group_vars/all`;

3. Run the concerned playbook:

        $ ansible-playbook -i inventory/servers servers-common.yml --ask-sudo-pass --skip-tags "creates" --tags "users"

Remember, test the script in local before running it in production!
