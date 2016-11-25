require 'watir'
require 'pry'
require 'SecureRandom'

describe 'Watir' do

b = Watir::Browser.new

after(:all) do
  tumblr_logout(b)
end

  it "should log in to tumblr" do
    tumblr_login(b)
    expect(logged_in?(b)).to be true
  end

  it "should be able to post a text post" do
    unless logged_in?(b)
      tumblr_login(b)
    end

    exists = false #boolean representation of whether the post exists or not
    b.goto "https://www.tumblr.com/new/text"
    rnd = SecureRandom.hex #generates unique id for post

    b.div(class: "editor-plaintext").send_keys("automated test post")
    b.div(class: "editor-richtext").send_keys("unique id: #{rnd} (pls ignore this post I am trying to write a program that writes posts to tumblr)")
    b.button(class: "create_post_button").click

    posts = b.lis(class: "post_container")
    posts.each do |post|
      if post.text.include? rnd
        exists = true
      end
    end

    expect(exists).to be true
    b.goto "http://calming-lavender.tumblr.com"
    expect(b.text).to include rnd
  end

  it 'should be able to upload a photo' do
    b.goto "https://www.tumblr.com/dashboard"
    rnd = SecureRandom.hex
    exists = false

    b.goto "https://www.tumblr.com/new/photo"
    b.div(class: "media-url-button").click
    b.div(aria_label: "Paste a URL").send_keys("http://66.media.tumblr.com/6edf13f41f6f41ad451925577751620f/tumblr_ogomj0lz0z1ujy8mro1_1280.jpg\n")
    b.div(class: 'editor-richtext').click
    b.div(class: 'editor-richtext').send_keys("unique id: #{rnd}")
    b.button(class: "create_post_button").click

    posts = b.lis(class: "post_container")
    posts.each do |post|
      if post.text.include? rnd
        exists = true
      end
    end
    expect(exists).to be true

    sleep(3)

    b.goto "https://www.tumblr.com/blog/calming-lavender"
    binding.pry
    expect(b.text.include? rnd).to be true
  end

end
