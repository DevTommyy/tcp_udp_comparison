use std::{
    fs,
    io::Write,
    net::{IpAddr, Ipv4Addr, SocketAddr, TcpStream, UdpSocket},
    time::Instant,
};

#[allow(dead_code)]
/// A mock peer that just sends all the content of a file with UDP, then an EOF to terminate the transmission.
///
/// # Warning
///
/// If any error occurs in the IO operation is catched with the `?` operand and the program is exited early.
fn send_udp(ip: SocketAddr) -> std::io::Result<()> {
    let start = Instant::now();

    let self_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 8888);

    let socket = UdpSocket::bind(self_ip)?;

    // NOTE: the file is 100k lines
    fs::read_to_string("input.txt")?.lines().for_each(|line| {
        socket.send_to(line.as_bytes(), ip).unwrap();
    });

    // Sending the EOF to make the reciver stop
    socket.send_to("\0".as_bytes(), ip)?;

    let elapsed = start.elapsed();
    let mut file = fs::OpenOptions::new()
        .append(true)
        .open("../data/udp_sender.txt")?;
    file.write_all(format!("{elapsed:?}\n").as_bytes())?;
    Ok(())
}

#[allow(dead_code)]
/// A mock client that just sends all the content of a file with TCP, then an EOF to terminate the transmission.
///
/// # Warning
///
/// If any error occurs in the IO operation is catched with the `?` operand and the program is exited early.
fn send_tcp(ip: SocketAddr) -> std::io::Result<()> {
    let start = Instant::now();

    let mut stream = TcpStream::connect(ip)?;

    // NOTE: the file is 100k lines
    fs::read_to_string("input.txt")?.lines().for_each(|line| {
        stream.write_all(line.as_bytes()).unwrap();
        stream.write_all(b"\n").unwrap(); // Append a newline after each line
    });

    // Sending the EOF to make the receiver stop
    stream.write_all(b"\0")?;

    let elapsed = start.elapsed();
    let mut file = fs::OpenOptions::new()
        .append(true)
        .open("../data/tcp_sender.txt")?;
    file.write_all(format!("{elapsed:?}\n").as_bytes())?;
    Ok(())
}

fn main() -> std::io::Result<()> {
    let target_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 9999);
    send_udp(target_ip)
    // send_tcp(target_ip)
}
