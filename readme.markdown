# FATIGUE
**Import your Nike+ runs to Garmin Connect**

## It looks like this

    $ fatigue


      __      _   _                  
     / _|    | | (_)                 
    | |_ __ _| |_ _  __ _ _   _  ___ 
    |  _/ _` | __| |/ _` | | | |/ _ \
    | || (_| | |_| | (_| | |_| |  __/
    |_| \__,_|\__|_|\__, |\__,_|\___|
                     __/ | for nike+garmin
                     |___/               



    Nike+ User ID:           123456789
    Garmin Connect Username: sookie
    Garmin Connect Password: 

    HARDCORE RUNNING ACTION: 
      status:      100% |oooooooooooooooooooooooooooooooooooooooooo| Time: 00:02:20

    Neato! We just imported 72 runs. See them for yourself at:
      http://connect.garmin.com/activities

## What you get

This grabs run data from the low-fi Nike+ histories, so while it won't have GPS
maps like what Garmin rocks, we'll populate your Garmin history with Nike+ data
for things like distance run, how long your run took, what day and time it was
run, and nifty things like that.

## Install

**For the Techies**

    gem install fatigue

If you have no idea what the heck a gem install is, have no fear; none of this
is hard to do.

**For Mac Users**

Open up your `Applications` folder, scroll down to `Utilities`, and then open
up `Terminal`. Once you're there, type `sudo gem install fatigue` and then
enter your Mac password when prompted. This will download the code to your
machine. When it tells you "3 gems installed", type `fatigue` and enjoy the
show.

NOTE: If you run into a problem during installation where it spits out `ERROR:
Failed to build gem native extension`, that means you need to install XCode.
It's available on your OS X install DVD or through the Mac App Store. We're
working on fixing this so you don't need to install XCode in the future.

**For Windows Users**

Microsoft makes everything harder since you'll have to install Ruby yourself.
Until someone forks this repository with better Windows instructions (hint
hint!), the best I can give you is to go try
[RubyInstaller](http://rubyinstaller.org), install it, and then see if you can
run `gem install fatigue` in it. Somehow. I don't know really, but I have a lot
of faith that you can manage it. You seem like a strong-willed individual.

## Can I see your ID

Nike might release a public API at some point in the future (although they'll
probably make you buy their shoes in order to use it). Until then, we can sneak
onto their widget API. You need to find your Nike+ user id, though (numeric ID,
that is; not your login).

To do this, log into your Nike+ account, click on "Runs", and then the long
number right at the end of the URL is just what you need. COPY AND PASTE IT
WITH ALL DUE HASTE.

You'll also need to make sure your runs are public. Click on your face on the
sidebar, go to settings, and share your life away. No need to be modest.

## Contribute

Pretty sure Nike will change their site, Garmin will change their site, or
both, so this may be a bit unstable, from time to time. Have no fear; open
source is here.

If you'd like to contribute fixes (thanks!), fork this project, add your
changes, make sure tests pass with `rake`, and send me a pull request.
High-fives for new methods that are properly [TomDoc](http://tomdoc.org)'d.

# JUST DO IT™
Love, @[holman](http://twitter.com/holman).
