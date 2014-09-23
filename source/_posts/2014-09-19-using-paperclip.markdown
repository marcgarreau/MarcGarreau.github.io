---
layout: post
title: "Using Paperclip"
date: 2014-09-19 13:47:30 -0600
comments: true
categories: 
---

>[Paperclip](https://github.com/thoughtbot/paperclip) allows us to upload, store and display pictures in an application. In this example, we'll go from installation to adding a picture to a menu item. You may substitute 'item' for any other model in your application.

* Install imagemagick. It can be a real headache, so there is a dedicated guide here: [(Coming soon)](#)

* Add paperclip to your application's Gemfile. At the time of writing, the latest version of paperclip is 4.2.

``` ruby Gemfile
gem 'paperclip', '~> 4.2.0'
```

* Install the gem:

{% terminal %}
$ bundle install
{% endterminal %}

* Since we're going to allow a user to add a photo to an item, we need to add the relationship and validation to our item.rb file.

``` ruby item.rb
has_attached_file :image, styles: {:medium => "300x300>", :thumb => "100x100#"}
validates_attachment :image, content_type: {content_type: ["image/jpeg", "image/jpeg", "image/png", "image/gif"]}
```
Paperclip allows us to specify what sizes we'd like to save the uploaded image in, so you'll notice above that we've specified two file sizes with the nicknames of `:medium` and `:thumb`. This will make it easy to display those file sizes later.

The trailing `#` in `"100x100#"` results in the image being centrally cropped, with those exact dimensions. The trailing	`>` in `"300x300>"` modifies the image only if its dimensions are larger than those specified. You can view more imagemagick modifiers [here](http://www.imagemagick.org/script/command-line-processing.php#geometry). 

* Generate the related migration
{% terminal %}
$ rails generate paperclip item image
{% endterminal %}

* Then run the migration
{% terminal %}
$ rake db:migrate
{% endterminal %}


* Next, we'll update the form in the edit item view to allow a user to select and upload a photo. Notice the addition of `html: {multipart: true}` to the head of the form, as well as the new `file_field` input.
``` ruby edit.html.erb
	<%= form_for @user, html: {multipart: true} do |f| %>
		<%= f.label :image %>
		<%= f.file_field :image %>
		# ...
```

* In rails 4, the `:image` will have to be a part of your strong params to get processed, so add that in the items controller.
``` ruby items_controller.rb
def item_params
	params.require(:item).permit(:image, # ... )
end
```

* Now that your image is uploaded, you can display an item's image using an `image_tag`. You may specify any of the nicknames you saved earlier to display that image size (i.e. `:thumb` instead of `:medium`).
``` ruby show.html.erb
<%= image_tag @item.image.url(:medium) %>
```

That's it!

If you'd like your shiny new paperclip to work with your application on Heroku, you're going to need to use the aws-sdk gem. You can find that tutorial [here, soon.]('#')