module RestfulWorkflow
  module DSL
    def self.extended(base)
      base.class_inheritable_accessor :workflow_active
      base.workflow_active = false
    end

    def stage
      raise ArgumentError, "Block required!" unless block_given?
      raise "Workflow already defined for this controller!" if workflow_active
      class_inheritable_accessor :steps
      self.steps = []
      extend SingletonMethods
      include Actions
      include Filters
      include Callbacks
      attr_reader :current_object
      helper ::RestfulWorkflow::Helpers
      yield Stage.new(self)
      self.workflow_active = true
      self
    end
  end
end
