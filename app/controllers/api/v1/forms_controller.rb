class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:show]

  def index
    @forms = current_api_v1_user.forms
    render json: @forms.to_json
  end

  def show
  end

  def update
  end

  def create
  end

  def destroy
  end
end
