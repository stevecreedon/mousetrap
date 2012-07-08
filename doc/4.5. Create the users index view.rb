# 1. Add some stuff to the users index view
# 2. Link the home page and the users page.




# 1. Now the test are passing let's list users in the users index view

# in app/views/users/index.html.erb

  <table>
	<tr><th>Id.</th><th>Email</th><th>signed in</th><th>ip</th>
	<% @users.each do |user| %>
	<tr>
		<td><%= user.id %></td>
		<td><%= user.email %></td>
		<td><%= user.current_sign_in_at %></td>
		<td><%= user.current_sign_in_ip %></td>
	</tr>
	<% end %>
  </table>

# 8. Now lets add some basic navigation:

# 8.1 a link from the home page to the users page:

  # in app/views/home/index.html.erb
  # NOTE: users_path is a dynamic Rails helper method for creating GET /users which links us to users#index

  <%= link_to "users", users_path %>

# 8.2 And also link back to dashboard from the users page:

   # in app/views/users/index.html.erb

  <%= link_to "dashboard", root_path %>