Monk-shake
==========

#### Monk lets you build Sinatra applications quickly and painlessly by letting it set up the directory structure for you.

----

Monk-shake is an UNOFFICIAL feature-complete rewrite of Monk that uses the
lightweight and superfast [Shake](http://github.com/rstacruz/shake)
instead of Thor. It is modeled after Monk 1.0 beta. See more info
at [monkrb.com](http://www.morkrb.com).

**NOTE:** *This is NOT an official replacement for Monk, nor is it
supported or endorsed by Citrusbyte.*

## Get started

You may need to uninstall the original monk gem. \*

    $ rvm @global             # TIP: Recommended for RVM users
    $ gem uninstall monk

Install it:

    $ gem install monk-shake --pre

Try it out! This should help you get started:

    $ monk

Now create your first project:

    $ monk init myproject

You'll get a new directory called `myproject/`. Start hacking!
Monk-shake provides the following commands while in your
project folder:

    $ cd myproject/
    $ monk install        # Install needed gems
    $ monk start          # Starts the server
    $ monk irb            # Starts a console session

*(\* = Alternatively, you can install monk-shake in a new RVM gemset instead. This means you will need to install it in your Monk-shake projects's gemsets too, however!)*

## Differences from the official Monk

 * *No more Thor!* The new Monkfile has deprecated the old Thorfile.
   This version uses Shake instead.

 * *Faster* as a result of above.

 * New help screens. They are actually very helpful.

 * This stores your config in a new format (YAML) in `~/.monk.conf`.

 * The default skeleton is [github.com/rstacruz/monk-plus](https://github.com/rstacruz/monk-plus),
   the mere reason being it's the only one that takes advantage of new
   features at the moment.

### Changes from Monk 0.x

 * This doesn't rely on the `dependencies` gem.

 * `monk init` will cache skeleton files so it'll run faster next time.

 * New `monk install` command installs gems from the `.gems` manifest file.

 * The command `monk unpack` now uses the more reliable RVM.

 * New `monk lock` command generates a `.gems` file for you.

### Differences from Monk 1.0 beta

 * This does not require RVM.

 * `monk install` will first check if a gem is installed. It will not
   try to reinstall gems you already have.

Authors
=======

Monk-shake is a derivative work by [Rico Sta. Cruz](http://www.ricostacruz.com),
heavily based on the original implementations of [Monk](http://www.monkrb.com).

Released under the MIT license.

Monk (the original [1.0 beta](http://github.com/monk/monk) and 
[0.x](https://github.com/monkrb/monk) implementations) is
copyright (c) 2009 Michel Martens and Damian Janowski. All credit
goes out to their (and contributors) hard work for the original idea,
the API and the Monk skeletons.
