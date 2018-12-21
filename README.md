# lua-syltning
Currently just a (too and very) verbose sandbox where I play around to build the different stages of a 2d platformer. Code is not optimized, there might be bugs etc. etc.

I am aware that there is dead code/code duplication in places and that a lot of code can be optimized. Again, at this stage this is a playground and nowhere near a finished entity/thing or whatever.

## Verified Löve2d versions
I started out with Löve 11.1, but have recently switched to 11.2. I had to do some changes to the basic physics when upping the versions. So, my recommendation to get this somewhat buggy stuff working is to use *LOVE 11.2 (Mysterious Mysteries)*. At least that is the version I'm currently playing around with.

It however has been proven that 11.2 behaves rather odd on some tested machines. In some scenarios (downloading the binary from www.love2d.org) 11.2 seems to wreak havoc on the physics (which made me retweak everything). In other scenarios (on different machines) using the 11.2 binary instead seem to have the 11.1 physics, making all the tweaks feel floaty.

Getting it using homebrew the 11.2 version also differ in behavior. When building 11.2 from source (on CentOS) it works as 11.1. Hmm... I have yet to investigate more thoroughly.
