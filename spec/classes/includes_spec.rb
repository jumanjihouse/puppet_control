require 'spec_helper'

describe 'includes' do
  context 'without the KEYNAME environment variable' do
    let(:facts) do
      {
        keyname: 'classes',
      }
    end

    it { is_expected.to contain_class('hiera_lookups::one') }
  end

  context 'when KEYNAME is set to "other_classes"' do
    let(:facts) do
      {
        keyname: 'other_classes',
      }
    end

    it { is_expected.to contain_class('hiera_lookups::two') }
  end
end
