#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestIPv6 < Test::Unit::TestCase
	def test_new
		ip = NetAddr::IPv6.new(1)
		assert_equal(1, ip.addr)
		
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.new(2**128) }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.new(-1) }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.new("::") } # string
	end
	
	def test_parse
		assert_equal(0, NetAddr::IPv6.parse("::").addr)
		assert_equal(1, NetAddr::IPv6.parse("::1").addr)
		assert_equal(0xfe800000000000000000000000000000, NetAddr::IPv6.parse("fe80::").addr)
		assert_equal(NetAddr::F128, NetAddr::IPv6.parse("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff").addr)
		
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("fe80::1::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("0:0:0:0:0:0:0:0:1") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("::fe80::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("::0:0:0:0:0:0:1") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("1:1:1:1:1:1:1::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("1:1:1:1:1:1:1::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("fec0") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("fec0:::1") }
		
	end
	
	def test_cmp
		ip = NetAddr::IPv6.parse("::1")
		ip2 = NetAddr::IPv6.parse("::0")
		ip3 =NetAddr::IPv6.parse("::2")
		ip4 = NetAddr::IPv6.parse("::1")
		assert_equal(1, ip.cmp(ip2))
		assert_equal(-1, ip.cmp(ip3))
		assert_equal(0, ip.cmp(ip4))
	end
	
	def test_long
		assert_equal("0000:0000:0000:0000:0000:0000:0000:0000", NetAddr::IPv6.parse("::").long)
		assert_equal("fe80:0000:0000:0000:0000:0000:0000:0001", NetAddr::IPv6.parse("fe80::1").long)
		assert_equal("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff", NetAddr::IPv6.new(NetAddr::F128).long)
	end
	
	def test_next
		assert_equal(1, NetAddr::IPv6.parse("::").next().addr)
		assert_nil(NetAddr::IPv6.parse("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff").next())
	end
	
	def test_prev
		assert_equal("::", NetAddr::IPv6.parse("::1").prev().to_s)
		assert_nil(NetAddr::IPv6.parse("::").prev())
	end
	
	def test_to_s
		assert_equal("::", NetAddr::IPv6.parse("0:0:0:0:0:0:0:0").to_s)
		assert_equal("1::", NetAddr::IPv6.parse("1:0:0:0:0:0:0:0").to_s)
		assert_equal("0:1::", NetAddr::IPv6.parse("0:1:0:0:0:0:0:0").to_s)
		assert_equal("0:0:1::", NetAddr::IPv6.parse("0:0:1:0:0:0:0:0").to_s)
		assert_equal("0:0:0:1::", NetAddr::IPv6.parse("0:0:0:1:0:0:0:0").to_s)
		assert_equal("::1:0:0:0", NetAddr::IPv6.parse("0:0:0:0:1:0:0:0").to_s)
		assert_equal("::1:0:0", NetAddr::IPv6.parse("0:0:0:0:0:1:0:0").to_s)
		assert_equal("::1:0", NetAddr::IPv6.parse(":0:0:0:0:0:1:0").to_s)
		assert_equal("::1", NetAddr::IPv6.parse("0:0:0:0:0:0:0:1").to_s)
		
		assert_equal("1::1", NetAddr::IPv6.parse("1:0:0:0:0:0:0:1").to_s)
		assert_equal("1:1::1", NetAddr::IPv6.parse("1:1:0:0:0:0:0:1").to_s)
		assert_equal("1:0:1::1", NetAddr::IPv6.parse("1:0:1:0:0:0:0:1").to_s)
		assert_equal("1:0:0:1::1", NetAddr::IPv6.parse("1:0:0:1:0:0:0:1").to_s)
		assert_equal("1::1:0:0:1", NetAddr::IPv6.parse("1:0:0:0:1:0:0:1").to_s)
		assert_equal("1::1:0:1", NetAddr::IPv6.parse("1:0:0:0:0:1:0:1").to_s)
		assert_equal("1::1:1", NetAddr::IPv6.parse("1:0:0:0:0:0:1:1").to_s)
	end

end
