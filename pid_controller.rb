# Based on code from https://github.com/miaoufkirsh/rb-pid-controller

# require 'pid_controller'
#
# kp = 1  # Proportional gain
# ki = 1  # Integral gain
# kd = 1  # Derivative gain
# set_point = 10
# pid = PIDController.new(set_point, kp, ki, kd)
#
# loop do
#   process_variable = 10 + (0.1 * (rand - 0.5))
#   control = pid << process_variable
#   puts "process_variable: #{process_variable} control: #{control}"
#   sleep 1
# end

class PIDController
  attr_accessor :history_length
  attr_reader :kp, :ki, :kd, :set_point

  def initialize(set_point, kp = 1.0, ki = 1.0, kd = 1.0, history_length = nil)
    @set_point = set_point
    @history_length = history_length
    @kp = kp.to_f
    @ki = ki.to_f
    @kd = kd.to_f
    reset!
  end

  def kp=(kp)
    @kp = kp.to_f
  end

  def ki=(ki)
    @ki = ki.to_f
  end

  def kd=(kd)
    @kd = kd.to_f
  end

  def set_point=(set_point)
    @set_point = set_point.to_f
  end

  def <<(process_variable)
    e, dt = error(process_variable)
    control = proportional_term(e) + integral_term(e, dt) + derivative_term(e, dt)
    @previous_error = e
    control
  end

  def reset!
    @accumulated_error = 0.0
    @history = @history_length ? [] : nil
    @last_time = nil
    @previous_error = 0.0
    self
  end

  private

  def error(process_variable)
    e = process_variable - @set_point
    now = Time.now.to_i
    if @last_time
      dt = (now - @last_time).to_f
    else
      dt = 1.0
    end
    @last_time = now
    [e, dt]
  end

  def proportional_term(e)
    @kp * e
  end

  def integral_term(e, dt)
    edt = e * dt
    @accumulated_error += edt
    if @history
      @history << edt
      (@history.length - @history_length).times do
        @accumulated_error -= @history.shift
      end
    end
    @ki * @accumulated_error
  end

  def derivative_term(e, dt)
    @kd * (e - @previous_error) / dt
  end
end
