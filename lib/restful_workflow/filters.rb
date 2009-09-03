module RestfulWorkflow
  module Filters
    def self.included(base)
      base.before_filter :init_data, :only => [:show, :update]
      base.before_filter :load_current_object, :only => [:show, :update]
      base.prepend_before_filter :load_step, :only => [:show, :update]
      base.prepend_before_filter :init_steps
    end

    def load_step
      @step = self.class.find_step(params[:id])
    end
  
    def init_steps
      self.class.steps.each {|s| s.controller = self }
    end

    def init_data
      @step.eval_deferred_data_class
    end
  
    def load_current_object
      case action_name
      when 'show'
        @current_object = @step.load_data
      when 'update'
        @current_object = @step.data.new(params[:current_object])
      end
      @current_object.controller = self if @current_object.respond_to?(:controller)
    end
  end
end