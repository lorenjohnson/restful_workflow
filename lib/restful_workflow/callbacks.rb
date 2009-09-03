module RestfulWorkflow
  module Callbacks
    def before(cb)
      block = @step.before(cb)
      instance_eval &block if block
    end

    def after(cb)
      block = @step.after(cb)
      instance_eval &block if block
    end
  end
end