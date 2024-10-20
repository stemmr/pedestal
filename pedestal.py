from pydantic import BaseModel
from openai import Client

class MultiChoice(BaseModel):
    question: str
    answers: list[str]
    correct_idx: int

class Pedestal:
    def __init__(self, context: str, client: Client):
        # Cotext to seed the learner with
        self.client = client
        self.context = context
        self.explanations = []
        self.flashcards = []
        self.model = "gpt-4o-mini"
        self.system_prompt = \
        """
        Create a multiple choice questions and a set of answers for a topic given by the user. 
        """

    def explanation(self) -> str:
       completion = self.client.chat.completions.create(
           model = self.model,
           messages = [
               {"role": "system", "content": "Write some interesting information about the user-provided topic"},
               {"role": "user", "content": self.context}
           ]
       )
       return completion.choices[0].message.content
       
    def question(self) -> MultiChoice:
        completion = self.client.beta.chat.completions.parse(
            model = self.model,
            messages = [
                {"role": "system", "content": self.system_prompt},
                {"role": "user", "content": self.explanations[-1]},
                {"role": "user", "content": self.context},
            ],
            response_format=MultiChoice
        )
        return completion.choices[0].message.parsed


    def invoke(self):
        # Draw a new explanation from the context
        explanation = self.explanation()
        self.explanations.append(explanation)
        print(f"{explanation}\n")
        # Present a question to the user
        multi_choice = self.question()
        print("---- QUESTIONS ----")
        print(f"{multi_choice.question}\n")
        for idx, answer in enumerate(multi_choice.answers):
            print(f"{idx + 1}. {answer}")

        print("\nEnter your answer (1-" + str(len(multi_choice.answers)) + "):")
        user_answer = input().strip()
        
        # Validate user input
        while not user_answer.isdigit() or int(user_answer) < 1 or int(user_answer) > len(multi_choice.answers):
            print("Invalid input. Please enter a number between 1 and " + str(len(multi_choice.answers)) + ":")
            user_answer = input().strip()
        
        user_answer = int(user_answer) - 1  # Convert to zero-based index
        
        if user_answer == multi_choice.correct_idx:
            print("Congratulations! That's the right answer")
        else:
            print(f"Sorry! That's not correct! The right answer was ({multi_choice.correct_idx+1}) {multi_choice.answers[multi_choice.correct_idx]}")