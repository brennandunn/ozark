require 'test_helper'

class SectionTest < ActiveSupport::TestCase

  context 'a Section instance' do
    
    setup do
      @section    = Factory.create(:section, :name => 'Default', :slug => '/', :root => true)
    end
    
    should 'not change slug when changed' do
      uri = @section.uri
      @section.attributes = { :name => 'Default', :per_page => 22 }
      @section.save
      assert_equal uri, @section.reload.uri
    end
    
  end

end
