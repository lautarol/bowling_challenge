class ResultWritter
  def initialize(results)
    write_frames_line
    write_scores(results)
  end

  def write_frames_line
    line = ''
    (1..10).each do |i|
      case i
      when 1 then line = "frame\t \t 1\t \t "
      when 10 then line += '10'
      else line += "#{i}\t \t "
      end
    end
    puts line
  end

  def write_scores(results)
    results.each do |result|
      accumulator = 0
      index = 0
      puts result.name
      line = "Pinfalls\t "
      result_line = "Score\t \t "

      result.score_card.frames.each do |frame|
        accumulator += frame.points
        if !frame.is_a?(LastFrame)
          line_value, index = print_regular_frames(result, frame, index)
          line += line_value
          result_line += getaccumulator(accumulator)
        else
          line += print_last_frame(result, frame, index)
          result_line += result.score.to_s
        end
      end

      puts line
      puts result_line
    end
  end

  def print_regular_frames(result, frame, i)
    line = ''
    case
    when !frame.strike? && !frame.spare?
      frame.result.each { line += "#{result.shots[i]}\t "; i += 1 }
    when frame.spare?
      line = "#{result.shots[i]}\t /\t"
      i += 2
    else
      line = "\t X\t "
      i += 1
    end
    [line, i]
  end

  def getaccumulator(accumulator)
    accumulator < 100 ? "#{accumulator} \t \t " : "#{accumulator}\t\t "
  end

  def print_last_frame(result, frame, i)
    case
    when frame.strike?
      print_last_frame_strike(frame)
    when frame.spare?
      print_last_frame_spare(frame)
    else
      "#{result.shots[i]}\t #{result.shots[i + 1]}"
    end
  end

  def print_last_frame_strike(frame)
    strike = { 20 => "X\t #{frame.result[1]}\t /", 30 => "X\t X\t X" }
    strike.default = "X\t #{frame.result[1]}\t #{frame.result[2]}"
    strike[frame.result.reduce(:+)]
  end

  def print_last_frame_spare(frame)
    frame.result.reduce(:+) == 20 ? "#{frame.result[0]}\t /\t X" : "#{frame.result[0]}\t /\t #{frame.result[2]}"
  end
end
