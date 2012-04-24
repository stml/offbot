class ProjectsController < ApplicationController
  ## Exception Handling
  class ProjectAccessNotPermitted < StandardError
  end

  class ProjectIndexNotPermitted < StandardError
  end

  def index
    raise ProjectIndexNotPermitted unless current_person.is_superadmin?
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    raise ProjectAccessNotPermitted unless @project.viewable_by?(current_person)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
    raise ProjectAccessNotPermitted unless @project.viewable_by?(current_person)
  end

  def update
    @project = Project.find(params[:id])
    raise ProjectAccessNotPermitted unless @project.viewable_by?(current_person)

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    raise ProjectIndexNotPermitted unless current_person.is_superadmin?
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def my_index
    @projects = Person.find(current_person.id).projects
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  rescue_from ProjectAccessNotPermitted, :with => :access_not_permitted
  rescue_from ProjectIndexNotPermitted, :with => :index_not_permitted

  # rescue_from NotPermitted do |exception|
  #   redirect_to root_path, :alert => exception.message
  # end

  def access_not_permitted(exception)
    redirect_to root_path, :alert => "Oi, you're not on that project! You ought to learn some manners."
  end

  def index_not_permitted(exception)
    redirect_to root_path, :alert => "Oi, you're not a superadmin! Can't look at that."
  end
end
