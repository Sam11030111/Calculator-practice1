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
    
    var btnColor: Color {
        switch self {
        case .divide, .multiply, .subtract, .add, .equal:
            return .black
        case .clear, .negative, .percent:
            return .white
        default:
            return .white
        }
    }
}

struct DarkButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80, alignment: .center)
            .background(
                DarkBackground(isTapped: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 40))
            )
    }
}

// DarkBackgroundButton and Shapes
struct DarkBackground<myShape: Shape>: View {
    var isTapped: Bool
    var shape: myShape

    var body: some View {
        ZStack {
            if isTapped {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
                      
                    .shadow(color: Color.darkStart, radius: 10, x: -5, y: -5)
                    .shadow(color: Color.darkEnd, radius: 5, x: -5, y: -5)
                
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

enum Operation: String {
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
    
    @State var currentOperation: Operation = .none
    @State var operationname = ""
    @State var runningNumber = 0
    @State var value = ""
    
    var body: some View {
        ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd).edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.screen)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 5)
                                .foregroundColor(.black)
                        }
                    
                    HStack {
                        Spacer()
                        Text("0")
                            .font(.custom("digital-7", size: 100))
                            .foregroundColor(.red)
                            .frame(height: 100)
                    }
                    .offset(x: -10, y: -15)
                    .padding(10)
                    
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 20))
                        Text(operationname)
                            .font(.custom("digital-7", size: 30))
                        Spacer()
                    }
                    .offset(x: 0, y: 110)
                    .padding(20)
                }
                .padding(15) // 上方長方形View
                               
                Spacer().frame(width: 0, height: 30)
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { btn in
                            Button {
                                self.didtap(btn: btn)
                            } label: {
                                Text(btn.rawValue)
                                    .bold()
                                    .font(.system(size: 30))
                                    .frame(width: btnWidth(), height: btnHeight())
                                    .foregroundColor(btn.btnColor)
                                    .background(Color.fire)
                                    .cornerRadius(btnWidth() / 2)
                            }
                            .buttonStyle(DarkButton())
                        }
                    }
                }
            }
        }
    }
    
    func btnWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
    
    func btnHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*20) / 4
    }
    
    func didtap(btn: CalculatButton) {
        switch btn {
        case .add, .subtract, .multiply, .divide, .equal:
            if btn == .add {
                self.operationname = "ADD"
            } else if btn == .subtract {
                self.operationname = "SUBTRACT"
            } else if btn == .multiply {
                self.operationname = "MULTIPLY"
            } else if btn == .divide {
                self.operationname = "DIVIDE"
            } else if btn == .equal {
                self.operationname = "EQUAL"
            }
        case .clear:
            self.operationname = "CLEAR"
        case .negative, .percent:
            break
        default:
            self.operationname = btn.rawValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: - Extension
extension Color {
    static let darkStart = Color(red: 255/255, green: 250/255, blue: 250/255)
    static let darkEnd = Color(red: 255/255, green: 222/255, blue: 173/255)
    static let fire = Color(red: 255/255, green: 127/255, blue: 36/255)
    static let screen = Color(red: 255/255, green: 225/255, blue: 255/255)
    static let number = Color(red: 139/255, green: 101/255, blue: 8/255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomTrailing)
    }
}



