import pickle


class User:
    def __init__(self, name, age, gender):
        self.name = name
        self.age = age
        self.gender = gender

    def __str__(self):
        return self.name

    def show_details(self):
        print("Personal details")
        print("")
        print("Name: ", self.name)
        print("Age ", self.age)
        print("Gender ", self.gender)
        print("")


class Bank(User):
    def __init__(self, name, age, gender):
        super().__init__(name, age, gender)
        self.balance = 0

    def deposit(self, amount):
        self.amount = amount
        self.balance = self.balance + self.amount
        print("Account balance has been updated: $", self.balance)

    def withdraw(self, amount):
        self.amount = amount
        if self.amount > self.balance:
            print("Insufficient Funds | Balance Available : $", self.balance)
        else:
            self.balance -= self.amount
            print("Account balance has been updated: $", self.balance)

    def view_balance(self):
        self.show_details()
        print("Account balance: $", self.balance)


def user_storage():
    with open('users.pckl', 'wb') as user_data:
        pickle.dump(User, user_data)


def user_management():
    name_user = input("Introduce name: ").capitalize()
    age_user = input("Introduce age: ")
    gender_user = input("Introduce gender: ")
    user = Bank(name_user, age_user, gender_user)
    user.show_details()

    while True:
        option = input("What do you like to do: [D]eposit, [W]ithdraw, or [V]iew balance? (press enter to exit): ")
        if option == "D":
            deposit_user = float(input("How much money you want to deposit?: $"))
            user.deposit(deposit_user)
        elif option == "W":
            withdraw_user = float(input("How much you want to withdraw?: $"))
            user.withdraw(withdraw_user)
        elif option == "V":
            user.view_balance()
        elif option == "":
            print("Thanks for using the app!")
            break
        else:
            print("Invalid. Try again.")
    return user


def main():
    user_management()


if __name__ == "__main__":
    main()
