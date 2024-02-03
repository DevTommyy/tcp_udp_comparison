use std::{
    fs,
    io::{BufRead, BufReader, Write},
    net::{IpAddr, Ipv4Addr, SocketAddr, TcpListener, UdpSocket},
    time::Instant,
};

#[allow(dead_code)]
/// A simple peer that just recive everything from an UDP socket that it connects too
///
/// # Warning
///
/// If any error occurs in the IO operation is catched with the `?` operation and propagated to the main
fn udp_test(ip: SocketAddr) -> std::io::Result<()> {
    let start = Instant::now();

    let socket = UdpSocket::bind(ip)?;
    let mut buf = [0u8; 32];

    loop {
        let (bytes_read, _) = socket.recv_from(&mut buf)?;
        // If EOF stop
        if buf[0] == b'\0' {
            break;
        }

        println!("{}", String::from_utf8_lossy(&buf[..bytes_read]));
        // Overwrite the buffer resetting it
        buf = [0u8; 32];
    }
    // register the time that the function took and writes it to a file
    let elapsed = start.elapsed();
    let mut file = fs::OpenOptions::new()
        .append(true)
        .open("../data/udp_receiver.txt")?;
    file.write_all(format!("{elapsed:?}\n").as_bytes())?;

    Ok(())
}

#[allow(dead_code)]
/// A simple client that just recive everything from a TCP stream that it connects too
///
/// # Warning
///
/// If any error occurs in the IO operation is catched with the `?` operation and propagated to the main
fn tcp_test(ip: SocketAddr) -> std::io::Result<()> {
    let start = Instant::now();

    let listener = TcpListener::bind(ip)?;

    let (stream, _addr) = listener.accept()?;
    // this reader is to give the exact output without extra newlines or something like that
    let reader = BufReader::new(&stream);

    for line in reader.lines() {
        let received_str = line?;
        // Trim leading and trailing whitespace
        let trimmed_str = received_str.trim();

        // Check if it's an EOF
        if trimmed_str == "\0" {
            break;
        }

        println!("{}", trimmed_str);
    }
    // register the time that the function took and writes it to a file
    let elapsed = start.elapsed();
    let mut file = fs::OpenOptions::new()
        .append(true)
        .open("../data/tcp_receiver.txt")?;
    file.write_all(format!("{elapsed:?}\n").as_bytes())?;
    Ok(())
}

fn main() -> std::io::Result<()> {
    let self_ip = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 9999);
    udp_test(self_ip)
    // tcp_test(self_ip)
}
