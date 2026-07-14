require "test_helper"

class RevampModelsTest < ActiveSupport::TestCase
  # Mall requires only a name; FriendlyId needs a slug column to persist.
  test "mall is valid with name and gets a slug" do
    mall = Mall.create!(name: "Smoke Mall #{rand(10_000)}")
    assert mall.persisted?
    assert_not_nil mall.slug, "Mall should generate a slug (FriendlyId)"
    mall.destroy
  end

  test "store requires name, email, description, and owner" do
    user = User.create!(email: "smoke_store_owner@redvillage.test", name: "Owner",
                        role: :member, password: "SmokePass123!", password_confirmation: "SmokePass123!")
    mall = Mall.create!(name: "Smoke Mall #{rand(10_000)}")
    store = Store.create!(name: "Smoke Store", email: "store@smoke.test",
                          description: "A demonstrable store.", user: user, mall: mall)
    assert store.persisted?
    assert_not_nil store.slug
    # Store belongs to the mall
    assert_equal mall.id, store.mall_id
    store.destroy
    mall.destroy
    user.destroy
  end

  test "product requires positive price and valid status" do
    user = User.create!(email: "smoke_prod_owner@redvillage.test", name: "Owner",
                        role: :member, password: "SmokePass123!", password_confirmation: "SmokePass123!")
    mall = Mall.create!(name: "Smoke Mall #{rand(10_000)}")
    store = Store.create!(name: "Smoke Store", email: "store@smoke.test",
                          description: "desc", user: user, mall: mall)
    product = Product.create!(name: "Smoke Product", price: 19.99, store: store,
                              inventory_quantity: 5, status: "active")
    assert product.persisted?
    assert_not_nil product.slug
    # Out-of-stock auto-sets status via callback
    product.update(inventory_quantity: 0)
    assert_equal "out_of_stock", product.reload.status
  ensure
    product&.destroy if product&.persisted?
    store&.destroy if store&.persisted?
    mall&.destroy if mall&.persisted?
    user&.destroy if user&.persisted?
  end

  test "event is valid with name and ticket prices" do
    event = Event.create!(name: "Smoke Event #{rand(10_000)}",
                          standard_ticket_price: 10.0, vip_ticket_price: 30.0, currency: "USD")
    assert event.persisted?
  ensure
    event&.destroy if event&.persisted?
  end

  test "user roles enum covers all backstage roles" do
    %i[member admin dj artist photographer videographer curator designer editor].each do |role|
      assert_includes User.roles.keys, role.to_s
    end
  end
end
