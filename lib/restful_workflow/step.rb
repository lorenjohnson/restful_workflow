module RestfulWorkflow
  class Step
    attr_accessor :stage, :name, :controller, :view

    def initialize(name, stage, *args)
      @name = name
      @view = name
      @stage = stage
      @in_menu = true
      @before_callbacks = {}
      @after_callbacks = {}
      initialize_data_class
    end
  
    def view(new_val=nil)
      @view = new_val if new_val
      @view
    end

    def controller_class
      stage.controller_class
    end

    def before(symbol, &block)
      if block_given?
        @before_callbacks[symbol.to_sym] = block
      end
      @before_callbacks[symbol.to_sym]
    end

    def after(symbol, &block)
      if block_given?
        @after_callbacks[symbol.to_sym] = block
      end
      @after_callbacks[symbol.to_sym]
    end

    def completed?
      load_data.valid?
    end

    def load_data
      attributes = controller.params[:current_object] rescue nil
      if attributes && controller.params[:current_object][:id]
        @data.find(controller.params[:current_object][:id])
      elsif controller.session[:current_interview_id]
        @data.find(controller.session[:current_interview_id])
      else
        @data.new
      end
    end

    def forward(value=nil, &block)
      raise ArgumentError, "Value or block required" unless value || block_given?
      @forward = if value
        case value
        when Symbol
          { :id => value.to_s }
        else
          value
        end
      else
        block
      end
    end

    def forward_url
      if @forward
        url = @forward.respond_to?(:call) ? controller.instance_eval(&@forward) : @forward
        url = { :id => url } if url.kind_of?(Symbol)
      end
      url || { :id => (next_step || self).name } 
    end
  
    def back(value=nil, &block)
      raise ArgumentError, "Value or block required" unless value || block_given?
      @back = if value
        case value
        when Symbol
          { :id => value.to_s }
        else
          value
        end
      else
        block
      end
    end

    def back_url
      if @back
        url = @back.respond_to?(:call) ? controller.instance_eval(&@back) : @back
        url = { :id => url } if url.kind_of?(Symbol)
      end
      url || { :id => (previous_step || self).name }
    end
  
    def first?
      controller_class.steps.first == self
    end

    def last?
      controller_class.steps.last == self
    end
  
    def method_missing(method, *args, &block)
      case method.to_s
      when /^before_/
        before method.to_s.sub(/^before_/, ''), &block
      when /^after_/
        after method.to_s.sub(/^after_/, ''), &block
      else
        super
      end
    end
  
    private

    def initialize_data_class
      @data = Class.new(Interview)
    end

    def next_step
      unless last?
        controller_class.steps[controller_class.steps.index(self) + 1]
      end
    end
  
    def previous_step
      unless first?
        controller_class.steps[controller_class.steps.index(self) - 1]
      end
    end

  end
end