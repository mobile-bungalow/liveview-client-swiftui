import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @ObservedElement var element: ElementNode
    let context: LiveContext<MyRegistry>
    @State var editedScore: Int?
    @State var width: CGFloat = 0
    
    var score: Int {
        if let str = element.attributeValue(for: "score"),
           let score = Int(str) {
            return score
        } else {
            return 0
        }
    }
    
    var effectiveScore: Int {
        editedScore ?? score
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<effectiveScore, id: \.self) { index in
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
            ForEach(effectiveScore..<5, id: \.self) { index in
                Image(systemName: "heart")
            }
        }
        .imageScale(.large)
    }
}
