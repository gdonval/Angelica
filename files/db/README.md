## Database dumps ##
---

<p align="center"><img src="../../ange.png" /></p>

Database dumps must be placed here.

If a dbms is enabled (e.g. `mariadb.enabled`), it will import files named after your databases (configured in the `application` section in [`vars`](https://github.com/gui-don/Angelica/tree/master/vars)).
Your files must be named after your projects databases names: e.g. *agl_db.sql*.

Note that *.dist* files are ignored. These are model files.