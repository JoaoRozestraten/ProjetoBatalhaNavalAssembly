# Battleship in Assembly 8086 (Projeto Batalha Naval)

This project is a classic **Battleship (Batalha Naval)** game fully developed in **8086 Assembly Language**. It runs in a terminal/console environment and provides an interactive grid-based game where the player attempts to find and sink a hidden fleet of ships.

## Features & Functionalities

### 1. Dynamic Game Board
* **20x20 Grid**: The playing area is a 20x20 matrix, mapped with columns from `A` to `T` and rows from `00` to `19`.
* **Visual Feedback**: The terminal updates to show the state of the board. Misses and hits are indicated visually, hiding the ships that haven't been discovered yet.

### 2. Randomized Ship Layouts
* The game randomly selects between **4 distinct ship placement configurations** (`mod0`, `mod1`, `mod2`, `mod3`) at the start of every game.
* **Randomization Engine**: It uses the system clock (via DOS interrupt `21h, 2ch`) to ensure unpredictable layouts each time you play.

### 3. The Fleet
The fleet consists of **6 ships** occupying a total of **19 slots** on the board:
* **1x Battleship (Encouraçado)**: Occupies 4 slots.
* **1x Frigate (Fragata)**: Occupies 3 slots.
* **2x Submarines (Submarinos)**: Occupy 2 slots each.
* **2x Seaplanes (Hidroaviões)**: Occupy 3 slots each, featuring a non-linear shape (a "head" and "wings").

### 4. Interactive Gameplay
* **Coordinate Targeting**: The user is prompted to input the target coordinates by choosing a letter for the column (e.g., `A`, `b`, `T`) and a 2-digit number for the row (e.g., `05`, `19`). It is case-insensitive.
* **Confirmation Prompt**: Before firing, the game displays the chosen coordinate and allows the player to either confirm the shot or select a different coordinate.
* **Immediate Feedback**: After a shot is confirmed, the game announces if it was a **Hit**, a **Miss**, or if the location was **Already Targeted**.
* **Progress Tracking**: Keeps track of the total number of successful hits (out of 19) and the total number of sunken ships (out of 6).

### 5. Control Options
* At any point after a shot, the user can choose to continue playing or press `D` to surrender and exit the game.
* The game automatically detects when all 19 target slots are hit and displays a victory message.

## Project Structure

* **`ProjetoBatalhaNaval.asm`**: The main game file containing all the logic, rendering procedures, and gameplay loops.
* **`DemonstrarSelecao.asm`**: An auxiliary debugging and testing script. It behaves similarly to the main code but is designed to simply randomize and instantly reveal the layout on the board. This is useful for testing the random ship generation without having to play the game.

## How to Run
To run this project, you will need an MS-DOS emulator with an assembler (such as DOSBox paired with TASM or MASM, or EMU8086):
1. Assemble the `.asm` file.
2. Link the generated object file to create an executable.
3. Run the `.exe` within your DOS emulator environment.
