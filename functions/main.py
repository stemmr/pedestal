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

@https_fn.on_request()
def addmessage(req: https_fn.Request) -> https_fn.Response:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Grab the text parameter.
    original = req.args.get("text")
    if original is None:
        return https_fn.Response("No text parameters provided", status=400)

    firestore_client: google.cloud.firestore.Client = firestore.client()

    # Push the new message into Cloud Firestore using the Firebase Admin SDK.
    _, doc_ref = firestore_client.collection("messages").add({"original": original})

    # Send back a message that we've successfully written the message
    return https_fn.Response(f"Message with ID {doc_ref.id} added.")
    

@https_fn.on_request(secrets=[OPENAI_API_KEY])
def createpost(req: https_fn.Request) -> https_fn.Response:
    """Takes in a topic and populates firebase with a new post on 
    that topic generated by a call to an LLM API"""
    topic = req.args.get("topic")
    if topic is None:
        return https_fn.Response("No topic provided for post generation", status=400)

    model = "gpt-4o-mini"
    
    firestore_client: google.cloud.firestore.Client = firestore.client()
    openai_client = OpenAI(api_key=OPENAI_API_KEY.value)
    completion = openai_client.chat.completions.create(
        model = model,
        messages = [
            {"role": "system", "content": "Write some interesting information about the user-provided topic"},
            {"role": "user", "content": topic}
        ]
    )

    title = "Some Title"
    summary = "Some Summary"
    content = completion.choices[0].message.content
    
    # Store in Firestore
    _, doc_ref = firestore_client.collection("staging_posts").add({
        "title": title,
        "summary": summary,
        "content": content,
        "topic": topic,
        "created_at": firestore.SERVER_TIMESTAMP
    })

    return https_fn.Response(f"Created a new post ({doc_ref.id}). [{content}]")