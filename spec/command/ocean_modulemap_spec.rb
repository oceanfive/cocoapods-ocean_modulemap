require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Ocean_modulemap do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ ocean_modulemap }).should.be.instance_of Command::Ocean_modulemap
      end
    end
  end
end

