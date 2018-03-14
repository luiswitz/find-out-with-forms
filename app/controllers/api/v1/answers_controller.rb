class Api::V1::AnswersController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:create]
  before_action :set_answer, only: [:show]
  before_action :set_form
  before_action :allow_only_user, only: [:index]

  def index
    @answers = @form.answers
    render json: @answers, status: 200
  end

  def show
    render json: @answer, include: :questions_answers, status: 200
  end

  def create
    @answer = Answer.create_with_questions(@form, params[:questions_answers])
    render json: @answer, status: 200
  end

  def destroy
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_form
    @form = @answer ? @answer.form : Form.find(params[:form_id])
  end

  def allow_only_user
    unless current_api_v1_user == @form.user
      render(json: {}, status: :forbiden) and return
    end
  end
end
