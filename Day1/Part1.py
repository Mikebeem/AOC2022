# My first Python script:
print("Hello, World!")

import time
start_time = time.time()

f = open("Day1/input.txt", "r")
lines = f.read().split("\n\n")

results= []
for line in lines:
    result = sum(int(x) for x in line.split("\n"))
    results.append(result)

print(max(results))
results.sort()
print(sum(results[-3:]))
f.close()

print("--- %s milliseconds ---" % ((time.time() - start_time)*1000))