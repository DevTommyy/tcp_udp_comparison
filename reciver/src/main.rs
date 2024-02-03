use std::net::{IpAddr, Ipv4Addr, SocketAddr, UdpSocket};

fn main() -> std::io::Result<()> {
    // let other_peer_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 8888);
    let self_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 9999);

    let socket = UdpSocket::bind(self_ip)?;
    let mut buf = [0u8; 65536];

    loop {
        let (bytes_read, _) = socket.recv_from(&mut buf)?;
        println!("{}", String::from_utf8_lossy(&buf[..bytes_read]));
    }
}
