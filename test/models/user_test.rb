require "test_helper"

class UserTest < ActiveSupport::TestCase  
  setup do
    @user = users(:one)
  end

  test "Assign admin if needed" do
		school = School.create!(
			name: "Divine Victory", subdomain: "divinevic",
			phone_number: "050123456", email: "divine@mail.com",
			box_address: "P.O.box 9", motto: "motto"
		)

		#first user should become admin
		user = school.users.build(
			username: "Don",
			first_name: "John",
			last_name: "Doe",
			email: "john@mail.com"
		)

		assert user.valid?, user.errors.full_messages.to_sentence
		assert :teacher, user.role
		
		user.save!
		assert :admin, user.role

		# Second user is a teacher
		second_user = school.users.build( 
			username: "secondUser", first_name: "Second",
			last_name: "User", email: "secuser@mail.com"
		)

		assert second_user.valid?, second_user.errors.full_messages.to_sentence
		assert :teacher, second_user.role

		second_user.save!
		assert 2, school.users.count

		# Destroy admin user to hit after_destroy callback
		user.destroy!
		assert user.destroyed?
		assert 1, school.users.count

		# Second user should now be promoted to admin
		second_user.reload
		assert :admin, second_user.role
	end
end
