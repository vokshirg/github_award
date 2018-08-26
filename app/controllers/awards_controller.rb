class AwardsController < ApplicationController
  def index
  end

  def repo_awards
    @link = params[:link]
    @contributors = Award.top_contributors_by_link(@link)
    unless @contributors
      flash[:error] = "Link empty or invalid"
      redirect_to action: 'index'
    end
  end

  def diplom
    contrib = params[:contrib]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "diplom",
               locals: {contrib: contrib},
               layout: 'wicked_pdf.pdf'
      end
    end
  end

  def download_zip
    require 'zip'
    @contribs = params[:contribs]
    stringio = Zip::OutputStream.write_buffer do |zio|
      @contribs.each do |contrib|
        #create and add a pdf file for this record
        dec_pdf = render_to_string pdf: "#{contrib[:author][:login]}.pdf",
                                   template: 'awards/diplom.pdf',
                                   locals: {contrib: contrib},
                                   layout: 'wicked_pdf.pdf'
        zio.put_next_entry("#{contrib[:author][:login]}.pdf")
        zio << dec_pdf
      end
    end
    # This is needed because we are at the end of the stream and
    # will send zero bytes otherwise
    stringio.rewind
    #just using variable assignment for clarity here
    binary_data = stringio.sysread
    send_data(binary_data, type: 'application/zip', filename: "diplomas.zip")
  end
end
