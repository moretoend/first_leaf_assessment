class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_internal_server_error
  rescue_from ActionController::UnpermittedParameters, with: :render_params_error

  private

  def render_params_error(exception)
    @errors = ["Unpermitted parameters were sent: #{exception.params.join(", ")}"]
    render 'shared/error', status: :unprocessable_entity
  end

  def render_internal_server_error(exception)
    Rails.logger.error(exception.backtrace.join("\n"))
    @errors = ["Something bad happened on our side"]
    render 'shared/error', status: :internal_server_error
  end
end
