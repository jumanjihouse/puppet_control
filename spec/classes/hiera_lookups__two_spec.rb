require 'spec_helper'

describe 'hiera_lookups::two' do
  context 'with actual hiera lookup' do
    it { is_expected.to contain_user('user2').with_password(/.+/) }
  end

  context 'with fake hiera lookup' do
    let(:hiera_config) { 'spec/fixtures/hiera-good.yaml' }

    it do
      is_expected.to contain_user('user2')
        .with_password('another_fake_password_string')
    end
  end

  context 'when lookup() specifies a default value' do
    context 'when hieradb is missing' do
      let(:hiera_config) { '/dev/null' }

      it { is_expected.to_not compile }
      it { is_expected.to raise_error(Puppet::PreformattedError) }
    end

    context 'when key is not in hiera but specifies a default value' do
      let(:hiera_config) { 'spec/fixtures/hiera-bad.yaml' }

      it { is_expected.to_not compile }
      it { is_expected.to raise_error(Puppet::PreformattedError) }
    end
  end
end
