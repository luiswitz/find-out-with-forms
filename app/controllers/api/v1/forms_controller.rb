class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:show]
  before_action :set_form, only: [:show]

  def index
    @forms = current_api_v1_user.forms
    render json: @forms.to_json
  end

  def show
    status = @form.enable? ? 200 : 404
    render json: @form, include: 'questions', status: status
  end

  def update
  end

  def create
  end

  def destroy
  end

  private

  def set_form
    @form = Form.friendly.find(params[:id])
  end
end
