require 'spec_helper'

class ApplicationController < ActionController::Base; end

describe ApplicationController, type: :controller do

  it do
    controller.flash[:error] = 'error'

    expect(controller.flash[:error]).to eq 'error'
    expect(controller.flash.key?(:error)).to be true
  end
end
