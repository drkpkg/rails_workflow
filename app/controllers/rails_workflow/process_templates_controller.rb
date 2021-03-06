module RailsWorkflow
  class ProcessTemplatesController < ::ActionController::Base
    layout 'rails_workflow/application'
    respond_to :html

    before_action :set_process_template, only: [:show, :edit, :update, :destroy]

    before_filter do
      @config_section_active = true
    end


    def index
      @process_templates = ProcessTemplateDecorator.
          decorate_collection(process_templates_collection)

      respond_with(@process_templates)
    end


    def new
      @process_template = ProcessTemplate.new(permitted_params).decorate
      respond_with @process_template
    end


    def create
      @process_template = ProcessTemplate.create(permitted_params)
      redirect_to process_template_operation_templates_path(@process_template)
    end

    def update
      @process_template.update(permitted_params)
      redirect_to process_template_url(@process_template)
    end

    def destroy
      @process_template.destroy
      redirect_to process_templates_url
    end

    protected
    def permitted_params
      params.permit(
          process_template: [
              :title,
              :source,
              :manager_class,
              :partial_name,
              :process_class,
              :type
          ]
      )[:process_template]
    end

    def set_process_template
      @process_template = ProcessTemplate.find(params[:id]).decorate
    end

    def process_templates_collection
      ProcessTemplate.
          order(id: :desc)
    end

  end
end
