class MarketingController < ApplicationController
  def index

  end

  def person
  end

  def country
  end

  def company
  end

  def companies
    @companies = Company.all
    render '/marketing/companies/index'
  end

  def people
    if params[:id]
      @person = Person.find_by_id(params[:id])
      render '/marketing/people/show'
    else
      @people = Person.active
      render '/marketing/people/index'
    end
  end


  def project
  end
end
