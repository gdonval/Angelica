## SSL files ##
---

<p align="center"><img src="../ange.png" /></p>

SSL certs must be placed here.

- `certs` directory is the place for the delivered certificates.
- `private` directory is the place for private keys.
- `ca` directory is the place for ca certificate.

Each files must be named after the `application.sites.short_name` ([see `vars`](https://github.com/gui-don/Angelica/tree/master/vars)).

- `certs` extension must be .crt (e.g. *my_project.crt*)
- `private` extension must be .key (e.g. *my_project.crt*)
- `certs` extension must be .cabundle (e.g. *my_project.crt*)

Each user inside the `ssh.group` must have its own key.
Keys must be named after your users configured in the `users`.

Note that *.dist* files are ignored. These are model files.

e.g. *random_user.key*
