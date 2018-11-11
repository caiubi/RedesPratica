with open("tabel.txt", "r") as ins:
    array = []
    for line in ins:
        array.append(line.rstrip("\n\r"))
    for ip in array:
        if "router" in ip:
            router = ip.replace('router: ', '')
    print router
    print array[2]
