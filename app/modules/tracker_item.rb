module TrackerItem
  extend ActiveSupport::Concern

  module ClassMethods
    def object_from_xml(xml)
      new(attrs_from_xml(xml))
    end

    def attrs_from_xml(xml)
      return [{}] if xml.nil? or xml.children.first.nil?
      objs = xml.children.first.children.present? ? xml.children.first.children : [xml.children.first]
      objs.map{|obj| parse_xml_attrs(obj)}
    end

    private
    def parse_xml_attrs(xml)
      attrs = {}
      xml.children.each { |data| attrs[data.attr('name').try(:underscore)] = data.inner_text}
      xml.attributes.each{ |key, value| attrs[key.underscore] = value.inner_text }
      attrs["#{self.name.underscore.split('/').last}_id"] =  attrs.delete('id')

      allowed_attributes = new.attributes.keys
      attrs.select{|key,value| allowed_attributes.include?(key)}
    end

  end

end