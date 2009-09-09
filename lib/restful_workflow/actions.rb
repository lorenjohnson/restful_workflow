module RestfulWorkflow
  module Actions

    def index
      first_uncompleted_step = self.class.steps.find {|step| !step.completed? }
      redirect_to :action => "show", :id => (first_uncompleted_step || self.class.steps.first).name
    end
    
    def show
      before :show
      render :action => @step.view
    end

    def update
      before :update
      params[:current_object]
      if @current_object.update_attributes(params[:current_object])
        redirect_to @step.forward_url
      else
        before :show
        render :action => @step.view
      end
    end

  end
end