#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestMask32 < Test::Unit::TestCase
	def test_new
		m32 = NetAddr::Mask32.new(24)
		assert_equal("/24", m32.to_s)
		assert_equal(0xffffff00, m32.mask)
		
		assert_raise(NetAddr::ValidationError){ NetAddr::Mask32.new(-1) }
		assert_raise(NetAddr::ValidationError){ NetAddr::Mask32.new(33) }
		assert_raise(NetAddr::ValidationError){ NetAddr::Mask32.new("/24") }
	end
end