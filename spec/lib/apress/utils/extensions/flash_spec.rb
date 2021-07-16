# frozen_string_literal: true
require 'spec_helper'

class ApplicationController < ActionController::Base
  def show
    redirect_to('', flash: {error: 'error'})
  end
end

describe ApplicationController, type: :controller do
  it do
    controller.flash[:error] = 'error'

    expect(controller.flash[:error]).to eq 'error'
    expect(controller.flash.key?(:error)).to be true
  end

  it do
    get :show

    expect(controller.flash[:error]).to eq 'error'
    expect(controller.flash.key?(:error)).to be true
  end
end
