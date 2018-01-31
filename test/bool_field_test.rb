require "test_helper"

class BoolFieldTest < Minitest::Test
  def test_from_xml_node
    bool_field = NokogiriMapper::BoolField.new "alive", "alive", true_strings: ["yes"], false_strings: ["no"]

    doc = Nokogiri::XML.parse("<record><alive>yes</alive></record>")
    assert bool_field.from_xml_node(doc)

    doc = Nokogiri::XML.parse("<record><alive>no</alive></record>")
    refute bool_field.from_xml_node(doc)
  end

  def test_build_xml
    bool_field = NokogiriMapper::BoolField.new "alive", "alive", true_strings: ["yes"], false_strings: ["no"]

    builder = Nokogiri::XML::Builder.new { |xml|
      xml.record {
        bool_field.build_xml xml, true
      }
    }

    expected_xml = <<-XML
<?xml version="1.0"?>
<record>
  <alive>yes</alive>
</record>
    XML

    assert_equal expected_xml, builder.to_xml

    builder = Nokogiri::XML::Builder.new { |xml|
      xml.record {
        bool_field.build_xml xml, false
      }
    }

    expected_xml = <<-XML
<?xml version="1.0"?>
<record>
  <alive>no</alive>
</record>
    XML

    assert_equal expected_xml, builder.to_xml
  end
end
