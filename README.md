# blooming-onion
Shell script for automating the deployment of a Tor hidden service for a Ghost.org blog.

## Prerequisites
This shell script requires a DigitalOcean Ghost One-Click-App. See https://www.digitalocean.com/features/one-click-apps/ghost/ for deets.

## Setup
The Ghost 1-Click-Application image isn't refreshed super-often and doesn't include git, so to do that, you'll want to run:

    apt-get update
    apt-get install git

...as a super-user. To run the script, simply clone this repo and run setup.sh, add executable permissions, and run (also as a super-user):

    git clone https://github.com/huertanix/blooming-onion.git
    chmod o+x blooming-onion/setup.sh
    ./blooming-onion/setup.sh
    
After the script runs, you can enter the .onion address created into the Tor Browser to set up your Ghost blag to haunt the ethereal realm of the dark web.

## License
This software is distributed under the GPL v3 License. See LICENSE.txt for further details.

## Credits
This project was created for a workshop on anonymous blogging at [Rightscon 2016](https://www.rightscon.org/) with [Caroline Sinders](https://twitter.com/carolinesinders) and [Stephanie Hyland](https://twitter.com/corcra).

This script was heavily inspired by [Brian J Brennan](https://twitter.com/brianloveswords)'s  [onion-ghost-blog](https://github.com/brianloveswords/onion-ghost-blog) ansible script .

Useful bash scripting protips were provided by Tuna, aka [supertunaman](https://twitter.com/supertunaman).
