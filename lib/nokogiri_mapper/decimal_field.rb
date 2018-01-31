# frozen_string_literal: true

require 'bigdecimal'

module NokogiriMapper
  class DecimalField
    attr_reader :name, :xml_element

    def initialize(name, xml_element)
      @name = name
      @xml_element = xml_element
    end

    def initialize_convert(value)
      return if value.nil?
      BigDecimal(value)
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      if node
        BigDecimal(node.text)
      end
    end

    def build_xml(xml, value)
      return if value.nil?
      s = value.round(2).to_s("F")
      s << "0" if s[-2] == "." # dddd.dd is required
      xml.send(xml_element, s)
    end
  end
end
