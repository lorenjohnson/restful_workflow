module RestfulWorkflow
  module Actions

    def index
      first_uncompleted_step = self.class.steps.find {|step| !step.completed? }
      redirect_to :action => "show", :id => (first_uncompleted_step || self.class.steps.first).name
    end
    
    def show
      @step.data_block
      before :show
      render :action => @step.view
    end

    def update
      before :update
      # @validations.attributes_with_forgiveness(params[:current_object])
      params[:current_object]
      @current_object.
      if @validations.valid? && @current_object.update_attributes(params[:current_object])
        redirect_to @step.forward_url
      else
        before :show
        render :action => @step.view
      end
    end

  end
end
