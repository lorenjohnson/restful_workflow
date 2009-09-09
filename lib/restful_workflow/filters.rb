module RestfulWorkflow
  module Filters
    def self.included(base)
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

    def load_current_object
      @current_object = @step.load_data
    end
  end
end