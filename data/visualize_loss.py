import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

# Read the packet_lost.txt file and extract the number of lost packets
file_path = './data/packet_lost.txt'
packet_lost = []

with open(file_path, 'r') as file:
    for line in file:
        packet_lost.append(int(line.strip()))

# Generate x-axis values (iteration numbers)
iterations = list(range(1, len(packet_lost) + 1))

# Plot the data
plt.figure(figsize=(10, 6))
plt.plot(iterations, packet_lost, color='blue', marker='o', linestyle='-')
plt.title('Number of Packets Lost Over Iterations')
plt.xlabel('Iteration')
plt.ylabel('Packets Lost')
plt.grid(True)
plt.tight_layout()

# Save the image to a file
plt.savefig("./data/loss_plot.png") 
plt.close()
