class ResultWritter
  def initialize(results)
    write_frames_line
    write_scores(results)
  end
  def write_frames_line
    for i in (1..10)
      case i
      when 1
        line = "frame\t \t 1\t \t "
      when 10
        line += '10'
      else
        line += "#{i}\t \t "
      end
    end
    puts line
  end

  def write_scores(results)
    results.each do |result|
      final_score= result.score
      accumulator = 0
      index = 0
      puts result.name
      line= "Pinfalls\t "
      result_line= "Score\t \t "
      result.score_card.frames.each do |frame|
        accumulator += frame.points
        unless frame.is_a?(LastFrame)
          values= print_regular_frames(result, frame, index)
          line += values[0]
          index = values[1]
          if accumulator < 100
            result_line += "#{accumulator} \t \t "
          else
            result_line += "#{accumulator}\t\t "
          end          
        else
          line += print_last_frame(result, frame, index)
          result_line += "#{final_score}"
        end
      end
      puts line
      puts result_line
    end
  end

  def print_regular_frames(result, frame, i)
    line = ""
    if frame.strike?
      line +=  "\t X\t "
      i += 1
    elsif frame.spare?
      line +=  "#{result.shots[i]}\t /\t"
      i += 2
    else
      frame.result.each do |shot_score|
        line += "#{result.shots[i]}\t "
        i += 1
      end
    end
    return line, i
  end
  
  def print_last_frame(result, frame, i)
    line = ""
    if frame.strike?
      if frame.result.reduce(:+) == 30
        line += "X\t X\t X"
      elsif frame.result.reduce(:+) == 20
        line += "X\t #{frame.result[1]}\t /"
      else
        line += "X\t #{frame.result[1]}\t #{frame.result[2]}"
      end
    elsif frame.spare?
      if frame.result.reduce(:+) == 20
        line +=  "#{frame.result[0]}\t /\t X"
      else
        line +=  "#{frame.result[0]}\t /\t #{frame.result[2]}"
      end
    else
      line += "#{result.shots[i]}\t #{result.shots[i+1]}"
    end
    return line
  end 
end