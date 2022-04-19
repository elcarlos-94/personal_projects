import random

chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!&%/_*(')-"
data = {}


def username():
    return input("Introduce the username you want to storage: ")


def password_introduce():
    return input("Introduce password: ")


def password_generator():
    password_len = int(input("How many characters would you like for your password?: "))
    # password_count = int(input("How many passwords?: "))
    # for x in range(password_count):
    password_2 = ""
    for x in range(password_len):
        password_2 += random.choice(chars)
    print("Here is your password: ", password_2)
    return password_2


def data_creator():
    exit_pass = None
    while exit_pass != "":
        select = input("Would you like to generate a password or introduce one? (G for Generate, I for introduce)"
                       " If you want to stop introducing data, press any key: ").upper()
        if select == "G" or select == "I":
            user = username()
            if select == "I":
                password_1 = password_introduce()
                data[user] = password_1
            elif select == "G":
                password_2 = password_generator()
                data[user] = password_2
        else:
            exit_pass = input("Press enter to exit or press any key to go back and generate new data. ")


def storage():
    has_data = bool(data)
    if has_data:
        print("These are your usernames and passwords saved:\n")
        for u, p in data.items():
            print("{} : {}\n".format(u, p))
        write_file = input("Would you like to write a file? Enter for no, any key for yes: ")
        if write_file == "":
            print("Thank you for using the password generator. Come back soon")
        else:
            with open("data.txt", "w") as my_input:
                my_input.write(str(data))
    elif not has_data:
        final_option = input("It seems you haven't input new data. Press enter to exit or press any key to go back "
                             "and continue")
        if final_option == "":
            print("Come back soon.")
        else:
            data_creator()


def main():
    data_creator()
    storage()


if __name__ == "__main__":
    main()
