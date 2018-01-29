module Api::V1
  class ApiController < ApplicationController
    rescue_from(ActiveRecord::RecordNotFound) do
      render json: { message: 'Not found' }, status: :not_found
    end

    rescue_from(ActionController::ParameterMissing) do
      render json: { 
        message: "Required parameter missing #{parameter_missing_exception.param}"
      },
      status: :bad_request
    end
  end
end
