require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://telederma.gov.co'
SitemapGenerator::Sitemap.create do
  add '/landing/home/home', :changefreq => 'daily', :priority => 1.0
  add '/landing/home/about_us', :changefreq => 'weekly'
  add '/landing/home/services', :changefreq => 'weekly'
  add '/landing/home/support', :changefreq => 'weekly'
  add '/landing/home/sales_contact', :changefreq => 'weekly'
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks