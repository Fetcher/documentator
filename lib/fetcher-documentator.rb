require 'fast'
require 'fetcher-documentator/version'

module Fetcher

  class Documentator
    def initialize path
      @name = "doc/" + path[4..-4] + ".md"

      @text_flat = flatten File.read path

      @doc = []
      class_name_parts = path[0..-4].split("/").last.split "_"
      class_name = ""
      class_name_parts.each do |part|
        class_name += part.capitalize
      end
      
      @text_flat.length.times do |i|
        if @text_flat[i].start_with? "##"
          if @text_flat[i].start_with? "###"
            method = @text_flat[i][4..-1].split(" ").first
            @doc << ""
            @doc << method
            @doc << ("-" * method.length)
            @doc << ""
            @doc << ("    " + @text_flat[i][4..-1])
          elsif @text_flat[i].start_with? "## @"
            transform_to_link(@text_flat[i][4..-1]).each do |line|
              @doc << line
            end
          elsif @text_flat[i].start_with? "## >"
            @doc << @text_flat[i][3..-1]
          else
            @doc << @text_flat[i][3..-1] 
            if @doc.last.nil?
              @doc[-1] = ""
            else
              unless @doc.last.end_with? ":"
                @doc[-1] = "    #{@doc.last}"
              else
                last = @doc.last
                if @doc[-2] == ""
                  @doc[-1] = "### #{last}" 
                else
                  @doc[-1] = "" 
                  @doc << "### #{last}"
                end
              end
            end
            unless @text_flat[i] == @text_flat.last
              @doc << "" unless @text_flat[i + 1].start_with? "##"
            end
          end
        end
      end

      unless @doc.empty?  
        @doc.unshift ("=" * class_name.length)
        @doc.unshift class_name
        file.write @name, @doc.join("\n") 
      end
    end

    def flatten text
      flat = []
      text.lines.to_a.each do |line|
        flat << line.strip
      end
      flat
    end

    def transform_to_link text
      method = text.split(".").last
      hierarchy = text.split(".")[0..-2].join(".")
      hierarchy_parts = hierarchy.split "/"
      domain = hierarchy_parts.shift
      capitalized_parts = []
      hierarchy_parts.each do |part|
        snaked = part.split "_"      
        up_snaked = []
        snaked.each do |sn|
          up_snaked << sn.capitalize
        end
        capitalized_parts << up_snaked.join("")
      end
      data = []
      data << "### #{domain}"
      data << ""
      data << "[#{method.upcase} #{domain}/#{capitalized_parts.join("/")}](https://github.com/Fetcher/#{domain}/blob/master/doc/#{domain}/#{hierarchy_parts.join("/")}.md##{method})"
      data
    end
  end
end
