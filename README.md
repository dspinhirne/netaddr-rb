# netaddr
A Ruby library for performing calculations on IPv4 and IPv6 subnets. There is also limited support for EUI addresses.

I originally created 1.x branch back in 2007 out of the need for a tool which I could use to track an
inventory of constantly changing IP subnets. The 2.x branch is a complete rewrite of 1.x and
is completely incompatible.


# Building
To run unit tests, execute the following from the top level directory

	ruby test/runAll.rb

To build the gem, execute the following from the top level directory

	gem build netaddr.gemspec


# Examples
Example code may be found in test/example.rb. This example code runs as part of the unit tests.


# Coding Style
I follow the following conventions:
* I use tabs for indention, as tabs make it really easy to adjust indention widths on the fly.
* I do not follow rigid limits on line lengths. My editor auto-wraps so I add a line break where it feels appropriate.
* I'm not a fan of obfuscation. I prefer clear code over fancy code.
* I try to add sensible comments... mostly because I forget what the hell I was thinking 3 months down the road.


# Status
I am rewriting this from scratch. The original 1.x code is, quite frankly, horrible and embarrassing since I was
new to Ruby when I wrote it. The 2.x code base will not be compatible with the 1.x branch and I plan to simplify things greatly.

I am currently wrapping up with the IPv4 portion of the library. I will port the rest as time allows.
