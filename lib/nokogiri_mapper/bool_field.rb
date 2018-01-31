# frozen_string_literal: true

module NokogiriMapper
  class BoolField
    attr_reader :name, :xml_element, :true_strings, :false_strings

    def initialize(name, xml_element, true_strings: ["1", "true"], false_strings: ["0", "false"])
      @name = name
      @xml_element = xml_element
      @true_strings = Array(true_strings)
      @false_strings = Array(false_strings)
    end

    def initialize_convert(value)
      return if value.nil?
      !!value
    end

    def from_xml_node(parent)
      node = parent.at(xml_element)
      if node
        true_strings.include?(node.text)
      end
    end

    def build_xml(xml, value)
      return if value.nil?
      xml.send(xml_element, value ? true_strings.first : false_strings.first)
    end
  end
end
