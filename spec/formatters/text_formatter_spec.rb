# frozen_string_literal: true

describe CronParser::Formatters::TextFormatter do
  subject { described_class.new(cron_entry).call }

  let(:cron_entry) do
    CronParser::EntryDetails.new.tap do |entry|
      entry.minutes = [1, 2, 30]
      entry.hours = [4, 12]
      entry.days = [1, 7, 28]
      entry.months = [9, 10]
      entry.days_of_week = [0, 5]
      entry.command = '/usr/bin/find'
    end
  end

  it 'prints table' do
    expect(subject).to eq "minute        1 2 30\n" \
    "hour          4 12\n" \
    "day of month  1 7 28\n" \
    "month         9 10\n" \
    "day of week   0 5\n" \
    "command       /usr/bin/find\n"
  end
end
