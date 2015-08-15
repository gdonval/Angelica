## Vars files ##
---

<p align="center"><img src="../ange.png" /></p>

Here are **all** the variables files you’ll need. [See ansible documentation here](https://docs.ansible.com/ansible/playbooks_variables.html).

What is important here is the order in which the files are loaded. The lowest override the highest.

It means that, the super global file *all* is overriden by global options set in *web*, *db*, *smtp*, which can be overrided by environment-specific files: *local*, *stage* or *prod*.

Here is how variable precedence works:


    ##########
    #
    #   TYPE                                                   all
    #                               ____________________________|____________________________
    #                              |                            |                            |
    #   ZONE                      web                           db                          smtp
    #                              |____________________________|____________________________|
    ###########                                   |                             |
    #                           __________________|_____________________________|________________
    #                          |                                |                                |
    #   ENV                  local                            stage                             prod
    #                __________|__________            __________|__________            __________|__________
    #               |          |          |          |          |          |          |          |          |
    #   ZONE     local_web  local_db  local_smtp  stage_web  stage_db  stage_smtp  prod_web   prod_db   prod_smtp
    #
    ###########

e.g. Variable precedence for a local web server host: all => web => local => local_web


