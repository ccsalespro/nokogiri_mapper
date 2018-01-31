# frozen_string_literal: true

module NokogiriMapper
  class StructField
    attr_reader :name, :type, :xml_element

    def initialize(name, type, xml_element)
      @name = name
      @type = type
      @xml_element = xml_element
    end

    def initialize_convert(value)
      value
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      type.from_xml_node(node) if node
    end

    def to_xml_builder(xml, value)
      return if value.nil?
      value.to_xml_builder(xml)
    end
  end
end
