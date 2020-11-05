# frozen_string_literal: true

module CronParser
  module Parsers
    class TextParser
      attr_reader :entry_details

      def initialize(text)
        @parts = text.split
        @entry_details = ::CronParser::EntryDetails.new

        raise CronParser::Errors::InvalidExpression if @parts.size != 6
      end

      def call
        parse

        entry_details
      end

      private

      attr_reader :minutes

      DIGIT_REGEX = /^\d+$/.freeze
      RANGE_REGEXP = /^\d+-\d+$/.freeze

      DAYS = (1..31).to_a.freeze
      DAYS_OF_WEEK = (0..6).to_a.freeze
      HOURS = (0..23).to_a.freeze
      MINUTES = (0..59).to_a.freeze
      MONTHS = (1..12).to_a.freeze

      def parse
        entry_details.minutes = parse_part(@parts[0], MINUTES)
        entry_details.hours = parse_part(@parts[1], HOURS)
        entry_details.days = parse_part(@parts[2], DAYS)
        entry_details.months = parse_part(@parts[3], MONTHS)
        entry_details.days_of_week = parse_part(@parts[4], DAYS_OF_WEEK)
        entry_details.command = @parts[5]
      end

      def parse_part(part, allowed_values)
        part.split(',').each_with_object([]) do |part, result|
          return allowed_values.to_a.dup if part == '*'

          result << part.to_i and next if DIGIT_REGEX.match?(part)
          result.concat(parse_range(part, allowed_values)) and next if RANGE_REGEXP.match?(part)
          result.concat(parse_step_value(part, allowed_values)) and next if part.include?('/')

          raise CronParser::Errors::InvalidExpression
        end.tap(&:uniq!).tap(&:sort!)
      end

      def parse_range(part, allowed_values)
        first, last = part.split('-').map(&:to_i)

        raise CronParser::Errors::InvalidExpression if first > last
        raise CronParser::Errors::InvalidExpression if !allowed_values.include?(first) || !allowed_values.include?(last)

        (first..last).to_a
      end

      def parse_step_value(part, allowed_values)
        first, step = part.split('/')
        step = step.to_i

        shift = allowed_values.first

        if first == '*'
          allowed_values
        elsif RANGE_REGEXP.match?(first)
          parse_range(first, allowed_values).tap { |result| shift = result.first }
        else
          raise CronParser::Errors::InvalidExpression
        end.select { |n| (n - shift) % step == 0 }
      end
    end
  end
end
