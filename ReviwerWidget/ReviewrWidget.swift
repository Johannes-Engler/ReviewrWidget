//
//  ReviewrWidget.swift
//  ReviwerWidget
//
//  Created by Johannes Engler on 17.09.21.
//
import SwiftUI

public struct ReviewrWidget: View {
    @StateObject var renderedHeight = RenderedHeight()

    var asin: String?
    var baseUrl: String

    public init() {}
        
    public var body: some View {
        VStack {
        GeometryReader {
                    geometry in
            if let asin = self.asin {
                ReviewrWebView(url: URL(string: baseUrl + asin)!, width: geometry.size.width, renderedHeight: renderedHeight).frame(height: renderedHeight.height)
            }
        }
        }.frame(height: renderedHeight.height)
    }
}

class RenderedHeight: ObservableObject {
    @Published var height = CGFloat(0)
}
