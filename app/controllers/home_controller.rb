class HomeController < ApplicationController
  allow_unauthenticated_access

  def show
    render "landings/show" unless authenticated?
  end
end
