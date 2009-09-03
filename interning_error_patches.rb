# Patches to Rails 2.3.2 to avoid "interning empty string error" when creating an anonymous classes based on AR...
# Monitor Rails Lighthouse ticket # 1926 for solution. Remove this monkey patch once Rails is upgraded 
# and includes a solution to this issue.
# https://rails.lighthouseapp.com/projects/8994/tickets/1926-interning-empty-string

# Rails 2.3.2 interning error patches to ActiveRecord::Base
module ActiveRecord
  class Base
    class << self
      # Transforms attribute key names into a more humane format, such as "First name" instead of "first_name". Example:
      #   Person.human_attribute_name("first_name") # => "First name"
      # This used to be depricated in favor of humanize, but is now preferred, because it automatically uses the I18n
      # module now.
      # Specify +options+ with additional translating options.
      def human_attribute_name(attribute_key_name, options = {})
        defaults = self_and_descendants_from_active_record.map do |klass|
          :"#{klass.name.underscore}.#{attribute_key_name}" unless klass.name.blank?
        end
        defaults << options[:default] if options[:default]
        defaults.flatten!
        defaults << attribute_key_name.humanize
        options[:count] ||= 1
        I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :attributes]))
      end

      # Transform the modelname into a more humane format, using I18n.
      # Defaults to the basic humanize method.
      # Default scope of the translation is activerecord.models
      # Specify +options+ with additional translating options.
      def human_name(options = {})
        defaults = self_and_descendants_from_active_record.map do |klass|
          :"#{klass.name.underscore}" unless klass.name.blank?
        end 
        defaults << self.name.humanize
        I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
      end
    end
  end
end

module I18n
  class << self
    def normalize_translation_keys(locale, key, scope)
      keys = [locale] + Array(scope) + [key]
      keys = keys.map { |k| k.to_s.split(/\./) if k}
      keys.flatten.map { |k| k.to_sym if k && !k.blank?}
    end
  end
end



