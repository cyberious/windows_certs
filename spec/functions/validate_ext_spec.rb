require 'spec_helper'

describe 'validate_ext' do
  describe 'valid testing' do
    it { should run.with_params('c:\mydomain.pfx','pfx')}
  end
  describe 'invalid test' do
    it {
      should run.with_params('c:\mydomain.crt')
    }
  end
end