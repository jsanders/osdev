osdev
=====

OS development playground.

Environment
-----------

This stuff is much easier to do on Linux, so I'm using Vagrant to easily work
inside a Linux vm. It's super easy to use:

    vagrant up
    vagrant ssh

Running
-------

Now that you have the vagrant environment, you should be able to run the kernel
using Bochs:

    vagrant ssh
    cd /vagrant
    make bochs

Currently, you should expect to see a terminal full of 'x's. Presumably, it will
do something slightly more interesting at some point!
