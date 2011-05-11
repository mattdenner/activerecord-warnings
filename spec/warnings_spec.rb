require 'spec_helper'

class SimpleModel < ActiveRecord::Base
  warnings do
    validates_presence_of :name
    validates_uniqueness_of :name

    validates_format_of :value, :with => /^[a-z]$/

    validates_numericality_of :value2
  end
end

describe SimpleModel do
  before(:all) do
    FileUtils.mkdir('tmp')

    # Connect to a temporary database and create the appropriate model tables
    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'tmp/database'
    )
    ActiveRecord::Base.connection.execute(%Q{
      CREATE TABLE IF NOT EXISTS simple_models(
        id INTEGER PRIMARY KEY,
        name VARCHAR(255),
        value VARCHAR(255),
        value2 INTEGER
      )
    })
  end

  after(:all) do
    FileUtils.rm_rf('tmp')
  end

  before(:each) do
    SimpleModel.destroy_all
  end

  describe '#validates_presence_of' do
    subject { SimpleModel.create! }

    it 'has warnings on name' do
      subject.warnings.on(:name).should == "can't be blank"
    end
  end

  describe '#validates_format_of' do
    subject { SimpleModel.create!(:value => '12345') }

    it 'has warnings on value' do
      subject.warnings.on(:value).should == 'is invalid'
    end
  end

  describe '#validates_numericality_of' do
    subject { SimpleModel.create!(:value2 => 'abcd') }

    it 'has warnings on value2' do
      subject.warnings.on(:value2).should == 'is not a number'
    end
  end

  describe '#validates_uniqueness_of' do
    before(:each) do
      SimpleModel.create!(:name => 'Foo')
    end

    subject do
      SimpleModel.create!(:name => 'Foo')
    end

    it 'has warnings on name' do
      subject.warnings.on(:name).should == 'has already been taken'
    end
  end
end
