class Admin::CompanyMembershipsController < CompanyMembershipsController
  before_filter :require_admin
  before_filter :admin_load_objects
  skip_before_filter :load_membership
  before_filter :load_membership, only: [:edit, :update, :show, :destroy]
  helper_method :new_path, :new_person_path, :show_path, :edit_path, :index_path

  protected
  def new_path
    new_admin_enspiral_company_net_company_company_membership_path(@company)
  end

  def new_person_path
    new_person_admin_enspiral_company_net_company_company_memberships_path(@company)
  end

  def show_path(company_membership)
    admin_enspiral_company_net_company_company_membership_path(@company, company_membership)
  end

  def edit_path(company_membership)
    edit_admin_enspiral_company_net_company_company_membership_path(@company, company_membership)
  end

  def index_path
    admin_enspiral_company_net_company_company_memberships_path(@company)
  end
end
