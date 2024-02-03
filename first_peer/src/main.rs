use std::{
    fs,
    net::{IpAddr, Ipv4Addr, SocketAddr, UdpSocket},
};

fn main() -> std::io::Result<()> {
    let other_peer_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 9999);
    let self_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 8888);

    let socket = UdpSocket::bind(self_ip)?;

    fs::read_to_string("input.txt")?.lines().for_each(|line| {
        socket.send_to(line.as_bytes(), other_peer_ip).unwrap();
    });

    Ok(())
}
