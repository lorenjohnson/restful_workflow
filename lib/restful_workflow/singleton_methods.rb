module RestfulWorkflow
  module SingletonMethods
    def find_step(name)
      self.steps.find { |s| s.name == name }
    end
  end
end