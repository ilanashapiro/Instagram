# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **approx. 30** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [X] Run your app on your phone and use the camera to take the photo
- [X] Style the login page to look like the real Instagram login page.
- [X] Style the feed to look like the real Instagram feed.
    - This feature I feel like I only partially implemented.
- [X] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [ ] Show the username and creation time for each post
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
- [X] Allow the logged in user to add a profile photo
- [X] Display the profile photo with each post
- [X] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [X] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:
- [X] Info is immediately updated between the tab bar view controllers by passing data using NSNotificationCenter
- [X] All users profile photos are displayed with the post (not just the currently logged in user's), and posts in all views are updated immediately after setting the image in the profile view without reloading
- [X] You can click on a user's name/profile photo in all views (home, your posts only, and detail view) to go to the profile page for that user. 
- [X] Profile page contains a bio text field for each user that can be seen for any user and edited for the current user, bio is saved in Parse
- [X] Profile pages are only editable (meaning you can only change profile pic and bio) for the currently logged in user.
- [X] Likes are smoothly updated without unnecessary requests to the database for all views (home feed, profile feed, and detail views) when a post is liked in any view. Like count and like button selected state are updated. 
    - [X] Also, likes from other users are saved and reflected in the like count of the posts, and likes of users are saved across logins/logouts.  (an array of all users who like the post is kept for each post in the database)

- [X] List anything else that you can get done to improve the app functionality!
    - Adding comment functionality especially would be nice
    - Just implementing some more of the optional features

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Ways to refactor code to have less duplicate code scattered around???
2. When/when not to use MVC and some deeper understanding of MVC

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/0fqG2krTFG.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](https://recordit.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- DateTools


## Notes

Describe any challenges encountered while building the app.
- It was very challenging getting the profile picture to work correctly and get updated appropriately across all views and states.

## License

Copyright 2019 Ilana Shapiro

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
