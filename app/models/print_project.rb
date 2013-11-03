class PrintProject < Prawn::Document

  def to_pdf(project, updates)
    # this looks awful, but hey, generates a basic printout
    text "<font size='24px'><b>#{project.name}</b></font>", inline_format: true
    text "<font size='18px'>Updates: <b>#{updates.length}</b></font>", inline_format: true
    move_down 30
    updates.each do |update|
      indent(0) do
        span(500) do
          text "<font size='16px'><b>#{update.person.name}</b></font>, <font size='16px'><i>#{update.created_at.strftime("%A %d %B, %Y")}</i></font>", inline_format: true
          move_down 10
          text "<font size='14px'>#{update.body}</font>", inline_format: true
        end
        move_down 40
      end
    end
    render
  end

end
