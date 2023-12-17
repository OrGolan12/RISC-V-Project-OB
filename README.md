<div align='center'>

<h1>RISC-V Verilog model (Or Golan & Bar Pascaro) </h1>
<p>RISC-V verilog implementation , Base RV ISA , 4xStages pipeline , Single-Issue </p>

<h4> <span> · </span> <a href="https://github.com/OrGolan12/RISC-V-Project-OB/blob/master/README.md"> Documentation </a> <span> · </span> <a href="https://github.com/OrGolan12/RISC-V-Project-OB/issues"> Report Bug </a> <span> · </span> <a href=""https://github.com/OrGolan12/RISC-V-Project-OB/issues"> Request Feature </a> </h4>

</div>


# :notebook_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
<a href="url"><img src=""https://github.com/OrGolan12/RISC-V-Project-OB/assets/68474751/0b58eeac-589d-4c82-b411-7fd20d111bc1" align="right" height="400" width="600" ></a>
- [Roadmap](#compass-roadmap)
- [FAQ](#grey_question-faq)
- [Contact](#handshake-contact)
- [Acknowledgements](#gem-acknowledgements)


## :star2: About the Project

### :dart: Features
- RISC-V verilog model
- 4xstages pipeline
- Single issue (1xALU)
- RV-BASE-ISA (RVI)

## :toolbox: Getting Started

### :bangbang: Prerequisites

- iverilog (Icarus Verilog)<a href="https://bleyer.org/icarus/"> Here</a>
- GTKWave (Simulation viewer)<a href="https://gtkwave.sourceforge.net/"> Here</a>

### :test_tube: Running Tests
Compile riscv verilog model
```bash
iverilog -o cpu_tb .\cpu_tb.v
```

Create simulation
```bash
VVP .\cpu_tb
```

Run simulation
```bash
gtkwave.exe .\cpu_tb.vcd
```


## :compass: Roadmap
* [ ] Support M extension (Multiply & Divide)
* [ ] Improve IPC (Better pipeline)

## :grey_question: FAQ
Q1: Why this project is called RISCV_OB
A1: OB is a short-term of Or & Bar , Tel-Aviv university students

Q2: Why this project was created
A2: It was created as a fun project to learn Verilog

## :handshake: Contact
Or Golan
- Linkedin:  https://www.linkedin.com/in/or-golan-512a2a281/ 
- Mail    :  golanorwd@gmail.com

Project Link
[https://github.com/OrGolan12/RISCV_OB](https://github.com/OrGolan12/RISC-V-Project-OB/)

## :gem: Acknowledgements
- [RISC-V website (Documentation)](https://riscv.org/)




