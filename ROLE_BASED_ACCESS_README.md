# Role-Based Access Control Implementation

## Overview
This implementation adds comprehensive role-based access control (RBAC) for DJs, Artists, and Admins with role-specific dashboards and admin impersonation functionality.

## Features Implemented

### 1. User Roles
- **Member** (default): Regular users with public site access only
- **DJ**: Can access DJ dashboard, view/manage events
- **Artist**: Can access Artist dashboard, upload/manage tracks and albums
- **Admin**: Full access to all features, can impersonate other users

### 2. Role-Specific Dashboards
- **Admin Dashboard** (`/admin/dashboard`): 
  - User statistics and management
  - Content management overview (galleries, news, videos, tracks, albums, events)
  - Recent activity feeds
  - Impersonation controls

- **DJ Dashboard** (`/dj/dashboard`):
  - Upcoming and past events
  - Quick access to music tracks
  - Event management tools

- **Artist Dashboard** (`/artist/dashboard`):
  - Track and album management
  - Upload/create content
  - Statistics and analytics

### 3. Impersonation (Admin Only)
- Admins can impersonate any user to test their experience
- Clear visual indicators when impersonating
- One-click stop impersonation
- Routes:
  - `POST /impersonate/:id` - Start impersonating a user
  - `DELETE /stop_impersonating` - Stop impersonation

### 4. Access Control
- **RoleBasedAccess Concern**: Reusable module for role-based authorization
  - `require_admin` - Admin-only access
  - `require_dj` - DJ or Admin access
  - `require_artist` - Artist or Admin access
  - `require_dj_or_artist` - Either DJ or Artist (or Admin)
  - `check_backstage_access` - Ensures user can access backend

- **Updated Controllers**:
  - `TracksController`: Artists and Admins can create/edit tracks
  - `AlbumsController`: Artists and Admins can create/edit albums
  - `EventsController`: DJs and Admins can create/edit events
  - `UsersController`: Admin-only user management

## File Structure

### New Files Created
- `app/controllers/concerns/role_based_access.rb` - RBAC concern
- `app/controllers/concerns/impersonation.rb` - Impersonation helpers
- `app/controllers/dashboards_controller.rb` - Dashboard controller
- `app/controllers/impersonations_controller.rb` - Impersonation controller
- `app/views/dashboards/admin.html.haml` - Admin dashboard view
- `app/views/dashboards/dj.html.haml` - DJ dashboard view
- `app/views/dashboards/artist.html.haml` - Artist dashboard view
- `app/views/shared/_role_navbar.html.erb` - Role-specific navigation
- `app/views/shared/_impersonation_banner.html.erb` - Impersonation banner
- `app/helpers/dashboard_helper.rb` - Dashboard helper methods
- `db/migrate/*_add_dj_and_artist_roles_to_users.rb` - Migration for roles

### Modified Files
- `app/models/user.rb` - Added DJ and Artist roles
- `app/controllers/application_controller.rb` - Included Impersonation concern
- `app/controllers/users/sessions_controller.rb` - Role-based redirects
- `app/controllers/users/registrations_controller.rb` - Role-based redirects and admin restriction
- `app/controllers/tracks_controller.rb` - Role-based access
- `app/controllers/albums_controller.rb` - Role-based access
- `app/controllers/events_controller.rb` - Role-based access
- `app/controllers/users_controller.rb` - Admin-only access with role filtering
- `app/views/layouts/admin.html.erb` - Dynamic navbar based on role
- `config/routes.rb` - Added dashboard and impersonation routes

## Usage

### Assigning Roles
Roles can be assigned during user registration (DJ, Artist, or Member). Admin role should only be assigned by existing admins through the user management interface.

### Accessing Dashboards
- After login, users are automatically redirected to their role-specific dashboard
- Manual navigation:
  - `/admin/dashboard` - Admin dashboard
  - `/dj/dashboard` - DJ dashboard
  - `/artist/dashboard` - Artist dashboard
  - `/dashboard` - Redirects based on user role

### Impersonation
1. Admin logs in and navigates to Users management (`/users`)
2. Find the user to impersonate
3. Click "Impersonate" button next to the user
4. A warning banner appears indicating impersonation mode
5. Click "Stop Impersonating" to return to admin account

### Creating Content by Role
- **Artists**: Can upload tracks and create albums
- **DJs**: Can create and manage events
- **Admins**: Can do everything

## Code Organization (DRY Principles)
- **Concerns**: Reusable modules for common functionality
- **Shared Partials**: Common UI elements reused across views
- **Helper Methods**: Utility functions in helpers
- **Role-Based Navigation**: Dynamic navbar based on user role

## Security Notes
- Admin role cannot be assigned during registration (auto-defaults to member)
- Only admins can impersonate users
- Users cannot impersonate themselves
- Role-based access enforced at controller level
- Session-based impersonation tracking

## Migration
Run the migration to ensure the database schema supports the new roles:
```bash
rails db:migrate
```

## Testing Recommendations
1. Test each role's dashboard access
2. Test role-based content creation permissions
3. Test impersonation flow (admin only)
4. Test unauthorized access attempts
5. Test role filtering in user management

