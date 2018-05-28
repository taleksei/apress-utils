require 'spec_helper'

RSpec.describe ActiveSupport::TimeWithZone do
  describe '#as_json' do
    if Apress::Utils.rails32?
      it { skip 'Old behaviour, no need for patching' }
    else
      let(:time_with_zone) do
        ActiveSupport::TimeZone['Europe/Moscow'].local(2018, 1, 12, 15, 0, 0)
      end

      context 'with default precision' do
        it { expect(time_with_zone.as_json).to eq('2018-01-12T15:00:00.000+03:00') }
      end

      context 'with custom precision' do
        around(:each) do |example|
          begin
            old_precision = ActiveSupport::JSON::Encoding.time_precision
            ActiveSupport::JSON::Encoding.time_precision = precision

            example.run
          ensure
            ActiveSupport::JSON::Encoding.time_precision = old_precision
          end
        end

        context 'with precision = 1' do
          let(:precision) { 1 }

          it { expect(time_with_zone.as_json).to eq('2018-01-12T15:00:00.0+03:00') }
        end

        context 'with precision = 0' do
          let(:precision) { 0 }

          it { expect(time_with_zone.as_json).to eq('2018-01-12T15:00:00+03:00') }
        end
      end
    end
  end
end
