class SurveysController < MarketingController
  require 'csv'
  def index
    @responses = []
    @questions_text = ""
    if request.post? && params[:csv].present?
      puts "*****"
      infile = params[:csv].read
      n = 0
      errs = 0, []
      CSV.parse(infile) do |row|
        @data = {}
        puts "***************"
        puts n
        if n == 0
          @questions_text = [ row[6], row[7], row[8]]
        else
          next if row.join.blank?
          @data[:mood] = { question_type: "num", answer: row[1] }
          @data[:mood_why] = { question_type: "text_long", answer: row[2] }
          user = User.find_by_email(row[3]).blank? ? row[3] : User.find_by_email(row[3])
          @data[:email] = { question_type: "email", answer: user}
          @data[:visibility] = { question_type: "visibility", answer: row[4].downcase == "visible" ? true : false }
          @data[:week_short] = { question_type: "text_short", answer: row[5] }
          @data[:questions_1] = { question_type: "yes_no", answer: row[6]}
          @data[:questions_2] = { question_type: "yes_no", answer: row[7]}
          @data[:questions_3] = { question_type: "text_short", answer: row[8] }
          @data[:comments] = { question_type: "text_short", answer: row[9] }
          @responses << @data
        end
        n += 1
      end
    end
  end
  def survey
  end
end
