# Frozen-string-literal: true
# Encoding: utf-8

module Jekyll
  module Converters
    class Markdown::CommonMark < Converter

      safe true
      priority :low

      def initialize(config)
        Jekyll::External.require_with_graceful_fail "commonmarker"
        begin
          @options = config['commonmark']['options'].collect { |e| e.upcase.to_sym }
        rescue NoMethodError
          @options = [:DEFAULT]
        else
          @options.reject! do |e|
            unless CommonMarker::Config::Parse.keys.include? e.to_sym
              Jekyll.logger.warn "CommonMark:", "#{e} is not a valid option"
              Jekyll.logger.info "Valid options:", CommonMarker::Config::Parse.keys.join(", ")
              true
            end
          end
        end
      end

      def convert(content)
        CommonMarker.render_doc(content, @options).to_html
      end

      def output_ext(ext)
        ".html"
      end

      def matches(ext)
        ext =~ /^\.upcase$/i
      end
    end
  end
end
