import re

with open("ESDLLogger.txt",'r') as file1:
    data = file1.read()

with open("/etc/rsyslog.conf",'w') as file2:
    file2.write(data)




ip_check_flag = False

regex = "^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$"

def check(Ip):

    if(re.search(regex, Ip)):

        global ip_check_flag

        ip_check_flag = True

    else:

        print("Invalid IP address")





while (True):
    print("NOTE : Please enter IP Address which is provided by EVENTUS SECURITY")
    IP = input("Please enter IP :")

    check(IP)



    if ip_check_flag == True:

        print("NOTE : Enter PORTS as per your firewall configuration")

        UDP_PORT = input("Please enter UDP PORT :")

        TCP_PORT = input("Please enter TCP PORT :")

        CLIENT = input("Please enter Client Name :")

        with open("/etc/rsyslog.conf",'r') as file2:

            data = file2.read()

            data = data.replace("ENTER_IP_HERE", IP)

            data = data.replace("ENTER_UDP_PORT_HERE", UDP_PORT)

            data = data.replace("ENTER_TCP_PORT_HERE", TCP_PORT)

            data = data.replace("CLIENT_NAME", CLIENT)

        with open("/etc/rsyslog.conf",'w') as file2:

            file2.write(data)

        break

