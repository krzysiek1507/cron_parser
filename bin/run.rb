# frozen_string_literal: true

require_relative '../lib/cron_parser'

cron_details = CronParser::Parsers::TextParser.new(ARGV.first).call

puts CronParser::Formatters::TextFormatter.new(cron_details).call
