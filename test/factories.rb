require 'factory_girl'

Factory.define :page do |p|
end

Factory.define :section do |s|
end

Factory.define :article do |a|
  a.published_at Time.now
end

Factory.define :theme do |t|
end