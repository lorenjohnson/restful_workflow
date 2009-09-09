class ParentHelpForm < ActiveForm
  cattr_accessor :controller, :current_interview
  # def save
  #   if valid?
  #     self.attributes.each do |k,v|
  #       answer = current_interview.interview_answers.find_or_create_by_interview_question_id(
  #         InterviewQuestion.find_or_create_by_code(k).id
  #       )
  #       answer.update_attribute(:answer, v)
  #     end
  #   end
  # end

  def create_attr_accessors(attribs_to_create={})
    attribs_to_create.each do |k,v|
      class_eval("attr_accessor #{k.intern}"
      eval("#{k} = #{v}")
    end
  end
  
  def method_missing(method, *args, &block)
    self.class_eval("attr_accessor #{method}")
  end

end