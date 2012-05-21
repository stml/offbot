class ProjectsController < ApplicationController

  def index
    raise NotPermitted unless current_person.is_superadmin?
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    raise NotPermitted unless @project.viewable_by?(current_person)

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

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        invite_or_add_people
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @project = Project.find(params[:id])
    raise NotPermitted unless @project.viewable_by?(current_person)
  end

  def update
    @project = Project.find(params[:id])
    raise NotPermitted unless @project.viewable_by?(current_person)
    params[:frequency] == @project.frequency ? changed_frequency = true : changed_frequency = true

    respond_to do |format|
      if @project.update_attributes(params[:project])
        invite_or_add_people
        if changed_frequency
          regenerate_schedule_for_everyone
        end
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
    raise NotPermitted unless @project.manageable_by?(current_person)
    @project.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def confirm_delete
    @project = Project.find(params[:id])
    raise NotPermitted unless @project.manageable_by?(current_person)

    respond_to do |format|
      format.html 
    end
  end

  def my_index
    @projects = current_person.projects

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # rescue_from NotPermitted do |exception|
  #   redirect_to root_path, :alert => exception.message
  # end

  protected

  def regenerate_schedule_for_everyone
    @project.people.each do |person|
      if @project.frequency
        dates = ScheduledRequestsMethods.generate_scheduled_dates(@project.frequency)
      elsif @project.frequency.nil?
        dates = ScheduledRequestsMethods.generate_scheduled_dates(0)
      end
      if dates
        dates.each do |date|
          ScheduledRequestsMethods.create_scheduled_date(person, @project, date)
        end
      end
    end
  end

  def invite_or_add_people
    invitations = params[:emails]
    invitations.each do |invitation|
      person = Person.find_by_email(invitation)
      if person
        unless @project.people.include?(person)
          #unless person == current_person
            person.projects << @project
          #end
        end
      else
        invite = Invitation.find_or_create_by_email(invitation)
        invite.projects << @project
        invite.save
      end
    end
  end

end
