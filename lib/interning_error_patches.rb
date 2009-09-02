# Patches to Rails 2.3.2 to avoid "interning empty string error" when creating an anonymous classes based on AR...
# Monitor Rails Lighthouse ticket # 1926 for solution. Remove this monkey patch once Rails is upgraded 
# and includes a solution to this issue.
# https://rails.lighthouseapp.com/projects/8994/tickets/1926-interning-empty-string

module ActiveRecord
  class Base
    # Rails 2.3.2 interning error patch
    def self.human_name(options = {})
      defaults = self_and_descendants_from_active_record.map do |klass|
        :"#{klass.name.underscore}" unless klass.name.blank?
      end 
      defaults << self.name.humanize
      I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
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

