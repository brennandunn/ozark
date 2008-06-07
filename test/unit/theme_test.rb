require 'test_helper'

class ThemeTest < ActiveSupport::TestCase

  context 'a Theme instance' do
    
    should 'be incomplete when created' do
      theme = Factory.create(:theme)
      assert theme.incomplete?
      assert_equal Theme::RequiredComponents, theme.incomplete_items
    end
    
    should 'display no missing components on complete theme' do
      assert themes(:default).incomplete_items.empty?
    end
    
  end

end
