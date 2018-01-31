# frozen_string_literal: true

module NokogiriMapper
  class Struct
    @attr_name_to_xml_element = lambda { |name| name }
    @class_name_to_xml_element = lambda { |name| name }

    class << self
      attr_accessor :xml_element,
        :attr_name_to_xml_element,
        :class_name_to_xml_element
      attr_reader :fields

      def string(name, xml_element: attr_name_to_xml_element.call(name))
        field name, StringField.new(name, xml_element)
      end

      def bool(name, xml_element: attr_name_to_xml_element.call(name))
        field name, BoolField.new(name, xml_element)
      end

      def decimal(name, xml_element: attr_name_to_xml_element.call(name))
        field name, DecimalField.new(name, xml_element)
      end

      def enum(name, type, xml_element: attr_name_to_xml_element.call(name))
        field name, EnumField.new(name, type, xml_element)
      end

      def struct(name, type, xml_element: attr_name_to_xml_element.call(name))
        field name, StructField.new(name, type, xml_element)
      end

      def field(name, field)
        attr_reader name
        @fields[name] = field
      end
    end

    %i[fields xml_element].each do |n|
      eval <<-RUBY
        def #{n}
          self.class.#{n}
        end
      RUBY
    end

    def self.inherited(subclass)
      subclass.instance_variable_set("@attr_name_to_xml_element", @attr_name_to_xml_element)
      subclass.instance_variable_set("@class_name_to_xml_element", @class_name_to_xml_element)
      subclass.instance_variable_set("@fields", {})
      subclass.instance_variable_set("@xml_element", @class_name_to_xml_element.call(subclass.name)) if subclass.name
    end

    def initialize(attrs)
      attrs.each do |k, v|
        if fields.key?(k)
          instance_variable_set "@#{k}", fields[k].initialize_convert(v)
        else
          raise ArgumentError, "unknown attribute #{k.inspect}"
        end
      end
    end

    def self.from_xml(xml)
      doc = Nokogiri::XML.parse(xml)
      from_xml_node(doc)
    end

    def self.from_xml_node(parent)
      attrs = {}
      fields.each do |k, f|
        v = f.from_xml_node(parent)
        attrs[k] = v unless v.nil?
      end
      new attrs
    end

    def to_xml
      Nokogiri::XML::Builder.new { |b| to_xml_builder(b) }.to_xml
    end

    def to_xml_builder(parent)
      parent.send(xml_element) do
        fields.each do |k, f|
          f.build_xml(parent, send(k))
        end
      end
    end
  end
end
