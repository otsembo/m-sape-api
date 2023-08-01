# frozen_string_literal: true
class AppError
  attr_accessor :errors
  def initialize(message)
    @errors = []
    @errors << message
  end

end
