require 'spec_helper'

describe 'hiera_lookups' do
  it { is_expected.to compile }
  it { is_expected.to contain_class('hiera_lookups::one') }
  it { is_expected.to contain_class('hiera_lookups::two') }
end
