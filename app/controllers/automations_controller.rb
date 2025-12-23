class AutomationsController < ApplicationController
  before_action :require_pro_access!
  before_action :set_automation, only: [ :edit, :update, :destroy, :toggle ]

  def index
    @automations = Current.user.workspace.automations.order(created_at: :desc)
  end

  def new
    @automation = Current.user.workspace.automations.new
  end

  def create
    @automation = Current.user.workspace.automations.new(automation_params)
    @automation.next_run_at = @automation.calculate_next_run

    if @automation.save
      redirect_to automations_path, notice: "Automation created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @automation.update(automation_params)
      @automation.update(next_run_at: @automation.calculate_next_run)
      redirect_to automations_path, notice: "Automation updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @automation.destroy
    redirect_to automations_path, notice: "Automation deleted successfully!"
  end

  def toggle
    @automation.update(enabled: !@automation.enabled)
    @automation.update(next_run_at: @automation.calculate_next_run) if @automation.enabled?
    redirect_to automations_path, notice: "Automation #{@automation.enabled? ? 'enabled' : 'disabled'}!"
  end

  private

  def set_automation
    @automation = Current.user.workspace.automations.find(params[:id])
  end

  def automation_params
    params.require(:automation).permit(:name, :automation_type, :config)
  end
end
