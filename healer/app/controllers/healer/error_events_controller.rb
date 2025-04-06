class Healer::ErrorEventsController < ApplicationController
  before_action :healer_error_event, only: %i[show edit update destroy]

  # GET /healer/error_events or /healer/error_events.json
  def index
    @healer_error_events = ::Healer::ErrorEvent.all
  end

  # GET /healer/error_events/1 or /healer/error_events/1.json
  def show
  end

  # GET /healer/error_events/new
  def new
  end

  # GET /healer/error_events/1/edit
  def edit
  end

  # POST /healer/error_events or /healer/error_events.json
  def create
    respond_to do |format|
      if @healer_error_event.save
        format.html { redirect_to @healer_error_event, notice: "Error event was successfully updated." }
        format.json { render :show, status: :created, location: @healer_error_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @healer_error_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /healer/error_events/1 or /healer/error_events/1.json
  def update
    respond_to do |format|
      if ::Healer::DynamicMethod::Create.call(healer_error_event: @healer_error_event)
        format.html { redirect_to resolution_path, notice: "Error event was successfully resolved." }
        format.json { render :show, status: :ok, location: @healer_error_event }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: "Error event could not be resolved." }
        format.json { render json: @healer_error_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /healer/error_events/1 or /healer/error_events/1.json
  def destroy
    @healer_error_event.destroy!

    respond_to do |format|
      format.html { redirect_to healer_error_events_path, status: :see_other, notice: "Error event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def resolution_path
      path_from_controller_action(healer_error_event.class_name, healer_error_event.method_name)
    end

    # Use callbacks to share common setup or constraints between actions.
    def healer_error_event
      @healer_error_event ||= Healer::ErrorEvent.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def healer_error_event_params
      params.fetch(:healer_error_event, {})
    end
end
