## Interaction Model


### Levels of Users
1. User is presented with a few popular categories
    a. Mathematics, Physics, Chemistry, Biology, History, Art, Computer Science, Economics
2. User can pick a subdomain
    a. Mathematics: Algebra, Calculus, Geometry, Number Theory, etc.

Options:
1. Generate few paragraphs of explanations
2. Present flashcards to users
3. Maintain a list of flashcards based on the information digested.
4. Keep presenting new explainers and periodically replay old flashcards.
5. (optional) Gamify learning by gathering points for specific subdomains.
6. (Optional) Create a learning path for a specific subdomain
7. Maintain context for which explanations were seen / history of questions answered

### Content Viewing
- Strict Content / Question pairs
- Swipeable summaries of little facts?
- Could be a timeline? Tapping into fact expands more deeply (endlessly deep?)
  - Have a way to save explainers to a catalog such that system asks questions about it later?
- Have a broad category and allow exploration within that category, then ask questions about that domain
- Strict Content / Question Pairs, while allowing users to tap sections they really liked
  - Maybe have an explore tab that only shows tidbits of content without asking questions
  - two tabs: Explore and Practice, practice would be scoped to a broad topic (Biology etc), paid version would allow very niche scopes 
- Three tabs: Explore / Bookmarks / Practice:
  - Explore: shows a timeline of chunks of information that users can either Bookmark or tab in to for a more detailed explanation, with more chunks (that can then also be bookmarked, similar to a wikipedia rabbit hole)
  - Bookmarks: shows all the informations you've bookmarked / allows you to delete, continue exploring or pinpoint for deeper grok
  - Practice: Uses your bookmarks as an input help you grok your topic (multiple choice questions) depending on difficulty of question, awarded points in the domain specified 
- Pregenerate a large collection of Wikipedia style articles from the collection
  - 2000 tokens per article, 2M Tokens for 1k articles
  - $24 for 1k articles with o1-mini, $120 for 1k with o1, $10 for 1k with 4o 

Open Questions:
- How do we capture the user's interests?
- How to figure out how deep their current knowledge is? 
- Would it make sense to have say a slider to allow more depth / less depth on the topic? 

Learning Strategies:
- Active Recall
- Spaced repition