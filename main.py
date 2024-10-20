from openai import OpenAI
import argparse
import sys

print("Hello World")

def main():
    parser = argparse.ArgumentParser(description="Learn more about a topic using OpenAI.")
    parser.add_argument("--topic", type=str, help="The topic you want to learn about")

    args = parser.parse_args()

    with open('OPENAI_API', 'r') as file:
        api_key = file.read().strip()
    
    client = OpenAI(api_key=api_key)

    for model in client.models.list():
        print(model.id)

    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {
                "role": "user",
                "content": "Write a haiku about recursion in programming."
            }
        ]
    )

    print(completion.choices[0].message)

if __name__ == "__main__":
    main()
