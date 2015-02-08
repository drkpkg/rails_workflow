module Workflow
  class Operation < ActiveRecord::Base
    include OperationStatus

    include Operations::DefaultRunner
    include Operations::Dependencies
    include Operations::Assignments

    belongs_to :process, class_name: "Workflow::Process"
    belongs_to :template, class_name: "Workflow::OperationTemplate"
    belongs_to :child_process, class_name: "Workflow::Process"
    has_one :context, class_name: "Workflow::Context", as: :parent
    has_many :workflow_errors, class_name: "Workflow::Error", as: :parent

    delegate :data, to: :context
    delegate :role, to: :template
    delegate :group, to: :template

    scope :with_child_process, -> { where.not(child_process: nil) }
    scope :incompleted, -> { where(status: user_ready_statuses) }

    def instruction
      self.template.instruction
    end

    def manager
      @manager ||= process.manager
    end

    def manager= manager
      @manager = manager
    end

  end
end
