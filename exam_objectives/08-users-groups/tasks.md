# 08 - Manage Users and Groups

## User/Group Creation
Create group `sharegroup` and users:
- haruna (no login shell, not in sharegroup)
- umar (member of sharegroup)
- adoga (UID 4444, member of sharegroup)

All users password: `persward`  
Change adoga's password to `perfect`

## Password Policies
- Minimum password length: 8 characters
- Maximum password age: 30 days

## Cleanup
- Remove umar from sharegroup
- Delete sharegroup
- Delete user haruna with home directory
