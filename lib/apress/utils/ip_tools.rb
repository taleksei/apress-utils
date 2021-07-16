# -*- encoding : utf-8 -*-
# frozen_string_literal: true
module Apress::Utils
  module IpTools
    require 'socket'
    require 'resolv'
    require 'ipaddr'

    class << self
      def internal_ips
        @internal_ips ||= Socket.ip_address_list.map do |addr|
          addrinfo2ipaddr(addr)
        end
      end

      def internal_ips_v4
        @internal_ips_v4 ||= Socket.ip_address_list.inject([]) do |addrs, addr| 
          if addr.ipv4? and !addr.ipv4_loopback? and !addr.ipv4_multicast?
            addrs << addrinfo2ipaddr(addr)
          end
          addrs  
        end
      end

      def internal_ips_v6
        @internal_ips_v6 ||= Socket.ip_address_list.inject([]) do |addrs, addr| 
          if addr.ipv6? and !addr.ipv6_loopback? and !addr.ipv6_multicast?
            addrs << addrinfo2ipaddr(addr)
          end
          addrs  
        end
      end

      def internal_ip_v4
        @internal_ip_v4 ||= internal_ips_v4.first
      end
      alias_method :internal_ip, :internal_ip_v4

      def internal_ip_v6
        @internal_ip_v6 ||= internal_ips_v6.first
      end

      def external_ips
        @external_ips ||= Resolv.getaddresses(HOST).map do |addr|
          IPAddr.new(addr)
        end
      end

      def external_ip
        external_ips.first
      end

      private

      def addrinfo2ipaddr(addr)
        raise ArgumentError unless addr.is_a?(Addrinfo)
        IPAddr.new(addr.ip_address.sub(/\%.*$/, ''))
      end
    end  
  end
end