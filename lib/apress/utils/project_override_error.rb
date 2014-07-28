# coding: utf-8
class Apress::Utils::ProjectOverrideError < StandardError
  def message
    'Необходимо переопределить метод в проекте'
  end
end