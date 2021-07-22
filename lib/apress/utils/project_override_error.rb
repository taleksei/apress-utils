# frozen_string_literal: true
class Apress::Utils::ProjectOverrideError < StandardError
  def message
    'Необходимо переопределить метод в проекте'
  end
end