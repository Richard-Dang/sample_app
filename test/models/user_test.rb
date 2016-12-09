require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 60
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a" * 255 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses"do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{valid_emails.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses"do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{invalid_emails.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAmPlE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be greater than 6 characters" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
