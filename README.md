pid_controller
==========

Description
--------------------------------

This is a simple PID controller writen in Ruby.

Usage
--------------------------------

      require 'pid_controller'

      kp = 1  # Proportional gain
      ki = 1  # Integral gain
      kd = 1  # Derivative gain
      set_point = 10

      # create pid controller
      pid = PIDController.new(set_point, kp, ki, kd)

      # push process variable to the controller and get control value
      control = pid << 11
