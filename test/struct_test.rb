require "test_helper"

class StructTest < Minitest::Test
  def test_simple_from_xml
    person_klass = Class.new(NokogiriMapper::Struct) do
      string :first_name
      string :last_name
    end

    person = person_klass.from_xml(<<-XML)
<person>
  <first_name>John</first_name>
  <last_name>Smith</last_name>
</person>
    XML

    assert_equal "John", person.first_name
    assert_equal "Smith", person.last_name
  end

  def test_simple_to_xml
    person_klass = Class.new(NokogiriMapper::Struct) do
      self.xml_element = "person"
      string :first_name
      string :last_name
    end

    person = person_klass.new first_name: "John", last_name: "Smith"

    expected_xml = <<-XML
<?xml version=\"1.0\"?>
<person>
  <first_name>John</first_name>
  <last_name>Smith</last_name>
</person>
    XML

    assert_equal expected_xml, person.to_xml
  end

  def test_custom_attr_name_to_xml_element_converter
    person_klass = Class.new(NokogiriMapper::Struct) do
      self.attr_name_to_xml_element = lambda { |s| s.upcase }
      string :first_name
      string :last_name
    end

    person = person_klass.from_xml(<<-XML)
<person>
  <FIRST_NAME>John</FIRST_NAME>
  <LAST_NAME>Smith</LAST_NAME>
</person>
    XML

    assert_equal "John", person.first_name
    assert_equal "Smith", person.last_name
  end

  def test_builtin_field_helpers
    colors = MetaEnum::Type.new red: 0, green: 1, blue: 2

    person_class = Class.new(NokogiriMapper::Struct) do
      self.xml_element = "person"
      string :first_name
      string :last_name
    end

    record_class = Class.new(NokogiriMapper::Struct) do
      bool :a_bool
      decimal :a_decimal
      enum :a_enum, colors
      string :a_string
      struct :a_struct, person_class
    end

    record = record_class.from_xml(<<-XML)
<record>
  <a_bool>1</a_bool>
  <a_decimal>1.23</a_decimal>
  <a_enum>2</a_enum>
  <a_string>Hi</a_string>
  <a_struct>
    <first_name>John</first_name>
    <last_name>Smith</last_name>
  </a_struct>
</record>
    XML

    assert_equal true, record.a_bool
    assert_equal BigDecimal("1.23"), record.a_decimal
    assert_equal colors[:blue], record.a_enum
    assert_equal "Hi", record.a_string
    assert_equal "John", record.a_struct.first_name
    assert_equal "Smith", record.a_struct.last_name
  end
end
