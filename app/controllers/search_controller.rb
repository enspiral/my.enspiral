class SearchController < IntranetController
  def index
    @people = Person.search(params[:search], star: true)
    @invoices = Invoice.search(params[:search], star: true)
    @projects = Project.search(params[:search], star: true)
  end
end
