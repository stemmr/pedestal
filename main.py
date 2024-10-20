from openai import OpenAI
import argparse
import sys

from pedestal import Pedestal

def main():
    parser = argparse.ArgumentParser(description="Learn more about a topic using OpenAI.")
    parser.add_argument("--topic", type=str, help="The topic you want to learn about")

    args = parser.parse_args()

    with open('OPENAI_API', 'r') as file:
        api_key = file.read().strip()
    
    client = OpenAI(api_key=api_key)

    learner = Pedestal(args.topic, client)

    while True:
        try:
            learner.invoke()
        except KeyboardInterrupt:
            print("\nLearning session interrupted. Goodbye!")
            sys.exit(0)        


if __name__ == "__main__":
    main()
