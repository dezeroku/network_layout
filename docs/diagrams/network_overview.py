from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.network import Internet
from diagrams.generic.network import Router, Switch
from diagrams.onprem.client import Client

with Diagram("Network Overview", show=False, outformat=["png"]):
    internet = Internet("Outside World")

    with Cluster("Home Network (.lan dns suffix)"):
        isp_router = Router("ISP Router\n192.168.240.1")
        with Cluster("ISP Router Network (Gateway 192.168.240.1)"):
            main_router = Router(
                "Main Router\n192.168.1.1\n192.168.2.1\n192.168.240.99"
            )

        with Cluster("Guest Network (Gateway 192.168.2.1)"):
            ap_router = Router("AP Router\n192.168.2.2")
            dev_server_guest = Client("Dev Server\n192.168.2.14")

        with Cluster("Main Network (Gateway 192.168.1.1)"):
            # For a lack of the better icon...
            main_ap = Switch("Main AP\n192.168.1.2")

        with Cluster("VPN (10.200.200.0/24)"):
            dev_server_vpn = Client("Dev Server\n10.200.200.3")

    internet >> isp_router
    isp_router >> main_router
    main_router >> ap_router
    main_router >> main_ap

    main_router >> dev_server_vpn
    ap_router >> dev_server_guest

    # dev_server_guest >> Edge(label="It's a single machine!") << dev_server_vpn
