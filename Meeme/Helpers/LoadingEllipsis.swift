import SwiftUI

struct LoadingEllipsis: View {
    @State private var dotCount = 0

    let interval: TimeInterval

    var body: some View {
        let dots = String(repeating: ".", count: dotCount % 4)
        return Text("\(dots)")
            .transition(.opacity)
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    withAnimation {
                        self.dotCount += 1
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
    }
}
