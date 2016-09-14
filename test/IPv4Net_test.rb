#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestIPv4Net < Test::Unit::TestCase
	def test_new
		ip = NetAddr::IPv4.parse("128.0.0.1")
		m32 = NetAddr::Mask32.new(24)
		net = NetAddr::IPv4Net.new(ip,m32)
		assert_equal("128.0.0.0/24", net.to_s)
	end
	
	def test_extended
		ip = NetAddr::IPv4.parse("128.0.0.1")
		m32 = NetAddr::Mask32.new(24)
		net = NetAddr::IPv4Net.new(ip,m32)
		assert_equal("128.0.0.0 255.255.255.0", net.extended)
	end
	
end