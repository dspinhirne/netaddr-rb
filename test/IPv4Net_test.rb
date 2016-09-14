#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestIPv4Net < Test::Unit::TestCase
	def test_new
		ip = NetAddr::IPv4.parse("128.0.0.1")
		m32 = NetAddr::Mask32.new(24)
		net = NetAddr::IPv4Net.new(ip,m32)
		assert_equal("128.0.0.0/24", net.to_s)

		net = NetAddr::IPv4Net.new(ip,nil)
		assert_equal("128.0.0.1/32", net.to_s)
	end
	
	def test_parse
		assert_equal("128.0.0.0/24", NetAddr::IPv4Net.parse("128.0.0.1/24").to_s)
		assert_equal("128.0.0.0/24", NetAddr::IPv4Net.parse("128.0.0.1 255.255.255.0").to_s)
		assert_equal("128.0.0.1/32", NetAddr::IPv4Net.parse("128.0.0.1").to_s) # default /32
	end
	
	def test_cmp
		net1 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		net2 = NetAddr::IPv4Net.parse("1.1.0.0/24")
		net3 =NetAddr::IPv4Net.parse("1.1.2.0/24")
		net4 = NetAddr::IPv4Net.parse("1.1.1.0/25")
		net5 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		
		assert_equal(1, net1.cmp(net2)) # ip less
		assert_equal(-1, net1.cmp(net3))# ip greater
		assert_equal(-1, net4.cmp(net1)) # ip eq, mask less
		assert_equal(1, net1.cmp(net4)) # ip eq, mask greater
		assert_equal(0, net1.cmp(net5)) # eq
	end
	
	def test_extended
		net = NetAddr::IPv4Net.parse("128.0.0.1/24")
		assert_equal("128.0.0.0 255.255.255.0", net.extended)
	end
	
end