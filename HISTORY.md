v1.0.0.pre2 (Unreleased)
------------------------

 * `monk install` improvements:

     * It now shows what gemset it's being installed to.

     * It now installs all gems in one go, instead of one-by-one.

     * You may now install from custom gems files.
       Example: `monk install .gems.development`

 * `monk add` now will stop you if you try to update the default skeleton.

 * `monk init` will use the same RVM Ruby version patch level if RVM is installed.

 * `monk lock` will back up your old .gems file if needed.

 * Ruby 1.8.6 is now the minimum required version.

v1.0.0.pre1
-----------

 * Initial.
