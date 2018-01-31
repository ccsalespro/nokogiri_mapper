# frozen_string_literal: true

module NokogiriMapper
  class StringField
    attr_reader :name, :xml_element

    def initialize(name, xml_element)
      @name = name
      @xml_element = xml_element
    end

    def initialize_convert(value)
      return if value.nil?
      value.to_s
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      node.text if node
    end

    def build_xml(xml, value)
      return if value.nil?
      xml.send(xml_element, value)
    end
  end
end
