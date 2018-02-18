class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:show]
  before_action :set_form, only: [:show, :update]

  def index
    @forms = current_api_v1_user.forms
    render json: @forms.to_json
  end

  def show
    status = @form.enable? ? 200 : 404
    render json: @form, include: :questions, status: status
  end

  def update
    @form.update(form_params)
    render json: @form, status: 200
  end

  def create
  end

  def destroy
  end

  private

  def set_form
    @form = Form.friendly.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:title, :description, :enable, :primary_color)
                          .merge(user: current_api_v1_user)
  end
end
