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
end