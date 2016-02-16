Strongbolt Example Application
=========

Usage
---------------------
1. Run `rake db:setup` to setup the database
2. Run `rails s` to start the local webserver
3. Explore the app at http://localhost:3000. You can use the users `admin@example.com` and `user@example.com` with the password `testpass`

How this was created
---------------------
1. Follow the [Rails Getting Started Guide](http://guides.rubyonrails.org/getting_started.html)
2. [Setup Devise](https://github.com/plataformatec/devise#getting-started)
3. Create a User in the Rails console: `User.create!(email: 'my-email@example.com', password: 'testpassword')`
4. See [Setting up Strongbolt](#Setting up Strongbolt)

Setting up Strongbolt
---------------------
Add this to your `Gemfile`:

    gem 'strongbolt'

To creates the required migrations, run:

    rails g strongbolt:install && rake db:migrate

Create a User Group which has full access for all exisiting users by running:

    rake strongbolt:seed

Add the following to the Strongbolt initializer `config/initializers/strongbolt.rb`

    config.skip_controller_authorization_for "Welcome", "Devise::Sessions", "Devise::Registrations"

We'll create a new role and user group by hand, so you can start playing around. Later we'll have views where you can create these things with a web frontend. Create a role and user group for unprivileged users in the rails console:

    Strongbolt::Role.create!(name: 'Unprivileged Users')
    Strongbolt::UserGroup.create!(name: 'Unprivileged Users', roles: [Strongbolt::Role.last])
    Strongbolt::Capability.create!(model: 'User', action: 'find', require_ownership: true, roles: [Strongbolt::Role.last])
    Strongbolt::Capability.create!(model: 'User', action: 'update', require_ownership: true, roles: [Strongbolt::Role.last])

This will create a User Group `Unprivileged Users`, which allows users to access their own user record and update it (required for Devise login and logout to work), but nothing else. Create a new unprivileged user in the Rails console to test the authorizations

    User.create!(email: 'my-second-email@example.com', password: 'testpassword', user_groups: [Strongbolt::UserGroup.last])

If you try to explore outside of the root with this user you will get an error saying

    <an-action> permission not granted to User:<x> for resource <a-resource>

Add the following to your `config/routes.rb` to include routes for the integrated vies to manage User Groups and Roles:

    Rails.application.routes.draw do
        # ...
        scope :strongbolt do
            strongbolt
        end
        # ...
    end

You can run `rake routes` to see which routes Strongbolt provides for you. The important ones are:

1. `/strongbolt/user_groups`
2. `/strongbolt/roles`

They help you manage User Groups and their roles and also allow you to add users to groups.

To style the views a little bit, we're gonna add bootstrap by including the gem `twitter-bootstrap-rails` and running:

    rails generate bootstrap:install static

To demonstrate Tenant Access, we'll add a new model `Category`:

    bin/rails generate model Category name:string
    bin/rails generate migration AddCategoryToArticles category:references

And afterwards, we'll add an `CategoriesController` to CRUD categories and update the article views so that each article can be assigned to a category.

Category will be our `Tentant`, so add the following to the Strongbolt initializer:

    config.tenants = "Category"

To allow users to see only the articles they have access to, we'll chnage the index actions for categories and articles:

    # CategoriesController.index
    current_user.accessible_categories
    # ArticlesController.index
    current_user.accessible_categories.map(&:articles).flatten.uniq

The only remaining action is to give the role `Unprivileged Users` access to categories, articles and comments by tenant:

    Strongbolt::Capability.create!(model: 'Category', action: 'find', require_ownership: false, require_tenant_access: true, roles: [Strongbolt::Role.last])
    Strongbolt::Capability.create!(model: 'Article', action: 'find', require_ownership: false, require_tenant_access: true, roles: [Strongbolt::Role.last])
    Strongbolt::Capability.create!(model: 'Comment', action: 'find', require_ownership: false, require_tenant_access: true, roles: [Strongbolt::Role.last])

Now give some user access to a category by executing this in the rails console:

    my_user.categories << my_category

They will only be able to see articles belonging to that category.
