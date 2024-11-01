### TODO

### iOS
- Add support for recording points on questions / topics
- Make it possible to bookmark from within post
- Update Topics View to be more clean
- Make QuestionView show whether Question was answered correctly
- Make QuestionView show number of points for a given question 
- Add Custom Styling to Back Button
- Test out TimelineView with images included

### Backend
- Add support for retrieving documents using Firebase
  - Explore using @FirestoreQuery
- Design API more thoughtfully
- Clean up Auth UI 
- Add Apple and GitHub Auth options (and potentially X)

- Create Cloud Functions to generate new content
- Forgot Password with email Auth

### Data Model
- users
  - bookmarks : collection
  - questions_answered : collection
  - questions_queue : collection
  - posts : collection
- questions
  - Can be associated with a post or not
- posts
  - topic

Important Queries:
- Load all posts for a topic this user can access
- Load all bookmarked posts for a topic from this user
- Allow user to bookmark a post
- Load all questions for a user

### V1 / App Store Scope
- User can authenticate with email/password
  - Sees consistent state when reopening the app
- Six initial topics 100 posts each
- Each topic has 5 questions, at first random and then shown according to bookmarks
- Points are given per topic and displayed
- Automate post generation with Cloud Function

### V2 Scope
- Drastically improve design, potentially work with a designer
- Add support for images when selecting topics / articles
- Improve Auth Flow, add login with Apple / GitHub / Twitter
- Automate new content generation on a schedule

### V3 Scope
- Include Payments / Premium version
- Add Custom Topics support 