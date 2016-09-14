# netaddr
A Ruby library for performing calculations on IPv4 and IPv6 subnets. There is also limited support for EUI addresses.

I originally created 1.x branch back in 2007 out of the need for a tool which I could use to track an
inventory of constantly changing IP subnets. The 2.x branch is intended to be a replacement for 1.x but
is completely incompatible.


# Building
To run unit tests, execute the following from the top level directory

	ruby test/runAll.rb

To build the gem, execute the following from the top level directory

	gem build netaddr.gemspec


# Coding Style
I'm not pickly about line lengths, etc. I'm not coding in the 1960's so my editor is cabable of wrapping lines.
However, I do use tabs for indention primarly because I find it much easier to adjust the indention level on the fly
when I need to. 

I'm not a fan of obfuscation. I prefer clear code over fancy code.


# Status
I am rewriting this from scratch. The original 1.x code is, quite frankly, horrible and embarrassing since I was
new to Ruby when I wrote it. The 2.x code base will not be compatible with the 1.x branch and I plan to simplify things greatly.


# Contributing
Once I decide on the basic classes then I will welcome others to port over any methods which they may need but are missing.



