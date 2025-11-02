class ProfilesListingsController < ApplicationController
  layout "new_look_layout"
  
  # Public-facing profile listing pages
  
  def djs
    @djs = User.djs.joins(:profile)
                .where(profiles: { public_profile: true })
                .where.not(profiles: { profile_picture: nil })
                .order('profiles.updated_at DESC')
  end

  def artists
    @artists = User.artists.joins(:profile)
                   .where(profiles: { public_profile: true })
                   .where.not(profiles: { profile_picture: nil })
                   .order('profiles.updated_at DESC')
  end

  def photographers
    @photographers = User.photographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .where.not(profiles: { profile_picture: nil })
                         .order('profiles.updated_at DESC')
  end

  def videographers
    @videographers = User.videographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .where.not(profiles: { profile_picture: nil })
                         .order('profiles.updated_at DESC')
  end

  def curators
    @curators = User.curators.joins(:profile)
                    .where(profiles: { public_profile: true })
                    .where.not(profiles: { profile_picture: nil })
                    .order('profiles.updated_at DESC')
  end

  def designers
    @designers = User.designers.joins(:profile)
                     .where(profiles: { public_profile: true })
                     .where.not(profiles: { profile_picture: nil })
                     .order('profiles.updated_at DESC')
  end

  def all_creators
    @creators = User.content_creators.joins(:profile)
                    .where(profiles: { public_profile: true })
                    .where.not(profiles: { profile_picture: nil })
                    .order('profiles.updated_at DESC')
  end
end

