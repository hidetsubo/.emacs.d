require 'pathname'
require 'erb'
require 'find'
require 'pp'
require 'optparse'
require 'yaml'

require 'bitclust'
require 'bitclust/subcommand'

module BitClust::Subcommands
  class ListCommand < BitClust::Subcommand
    def initialize
      @mode = nil
      @parser = OptionParser.new {|opt|
        opt.banner = "Usage: #{File.basename($0, '.*')} list (--library|--class|--method|--function)"
        opt.on('--library', 'List libraries.') {
          @mode = :library
        }
        opt.on('--class', 'List classes.') {
          @mode = :class
        }
        opt.on('--method', 'List methods.') {
          @mode = :method
        }
        opt.on('--function', 'List functions.') {
          @mode = :function
        }
        opt.on('--help', 'Prints this message and quit.') {
          puts opt.help
          exit 0
        }
      }
    end

    def parse(argv)
      super
      unless @mode
        error 'one of (--library|--class|--method|--function) is required'
      end
    end

    def exec(db, argv)
      case @mode
      when :library
        db.libraries.map {|lib| lib.name }.sort.each do |name|
          puts name
        end
      when :class
        db.classes.map {|c| c.name }.sort.each do |name|
          puts name
        end
      when :method
        db.classes.sort_by {|c| c.name }.each do |c|
          c.entries.sort_by {|m| m.id }.each do |m|
            puts m.label
          end
        end
      when :function
        db.functions.sort_by {|f| f.name }.each do |f|
          puts f.name
        end
      else
        raise "must not happen: @mode=#{@mode.inspect}"
      end
    end
  end
end
