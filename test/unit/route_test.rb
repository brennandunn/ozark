require 'test_helper'

class RouteTest < ActiveSupport::TestCase

  context 'recognize routes on articles and sections' do
    
    setup do
      @section    = Factory.create(:section, :name => 'Default', :slug => '/', :root => true)
      @article    = @section.articles.create :name => 'Welcome to my blog!', :published_at => Time.now
      @article_2  = @section.articles.create :name => 'Article number 2', :published_at => 1.day.ago
    end
    
    should 'find article list for section' do
      assert_equal Article.find(:all), Routeable::recognize('').articles
    end

    should 'find paginate a section' do
      Section.any_instance.stubs(:per_page).returns(1)
      request = ActionController::AbstractRequest.new
      request.stubs(:parameters).returns({})
      assert_equal 2, Routeable::recognize('').total_pages
      assert Routeable::recognize('page1', request)
      assert Routeable::recognize('page2', request)
      assert ! Routeable::recognize('page3', request)
    end

    should 'find an article from permalink' do
      assert_equal @article, Routeable::recognize('welcome-to-my-blog')
    end
        
  end

  context 'recognize routes on pages' do
    
    should 'find the root page' do
      page = Factory.create(:page, :name => 'Home Page', :slug => '/')
      assert_equal page, Routeable::recognize('')
    end
  
    should 'find pages under sections' do
      section = Factory.create(:section, :name => 'About Me', :slug => 'about', :root => true)
      page = section.pages.create :name => 'Resume', :slug => 'resume'
      assert_equal page, Routeable::recognize('about/resume')
    end
    
  end
  
  context 'sections and capturing route level requests' do
    
    context 'no capture' do
      
      setup do
        @section_a = Factory.create(:section, :name => 'Default with no capture', :slug => '/', :root => false)
        @page_a = @section_a.pages.create :name => 'Home Page', :slug => '/'
      end
      
      should 'capture `page a` for root level request' do
        assert_equal @page_a, Routeable::recognize('')
      end
      
    end
    
    context 'with capture' do
      
      setup do
        @section_b = Factory.create(:section, :name => 'Default with capture', :slug => '/', :root => true)
        @page_b = @section_b.pages.create :name => 'Sub Home Page', :slug => ''
      end
      
      should 'capture `section b` for root level request' do
        assert_equal @section_b, Routeable::recognize('')
      end
      
    end
        
  end
  
  context 'recognize routes on redirects' do
    
    should 'determine a basic redirect' do
      Route.redirect!('google', 'http://www.google.com')
      assert_equal 'http://www.google.com', Routeable::recognize('google').url
    end
    
  end

end
