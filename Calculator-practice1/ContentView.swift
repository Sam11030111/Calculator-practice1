//
//  ContentView.swift
//  Calculator-practice1
//
//  Created by 李竑陞 on 2023/3/6.
//

import SwiftUI

enum CalculatButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "A/C"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var btnColor: some View {
        switch self {
        case .clear:
            return LinearGradient(.orange)
        case .add, .subtract, .multiply, .divide, .equal:
            return LinearGradient(.black)
        default:
            return LinearGradient(.indigo, .black)
        }
    }
}

struct DarkButton: ButtonStyle {
    var btn: CalculatButton
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: btnWidth(item: btn), height: btnHeight(), alignment: .center)
            .background(
                ButtonBackground(isTapped: configuration.isPressed, shape: RoundedRectangle(cornerRadius: btnWidth(item: btn) / 2))
            )
    }
    
    func btnWidth(item: CalculatButton) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - 4*20) / 2
        }
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
    
    func btnHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
}

struct ButtonBackground<myshape: Shape>: View {
    var isTapped: Bool
    var shape: myshape
    
    var body: some View {
        ZStack {
            if isTapped {
                shape
                    .fill(LinearGradient(.black, .indigo))
                    .overlay(shape.stroke(LinearGradient(Color.black, .white), lineWidth: 2))
                    .shadow(color: Color.indigo, radius: 5, x: 1, y: 1)
                    .shadow(color: Color.black, radius: 5, x: -1, y: -1)
                
            } else {
                shape
                    .fill(LinearGradient(Color.white, Color.black))
                    .overlay(shape.stroke(LinearGradient(Color.white, Color.indigo), lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: -10, y: -10)
                    .shadow(color: Color.black, radius: 5, x: 5, y: 5)
            }
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    let buttons: [[CalculatButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    @State var value = "0"
    @State var operationname = ""
    @State var runningNumber = 0
    @State var currentOperation: Operation = .none
    
    var body: some View {
        ZStack {
            LinearGradient(.white, .indigo).ignoresSafeArea(.all)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 3).foregroundColor(.black)
                        }
                        .frame(height: 250)
                        .shadow(radius: 10, x: 5, y: 5)
                        .padding()
                    
                    HStack {
                        Spacer()
                        Text(value)
                            .font(.custom("digital-7", size: 80))
                    }
                    .offset(x: -20, y: -20)
                    .padding()
                    
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 20))
                        Text(operationname)
                            .font(.custom("digital-7", size: 30))
                        Spacer()
                    }
                    .offset(x: 0, y: 100)
                    .padding(30)
                    
                    
                }
                .padding(10)
                
                Spacer().frame(height: 30)
                
                ForEach(buttons, id: \.self) { rows in
                    HStack(spacing: 20) {
                        ForEach(rows, id: \.self) { btn in
                            Button {
                                self.btnTap(btn: btn)
                            } label: {
                                Text(btn.rawValue)
                                    .bold()
                                    .font(.system(size: 30))
                                    .frame(width: btnWidth(item: btn), height: btnHeight())
                                    .foregroundColor(.white)
                                    .background(btn.btnColor)
                                    .cornerRadius(btnWidth(item: btn) / 2)
                            }
                            .buttonStyle(DarkButton(btn: btn))
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
        }
    }
    
    func btnWidth(item: CalculatButton) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - 4*20) / 2
        }
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
    
    func btnHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
    
    func btnTap(btn: CalculatButton) {
        switch btn {
        case .add, .subtract, .multiply, .divide, .equal:
            if btn == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
                print("\(self.value)")
                self.operationname = "ADD"
            } else if btn == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
                self.operationname = "SUBTRACT"
            } else if btn == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
                self.operationname = "MULTIPLY"
            } else if btn == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
                self.operationname = "DIVIDE"
            } else if btn == .equal {
                let runningValue = self.runningNumber
                let currentValue = Int(self.value) ?? 0
                switch self.currentOperation {
                case .add:
                    self.value = "\(runningValue + currentValue)"
                case .subtract:
                    self.value = "\(runningValue - currentValue)"
                case .multiply:
                    self.value = "\(runningValue * currentValue)"
                case .divide:
                    self.value = "\(runningValue / currentValue)"
                case .none:
                    break
                }
                self.operationname = "EQUAL"
            }

            if btn != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
            self.operationname = "CLEAR"
        case .decimal, .negative, .percent:
            break
        default:
            let number = btn.rawValue
            if self.value == "0" {
                value = number
            } else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - Extension
extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomTrailing)
    }
}



