import math
gastos = {}
capital = float(input("Ingresa cuánto dinero tienes ahora."))
opcion = input("Presiona cualquier tecla para salir, enter para ingresar tus datos")


def administrador_dinero():
    while True:
        if opcion == "":
            nombre_producto = input("Ingresa lo que compraste")
            gastos[nombre_producto] = float(input("¿Cuánto gastaste?"))
        else:
            for c, v in gastos.items():
                print(c, v)
            total = str(math.fsum(gastos.values()))
            print("El total es {} y te quedan {}".format(total, capital-math.fsum(gastos.values())))
            break


def main():
    administrador_dinero()


if __name__ == "__name__":
    main()