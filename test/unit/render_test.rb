require 'test_helper'

class RenderTest < ActiveSupport::TestCase
  
  context 'render a complete theme' do
    
    setup do
      @section = Factory.create(:section, :name => 'Default', :slug => '', :theme => themes(:default))
      @first_article = @section.articles.create :name => 'Welcome to my blog!', :slug => 'welcome'
      @second_article = @section.articles.create :name => 'Rails 101'
      [
        { :name => 'Brennan Dunn', :content => 'Great post!' }, 
        { :name => 'John Doe', :content => 'You suck!' }
      ].each do |comment|
        @first_article.comments.create :name => comment[:name], :content => comment[:content]
      end
    end
    
    should 'render a list of articles' do
      output = out(Routeable::recognize('').render)
      assert_equal 1, output['h1.section_title'].size
      assert_equal 2, output['div.article_preview'].size
    end

    should 'render an article' do
      output = out(Routeable::recognize('welcome').render)
      assert_equal 1, output['h2.article_title'].size
      assert_equal 1, output['span.time_ago'].size
      assert_equal 2, output['div.comment'].size
    end
    
  end
  
  context 'rendering an incomplete template' do
    
    setup do
      @section = Factory.create(:section, :name => 'Incomplete', :slug => '', :theme => themes(:incomplete)) 
      @first_article = @section.articles.create :name => 'Welcome to my blog!', :slug => 'welcome'
      @second_article = @section.articles.create :name => 'Rails 101'       
    end
    
    should 'fail' do
      assert_raise Renderable::IncompleteThemeError do 
        Routeable::recognize('').render
      end
    end
    
  end
  
  def out(text)
    HpricotTestExtension::DocumentOutput.new(text)
  end

end
