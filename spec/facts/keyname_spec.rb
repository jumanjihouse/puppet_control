require 'spec_helper'
require 'keyname'

describe 'keyname fact' do
  random_string = (0...8).map { rand(26..65).chr }.join

  before do
    Foo::Keyname.stubs(:value).returns(random_string)
  end

  after do
    Foo::Keyname.unstub(:value)
  end

  it 'returns the value of Foo::Keyname' do
    expect(Facter.fact(:keyname).value).to eq(random_string)
  end
end

describe 'Foo::Keyname' do
  context 'when KEYNAME is unset' do
    it 'returns "classes"' do
      ENV['KEYNAME'] = nil
      expect(Foo::Keyname.value).to eq('classes')
    end
  end

  context 'when KEYNAME is set' do
    context 'with a valid (good) value' do
      random_string = (0...8).map { rand(26..65).chr }.join

      before do
        ENV['KEYNAME'] = random_string
        Foo::Keyname.stubs(:valid?).returns(true)
      end

      after do
        Foo::Keyname.unstub(:valid?)
      end

      it 'returns the correct value in lower case' do
        expect(Foo::Keyname.value).to eq(random_string.downcase)
      end
    end

    context 'with an invalid (bad) value' do
      it 'returns "unrecognized"' do
        ENV['KEYNAME'] = 'boogabooga_yo_dawg'
        expect(Foo::Keyname.value).to eq('unrecognized')
      end
    end

    context 'with an empty (bad) value' do
      it 'returns "unrecognized"' do
        ENV['KEYNAME'] = ''
        expect(Foo::Keyname.value).to eq('unrecognized')
      end
    end
  end
end
