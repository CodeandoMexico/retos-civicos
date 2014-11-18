module Dashboard
  class JudgesController < Dashboard::BaseController
    before_filter :require_current_challenge, only: [:index, :new, :create]
    before_filter :set_current_challenge

    def index
      @challenges = organization.challenges.
        order('created_at DESC')
      @judges = current_challenge_judges
    end

    def new
      @user = User.new
    end

    def create
      if judge_already_exists
        @judge_challenges = @judge.challenges
        render :request_permission_for_challenge
      elsif create_new_user
        current_challenge.evaluations.create(judge_id: @user.userable.id)
        redirect_to dashboard_judges_path, notice: t('flash.judge.saved_successfully')
      else
        render :new
      end
    end

    private

    def current_challenge_judges
      current_challenge.judges.order('created_at DESC')
    end

    def set_current_challenge
      @current_challenge = current_challenge
    end

    def judge_already_exists
      @user = User.find_by_email(params[:user][:email])
      @judge = @user.userable if @user.judge?
    end

    def create_new_user
      @user = User.new(params[:user])
      @user.password = @user.email
      @user.userable = Judge.new
      @user.save
    end
  end
end
