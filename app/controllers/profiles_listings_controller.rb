class ProfilesListingsController < ApplicationController
  layout "marketplace"

  # Public-facing profile listing pages.
  # NOTE: deliberately NOT gating on profile_picture presence — no seed user has
  # an uploaded avatar, so the gate previously left every page empty (same bug
  # that blanked /team). The _profile_card partial renders a placeholder icon.

  def djs
    @djs = User.djs.joins(:profile)
                .where(profiles: { public_profile: true })
                .order('profiles.updated_at DESC')
  end

  def artists
    @artists = User.artists.joins(:profile)
                   .where(profiles: { public_profile: true })
                   .order('profiles.updated_at DESC')
  end

  def photographers
    @photographers = User.photographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .order('profiles.updated_at DESC')
  end

  def videographers
    @videographers = User.videographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .order('profiles.updated_at DESC')
  end

  def curators
    @curators = User.curators.joins(:profile)
                    .where(profiles: { public_profile: true })
                    .order('profiles.updated_at DESC')
  end

  def designers
    @designers = User.designers.joins(:profile)
                     .where(profiles: { public_profile: true })
                     .order('profiles.updated_at DESC')
  end

  def all_creators
    @creators = User.content_creators.joins(:profile)
                    .where(profiles: { public_profile: true })
                    .order('profiles.updated_at DESC')
  end
end
