#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestIPv4 < Test::Unit::TestCase
	def test_new
		ip = NetAddr::IPv4.new(0x80000001)
		assert_equal("128.0.0.1", ip.to_s)
		
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.new(0x8000000001) }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.new(-1) }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.new("128.0.0.1") }
	end
	
	def test_parse
		ip = NetAddr::IPv4.parse("128.0.0.1")
		assert_equal("128.0.0.1", ip.to_s)
		
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.parse("128.0.0.1a") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.parse("256.0.0.1") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.parse("128.0.0.1.1") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv4.parse("128") }
	end
	
	def test_cmp
		ip = NetAddr::IPv4.parse("128.0.0.1")
		ip2 = NetAddr::IPv4.parse("128.0.0.0")
		ip3 =NetAddr::IPv4.parse("128.0.0.2")
		ip4 = NetAddr::IPv4.parse("128.0.0.1")
		assert_equal(1, ip.cmp(ip2))
		assert_equal(-1, ip.cmp(ip3))
		assert_equal(0, ip.cmp(ip4))
	end
	
	def test_next
		assert_equal("255.255.255.255", NetAddr::IPv4.parse("255.255.255.254").next().to_s)
		assert_nil(NetAddr::IPv4.parse("255.255.255.255").next())
	end
	
	def test_prev
		assert_equal("0.0.0.0", NetAddr::IPv4.parse("0.0.0.1").prev().to_s)
		assert_nil(NetAddr::IPv4.parse("0.0.0.0").prev())
	end
end