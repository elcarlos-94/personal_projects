import math

BASE = 100  # Moles
O2_AIR = 0.21
N2_AIR = 0.79
chems_init = {}
chems_exit = {}
air_items = {}

title = "Furnace program"
print(title + "\n" + "-" * len(title) + "\n")


def initial_mix():
    while math.fsum(chems_init.values()) != BASE:
        mix = int(input("How many chems are in your initial mixture?: "))
        for i in range(mix):
            chem_in = input("Introduce initial chem: ").upper()
            chem_moles_in = float(input("Introduce value: "))
            chems_init[chem_in] = chem_moles_in
        if math.fsum(chems_init.values()) > BASE or math.fsum(chems_init.values()) < BASE:
            print("The initial mixture has 100 moles. Try again")


def final_mix():
    surplus = float(input("Introduce surplus of air in decimals: "))
    required_quantity_o2 = float(input("Depending on the reactions in the furnace, how many required moles of O2 "
                                       "do you need?: "))
    required_quantity_air = required_quantity_o2 / O2_AIR
    air_supplied = required_quantity_air * (1 + surplus)
    n2_supplied = air_supplied * N2_AIR
    o2_supplied = air_supplied * O2_AIR
    air_items["O2"] = o2_supplied
    air_items["N2"] = n2_supplied
    air_items["AIR"] = air_supplied
    exit_mix = int(input("How many chems will be getting at the final mixture?: "))
    for m in range(exit_mix):
        chem_exit = input("Introduce final chem: ").upper()
        if chem_exit == "O2":
            chems_exit[chem_exit] = o2_supplied - required_quantity_o2
            continue
        elif chem_exit == "N2":
            chems_exit[chem_exit] = chems_init["N2"] + n2_supplied
            continue
        # for key in set(chems_init) & set(chems_exit): Check later for merging and sum values.
        #  chems_exit = chems_init.get(key, 0) + chems_exit.get(key, 0)
        chem_moles_exit = float(input("Introduce value: "))
        chems_exit[chem_exit] = chem_moles_exit


def balance_test(analysis_mode):
    while analysis_mode != "W" and analysis_mode != "D":
        analysis_mode = input("Select the analysis you want to make: [D]ry or [W]et: ")
        if analysis_mode == "D":
            try:
                del (chems_exit["H2O"])
                dry_gas = math.fsum(chems_exit.values())
                dry_analysis = {key: (value / dry_gas) * 100 for key, value in chems_exit.items()}
                print("Dry analysis:\n")
                for c, v in dry_analysis.items():
                    print(c, v)
            except KeyError:
                print("Though it is dry analysis, we need H2O moles for the final sum.")
        elif analysis_mode == "W":
            wet_gas = math.fsum(chems_exit.values())
            wet_analysis = {key: (value / wet_gas) * 100 for key, value in chems_exit.items()}
            print("Wet analysis:\n")
            for c, v in wet_analysis.items():
                print(c, v)


def results():
    print("Initial mixture:\n")
    for c, v in chems_init.items():
        print(c, v)

    print("Final mixture:\n")
    for c, v in chems_exit.items():
        print(c, v)

    print("Initial air:\n")
    for c, v in air_items.items():
        print(c, v)


def main(analysis_mode=None):
    initial_mix()
    final_mix()
    balance_test(analysis_mode)
    results()


if __name__ == "__main__":
    main()
