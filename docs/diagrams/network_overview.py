from diagrams import Cluster, Diagram
from diagrams.generic.blank import Blank
from diagrams.onprem.network import Internet
from diagrams.generic.network import Router, Switch
from diagrams.generic.compute import Rack

with Diagram("Network Overview", show=False, outformat=["png"], direction='TB'):
    internet = Internet("Outside World")

    isp_router = Router("ISP Router\n192.168.240.1")
    main_router = Router(
        "Main Router\n192.168.1.1\n192.168.2.1\n192.168.3.1\n10.192.168.69.1\n192.168.240.99"
    )

    with Cluster("LAN (192.168.1.0/24)"):
        homekit_hub = Switch("Homekit Hub\n192.168.1.10")
        ap_router = Switch("AP Router\n192.168.1.3")
        main_ap = Switch("Main AP\n192.168.1.2")

        lan_middle = ap_router

    with Cluster("Guest (192.168.2.0/24)"):
        guest_network = Blank()

        guest_middle = guest_network

    with Cluster("IoT (192.168.3.0/24)"):
        with Cluster("homeserver (k8s cluster)"):
            homeserver_three = Rack("homeserver-three\n192.168.3.12")
            homeserver_two = Rack("homeserver-two\n192.168.3.11")
            homeserver_one = Rack("homeserver-one\n192.168.3.10")

        iot_middle = homeserver_two

    with Cluster("VPN (192.168.69.1/24)"):
        vpn_network = Blank()

        vpn_middle = vpn_network

    internet >> isp_router
    isp_router >> main_router

    # Point to the "middle" nodes
    # so the diagrams look cleaner
    main_router >> lan_middle
    main_router >> guest_middle
    main_router >> iot_middle
    main_router >> vpn_network
