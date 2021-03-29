# Cosine-similarity-VHDL
Get EMG signals from a Database, through UART communication, and classify signals based on cosine similarity calculation

# Diploma work
The modules are, dataset manager (that takes data receiving from UART protocol that I created, storing in RAM memory from the Vivado IP catalog, there is a the template manager, that after generating the templates in python, I stored them in ROMS, with .coe files in Xilinx ip also, the template manager basically receives the address location we want to access for calculation and send it, the cosine similarities that receives the data as vectors from the memories, and have the calculations needed, the average result that takes de 32 bit data from cosine similarity and after getting the 10 channels it averages them, and comparing results takes the results from average and as result gives us the higher average which means the most similar template.
