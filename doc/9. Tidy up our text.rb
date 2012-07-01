1. Install RedCloth gem
2. Install profanity gem

#1. We'll convert line breaks in our description and comments into HTML using the RedCloth gem

# 1.1 Install the gem in Gemfile and run bundler

    gem 'RedCloth', "~> 4.2.9"
    
    bundle install

# 1.2 update the description line in app/vies/profiles/show.html.erb

    <div><%= raw RedCloth.new(@profile.description).to_html %></div>
    
# 1.3 update the text line in app/vies/comments/_show.html.erb

    <%= raw RedCloth.new(comment.text).to_html %>
    
                                                                        > (ignore this line)

# 2 lets stop all those angry web people out there...

    gem 'profanity_filter', "~> 0.1.1"
    
    bundle install
    
# 2.2 update the description line in app/vies/profiles/show.html.erb

    <div><%= raw RedCloth.new(ProfanityFilter::Base.clean(@profile.description)).to_html %></div>
    
# 2.3 update the text line in app/vies/comments/_show.html.erb

    <%= raw RedCloth.new(ProfanityFilter::Base.clean(comment.text)).to_html %>
    
                                                                         > (ignore this line)

# I'll leave you to test this how you will....

    
    
