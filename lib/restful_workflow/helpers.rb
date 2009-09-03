module RestfulWorkflow
  module Helpers
    def link_forward(contents)
      link_to contents, @step.forward_url
    end
  
    def link_back(contents)
      link_to contents, @step.back_url
    end
    
    def back_url
      @step.back_url
    end
    
    def forward_url
      @step.forward_url
    end
    
    def object_path
      url_for :controller => @step.controller.controller_name, :action => "update"
    end

    def each_step(&block)
      @controller.class.steps.each {|step|
        step.controller = @controller
        yield step
      }
    end
  end
end