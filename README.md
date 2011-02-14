Monk
====

A feature-complete implementation of Monk that uses Shake instead of Thor.
It is modeled after Monk 1.0 beta. It implements all the features that are
available in Monk.

### Differences from the real Monk in general

 * *No more Thor!* The new Monkfile has deprecated the old Thorfile.
   This version uses Shake instead.

 * *Faster.* As a result of above.

 * New help screens. They are actually very helpful.

 * This does not require RVM.

 * This stores your config in a new format (YAML) in `~/.monk.conf`.

### Changes from Monk 0.x

 * This doesn't rely on the `dependencies` gem.

 * `monk init` will cache skeleton files so it'll run faster next time.

 * New `monk install` command installs gems from the `.gems` manifest file.

 * The command `monk unpack` now uses the more reliable RVM.

 * New `monk lock` command generates a `.gems` file for you.

### Differences from Monk 1.0 beta

 * `monk install` will first check if a gem is installed. It will not
   try to reinstall gems you already have.

