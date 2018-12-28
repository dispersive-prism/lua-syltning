# lua-syltning
Currently just a (too and very) verbose sandbox where I play around to build the different stages of a 2d platformer. Code is not optimized, there might be bugs etc. etc.

I am aware that there is dead code/code duplication in places and that a lot of code can be optimized. Again, at this stage this is a playground and nowhere near a finished entity/thing or whatever. This is just a product of quick and sometimes foolish coding.

## Current status
* Basic collision detection in place. This still needs some additional work.
* Parrallax scrolling with tile based backgrounds in place.
* Basic level in place
..* Now contains a bridge
..** Now contains a pool of water
..* Now contains a ladder

## Controls
Use 'w', 'a', 's', 'd' for movement and 'space' to jump. Pressing 's' on bridges and then jumping makes you drop down. Keep hammering the 'space' button in water to swim.

## Verified Löve2d versions
I started out with Löve 11.1, but have recently switched to 11.2. I had to do some changes to the basic physics when upping the versions. So, my recommendation to get this somewhat buggy stuff working is to use *LOVE 11.2 (Mysterious Mysteries)*. At least that is the version I'm currently playing around with.
