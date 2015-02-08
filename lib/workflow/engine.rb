module Workflow
  class Engine < ::Rails::Engine
    isolate_namespace Workflow

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    # initializer "workflow.url_helpers" do
    #   ActiveSupport.on_load(:action_controller) do
    #     helper Rails.application.routes.url_helpers
    #   end
    # end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
