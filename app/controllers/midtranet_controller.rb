class MidtranetController < MarketingController
  require 'csv'
  before_filter :authenticate
  def index
    @averages = historical_mood_averages
    #@csv_file = File.read(Rails.root.join("uploads", "surveys", "how_going_#{params[:id]}.csv"))
    #@responses = []
    #@questions_text = ""
    #puts "*****"
    #infile = @csv_file
    #n = 0
    #errs = 0, []
    #CSV.parse(infile) do |row|
      #@data = {}
      #if n == 0
        #@questions_text = [ row[6], row[7], row[8]]
      #else
        #next if row.join.blank?
        #@data[:mood] = { question_type: "num", answer: row[1] }
        #@data[:mood_why] = { question_type: "text_long", answer: row[2] }
        #user = User.find_by_email(row[3]).blank? ? row[3] : User.find_by_email(row[3])
        #@data[:email] = { question_type: "email", answer: user}
        #@data[:visibility] = { question_type: "visibility", answer: row[4].downcase == "visible" ? true : false }
        #@data[:week_short] = { question_type: "text_short", answer: row[5] }
        #@data[:questions_1] = { question_type: "yes_no", answer: row[6]}
        #@data[:questions_2] = { question_type: "yes_no", answer: row[7]}
        #@data[:questions_3] = { question_type: "text_short", answer: row[8] }
        #@data[:comments] = { question_type: "text_short", answer: row[9] }
        #@responses << @data
      #end
      #n += 1
    #end
  end

  def historical_mood_averages
    @averages = []
    Dir.foreach(Rails.root.join("uploads", "surveys")) do |csv_file|
      @scores_array = []
      next if csv_file == ".." or csv_file == "."
      csv_file = File.read(Rails.root.join("uploads", "surveys", csv_file))
      n = 0
      CSV.parse(csv_file) do |row|
        n += 1
        next if row.join.blank? or n == 1
        puts "*********"
        puts row[1].inspect
        @scores_array << row[1]
      end
      @avg = @scores_array.inject{ |sum, el| sum.to_f + el.to_f }.to_f / @scores_array.size
      @averages << @avg.to_f
    end
    return @averages
  end
end
