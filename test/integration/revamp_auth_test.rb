require "test_helper"

class RevampAuthTest < ActionDispatch::IntegrationTest
  # --- Public surfaces must be open to guests ---
  test "public pages are reachable by guests" do
    %w[/ /events /news /music /gallery /galleries /stores /artists /malls].each do |path|
      get path
      assert_response :success, "expected #{path} to be public (200), got #{response.status}"
    end
  end

  # --- Privileged/backstage surfaces must require auth ---
  test "backstage pages redirect guests to login" do
    %w[/ad_spots /admin/dashboard /admin_artist_index /artists/new /main_banners].each do |path|
      get path
      assert [302, 301].include?(response.status), "expected #{path} gated, got #{response.status}"
      assert response.location.include?("sign_in") || response.location.include?("login"),
             "expected #{path} to redirect to login, got #{response.location}"
    end
  end

  # --- Impersonation must never be reachable by a guest ---
  test "impersonation is blocked for guests" do
    post "/impersonate/1"
    # Either a 302 to login (require_admin) or 422 (CSRF) — never a success.
    assert response.status != 200, "impersonation must not succeed for guests (got #{response.status})"
  end

  # --- A valid admin can reach the backstage dashboard ---
  test "admin can access backstage after login" do
    admin = User.create!(
      email: "smoke_admin@redvillage.test",
      name: "Smoke Admin",
      role: :admin,
      password: "SmokePass123!",
      password_confirmation: "SmokePass123!"
    )
    sign_in admin
    get "/admin/dashboard"
    assert_response :success, "admin dashboard should be reachable for admin (got #{response.status})"
  ensure
    admin&.destroy if admin&.persisted?
  end

  private

  # Minimal Devise sign-in helper for integration tests.
  def sign_in(user)
    post "/users/sign_in", params: {
      user: { email: user.email, password: user.password }
    }
  end
end
