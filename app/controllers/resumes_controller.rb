class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def parse_entry
    @resumes = Resume.all.sort
    @resume = @resumes.last
    list_invalid = []
    list_valid = []
    # if @resume.attachment
    #   render "layouts/index"
    # end

    sheet = Roo::Excelx.new("public/#{@resume.attachment.to_s}")
    sheet.each_row_streaming do |row|
      puts "#{row[0]} , #{row[1]} , #{row[2]}"
      if not (row[0].to_s.eql? "first_name" and row[1].to_s.eql? "last_name" and row[2].to_s.eql? "email")
        @user = User.new
        # create string for remove spe char
        fn = row[0].to_s.gsub(/[\p{Latin}]*/, '')
        ln = row[1].to_s.gsub(/[\p{Latin}]*/, '')
        e = row[2].to_s.gsub(/[\p{Latin},@.]*/, '')
        @user.first_name = row[0].to_s
        @user.first_name.delete! fn.titleize
        @user.last_name = row[1].to_s
        @user.last_name.delete! ln.titleize
        @user.email = row[2]
        @user.email.delete! e
        if @user.valid?
          @user.save
          list_valid << @user.first_name << @user.last_name << @user.email
          # list_valid << row[0].to_s << row[1].to_s << row[2].to_s
        else
          list_invalid << row[0].to_s << row[1].to_s << row[2].to_s << @user.errors.messages
        end
      end

    end
     render "layouts/upload", locals: { fail: list_invalid, success: list_valid }

  end

  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new(resume_params)

    if @resume.save
      redirect_to resumes_parse_entry_path
      # redirect_to resume_path, notice: "The resume #{@resume.name}  has been uploaded."

    else
      render "new"
    end
  end

  def destroy
    @resume = Resume.find(params[:id])
    @resume.destroy
    redirect_to resumes_path, notice:  "The resume #{@resume.name} has been deleted."
  end

  private
  def resume_params
    params.require(:resume).permit(:name, :attachment)
  end

end
