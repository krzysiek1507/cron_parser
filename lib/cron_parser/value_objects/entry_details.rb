# frozen_string_literal: true

module CronParser
  class EntryDetails
    attr_accessor :minutes, :hours, :days, :months, :days_of_week, :command
  end
end
