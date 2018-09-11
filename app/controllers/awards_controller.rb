class AwardsController < ApplicationController
  def index
  end

  def repo_awards
    result = GetTopContributors.call(repo: params[:link])
    if result.success?
      @contributors = result.contributors
    else
      flash[:error] = result.message
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
    contribs = params[:contribs]
    stringio = Zip::OutputStream.write_buffer do |zio|
      contribs.each do |contrib|
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
