import SwiftUI

struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let scale = rect.width / 125
        let centerX = rect.size.width / 2
        let centerY = rect.size.height / 2
        let sixOclock = CGFloat(Double.pi / 2)

        path.addArc(center: CGPoint(x: centerX, y: centerY), radius: centerX, startAngle: .radians(sixOclock), endAngle: .radians(sixOclock * 8), clockwise: true)
        path.move(to: CGPoint(x: centerX - 23 * scale, y: centerY - 1 * scale))
        path.addLine(to: CGPoint(x: centerX - 6 * scale, y: centerY + 15.9 * scale))
        path.addLine(to: CGPoint(x: centerX + 22.8 * scale, y: centerY - 13.4 * scale))

        return path
    }
}

struct CheckmarkAnimation: View {
    @State private var checkViewAppear = false
    @State private var circleViewAppear = false

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Circle()
                    .trim(from: 0, to: circleViewAppear ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.white)
                    .animation(Animation.easeIn(duration: 0.4), value: circleViewAppear)
                    .frame(width: 65, height: 65)
                    .onAppear {
                        self.circleViewAppear.toggle()
                    }
                Checkmark()
                    .trim(from: 0, to: checkViewAppear ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 2.75, lineCap: .round))
                    .foregroundColor(.white)
                    .animation(Animation.easeIn(duration: 0.4).delay(0.5), value: checkViewAppear)
                    .aspectRatio(1, contentMode: .fit)
                    .onAppear {
                        self.checkViewAppear.toggle()
                    }
            }
        }
        .frame(width: 65, height: 65)
    }
}
