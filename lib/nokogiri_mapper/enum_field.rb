# frozen_string_literal: true

module NokogiriMapper
  class EnumField
    attr_reader :name, :type, :xml_element

    def initialize(name, type, xml_element)
      @name = name
      @type = type
      @xml_element = xml_element
    end

    def initialize_convert(value)
      return if value.nil?
      type[value]
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      if node
        type[node.text]
      end
    end

    def to_xml_builder(xml, value)
      return if value.nil?
      xml.send(xml_element, value.value)
    end
  end
end
