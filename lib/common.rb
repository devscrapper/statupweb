#!/usr/bin/env ruby -w
# encoding: UTF-8
require 'logger'
module Common

  def information(msg)

    p "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} => #{msg}"
  end

  def debug(msg, line=nil)

  end

  def warning(msg, line=nil)

    p "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} => #{msg}"
  end

  def alert(msg, line=nil)

    p "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} => #{msg}"
  end

  def error(msg, line=nil)

    p "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} ERROR => #{msg}"
  end

  module_function :information
  module_function :alert
  module_function :warning
  module_function :error
end