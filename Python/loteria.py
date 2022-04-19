import pyttsx3
import random
from time import sleep

past_cards = []

engine = pyttsx3.init()
engine.setProperty('rate', 120)
engine.setProperty('voice', 'spanish')


def read_cards():
    with open("loteria.txt", "r") as cards:
        lottery_cards = cards.read().split("\n")
    return lottery_cards


def sort_cards(lottery_cards):
    while not len(past_cards) >= 53:
        card = random.choice(lottery_cards)
        if card not in past_cards:
            past_cards.append(card)


def card_count():
    for i in past_cards:
        if i == past_cards[-1]:
            print("La carta ganadora es... {}!".format(past_cards[-1]))
            pyttsx3.speak("La carta ganadora es... {}!".format(past_cards[-1]))
        else:
            pyttsx3.speak(i)
            print(i)
            sleep(2)


def main():
    lottery_cards = read_cards()
    sort_cards(lottery_cards)
    card_count()


if __name__ == "__main__":
    main()
