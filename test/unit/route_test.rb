require 'test_helper'

class RouteTest < ActiveSupport::TestCase

  context 'recognize routes on articles and sections' do
    
    setup do
      @section = Factory.create(:section, :name => 'Default', :slug => '')
      @article = @section.articles.create :name => 'Welcome to my blog!'
    end
    
    should 'find article list for section' do
      assert_equal Article.find(:all), Routeable::recognize('').articles
    end

    should 'find an article from permalink' do
      assert_equal @article, Routeable::recognize('welcome-to-my-blog')
    end
    
  end

  context 'recognize routes on pages' do
    
    should 'find the root page' do
      page = Factory.create(:page, :name => 'Home Page', :slug => '')
      assert_equal page, Routeable::recognize('')
    end

    should 'find pages under sections' do
      section = Factory.create(:section, :name => 'About Me', :slug => 'about')
      page = section.pages.create :name => 'Resume', :slug => 'resume'
      assert_equal page, Routeable::recognize('about/resume')
    end
    
  end
  
  context 'recognize routes on redirects' do
    
    should 'determine a basic redirect' do
      Route.redirect!('google', 'http://www.google.com')
      assert_equal 'http://www.google.com', Routeable::recognize('google').url
    end
    
  end

end
