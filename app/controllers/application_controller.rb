class ApplicationController < ActionController::API
  rescue_from ActionController::UnpermittedParameters, with: :render_params_error

  private

  def render_params_error(exception)
    @errors = ["Unpermitted parameters were sent: #{exception.params.join(", ")}"]
    render 'shared/error', status: :unprocessable_entity
  end
end
