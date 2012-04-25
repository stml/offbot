class UpdatesController < ApplicationController
  def index
    raise NotPermitted unless current_person.is_superadmin?
    @updates = Update.all

    respond_to do |format|
      format.html 
    end
  end

  def show
    @update = Update.find(params[:id])
    raise NotPermitted unless @update.viewable_by?(current_person)

    respond_to do |format|
      format.html 
    end
  end

  def new
    @update = Update.new

    respond_to do |format|
      format.html 
    end
  end

  def edit
    @update = Update.find(params[:id])
    raise NotPermitted unless @update.editable_by?(current_person)
  end

  def create
    @update = Update.new(params[:update])
    @person = current_person
    @person.updates << @update

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, notice: 'Update was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @update = Update.find(params[:id])
    raise NotPermitted unless @update.editable_by?(current_person)

    respond_to do |format|
      if @update.update_attributes(params[:update])
        format.html { redirect_to @update, notice: 'Update was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @update = Update.find(params[:id])
    raise NotPermitted unless @update.editable_by?(current_person)
    @update.destroy

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def my_index
    @updates = current_person.updates

    respond_to do |format|
      format.html
    end
  end
end
