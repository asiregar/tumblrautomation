require 'watir'
require 'pry'

describe 'Watir' do


b = Watir::Browser.new


after(:all) do
  tumblr_logout(b)
end

  it "should log in to tumblr" do
    if b.url != "https://www.tumblr.com/login"
      b.goto("https://www.tumblr.com/login")
    end
    tumblr_login(b)
    expect(logged_in?(b)).to be true
  end

  it "should be able to post a text post" do
    unless logged_in?(b)
      tumblr_login(b)
    end
    b.goto "https://www.tumblr.com/new/text"
    exists = false
    b.div(class: "editor-plaintext").send_keys("automated test post")
    b.div(class: "editor-richtext").send_keys("(pls ignore this post I am trying to write a program that writes posts to tumblr) sdkblkjjkckjbla")
    b.button(class: "create_post_button").click
    posts = b.lis(class: "post_container")
    posts.each do |post|
      if post.text.include? "sdkblkjjkckjbla"
        exists = true
      end
    end
    expect(exists).to be true
    b.goto "https://www.tumblr.com/login"
  end

end
