# Montgomery1024
Verilog implementation of 1024 bit Montgomery Multiplication/Exponentiation.

S19EC6.201 Digital Signal Processing Coursework

Course Instructor: Prof. Syed Azeemuddin, IIIT Hyderabad

This project was intended for faster implementation of hardware cryptographic protocols, RSA, DSA and DH for example.

We've rolled out our own [Hybrid Montgomery algorithm](https://eprint.iacr.org/2013/882.pdf) and successfully reduced the design latency by a whopping 34% in accordance with multiple IEEE papers. We've decided to go with Kogge Stone adder and had to sacrifice Area and Power for Time, but yet the total expected output was almost identical with the unoptimized algorithm. 
```
The Kogge stone adder cancels out the unoptimized Montgomery and hence, a win-win situation for everyone!
```








