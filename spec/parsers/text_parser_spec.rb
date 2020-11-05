# frozen_string_literal: true

describe CronParser::Parsers::TextParser do
  subject { described_class.new(expression).call }

  let(:expression) { '1 * * * * /usr/bin/find' }

  context 'minutes' do
    subject { described_class.new(expression).call.minutes }

    context 'one single minute' do
      let(:expression) { '1 * * * * /usr/bin/find' }

      it 'returns [1]' do
        expect(subject).to eq [1]
      end
    end

    context 'multiple single minutes' do
      let(:expression) { '1,2,3 * * * * /usr/bin/find' }

      it 'returns [1,2,3]' do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context 'any value' do
      let(:expression) { '* * * * * /usr/bin/find' }

      it 'returns [0..59]' do
        expect(subject).to eq (0..59).to_a
      end
    end

    context 'range value' do
      let(:expression) { '3-8 * * * * /usr/bin/find' }

      it 'returns [3, 4, 5, 6, 7, 8]' do
        expect(subject).to eq [3, 4, 5, 6, 7, 8]
      end
    end

    context 'step value with any' do
      let(:expression) { '*/15 * * * * /usr/bin/find' }

      it 'returns [0, 15, 30, 45]' do
        expect(subject).to eq [0, 15, 30, 45]
      end
    end

    context 'step value with 0-10/5 range' do
      let(:expression) { '0-10/5 * * * * /usr/bin/find' }

      it 'returns [0, 5, 10]' do
        expect(subject).to eq [0, 5, 10]
      end
    end

    context 'step value with 1-10/5 range' do
      let(:expression) { '1-10/5 * * * * /usr/bin/find' }

      it 'returns [1, 6]' do
        expect(subject).to eq [1, 6]
      end
    end

    context 'all combinations w/o any' do
      let(:expression) { '1,2,0-29/15,*/20,47-49 * * * * /usr/bin/find' }

      it 'returns [0, 1, 2, 15, 20, 40, 47, 48, 49]' do
        expect(subject).to eq [0, 1, 2, 15, 20, 40, 47, 48, 49]
      end
    end

    context 'all combinations with any' do
      let(:expression) { '1,2,0-29/15,*/20,47-49,* * * * * /usr/bin/find' }

      it 'returns [0..59]' do
        expect(subject).to eq (0..59).to_a
      end
    end

    context 'when minutes out of range' do
      let(:expression) { '1-70 * * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when minutes range incorrect' do
      let(:expression) { '10-2 * * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when minutes range contains letter' do
      let(:expression) { 'a/10 * * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when minutes incorrect' do
      let(:expression) { 'a * * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end
  end

  context 'hours' do
    subject { described_class.new(expression).call.hours }

    context 'one single hour' do
      let(:expression) { '* 1 * * * /usr/bin/find' }

      it 'returns [1]' do
        expect(subject).to eq [1]
      end
    end

    context 'multiple single hours' do
      let(:expression) { '* 1,2,3 * * * /usr/bin/find' }

      it 'returns [1,2,3]' do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context 'any value' do
      let(:expression) { '* * * * * /usr/bin/find' }

      it 'returns [0..23]' do
        expect(subject).to eq (0..23).to_a
      end
    end

    context 'range value' do
      let(:expression) { '* 3-8 * * * /usr/bin/find' }

      it 'returns [3, 4, 5, 6, 7, 8]' do
        expect(subject).to eq [3, 4, 5, 6, 7, 8]
      end
    end

    context 'step value with any' do
      let(:expression) { '* */5 * * * /usr/bin/find' }

      it 'returns [0, 5, 10, 15, 20]' do
        expect(subject).to eq [0, 5, 10, 15, 20]
      end
    end

    context 'step value with range' do
      let(:expression) { '* 0-23/15 * * * /usr/bin/find' }

      it 'returns [0, 15]' do
        expect(subject).to eq [0, 15]
      end
    end

    context 'all combinations w/o any' do
      let(:expression) { '* 1,2,0-23/5,*/20,21-22 * * * /usr/bin/find' }

      it 'returns [0, 1, 2, 5, 10, 15, 20, 21, 22]' do
        expect(subject).to eq [0, 1, 2, 5, 10, 15, 20, 21, 22]
      end
    end

    context 'all combinations with any' do
      let(:expression) { '* 1,2,0-23/5,*/20,21-22,* * * * /usr/bin/find' }

      it 'returns [0..23]' do
        expect(subject).to eq (0..23).to_a
      end
    end

    context 'when hours out of range' do
      let(:expression) { '* 1-25 * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when hours range incorrect' do
      let(:expression) { '* 10-2 * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when hours range contains letter' do
      let(:expression) { '* a/10 * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when hours incorrect' do
      let(:expression) { '* a * * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end
  end

  context 'days' do
    subject { described_class.new(expression).call.days }

    context 'one single day' do
      let(:expression) { '* * 1 * * /usr/bin/find' }

      it 'returns [1]' do
        expect(subject).to eq [1]
      end
    end

    context 'multiple single days' do
      let(:expression) { '* * 1,2,3 * * /usr/bin/find' }

      it 'returns [1,2,3]' do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context 'any value' do
      let(:expression) { '* * * * * /usr/bin/find' }

      it 'returns [1..31]' do
        expect(subject).to eq (1..31).to_a
      end
    end

    context 'range value' do
      let(:expression) { '* * 3-8 * * /usr/bin/find' }

      it 'returns [3, 4, 5, 6, 7, 8]' do
        expect(subject).to eq [3, 4, 5, 6, 7, 8]
      end
    end

    context 'step value with any' do
      let(:expression) { '* * */5 * * /usr/bin/find' }

      it 'returns [1, 6, 11, 16, 21, 26, 31]' do
        expect(subject).to eq [1, 6, 11, 16, 21, 26, 31]
      end
    end

    context 'step value with range' do
      let(:expression) { '* * 1-23/15 * * /usr/bin/find' }

      it 'returns [1, 16]' do
        expect(subject).to eq [1, 16]
      end
    end

    context 'all combinations w/o any' do
      let(:expression) { '* * 1,2,1-23/5,*/19,21-22 * * /usr/bin/find' }

      it 'returns [1, 2, 6, 11, 16, 20, 21, 22]' do
        expect(subject).to eq [1, 2, 6, 11, 16, 20, 21, 22]
      end
    end

    context 'all combinations with any' do
      let(:expression) { '* 1,2,0-23/5,*/20,21-22,* * * * /usr/bin/find' }

      it 'returns [1..31]' do
        expect(subject).to eq (1..31).to_a
      end
    end

    context 'when days out of range' do
      let(:expression) { '* * 1-32 * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days range incorrect' do
      let(:expression) { '* * 10-2 * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days range contains letter' do
      let(:expression) { '* * a/10 * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days incorrect' do
      let(:expression) { '* * a * * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end
  end

  context 'months' do
    subject { described_class.new(expression).call.months }

    context 'one single month' do
      let(:expression) { '* * * 1 * /usr/bin/find' }

      it 'returns [1]' do
        expect(subject).to eq [1]
      end
    end

    context 'multiple single months' do
      let(:expression) { '* * * 1,2,3 * /usr/bin/find' }

      it 'returns [1,2,3]' do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context 'any value' do
      let(:expression) { '* * * * * /usr/bin/find' }

      it 'returns [1..12]' do
        expect(subject).to eq (1..12).to_a
      end
    end

    context 'range value' do
      let(:expression) { '* * * 3-8 * /usr/bin/find' }

      it 'returns [3, 4, 5, 6, 7, 8]' do
        expect(subject).to eq [3, 4, 5, 6, 7, 8]
      end
    end

    context 'step value with any' do
      let(:expression) { '* * * */5 * /usr/bin/find' }

      it 'returns [1, 6, 11]' do
        expect(subject).to eq [1, 6, 11]
      end
    end

    context 'step value with range' do
      let(:expression) { '* * * 2-12/6 * /usr/bin/find' }

      it 'returns [2, 8]' do
        expect(subject).to eq [2, 8]
      end
    end

    context 'all combinations w/o any' do
      let(:expression) { '* * * 1,2,2-12/6,*/3,11-12 * /usr/bin/find' }

      it 'returns [1, 2, 4, 7, 8, 10, 11, 12]' do
        expect(subject).to eq [1, 2, 4, 7, 8, 10, 11, 12]
      end
    end

    context 'all combinations with any' do
      let(:expression) { '* * * 1,2,2-12/6,*/3,11-12,* * /usr/bin/find' }

      it 'returns [1..12]' do
        expect(subject).to eq (1..12).to_a
      end
    end

    context 'when days out of range' do
      let(:expression) { '* * * 0-12 * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days range incorrect' do
      let(:expression) { '* * * 10-2 * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days range contains letter' do
      let(:expression) { '* * * a/10 * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days incorrect' do
      let(:expression) { '* * * a * /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end
  end

  context 'days_of_week' do
    subject { described_class.new(expression).call.days_of_week }

    context 'one single day of week' do
      let(:expression) { '* * * * 1 /usr/bin/find' }

      it 'returns [1]' do
        expect(subject).to eq [1]
      end
    end

    context 'multiple single days of week' do
      let(:expression) { '* * * * 1,2,3 /usr/bin/find' }

      it 'returns [1,2,3]' do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context 'any value' do
      let(:expression) { '* * * * * /usr/bin/find' }

      it 'returns [0..6]' do
        expect(subject).to eq (0..6).to_a
      end
    end

    context 'range value' do
      let(:expression) { '* * * * 2-6 /usr/bin/find' }

      it 'returns [2, 3, 4, 5, 6]' do
        expect(subject).to eq [2, 3, 4, 5, 6]
      end
    end

    context 'step value with any' do
      let(:expression) { '* * * * */5 /usr/bin/find' }

      it 'returns [0, 5]' do
        expect(subject).to eq [0, 5]
      end
    end

    context 'step value with range' do
      let(:expression) { '* * * * 1-4/2 /usr/bin/find' }

      it 'returns [1, 3]' do
        expect(subject).to eq [1, 3]
      end
    end

    context 'all combinations w/o any' do
      let(:expression) { '* * * * 1,2,2-4/3,*/6,5-6 /usr/bin/find' }

      it 'returns [0, 1, 2, 5, 6]' do
        expect(subject).to eq [0, 1, 2, 5, 6]
      end
    end

    context 'all combinations with any' do
      let(:expression) { '* * * * 1,2,2-4/3,*/6,5-6,* /usr/bin/find' }

      it 'returns [0..6]' do
        expect(subject).to eq (0..6).to_a
      end
    end

    context 'when days of week out of range' do
      let(:expression) { '* * * * 0-12 /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days of week range incorrect' do
      let(:expression) { '* * * * 10-2 /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days if week range contains letter' do
      let(:expression) { '* * * * a/3 /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end

    context 'when days of week incorrect' do
      let(:expression) { '* * * * a /usr/bin/find' }

      it 'raises an error' do
        expect { subject }.to raise_error CronParser::Errors::InvalidExpression
      end
    end
  end

  context 'command' do
    subject { described_class.new(expression).call.command }

    let(:expression) { '* * * * * /usr/bin/find' }

    it 'returns command' do
      expect(subject).to eq '/usr/bin/find'
    end
  end
end
