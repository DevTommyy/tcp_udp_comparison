import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

# Define a function to read data from a file
def read_data(filename):
    with open(filename, 'r') as file:
        data = [float(line.strip('ms\n')) for line in file]
    return data

# File paths
tcp_sender_file = 'data/tcp_sender.txt'
tcp_receiver_file = 'data/tcp_receiver.txt'
udp_sender_file = 'data/udp_sender.txt'
udp_receiver_file = 'data/udp_receiver.txt'

# Read data from files
tcp_sender_data = read_data(tcp_sender_file)
tcp_receiver_data = read_data(tcp_receiver_file)
udp_sender_data = read_data(udp_sender_file)
udp_receiver_data = read_data(udp_receiver_file)

# Creating comparison plots
plt.figure(figsize=(14, 6))

# Comparison plot for Sender
plt.subplot(1, 2, 1)
plt.plot(tcp_sender_data, color='blue', label='TCP Sender')
plt.plot(udp_sender_data, color='green', label='UDP Sender')
plt.title('Comparison of Sender Data')
plt.xlabel('Data Points')
plt.ylabel('Time (ms)')
plt.legend()

# Comparison plot for Receiver
plt.subplot(1, 2, 2)
plt.plot(tcp_receiver_data, color='red', label='TCP Receiver')
plt.plot(udp_receiver_data, color='orange', label='UDP Receiver')
plt.title('Comparison of Receiver Data')
plt.xlabel('Data Points')
plt.ylabel('Time (ms)')
plt.legend()

plt.savefig("./data/data_plot.png")  # Save the figure to a file instead of displaying
plt.close()
