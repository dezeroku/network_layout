from diagrams import Cluster, Diagram
from diagrams.generic.blank import Blank
from diagrams.onprem.network import Internet
from diagrams.generic.network import Router, Switch
from diagrams.generic.compute import Rack

with Diagram("Network Overview", show=False, outformat=["png"], direction='TB'):
    internet = Internet("Outside World")

    isp_router = Router("ISP Router\n192.168.240.1")
    main_router = Router(
        "Main Router\n192.168.1.1\n192.168.2.1\n192.168.3.1\n192.168.69.1\n192.168.240.99"
    )

    with Cluster("LAN (192.168.1.0/24)"):
        homekit_hub = Switch("Homekit Hub\n192.168.1.10")
        ap_router = Switch("AP Router\n192.168.1.3")

        lan_middle = ap_router

    with Cluster("Guest (192.168.2.0/24)"):
        guest_network = Blank()

        guest_middle = guest_network

    with Cluster("IoT (192.168.3.0/24)"):
        iot_network = Blank()

        iot_middle = iot_network

    with Cluster("Cluster (192.168.4.0/24)"):
        with Cluster("homeserver (k8s)"):
            homeserver_seven = Rack("homeserver-seven\n192.168.4.17")
            homeserver_six = Rack("homeserver-six\n192.168.4.16")
            homeserver_five = Rack("homeserver-five\n192.168.4.15")
        with Cluster("homeserver-backup (k8s)"):
            homeserver_backup_three = Rack("homeserver-backup-three\n192.168.4.23")
            homeserver_backup_two = Rack("homeserver-backup-two\n192.168.4.22")
            homeserver_backup_one = Rack("homeserver-backup-one\n192.168.4.21")

        pikvm = Rack("pikvm\n192.168.4.31")
        cluster_middle = homeserver_backup_three

    with Cluster("VPN Main (192.168.69.1/24)"):
        vpn_main = Blank()

    with Cluster("VPN Guest (192.168.70.1/24)"):
        vpn_guest = Blank()

    with Cluster("VPN Family (192.168.71.1/24)"):
        vpn_family = Blank()

    internet >> isp_router
    isp_router >> main_router

    # Point to the "middle" nodes
    # so the diagrams look cleaner
    main_router >> lan_middle
    main_router >> guest_middle
    main_router >> iot_middle
    main_router >> cluster_middle
    main_router >> vpn_main
    main_router >> vpn_guest
    main_router >> vpn_family
