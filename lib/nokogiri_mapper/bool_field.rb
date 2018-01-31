# frozen_string_literal: true

module NokogiriMapper
  class BoolField
    attr_reader :name, :xml_element

    def initialize(name, xml_element)
      @name = name
      @xml_element = xml_element
    end

    def initialize_convert(value)
      return if value.nil?
      !!value
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      if node
        node.text == "1"
      end
    end

    def build_xml(xml, value)
      return if value.nil?
      xml.send(xml_element, value ? "1" : "0")
    end
  end
end
