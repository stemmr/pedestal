# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`
import firebase_functions.core
from pydantic import BaseModel
from openai import Client, OpenAI

# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
from firebase_functions import firestore_fn, https_fn
from firebase_functions.params import SecretParam

# The Firebase SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore

app = initialize_app()

OPENAI_API_KEY = SecretParam('OPENAI_API_KEY')

model = "gpt-4o-mini"

class Post(BaseModel):
    title: str
    summary: str
    content: str

class MultiChoice(BaseModel):
    question: str
    options: list[str]
    correct_idx: int
    points: int

@https_fn.on_request(secrets=[OPENAI_API_KEY])
def createpost(req: https_fn.Request) -> https_fn.Response:
    """Takes in a topic and populates firebase with a new post on 
    that topic generated by a call to an LLM API"""
    topic = req.args.get("topic")
    if topic is None:
        return https_fn.Response("No topic provided for post generation", status=400)
    
    firestore_client: google.cloud.firestore.Client = firestore.client()
    openai_client = OpenAI(api_key=OPENAI_API_KEY.value)
    completion = openai_client.beta.chat.completions.parse(
        model = model,
        messages = [
            {"role": "system", "content": f"""
                Write some interesting information about a sub area or niche within the wider topic {topic}.

                Make sure that it is engaging, and has a similar tone to a blog post written by an expert on the topic or a Wikipedia Article.
                It should also be very insightful, kind of like the type of article you'd find in a magazine, but with a slightly more academic tone.
                Make sure to bring a lot of structure in the content you're providing to the user so it can easily be digested.

                Ensure that it is about 500 words in length and that it can easily be digested in a few minutes reading.
             """}
        ],
        response_format=Post
    )

    post: Post = completion.choices[0].message.parsed
    
    # Store in Firestore
    _, doc_ref = firestore_client.collection("posts").add({
        "title": post.title,
        "summary":post.summary,
        "content": post.content,
        "topic": topic,
        "created_at": firestore.SERVER_TIMESTAMP
    })

    return https_fn.Response(f"Created a new post ({doc_ref.id}). [{post}]")

@https_fn.on_request(secrets=[OPENAI_API_KEY])
def createquestion(req: https_fn.Request) -> https_fn.Response:
    """Takes in a post ID and generates a question based on that post and then uploads it to Firestore
    Will also ensure the question is formatted correctly for consumption by the frontend."""
    post_id = req.args.get("post_id")
    if post_id is None:
        return https_fn.Response("No post id provided to generate a question from.", status=400)
    
    firestore_client: google.cloud.firestore.Client = firestore.client()
    openai_client = OpenAI(api_key=OPENAI_API_KEY.value)

    # Get the post content
    post_ref = firestore_client.collection("posts").document(post_id)
    post = post_ref.get()
    if not post.exists:
        return https_fn.Response(f"Post with id {post_id} not found", status=404)
    
    post_data = post.to_dict()
    post_content = post_data.get("content")

    # Generate question using OpenAI
    completion = openai_client.beta.chat.completions.parse(
        model=model,
        messages=[
            {"role": "system", "content": """
                Create a multiple choice question based on the following content. 
                Assign points to the question based on how difficult the question is to get right.
                Ensure there are always 2-4 options to pick from with one correct answer. 
             """},
            {"role": "user", "content": post_content}
        ],
        response_format=MultiChoice
    )
    
    question = completion.choices[0].message.parsed

    # Store the question in Firestore
    _, question_ref = firestore_client.collection("questions").add({
        "postId": post_id,
        "question": question.question,
        "options": question.options,
        "correctOptionIndex": question.correct_idx,
        "points": question.points,
        "type": "MultipleChoice",
        "createdAt": firestore.SERVER_TIMESTAMP
    })

    return https_fn.Response(f"Created new question {question_ref.id} for post {post_id}: [{question}]")

@firestore_fn.on_document_created(document="users/{userId}/bookmarks/{postId}")
def on_bookmarked(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]):
    """Watches a users bookmarks collection and updates the user's questions 
    to more closely match the user's interests based on their bookmarks  
    """
    
    user_id = event.params['userId']
    if not event or not event.params:
        print("Invalid event or missing parameters.")
        return
        
    post_id = event.params.get('postId')
    if not post_id:
        print("No post ID specified in Firestore event.")
        return
    print(f"Calling bookmarked post handling function for {user_id} on {post_id}")
    firestore_client: google.cloud.firestore.Client = firestore.client()

    # Get all questions for the bookmarked post
    questions = firestore_client.collection("questions").where("postId", "==", post_id).get()
    print(f"Questions associated with a Bookmark: {questions}")
    # Add each question to the user's questions collection
    user_questions_ref = firestore_client.collection("users").document(user_id).collection("questions")
    for question in questions:
        # Check if question already exists for this user
        question = user_questions_ref.document(question.id).get()
        if not question.exists:
            print(f"Setting a new question for the user. {question.id}")
            user_questions_ref.add(
                document_id = question.id,
                document_data = {
                    "answered": False,
                    "postId": post_id,
                    "createdAt": firestore.SERVER_TIMESTAMP
                })
        else:
            print(f"Question {question.id} already exists for user.")