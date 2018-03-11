require 'spec_helper'

describe 'hiera_lookups::one' do
  context 'with actual hiera lookup' do
    it { is_expected.to contain_user('user1').with_password(/.+/) }
  end

  context 'with fake hiera lookup' do
    let(:hiera_config) { 'spec/fixtures/hiera-good.yaml' }

    it do
      is_expected.to contain_user('user1').with_password('fake_password_string')
    end
  end

  context 'when lookup() does not specify a default value' do
    context 'when hieradb is missing' do
      let(:hiera_config) { '/dev/null' }

      it { is_expected.to_not compile }
      it { is_expected.to raise_error(Puppet::DataBinding::LookupError) }
    end

    context 'when key is not in hiera' do
      let(:hiera_config) { 'spec/fixtures/hiera-bad.yaml' }

      it { is_expected.to_not compile }
      it { is_expected.to raise_error(Puppet::DataBinding::LookupError) }
    end
  end
end
