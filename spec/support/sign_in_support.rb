module SignInSupport
  def sign_in_support(user)
    # トップページに遷移する
    visit root_path
    # ログインボタンをクリックし、サインインページに移動する
    find('a[class="login"]').click
    expect(current_path).to eq new_user_session_path
    # "サインインする"
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
  end
end