<img width="823" height="297" alt="image" src="https://github.com/user-attachments/assets/ff6f7168-dcb1-4980-964a-166c42205cd4" />
<img width="1622" height="124" alt="image" src="https://github.com/user-attachments/assets/c871b712-d1fc-4976-8a3f-9063f0a665b8" />
In this project, a fully pipelined CORDIC sine–cosine generator is implemented on FPGA using Verilog. The implementation includes:
	A Quadrant Detector
	A 14-stage CORDIC pipeline
	A ROM for arctan constants
	A fixed-point arithmetic unit using Q2.13 format
	A complete testbench with angle normalization

Stage equations (rotation mode):
	Define
<img width="223" height="71" alt="image" src="https://github.com/user-attachments/assets/f63d1d96-dbc0-4451-9eb9-3e8af7992217" />

in rotation mode 
	Then the stage equations become
<img width="266" height="134" alt="image" src="https://github.com/user-attachments/assets/75f74d3d-f947-4b2f-87c9-2866b889bdd5" />


CORDIC gain (constant):
<img width="259" height="99" alt="image" src="https://github.com/user-attachments/assets/99417d95-f21e-40cb-8949-19a23750ea8d" />


For N=14, K_14≈0.607252. Typical choices:
	pre-scale x_0=K_Nso outputs are approximately cos⁡,sin⁡directly, or
	post-scale by 1/K_Nto compensate
Fixed-point conventions used (Q2.13)
	16-bit signed: signed [15:0]
	Format Q2.13: 1 sign bit, 2 integer bits, 13 fraction bits.
	Scaling factor: value_real = integer / 2^13(= /8192).
	Example: 1.0 → 0x2000 (8192), 0.5 → 0x1000 (4096).
Angle representation:
	Angles are in radians, also stored as Q2.13:
"angle_q"="round"("angle_rad"×8192).
	π≈3.141592653589793→ pi_q ≈ 25736 (0x6488), π/2≈12868

We must fold the angle into the CORDIC working domain:
-π/2≤Z_0≤+π/2

	Case 1 — Angle is already in the CORDIC domain
Condition:
-π/2≤"angle_in"≤+π/2

Operation:
	Use the angle directly
	Use positive initial vector
Values used:
Zi = angle_in
Xi = +K   (0.607252 in Q2.13 → 0x136E)
Yi = 0


	Case 2 — Angle is in the upper half-plane
+π/2<"angle_in"≤+π

Operation:
	Subtract π from the angle
	Flip the sign of the initial vector
Values used:
Zi = angle_in - π
Xi = -K
Yi = 0

	Case 3 — Angle is in the lower half-plane
-π≤"angle_in"<-π/2

Operation:
	Add π to the angle
	Flip the initial vector
Values used:
Zi = angle_in + π
Xi = -K
Yi = 0


