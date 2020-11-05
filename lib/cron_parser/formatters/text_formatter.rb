# frozen_string_literal: true

module CronParser
  module Formatters
    class TextFormatter
      attr_reader :entry_details

      def initialize(entry_details)
        @entry_details = entry_details
      end

      def call
        [
          line('minute', entry_details.minutes),
          line('hour', entry_details.hours),
          line('day of month', entry_details.days),
          line('month', entry_details.months),
          line('day of week', entry_details.days_of_week),
          line('command', entry_details.command)
        ].join
      end

      private

      def line(field_name, value)
        "#{field_name.ljust(14)}#{value.is_a?(Array) ? value.join(' ') : value}\n"
      end
    end
  end
end
