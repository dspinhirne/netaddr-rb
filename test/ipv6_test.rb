#!/usr/bin/ruby

require_relative "../lib/netaddr.rb"
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
		
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("fe80::1::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("::fe80::") }
		assert_raise(NetAddr::ValidationError){ NetAddr::IPv6.parse("0:0:0:0:0:0:0:0:1") }
		assert_equal(1, NetAddr::IPv6.parse("::0:0:0:0:0:0:1").addr)
		assert_equal(0x00010002000300040005000600070008, NetAddr::IPv6.parse("1:2:3:4:5:6:7:8").addr)
		assert_equal(0x00010002000300040005000600070000, NetAddr::IPv6.parse("1:2:3:4:5:6:7::").addr)
		assert_equal(0x00010002000300040005000600000000, NetAddr::IPv6.parse("1:2:3:4:5:6::").addr)
		assert_equal(0x00010002000300040005000000000000, NetAddr::IPv6.parse("1:2:3:4:5::").addr)
		assert_equal(0x00010002000300040000000000000000, NetAddr::IPv6.parse("1:2:3:4::").addr)
		assert_equal(0x00010002000300000000000000000000, NetAddr::IPv6.parse("1:2:3::").addr)
		assert_equal(0x00010002000000000000000000000000, NetAddr::IPv6.parse("1:2::").addr)
		assert_equal(0x00010000000000000000000000000000, NetAddr::IPv6.parse("1::").addr)
		assert_equal(0x00000000000000000000000000000001, NetAddr::IPv6.parse("::1").addr)
		assert_equal(0x00000000000000000000000000010002, NetAddr::IPv6.parse("::1:2").addr)
		assert_equal(0x00000000000000000000000100020003, NetAddr::IPv6.parse("::1:2:3").addr)
		assert_equal(0x00000000000000000001000200030004, NetAddr::IPv6.parse("::1:2:3:4").addr)
		assert_equal(0x00000000000000010002000300040005, NetAddr::IPv6.parse("::1:2:3:4:5").addr)
		assert_equal(0x00000000000100020003000400050006, NetAddr::IPv6.parse("::1:2:3:4:5:6").addr)
		assert_equal(0x00000001000200030004000500060007, NetAddr::IPv6.parse("::1:2:3:4:5:6:7").addr)
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
	
	def test_to_net
		ip = NetAddr::IPv6.parse("1::")
		net = NetAddr::IPv6Net.parse("1::")
		assert_equal(0, net.cmp(ip.to_net()))
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
