class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_error
    {
      errors: [
        {
          status: @error.status,
          message: @error.message,
          code: @error.code
        }
      ]
    }
  end
end