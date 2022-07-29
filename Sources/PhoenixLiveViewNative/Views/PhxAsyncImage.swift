//
//  PhxAsyncImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

struct PhxAsyncImage: View {
    private let url: URL?
    private let scale: Double?
    
    init<R: CustomRegistry>(element: Element, context: LiveContext<R>) {
        self.url = URL(string: try! element.attr("src"), relativeTo: context.url)
        if let attr = element.attrIfPresent("scale"),
           let f = Double(attr) {
            self.scale = f
        } else {
            self.scale = nil
        }
    }
    
    var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        AsyncImage(url: url, scale: scale ?? 1, transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    // when using an AsyncImage in the hero transition overlay, it never resolves to the actual image
                    // so when the source AsyncImage resolves, we use a preference to communicate the resulting
                    // Image up to the overlay view, in case it needs to be used
                    .preference(key: HeroViewOverrideKey.self, value: image.resizable())
            case .failure(let error):
                Text(error.localizedDescription)
            case .empty:
                ProgressView().progressViewStyle(.circular)
            @unknown default:
                EmptyView()
            }
        }
    }
}
