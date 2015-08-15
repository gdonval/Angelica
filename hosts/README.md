## Hosts ##
---

<p align="center"><img src="../ange.png" /></p>

Here are ansible hosts files. [See ansible doc here](https://docs.ansible.com/ansible/intro_inventory.html).
Everytime you start an ansible playbook, you must designate the host file corresponding to the environment you are setting up:

- *prod* if you’re setting up production servers.

- *stage* if you’re setting up stage servers.

- *local* if you’re setting up local (or development) servers.

Note that *.dist* files are ignored. Theses are model files.
