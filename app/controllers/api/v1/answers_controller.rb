class Api::V1::AnswersController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_form
  before_action :allow_only_user, only: [:index]

  def index
    @answers = @form.answers
    render json: @answers, status: 200
  end

  def show
  end

  def create
  end

  def destroy
  end

  private

  def set_form
    @form = @answer ? @answer.form : Form.find(params[:form_id])
  end

  def allow_only_user
    unless current_api_v1_user == @form.user
      render(json: {}, status: :forbiden) and return
    end
  end
end
