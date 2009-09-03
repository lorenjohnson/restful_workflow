module RestfulWorkflow
  class Stage
    attr_accessor :controller_class
    def initialize(controller_class)
      @controller_class = controller_class
    end

    def method_missing(method, *args, &block)
      step = Step.new(method.to_s, self, *args)
      controller_class.steps << step
      step.instance_eval(&block) if block_given?
      step
    end
  end
end