require 'test_helper'

class RenderTest < ActiveSupport::TestCase

  context 'accessing and rendering a section' do
    
    setup do
      @section = Factory.create(:section, :name => 'Default', :slug => '', :theme => themes(:default))
      @first_article = @section.articles.create :name => 'Welcome to my blog!'
      @second_article = @section.articles.create :name => 'Rails 101'
    end

    should 'render a list of articles' do
      output = out(Routeable::recognize('').render)
      assert_equal 1, output['h1.section_title'].size
      assert_equal 2, output['div.article_preview'].size
    end
    
  end
  
  def out(text)
    HpricotTestExtension::DocumentOutput.new(text)
  end

end
