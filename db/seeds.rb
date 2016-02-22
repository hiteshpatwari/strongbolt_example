# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require_relative '../config/initializers/strongbolt'

[ 'Default', 'Secret' ].each { |c| Category.create!(name: c) }

Article.create!(title: 'Simple Article', text: 'Simple Article Text',
  category: Category.find_by!(name: 'Default'))
Article.create!(title: 'Secret Article', text: 'Secret Article Text',
  category: Category.find_by!(name: 'Secret'))

admin_role  = Strongbolt::Role.create!(name: 'FULL ACCESS USERS (TEMPORARY)')
admin_group = Strongbolt::UserGroup.create!(name: 'FULL ACCESS USERS (TEMPORARY)',
  roles: [admin_role])

Capability.models.each do |model|
  Capability::Actions.each do |action|
    Strongbolt::Capability.create!(model: model, action: action, require_ownership: false,
      require_tenant_access: false, roles: [admin_role])
  end
end

unprivileged_role  = Strongbolt::Role.create!(name: 'Unprivileged Users')
unprivileged_group = Strongbolt::UserGroup.create!(name: 'Unprivileged Users',
  roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'User', action: 'find', require_ownership: true,
  roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'User', action: 'update', require_ownership: true,
  roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'Category', action: 'find', require_ownership: false,
  require_tenant_access: true, roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'Article', action: 'find', require_ownership: false,
  require_tenant_access: true, roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'Article', action: 'create', require_ownership: false,
  require_tenant_access: true, roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'Comment', action: 'find', require_ownership: false,
  require_tenant_access: true, roles: [unprivileged_role])
Strongbolt::Capability.create!(model: 'Comment', action: 'create', require_ownership: false,
  require_tenant_access: true, roles: [unprivileged_role])

admin_user  = User.create!(email: 'admin@example.com', password: 'testpass')
normal_user = User.create!(email: 'user@example.com' , password: 'testpass')
admin_user.categories    = Category.all
admin_user.user_groups  << admin_group
normal_user.categories  << Category.find_by!(name: 'Default')
normal_user.user_groups << unprivileged_group
