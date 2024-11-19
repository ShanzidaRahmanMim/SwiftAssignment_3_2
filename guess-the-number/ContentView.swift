import SwiftUI

struct ContentView: View {
    @State private var targetNumber = String(Int.random(in: 1000...9999))
    @State private var guess = ""
    @State private var feedback = [Color](repeating: .clear, count: 4)
    @State private var attempts = 0
    @State private var gameOver = false
    @State private var submittedGuesses: [(String, [Color])] = []
    @FocusState private var isTextFieldFocused: Bool // State to track focus

    var body: some View {
        VStack(spacing: 20) {
            Text("Numberle")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Guess the 4-digit number")
                .font(.headline)
            
            VStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { row in
                    HStack {
                        if row < submittedGuesses.count {
                            let (guess, colors) = submittedGuesses[row]
                            ForEach(0..<4, id: \.self) { index in
                                Text(String(guess[guess.index(guess.startIndex, offsetBy: index)]))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(width: 50, height: 50)
                                    .background(colors[index])
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        } else {
                            ForEach(0..<4, id: \.self) { _ in
                                Text("")
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            if gameOver {
                Text("Congratulations! You guessed it in \(attempts) attempts!")
                    .font(.headline)
                    .foregroundColor(.green)
                Button("Play Again") {
                    resetGame()
                }
                .buttonStyle(.borderedProminent)
            } else {
                TextField("Enter your guess", text: $guess)
                    .keyboardType(.numberPad) // Ensure number pad is requested
                    .focused($isTextFieldFocused) // Link focus state
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Button("Submit Guess") {
                    processGuess()
                }
                .buttonStyle(.borderedProminent)
                .disabled(guess.count != 4 || !guess.allSatisfy(\.isNumber))
                .onAppear {
                    isTextFieldFocused = true // Auto-focus the TextField
                }
            }
        }
        .padding()
    }
    
    func processGuess() {
        attempts += 1
        var colors = [Color](repeating: .red, count: 4)
        
        var targetChars = Array(targetNumber)
        var guessChars = Array(guess)
        
        for i in 0..<4 {
            if guessChars[i] == targetChars[i] {
                colors[i] = .green
                targetChars[i] = "*"
                guessChars[i] = " "
            }
        }
        
        for i in 0..<4 {
            if let matchIndex = targetChars.firstIndex(of: guessChars[i]), colors[i] != .green {
                colors[i] = .yellow
                targetChars[matchIndex] = "*"
            }
        }
        
        submittedGuesses.append((guess, colors))
        if submittedGuesses.count > 6 {
            submittedGuesses.removeFirst()
        }
        
        if guess == targetNumber {
            gameOver = true
        }
        
        guess = ""
    }
    
    func resetGame() {
        targetNumber = String(Int.random(in: 1000...9999))
        guess = ""
        feedback = [Color](repeating: .clear, count: 4)
        attempts = 0
        gameOver = false
        submittedGuesses.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

